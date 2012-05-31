From: Jan Engelhardt <jengelh@inai.de>
Subject: conntrack-tools: 1 pending fix
Date: Thu, 31 May 2012 14:03:16 +0200
Message-ID: <1338465797-9797-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36328 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab2EaMDr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 May 2012 08:03:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit d44489648c1a56d543a84bbebe455227bb25cf34:

  conntrackd: fix compilation in src/parse.c (2012-05-28 14:06:48 +0200)

are available in the git repository at:
  git://git.inai.de/conntrack-tools fix

Jan Engelhardt (1):
      conntrackd: resolve a compiler error

 src/parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
