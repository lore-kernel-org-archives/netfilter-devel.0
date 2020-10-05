Return-Path: <SRS0=VfFo=DM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4329C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 20:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F21021548
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 20:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgJEUPo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Oct 2020 16:15:44 -0400
Received: from mg.ssi.bg ([178.16.128.9]:39054 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgJEUPo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Oct 2020 16:15:44 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 000EB2B1D1
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2020 23:15:42 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id B56F52B1CA
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2020 23:15:41 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 51B8D3C09B7;
        Mon,  5 Oct 2020 23:15:38 +0300 (EEST)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 095KFcJv013997;
        Mon, 5 Oct 2020 23:15:38 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.15.2/8.15.2/Submit) id 095KFZIE013996;
        Mon, 5 Oct 2020 23:15:35 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        "longguang.yue" <bigclouds@163.com>, yuelongguang@gmail.com
Subject: [PATCH v8 net-next] ipvs: inspect reply packets from DR/TUN real servers
Date:   Mon,  5 Oct 2020 23:13:47 +0300
Message-Id: <20201005201347.13644-1-ja@ssi.bg>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: longguang.yue <bigclouds@163.com>

Just like for MASQ, inspect the reply packets coming from DR/TUN
real servers and alter the connection's state and timeout
according to the protocol.

It's ipvs's duty to do traffic statistic if packets get hit,
no matter what mode it is.

Signed-off-by: longguang.yue <bigclouds@163.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---

Simon, Pablo, please review and apply!

Before v6 this patch was named
"ipvs: Add traffic statistic up even it is VS/DR or VS/TUN mode"

Changes:
v1: support DR/TUN mode statistic
v2: ip_vs_conn_out_get handles DR/TUN mode's conn
v3: fix checkpatch
v4, v5: restructure and optimise this feature
v6: rewrite subject and patch description
v7: adjust changelogs and order of some local vars
v8: fix patch format

 net/netfilter/ipvs/ip_vs_conn.c | 18 +++++++++++++++---
 net/netfilter/ipvs/ip_vs_core.c | 19 +++++++------------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index a90b8eac16ac..c100c6b112c8 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -402,6 +402,8 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 {
 	unsigned int hash;
 	struct ip_vs_conn *cp, *ret=NULL;
+	const union nf_inet_addr *saddr;
+	__be16 sport;
 
 	/*
 	 *	Check for "full" addressed entries
@@ -411,10 +413,20 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 	rcu_read_lock();
 
 	hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[hash], c_list) {
-		if (p->vport == cp->cport && p->cport == cp->dport &&
-		    cp->af == p->af &&
+		if (p->vport != cp->cport)
+			continue;
+
+		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ) {
+			sport = cp->vport;
+			saddr = &cp->vaddr;
+		} else {
+			sport = cp->dport;
+			saddr = &cp->daddr;
+		}
+
+		if (p->cport == sport && cp->af == p->af &&
 		    ip_vs_addr_equal(p->af, p->vaddr, &cp->caddr) &&
-		    ip_vs_addr_equal(p->af, p->caddr, &cp->daddr) &&
+		    ip_vs_addr_equal(p->af, p->caddr, saddr) &&
 		    p->protocol == cp->protocol &&
 		    cp->ipvs == p->ipvs) {
 			if (!__ip_vs_conn_get(cp))
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index e3668a6e54e4..cc3c275934f4 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -875,7 +875,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 	unsigned int verdict = NF_DROP;
 
 	if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
-		goto ignore_cp;
+		goto after_nat;
 
 	/* Ensure the checksum is correct */
 	if (!skb_csum_unnecessary(skb) && ip_vs_checksum_complete(skb, ihl)) {
@@ -901,6 +901,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
 		goto out;
 
+after_nat:
 	/* do the statistics and put it back */
 	ip_vs_out_stats(cp, skb);
 
@@ -909,8 +910,6 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		ip_vs_notrack(skb);
 	else
 		ip_vs_update_conntrack(skb, cp, 0);
-
-ignore_cp:
 	verdict = NF_ACCEPT;
 
 out:
@@ -1276,6 +1275,9 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 {
 	struct ip_vs_protocol *pp = pd->pp;
 
+	if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
+		goto after_nat;
+
 	IP_VS_DBG_PKT(11, af, pp, skb, iph->off, "Outgoing packet");
 
 	if (skb_ensure_writable(skb, iph->len))
@@ -1316,6 +1318,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 
 	IP_VS_DBG_PKT(10, af, pp, skb, iph->off, "After SNAT");
 
+after_nat:
 	ip_vs_out_stats(cp, skb);
 	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd);
 	skb->ipvs_property = 1;
@@ -1412,11 +1415,8 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
 	cp = INDIRECT_CALL_1(pp->conn_out_get, ip_vs_conn_out_get_proto,
 			     ipvs, af, skb, &iph);
 
-	if (likely(cp)) {
-		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
-			goto ignore_cp;
+	if (likely(cp))
 		return handle_response(af, skb, pd, cp, &iph, hooknum);
-	}
 
 	/* Check for real-server-started requests */
 	if (atomic_read(&ipvs->conn_out_counter)) {
@@ -1475,14 +1475,9 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
 		}
 	}
 
-out:
 	IP_VS_DBG_PKT(12, af, pp, skb, iph.off,
 		      "ip_vs_out: packet continues traversal as normal");
 	return NF_ACCEPT;
-
-ignore_cp:
-	__ip_vs_conn_put(cp);
-	goto out;
 }
 
 /*
-- 
2.26.2


