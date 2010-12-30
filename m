From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfnetlink: build improvements
Date: Fri, 31 Dec 2010 00:40:05 +0100
Message-ID: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50193 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0L3XkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:40:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit ba37f0a01d83d0884a423971b329fb003aa4d196:

  Merge branch 'master' of git://dev.medozas.de/libnfnetlink (2010-12-21 20:31:21 +0100)

are available in the git repository at:

  git://dev.medozas.de/libnfnetlink master

Jan Engelhardt (5):
      build: remove unused LIBTOOL_DEPS
      build: use -Wall across the entire source
      utils: resolve compiler warning
      build: implement export symbols
      src: remove redundant cast near msg_name

 .gitignore            |    1 +
 Make_global.am        |    1 +
 configure.ac          |    3 +-
 m4/gcc4_visibility.m4 |   21 +++++++
 src/Makefile.am       |    2 -
 src/iftable.c         |   23 ++++----
 src/internal.h        |   12 ++++
 src/libnfnetlink.c    |  161 ++++++++++++++++++++++++++++---------------------
 utils/iftest.c        |    3 +-
 9 files changed, 143 insertions(+), 84 deletions(-)
 create mode 100644 m4/gcc4_visibility.m4
 create mode 100644 src/internal.h
