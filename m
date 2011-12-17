From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: build updates
Date: Sat, 17 Dec 2011 16:35:02 +0100
Message-ID: <1324136109-31504-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59366 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1LQPfQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 7c061f216ee04a8df5f49521b146f4a274b5f1ac:

  ipset 6.10 released (2011-11-25 09:36:04 +0100)

are available in the git repository at:
  git://dev.medozas.de/ipset master

Jan Engelhardt (6):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      build: process include/libipset/
      build: include libipset/nfproto.h
      build: install libipset/linux_ip_set_list.h
      build: make distcheck work and use POSIX mode for tarball generation

 .gitignore                   |   12 ++++--------
 Makefile.am                  |    4 +++-
 configure.ac                 |    5 +++--
 include/Makefile.am          |    1 -
 include/libipset/Makefile.am |    7 +++++--
 src/Makefile.am              |    2 +-
 6 files changed, 16 insertions(+), 15 deletions(-)
 delete mode 100644 include/Makefile.am
