From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_log: build updates
Date: Sat, 17 Dec 2011 16:36:08 +0100
Message-ID: <1324136172-28320-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59429 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1LQPgN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:36:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 253172652d9f91f47b3bef79499d7994a9997f7f:

  build: fix error with automake-1.9 (2011-08-01 20:00:02 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_log master

Jan Engelhardt (3):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      build: disable implicit .tar.gz archive generation and use POSIX mode

 .gitignore   |   12 ++++--------
 configure.ac |    5 +++--
 2 files changed, 7 insertions(+), 10 deletions(-)
