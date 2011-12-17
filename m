From: Jan Engelhardt <jengelh@medozas.de>
Subject: conntrack-tools: build updates
Date: Sat, 17 Dec 2011 16:37:53 +0100
Message-ID: <1324136277-10721-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59790 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab1LQPiA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:38:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 482c167dffd033915f693c13eb3c47e6f6f77a27:

  conntrackd: add missing initial caching of gettimeofday() (2011-10-24 12:01:26 +0200)

are available in the git repository at:
  git://dev.medozas.de/conntrack-tools master

Jan Engelhardt (3):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      build: disable implicit .tar.gz archive generation and use POSIX mode

 .gitignore   |   12 ++++--------
 configure.ac |    5 +++--
 2 files changed, 7 insertions(+), 10 deletions(-)
