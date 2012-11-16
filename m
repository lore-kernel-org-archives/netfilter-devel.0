From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next:nf_tables-experiments PATCH] nf_tables: Fix up build issue on IPv6 NAT support
Date: Fri, 16 Nov 2012 09:42:59 +0200
Message-ID: <1353051779-21341-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57584 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2KPHnD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:43:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A left-over from IPv4 NAT which was not detected at first since
CONFIG_NETFILTER_DEBUG was not enabled when compiling.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/ipv6/netfilter/nft_chain_nat_ipv6.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
index c585807..bc2f351 100644
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
@@ -45,8 +45,6 @@ static unsigned int nf_nat_ipv6_fn(const struct nf_hook_ops *ops,
 	if (ct == NULL || nf_ct_is_untracked(ct))
 		return NF_ACCEPT;
 
-	NF_CT_ASSERT(!(ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)));
-
 	nat = nfct_nat(ct);
 	if (nat == NULL) {
 		/* Conntrack module was loaded late, can't add extension. */
-- 
1.8.0

