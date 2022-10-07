Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AE2C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Oct 2022 09:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJGJQe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 05:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJGJQT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 05:16:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7783CA0245
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Oct 2022 02:16:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 1/6] netfilter: nft_payload: access GRE payload via inner offset
Date:   Fri,  7 Oct 2022 11:16:09 +0200
Message-Id: <20221007091614.339582-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007091614.339582-1-pablo@netfilter.org>
References: <20221007091614.339582-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parse GRE packets to properly set up inner offset, this allow for
matching on inner headers. This includes support for GRE v0 and v1.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: handle GREv0 and GREv1.

 net/netfilter/nft_payload.c | 38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 99d971fc54ad..448e32750fa0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -19,6 +19,8 @@
 /* For layer 4 checksum field offset. */
 #include <linux/tcp.h>
 #include <linux/udp.h>
+#include <net/gre.h>
+#include <net/pptp.h>
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -100,6 +102,42 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
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
+				offset += sizeof_field(struct pptp_gre_header, seq);
+			break;
+		case GRE_VERSION_1:
+			offset += sizeof_field(struct pptp_gre_header, payload_len) +
+				  sizeof_field(struct pptp_gre_header, call_id);
+
+			if (gre->flags & GRE_SEQ)
+				offset += sizeof_field(struct pptp_gre_header, seq);
+
+			if (gre->flags & GRE_ACK)
+				offset += sizeof_field(struct pptp_gre_header, ack);
+			break;
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

