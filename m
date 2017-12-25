From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH V4 4/5] netfilter: nf_nat_snmp_basic: use nf_ct_helper_log
Date: Tue, 26 Dec 2017 00:00:21 +0900
Message-ID: <20171225150021.4032-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37859 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752760AbdLYPA1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Dec 2017 10:00:27 -0500
Received: by mail-pg0-f65.google.com with SMTP id o13so6278552pgp.4
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Dec 2017 07:00:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use nf_ct_helper_log to write log message.

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

 net/ipv4/netfilter/nf_nat_snmp_basic.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index c8ac57f..7f7d847 100644
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
2.9.3

