From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next] netfilter: ipv6: nf_defrag: Kill frag queue on RFC2460 failure
Date: Wed, 31 Jan 2018 04:50:01 -0700
Message-ID: <1517399401-9299-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33110 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbeAaLur (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Jan 2018 06:50:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Failures were seen in ICMPv6 fragmentation timeout tests if they were
run after the RFC2460 failure tests. Kernel was not sending out the
ICMPv6 fragment reassembly time exceeded packet after the fragmentation
reassembly timeout of 1 minute had elapsed.

This happened because the frag queue was not released if an error in
IPv6 fragmentation header was detected by RFC2460.

Fixes: 83f1999caeb1 ("netfilter: ipv6: nf_defrag: Pass on packets to stack per RFC2460")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
Hi Pablo
This needs to be picked up for 4.16
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index ce53dcf..b84ce3e 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -264,6 +264,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 			 * this case. -DaveM
 			 */
 			pr_debug("end of fragment not rounded to 8 bytes.\n");
+			inet_frag_kill(&fq->q, &nf_frags);
 			return -EPROTO;
 		}
 		if (end > fq->q.len) {
-- 
1.9.1

