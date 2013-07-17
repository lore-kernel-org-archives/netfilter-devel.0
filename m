From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - PATCH 0/2] fixes
Date: Wed, 17 Jul 2013 10:34:13 +0300
Message-ID: <1374046455-19234-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab3GQHeV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:34:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

First patch is in reply of my previous "[iptables-nftables - PATCH 3/9] nft: Refactor and optimize nft_rule_list"
Since there is no need to refactor anything anymore. And same fixe applies on rule save actually.

Second patch, well I am not found of "style" patches, but I am also annoyed by lines being way too long.
Your call Pablo, take that one or scrap it. 

Tomasz Bursztyka (2):
  nft: Optimize chain listing if only one is looked for
  nft: Fix code style issues

 iptables/nft.c | 94 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 32 deletions(-)

-- 
1.8.2.1

