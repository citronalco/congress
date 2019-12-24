
#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import json
import urllib.request
from typing import Dict
import pyotherside

class Congress():
    """
    The congress
    """

    def __init__(self, sched_url: str, spk_url: str,
                 sched_cfile: str = None, spk_cfile: str = None):
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
            with open(cfile, 'wb') as out_file:
                out_file.write(self._root)

        with urllib.request.urlopen(spk_url) as response:
            data = response.read()
            self._spk = json.loads(data.decode("utf-8"))

        self._speakers = self._spk['schedule_speakers']['speakers']
        self._speakers.sort(key=lambda r: r['public_name'].lstrip(), reverse=False)

        if spk_cfile:
            with open(cfile, 'wb') as out_file:
                out_file.write(data)

    def con_data(self):
        """
        Congress data
        """

        conference = self._root.find('conference')
        params = {}
        for element in conference.getchildren():
            params[element.tag] = element.text

        return params

    def get_days(self):
        """
        Return Days
        """

        days = []

        for day in self._root.iter('day'):
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
        for event in daydata.iterfind('room/event'):
            param = event.attrib
            param["eventid"] = param["id"]
            for element in event.getchildren():
                param[element.tag] = element.text
            p = ""
            for person in event.findall('persons')[0]:
                if p != "":
                    p += ", "
                p += person.text
            param['persons'] = p
            params.append(param)

        params.sort(key=lambda r: r["date"], reverse=False)
        return params

    def get_speakers(self):
        """
        Return speakers list data
        """

        return self._speakers

    def get_event(self, event_id: int):
        """
        Return event data
        Args:
            event_id(int): id of the event to be returned
        """

        p = ""
        event = self._root.findall('day/room/event[@id="{0}"]'.format(event_id))[0]
        persons = event.findall('persons')[0]
        for person in persons:
            if p != "":
                p += ", "
            p += person.text
        ret = event.attrib
        ret['persons'] = p
        return ret

class CongressHandler:
    def __init__(self):
        self.congress = Congress(
            'https://fahrplan.events.ccc.de/congress/2019/Fahrplan/schedule.xml',
            'https://fahrplan.events.ccc.de/congress/2019/Fahrplan/speakers.json'
        )

    def get_days(self):
        pyotherside.send("daysData", self.congress.get_days())

    def get_day(self, day: int):
        pyotherside.send("dayData", self.congress.get_day(day))

    def get_speakers(self):
        pyotherside.send("speakersData", self.congress.get_speakers())

    def con_data(self):
        pyotherside.send("conData", self.congress.con_data())

    def get_event(self, event_id):
        pyotherside.send("eventData", self.congress.get_event(event_id))

congresshandler = CongressHandler()
