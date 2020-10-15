Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE28C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 16:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4054E21D7F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 16:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbgJOQRG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 12:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388461AbgJOQRG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 12:17:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52DDC061755
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 09:17:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kT5w7-0001PA-Pt; Thu, 15 Oct 2020 18:17:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nftables: allow re-computing sctp CRC-32C in 'payload' statements
Date:   Thu, 15 Oct 2020 18:16:51 +0200
Message-Id: <20201015161651.4902-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

nftables payload statements are used to mangle SCTP headers, but they can
only replace the Internet Checksum. As a consequence, nftables rules that
mangle sport/dport/vtag in SCTP headers potentially generate packets that
are discarded by the receiver, unless the CRC-32C is "offloaded" (e.g the
rule mangles a skb having 'ip_summed' equal to 'CHECKSUM_PARTIAL'.

Fix this extending uAPI definitions and L4 checksum update function, in a
way that userspace programs (e.g. nft) can instruct the kernel to compute
CRC-32C in SCTP headers. Also ensure that LIBCRC32C is built if NF_TABLES
is 'y' or 'm' in the kernel build configuration.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: I accidentally pushed the userspace side to nftables.git already,
 my bad.  Here is the kernel part.

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/Kconfig                    |  1 +
 net/netfilter/nft_payload.c              | 28 ++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 352ee51707a1..98272cb5f617 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -749,10 +749,12 @@ enum nft_payload_bases {
  *
  * @NFT_PAYLOAD_CSUM_NONE: no checksumming
  * @NFT_PAYLOAD_CSUM_INET: internet checksum (RFC 791)
+ * @NFT_PAYLOAD_CSUM_SCTP: CRC-32c, for use in SCTP header (RFC 3309)
  */
 enum nft_payload_csum_types {
 	NFT_PAYLOAD_CSUM_NONE,
 	NFT_PAYLOAD_CSUM_INET,
+	NFT_PAYLOAD_CSUM_SCTP,
 };
 
 enum nft_payload_csum_flags {
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 25313c29d799..52370211e46b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -441,6 +441,7 @@ endif # NF_CONNTRACK
 
 config NF_TABLES
 	select NETFILTER_NETLINK
+	select LIBCRC32C
 	tristate "Netfilter nf_tables support"
 	help
 	  nftables is the new packet classification framework that intends to
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 7a2e59638499..dcd3c7b8a367 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -22,6 +22,7 @@
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/sctp/checksum.h>
 
 static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
 					 struct vlan_ethhdr *veth)
@@ -484,6 +485,19 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
+static int nft_payload_csum_sctp(struct sk_buff *skb, int offset)
+{
+	struct sctphdr *sh;
+
+	if (skb_ensure_writable(skb, offset + sizeof(*sh)))
+		return -1;
+
+	sh = (struct sctphdr *)(skb->data + offset);
+	sh->checksum = sctp_compute_cksum(skb, offset);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	return 0;
+}
+
 static int nft_payload_l4csum_update(const struct nft_pktinfo *pkt,
 				     struct sk_buff *skb,
 				     __wsum fsum, __wsum tsum)
@@ -587,6 +601,13 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	    skb_store_bits(skb, offset, src, priv->len) < 0)
 		goto err;
 
+	if (priv->csum_type == NFT_PAYLOAD_CSUM_SCTP &&
+	    pkt->tprot == IPPROTO_SCTP &&
+	    skb->ip_summed != CHECKSUM_PARTIAL) {
+		if (nft_payload_csum_sctp(skb, pkt->xt.thoff))
+			goto err;
+	}
+
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
@@ -623,6 +644,13 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
+	case NFT_PAYLOAD_CSUM_SCTP:
+		if (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER)
+			return -EINVAL;
+
+		if (priv->csum_offset != offsetof(struct sctphdr, checksum))
+			return -EINVAL;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.26.2

