From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH v2 nft 1/2] proto: add checksum key information to struct proto_desc
Date: Tue, 24 Nov 2015 12:55:40 +0000
Message-ID: <1448369741-19622-2-git-send-email-kaber@trash.net>
References: <1448369741-19622-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45658 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753437AbbKXMzp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 07:55:45 -0500
In-Reply-To: <1448369741-19622-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The checksum key is used to determine the correct position where to update
the checksum for the payload statement.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/proto.h | 2 ++
 src/proto.c     | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/proto.h b/include/proto.h
index a43bf98..974116f 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -68,6 +68,7 @@ struct proto_hdr_template {
  *
  * @name:	protocol name
  * @base:	header base
+ * @checksum_key: key of template containing checksum
  * @protocol_key: key of template containing upper layer protocol description
  * @length:	total size of the header, in bits
  * @protocols:	link to upper layer protocol descriptions indexed by protocol value
@@ -76,6 +77,7 @@ struct proto_hdr_template {
 struct proto_desc {
 	const char			*name;
 	enum proto_bases		base;
+	unsigned int			checksum_key;
 	unsigned int			protocol_key;
 	unsigned int			length;
 	struct {
diff --git a/src/proto.c b/src/proto.c
index 28b93cb..89ec282 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -321,6 +321,7 @@ static const struct datatype icmp_type_type = {
 const struct proto_desc proto_icmp = {
 	.name		= "icmp",
 	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.checksum_key	= ICMPHDR_CHECKSUM,
 	.templates	= {
 		[ICMPHDR_TYPE]		= ICMPHDR_TYPE("type", &icmp_type_type, type),
 		[ICMPHDR_CODE]		= ICMPHDR_FIELD("code", code),
@@ -343,6 +344,7 @@ const struct proto_desc proto_icmp = {
 const struct proto_desc proto_udp = {
 	.name		= "udp",
 	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.checksum_key	= UDPHDR_CHECKSUM,
 	.templates	= {
 		[UDPHDR_SPORT]		= INET_SERVICE("sport", struct udphdr, source),
 		[UDPHDR_DPORT]		= INET_SERVICE("dport", struct udphdr, dest),
@@ -398,6 +400,7 @@ static const struct datatype tcp_flag_type = {
 const struct proto_desc proto_tcp = {
 	.name		= "tcp",
 	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.checksum_key	= TCPHDR_CHECKSUM,
 	.templates	= {
 		[TCPHDR_SPORT]		= INET_SERVICE("sport", struct tcphdr, source),
 		[TCPHDR_DPORT]		= INET_SERVICE("dport", struct tcphdr, dest),
@@ -491,6 +494,7 @@ const struct proto_desc proto_sctp = {
 const struct proto_desc proto_ip = {
 	.name		= "ip",
 	.base		= PROTO_BASE_NETWORK_HDR,
+	.checksum_key	= IPHDR_CHECKSUM,
 	.protocol_key	= IPHDR_PROTOCOL,
 	.protocols	= {
 		PROTO_LINK(IPPROTO_ICMP,	&proto_icmp),
@@ -563,6 +567,7 @@ static const struct datatype icmp6_type_type = {
 const struct proto_desc proto_icmp6 = {
 	.name		= "icmpv6",
 	.base		= PROTO_BASE_TRANSPORT_HDR,
+	.checksum_key	= ICMP6HDR_CHECKSUM,
 	.templates	= {
 		[ICMP6HDR_TYPE]		= ICMP6HDR_TYPE("type", &icmp6_type_type, icmp6_type),
 		[ICMP6HDR_CODE]		= ICMP6HDR_FIELD("code", icmp6_code),
-- 
2.5.0

