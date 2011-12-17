From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_conntrack: build updates
Date: Sat, 17 Dec 2011 16:35:40 +0100
Message-ID: <1324136144-12845-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59399 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1LQPfs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:35:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 7843632196fd959f3f8f16f3d533c72d315a7e08:

  expect: add nfexp_send() (2011-12-08 02:06:53 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_conntrack master

Jan Engelhardt (3):
      Update .gitignore
      build: use AC_CONFIG_AUX_DIR and stash away tools
      build: disable implicit .tar.gz archive generation and use POSIX mode

 .gitignore   |   11 ++++-------
 configure.ac |    4 +++-
 2 files changed, 7 insertions(+), 8 deletions(-)
