Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E28C2D0CD
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE0D42146E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfLQL1c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:27:32 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57326 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727528AbfLQL1c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:32 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB0k-0006kR-PM; Tue, 17 Dec 2019 12:27:30 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 03/10] proto: add proto_desc_id enumeration
Date:   Tue, 17 Dec 2019 12:27:06 +0100
Message-Id: <20191217112713.6017-4-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

This allows to uniquely identify the protocol description.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/proto.h | 27 +++++++++++++++++++++++++++
 src/proto.c     | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/proto.h b/include/proto.h
index fab48c1bb30c..1771ba8e8d8c 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -63,10 +63,34 @@ struct proto_hdr_template {
 #define PROTO_UPPER_MAX		16
 #define PROTO_HDRS_MAX		20
 
+enum proto_desc_id {
+	PROTO_DESC_UNKNOWN	= 0,
+	PROTO_DESC_AH,
+	PROTO_DESC_ESP,
+	PROTO_DESC_COMP,
+	PROTO_DESC_ICMP,
+	PROTO_DESC_IGMP,
+	PROTO_DESC_UDP,
+	PROTO_DESC_UDPLITE,
+	PROTO_DESC_TCP,
+	PROTO_DESC_DCCP,
+	PROTO_DESC_SCTP,
+	PROTO_DESC_TH,
+	PROTO_DESC_IP,
+	PROTO_DESC_IP6,
+	PROTO_DESC_ICMPV6,
+	PROTO_DESC_ARP,
+	PROTO_DESC_VLAN,
+	PROTO_DESC_ETHER,
+	__PROTO_DESC_MAX
+};
+#define PROTO_DESC_MAX	(__PROTO_DESC_MAX - 1)
+
 /**
  * struct proto_desc - protocol header description
  *
  * @name:	protocol name
+ * @id:		protocol identifier
  * @base:	header base
  * @checksum_key: key of template containing checksum
  * @protocol_key: key of template containing upper layer protocol description
@@ -77,6 +101,7 @@ struct proto_hdr_template {
  */
 struct proto_desc {
 	const char			*name;
+	enum proto_desc_id		id;
 	enum proto_bases		base;
 	unsigned int			checksum_key;
 	unsigned int			protocol_key;
@@ -160,6 +185,8 @@ extern const struct proto_desc *proto_find_upper(const struct proto_desc *base,
 extern int proto_find_num(const struct proto_desc *base,
 			  const struct proto_desc *desc);
 
+extern const struct proto_desc *proto_find_desc(enum proto_desc_id desc_id);
+
 enum eth_hdr_fields {
 	ETHHDR_INVALID,
 	ETHHDR_DADDR,
diff --git a/src/proto.c b/src/proto.c
index 40ce590efd12..7d001501d7d2 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -227,6 +227,7 @@ void proto_ctx_update(struct proto_ctx *ctx, enum proto_bases base,
 
 const struct proto_desc proto_ah = {
 	.name		= "ah",
+	.id		= PROTO_DESC_AH,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.protocol_key	= AHHDR_NEXTHDR,
 	.protocols	= {
@@ -263,6 +264,7 @@ const struct proto_desc proto_ah = {
 
 const struct proto_desc proto_esp = {
 	.name		= "esp",
+	.id		= PROTO_DESC_ESP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.templates	= {
 		[ESPHDR_SPI]		= ESPHDR_FIELD("spi", spi),
@@ -279,6 +281,7 @@ const struct proto_desc proto_esp = {
 
 const struct proto_desc proto_comp = {
 	.name		= "comp",
+	.id		= PROTO_DESC_COMP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.protocol_key	= COMPHDR_NEXTHDR,
 	.protocols	= {
@@ -343,6 +346,7 @@ const struct datatype icmp_type_type = {
 
 const struct proto_desc proto_icmp = {
 	.name		= "icmp",
+	.id		= PROTO_DESC_ICMP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.checksum_key	= ICMPHDR_CHECKSUM,
 	.templates	= {
@@ -395,6 +399,7 @@ const struct datatype igmp_type_type = {
 
 const struct proto_desc proto_igmp = {
 	.name		= "igmp",
+	.id		= PROTO_DESC_IGMP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.checksum_key	= IGMPHDR_CHECKSUM,
 	.templates	= {
@@ -415,6 +420,7 @@ const struct proto_desc proto_igmp = {
 
 const struct proto_desc proto_udp = {
 	.name		= "udp",
+	.id		= PROTO_DESC_UDP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.checksum_key	= UDPHDR_CHECKSUM,
 	.templates	= {
@@ -427,6 +433,7 @@ const struct proto_desc proto_udp = {
 
 const struct proto_desc proto_udplite = {
 	.name		= "udplite",
+	.id		= PROTO_DESC_UDPLITE,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.templates	= {
 		[UDPHDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
@@ -472,6 +479,7 @@ const struct datatype tcp_flag_type = {
 
 const struct proto_desc proto_tcp = {
 	.name		= "tcp",
+	.id		= PROTO_DESC_TCP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.checksum_key	= TCPHDR_CHECKSUM,
 	.templates	= {
@@ -534,6 +542,7 @@ const struct datatype dccp_pkttype_type = {
 
 const struct proto_desc proto_dccp = {
 	.name		= "dccp",
+	.id		= PROTO_DESC_DCCP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.templates	= {
 		[DCCPHDR_SPORT]		= INET_SERVICE("sport", struct dccp_hdr, dccph_sport),
@@ -552,6 +561,7 @@ const struct proto_desc proto_dccp = {
 
 const struct proto_desc proto_sctp = {
 	.name		= "sctp",
+	.id		= PROTO_DESC_SCTP,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.templates	= {
 		[SCTPHDR_SPORT]		= INET_SERVICE("sport", struct sctphdr, source),
@@ -566,6 +576,7 @@ const struct proto_desc proto_sctp = {
  */
 const struct proto_desc proto_th = {
 	.name		= "th",
+	.id		= PROTO_DESC_TH,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.templates	= {
 		[THDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
@@ -648,6 +659,7 @@ const struct datatype ecn_type = {
 
 const struct proto_desc proto_ip = {
 	.name		= "ip",
+	.id		= PROTO_DESC_IP,
 	.base		= PROTO_BASE_NETWORK_HDR,
 	.checksum_key	= IPHDR_CHECKSUM,
 	.protocols	= {
@@ -744,6 +756,7 @@ const struct datatype icmp6_type_type = {
 
 const struct proto_desc proto_icmp6 = {
 	.name		= "icmpv6",
+	.id		= PROTO_DESC_ICMPV6,
 	.base		= PROTO_BASE_TRANSPORT_HDR,
 	.checksum_key	= ICMP6HDR_CHECKSUM,
 	.templates	= {
@@ -771,6 +784,7 @@ const struct proto_desc proto_icmp6 = {
 
 const struct proto_desc proto_ip6 = {
 	.name		= "ip6",
+	.id		= PROTO_DESC_IP6,
 	.base		= PROTO_BASE_NETWORK_HDR,
 	.protocols	= {
 		PROTO_LINK(IPPROTO_ESP,		&proto_esp),
@@ -892,6 +906,7 @@ const struct datatype arpop_type = {
 
 const struct proto_desc proto_arp = {
 	.name		= "arp",
+	.id		= PROTO_DESC_ARP,
 	.base		= PROTO_BASE_NETWORK_HDR,
 	.templates	= {
 		[ARPHDR_HRD]		= ARPHDR_FIELD("htype",	htype),
@@ -925,6 +940,7 @@ const struct proto_desc proto_arp = {
 
 const struct proto_desc proto_vlan = {
 	.name		= "vlan",
+	.id		= PROTO_DESC_VLAN,
 	.base		= PROTO_BASE_LL_HDR,
 	.protocol_key	= VLANHDR_TYPE,
 	.length		= sizeof(struct vlan_hdr) * BITS_PER_BYTE,
@@ -996,6 +1012,7 @@ const struct datatype ethertype_type = {
 
 const struct proto_desc proto_eth = {
 	.name		= "ether",
+	.id		= PROTO_DESC_ETHER,
 	.base		= PROTO_BASE_LL_HDR,
 	.protocol_key	= ETHHDR_TYPE,
 	.length		= sizeof(struct ether_header) * BITS_PER_BYTE,
@@ -1034,3 +1051,32 @@ const struct proto_desc proto_netdev = {
 		[0]	= PROTO_META_TEMPLATE("protocol", &ethertype_type, NFT_META_PROTOCOL, 16),
 	},
 };
+
+static const struct proto_desc *proto_definitions[PROTO_DESC_MAX + 1] = {
+	[PROTO_DESC_AH]		= &proto_ah,
+	[PROTO_DESC_ESP]	= &proto_esp,
+	[PROTO_DESC_COMP]	= &proto_comp,
+	[PROTO_DESC_ICMP]	= &proto_icmp,
+	[PROTO_DESC_IGMP]	= &proto_igmp,
+	[PROTO_DESC_UDP]	= &proto_udp,
+	[PROTO_DESC_UDPLITE]	= &proto_udplite,
+	[PROTO_DESC_TCP]	= &proto_tcp,
+	[PROTO_DESC_DCCP]	= &proto_dccp,
+	[PROTO_DESC_SCTP]	= &proto_sctp,
+	[PROTO_DESC_TH]		= &proto_th,
+	[PROTO_DESC_IP]		= &proto_ip,
+	[PROTO_DESC_IP6]	= &proto_ip6,
+	[PROTO_DESC_ICMPV6]	= &proto_icmp6,
+	[PROTO_DESC_ARP]	= &proto_arp,
+	[PROTO_DESC_VLAN]	= &proto_vlan,
+	[PROTO_DESC_ETHER]	= &proto_eth,
+};
+
+const struct proto_desc *proto_find_desc(enum proto_desc_id desc_id)
+{
+	if (desc_id >= PROTO_DESC_UNKNOWN &&
+	    desc_id <= PROTO_DESC_MAX)
+		return proto_definitions[desc_id];
+
+	return NULL;
+}
-- 
2.24.1

