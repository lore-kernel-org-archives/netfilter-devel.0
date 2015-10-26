From: Ian Morris <ipm@chirality.org.uk>
Subject: [PATCH nf-next 0/4] netfilter: bridge coding style
Date: Mon, 26 Oct 2015 09:10:39 +0000
Message-ID: <1445850643-9186-1-git-send-email-ipm@chirality.org.uk>
Cc: Ian Morris <ipm@chirality.org.uk>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inet-gw.chirality.org.uk ([88.97.209.22]:56040 "EHLO
	cedar.ipmorris.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753307AbbJZJKs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 05:10:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series of patches adddress coding style issues detected by checkpatch.

No changes in the resultant object arise from these changes.

Ian Morris (4):
  netfilter-bridge: Cleanse indentation
  netfilter-bridge: use netdev style comments
  netfilter-bridge: brace placement
  netfilter-bridge: layout of if statements

 net/bridge/netfilter/ebt_ip6.c        |   4 +-
 net/bridge/netfilter/ebt_log.c        |   9 +--
 net/bridge/netfilter/ebt_stp.c        |   2 +-
 net/bridge/netfilter/ebt_vlan.c       |  15 ++--
 net/bridge/netfilter/ebtable_filter.c |   2 +-
 net/bridge/netfilter/ebtable_nat.c    |   2 +-
 net/bridge/netfilter/ebtables.c       | 139 +++++++++++++++++-----------------
 7 files changed, 90 insertions(+), 83 deletions(-)

-- 
1.9.1

