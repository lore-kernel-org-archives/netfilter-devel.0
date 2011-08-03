From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_log: build fix
Date: Wed,  3 Aug 2011 17:09:24 +0200
Message-ID: <1312384166-26541-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59513 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab1HCPJ2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:09:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 353cc5f966912aa8d576f8a27daaee93f8bc29a0:

  build: Linux kernel-style for compilation messages (2011-03-15 18:20:17 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_log master

Jan Engelhardt (1):
      build: fix error with automake-1.9

 .gitignore   |    1 +
 configure.ac |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
