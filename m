From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset-5 build patches
Date: Tue, 19 Oct 2010 18:12:13 +0200
Message-ID: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53561 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab0JSQM1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 1b8c69e14d97bf5d0e973740c5802fdbf96f756d:

  Compatibility and documentation fixes (2010-07-13 14:18:22 +0200)

are available in the git repository at:
  git://dev.medozas.de/ipset ipset-5

Jan Engelhardt (8):
      build: just use autoreconf
      build: resolve autoreconf/libtoolize suggestions
      build: add separate option for kernel source directory
      build: use libmnl's pkgconfig files
      build: remove manual -fPIC flag
      build: use subdir-objects and CC_C_O
      build: run autoupdate
      Add .gitignore files

 .gitignore      |   20 ++++++++++++++++++++
 Makefile.am     |    2 ++
 autogen.sh      |   18 ++----------------
 configure.ac    |   36 ++++++++++++++++++++----------------
 lib/Makefile.am |    4 ++--
 m4/.gitignore   |    2 ++
 src/.gitignore  |    1 +
 7 files changed, 49 insertions(+), 34 deletions(-)
 create mode 100644 .gitignore
 create mode 100644 m4/.gitignore
 create mode 100644 src/.gitignore
