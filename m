From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_queue: build fixes
Date: Wed,  3 Aug 2011 17:10:15 +0200
Message-ID: <1312384217-26670-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59534 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab1HCPKT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:10:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit fdb06b98e1d5efbdc33ea2724fccd297c3d2315a:

  build: Linux kernel-style for compilation messages (2011-03-15 18:23:42 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_queue master

Jan Engelhardt (2):
      build: fix error with automake-1.9
      build: fix file list warning with automake-1.9

 .gitignore   |    1 +
 Makefile.am  |    2 +-
 configure.ac |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)
