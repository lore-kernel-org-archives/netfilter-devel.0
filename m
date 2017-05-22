From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/4 RFC] exthdr: Define AH header description
Date: Mon, 22 May 2017 18:49:35 +0200
Message-ID: <20170522164936.28034-4-phil@nwl.cc>
References: <20170522164936.28034-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56473 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964795AbdEVQuB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2017 12:50:01 -0400
In-Reply-To: <20170522164936.28034-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is not directly used from parsing stage since AH header match is
defined there as payload expression. Instead it will be used when
converting that payload expression into an exthdr one for IPv6.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/exthdr.h |  1 +
 src/exthdr.c     | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/exthdr.h b/include/exthdr.h
index a5522ea5b5e5d..0f9c17222a47a 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -89,5 +89,6 @@ extern const struct exthdr_desc exthdr_rt2;
 extern const struct exthdr_desc exthdr_frag;
 extern const struct exthdr_desc exthdr_dst;
 extern const struct exthdr_desc exthdr_mh;
+extern const struct exthdr_desc exthdr_ah;
 
 #endif /* NFTABLES_EXTHDR_H */
diff --git a/src/exthdr.c b/src/exthdr.c
index c8599f233132a..c08b39a0ee8d2 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -104,6 +104,7 @@ static const struct exthdr_desc *exthdr_protocols[IPPROTO_MAX] = {
 	[IPPROTO_FRAGMENT]	= &exthdr_frag,
 	[IPPROTO_DSTOPTS]	= &exthdr_dst,
 	[IPPROTO_MH]		= &exthdr_mh,
+	[IPPROTO_AH]		= &exthdr_ah,
 };
 
 const struct exthdr_desc *exthdr_find_proto(uint8_t proto)
@@ -344,6 +345,21 @@ const struct exthdr_desc exthdr_mh = {
 	},
 };
 
+#define AH_FIELD(__name, __member, __dtype) \
+	HDR_TEMPLATE(__name, __dtype, struct ip_auth_hdr, __member)
+
+const struct exthdr_desc exthdr_ah = {
+	.name		= "ah",
+	.type		= IPPROTO_AH,
+	.templates	= {
+		[AHHDR_NEXTHDR]		= AH_FIELD("nexthdr", nexthdr, &inet_protocol_type),
+		[AHHDR_HDRLENGTH]	= AH_FIELD("hdrlength", hdrlen, &integer_type),
+		[AHHDR_RESERVED]	= AH_FIELD("reserved", reserved, &integer_type),
+		[AHHDR_SPI]		= AH_FIELD("spi", spi, &integer_type),
+		[AHHDR_SEQUENCE]	= AH_FIELD("sequence", seq_no, &integer_type),
+	},
+};
+
 static void __init exthdr_init(void)
 {
 	datatype_register(&mh_type_type);
-- 
2.11.0

