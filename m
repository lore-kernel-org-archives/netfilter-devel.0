From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_conntrack autotools updates
Date: Thu,  9 Sep 2010 01:32:35 +0200
Message-ID: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48402 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab0IHXcp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:32:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Pablo,

I have here a few commits that update the autotools files to resolve
autotools warnings, use more "modern" constructs, and to shorten them
a little. There is also a gitignore added. Please consider applying.

fatal: The remote end hung up unexpectedly
warn: No branch of git://dev.medozas.de/libnetfilter_conntrack is at:
warn:   a9f46ea: Add .gitignore
warn: Are you sure you pushed master there?


The following changes since commit 107d52d3e6bf116314321e6ed7acf2a2cd1c6b34:

  build: bump version to 0.9.0 (2010-09-08 11:16:57 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_conntrack ..BRANCH.NOT.VERIFIED..

Jan Engelhardt (7):
      build: use autoconf-suggested naming of files
      build: use modern call syntax for AC_INIT, AM_INIT_AUTOMAKE
      build: avoid use of deprecated INCLUDES
      build: use simpler autoreconf in autogen
      build: run AC_CANONICAL_HOST only
      build: no need for error message in PKG_CHECK_MODULES
      Add .gitignore

 .gitignore                   |   20 ++++++++++++++++++++
 Make_global.am               |    2 +-
 Makefile.am                  |    2 --
 autogen.sh                   |    6 +-----
 configure.in => configure.ac |   13 +++++--------
 5 files changed, 27 insertions(+), 16 deletions(-)
 create mode 100644 .gitignore
 rename configure.in => configure.ac (87%)
