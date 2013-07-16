From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 0/9] Various fixes
Date: Tue, 16 Jul 2013 15:38:44 +0300
Message-ID: <1373978333-17427-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab3GPMi7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:38:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here are some fixes, mostly on output issues.
Afaik, nftables does not handle any chain ordering, builtin ones or not, but in iptables user is used to see builtins ones in a certains order and the rest.
So patch 6, 7 and 8 ensures this.

Other patches are self explained.

Tomasz Bursztyka (9):
  nft: Set the rule family when creating a new one
  nft: Handle error on adding rule expressions
  nft: Refactor and optimize nft_rule_list
  xtables: Remove useless parameter to nft_chain_list_find
  nft: Une one unique function to test for a builtin chain
  nft: Print chains in right order when listing rules
  nft: Print chains in right order when saving rules
  xtables-save: Print chains in right order
  nft: Fix small memory leaks

 iptables/nft.c             | 250 ++++++++++++++++++++++++++++++---------------
 iptables/nft.h             |   2 +-
 iptables/xtables-restore.c |   2 +-
 3 files changed, 171 insertions(+), 83 deletions(-)

-- 
1.8.2.1

