Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DEDC6FD1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Mar 2023 12:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbjC3MM7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 08:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjC3MM6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 08:12:58 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2114.outbound.protection.outlook.com [40.107.21.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE02EC
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2023 05:12:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3ySKSEqa3xt2teytAtkPLeG7/hgnnSnkPMRLz1oxXYjwkxPxJNqq7bAB2Dw76IkjMxWFNucJjt7F4Fb2+HrM79oi8b2wGHLPv4g1+QbSZQ0OXRuknARSReRLSeXiViETv5lbMDhRZCppA9J1X+vp5et7YL1fHafqVTo0KM+Ed1Xb6Kj+NGOZF+p6VzAq6EGM6g6mgxfyLeKM+AHUx04Fn0+3j0VlJNvaB0gWm9wYo2+G1kjYUdVh6CgP3PhpYdfHsDK8PULnaks+iNg4CMWqhaLjF7r+lEgRh4DZvrN4n4DGSTMEqeR/rf8M6R/q7xhwANaxYdxrYrOp12WWOCetA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ha1BNOgOlZ7Ozg+kZDCmAeneFpUTuh6rL+3s7R36L2o=;
 b=kZhaUq7riXHbr9cNRTlOdbN51K9oWH9z8kNaI6Y+XYMR3JPPNE6MhvXPTI8RhDWeOGGMU9YXwTzl0W2PnJ5F1Mu6jirVfCiIdaYg6DQImmRUyAeWvqPRBYfRIARJNlsIXTdJW2oKeRPMumkqxJNUG2S5c9m6NVwzYOYCN134Ruzq4S94kaQVYo+TOcPpdfIbZd87jf1ZF6lBY+dxyuaxSy1grg9kQIdn4R/r0OF9dfbSjXC8vRl0vXA2nQhmQt6Yw4xhavuB4MLWgpTBRJSH7a/ZQ/OT0HcQVD3SxPOgP7+IX3gwiva0ZJIhCNfD/3+OO3H4vwSlXOSE6Z+8Vka4VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ha1BNOgOlZ7Ozg+kZDCmAeneFpUTuh6rL+3s7R36L2o=;
 b=RELO3QmU9bQIkhOQJGAmOd+7IcDqwSDP/8b+S3qYKtt+ubZsCK6Sfd9eCBzCkAm/YPEjDOCuNj8SVcBlSRVwZk9KyzY5rOOoK3fGeGoym7o+nDVy0etlEwo21m9UmlnvNzmWDlDyPpo0MMGKel85L1phvh+vqd7WVHpkTd+/wxc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DB8P189MB0885.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:16f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 12:12:52 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%6]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 12:12:52 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [RFC PATCH v2] nft: autocomplete for libreadline
Date:   Thu, 30 Mar 2023 13:57:17 +0200
Message-Id: <20230330115717.7692-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVX0EPF000013DF.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1::b) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|DB8P189MB0885:EE_
X-MS-Office365-Filtering-Correlation-Id: d41c8902-f670-43c1-5ef4-08db311815e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lwMHiGUnNP+2fjXvwxJwAggsX6PBxF/zH4bDJwLvWe4AkF544L+kQKnpCL7ud8ZqRTlNxwHkhGRq+t2m7Sr7Al/kuQ8Liy98f//0ISzZ1apld0Geht/LENZXMiZj4arrfPydamnHG7Z4luyg0AyrN97FGwoarDMQYBYUWARbgVL8ufJXwJrTUjSAlr/p7UFlC3c8ctHX6P78VOCVk9ObEULCdyeQXfIaRnh395QOdgBzcV3ymM8zPTikeBLDFCNg4xg36iqQhRPIr1omv3wPLBdrYd3S07xB8Kq/EkdOixqzOO3O6x9GtfvbkfKK1mXzxc+gcsRyQIVkhHcSfVoxsAlBo+KhIhgq6+HoyfuivVFrJy3XwHU6V3t8rL75VS3s0qeqJpEa2yF+ksIYKGj4ZJZ0DV6Xm1rw3tHtLc1HK/sKcCnq7+87xkwEc4fM5OW/9HSWSB9G51aKfKmI7O3eKN7v1KYHCvwnVsIMZTbcKE7fKUDy3bLs7ts714hnf5r1pwZZpBgloCHKiBkqLhcE4x54Fxjq0F7hP/jk4sOCsIKS8833YtsxX6k+GW7xB3FeDB5NE05Ypt+9/VnurkFCMg2Gki0FTh+LJ31bFYgUKe+8Rj/8+l5bvq58gBxlzqQseYhpHFZhQW3WbyKF5jjq0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(39840400004)(451199021)(109986019)(2616005)(83380400001)(6486002)(54906003)(478600001)(316002)(186003)(6666004)(1076003)(6506007)(2906002)(26005)(6512007)(5660300002)(8936002)(44832011)(36756003)(38100700002)(66946007)(70586007)(41300700001)(8676002)(66556008)(66476007)(4326008)(86362001)(266003)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rZ84iC7fIUqQi8as1E3tmRQJAt/iLFA88kIn+FSKdVMECPPsezE1ef6IwHcJ?=
 =?us-ascii?Q?NZ/feDcw1alZo7Ev7r9Da7D47+wrVcH+mxnKeZJ+KGvnZ6x9J2D72qEDnF/i?=
 =?us-ascii?Q?5/py3VjGN9Egu5T+6wIf/8yoGnjxeKXhZc34eoAX9mGL6Nbw/YeIQWNjZhPq?=
 =?us-ascii?Q?hakp/+Wi3i7CK/eX9TJHscKFgN6yx2IWPDNfZRqxMo7d2ZsMfYjIbjW88OQm?=
 =?us-ascii?Q?dVbsQlJMuisRDiiBymCxbeJynaCNbhjb2yaWjGdzRca1K5+Bs+kWG2BMjGYT?=
 =?us-ascii?Q?pBhNx31OX+Gc/NkTITapPa9drtgxQjpgVyfWLda+hvyZLkkJNGFNRY+ijzoU?=
 =?us-ascii?Q?y3fOipbvKgOrdThA8fC+g75E2lmJ8n5iozrItFvtOogULfc026zTEfjrX6EW?=
 =?us-ascii?Q?QoWwJdHYVpQhbO59vrGzssMPNhODyJyjSBuHFWapaSvANttC0wzoViv+Gena?=
 =?us-ascii?Q?MzvVZe0y8SezTit8sCPD8sc9HygCba9doYj/lSKZnOKxXnYBYBVCivvlXNUm?=
 =?us-ascii?Q?qTIFxSi2XeHwanXH95L04PbtV6cSFz0itBCsexGXMt/TdzkCWqj2npqTOXwz?=
 =?us-ascii?Q?vh5hhOWdElGhotrX1JKRG7K45gCBazlR4RqawqZ8zCb7jMzcMAi8WiCTZK7H?=
 =?us-ascii?Q?COwq6ppQyjdpetmhE0TehFTCGnZLlgSjuO5A8ydwkK03nF+isGPNNNo3m8Yz?=
 =?us-ascii?Q?415Np+58dhhlfr0vy8/EnHGj/Avo1ryX/QMgCewK0eGWOyhDoA76uA6yHoTw?=
 =?us-ascii?Q?blcTSGC4DgnLRT6G/wevQEbbxnRIb0DUe0DHX8q9LqETaiTrXk4cdHIBnhqd?=
 =?us-ascii?Q?cZ/GBI/1/qDqjKVI0War0nRaJMloGJIbvyMrnl/VzSCxQ2ysigDsePXquBKg?=
 =?us-ascii?Q?cOZJYZ1iYzTjP1IOCdiiJDfRK8zb0IHS0YLHOuIJCq2hknLD4CUe/WFRpUY4?=
 =?us-ascii?Q?4WxMoM2ExSXxXtm5NFf433sH0sS4kjUJMpeG2+XOInNHFtpFBLejUmKhDuZz?=
 =?us-ascii?Q?tW5MFXECaOmD949gJ5E2G4QK75aD+EdGex16zElQJ3++bNlcTpHVQ2jY/Q6L?=
 =?us-ascii?Q?Ir90uYsQYDkUdsrJPUk/bFRVufsTs1/YVn+qBxJxH2G4Ibdvj0tC+6DiDt6t?=
 =?us-ascii?Q?3bDBGNesoAgNJ1ygUWXkxJ8fh0LI5gARDJZRrJy8o/dkNgg+/pifk6pj4wsR?=
 =?us-ascii?Q?WO33GMFvAZiH6b7DfCYLTYhIJeuwpV58IWaBS9Qg7zXvEc9NQrB5YcnOSvmm?=
 =?us-ascii?Q?qNAQK9Jrm+BZeyRCpw2q3yBD4HLN/8reCTgMC35Yrhn9Xk94qyW6UAGYMTrN?=
 =?us-ascii?Q?8Vr/rL8qE9LP2TUS3sK2Fl0VqvoaXPd9XKFlk2JH2oyD2Unk+QyDtos092e3?=
 =?us-ascii?Q?rGGcpxdLmkHr3CSu2X/P4x4ruPq5b4nFS2DFq+v/k54j5RPZoPjfB938y6NO?=
 =?us-ascii?Q?xcUl8G6dDgy7DSEenu/JJJNizYapGibunYEh43YYl5X+2Qz4GLgAW6fWJEqA?=
 =?us-ascii?Q?SrTQ6n6w6UUwCoj6dRjW03VTmNST85eoAoxdgcTNbFNZTpHr6L+RfIB6vPvf?=
 =?us-ascii?Q?inr7VrkILZ8RPFG7kuMKRSC1anrpRjJtPbIFe5pucKbQO1fJSvFT8+UOOTz3?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: d41c8902-f670-43c1-5ef4-08db311815e4
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 12:12:52.0675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlRAdcN9Smr3OhwFo4X6TDcLjpLlVjDOh/aloHDAwRLTrRSwoXt2XmtQHppm6uD0DDGw3EnYnTrZ1NhHduV2HHlG9vRv0AOg7rmXHQ4Wa2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P189MB0885
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The lack for autocomplete in interactive mode is a bit annoying, and
there doesn't seem to be an easy way to support it using bash
completion. Here is a proposal to use bison to guess the next tokens.

Add support for autocomplete for libreadline CLI.
This patch uses the bison push parser to step through each token and
list all possible next tokens.

- First word autocomplete doesn't work, since the last token flex passes
  is TOKEN_EOF, and the parser is default state
- Number of special tokens are specifically skipped, and only symbols
  that are escaped by \" or \' are considered valid keywords

Changes since v1:
- Fix libtool version as suggested by Jan 
- Add YYSYMBOL_NUM to special token list

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 Make_global.am                 |   2 +-
 include/nftables/libnftables.h |   2 +
 include/parser.h               |   3 +
 src/cli.c                      |   5 +-
 src/libnftables.c              |  13 ++++
 src/libnftables.map            |   4 ++
 src/parser_bison.y             | 108 +++++++++++++++++++++++++++++++++
 7 files changed, 135 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 5bb541f6..67216a2c 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,4 +18,4 @@
 # set age to 0.
 # </snippet>
 #
-libnftables_LIBVERSION=2:0:1
+libnftables_LIBVERSION=3:0:2
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index 85e08c9b..57f8be64 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -92,6 +92,8 @@ void nft_ctx_clear_vars(struct nft_ctx *ctx);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf);
 int nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename);
 
+char **nft_get_expected_tokens(struct nft_ctx *nft, const char *line, const char *text);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/include/parser.h b/include/parser.h
index f79a22f3..cec3a8f8 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -98,6 +98,9 @@ extern void parser_init(struct nft_ctx *nft, struct parser_state *state,
 			struct scope *top_scope);
 extern int nft_parse(struct nft_ctx *ctx, void *, struct parser_state *state);
 
+extern char **expected_matches (struct nft_ctx *nft, struct parser_state *state,
+				const char *text);
+
 extern void *scanner_init(struct parser_state *state);
 extern void scanner_destroy(struct nft_ctx *nft);
 
diff --git a/src/cli.c b/src/cli.c
index 11fc85ab..ffd7bf61 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -158,7 +158,10 @@ static void cli_complete(char *line)
 
 static char **cli_completion(const char *text, int start, int end)
 {
-	return NULL;
+	char *line = strndup(rl_line_buffer, (size_t)start);
+
+	rl_attempted_completion_over = 1;
+	return nft_get_expected_tokens(cli_nft, line, text);
 }
 
 int cli_init(struct nft_ctx *nft)
diff --git a/src/libnftables.c b/src/libnftables.c
index 4f538c44..a85cb155 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -555,6 +555,19 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	return 0;
 }
 
+EXPORT_SYMBOL(nft_get_expected_tokens);
+char **nft_get_expected_tokens(struct nft_ctx *nft, const char *line, const char *text)
+{
+	LIST_HEAD(msgs);
+	LIST_HEAD(cmds);
+
+	parser_init(nft, nft->state, &msgs, &cmds, nft->top_scope);
+	nft->scanner = scanner_init(nft->state);
+	scanner_push_buffer(nft->scanner, &indesc_cmdline, line);
+
+	return expected_matches(nft, nft->state, text);
+}
+
 EXPORT_SYMBOL(nft_run_cmd_from_buffer);
 int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 {
diff --git a/src/libnftables.map b/src/libnftables.map
index a46a3ad5..9e4d8fcd 100644
--- a/src/libnftables.map
+++ b/src/libnftables.map
@@ -33,3 +33,7 @@ LIBNFTABLES_3 {
   nft_ctx_set_optimize;
   nft_ctx_get_optimize;
 } LIBNFTABLES_2;
+
+LIBNFTABLES_4 {
+  nft_get_expected_tokens;
+} LIBNFTABLES_3;
\ No newline at end of file
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e4f21ca1..6d1c2374 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -13,6 +13,7 @@
 #include <ctype.h>
 #include <stddef.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <inttypes.h>
 #include <syslog.h>
 #include <netinet/ip.h>
@@ -160,6 +161,7 @@ int nft_lex(void *, void *, void *);
 %name-prefix "nft_"
 %debug
 %define api.pure
+%define api.push-pull both
 %parse-param		{ struct nft_ctx *nft }
 %parse-param		{ void *scanner }
 %parse-param		{ struct parser_state *state }
@@ -6215,3 +6217,109 @@ exthdr_key		:	HBH	close_scope_hbh	{ $$ = IPPROTO_HOPOPTS; }
 			;
 
 %%
+
+static int expected_tokens(struct nft_ctx *nft, struct parser_state *state,
+		    int *tokens, int ntokens)
+{
+	int res = 0;
+	yypstate *pstate = yypstate_new();
+	YYLTYPE yylloc;
+	int yystatus;
+
+	location_init(nft->scanner, state, &yylloc);
+	do {
+		YYSTYPE yylval;
+		int token = nft_lex(&yylval, &yylloc, nft->scanner);
+		// Don't let the parse know when we reach the end of input.
+		if (token == TOKEN_EOF)
+			break;
+		yystatus = nft_push_parse(pstate, token, &yylval, &yylloc, nft, nft->scanner, state);
+	} while (yystatus == YYPUSH_MORE);
+
+	if (!pstate->yynerrs)
+	{
+		res = yypstate_expected_tokens(pstate, tokens, ntokens);
+	}
+
+	yypstate_delete(pstate);
+	return res;
+}
+
+char **expected_matches (struct nft_ctx *nft, struct parser_state *state,
+			 const char *text)
+{
+	const size_t len = strlen(text);
+	int match = 1;
+	char **matches = NULL;
+	bool special_token = false;
+	const int special_tokens[] = {
+		YYSYMBOL_YYEOF,
+		YYSYMBOL_YYUNDEF,
+		YYSYMBOL_JUNK,
+		YYSYMBOL_NEWLINE,
+		YYSYMBOL_COLON,
+		YYSYMBOL_SEMICOLON,
+		YYSYMBOL_COMMA,
+		YYSYMBOL_NUM,
+		YYSYMBOL_STRING,
+		YYSYMBOL_QUOTED_STRING,
+		YYSYMBOL_ASTERISK_STRING,
+		YYSYMBOL_LAST
+	};
+	int tokens[YYNTOKENS];
+	int ntokens = expected_tokens(nft, state, tokens, YYNTOKENS);
+
+	if (ntokens == 0)
+		goto out;
+
+	// Need initial prefix and final NULL.
+	matches = calloc((size_t)ntokens + 2, sizeof(*matches));
+	if (!matches)
+		goto out;
+
+	for (int i = 0; i < ntokens; ++i) {
+		const char* token = yysymbol_name(tokens[i]);
+		const char* unescaped_token = NULL;
+
+		for (size_t j = 0; j < sizeof(special_tokens)/sizeof(special_tokens[0]); ++j) {
+			if (tokens[i] == special_tokens[j]) {
+				special_token = true;
+				break;
+			}
+		}
+
+		if (special_token) {
+			special_token = false;
+			continue;
+		}
+
+		/* Only match tokens that are escaped by \" or \' */
+		if (token[0] == '"' || token[0] == '\'') {
+			unescaped_token = strndup(token + 1, strlen(token) - 2);
+		}
+
+
+		if (unescaped_token && (!len ||
+			strncmp(text, unescaped_token, len) == 0)) {
+			matches[match++] = strdup(unescaped_token);
+		}
+	}
+
+	// Find the longest common prefix, and install it in matches[0], as
+	// required by readline.
+	if (match == 1) {
+		free(matches);
+		return NULL;
+	} else {
+		size_t lcplen = strlen(matches[1]);
+		for (int i = 2; i < match && lcplen; ++i)
+			for (size_t j = 0; j < lcplen; ++j)
+				if (matches[1][j] != matches[i][j])
+					lcplen = j;
+		matches[0] = strdup(matches[1]);
+		matches[0][lcplen] = '\0';
+	}
+
+out:
+	return matches;
+}
-- 
2.34.1

