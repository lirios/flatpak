#
# This file is part of Liri.
#
# Copyright (C) 2018 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# $BEGIN_LICENSE:GPL3+$
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# $END_LICENSE$
#

import sys
import subprocess

__all__ = (
    'command',
)


def command(cmd, echo=False, output=False):
    """
    Execute a command and return the output.
    :param cmd: List of command parameters.
    :return: Output.
    """
    if echo:
        print('Executing: {}'.format(subprocess.list2cmdline(cmd)))
    if output is True:
        return subprocess.run(cmd, stdout=sys.stdout, stderr=sys.stderr)
    else:
        return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=sys.stdout.buffer)
