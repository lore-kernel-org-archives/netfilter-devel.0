Return-Path: <SRS0=cI96=DJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15517C35257
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 19:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD73206DD
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Oct 2020 19:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ijqMYkJg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgJBTws (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Oct 2020 15:52:48 -0400
Received: from m12-13.163.com ([220.181.12.13]:38330 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBTws (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Oct 2020 15:52:48 -0400
X-Greylist: delayed 6344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2020 15:52:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=nd9oP
        Av+PVdHTui16lO4giEVC1V0YqToMfMakyliwMQ=; b=ijqMYkJgCWfmFay1I1Kz1
        HEXxHn8T8isObsQYDAMfmwm0Zgp1rTpoWpgR74Y7h2v2HJedbphh7Jt59DdmbBzQ
        evXGg2oLdQlTbRSBjvpf2poaqh06xRH2lKjkn++g4y+fhlqIebDfsfcIW66dh47/
        Y2lhaIY2tdMm4Kx2nc5yBI=
Received: from localhost.localdomain (unknown [114.247.184.147])
        by smtp9 (Coremail) with SMTP id DcCowACnCGi_YHdf7MZNJQ--.43537S2;
        Sat, 03 Oct 2020 01:17:51 +0800 (CST)
From:   "longguang.yue" <bigclouds@163.com>
Cc:     ja@ssi.bg, kuba@kernel.org, wensong@linux-vs.org,
        horms@verge.net.au, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, yuelongguang@gmail.com,
        "longguang.yue" <bigclouds@163.com>
Subject: [PATCH v4] ipvs: Add traffic statistic up even it is VS/DR or VS/TUN mode
Date:   Sat,  3 Oct 2020 01:17:32 +0800
Message-Id: <20201002171732.74552-1-bigclouds@163.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <alpine.LFD.2.23.451.2009302019180.5709@ja.home.ssi.bg>
References: <alpine.LFD.2.23.451.2009302019180.5709@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowACnCGi_YHdf7MZNJQ--.43537S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr4DCw1kZF48ZFW3Ar4rAFb_yoW5Kw1Dp3
        WUKa93XrW8GFy3t3WxJr97ur1fCr1kJ3Zrur4Yk34Sy3Z8JF15XFsY9FyYyFW5CrsYqa43
        tw4Fqw45Cw1DJ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UmhFsUUUUU=
X-Originating-IP: [114.247.184.147]
X-CM-SenderInfo: peljuzprxg2qqrwthudrp/1tbiVB+xQ1UMOY-1YAAAsD
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's ipvs's duty to do traffic statistic if packets get hit,
no matter what mode it is.

Changes in v1: support DR/TUN mode statistic
Changes in v2: ip_vs_conn_out_get handles DR/TUN mode's conn
Changes in v3: fix checkpatch
Changes in v4: restructure and optimise this feature

Signed-off-by: longguang.yue <bigclouds@163.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 18 +++++++++++++++---
 net/netfilter/ipvs/ip_vs_core.c | 24 +++++++++++++++++-------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index a90b8eac16ac..af08ca2d9174 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -401,6 +401,8 @@ struct ip_vs_conn *ip_vs_ct_in_get(const struct ip_vs_conn_param *p)
 struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
 {
 	unsigned int hash;
+	__be16 sport;
+	const union nf_inet_addr *saddr;
 	struct ip_vs_conn *cp, *ret=NULL;
 
 	/*
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
index e3668a6e54e4..315289aecad7 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -911,6 +911,10 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		ip_vs_update_conntrack(skb, cp, 0);
 
 ignore_cp:
+	ip_vs_out_stats(cp, skb);
+	skb->ipvs_property = 1;
+	if (!(cp->flags & IP_VS_CONN_F_NFCT))
+		ip_vs_notrack(skb);
 	verdict = NF_ACCEPT;
 
 out:
@@ -1276,6 +1280,9 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 {
 	struct ip_vs_protocol *pp = pd->pp;
 
+	if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
+		goto ignore_cp;
+
 	IP_VS_DBG_PKT(11, af, pp, skb, iph->off, "Outgoing packet");
 
 	if (skb_ensure_writable(skb, iph->len))
@@ -1328,6 +1335,16 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 	LeaveFunction(11);
 	return NF_ACCEPT;
 
+ignore_cp:
+	ip_vs_out_stats(cp, skb);
+	skb->ipvs_property = 1;
+	if (!(cp->flags & IP_VS_CONN_F_NFCT))
+		ip_vs_notrack(skb);
+	__ip_vs_conn_put(cp);
+
+	LeaveFunction(11);
+	return NF_ACCEPT;
+
 drop:
 	ip_vs_conn_put(cp);
 	kfree_skb(skb);
@@ -1413,8 +1430,6 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
 			     ipvs, af, skb, &iph);
 
 	if (likely(cp)) {
-		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
-			goto ignore_cp;
 		return handle_response(af, skb, pd, cp, &iph, hooknum);
 	}
 
@@ -1475,14 +1490,9 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
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
2.20.1 (Apple Git-117)


