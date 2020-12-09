Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DB0C19425
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B9023B6B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 17:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgLIRu2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgLIRuO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 12:50:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ED6C0613D6
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 09:49:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kn3an-0004Qb-8k; Wed, 09 Dec 2020 18:49:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 01/10] exthdr: remove unused proto_key member from struct
Date:   Wed,  9 Dec 2020 18:49:15 +0100
Message-Id: <20201209174924.27720-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201209174924.27720-1-fw@strlen.de>
References: <20201209174924.27720-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

also, no need for this struct to be in the parser.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/exthdr.h   | 1 -
 src/exthdr.c       | 4 ----
 src/parser_bison.y | 1 -
 3 files changed, 6 deletions(-)

diff --git a/include/exthdr.h b/include/exthdr.h
index c9a3c211b8c4..1bc756f93649 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -30,7 +30,6 @@ struct exthdr_desc {
 	const char			*name;
 	enum exthdr_desc_id		id;
 	uint8_t				type;
-	int				proto_key;
 	struct proto_hdr_template	templates[10];
 };
 
diff --git a/src/exthdr.c b/src/exthdr.c
index 5eb66529b5d7..b0243adad1da 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -409,7 +409,6 @@ const struct exthdr_desc exthdr_rt2 = {
 	.name           = "rt2",
 	.id		= EXTHDR_DESC_RT2,
 	.type           = IPPROTO_ROUTING,
-	.proto_key	= 2,
 	.templates	= {
 		[RT2HDR_RESERVED]	= {},
 		[RT2HDR_ADDR]		= {},
@@ -423,7 +422,6 @@ const struct exthdr_desc exthdr_rt0 = {
 	.name           = "rt0",
 	.id		= EXTHDR_DESC_RT0,
 	.type           = IPPROTO_ROUTING,
-	.proto_key      = 0,
 	.templates	= {
 		[RT0HDR_RESERVED]	= RT0_FIELD("reserved", ip6r0_reserved, &integer_type),
 		[RT0HDR_ADDR_1]		= RT0_FIELD("addr[1]", ip6r0_addr[0], &ip6addr_type),
@@ -439,7 +437,6 @@ const struct exthdr_desc exthdr_rt4 = {
 	.name		= "srh",
 	.id		= EXTHDR_DESC_SRH,
 	.type		= IPPROTO_ROUTING,
-	.proto_key	= 4,
 	.templates      = {
 		[RT4HDR_LASTENT]	= RT4_FIELD("last-entry", ip6r4_last_entry, &integer_type),
 		[RT4HDR_FLAGS]		= RT4_FIELD("flags", ip6r4_flags, &integer_type),
@@ -458,7 +455,6 @@ const struct exthdr_desc exthdr_rt = {
 	.name		= "rt",
 	.id		= EXTHDR_DESC_RT,
 	.type		= IPPROTO_ROUTING,
-	.proto_key      = -1,
 #if 0
 	.protocol_key	= RTHDR_TYPE,
 	.protocols	= {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e8aa5bb8eb3d..08aadaa32a86 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -184,7 +184,6 @@ int nft_lex(void *, void *, void *);
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
 	struct prio_spec	prio_spec;
-	const struct exthdr_desc *exthdr_desc;
 }
 
 %token TOKEN_EOF 0		"end of file"
-- 
2.26.2

