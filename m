From: Jan Engelhardt <jengelh@inai.de>
Subject: Documentation and a build fix
Date: Wed, 26 Dec 2012 00:11:16 +0100
Message-ID: <1356477089-13241-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:38892 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2LYXLd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:11:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit eec83c7ce4351359cae797840d63cf4ef2809c95:

  bump version to 1.4.17 (2012-12-25 13:38:36 +0100)

are available in the git repository at:

  git://git.inai.de/iptables master

for you to fetch changes up to 070e9ad8fe6380be3fe19924cd50619e540382d0:

  build: resolve link failure for ip6t_NETMAP (2012-12-26 00:00:11 +0100)

----------------------------------------------------------------
Jan Engelhardt (13):
      doc: add package version to all manpages
      doc: fixup omissions in ip6tables-restore.8
      doc: document iptables-restore's -t option
      doc: document iptables-restore's -v option
      doc: document iptables-restore's -M option
      doc: document iptables-restore's -h option
      doc: name the supported log levels for ipt_LOG
      src: remove faulty deprecated marker in libipt_LOG source
      iptables: fix order of internal commands list
      iptables: implement --line-numbers for iptables -S
      doc: mention -m in the manpage
      doc: document the -4 and -6 options
      build: resolve link failure for ip6t_NETMAP

 extensions/GNUmakefile.in                          |    3 +-
 extensions/libip6t_LOG.c                           |    2 +-
 extensions/libip6t_LOG.man                         |    5 ++-
 extensions/libipt_LOG.c                            |    2 +-
 extensions/libipt_LOG.man                          |    5 ++-
 include/ip6tables.h                                |    3 +-
 include/iptables.h                                 |    3 +-
 iptables/.gitignore                                |    5 ++-
 iptables/Makefile.am                               |   34 +++++++++++++++----
 ...{ip6tables-restore.8 => ip6tables-restore.8.in} |   22 ++++++++++--
 iptables/{ip6tables-save.8 => ip6tables-save.8.in} |    2 +-
 iptables/ip6tables-save.c                          |    2 +-
 iptables/ip6tables.8.in                            |   18 +++++++++-
 iptables/ip6tables.c                               |   35 +++++++++++---------
 iptables/{iptables-apply.8 => iptables-apply.8.in} |    2 +-
 iptables/iptables-extensions.8.in                  |    2 +-
 .../{iptables-restore.8 => iptables-restore.8.in}  |   20 +++++++++--
 iptables/{iptables-save.8 => iptables-save.8.in}   |    2 +-
 iptables/iptables-save.c                           |    2 +-
 iptables/{iptables-xml.1 => iptables-xml.1.in}     |    2 +-
 iptables/iptables.8.in                             |   18 +++++++++-
 iptables/iptables.c                                |   35 +++++++++++---------
 22 files changed, 161 insertions(+), 63 deletions(-)
 rename iptables/{ip6tables-restore.8 => ip6tables-restore.8.in} (72%)
 rename iptables/{ip6tables-save.8 => ip6tables-save.8.in} (96%)
 rename iptables/{iptables-apply.8 => iptables-apply.8.in} (95%)
 rename iptables/{iptables-restore.8 => iptables-restore.8.in} (71%)
 rename iptables/{iptables-save.8 => iptables-save.8.in} (96%)
 rename iptables/{iptables-xml.1 => iptables-xml.1.in} (97%)
