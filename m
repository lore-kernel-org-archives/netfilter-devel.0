Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B00C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F200120738
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403939AbgFXNaM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403921AbgFXNaL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:30:11 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB79CC061573
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 06:30:10 -0700 (PDT)
Received: janet.servers.dxld.at; Wed, 24 Jun 2020 15:30:09 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Subject: [libnf_ct PATCH v2 6/9] Fix buffer overflow on invalid icmp type in setters
Date:   Wed, 24 Jun 2020 15:30:02 +0200
Message-Id: <20200624133005.22046-6-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200624133005.22046-1-dxld@darkboxed.org>
References: <20200624133005.22046-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When type is out of range for the invmap_icmp{,v6} array we leave rtype at
zero which will map to type=255 just like other error cases in this
function.

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 src/conntrack/grp_setter.c |  8 +++++---
 src/conntrack/setter.c     | 11 +++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/src/conntrack/grp_setter.c b/src/conntrack/grp_setter.c
index fccf578..49dc033 100644
--- a/src/conntrack/grp_setter.c
+++ b/src/conntrack/grp_setter.c
@@ -85,18 +85,20 @@ static void set_attr_grp_repl_port(struct nf_conntrack *ct, const void *value)
 
 static void set_attr_grp_icmp(struct nf_conntrack *ct, const void *value)
 {
-	uint8_t rtype;
+	uint8_t rtype = 0;
 	const struct nfct_attr_grp_icmp *this = value;
 
 	ct->head.orig.l4dst.icmp.type = this->type;
 
 	switch(ct->head.orig.l3protonum) {
 		case AF_INET:
-			rtype = invmap_icmp[this->type];
+			if (this->type < ARRAY_SIZE(invmap_icmp))
+				rtype = invmap_icmp[this->type];
 			break;
 
 		case AF_INET6:
-			rtype = invmap_icmpv6[this->type - 128];
+			if (this->type - 128 < ARRAY_SIZE(invmap_icmp))
+				rtype = invmap_icmpv6[this->type - 128];
 			break;
 
 		default:
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 3a293b0..1d3b971 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -124,17 +124,20 @@ set_attr_repl_zone(struct nf_conntrack *ct, const void *value, size_t len)
 static void
 set_attr_icmp_type(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	uint8_t rtype;
+	uint8_t type = *((uint8_t *) value);
+	uint8_t rtype = 0;
 
-	ct->head.orig.l4dst.icmp.type = *((uint8_t *) value);
+	ct->head.orig.l4dst.icmp.type = type;
 
 	switch(ct->head.orig.l3protonum) {
 		case AF_INET:
-			rtype = invmap_icmp[*((uint8_t *) value)];
+			if (type < ARRAY_SIZE(invmap_icmp))
+				rtype = invmap_icmp[type];
 			break;
 
 		case AF_INET6:
-			rtype = invmap_icmpv6[*((uint8_t *) value) - 128];
+			if (type - 128 < ARRAY_SIZE(invmap_icmpv6))
+				rtype = invmap_icmpv6[type - 128];
 			break;
 
 		default:
-- 
2.20.1

