From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_queue: build system cleanups
Date: Sun, 31 Oct 2010 00:11:05 +0200
Message-ID: <1288476676-32749-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49954 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab0J3WLS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:11:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 9ae213ed891556bde865b81b959e76c36461bc9e:

  nfq: fix redundant LIBVERSION definition (2010-07-15 11:12:30 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_queue master

Jan Engelhardt (10):
      build: build: use autoconf-suggested naming of files
      build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
      build: avoid use of deprecated INCLUDES
      build: use simpler autoreconf in autogen
      build: run AC_CANONICAL_HOST only
      build: no need for error message in PKG_CHECK_MODULES
      build: set Libs.private for pkgconfig file
      build: remove statements without effect
      build: remove -fPIC flag
      Update .gitignore

 .gitignore                   |   33 ++++++++++++++++++---------------
 Makefile.am                  |    6 ------
 autogen.sh                   |   20 +++-----------------
 configure.in => configure.ac |   18 +++++-------------
 libnetfilter_queue.pc.in     |    1 +
 src/Makefile.am              |    6 +++---
 utils/.gitignore             |    1 +
 utils/Makefile.am            |    2 +-
 8 files changed, 32 insertions(+), 55 deletions(-)
 rename configure.in => configure.ac (52%)
 create mode 100644 utils/.gitignore
