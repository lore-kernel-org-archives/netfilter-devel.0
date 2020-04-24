Return-Path: <SRS0=g4y9=6I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53263C54FD0
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CAC420781
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Apr 2020 19:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgDXTzs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 15:55:48 -0400
Received: from correo.us.es ([193.147.175.20]:46116 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729404AbgDXTzs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 15:55:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C29DD28D1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D900BAAA3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 033ACDA736; Fri, 24 Apr 2020 21:55:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A86BBAAB1
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 Apr 2020 21:55:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EAF6742EF4E0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2020 21:55:43 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 5/5] netfilter: nft_nat: add netmap support
Date:   Fri, 24 Apr 2020 21:55:37 +0200
Message-Id: <20200424195537.23975-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424195537.23975-1-pablo@netfilter.org>
References: <20200424195537.23975-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to NAT the network address prefix onto another
network address prefix, a.k.a. netmapping.

Userspace must specify the NF_NAT_RANGE_NETMAP flag and the prefix
address through the NFTA_NAT_REG_ADDR_MIN and NFTA_NAT_REG_ADDR_MAX
netlink attributes.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_nat.h |  4 ++-
 net/netfilter/nft_nat.c               | 46 ++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/netfilter/nf_nat.h
index 4a95c0db14d4..a64586e77b24 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -11,6 +11,7 @@
 #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
 #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
 #define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
+#define NF_NAT_RANGE_NETMAP			(1 << 6)
 
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -18,7 +19,8 @@
 #define NF_NAT_RANGE_MASK					\
 	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
 	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
-	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET)
+	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET | \
+	 NF_NAT_RANGE_NETMAP)
 
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 7442aa8b1555..23a7bfd10521 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -60,6 +60,46 @@ static void nft_nat_setup_proto(struct nf_nat_range2 *range,
 		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
 }
 
+static void nft_nat_setup_netmap(struct nf_nat_range2 *range,
+				 const struct nft_pktinfo *pkt,
+				 const struct nft_nat *priv)
+{
+	struct sk_buff *skb = pkt->skb;
+	union nf_inet_addr new_addr;
+	__be32 netmask;
+	int i, len = 0;
+
+	switch (priv->type) {
+	case NFT_NAT_SNAT:
+		if (nft_pf(pkt) == NFPROTO_IPV4) {
+			new_addr.ip = ip_hdr(skb)->saddr;
+			len = sizeof(struct in_addr);
+		} else {
+			new_addr.in6 = ipv6_hdr(skb)->saddr;
+			len = sizeof(struct in6_addr);
+		}
+		break;
+	case NFT_NAT_DNAT:
+		if (nft_pf(pkt) == NFPROTO_IPV4) {
+			new_addr.ip = ip_hdr(skb)->daddr;
+			len = sizeof(struct in_addr);
+		} else {
+			new_addr.in6 = ipv6_hdr(skb)->daddr;
+			len = sizeof(struct in6_addr);
+		}
+		break;
+	}
+
+	for (i = 0; i < len / sizeof(__be32); i++) {
+		netmask = ~(range->min_addr.ip6[i] ^ range->max_addr.ip6[i]);
+		new_addr.ip6[i] &= ~netmask;
+		new_addr.ip6[i] |= range->min_addr.ip6[i] & netmask;
+	}
+
+	range->min_addr = new_addr;
+	range->max_addr = new_addr;
+}
+
 static void nft_nat_eval(const struct nft_expr *expr,
 			 struct nft_regs *regs,
 			 const struct nft_pktinfo *pkt)
@@ -70,8 +110,12 @@ static void nft_nat_eval(const struct nft_expr *expr,
 	struct nf_nat_range2 range;
 
 	memset(&range, 0, sizeof(range));
-	if (priv->sreg_addr_min)
+
+	if (priv->sreg_addr_min) {
 		nft_nat_setup_addr(&range, regs, priv);
+		if (priv->flags & NF_NAT_RANGE_NETMAP)
+			nft_nat_setup_netmap(&range, pkt, priv);
+	}
 
 	if (priv->sreg_proto_min)
 		nft_nat_setup_proto(&range, regs, priv);
-- 
2.20.1

