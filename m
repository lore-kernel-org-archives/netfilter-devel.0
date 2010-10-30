From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfnetlink: build system cleanup
Date: Sun, 31 Oct 2010 00:07:24 +0200
Message-ID: <1288476454-18451-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46280 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab0J3WHh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:07:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 54c8cf1853e97dcaa974c9f44297f94619f1d880:

  iftable: fix wrong handler unregistration on error (2010-09-30 13:23:07 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnfnetlink master

Jan Engelhardt (9):
      build: use autoconf-suggested naming of files
      build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
      build: avoid use of deprecated INCLUDES
      build: use simpler autoreconf in autogen
      build: use AC_CONFIG_MACRO_DIR as directed
      build: run AC_CANONICAL_HOST only
      build: remove statements without effect
      build: remove -fPIC flag
      Add .gitignore files

 .gitignore                   |   19 +++++++++++++++++++
 Make_global.am               |    2 +-
 Makefile.am                  |    6 +-----
 autogen.sh                   |   20 +++-----------------
 configure.in => configure.ac |    8 ++++----
 m4/.gitignore                |    2 ++
 src/Makefile.am              |    3 +--
 utils/.gitignore             |    1 +
 8 files changed, 32 insertions(+), 29 deletions(-)
 create mode 100644 .gitignore
 rename configure.in => configure.ac (77%)
 create mode 100644 m4/.gitignore
 create mode 100644 utils/.gitignore
