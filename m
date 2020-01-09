Return-Path: <SRS0=zMD2=26=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3048C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35492067D
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 17:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387878AbgAIRV0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 12:21:26 -0500
Received: from correo.us.es ([193.147.175.20]:58614 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgAIRV0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 12:21:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4243AE8D65
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32DACDA705
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 28504DA703; Thu,  9 Jan 2020 18:21:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21E2BDA705
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 18:21:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0D91942EE38E
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 18:21:21 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] main: add -w/--netns option
Date:   Thu,  9 Jan 2020 18:21:15 +0100
Message-Id: <20200109172115.229723-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200109172115.229723-1-pablo@netfilter.org>
References: <20200109172115.229723-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This option allows you to specify which net namespace you want to run this
command on.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt |  4 ++++
 src/main.c  | 28 +++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 45350253ccbf..a668c33b3c6d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -32,6 +32,10 @@ For a full summary of options, run *nft --help*.
 *--version*::
 	Show version.
 
+*-w*::
+*--netns 'namespace'*::
+	Run command on the specified net namespace.
+
 *-n*::
 *--numeric*::
 	Print fully numerical output.
diff --git a/src/main.c b/src/main.c
index 0f2b57cbacbb..df88c028fcb3 100644
--- a/src/main.c
+++ b/src/main.c
@@ -28,6 +28,7 @@ enum opt_vals {
 	OPT_HELP		= 'h',
 	OPT_VERSION		= 'v',
 	OPT_CHECK		= 'c',
+	OPT_NETNS		= 'w',
 	OPT_FILE		= 'f',
 	OPT_INTERACTIVE		= 'i',
 	OPT_INCLUDEPATH		= 'I',
@@ -46,7 +47,7 @@ enum opt_vals {
 	OPT_TERSE		= 't',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"+hvd:cf:iI:jvnsNaeSupypTt"
+#define OPTSTRING	"+hvd:cf:iI:jvnsNaeSupypTtw:"
 
 static const struct option options[] = {
 	{
@@ -129,6 +130,11 @@ static const struct option options[] = {
 		.val		= OPT_TERSE,
 	},
 	{
+		.name		= "netns",
+		.val		= OPT_NETNS,
+		.has_arg	= 1,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -150,6 +156,7 @@ static void show_help(const char *name)
 "  -n, --numeric			Print fully numerical output.\n"
 "  -s, --stateless		Omit stateful information of ruleset.\n"
 "  -t, --terse			Omit contents of sets.\n"
+"  -w, --netns			Run command on network namespace\n"
 "  -u, --guid			Print UID/GID as defined in /etc/passwd and /etc/group.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -S, --service			Translate ports to service names as described in /etc/services.\n"
@@ -231,9 +238,11 @@ static bool nft_options_check(int argc, char * const argv[])
 			} else if (argv[i][1] == 'd' ||
 				   argv[i][1] == 'I' ||
 				   argv[i][1] == 'f' ||
+				   argv[i][1] == 'w' ||
 				   !strcmp(argv[i], "--debug") ||
 				   !strcmp(argv[i], "--includepath") ||
-				   !strcmp(argv[i], "--file")) {
+				   !strcmp(argv[i], "--file") ||
+				   !strcmp(argv[i], "--netns")) {
 				skip = true;
 				continue;
 			}
@@ -247,10 +256,10 @@ static bool nft_options_check(int argc, char * const argv[])
 
 int main(int argc, char * const *argv)
 {
-	char *buf = NULL, *filename = NULL, *includepath = NULL;
+	char *buf = NULL, *filename = NULL, *includepath = NULL, *netns = NULL;
 	unsigned int output_flags = 0, debug_mask = 0, len;
 	bool interactive = false, dry_run = false;
-	int i, val, rc;
+	int i, val, rc, ctx = NFT_CTX_DEFAULT;
 
 	if (!nft_options_check(argc, argv))
 		exit(EXIT_FAILURE);
@@ -271,6 +280,9 @@ int main(int argc, char * const *argv)
 		case OPT_CHECK:
 			dry_run = true;
 			break;
+		case OPT_NETNS:
+			netns = optarg;
+			break;
 		case OPT_FILE:
 			filename = optarg;
 			break;
@@ -353,12 +365,18 @@ int main(int argc, char * const *argv)
 		}
 	}
 
-	nft = nft_ctx_new(NFT_CTX_DEFAULT);
+	if (netns)
+		ctx = NFT_CTX_NETNS;
+
+	nft = nft_ctx_new(ctx);
 	if (includepath && nft_ctx_add_include_path(nft, includepath) < 0) {
 		fprintf(stderr, "Failed to add include path '%s'\n", optarg);
 		exit(EXIT_FAILURE);
 	}
 
+	if (netns && nft_ctx_set_netns(nft, netns) < 0)
+		exit(EXIT_FAILURE);
+
 	nft_ctx_set_dry_run(nft, dry_run);
 	nft_ctx_output_set_debug(nft, debug_mask);
 	nft_ctx_output_set_flags(nft, output_flags);
-- 
2.11.0

