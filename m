From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH V4 3/5] netfilter: nf_nat_snmp_basic: replace ctinfo with dir.
Date: Mon, 25 Dec 2017 23:59:56 +0900
Message-ID: <20171225145956.3962-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37583 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdLYPAD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Dec 2017 10:00:03 -0500
Received: by mail-pf0-f196.google.com with SMTP id n6so17943561pfa.4
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Dec 2017 07:00:03 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The snmp_translate() receives ctinfo data to get dir value only.
because of caller already has dir value, we just replace ctinfo with dir.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

V4 :
 - rename nf_nat_snmp_basic.c to nf_nat_snmp_basic_main.c
 to fix compile error

V3 :
 - be separated by previous patch.

V2 :
 - Add missing nf_nat_snmp_basic.asn1 file

V1 :
 - Initial patch

 net/ipv4/netfilter/nf_nat_snmp_basic.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index e5ec946..c8ac57f 100644
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
2.9.3

