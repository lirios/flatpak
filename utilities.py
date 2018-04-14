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
import shlex
import subprocess

__all__ = (
    'command',
    'prepare',
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


def prepare(src_filename, dst_filename, metadata):
    """
    Rewrite `src_filename` expanding parameters and writing `dst_filename`.
    :param src_filename: Path to the source file.
    :param dst_filename: Path to the destination file.
    :param metadata: Dictionary with app name and version.
    :return: Path to the new file.
    """
    import tempfile
    with open(src_filename, 'r') as f:
        dst = open(dst_filename, 'w')
        for line in f:
            s = line.replace(r'@@APP_BRANCH@@', metadata['version']).replace(r'@@GIT_TAG@@', metadata['tag']).replace(r'@@LIRI_SDK_VERSION@@', metadata['sdk-version'])
            dst.write(s)
        dst.close()

# Copyright 2016 Colin Walters <walters@verbum.org>
# Licensed under the new-BSD license (http://www.opensource.org/licenses/bsd-license.php)
def rsync(src_path, dest_url, rsync_opts, rsync_opt):
    """
    Synchronize OSTree repository.
    :param src_path: Repository path.
    :param dest_url: Destination URL.
    :param rsync_opts: Rsync options.
    :param rsync_opt: Single rsync option.
    """
    OBJECTS_AND_DELTAS = ['/objects', '/objects/**', '/deltas', '/deltas/**']
    # We rsync in reverse data dependence order - the summary and refs
    # point to objects + deltas.  Our first pass over the objects doesn't
    # perform any deletions, as that would create race conditions.  We
    # do handle deletions for refs and summary.
    # Finally, we handle any deletions for objects and deltas.
    RSYNC_ORDERING = [(OBJECTS_AND_DELTAS, ['--ignore-existing']),
                      (['/refs', '/refs/**', '/summary', '/summary.sig'], ['--delete', '--ignore-missing-args']),
                      (OBJECTS_AND_DELTAS, ['--ignore-existing', '--delete'])]

    for (paths, opts) in RSYNC_ORDERING:
        argv = ['rsync', '-rlpt', '--info=progress2']
        for path in paths:
            argv.append('--include=' + path)
        argv.extend(['--exclude=*', src_path, dest_url])
        argv.extend(opts)
        if rsync_opts is not None:
            argv.extend(shlex.split(rsync_opts))
        argv.extend(rsync_opt)
        print("Executing: {}".format(subprocess.list2cmdline(argv)))
        subprocess.check_call(argv)
