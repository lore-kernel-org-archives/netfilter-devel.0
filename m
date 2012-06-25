From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_cttimeout: build updates
Date: Mon, 25 Jun 2012 20:31:58 +0200
Message-ID: <1340649119-17014-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48640 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab2FYScB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:32:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 329652bef21c831dae1a9a79084b999d40b4eb5b:

  build: fix broken Makefile.am in include/linux/ (2012-05-26 15:18:17 +0200)

are available in the git repository at:
  git://git.inai.de/libnetfilter_cttimeout master

Jan Engelhardt (1):
      build: remove unnecessary pkgconfig->config.status dependency

 Makefile.am |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
