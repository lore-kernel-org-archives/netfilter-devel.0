From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_acct: build updates
Date: Thu, 29 Dec 2011 22:24:45 +0100
Message-ID: <1325193891-20905-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59707 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1L2VYx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:24:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit dc5ae69f1cff7f9001187f7c630597f670137f06:

  update .gitignore file (2011-12-29 19:37:47 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_acct master

Jan Engelhardt (5):
      build: enable automake warnings
      build: remove unnecessary AC_EXEEXT
      Update .gitignore
      Add examples/.gitignore
      build: add missing LIBMNL_CFLAGS to compilation process

 .gitignore          |    6 +++---
 Make_global.am      |    2 +-
 configure.ac        |    4 ++--
 examples/.gitignore |    3 +++
 4 files changed, 9 insertions(+), 6 deletions(-)
 create mode 100644 examples/.gitignore
