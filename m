From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl build system patches
Date: Tue, 19 Oct 2010 12:47:31 +0200
Message-ID: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44384 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152Ab0JSKro (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit e7fa7219245809491fedfd9efcbe50b6c839f734:

  add quote from Thoureau to documentation (2010-10-10 13:53:22 +0200)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (10):
      build: just use autoreconf
      build: do not abuse AM_INIT_AUTOMAKE for autoconf options
      build: automake options should be in AM_INIT_AUTOMAKE
      build: use subdir-objects and CC_C_O
      build: run autoupdate
      build: rebuild .pc files when configure status changed
      build: resolve compiler warnings
      build: remove unneeded -dynamic -ldl -nostartfiles flags
      build: default to not build static libraries
      Add .gitignore files

 .gitignore                     |   23 +++++++++++++++++++++++
 Make_global.am                 |    2 +-
 Makefile.am                    |    3 ++-
 autogen.sh                     |   18 ++----------------
 configure.ac                   |   21 +++++++++++++++++++++
 configure.in                   |   18 ------------------
 examples/genl/.gitignore       |    1 +
 examples/genl/Makefile.am      |    1 -
 examples/netfilter/.gitignore  |    2 ++
 examples/netfilter/Makefile.am |    2 --
 examples/rtnl/.gitignore       |    7 +++++++
 examples/rtnl/Makefile.am      |    7 -------
 src/Makefile.am                |    4 +---
 src/nlmsg.c                    |    2 +-
 14 files changed, 61 insertions(+), 50 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 configure.ac
 delete mode 100644 configure.in
 create mode 100644 examples/genl/.gitignore
 create mode 100644 examples/netfilter/.gitignore
 create mode 100644 examples/rtnl/.gitignore
