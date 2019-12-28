#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import json
import urllib.request
import pyotherside
from pathlib import Path
import threading


SCHED = "https://fahrplan.events.ccc.de/congress/2019/Fahrplan/schedule.xml"
SPKS = "https://fahrplan.events.ccc.de/congress/2019/Fahrplan/speakers.json"
VIDS = "https://media.ccc.de/c/36c3/podcast/webm-hq.xml"


class Congress:
    """
    The congress
    """

    def __init__(
        self,
        sched_url: str,
        spk_url: str,
        vid_url: str,
        sched_cfile: str = None,
        spk_cfile: str = None,
        vid_cfile: str = None,
    ):
        """
        Initialization: parse the congress data from url
        Args:
            sched_url(str): the url of the congress data xml file
            spk_url(str): the url of the speaker data json file
            cfile(str): cache file
        """

        with urllib.request.urlopen(sched_url) as response:
            data = response.read()
            self._root = ET.fromstring(data)

        if sched_cfile:
            with open(sched_cfile, "wb") as out_file:
                out_file.write(self._root)

        with urllib.request.urlopen(spk_url) as response:
            data = response.read()
            self._spk = json.loads(data.decode("utf-8"))

        self._speakers = self._spk["schedule_speakers"]["speakers"]
        self._speakers.sort(
            key=lambda r: r["public_name"].lstrip().lower(), reverse=False
        )

        if spk_cfile:
            with open(spk_cfile, "wb") as out_file:
                out_file.write(data)

        with urllib.request.urlopen(vid_url) as response:
            data = response.read()
            self._vids = ET.fromstring(data)

        if vid_cfile:
            with open(vid_cfile, "wb") as out_file:
                out_file.write(self._vids)

    def con_data(self):
        """
        Congress data
        """

        conference = self._root.find("conference")
        params = {}
        for element in conference.getchildren():
            params[element.tag] = element.text

        return params

    def get_days(self):
        """
        Return Days
        """

        days = []

        for day in self._root.iter("day"):
            days.append(day.attrib)

        return days

    def get_day(self, day: int):
        """
        Return day data
        Args:
            day(int): day number (0 starting)
        """

        params = []
        daydata = self._root.findall('day[@index="{0}"]'.format(day))[0]
        for event in daydata.iterfind("room/event"):
            param = event.attrib
            param["eventid"] = param["id"]
            for element in event.getchildren():
                param[element.tag] = element.text
            p = ""
            for person in event.findall("persons")[0]:
                if p != "":
                    p += ", "
                p += person.text
                param["vidurl"] = self.get_vid(param["id"])

            param["persons"] = p
            params.append(param)

        params.sort(key=lambda r: r["date"], reverse=False)
        return params

    def get_speakers(self):
        """
        Return speakers list data
        """

        return self._speakers

    def get_speaker(self, speaker_id: str):
        """
        Get speaker information
        Args:
            speaker_id(str): Id of the speaker
        """

        speaker = [obj for obj in self._speakers if obj["id"] == speaker_id][0]

        evs = speaker["events"]
        params = []

        for ev in evs:
            event = self._root.findall(
                'day/room/event[@id="{0}"]'.format(ev["id"]))[0]
            param = event.attrib
            param["eventid"] = param["id"]
            for element in event.getchildren():
                param[element.tag] = element.text
            p = ""
            for person in event.findall("persons")[0]:
                if p != "":
                    p += ", "
                p += person.text
            param["persons"] = p
            param["vidurl"] = self.get_vid(param["id"])
            params.append(param)
        params.sort(key=lambda r: r["date"], reverse=False)
        speaker["events"] = params
        return speaker

    def get_vid(self, event_id: int):
        """
        Return the video url if exists for event_id
        """

        channel = self._vids.find("channel")
        items = channel.findall("item")

        videncs = [
            obj
            for obj in items
            if "{0}".format(event_id)
            in obj.findall(
                "{http://www.itunes.com/dtds/podcast-1.0.dtd}keywords")[
                0
            ].text
        ]
        if len(videncs) > 0:
            enc = videncs[0].find('enclosure')
            url = enc.attrib["url"]
        else:
            url = ""
        return url

    def load_vid(self, event_id: int, url: int, vidpath: str):
        """
        Load video
        Args:
            event_id: id of the event
            url: url of the video
            vidpath: path of the video file to be stored
        """

        v = Path(vidpath)
        vp = v / 'congress'
        vp.mkdir(parents=True, exist_ok=True)

        filepath = vp / Path(str(event_id) + '.webm')
        filetmp = vp / Path(str(event_id) + '.webm.part')

        if not filepath.is_file():
            pyotherside.send("load_vid: Need to download " + url)
            req = urllib.request.Request(url, data=None)
            try:
                h = urllib.request.urlopen(req)
            except urllib.error.HTTPerror as e:
                if hasattr(e, "reason"):
                    pyotherside.send("apperror",
                                     "Error opening URL: " + e.reason)
                return
            length = int(h.getheader("content-length"))

            count = 0
            p1 = 0
            with open(filetmp, "wb") as fhandle:
                while True:
                    chunk = h.read(1024)
                    if not chunk:
                        break
                    count += 1024
                    fhandle.write(chunk)
                    p2 = int(count / length * 100)
                    if p2 > p1:
                        p1 = p2
                        pyotherside.send("vidPercent", p1)

            filetmp.rename(filepath)

        pyotherside.send("vidPath", filepath.as_posix())

    def get_event(self, event_id: int):
        """
        Return event data
        Args:
            event_id(int): id of the event to be returned
        """

        p = ""
        event = self._root.findall(
            'day/room/event[@id="{0}"]'.format(event_id))[0]
        persons = event.findall("persons")[0]
        for person in persons:
            if p != "":
                p += ", "
            p += person.text
        ret = event.attrib
        ret["persons"] = p
        ret["vidurl"] = self.get_vid(event_id)
        return ret


class CongressHandler:
    def __init__(self):
        self.congress = Congress(SCHED, SPKS, VIDS)
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def get_days(self):
        pyotherside.send("daysData", self.congress.get_days())

    def get_day(self, day: int):
        pyotherside.send("dayData", self.congress.get_day(day))

    def get_speakers(self):
        pyotherside.send("speakersData", self.congress.get_speakers())

    def get_speaker(self, speakerid):
        pyotherside.send("speakerData",
                         self.congress.get_speaker(int(speakerid)))

    def con_data(self):
        pyotherside.send("conData", self.congress.con_data())

    def get_event(self, event_id):
        pyotherside.send("eventData", self.congress.get_event(event_id))

    def load_vid(self, event_id, url, vidpath):
        self.congress.load_vid(event_id, url, vidpath)


congresshandler = CongressHandler()
