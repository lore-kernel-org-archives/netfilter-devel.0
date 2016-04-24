From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH nft 5/6] proto: add protocol header fields filter and ordering for packet decoding
Date: Sun, 24 Apr 2016 22:30:39 +0100
Message-ID: <1461533440-10605-6-git-send-email-kaber@trash.net>
References: <1461533440-10605-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52079 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbcDXVjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 17:39:20 -0400
In-Reply-To: <1461533440-10605-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The next patch introduces packet decoding for tracing messages based on
the proto definitions. In order to provide a readable output, add a filter
to surpress uninteresting header fields and allow to specify and explicit
output order.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/proto.h |  5 +++++
 src/proto.c     | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/include/proto.h b/include/proto.h
index c252a67..2a662a1 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -85,6 +85,11 @@ struct proto_desc {
 		const struct proto_desc		*desc;
 	}				protocols[PROTO_UPPER_MAX];
 	struct proto_hdr_template	templates[PROTO_HDRS_MAX];
+	struct {
+		uint8_t				order[PROTO_HDRS_MAX];
+		uint32_t			filter;
+	}				format;
+
 };
 
 #define PROTO_LINK(__num, __desc)	{ .num = (__num), .desc = (__desc), }
diff --git a/src/proto.c b/src/proto.c
index 329d991..cecde0f 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -244,6 +244,12 @@ const struct proto_desc proto_ah = {
 		[AHHDR_SPI]		= AHHDR_FIELD("spi", spi),
 		[AHHDR_SEQUENCE]	= AHHDR_FIELD("sequence", seq_no),
 	},
+	.format		= {
+		.order	= {
+			AHHDR_SPI, AHHDR_HDRLENGTH, AHHDR_NEXTHDR,
+		},
+		.filter	= (1 << AHHDR_RESERVED) | (1 << AHHDR_SEQUENCE)
+	},
 };
 
 /*
@@ -431,6 +437,11 @@ const struct proto_desc proto_tcp = {
 		[TCPHDR_CHECKSUM]	= TCPHDR_FIELD("checksum", check),
 		[TCPHDR_URGPTR]		= TCPHDR_FIELD("urgptr", urg_ptr),
 	},
+	.format		= {
+		.filter	= (1 << TCPHDR_SEQ) | (1 << TCPHDR_ACKSEQ) |
+			  (1 << TCPHDR_DOFF) | (1 << TCPHDR_RESERVED) |
+			  (1 << TCPHDR_URGPTR),
+	},
 };
 
 /*
@@ -535,6 +546,14 @@ const struct proto_desc proto_ip = {
 		[IPHDR_SADDR]		= IPHDR_ADDR("saddr",		saddr),
 		[IPHDR_DADDR]		= IPHDR_ADDR("daddr",		daddr),
 	},
+	.format		= {
+		.order	= {
+			IPHDR_SADDR, IPHDR_DADDR, IPHDR_TOS, IPHDR_TTL,
+			IPHDR_ID, IPHDR_PROTOCOL, IPHDR_LENGTH,
+		},
+		.filter	= (1 << IPHDR_VERSION)  | (1 << IPHDR_HDRLENGTH) |
+			  (1 << IPHDR_FRAG_OFF),
+	},
 };
 
 /*
@@ -631,6 +650,14 @@ const struct proto_desc proto_ip6 = {
 		[IP6HDR_SADDR]		= IP6HDR_ADDR("saddr",		saddr),
 		[IP6HDR_DADDR]		= IP6HDR_ADDR("daddr",		daddr),
 	},
+	.format		= {
+		.order	= {
+			IP6HDR_SADDR, IP6HDR_DADDR, IP6HDR_PRIORITY,
+			IP6HDR_HOPLIMIT, IP6HDR_FLOWLABEL, IP6HDR_NEXTHDR,
+			IP6HDR_LENGTH,
+		},
+		.filter	= (1 << IP6HDR_VERSION),
+	},
 };
 
 /*
@@ -719,6 +746,10 @@ const struct proto_desc proto_arp = {
 		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
 		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
 	},
+	.format		= {
+		.filter	= (1 << ARPHDR_HRD) | (1 << ARPHDR_PRO) |
+			  (1 << ARPHDR_HLN) | (1 << ARPHDR_PLN),
+	},
 };
 
 /*
@@ -818,6 +849,12 @@ const struct proto_desc proto_eth = {
 		[ETHHDR_SADDR]		= ETHHDR_ADDR("saddr", ether_shost),
 		[ETHHDR_TYPE]		= ETHHDR_TYPE("type", ether_type),
 	},
+	.format		= {
+		.order	= {
+			ETHHDR_SADDR, ETHHDR_DADDR, ETHHDR_TYPE,
+		},
+	},
+
 };
 
 /*
-- 
2.5.5

