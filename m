From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: libiptc, cleanups
Date: Sun, 11 Sep 2011 17:35:49 +0200
Message-ID: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51842 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab1IKPgD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:36:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 62fc25fd1625f0f65b9eed3e15fe929dd0aff2c5:

  Merge branch 'master' of git://dev.medozas.de/iptables (2011-09-08 17:00:49 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (14):
      build: sort file list before build
      doc: fix undesired newline in ip6tables-restore(8)
      ip6tables-restore: implement missing -T option
      doc: document iptables-restore's -T option
      Merge branch 'stable'
      libiptc: resolve compile failure
      iptables-save: remove binary dumping dead code
      libiptc: remove unused HOOK_DROPPING thing
      libiptc: combine common types
      libiptc: replace ipt_chainlabel by xt_chainlabel
      libiptc: combine common types: _handle
      src: resolve old macro names that are indirections
      libiptc: use a family-invariant xtc_ops struct for code reduction
      ip6tables-restore: make code look alike with iptables-restore

 extensions/GNUmakefile.in       |   12 ++--
 extensions/libipt_realm.c       |   10 ++--
 include/Makefile.am             |    2 +-
 include/ip6tables.h             |   10 ++--
 include/iptables.h              |   16 +++---
 include/libiptc/libip6tc.h      |  110 +++++++++++++++++++-------------------
 include/libiptc/libiptc.h       |  110 +++++++++++++++++++-------------------
 include/libiptc/xtcshared.h     |   20 +++++++
 iptables/ip6tables-restore.8    |    4 +-
 iptables/ip6tables-restore.c    |   64 ++++++++++++----------
 iptables/ip6tables-save.c       |   84 ++++++++++++-----------------
 iptables/ip6tables-standalone.c |    2 +-
 iptables/ip6tables.c            |  112 +++++++++++++++++++-------------------
 iptables/iptables-restore.8     |    5 ++-
 iptables/iptables-restore.c     |   48 ++++++++--------
 iptables/iptables-save.c        |   84 ++++++++++++-----------------
 iptables/iptables-standalone.c  |    2 +-
 iptables/iptables-xml.c         |   36 ++++++------
 iptables/iptables.c             |  110 +++++++++++++++++++-------------------
 iptables/xshared.c              |    2 +-
 libiptc/Makefile.am             |    4 +-
 libiptc/libip4tc.c              |   56 +++++++------------
 libiptc/libip6tc.c              |   38 ++++++-------
 libiptc/libiptc.c               |   54 ++++++++++---------
 24 files changed, 495 insertions(+), 500 deletions(-)
 create mode 100644 include/libiptc/xtcshared.h
