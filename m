From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_queue: build updates
Date: Mon, 25 Jun 2012 20:35:50 +0200
Message-ID: <1340649352-20198-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48698 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab2FYSfx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:35:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 08058418ac34c2456c9d010a99e4420dbe5c885f:

  build: bump version to 1.0.1 (2012-01-02 22:49:47 +0100)

are available in the git repository at:
  git://git.inai.de/libnetfilter_queue master

Jan Engelhardt (2):
      build: remove unnecessary AC_EXEEXT
      build: remove unused lines in Makefile.am

 Make_global.am |    4 ++--
 configure.ac   |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)
