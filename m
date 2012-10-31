From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 0/5] Support for -E and -R options.
Date: Wed, 31 Oct 2012 11:31:03 +0200
Message-ID: <1351675868-14302-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:33152 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab2JaJbL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:31:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

5 patches to implement -E and -R options in patch 2, 4 and 5.
Patches 1 and 3 are simple fixes.

Please review,

Tomasz Bursztyka (5):
  headers: Make nf_tables.h up to date
  nft: Add support for chain rename options (-E)
  iptables: nft: Fix -D chain rulenum option
  iptables: nft: Refactor __nft_rule_check to return rule handle when
    relevant
  iptables: nft: Add support for -R option

 include/linux/netfilter/nf_tables.h |  3 ++
 iptables/nft.c                      | 79 ++++++++++++++++++++++++++-----------
 iptables/nft.h                      |  2 +-
 iptables/xtables.c                  |  3 +-
 4 files changed, 63 insertions(+), 24 deletions(-)

-- 
1.7.12.4

