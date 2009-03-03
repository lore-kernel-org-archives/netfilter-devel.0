From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: conntrack: increase drop stats if sequence
	adjustment fails
Date: Wed, 04 Mar 2009 00:36:58 +0100
Message-ID: <20090303233657.7390.5796.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47754 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756421AbZCDADt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:03:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch increases the statistics of packets drop if the sequence
adjustment fails in ipv4_confirm().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 4273aa7..e06fd8a 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -120,8 +120,10 @@ static unsigned int ipv4_confirm(unsigned int hooknum,
 		typeof(nf_nat_seq_adjust_hook) seq_adjust;
 
 		seq_adjust = rcu_dereference(nf_nat_seq_adjust_hook);
-		if (!seq_adjust || !seq_adjust(skb, ct, ctinfo))
+		if (!seq_adjust || !seq_adjust(skb, ct, ctinfo)) {
+			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
 			return NF_DROP;
+		}
 	}
 out:
 	/* We've seen it coming out the other side: confirm it */

