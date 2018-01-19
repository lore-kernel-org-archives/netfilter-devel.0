From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 24/32] netfilter: nf_nat_snmp_basic: replace ctinfo with dir.
Date: Fri, 19 Jan 2018 20:10:33 +0100
Message-ID: <20180119191041.25804-25-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

The snmp_translate() receives ctinfo data to get dir value only.
because of caller already has dir value, we just replace ctinfo with dir.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_snmp_basic.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index e5ec946f0765..c8ac57f56318 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1082,15 +1082,12 @@ static int snmp_parse_mangle(unsigned char *msg,
 /*
  * SNMP translation routine.
  */
-static int snmp_translate(struct nf_conn *ct,
-			  enum ip_conntrack_info ctinfo,
-			  struct sk_buff *skb)
+static int snmp_translate(struct nf_conn *ct, int dir, struct sk_buff *skb)
 {
 	struct iphdr *iph = ip_hdr(skb);
 	struct udphdr *udph = (struct udphdr *)((__be32 *)iph + iph->ihl);
 	u_int16_t udplen = ntohs(udph->len);
 	u_int16_t paylen = udplen - sizeof(struct udphdr);
-	int dir = CTINFO2DIR(ctinfo);
 	struct oct1_map map;
 
 	/*
@@ -1155,7 +1152,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 		return NF_DROP;
 
 	spin_lock_bh(&snmp_lock);
-	ret = snmp_translate(ct, ctinfo, skb);
+	ret = snmp_translate(ct, dir, skb);
 	spin_unlock_bh(&snmp_lock);
 	return ret;
 }
-- 
2.11.0
