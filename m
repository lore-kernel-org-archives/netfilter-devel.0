From: Jan Engelhardt <jengelh@inai.de>
Subject: libnetfilter_acct: build updates
Date: Mon, 25 Jun 2012 20:19:00 +0200
Message-ID: <1340648341-15979-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48511 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab2FYSTJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:19:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit e1b471136646051ec5869da27b984993ede1bb65:

  build: bump version to 1.0.1 (2012-06-22 17:52:26 +0200)

are available in the git repository at:
  git://git.inai.de/libnetfilter_acct master

Jan Engelhardt (1):
      build: remove unnecessary pkgconfig->config.status dependency

 Makefile.am |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
