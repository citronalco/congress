
#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import urllib.request
from typing import Dict
import pyotherside

class Congress():
    """
    The congress
    """

    def __init__(self, url: str, cfile: str = None):
        """
        Initialization: parse the congress data from url
        Args:
            url(str): the url of the congress data xml file
            cfile(str): cache file
        """

        with urllib.request.urlopen(url) as response:
            data = response.read()
            self._root = ET.fromstring(data)

        if cfile:
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
            params.append(param)

        params.sort(key=lambda r: r["date"], reverse=False)
        return params

    def get_event(self, event_id: int):
        """
        Return event data
        Args:
            event_id(int): id of the event to be returned
        """

        event = self._root.findall('day/room/event[@id="{0}"]'.format(event_id))[0]
        return event.attrib

class CongressHandler:
    def __init__(self):
        self.congress = Congress(
            'https://fahrplan.events.ccc.de/congress/2019/Fahrplan/schedule.xml'
        )

    def get_days(self):
        pyotherside.send("daysData", self.congress.get_days())

    def get_day(self, day: int):
        pyotherside.send("dayData", self.congress.get_day(day))

    def con_data(self):
        pyotherside.send("conData", self.congress.con_data())

    def get_event(self, event_id):
        pyotherside.send("eventData", self.congress.get_event(event_id))

congresshandler = CongressHandler()
