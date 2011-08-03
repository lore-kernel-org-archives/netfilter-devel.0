From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfnetlink: build fixes
Date: Wed,  3 Aug 2011 17:11:56 +0200
Message-ID: <1312384319-29980-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59554 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab1HCPMA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:12:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 87eac438d72e8abfc05d9dc99ff80db8789ca5fd:

  utils: resolve compiler warning (2011-07-30 20:57:13 +0200)

are available in the git repository at:
  git://dev.medozas.de/libnfnetlink master

Jan Engelhardt (2):
      nfnl: avoid exit on large packet
      build: fix error with automake-1.9

 .gitignore         |    2 ++
 configure.ac       |    1 +
 src/libnfnetlink.c |    4 +---
 3 files changed, 4 insertions(+), 3 deletions(-)
