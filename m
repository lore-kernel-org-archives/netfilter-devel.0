From: Jan Engelhardt <jengelh@medozas.de>
Subject: Fixes to opts, docs
Date: Mon,  9 May 2011 21:53:40 +0200
Message-ID: <1304970823-11244-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54465 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1EITxp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:53:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit edc2b1adf32d2b11e126174f525293b3bca6e7bc:

  Merge branch 'opts' of git://dev.medozas.de/iptables (2011-05-09 11:26:32 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Changli Gao (1):
      iptables: fix the dead loop when meeting unknown options

Jan Engelhardt (1):
      doc: S/DNAT allows to omit IP addresses

 extensions/libipt_DNAT.c   |    2 +-
 extensions/libipt_DNAT.man |    2 +-
 extensions/libipt_SNAT.c   |    2 +-
 extensions/libipt_SNAT.man |    2 +-
 xshared.c                  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)
