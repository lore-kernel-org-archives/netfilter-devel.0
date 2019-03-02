Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF02FC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9BA820838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfCBSgW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:22 -0500
Received: from mail.us.es ([193.147.175.20]:36068 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbfCBSgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7BD521361AB
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 677FDDA856
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5CAACDA85E; Sat,  2 Mar 2019 19:36:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C134DA797;
        Sat,  2 Mar 2019 19:36:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E12744265A2F;
        Sat,  2 Mar 2019 19:36:17 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/29] netfilter: nat: remove csum_recalc hook
Date:   Sat,  2 Mar 2019 19:35:54 +0100
Message-Id: <20190302183613.3159-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
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
 include/net/netfilter/nf_nat_l3proto.h |  7 +++----
 net/netfilter/nf_nat_helper.c          | 12 ++++--------
 net/netfilter/nf_nat_proto.c           | 22 ++++++++++++++++++++--
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index c1123030c94f..8ee0b5b629c7 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -4,15 +4,14 @@
 
 struct nf_nat_l3proto {
 	u8	l3proto;
-
-	void	(*csum_recalc)(struct sk_buff *skb, u8 proto,
-			       void *data, __sum16 *check,
-			       int datalen, int oldlen);
 };
 
 unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
 			      enum nf_nat_manip_type mtype,
 			      enum ip_conntrack_dir dir);
+void nf_nat_csum_recalc(struct sk_buff *skb,
+			u8 nfproto, u8 proto, void *data, __sum16 *check,
+			int datalen, int oldlen);
 
 int nf_nat_l3proto_register(const struct nf_nat_l3proto *);
 void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *);
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 12dea976d959..0a8dd5f368cd 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -97,7 +97,6 @@ bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 				const char *rep_buffer,
 				unsigned int rep_len, bool adjust)
 {
-	const struct nf_nat_l3proto *l3proto;
 	struct tcphdr *tcph;
 	int oldlen, datalen;
 
@@ -117,9 +116,8 @@ bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 
 	datalen = skb->len - protoff;
 
-	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
-	l3proto->csum_recalc(skb, IPPROTO_TCP, tcph, &tcph->check,
-			     datalen, oldlen);
+	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_TCP,
+			   tcph, &tcph->check, datalen, oldlen);
 
 	if (adjust && rep_len != match_len)
 		nf_ct_seqadj_set(ct, ctinfo, tcph->seq,
@@ -149,7 +147,6 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 			 const char *rep_buffer,
 			 unsigned int rep_len)
 {
-	const struct nf_nat_l3proto *l3proto;
 	struct udphdr *udph;
 	int datalen, oldlen;
 
@@ -175,9 +172,8 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 	if (!udph->check && skb->ip_summed != CHECKSUM_PARTIAL)
 		return true;
 
-	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
-	l3proto->csum_recalc(skb, IPPROTO_UDP, udph, &udph->check,
-			     datalen, oldlen);
+	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_TCP,
+			   udph, &udph->check, datalen, oldlen);
 
 	return true;
 }
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 8a306a77914d..8284ed1b3173 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -535,9 +535,28 @@ static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
 }
 #endif
 
+void nf_nat_csum_recalc(struct sk_buff *skb,
+			u8 nfproto, u8 proto, void *data, __sum16 *check,
+			int datalen, int oldlen)
+{
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+		nf_nat_ipv4_csum_recalc(skb, proto, data, check,
+					datalen, oldlen);
+		return;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		nf_nat_ipv6_csum_recalc(skb, proto, data, check,
+					datalen, oldlen);
+		return;
+#endif
+	}
+
+	WARN_ON_ONCE(1);
+}
+
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.l3proto		= NFPROTO_IPV4,
-	.csum_recalc		= nf_nat_ipv4_csum_recalc,
 };
 
 int nf_nat_icmp_reply_translation(struct sk_buff *skb,
@@ -788,7 +807,6 @@ void nf_nat_l3proto_exit(void)
 #if IS_ENABLED(CONFIG_IPV6)
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
-	.csum_recalc		= nf_nat_ipv6_csum_recalc,
 };
 
 int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
-- 
2.11.0


