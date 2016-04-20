From: Jarno Rajahalme <jarno@ovn.org>
Subject: [PATCH] nf_nat_packet: Clear skb hash after modifying packet headers.
Date: Wed, 20 Apr 2016 14:31:10 -0700
Message-ID: <1461187870-54322-1-git-send-email-jarno@ovn.org>
Cc: kernel-janitors@vger.kernel.org, dev@openvswitch.org, jarno@ovn.org
To: netfilter-devel@vger.kernel.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Clear the skb hash when it does not reflect the actual header values
any more.

Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
---
 net/netfilter/nf_nat_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 06a9f45..3c2302f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -505,6 +505,7 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
 		if (!l3proto->manip_pkt(skb, 0, l4proto, &target, mtype))
 			return NF_DROP;
 	}
+	skb_clear_hash(skb);
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(nf_nat_packet);
-- 
2.1.4

