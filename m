Return-Path: <SRS0=xvfr=2C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE43C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E701722527
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbfLLRPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:15:02 -0500
Received: from correo.us.es ([193.147.175.20]:49222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbfLLRPC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 12:15:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1243E2C5B
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 18:14:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9385CDA70B
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2019 18:14:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87573DA701; Thu, 12 Dec 2019 18:14:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 578D1DA701;
        Thu, 12 Dec 2019 18:14:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 12 Dec 2019 18:14:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3AE7F4265A5A;
        Thu, 12 Dec 2019 18:14:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] main: allow for getopt parser from top-level scope only
Date:   Thu, 12 Dec 2019 18:14:55 +0100
Message-Id: <20191212171455.83382-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch restricts the getopt parser to the top-level scope. This is
implicitly providing a fix for the following error reporting:

 # nft add chain x k { type filter hook input priority -10\;  }
 nft: invalid option -- '1'

When defining basechains using a negative priority number.

This patch is processing the input to escape all dash (-) after leaving
the top-level scope (ie. {), then it removes the escaping before
entering the bison parser.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index fde8b15c5870..c96953e3cd2f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -202,29 +202,107 @@ static const struct {
 	},
 };
 
+struct nft_opts {
+	char		**argv;
+	int		argc;
+};
+
+static int nft_opts_init(int argc, char * const argv[], struct nft_opts *opts)
+{
+	uint32_t scope = 0;
+	char *new_argv;
+	int i;
+
+	opts->argv = calloc(argc + 1, sizeof(char *));
+	if (!opts->argv)
+		return -1;
+
+	for (i = 0; i < argc; i++) {
+		if (scope > 0) {
+			if (argv[i][0] == '-') {
+				new_argv = malloc(strlen(argv[i]) + 2);
+				if (!new_argv)
+					return -1;
+
+				sprintf(new_argv, "\\-%s", &argv[i][1]);
+				opts->argv[opts->argc++] = new_argv;
+				continue;
+			}
+		} else if (argv[i][0] == '{') {
+			scope++;
+		} else if (argv[i][0] == '}') {
+			scope--;
+		}
+
+		opts->argv[opts->argc++] = strdup(argv[i]);
+	}
+
+	return 0;
+}
+
+static int nft_opts_update(struct nft_opts *opts)
+{
+	char *new_argv;
+	int i;
+
+	for (i = 0; i < opts->argc; i++) {
+		if (opts->argv[i][0] == '\\') {
+			new_argv = malloc(strlen(opts->argv[i]) + 1);
+			if (!new_argv)
+				return -1;
+
+			sprintf(new_argv, "-%s", &opts->argv[i][2]);
+			free(opts->argv[i]);
+			opts->argv[i] = new_argv;
+		}
+	}
+
+	return 0;
+}
+
+static void nft_opts_release(struct nft_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < opts->argc; i++)
+		free(opts->argv[i]);
+
+	free(opts->argv);
+}
+
 int main(int argc, char * const *argv)
 {
 	char *buf = NULL, *filename = NULL;
 	unsigned int output_flags = 0;
+	struct nft_opts opts = {};
 	bool interactive = false;
 	unsigned int debug_mask;
 	unsigned int len;
 	int i, val, rc;
 
+	if (nft_opts_init(argc, argv, &opts) < 0) {
+		nft_opts_release(&opts);
+		fprintf(stderr, "OOM\n");
+		exit(EXIT_FAILURE);
+	}
+
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 
 	while (1) {
-		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
+		val = getopt_long(opts.argc, opts.argv, OPTSTRING, options,
+				  NULL);
 		if (val == -1)
 			break;
 
 		switch (val) {
 		case OPT_HELP:
 			show_help(argv[0]);
+			nft_opts_release(&opts);
 			exit(EXIT_SUCCESS);
 		case OPT_VERSION:
 			printf("%s v%s (%s)\n",
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
+			nft_opts_release(&opts);
 			exit(EXIT_SUCCESS);
 		case OPT_CHECK:
 			nft_ctx_set_dry_run(nft, true);
@@ -240,6 +318,7 @@ int main(int argc, char * const *argv)
 				fprintf(stderr,
 					"Failed to add include path '%s'\n",
 					optarg);
+				nft_opts_release(&opts);
 				exit(EXIT_FAILURE);
 			}
 			break;
@@ -275,6 +354,7 @@ int main(int argc, char * const *argv)
 				if (i == array_size(debug_param)) {
 					fprintf(stderr, "invalid debug parameter `%s'\n",
 						optarg);
+					nft_opts_release(&opts);
 					exit(EXIT_FAILURE);
 				}
 
@@ -295,6 +375,7 @@ int main(int argc, char * const *argv)
 			output_flags |= NFT_CTX_OUTPUT_JSON;
 #else
 			fprintf(stderr, "JSON support not compiled-in\n");
+			nft_opts_release(&opts);
 			exit(EXIT_FAILURE);
 #endif
 			break;
@@ -314,24 +395,32 @@ int main(int argc, char * const *argv)
 			output_flags |= NFT_CTX_OUTPUT_TERSE;
 			break;
 		case OPT_INVALID:
+			nft_opts_release(&opts);
 			exit(EXIT_FAILURE);
 		}
 	}
 
 	nft_ctx_output_set_flags(nft, output_flags);
 
+	if (nft_opts_update(&opts) < 0) {
+		nft_opts_release(&opts);
+		fprintf(stderr, "OOM\n");
+		exit(EXIT_FAILURE);
+	}
+
 	if (optind != argc) {
 		for (len = 0, i = optind; i < argc; i++)
-			len += strlen(argv[i]) + strlen(" ");
+			len += strlen(opts.argv[i]) + strlen(" ");
 
 		buf = calloc(1, len);
 		if (buf == NULL) {
 			fprintf(stderr, "%s:%u: Memory allocation failure\n",
 				__FILE__, __LINE__);
+			nft_opts_release(&opts);
 			exit(EXIT_FAILURE);
 		}
 		for (i = optind; i < argc; i++) {
-			strcat(buf, argv[i]);
+			strcat(buf, opts.argv[i]);
 			if (i + 1 < argc)
 				strcat(buf, " ");
 		}
@@ -342,14 +431,17 @@ int main(int argc, char * const *argv)
 		if (cli_init(nft) < 0) {
 			fprintf(stderr, "%s: interactive CLI not supported in this build\n",
 				argv[0]);
+			nft_opts_release(&opts);
 			exit(EXIT_FAILURE);
 		}
 		return EXIT_SUCCESS;
 	} else {
 		fprintf(stderr, "%s: no command specified\n", argv[0]);
+		nft_opts_release(&opts);
 		exit(EXIT_FAILURE);
 	}
 
+	nft_opts_release(&opts);
 	free(buf);
 	nft_ctx_free(nft);
 
-- 
2.11.0

