From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfnetlink patches
Date: Sat, 30 Jul 2011 21:11:00 +0200
Message-ID: <1312053064-2153-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36862 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab1G3TLI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:11:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit a82107933da41572428b8c882d77c10267cbcef9:

  src: BAD_SIZEOF (2011-06-13 19:53:17 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnfnetlink master

Jan Engelhardt (3):
      build: remove unused LIBTOOL_DEPS
      build: use -Wall across the entire source
      utils: resolve compiler warning

 Make_global.am  |    1 +
 configure.ac    |    1 -
 src/Makefile.am |    2 --
 utils/iftest.c  |    3 ++-
 4 files changed, 3 insertions(+), 4 deletions(-)
