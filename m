Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA40C10F05
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D37120838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfCBSf1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:27 -0500
Received: from mail.us.es ([193.147.175.20]:35774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfCBSfO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B71091361B9
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3491DA846
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A00A9DA876; Sat,  2 Mar 2019 19:35:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36196DA863;
        Sat,  2 Mar 2019 19:35:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CFF5A4265A2F;
        Sat,  2 Mar 2019 19:35:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/29] netfilter: nat: move nlattr parse and xfrm session decode to core
Date:   Sat,  2 Mar 2019 19:34:33 +0100
Message-Id: <20190302183457.3079-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

None of these functions calls any external functions, moving them allows
to avoid both the indirection and a need to export these symbols.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_nat_l3proto.h   |   9 --
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |  58 -------------
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |  60 -------------
 net/netfilter/nf_nat_core.c              | 142 ++++++++++++++++++++++++++-----
 4 files changed, 123 insertions(+), 146 deletions(-)

diff --git a/include/net/netfilter/nf_nat_l3proto.h b/include/net/netfilter/nf_nat_l3proto.h
index d774ca0c4c5e..100972bbd9ad 100644
--- a/include/net/netfilter/nf_nat_l3proto.h
+++ b/include/net/netfilter/nf_nat_l3proto.h
@@ -18,15 +18,6 @@ struct nf_nat_l3proto {
 	void	(*csum_recalc)(struct sk_buff *skb, u8 proto,
 			       void *data, __sum16 *check,
 			       int datalen, int oldlen);
-
-	void	(*decode_session)(struct sk_buff *skb,
-				  const struct nf_conn *ct,
-				  enum ip_conntrack_dir dir,
-				  unsigned long statusbit,
-				  struct flowi *fl);
-
-	int	(*nlattr_to_range)(struct nlattr *tb[],
-				   struct nf_nat_range2 *range);
 };
 
 int nf_nat_l3proto_register(const struct nf_nat_l3proto *);
diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 4b07eb8a9b18..36b4f9659ffa 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -28,40 +28,6 @@
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4;
 
-#ifdef CONFIG_XFRM
-static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
-				       const struct nf_conn *ct,
-				       enum ip_conntrack_dir dir,
-				       unsigned long statusbit,
-				       struct flowi *fl)
-{
-	const struct nf_conntrack_tuple *t = &ct->tuplehash[dir].tuple;
-	struct flowi4 *fl4 = &fl->u.ip4;
-
-	if (ct->status & statusbit) {
-		fl4->daddr = t->dst.u3.ip;
-		if (t->dst.protonum == IPPROTO_TCP ||
-		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
-		    t->dst.protonum == IPPROTO_DCCP ||
-		    t->dst.protonum == IPPROTO_SCTP)
-			fl4->fl4_dport = t->dst.u.all;
-	}
-
-	statusbit ^= IPS_NAT_MASK;
-
-	if (ct->status & statusbit) {
-		fl4->saddr = t->src.u3.ip;
-		if (t->dst.protonum == IPPROTO_TCP ||
-		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
-		    t->dst.protonum == IPPROTO_DCCP ||
-		    t->dst.protonum == IPPROTO_SCTP)
-			fl4->fl4_sport = t->src.u.all;
-	}
-}
-#endif /* CONFIG_XFRM */
-
 static bool nf_nat_ipv4_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
 				  const struct nf_conntrack_tuple *target,
@@ -127,35 +93,11 @@ static void nf_nat_ipv4_csum_recalc(struct sk_buff *skb,
 					 htons(oldlen), htons(datalen), true);
 }
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-static int nf_nat_ipv4_nlattr_to_range(struct nlattr *tb[],
-				       struct nf_nat_range2 *range)
-{
-	if (tb[CTA_NAT_V4_MINIP]) {
-		range->min_addr.ip = nla_get_be32(tb[CTA_NAT_V4_MINIP]);
-		range->flags |= NF_NAT_RANGE_MAP_IPS;
-	}
-
-	if (tb[CTA_NAT_V4_MAXIP])
-		range->max_addr.ip = nla_get_be32(tb[CTA_NAT_V4_MAXIP]);
-	else
-		range->max_addr.ip = range->min_addr.ip;
-
-	return 0;
-}
-#endif
-
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv4 = {
 	.l3proto		= NFPROTO_IPV4,
 	.manip_pkt		= nf_nat_ipv4_manip_pkt,
 	.csum_update		= nf_nat_ipv4_csum_update,
 	.csum_recalc		= nf_nat_ipv4_csum_recalc,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_ipv4_nlattr_to_range,
-#endif
-#ifdef CONFIG_XFRM
-	.decode_session		= nf_nat_ipv4_decode_session,
-#endif
 };
 
 int nf_nat_icmp_reply_translation(struct sk_buff *skb,
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index 490bfd3c9162..5d667cf9bab8 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -28,40 +28,6 @@
 
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6;
 
-#ifdef CONFIG_XFRM
-static void nf_nat_ipv6_decode_session(struct sk_buff *skb,
-				       const struct nf_conn *ct,
-				       enum ip_conntrack_dir dir,
-				       unsigned long statusbit,
-				       struct flowi *fl)
-{
-	const struct nf_conntrack_tuple *t = &ct->tuplehash[dir].tuple;
-	struct flowi6 *fl6 = &fl->u.ip6;
-
-	if (ct->status & statusbit) {
-		fl6->daddr = t->dst.u3.in6;
-		if (t->dst.protonum == IPPROTO_TCP ||
-		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
-		    t->dst.protonum == IPPROTO_DCCP ||
-		    t->dst.protonum == IPPROTO_SCTP)
-			fl6->fl6_dport = t->dst.u.all;
-	}
-
-	statusbit ^= IPS_NAT_MASK;
-
-	if (ct->status & statusbit) {
-		fl6->saddr = t->src.u3.in6;
-		if (t->dst.protonum == IPPROTO_TCP ||
-		    t->dst.protonum == IPPROTO_UDP ||
-		    t->dst.protonum == IPPROTO_UDPLITE ||
-		    t->dst.protonum == IPPROTO_DCCP ||
-		    t->dst.protonum == IPPROTO_SCTP)
-			fl6->fl6_sport = t->src.u.all;
-	}
-}
-#endif
-
 static bool nf_nat_ipv6_manip_pkt(struct sk_buff *skb,
 				  unsigned int iphdroff,
 				  const struct nf_conntrack_tuple *target,
@@ -136,37 +102,11 @@ static void nf_nat_ipv6_csum_recalc(struct sk_buff *skb,
 					 htons(oldlen), htons(datalen), true);
 }
 
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-static int nf_nat_ipv6_nlattr_to_range(struct nlattr *tb[],
-				       struct nf_nat_range2 *range)
-{
-	if (tb[CTA_NAT_V6_MINIP]) {
-		nla_memcpy(&range->min_addr.ip6, tb[CTA_NAT_V6_MINIP],
-			   sizeof(struct in6_addr));
-		range->flags |= NF_NAT_RANGE_MAP_IPS;
-	}
-
-	if (tb[CTA_NAT_V6_MAXIP])
-		nla_memcpy(&range->max_addr.ip6, tb[CTA_NAT_V6_MAXIP],
-			   sizeof(struct in6_addr));
-	else
-		range->max_addr = range->min_addr;
-
-	return 0;
-}
-#endif
-
 static const struct nf_nat_l3proto nf_nat_l3proto_ipv6 = {
 	.l3proto		= NFPROTO_IPV6,
 	.manip_pkt		= nf_nat_ipv6_manip_pkt,
 	.csum_update		= nf_nat_ipv6_csum_update,
 	.csum_recalc		= nf_nat_ipv6_csum_recalc,
-#if IS_ENABLED(CONFIG_NF_CT_NETLINK)
-	.nlattr_to_range	= nf_nat_ipv6_nlattr_to_range,
-#endif
-#ifdef CONFIG_XFRM
-	.decode_session	= nf_nat_ipv6_decode_session,
-#endif
 };
 
 int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 35e61038ae96..0f39ae7a9f34 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -65,9 +65,74 @@ __nf_nat_l3proto_find(u8 family)
 }
 
 #ifdef CONFIG_XFRM
+static void nf_nat_ipv4_decode_session(struct sk_buff *skb,
+				       const struct nf_conn *ct,
+				       enum ip_conntrack_dir dir,
+				       unsigned long statusbit,
+				       struct flowi *fl)
+{
+	const struct nf_conntrack_tuple *t = &ct->tuplehash[dir].tuple;
+	struct flowi4 *fl4 = &fl->u.ip4;
+
+	if (ct->status & statusbit) {
+		fl4->daddr = t->dst.u3.ip;
+		if (t->dst.protonum == IPPROTO_TCP ||
+		    t->dst.protonum == IPPROTO_UDP ||
+		    t->dst.protonum == IPPROTO_UDPLITE ||
+		    t->dst.protonum == IPPROTO_DCCP ||
+		    t->dst.protonum == IPPROTO_SCTP)
+			fl4->fl4_dport = t->dst.u.all;
+	}
+
+	statusbit ^= IPS_NAT_MASK;
+
+	if (ct->status & statusbit) {
+		fl4->saddr = t->src.u3.ip;
+		if (t->dst.protonum == IPPROTO_TCP ||
+		    t->dst.protonum == IPPROTO_UDP ||
+		    t->dst.protonum == IPPROTO_UDPLITE ||
+		    t->dst.protonum == IPPROTO_DCCP ||
+		    t->dst.protonum == IPPROTO_SCTP)
+			fl4->fl4_sport = t->src.u.all;
+	}
+}
+
+static void nf_nat_ipv6_decode_session(struct sk_buff *skb,
+				       const struct nf_conn *ct,
+				       enum ip_conntrack_dir dir,
+				       unsigned long statusbit,
+				       struct flowi *fl)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	const struct nf_conntrack_tuple *t = &ct->tuplehash[dir].tuple;
+	struct flowi6 *fl6 = &fl->u.ip6;
+
+	if (ct->status & statusbit) {
+		fl6->daddr = t->dst.u3.in6;
+		if (t->dst.protonum == IPPROTO_TCP ||
+		    t->dst.protonum == IPPROTO_UDP ||
+		    t->dst.protonum == IPPROTO_UDPLITE ||
+		    t->dst.protonum == IPPROTO_DCCP ||
+		    t->dst.protonum == IPPROTO_SCTP)
+			fl6->fl6_dport = t->dst.u.all;
+	}
+
+	statusbit ^= IPS_NAT_MASK;
+
+	if (ct->status & statusbit) {
+		fl6->saddr = t->src.u3.in6;
+		if (t->dst.protonum == IPPROTO_TCP ||
+		    t->dst.protonum == IPPROTO_UDP ||
+		    t->dst.protonum == IPPROTO_UDPLITE ||
+		    t->dst.protonum == IPPROTO_DCCP ||
+		    t->dst.protonum == IPPROTO_SCTP)
+			fl6->fl6_sport = t->src.u.all;
+	}
+#endif
+}
+
 static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {
-	const struct nf_nat_l3proto *l3proto;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	enum ip_conntrack_dir dir;
@@ -79,17 +144,20 @@ static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		return;
 
 	family = nf_ct_l3num(ct);
-	l3proto = __nf_nat_l3proto_find(family);
-	if (l3proto == NULL)
-		return;
-
 	dir = CTINFO2DIR(ctinfo);
 	if (dir == IP_CT_DIR_ORIGINAL)
 		statusbit = IPS_DST_NAT;
 	else
 		statusbit = IPS_SRC_NAT;
 
-	l3proto->decode_session(skb, ct, dir, statusbit, fl);
+	switch (family) {
+	case NFPROTO_IPV4:
+		nf_nat_ipv4_decode_session(skb, ct, dir, statusbit, fl);
+		return;
+	case NFPROTO_IPV6:
+		nf_nat_ipv6_decode_session(skb, ct, dir, statusbit, fl);
+		return;
+	}
 }
 
 int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
@@ -887,10 +955,43 @@ static const struct nla_policy nat_nla_policy[CTA_NAT_MAX+1] = {
 	[CTA_NAT_PROTO]		= { .type = NLA_NESTED },
 };
 
+static int nf_nat_ipv4_nlattr_to_range(struct nlattr *tb[],
+				       struct nf_nat_range2 *range)
+{
+	if (tb[CTA_NAT_V4_MINIP]) {
+		range->min_addr.ip = nla_get_be32(tb[CTA_NAT_V4_MINIP]);
+		range->flags |= NF_NAT_RANGE_MAP_IPS;
+	}
+
+	if (tb[CTA_NAT_V4_MAXIP])
+		range->max_addr.ip = nla_get_be32(tb[CTA_NAT_V4_MAXIP]);
+	else
+		range->max_addr.ip = range->min_addr.ip;
+
+	return 0;
+}
+
+static int nf_nat_ipv6_nlattr_to_range(struct nlattr *tb[],
+				       struct nf_nat_range2 *range)
+{
+	if (tb[CTA_NAT_V6_MINIP]) {
+		nla_memcpy(&range->min_addr.ip6, tb[CTA_NAT_V6_MINIP],
+			   sizeof(struct in6_addr));
+		range->flags |= NF_NAT_RANGE_MAP_IPS;
+	}
+
+	if (tb[CTA_NAT_V6_MAXIP])
+		nla_memcpy(&range->max_addr.ip6, tb[CTA_NAT_V6_MAXIP],
+			   sizeof(struct in6_addr));
+	else
+		range->max_addr = range->min_addr;
+
+	return 0;
+}
+
 static int
 nfnetlink_parse_nat(const struct nlattr *nat,
-		    const struct nf_conn *ct, struct nf_nat_range2 *range,
-		    const struct nf_nat_l3proto *l3proto)
+		    const struct nf_conn *ct, struct nf_nat_range2 *range)
 {
 	struct nlattr *tb[CTA_NAT_MAX+1];
 	int err;
@@ -901,8 +1002,19 @@ nfnetlink_parse_nat(const struct nlattr *nat,
 	if (err < 0)
 		return err;
 
-	err = l3proto->nlattr_to_range(tb, range);
-	if (err < 0)
+	switch (nf_ct_l3num(ct)) {
+	case NFPROTO_IPV4:
+		err = nf_nat_ipv4_nlattr_to_range(tb, range);
+		break;
+	case NFPROTO_IPV6:
+		err = nf_nat_ipv6_nlattr_to_range(tb, range);
+		break;
+	default:
+		err = -EPROTONOSUPPORT;
+		break;
+	}
+
+	if (err)
 		return err;
 
 	if (!tb[CTA_NAT_PROTO])
@@ -918,7 +1030,6 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 			  const struct nlattr *attr)
 {
 	struct nf_nat_range2 range;
-	const struct nf_nat_l3proto *l3proto;
 	int err;
 
 	/* Should not happen, restricted to creating new conntracks
@@ -927,18 +1038,11 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (WARN_ON_ONCE(nf_nat_initialized(ct, manip)))
 		return -EEXIST;
 
-	/* Make sure that L3 NAT is there by when we call nf_nat_setup_info to
-	 * attach the null binding, otherwise this may oops.
-	 */
-	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
-	if (l3proto == NULL)
-		return -EAGAIN;
-
 	/* No NAT information has been passed, allocate the null-binding */
 	if (attr == NULL)
 		return __nf_nat_alloc_null_binding(ct, manip) == NF_DROP ? -ENOMEM : 0;
 
-	err = nfnetlink_parse_nat(attr, ct, &range, l3proto);
+	err = nfnetlink_parse_nat(attr, ct, &range);
 	if (err < 0)
 		return err;
 
-- 
2.11.0


