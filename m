From: Jan Engelhardt <jengelh@medozas.de>
Subject: ulogd2: build fixes
Date: Wed,  2 Feb 2011 22:51:04 +0100
Message-ID: <1296683468-30413-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36964 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab1BBVvL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:51:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 4f652cc32aebeac20f46009f146ad973a1ed0e99:

  NFCT: fix bug in polling mode (2010-12-09 12:02:15 +0100)

are available in the git repository at:
  git://dev.medozas.de/ulogd2 master

Jan Engelhardt (3):
      build: avoid use of LIBS variable
      build: use appropriate location for program modules
      build: use compile/link information from pkgconfig

Pablo Neira Ayuso (1):
      ulogd: fix double call of stop for reused input plugins

 Makefile.am                   |    2 +-
 configure.ac                  |    5 ++-
 filter/Makefile.am            |   13 ++++++-----
 filter/raw2packet/Makefile.am |    2 +-
 include/ulogd/ulogd.h         |    2 +
 input/flow/Makefile.am        |    2 +-
 input/packet/Makefile.am      |    4 +-
 output/Makefile.am            |   15 +++++++------
 output/dbi/Makefile.am        |    4 +-
 output/mysql/Makefile.am      |    4 +-
 output/pcap/Makefile.am       |    4 +-
 output/pgsql/Makefile.am      |    4 +-
 output/sqlite3/Makefile.am    |    4 +-
 src/Makefile.am               |    1 +
 src/ulogd.c                   |   14 +++++++++++-
 ulogd.conf.in                 |   42 ++++++++++++++++++++--------------------
 16 files changed, 69 insertions(+), 53 deletions(-)
