From: Jan Engelhardt <jengelh@medozas.de>
Subject: conntrack-tools: build system cleanups
Date: Sun, 31 Oct 2010 00:49:34 +0200
Message-ID: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44503 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0J3Wtp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 31ae56a2af1381459e4ec38c31ab810ffa410cf9:

  conntrack: allow to listen to all kind of expectation events (2010-10-12 12:56:01 +0200)

are available in the git repository at:
  git://dev.medozas.de/conntrack-tools master

Jan Engelhardt (7):
      build: use autoconf-suggested naming of files
      build: use modern call syntax for AM_INIT_AUTOMAKE
      build: drop unused $(all_includes)
      build: remove statements without effect
      build: remove unused $(all_libraries)
      build: no need for error message in PKG_CHECK_MODULES
      Add .gitignore files

 .gitignore                   |   18 ++++++++++++++++++
 Make_global.am               |    5 +++--
 Makefile.am                  |    7 -------
 configure.in => configure.ac |   31 +++++--------------------------
 src/.gitignore               |    6 ++++++
 src/Makefile.am              |    5 ++---
 6 files changed, 34 insertions(+), 38 deletions(-)
 create mode 100644 .gitignore
 rename configure.in => configure.ac (75%)
 create mode 100644 src/.gitignore
