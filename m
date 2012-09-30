From: Jan Engelhardt <jengelh@inai.de>
Subject: Mostly documentation fixes
Date: Sun, 30 Sep 2012 12:22:03 +0200
Message-ID: <1349000540-17508-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38807 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2I3KW0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:22:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


It was that time of the year again to process reports from the
Debian bug tracking system. :)

===
The following changes since commit 0d701631625898ac33fb53c67ed2b529668fe0d7:

  libxt_state: replace as an alias to xt_conntrack (2012-09-30 11:21:25 +0200)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to 6cf011116fc4752cde75eabe3b1b3f2a93ae27bd:

  src: remove faulty deprecated marker in libipt_LOG source (2012-09-30 12:17:31 +0200)

----------------------------------------------------------------
Jan Engelhardt (17):
      doc: clean up interpunction in state list for xt_conntrack
      doc: deduplicate extension descriptions into a new manpage
      doc: trim "state" manpage and reference conntrack instead
      doc: have NOTRACK manpage point to CT instead
      doc: mention iptables-apply in the SEE ALSO sections
      iptables: fix order of internal commands list
      iptables: implement --line-numbers for iptables -S
      iptables-restore: kill unused -b option
      doc: rename .8.in files to .8in
      doc: add package version to all manpages
      doc: fixup omissions in ip6tables-restore.8
      doc: document iptables-restore's -t option
      doc: document iptables-restore's -v option
      doc: document iptables-restore's -M option
      doc: document iptables-restore's -h option
      doc: name the supported log levels for ipt_LOG
      src: remove faulty deprecated marker in libipt_LOG source

 extensions/.gitignore                              |    4 +--
 extensions/GNUmakefile.in                          |   35 +++++++++-----------
 extensions/libip6t_LOG.c                           |    2 +-
 extensions/libip6t_LOG.man                         |    5 ++-
 extensions/libipt_LOG.c                            |    2 +-
 extensions/libipt_LOG.man                          |    5 ++-
 extensions/libxt_HMARK.man                         |    2 +-
 extensions/libxt_NOTRACK.man                       |    6 ++--
 extensions/libxt_conntrack.man                     |   18 +++++-----
 extensions/libxt_state.man                         |   28 ++++------------
 include/ip6tables.h                                |    3 +-
 include/iptables.h                                 |    3 +-
 iptables/.gitignore                                |    3 +-
 iptables/Makefile.am                               |   13 +++++---
 .../{ip6tables-restore.8 => ip6tables-restore.8in} |   22 ++++++++++--
 iptables/ip6tables-restore.c                       |   11 ++----
 iptables/{ip6tables-save.8 => ip6tables-save.8in}  |    2 +-
 iptables/ip6tables-save.c                          |    2 +-
 iptables/{ip6tables.8.in => ip6tables.8in}         |   23 +++----------
 iptables/ip6tables.c                               |   35 +++++++++++---------
 iptables/{iptables-apply.8 => iptables-apply.8in}  |    4 +--
 iptables/iptables-extensions.8in                   |   27 +++++++++++++++
 .../{iptables-restore.8 => iptables-restore.8in}   |   20 +++++++++--
 iptables/iptables-restore.c                        |   11 ++----
 iptables/{iptables-save.8 => iptables-save.8in}    |    2 +-
 iptables/iptables-save.c                           |    2 +-
 iptables/{iptables.8.in => iptables.8in}           |   25 ++++----------
 iptables/iptables.c                                |   35 +++++++++++---------
 28 files changed, 182 insertions(+), 168 deletions(-)
 rename iptables/{ip6tables-restore.8 => ip6tables-restore.8in} (72%)
 rename iptables/{ip6tables-save.8 => ip6tables-save.8in} (96%)
 rename iptables/{ip6tables.8.in => ip6tables.8in} (95%)
 rename iptables/{iptables-apply.8 => iptables-apply.8in} (91%)
 create mode 100644 iptables/iptables-extensions.8in
 rename iptables/{iptables-restore.8 => iptables-restore.8in} (71%)
 rename iptables/{iptables-save.8 => iptables-save.8in} (96%)
 rename iptables/{iptables.8.in => iptables.8in} (95%)
