Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB76C2D0BF
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E19921582
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 17:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfLQRRL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 12:17:11 -0500
Received: from correo.us.es ([193.147.175.20]:37926 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfLQRRL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 12:17:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5331C1C4441
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 442D1DA713
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 39A4DDA712; Tue, 17 Dec 2019 18:17:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32835DA70A;
        Tue, 17 Dec 2019 18:17:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 18:17:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 180B042EF42A;
        Tue, 17 Dec 2019 18:17:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nft 02/11] exthdr: add exthdr_desc_id enum and use it
Date:   Tue, 17 Dec 2019 18:16:53 +0100
Message-Id: <20191217171702.31493-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191217171702.31493-1-pablo@netfilter.org>
References: <20191217171702.31493-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to identify the exthdr protocol from the userdata area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/exthdr.h | 15 +++++++++++++++
 src/exthdr.c     | 28 ++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/exthdr.h b/include/exthdr.h
index 3959a65c7713..c9a3c211b8c4 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -5,6 +5,20 @@
 #include <tcpopt.h>
 #include <ipopt.h>
 
+enum exthdr_desc_id {
+	EXTHDR_DESC_UNKNOWN	= 0,
+	EXTHDR_DESC_HBH,
+	EXTHDR_DESC_RT,
+	EXTHDR_DESC_RT0,
+	EXTHDR_DESC_RT2,
+	EXTHDR_DESC_SRH,
+	EXTHDR_DESC_FRAG,
+	EXTHDR_DESC_DST,
+	EXTHDR_DESC_MH,
+	__EXTHDR_DESC_MAX
+};
+#define EXTHDR_DESC_MAX	(__EXTHDR_DESC_MAX - 1)
+
 /**
  * struct exthdr_desc - extension header description
  *
@@ -14,6 +28,7 @@
  */
 struct exthdr_desc {
 	const char			*name;
+	enum exthdr_desc_id		id;
 	uint8_t				type;
 	int				proto_key;
 	struct proto_hdr_template	templates[10];
diff --git a/src/exthdr.c b/src/exthdr.c
index e1ec6f3dd52b..925b52329003 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -23,6 +23,26 @@
 #include <expression.h>
 #include <statement.h>
 
+static const struct exthdr_desc *exthdr_definitions[PROTO_DESC_MAX + 1] = {
+	[EXTHDR_DESC_HBH]	= &exthdr_hbh,
+	[EXTHDR_DESC_RT]	= &exthdr_rt,
+	[EXTHDR_DESC_RT0]	= &exthdr_rt0,
+	[EXTHDR_DESC_RT2]	= &exthdr_rt2,
+	[EXTHDR_DESC_SRH]	= &exthdr_rt4,
+	[EXTHDR_DESC_FRAG]	= &exthdr_frag,
+	[EXTHDR_DESC_DST]	= &exthdr_dst,
+	[EXTHDR_DESC_MH]	= &exthdr_mh,
+};
+
+static const struct exthdr_desc *exthdr_find_desc(enum exthdr_desc_id desc_id)
+{
+	if (desc_id >= EXTHDR_DESC_UNKNOWN &&
+	    desc_id <= EXTHDR_DESC_MAX)
+		return exthdr_definitions[desc_id];
+
+	return NULL;
+}
+
 static void exthdr_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	if (expr->exthdr.op == NFT_EXTHDR_OP_TCPOPT) {
@@ -281,6 +301,7 @@ bool exthdr_find_template(struct expr *expr, const struct expr *mask, unsigned i
 
 const struct exthdr_desc exthdr_hbh = {
 	.name		= "hbh",
+	.id		= EXTHDR_DESC_HBH,
 	.type		= IPPROTO_HOPOPTS,
 	.templates	= {
 		[HBHHDR_NEXTHDR]	= HBH_FIELD("nexthdr", ip6h_nxt, &inet_protocol_type),
@@ -294,6 +315,7 @@ const struct exthdr_desc exthdr_hbh = {
 
 const struct exthdr_desc exthdr_rt2 = {
 	.name           = "rt2",
+	.id		= EXTHDR_DESC_RT2,
 	.type           = IPPROTO_ROUTING,
 	.proto_key	= 2,
 	.templates	= {
@@ -307,6 +329,7 @@ const struct exthdr_desc exthdr_rt2 = {
 
 const struct exthdr_desc exthdr_rt0 = {
 	.name           = "rt0",
+	.id		= EXTHDR_DESC_RT0,
 	.type           = IPPROTO_ROUTING,
 	.proto_key      = 0,
 	.templates	= {
@@ -322,6 +345,7 @@ const struct exthdr_desc exthdr_rt0 = {
 
 const struct exthdr_desc exthdr_rt4 = {
 	.name		= "srh",
+	.id		= EXTHDR_DESC_SRH,
 	.type		= IPPROTO_ROUTING,
 	.proto_key	= 4,
 	.templates      = {
@@ -340,6 +364,7 @@ const struct exthdr_desc exthdr_rt4 = {
 
 const struct exthdr_desc exthdr_rt = {
 	.name		= "rt",
+	.id		= EXTHDR_DESC_RT,
 	.type		= IPPROTO_ROUTING,
 	.proto_key      = -1,
 #if 0
@@ -366,6 +391,7 @@ const struct exthdr_desc exthdr_rt = {
 
 const struct exthdr_desc exthdr_frag = {
 	.name		= "frag",
+	.id		= EXTHDR_DESC_FRAG,
 	.type		= IPPROTO_FRAGMENT,
 	.templates	= {
 		[FRAGHDR_NEXTHDR]	= FRAG_FIELD("nexthdr", ip6f_nxt, &inet_protocol_type),
@@ -392,6 +418,7 @@ const struct exthdr_desc exthdr_frag = {
 
 const struct exthdr_desc exthdr_dst = {
 	.name		= "dst",
+	.id		= EXTHDR_DESC_DST,
 	.type		= IPPROTO_DSTOPTS,
 	.templates	= {
 		[DSTHDR_NEXTHDR]	= DST_FIELD("nexthdr", ip6d_nxt, &inet_protocol_type),
@@ -438,6 +465,7 @@ const struct datatype mh_type_type = {
 
 const struct exthdr_desc exthdr_mh = {
 	.name		= "mh",
+	.id		= EXTHDR_DESC_MH,
 	.type		= IPPROTO_MH,
 	.templates	= {
 		[MHHDR_NEXTHDR]		= MH_FIELD("nexthdr", ip6mh_proto, &inet_protocol_type),
-- 
2.11.0

