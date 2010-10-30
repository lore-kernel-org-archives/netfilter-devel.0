From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_log: build system cleanups
Date: Sun, 31 Oct 2010 00:09:48 +0200
Message-ID: <1288476600-29859-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49895 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab0J3WKC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:10:02 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 8d6a60cb89ebd330156e594456034e49a324a56e:

  license: upgrade to GPLv2+ (2010-10-29 20:35:43 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_log master

Jan Engelhardt (11):
      build: use autoconf-suggested naming of files
      build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
      build: avoid use of deprecated INCLUDES
      build: use simpler autoreconf in autogen
      build: run AC_CANONICAL_HOST only
      build: remove statements without effect
      build: remove -fPIC flag
      build: no need for error message in PKG_CHECK_MODULES
      build: set Libs.private for pkgconfig file
      Remove accidentally-added file "depcomp"
      Add .gitignore files

 .gitignore                   |   20 ++
 Makefile.am                  |    8 +-
 autogen.sh                   |   20 +--
 configure.in => configure.ac |   18 +--
 depcomp                      |  479 ------------------------------------------
 libnetfilter_log.pc.in       |    1 +
 src/Makefile.am              |    6 +-
 utils/.gitignore             |    2 +
 utils/Makefile.am            |    2 +-
 9 files changed, 36 insertions(+), 520 deletions(-)
 create mode 100644 .gitignore
 rename configure.in => configure.ac (52%)
 delete mode 100755 depcomp
 create mode 100644 utils/.gitignore
