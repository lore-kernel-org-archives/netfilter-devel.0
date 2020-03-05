Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C2CC3F2D8
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8958320848
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 14:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="gsbtKfG+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCEOsI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:48:08 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55990 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgCEOsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 09:48:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LGKUW0CNdNC0JrYJDiGFbVebatK78b0zzmdr+eZ9D44=; b=gsbtKfG+idA5e9UnoulxmLHmV3
        vQQ+E8Jj+lS2KvDlNJftfiT/Jumk+2KRBuub8waMke7iicSzklqS7TgbCGBFM6SjAaxXLI8K325yP
        UbZ37yDhJHFWFWRAPVj4AbjxsohvwHsZJwwYubminqy6GKEQsD8A994/IJZP1RkeM4SscfAu9DthD
        A9Wg48iE7PCXHEbZcwYAp5Q0vVuIqAH+r/15UYncE76WVwU+3H6EUx+H7jAMi6R2I4GjOcmCPOj79
        4l8yJi1ACwxbfkzRmrLFgTYh/v6xUP5mYmagNdZHR30Pwm3qyXFbbA1tQFOOqKID0FZ2XdHfWfXCv
        KpSSKOqg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j9rnB-0006kU-Rt; Thu, 05 Mar 2020 14:48:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 4/4] main: use one data-structure to initialize getopt_long(3) arguments and help.
Date:   Thu,  5 Mar 2020 14:48:05 +0000
Message-Id: <20200305144805.143783-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200305144805.143783-1-jeremy@azazel.net>
References: <20200305144805.143783-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By generating the getopt_long(3) optstring and options, and the help
from one source, we reduce the chance that they may get out of sync.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/main.c | 251 +++++++++++++++++++++++++++++------------------------
 1 file changed, 138 insertions(+), 113 deletions(-)

diff --git a/src/main.c b/src/main.c
index 4e9a2ed3bcec..1ee4d957a152 100644
--- a/src/main.c
+++ b/src/main.c
@@ -24,6 +24,19 @@
 
 static struct nft_ctx *nft;
 
+/*
+ * These options are grouped separately in the help, so we give them named
+ * indices for use there.
+ */
+enum opt_indices {
+	IDX_HELP,
+	IDX_VERSION,
+	IDX_VERSION_LONG,
+	IDX_CHECK,
+	IDX_FILE,
+	IDX_INTERACTIVE,
+};
+
 enum opt_vals {
 	OPT_HELP		= 'h',
 	OPT_VERSION		= 'v',
@@ -47,123 +60,133 @@ enum opt_vals {
 	OPT_TERSE		= 't',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"+hvVcf:iI:jnsNSd:aeuypTt"
 
-static const struct option options[] = {
-	{
-		.name		= "help",
-		.val		= OPT_HELP,
-	},
-	{
-		.name		= "version",
-		.val		= OPT_VERSION,
-	},
-	{
-		.name		= "check",
-		.val		= OPT_CHECK,
-	},
-	{
-		.name		= "file",
-		.val		= OPT_FILE,
-		.has_arg	= 1,
-	},
-	{
-		.name		= "interactive",
-		.val		= OPT_INTERACTIVE,
-	},
-	{
-		.name		= "numeric",
-		.val		= OPT_NUMERIC,
-	},
-	{
-		.name		= "stateless",
-		.val		= OPT_STATELESS,
-	},
-	{
-		.name		= "reversedns",
-		.val		= OPT_IP2NAME,
-	},
-	{
-		.name		= "service",
-		.val		= OPT_SERVICE,
-	},
-	{
-		.name		= "includepath",
-		.val		= OPT_INCLUDEPATH,
-		.has_arg	= 1,
-	},
-	{
-		.name		= "debug",
-		.val		= OPT_DEBUG,
-		.has_arg	= 1,
-	},
-	{
-		.name		= "handle",
-		.val		= OPT_HANDLE_OUTPUT,
-	},
-	{
-		.name		= "echo",
-		.val		= OPT_ECHO,
-	},
-	{
-		.name		= "json",
-		.val		= OPT_JSON,
-	},
-	{
-		.name		= "guid",
-		.val		= OPT_GUID,
-	},
-	{
-		.name		= "numeric-priority",
-		.val		= OPT_NUMERIC_PRIO,
-	},
-	{
-		.name		= "numeric-protocol",
-		.val		= OPT_NUMERIC_PROTO,
-	},
-	{
-		.name		= "numeric-time",
-		.val		= OPT_NUMERIC_TIME,
-	},
-	{
-		.name		= "terse",
-		.val		= OPT_TERSE,
-	},
-	{
-		.name		= NULL
-	}
+struct nft_opt {
+	const char    *name;
+	enum opt_vals  val;
+	const char    *arg;
+	const char    *help;
+};
+
+#define NFT_OPT(n, v, a, h) \
+	(struct nft_opt) { .name = n, .val = v, .arg = a, .help = h }
+
+static const struct nft_opt nft_options[] = {
+	NFT_OPT("help",			OPT_HELP,		NULL,
+		"Show this help"),
+	NFT_OPT("version",		OPT_VERSION,		NULL,
+		"Show version information"),
+	NFT_OPT(NULL,                   OPT_VERSION_LONG,       NULL,
+		"Show extended version information"),
+	NFT_OPT("check",		OPT_CHECK,		NULL,
+		"Check commands validity without actually applying the changes."),
+	NFT_OPT("file",			OPT_FILE,		"<filename>",
+		"Read input from <filename>"),
+	NFT_OPT("interactive",		OPT_INTERACTIVE,	NULL,
+		"Read input from interactive CLI"),
+	NFT_OPT("numeric",		OPT_NUMERIC,		NULL,
+		"Print fully numerical output."),
+	NFT_OPT("stateless",		OPT_STATELESS,		NULL,
+		"Omit stateful information of ruleset."),
+	NFT_OPT("reversedns",		OPT_IP2NAME,		NULL,
+		"Translate IP addresses to names."),
+	NFT_OPT("service",		OPT_SERVICE,		NULL,
+		"Translate ports to service names as described in /etc/services."),
+	NFT_OPT("includepath",		OPT_INCLUDEPATH,	"<directory>",
+		"Add <directory> to the paths searched for include files. Default is: " DEFAULT_INCLUDE_PATH),
+	NFT_OPT("debug",		OPT_DEBUG,		"<level [,level...]>",
+		"Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
+	NFT_OPT("handle",		OPT_HANDLE_OUTPUT,	NULL,
+		"Output rule handle."),
+	NFT_OPT("echo",			OPT_ECHO,		NULL,
+		"Echo what has been added, inserted or replaced."),
+	NFT_OPT("json",			OPT_JSON,		NULL,
+		"Format output in JSON"),
+	NFT_OPT("guid",			OPT_GUID,		NULL,
+		"Print UID/GID as defined in /etc/passwd and /etc/group."),
+	NFT_OPT("numeric-priority",	OPT_NUMERIC_PRIO,	NULL,
+		"Print chain priority numerically."),
+	NFT_OPT("numeric-protocol",	OPT_NUMERIC_PROTO,	NULL,
+		"Print layer 4 protocols numerically."),
+	NFT_OPT("numeric-time",		OPT_NUMERIC_TIME,	NULL,
+		"Print time values numerically."),
+	NFT_OPT("terse",		OPT_TERSE,		NULL,
+		"Omit contents of sets."),
 };
 
+#define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
+
+static const char *get_optstring(void)
+{
+	static char optstring[NR_NFT_OPTIONS + 2];
+
+	if (!optstring[0]) {
+		size_t i, j;
+
+		optstring[0] = '+';
+		for (i = 0, j = 1; i < NR_NFT_OPTIONS; i++)
+			j += sprintf(optstring + j, "%c%s",
+				     nft_options[i].val,
+				     nft_options[i].arg ? ":" : "");
+	}
+	return optstring;
+}
+
+static const struct option *get_options(void)
+{
+	static struct option options[NR_NFT_OPTIONS + 1];
+
+	if (!options[0].name) {
+		size_t i, j;
+
+		for (i = 0, j = 0; i < NR_NFT_OPTIONS; ++i) {
+			if (nft_options[i].name) {
+				options[j].name    = nft_options[i].name;
+				options[j].val     = nft_options[i].val;
+				options[j].has_arg = nft_options[i].arg != NULL;
+				j++;
+			}
+		}
+	}
+	return options;
+}
+
+static void print_option(const struct nft_opt *opt)
+{
+	char optbuf[33] = "";
+	int i;
+
+	i = snprintf(optbuf, sizeof(optbuf), "  -%c", opt->val);
+	if (opt->name)
+		i += snprintf(optbuf + i, sizeof(optbuf) - i, ", %s", opt->name);
+	if (opt->arg)
+		i += snprintf(optbuf + i, sizeof(optbuf) - i, " %s", opt->arg);
+
+	printf("%-32s%s\n", optbuf, opt->help);
+}
+
 static void show_help(const char *name)
 {
-	printf(
-"Usage: %s [ options ] [ cmds... ]\n"
-"\n"
-"Options:\n"
-"  -h, --help				Show this help\n"
-"  -v, --version				Show version information\n"
-"  -V					Show extended version information\n"
-"\n"
-"  -c, --check				Check commands validity without actually applying the changes.\n"
-"  -f, --file <filename>			Read input from <filename>\n"
-"  -i, --interactive			Read input from interactive CLI\n"
-"\n"
-"  -j, --json				Format output in JSON\n"
-"  -n, --numeric				Print fully numerical output.\n"
-"  -s, --stateless			Omit stateful information of ruleset.\n"
-"  -t, --terse				Omit contents of sets.\n"
-"  -u, --guid				Print UID/GID as defined in /etc/passwd and /etc/group.\n"
-"  -N, --reversedns			Translate IP addresses to names.\n"
-"  -S, --service				Translate ports to service names as described in /etc/services.\n"
-"  -p, --numeric-protocol		Print layer 4 protocols numerically.\n"
-"  -y, --numeric-priority		Print chain priority numerically.\n"
-"  -T, --numeric-time			Print time values numerically.\n"
-"  -a, --handle				Output rule handle.\n"
-"  -e, --echo				Echo what has been added, inserted or replaced.\n"
-"  -I, --includepath <directory>		Add <directory> to the paths searched for include files. Default is: " DEFAULT_INCLUDE_PATH "\n"
-"  -d, --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
-"\n",
-	name);
+	printf("Usage: %s [ options ] [ cmds... ]\n"
+	       "\n"
+	       "Options:\n", name);
+
+	print_option(&nft_options[IDX_HELP]);
+	print_option(&nft_options[IDX_VERSION]);
+	print_option(&nft_options[IDX_VERSION_LONG]);
+
+	fputs("\n", stdout);
+
+	print_option(&nft_options[IDX_CHECK]);
+	print_option(&nft_options[IDX_FILE]);
+	print_option(&nft_options[IDX_INTERACTIVE]);
+
+	fputs("\n", stdout);
+
+	for (size_t i = IDX_INTERACTIVE + 1; i < NR_NFT_OPTIONS; ++i)
+		print_option(&nft_options[i]);
+
+	fputs("\n", stdout);
 }
 
 static void show_version(void)
@@ -288,6 +311,8 @@ static bool nft_options_check(int argc, char * const argv[])
 
 int main(int argc, char * const *argv)
 {
+	const struct option *options = get_options();
+	const char *optstring = get_optstring();
 	char *buf = NULL, *filename = NULL;
 	unsigned int output_flags = 0;
 	bool interactive = false;
@@ -301,7 +326,7 @@ int main(int argc, char * const *argv)
 	nft = nft_ctx_new(NFT_CTX_DEFAULT);
 
 	while (1) {
-		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
+		val = getopt_long(argc, argv, optstring, options, NULL);
 		if (val == -1)
 			break;
 
-- 
2.25.1

