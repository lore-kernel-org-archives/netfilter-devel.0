Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B653C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Oct 2022 10:08:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiJJKIM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Oct 2022 06:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiJJKIK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Oct 2022 06:08:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D66565575
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Oct 2022 03:08:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v4 1/6] netfilter: nft_payload: access GRE payload via inner offset
Date:   Mon, 10 Oct 2022 12:08:03 +0200
Message-Id: <20221010100803.356322-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parse GRE v0 packets to properly set up inner offset, this allow for
matching on inner headers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: - add default case to deal with unsupported version.
    - use gre_full_hdr to get offset to seq field.
    - only gre v0 support at this stage.

This patch is the only update wrt. v3 series.

 net/netfilter/nft_payload.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 99d971fc54ad..dd8157c5723c 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -19,6 +19,7 @@
 /* For layer 4 checksum field offset. */
 #include <linux/tcp.h>
 #include <linux/udp.h>
+#include <net/gre.h>
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -100,6 +101,34 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
 		pkt->inneroff = thoff + __tcp_hdrlen(th);
 		}
 		break;
+	case IPPROTO_GRE: {
+		u32 offset = sizeof(struct gre_base_hdr), version;
+		struct gre_base_hdr *gre, _gre;
+
+		gre = skb_header_pointer(pkt->skb, thoff, sizeof(_gre), &_gre);
+		if (!gre)
+			return -1;
+
+		version = gre->flags & GRE_VERSION;
+		switch (version) {
+		case GRE_VERSION_0:
+			if (gre->flags & GRE_CSUM) {
+				offset += sizeof_field(struct gre_full_hdr, csum) +
+					  sizeof_field(struct gre_full_hdr, reserved1);
+			}
+			if (gre->flags & GRE_KEY)
+				offset += sizeof_field(struct gre_full_hdr, key);
+
+			if (gre->flags & GRE_SEQ)
+				offset += sizeof_field(struct gre_full_hdr, seq);
+			break;
+		default:
+			return -1;
+		}
+
+		pkt->inneroff = thoff + offset;
+		}
+		break;
 	default:
 		return -1;
 	}
-- 
2.30.2

