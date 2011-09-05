From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables fixes 20110905
Date: Mon,  5 Sep 2011 20:22:48 +0200
Message-ID: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33340 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869Ab1IESW5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:22:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit bf42cf92ea0c53e5470a20d62d00e5e83379f4d5:

  Merge branch 'stable' of git://dev.medozas.de/iptables (2011-09-05 20:16:07 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables stable

Jan Engelhardt (4):
      libxt_statistic: link with -lm
      libxt_RATEEST: link with -lm
      build: scan for unreferenced symbols
      iptables: move kernel version find routing into libxtables

Tom Eastep (1):
      libxt_CONNSECMARK: fix spacing in output

 Makefile.am                    |    3 ++-
 extensions/GNUmakefile.in      |   17 +++++++++++++++--
 extensions/libxt_CONNSECMARK.c |    2 +-
 include/iptables.h             |    8 --------
 include/xtables.h.in           |    8 ++++++++
 iptables/Makefile.am           |   10 +++++++---
 iptables/iptables.c            |   18 ------------------
 iptables/xtables.c             |   18 ++++++++++++++++++
 8 files changed, 51 insertions(+), 33 deletions(-)
