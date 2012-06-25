From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_log: build updates
Date: Mon, 25 Jun 2012 20:34:43 +0200
Message-ID: <1340649285-20005-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48676 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2FYSeq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:34:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 97866a0a7482ca518bad39536c7c667bfb9604b2:

  build: bump version to 1.0.1 (2012-01-02 21:05:56 +0100)

are available in the git repository at:
  git://git.inai.de/libnetfilter_log master

Jan Engelhardt (2):
      build: remove unnecessary pkgconfig->config.status dependency
      build: remove unused lines in Makefile.am

 Make_global.am |    4 ++--
 Makefile.am    |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)
