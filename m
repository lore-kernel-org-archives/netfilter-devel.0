From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: [PATCH] netfilter: Allow dropping packet after call to l4proto->packet
Date: Thu, 12 Mar 2009 16:13:46 +0100
Message-ID: <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com>
References: <200903121603.02733.christoph.paasch@gmail.com>
Cc: Christoph Paasch <christoph.paasch@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:38064 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbZCLPNy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:13:54 -0400
Received: by ewy25 with SMTP id 25so390429ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2009 08:13:50 -0700 (PDT)
In-Reply-To: <200903121603.02733.christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As NF_DROP = 0, no packets would ever have been dropped.
---
 net/netfilter/nf_conntrack_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ebc2756..452db52 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -727,7 +727,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	NF_CT_ASSERT(skb->nfct);
 
 	ret = l4proto->packet(ct, skb, dataoff, ctinfo, pf, hooknum);
-	if (ret < 0) {
+	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
 		pr_debug("nf_conntrack_in: Can't track with proto module\n");
-- 
1.5.6.3

