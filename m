From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl: build updates
Date: Sat, 17 Dec 2011 16:37:06 +0100
Message-ID: <1324136231-25643-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59764 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1LQPhN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:37:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit bae830bbfc10b3892d48cde9bafc6f7356f0affc:

  build: abort autogen on subcommand failure (2011-08-09 14:28:49 +0200)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (4):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      m4: resolve autoconf-2.68 warnings
      build: disable implicit .tar.gz archive generation and use POSIX mode

 .gitignore            |   12 ++++--------
 configure.ac          |    3 ++-
 m4/gcc4_visibility.m4 |    4 ++--
 3 files changed, 8 insertions(+), 11 deletions(-)
