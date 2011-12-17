From: Jan Engelhardt <jengelh@medozas.de>
Subject: nfnetlink: build updates
Date: Sat, 17 Dec 2011 04:04:42 +0100
Message-ID: <1324091086-6074-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:51275 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835Ab1LQDEv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Dec 2011 22:04:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 98a8de97de020cedb0240cd0554dc6246bf0237a:

  build: fix error with automake-1.9 (2011-08-01 19:55:55 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnfnetlink master

Jan Engelhardt (3):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      build: disable implicit .tar.gz archive generation and use POSIX mode

 .gitignore   |   12 ++++--------
 configure.ac |    4 +++-
 2 files changed, 7 insertions(+), 9 deletions(-)
