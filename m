From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/10] netfilter: nf_defrag_ipv4: Drop redundant ip_send_check()
Date: Tue,  8 Mar 2016 11:00:45 +0100
Message-ID: <1457431250-3086-6-git-send-email-pablo@netfilter.org>
References: <1457431250-3086-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1457431250-3086-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Joe Stringer <joe@ovn.org>

Since commit 0848f6428ba3 ("inet: frags: fix defragmented packet's IP
header for af_packet"), ip_send_check() would be called twice for
defragmentation that occurs from netfilter ipv4 defrag hooks. Remove the
extra call.

Signed-off-by: Joe Stringer <joe@ovn.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index a04dee5..d88da36 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -31,10 +31,8 @@ static int nf_ct_ipv4_gather_frags(struct net *net, struct sk_buff *skb,
 	err = ip_defrag(net, skb, user);
 	local_bh_enable();
 
-	if (!err) {
-		ip_send_check(ip_hdr(skb));
+	if (!err)
 		skb->ignore_df = 1;
-	}
 
 	return err;
 }
-- 
2.1.4
