Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF285C761A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Mar 2023 11:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjC3LgS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 07:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjC3LgD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 07:36:03 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2107.outbound.protection.outlook.com [40.107.105.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BA010D7
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2023 04:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fh50pc2ReQti81H9XuEt+hT1SGtqND453vO8jJSTPjiVWtiHC5BLtaA2Nq/89fO99NkfeMNpMScJCSKiS/IZLvBSc274Xr+66vagV22Z2s3fRG1qFCdiI1MIia/NHC1nomUT8dtBlZ4CtVWXYYBscQNK41uye6v5yhJFK72Kegk20T4dcqqxJ9XS+ya6miCkJ27PonS3nO4lfoBBfpENwOy2amqmigsGoj/hnF4XUuVd9ypwOvmNskP4wKvjZS3sSfgOON4/u0VHfKLvScFwSN8Pg1LLSawcu2H6dVLP730sqkh3WPcaWqGvP3hnlJ9WI8frGR7RQwgJ/X/5cco7pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pa0ZwSTexoTxmaiGO+hrSUVfOZMh6cbWD+ELVD3IejE=;
 b=MOn78hFd6pMgguanW9R/3pWzt8iuvUlzXq0M18US2Hm04Xy97ZcsWaiafZdp6yRxr9rhk7FpzJCZ5Elo3YP9vkGuscKVgvSdMY3NYNJ3kP83sDcjKeVTQka+hdRNY91BZwQd8VOWvy+vSbjbOfYjZhZP/FqHQWccDdvx8mnUVtp5CdF0MIPnkjl/sY7anA3NdJ+1w+vFtOpUZWboDTWgFBgzG0KgQof/rUI10i1uQl8Y8ENc6yVvrpjYiBTTIo7oxsR2xOrBoLoX92oN3A/hMfNOhnt8iuMxSp9h2zF05LpKEA4x9V9rPaJvjgVh/4jGaWAcyHmCiiUtrfb0WZRtNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pa0ZwSTexoTxmaiGO+hrSUVfOZMh6cbWD+ELVD3IejE=;
 b=PlbTJxvP6UTx7v5hdGKkys/3Ln+mlWFea1yt6GUssT9TJY3HVUzX46Ix6j7ikL2SIR8/KfW6eSKD1DSrQ/ejOFIZUNwhRovwdo1vE2IOu7WNBADUO75UWu4Mo5YzLfYBaX4FnHvjaNejEsd950WNAO94+Z0FW4YXgEIRMcYnCAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by PAXP189MB1951.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:277::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 11:35:58 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%6]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 11:35:58 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [RFC PATCH] nft: autocomplete for libreadline
Date:   Thu, 30 Mar 2023 13:25:35 +0200
Message-Id: <20230330112535.31483-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV2PEPF000000F7.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:1:0:25) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|PAXP189MB1951:EE_
X-MS-Office365-Filtering-Correlation-Id: afa3a352-69e1-40dd-d25e-08db3112ee40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cE84F7M+yXLZkA3x8n8Sqh/lqv8AnsiDY/PYA9pmHE+ZajeKdTQrKcbvoPaAue5aoyhHhrg9AyKVotDexmEleY0uHaETEQzaCZGPIhPYoXhwNo9fQ6LSqGGsiiAsMkhUkjDVzEuEgsprRHlwsZ5/kPYTZ6lJm5myXuFNxnwqRmgI37RJbiV2POmAaCU0/Xa3WsjVbN9qRlX6QkBUeWwhOSyqk5hjz9UI2WI2UXqRYchiOj9C01+gYbJCiBLhZQUTj+PkcFIMcSa4Xn1x+1WpHimBWdBfnXTMiXivoAMDt81BkX5pVNP/ulo9D4mFkE1jye8ObPcygarAM4iqRtPBpcaQe9aGnQqnL+N8XJBoGJ8lhJcJnCQzao8NVR/r8VPzOeedQxfvZYD+5hlryM2/oz3KnrmzHaR0hop4Z3eIL5oF3zrKXNlP+RAU06iRHjoaLb42hl847sxxcMC1W/mvu1ejEDE2u14WHlY6nSg4Vs1+vw62IT7Y5n4DBQEoGDylun3TZNPLtbuByUbDaGnYEmhSKRmTgEbFNh9KQ7+GCM/5VbzPmGGufIQakukgzT9mm+FWVEV6j9fkwWnGBhjEPfROe0Afbz3v85HOCjANW7DidbbGj1J2+cFxkk55T6Gcx/Z6nvrvQP3mygOW2tyzFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(136003)(396003)(346002)(376002)(109986019)(451199021)(2616005)(6486002)(6512007)(26005)(36756003)(478600001)(186003)(1076003)(6506007)(6666004)(86362001)(70586007)(41300700001)(66476007)(66556008)(4326008)(8676002)(44832011)(38100700002)(316002)(5660300002)(54906003)(8936002)(83380400001)(2906002)(66946007)(266003)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kJ2NCvNO+6z6p1kvqFRAFbWVvvMJmBd2652umE/ClsBYPlqRf8yIWdLWYcTr?=
 =?us-ascii?Q?i+Es//3ttnxpCQNVhiAzKa1rXix8KkffMRtSCGMYGQ3wp42fZqKYnyyUMq+y?=
 =?us-ascii?Q?WDgpOjaSQjcSlD7cAHwbScW6PV0Km2o4rhmKKQcrNXHnUMb+dAXuUfPxEzAB?=
 =?us-ascii?Q?ktu248/alNb4K9uorzkrZLBrTba5VREETfMR9/Od3hM8gt9eaJQ64Uu7seuO?=
 =?us-ascii?Q?Hj18mczzQxwdxutZtuJBop7XJXCU4FkKnJqzs7HtHxOsh0B1zDxZxMeN9AfE?=
 =?us-ascii?Q?lZOcwVN55ZMyXHFPcLDFSRR2YVjV99AVd4U8lq1u1vZqLNYgy+tf57g1b5RX?=
 =?us-ascii?Q?+0wsG6c0eR0gvklJwVuh9bjDBX9tOQo1MS+RHN/ntaePNjTAiqAeIfiVsQop?=
 =?us-ascii?Q?19BqIJM6DtRFG6CPpYgWg8AKrSz0KhaZn/QmBvhU50Q6scb0RCS1ErhvABec?=
 =?us-ascii?Q?uyzydcqvQV6CgKDgY4N8/GI/UkEZQfbBA/uOiWFhobXX//ABau3cipHqluVZ?=
 =?us-ascii?Q?b/srzeCMdUoNKOaATp24mwtwonO/y/m+AMXYAkT71GEMSFLTguzRfgsvkpfi?=
 =?us-ascii?Q?VFUFvTa1WRtovvNOKfNmo5zgLL7+EY8TepPdwK/v+RgNXf6cu3jMvyoo1RLy?=
 =?us-ascii?Q?UhDhb7w9ClSJrMmH+8bbhi8UhJNkVLUJNqyd9CB13nA0Dgqgrrq+LagB5klz?=
 =?us-ascii?Q?EmW354cKA4pBGfnDMC4aJ/K4A+BCOKbh4MKyDqALCTwMTFJBTnvAz3e8nMSM?=
 =?us-ascii?Q?bf1ERt2MD2yf1svsNAs2GJNuwqnnMeREQLIyHpCkYtnpM2yY/r0MMC5UlmoG?=
 =?us-ascii?Q?LeVTMOl1mowvAKCEM5cV/Xkz7N2f+2n06CFq1zjQfdZ2HD150JMvUDbVM3D9?=
 =?us-ascii?Q?xVbASEsxK+RLJSoX6+Ld6AzMwCqLKsQ+r+o2/+JNe7YIcFQ0Bok0+EhlWcTV?=
 =?us-ascii?Q?C6zUE0H/YBDyAJLDaj518643FTsME8cTmLno238YZXvSkUWTyHVoUN8phdIr?=
 =?us-ascii?Q?rlz5i3xNgkDCyag/PeTId+ibroXI4suCQ780QvkBNpV1IuqrwEPKqm9k+S8w?=
 =?us-ascii?Q?pa/xzOHTeGuQSpTMUvQlSr0rcu6jjm3LgFGEpOB4CmI0BuhW7zjs6eUh0Xvd?=
 =?us-ascii?Q?vIHz1DhhDQEX1r1bIP4mTXhr8lVs/yMJkdoXynaIrzaMvSHZ4xu+bOl/svsA?=
 =?us-ascii?Q?t1Zjp8VW+qYY300K1EcfZZlTkrgksVsMmgwfzZGeZWSS4usesySr70TTOec8?=
 =?us-ascii?Q?613FScmp67D84GPscFyNdI0yGu7+8WEnrvlTtbONyv5oB82+iN3V6aUe/Qdb?=
 =?us-ascii?Q?UMpKUjNzY/u8poXBoUUhJh37qzUZ6o3b1jXwu/F6CMYF1kby++prLQSUDzGE?=
 =?us-ascii?Q?IDqv8gixVVJdr3H5ectfFt9QQ3QLynW12tWJv8vvGxvMHAIT5FbamqS0Nl5L?=
 =?us-ascii?Q?maRGymASYFxcPqhVEaHMR7TihzXtdMvWOkuuvkzK8d1eGQFrFjhJNyABobXh?=
 =?us-ascii?Q?rMSDYFU67l0X9bF7gxO9g/fUzO3OZhDPXQPV2i6cJ3orlMFlFVufRogJhKW/?=
 =?us-ascii?Q?0gUOgmfWWsWI0vjf7rzywMSLW+wuHzGqMgbc9CRKHW+it10GJBgs2d9lxsvH?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: afa3a352-69e1-40dd-d25e-08db3112ee40
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 11:35:58.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xn0ITRL7Hm6QjoNdC/85QXCf0KG5OhsYrCqkkptpUn/DURN0MAreiMF+YC88xiACMUmt3mEvQg2H+qstEotriVakgD3fvn81kIRMbWYazSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP189MB1951
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The lack for autocomplete in interactive mode is a bit annoying, and
there doesn't seem to be an easy way to support it using bash
completion. Here is a proposal to use bison to guess the next tokens.

This patch adds support for keyword autocomplete for libreadline CLI
only, it uses the bison push parser to step through each token and lists
all all possible next tokens.

Some important notes:
- First word autocomplete doesn't work, since the last token flex passes
  is TOKEN_EOF, and the parser is default state
- Number of special tokens are specifically skipped, and only symbols
  that are escaped by \" or \' are considered valid keywords

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 Make_global.am                 |   2 +-
 include/nftables/libnftables.h |   2 +
 include/parser.h               |   3 +
 src/cli.c                      |   5 +-
 src/libnftables.c              |  13 ++++
 src/libnftables.map            |   4 ++
 src/parser_bison.y             | 107 +++++++++++++++++++++++++++++++++
 7 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 5bb541f6..35c81ee0 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -18,4 +18,4 @@
 # set age to 0.
 # </snippet>
 #
-libnftables_LIBVERSION=2:0:1
+libnftables_LIBVERSION=3:0:1
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
index e4f21ca1..d466628d 100644
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
@@ -6215,3 +6217,108 @@ exthdr_key		:	HBH	close_scope_hbh	{ $$ = IPPROTO_HOPOPTS; }
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

