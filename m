From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/11] netfilter: ipv6: nf_defrag: Kill frag queue on RFC2460 failure
Date: Wed,  7 Feb 2018 18:42:20 +0100
Message-ID: <20180207174229.4098-3-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754171AbeBGRmj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:42:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 184313066AA
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08D25DA3AE
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:38 +0100 (CET)
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Failures were seen in ICMPv6 fragmentation timeout tests if they were
run after the RFC2460 failure tests. Kernel was not sending out the
ICMPv6 fragment reassembly time exceeded packet after the fragmentation
reassembly timeout of 1 minute had elapsed.

This happened because the frag queue was not released if an error in
IPv6 fragmentation header was detected by RFC2460.

Fixes: 83f1999caeb1 ("netfilter: ipv6: nf_defrag: Pass on packets to stack per RFC2460")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index ce53dcfda88a..b84ce3e6d728 100644
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
2.11.0

