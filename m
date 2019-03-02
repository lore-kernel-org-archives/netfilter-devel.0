Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B7BC10F05
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 514A32086D
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfCBSfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:17 -0500
Received: from mail.us.es ([193.147.175.20]:35742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbfCBSfP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 819291361A8
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B319DA84C
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 608FFDA7FC; Sat,  2 Mar 2019 19:35:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B983DA856;
        Sat,  2 Mar 2019 19:35:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0CC6F4265A2F;
        Sat,  2 Mar 2019 19:35:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/29] netfilter: nat: remove l3 manip_pkt hook
Date:   Sat,  2 Mar 2019 19:34:36 +0100
Message-Id: <20190302183457.3079-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

We can now use direct calls.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l3proto.h |  9 ++++-----
 net/netfilter/nf_nat_core.c            | 17 -----------------
 net/netfilter/nf_nat_proto.c           | 28 ++++++++++++++++++++++++++--
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index 100972bbd9ad..62ef15eb7594 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -5,11 +5,6 @@
 struct nf_nat_l3proto {
 	u8	l3proto;
 
-	bool	(*manip_pkt)(struct sk_buff *skb,
-			     unsigned int iphdroff,
-			     const struct nf_conntrack_tuple *target,
-			     enum nf_nat_manip_type maniptype);
-
 	void	(*csum_update)(struct sk_buff *skb, unsigned int iphdroff,
 			       __sum16 *check,
 			       const struct nf_conntrack_tuple *t,
@@ -20,6 +15,10 @@ struct nf_nat_l3proto {
 			       int datalen, int oldlen);
 };
 
+unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
+			      enum nf_nat_manip_type mtype,
+			      enum ip_conntrack_dir dir);
+
 int nf_nat_l3proto_register(const struct nf_nat_l3proto *);
 void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *);
 const struct nf_nat_l3proto *__nf_nat_l3proto_find(u8 l3proto);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 0c548ff215b2..8c5c29189383 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -699,23 +699,6 @@ nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 }
 EXPORT_SYMBOL_GPL(nf_nat_alloc_null_binding);
 
-static unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
-				     enum nf_nat_manip_type mtype,
-				     enum ip_conntrack_dir dir)
-{
-	const struct nf_nat_l3proto *l3proto;
-	struct nf_conntrack_tuple target;
-
-	/* We are aiming to look like inverse of other direction. */
-	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
-
-	l3proto = __nf_nat_l3proto_find(target.src.l3num);
-	if (!l3proto->manip_pkt(skb, 0, &target, mtype))
-		return NF_DROP;
-
-	return NF_ACCEPT;
-}
-
 /* Do packet manipulations according to nf_nat_setup_info. */
 unsigned int nf_nat_packet(struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index ecb988ed4d69..5a6496dbf1bf 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -425,6 +425,32 @@ static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 	return true;
 }
 
+unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
+			      enum nf_nat_manip_type mtype,
+			      enum ip_conntrack_dir dir)
+{
+	struct nf_conntrack_tuple target;
+
+	/* We are aiming to look like inverse of other direction. */
+	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
+
+	switch (target.src.l3num) {
+	case NFPROTO_IPV6:
+		if (nf_nat_ipv6_manip_pkt(skb, 0, &target, mtype))
+			return NF_ACCEPT;
+		break;
+	case NFPROTO_IPV4:
+		if (nf_nat_ipv4_manip_pkt(skb, 0, &target, mtype))
+			return NF_ACCEPT;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return NF_DROP;
+}
+
 static void nf_nat_ipv4_csum_update(struct sk_buff *skb,
 				    unsigned int iphdroff, __sum16 *check,
 				    const struct nf_conntrack_tuple *t,
@@ -506,7 +532,6 @@ static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.l3proto		= NFPROTO_IPV4,
-	.manip_pkt		= nf_nat_ipv4_manip_pkt,
 	.csum_update		= nf_nat_ipv4_csum_update,
 	.csum_recalc		= nf_nat_ipv4_csum_recalc,
 };
@@ -759,7 +784,6 @@ void nf_nat_l3proto_exit(void)
 #if IS_ENABLED(CONFIG_IPV6)
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
-	.manip_pkt		= nf_nat_ipv6_manip_pkt,
 	.csum_update		= nf_nat_ipv6_csum_update,
 	.csum_recalc		= nf_nat_ipv6_csum_recalc,
 };
-- 
2.11.0


