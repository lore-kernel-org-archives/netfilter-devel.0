From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 25/32] netfilter: nf_nat_snmp_basic: use nf_ct_helper_log
Date: Fri, 19 Jan 2018 20:10:34 +0100
Message-ID: <20180119191041.25804-26-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45260 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756265AbeASTL0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AFAC82EFEAE
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96D79DA84B
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:09 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Taehee Yoo <ap420073@gmail.com>

Use nf_ct_helper_log to write log message.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_nat_snmp_basic.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index c8ac57f56318..7f7d847bb048 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1109,7 +1109,7 @@ static int snmp_translate(struct nf_conn *ct, int dir, struct sk_buff *skb)
 
 	if (!snmp_parse_mangle((unsigned char *)udph + sizeof(struct udphdr),
 			       paylen, &map, &udph->check)) {
-		net_warn_ratelimited("bsalg: parser failed\n");
+		nf_ct_helper_log(skb, ct, "parser failed\n");
 		return NF_DROP;
 	}
 	return NF_ACCEPT;
@@ -1143,13 +1143,14 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	 * can mess around with the payload.
 	 */
 	if (ntohs(udph->len) != skb->len - (iph->ihl << 2)) {
-		net_warn_ratelimited("SNMP: dropping malformed packet src=%pI4 dst=%pI4\n",
-				     &iph->saddr, &iph->daddr);
-		 return NF_DROP;
+		nf_ct_helper_log(skb, ct, "dropping malformed packet\n");
+		return NF_DROP;
 	}
 
-	if (!skb_make_writable(skb, skb->len))
+	if (!skb_make_writable(skb, skb->len)) {
+		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		return NF_DROP;
+	}
 
 	spin_lock_bh(&snmp_lock);
 	ret = snmp_translate(ct, dir, skb);
-- 
2.11.0

