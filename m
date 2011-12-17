From: Jan Engelhardt <jengelh@medozas.de>
Subject: ulogd2: build updates
Date: Sat, 17 Dec 2011 16:39:18 +0100
Message-ID: <1324136362-16840-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59821 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab1LQPjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:39:23 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 1aa4c6135545ee8107584406f9d865d13c65a5ce:

  pcap: add file option to configuration file (2011-09-01 17:09:16 +0200)

are available in the git repository at:
  git://dev.medozas.de/ulogd2 master

Jan Engelhardt (3):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      build: disable implicit .tar.gz archive generation and use POSIX mode

 .gitignore   |   11 ++++-------
 configure.ac |    4 ++--
 2 files changed, 6 insertions(+), 9 deletions(-)
