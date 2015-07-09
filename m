From: subashab@codeaurora.org
Subject: [PATCH] netfilter: nf_nat: Fix possible null dereference
Date: Thu, 9 Jul 2015 01:23:58 -0000
Message-ID: <fea9df65d6768053838fb1eca1846ef7.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36936 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbGIBX7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 21:23:59 -0400
Received: from www.codeaurora.org (unknown [198.145.29.65])
	by smtp.codeaurora.org (Postfix) with ESMTP id 22A2A140402
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2015 01:23:58 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix an issue where __nf_ct_ext_find() could return null to nat in
nf_nat_masquerade_ipv4() and could be dereferenced.

This was detected by static analysis software.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index c6eb421..4be5d70 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -38,6 +38,8 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int
hooknum,

 	ct = nf_ct_get(skb, &ctinfo);
 	nat = nfct_nat(ct);
+	if (!nat)
+		return NF_DROP;

 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			    ctinfo == IP_CT_RELATED_REPLY));
--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
Foundation Collaborative Project


