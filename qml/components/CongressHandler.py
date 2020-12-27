#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import json
import urllib.request
import pyotherside
from pathlib import Path
import threading
import subprocess
import icalendar
from datetime import datetime, timedelta

SCHED = "https://fahrplan.events.ccc.de/rc3/2020/Fahrplan/schedule.xml"
SPKS = "https://fahrplan.events.ccc.de/rc3/2020/Fahrplan/speakers.json"
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
        cache: str,
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

        self._cache = Path(cache)
        self._cache.mkdir(parents=True, exist_ok=True)
        sched_cfile = cache / Path('sched.xml')
        spk_cfile = cache / Path('spk.json')
        vid_cfile = cache / Path('vid.xml')

        if sched_cfile.exists():
            with sched_cfile.open('rb') as schedhandler:
                data = schedhandler.read()
                self._root = ET.fromstring(data)
        else:
            with urllib.request.urlopen(sched_url) as response:
                data = response.read()
                self._root = ET.fromstring(data)

                with sched_cfile.open("wb") as out_file:
                    out_file.write(data)

        if spk_cfile.exists():
            with spk_cfile.open('rb') as spkhandler:
                data = spkhandler.read()
                self._spk = json.loads(data.decode("utf-8"))
        else:
            with urllib.request.urlopen(spk_url) as response:
                data = response.read()
                self._spk = json.loads(data.decode("utf-8"))
                with spk_cfile.open("wb") as out_file:
                    out_file.write(data)

        self._speakers = self._spk["schedule_speakers"]["speakers"]
        self._speakers.sort(
            key=lambda r: r["public_name"].lstrip().lower(), reverse=False
        )

        if vid_cfile.exists():
            with vid_cfile.open('rb') as vidhandler:
                data = vidhandler.read()
                self._vids = ET.fromstring(data)
        else:
            with urllib.request.urlopen(vid_url) as response:
                data = response.read()
                self._vids = ET.fromstring(data)
                with vid_cfile.open("wb") as out_file:
                    out_file.write(data)

        self._vidpath = ""

    def set_vid_path(self, vidpath):
        """
        Set the video path
        """

        self._vidpath = vidpath

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
            vp = Path(self._vidpath) / Path("{0}.webm".format(event_id))
            if vp.exists():
                url = "file://" + vp.as_posix()
                pyotherside.send("video already downloaded. Path: " + url)
        else:
            url = ""
        return url

    def delete_video(self, event_id: int):
        """
        Delete downloaded Video
        Args:
            event_id(int): the event_id of the video
        """

        vp = Path(self._vidpath) / Path("{0}.webm".format(event_id))
        vp.unlink()
        pyotherside.send("videoDeleted", event_id)

    def get_downloaded_vids(self):
        """
        return an event list of all downloaded videos
        """

        if self._vidpath == "":
            return []

        vp = Path(self._vidpath)

        events = []
        for f in vp.iterdir():
            if f.suffix == '.webm':
                event = self._root.findall(
                    'day/room/event[@id="{0}"]'.format(f.stem))[0]
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
                events.append(param)

        events.sort(key=lambda r: r["track"], reverse=False)
        return events

    def load_vid(self, event_id: int, url: int):
        """
        Load video
        Args:
            event_id: id of the event
            url: url of the video
            vidpath: path of the video file to be stored
        """

        if self._vidpath == "":
            pyotherside.send("noVidPath")
            return

        vp = Path(self._vidpath)
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
                        pyotherside.send("vidPercent", event_id, p1)

            filetmp.rename(filepath)

        pyotherside.send("vidPath", "file://" + filepath.as_posix())

    def open_ical(self, event_id: int):
        """
        Load video
        Args:
            event_id: id of the event
        """
        filetmp = Path("/tmp/" + str(event_id) + ".ics")

        if not filetmp.is_file():
            fhandle = open(filetmp, "wb")
            fhandle.write(self.gen_ics(event_id))
            fhandle.close()

        subprocess.run(["/usr/bin/xdg-open", filetmp])

    def gen_ics(self, event_id: int):
        """
        Return event calendar data
        Args:
            event_id(int): id of the event to be returned
        """

        calendar = icalendar.Calendar()
        calendar.add("proid", "-//Congress Sailfish app")
        calendar.add("version", "2.0")

        event = self.get_event(event_id)
        event_start = datetime.fromisoformat(event["date"])
        event_duration_parts = event["duration"].split(":")
        event_duration = timedelta(
            hours=int(event_duration_parts[0]),
            minutes=int(event_duration_parts[1])
        )
        cal_event = icalendar.Event()
        cal_event.add("summary", event["title"])
        cal_event.add("description", event["abstract"])
        cal_event.add("dtstart", event_start)
        cal_event.add("dtend", event_start + event_duration)
        cal_event.add("url", event["url"])
        cal_event.add("location", event["room"])

        calendar.add_component(cal_event)
        return calendar.to_ical()

    def play_vid(self, vidurl):
        """
        Start the sailfish-os browser for playing a video
        Args:
            vidurl(str): the url to be shown
        """

        subprocess.run(["/usr/bin/sailfish-browser", vidurl])

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
        self.bgthread = threading.Thread()
        self.bgthread.start()

    def init(self, cache):
        self.congress = Congress(SCHED, SPKS, VIDS, cache)

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

    def load_vid(self, event_id, url):
        dlthread = threading.Thread(target=self.congress.load_vid,
                                    args=[event_id, url])
        dlthread.start()

    def get_vids(self):
        pyotherside.send("dayData", self.congress.get_downloaded_vids())

    def set_vidpath(self, vidpath):
        self.congress.set_vid_path(vidpath)

    def play_vid(self, vidurl):
        dlthread = threading.Thread(target=self.congress.play_vid,
                                    args=[vidurl])
        dlthread.start()

    def delete_video(self, event_id):
        self.congress.delete_video(event_id)

    def open_ical(self, event_id):
        self.congress.open_ical(event_id)


congresshandler = CongressHandler()
