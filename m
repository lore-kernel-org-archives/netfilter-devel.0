Return-Path: <SRS0=nQ4N=BG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F552C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 16:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C2B220672
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 16:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgG0QLj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 12:11:39 -0400
Received: from correo.us.es ([193.147.175.20]:60114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgG0QLj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 12:11:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 62546E8E86
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 18:11:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53D03DA78D
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 18:11:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4974DDA78B; Mon, 27 Jul 2020 18:11:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C66A8DA789;
        Mon, 27 Jul 2020 18:11:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 27 Jul 2020 18:11:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A9D774265A2F;
        Mon, 27 Jul 2020 18:11:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     arturo@netfilter.org
Subject: [PATCH nft] nft: rearrange help output to group related options together
Date:   Mon, 27 Jul 2020 18:11:29 +0200
Message-Id: <20200727161129.31632-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Arturo Borrero Gonzalez <arturo@netfilter.org>

It has been reported that nft options are a bit chaotic. With a growing list of options for the nft
CLI, we can do better when presenting them to the user who requests help.

This patch introduces a textual output grouping for options, in 4 groups:
  * Options (general)     -- common Unix utility options
  * Options (operative)   -- the options that modify the operative behaviour of nft
  * Options (translation) -- output text modifiers for data translation
  * Options (parsing)     -- output text modifiers for parsing and other operations

There is no behavior change in this patch, is mostly a cosmetic change in the hope that users will
find the nft tool a bit less confusing to use.

After this patch, the help output is:

=== 8< ===
% nft --help
Usage: nft [ options ] [ cmds... ]

Options (general):
  -h, help                      Show this help
  -v, version                   Show version information
  -V                            Show extended version information

Options (ruleset input handling):
  -f, file <filename>           Read input from <filename>
  -i, interactive               Read input from interactive CLI
  -I, includepath <directory>   Add <directory> to the paths searched for include files. Defaul[..]
  -c, check                     Check commands validity without actually applying the changes.

Options (ruleset list formatting):
  -a, handle                    Output rule handle.
  -s, stateless                 Omit stateful information of ruleset.
  -t, terse                     Omit contents of sets.
  -S, service                   Translate ports to service names as described in /etc/services.
  -N, reversedns                Translate IP addresses to names.
  -u, guid                      Print UID/GID as defined in /etc/passwd and /etc/group.
  -n, numeric                   Print fully numerical output.
  -y, numeric-priority          Print chain priority numerically.
  -p, numeric-protocol          Print layer 4 protocols numerically.
  -T, numeric-time              Print time values numerically.

Options (command output format):
  -e, echo                      Echo what has been added, inserted or replaced.
  -j, json                      Format output in JSON
  -d, debug <level [,level...]> Specify debugging level (scanner, parser, eval, netlink, mnl, p[..]
=== 8< ===

While at it, refresh the man page to better reflex this new grouping, and add some missing options.

Joint work with Pablo.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.txt |  94 +++++++++++++++++++++---------------
 src/main.c  | 136 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 139 insertions(+), 91 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index ba0c8c0bef44..5326de167de8 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -22,7 +22,10 @@ for Netfilter.
 
 OPTIONS
 -------
-For a full summary of options, run *nft --help*.
+The command accepts several different options which are documented here in groups for better
+understanding of their meaning. You can get information about options by running *nft --help*.
+
+.General options:
 
 *-h*::
 *--help*::
@@ -32,42 +35,73 @@ For a full summary of options, run *nft --help*.
 *--version*::
 	Show version.
 
-*-n*::
-*--numeric*::
-	Print fully numerical output.
+*-V*::
+	Show long version information, including compile-time configuration.
+
+.Ruleset input handling options that specify to how to load rulesets:
+
+*-f*::
+*--file 'filename'*::
+	Read input from 'filename'. If 'filename' is -, read from stdin.
+
+*-i*::
+*--interactive*::
+	Read input from an interactive readline CLI. You can use quit to exit, or use the EOF marker,
+	normally this is CTRL-D.
+
+*-I*::
+*--includepath directory*::
+	Add the directory 'directory' to the list of directories to be searched for included files. This
+	option may be specified multiple times.
+
+*-c*::
+*--check*::
+	Check commands validity without actually applying the changes.
+
+.Ruleset list output formatting that modify the output of the list ruleset command:
+
+*-a*::
+*--handle*::
+	Show object handles in output.
 
 *-s*::
 *--stateless*::
 	Omit stateful information of rules and stateful objects.
 
-*-N*::
-*--reversedns*::
-	Translate IP address to names via reverse DNS lookup. This may slow down
-	your listing since it generates network traffic.
+*-t*::
+*--terse*::
+	Omit contents of sets from output.
 
 *-S*::
 *--service*::
 	Translate ports to service names as defined by /etc/services.
 
+*-N*::
+*--reversedns*::
+	Translate IP address to names via reverse DNS lookup. This may slow down
+	your listing since it generates network traffic.
+
 *-u*::
 *--guid*::
 	Translate numeric UID/GID to names as defined by /etc/passwd and /etc/group.
 
-*-p*::
-*--numeric-protocol*::
-	Display layer 4 protocol numerically.
+*-n*::
+*--numeric*::
+	Print fully numerical output.
 
 *-y*::
 *--numeric-priority*::
 	Display base chain priority numerically.
 
-*-c*::
-*--check*::
-	Check commands validity without actually applying the changes.
+*-p*::
+*--numeric-protocol*::
+	Display layer 4 protocol numerically.
 
-*-a*::
-*--handle*::
-	Show object handles in output.
+*-T*::
+*--numeric-time*::
+	Show time, day and hour values in numeric format.
+
+.Command output formatting:
 
 *-e*::
 *--echo*::
@@ -78,27 +112,11 @@ For a full summary of options, run *nft --help*.
 *--json*::
 	Format output in JSON. See libnftables-json(5) for a schema description.
 
-*-I*::
-*--includepath directory*::
-	Add the directory 'directory' to the list of directories to be searched for included files. This
-	option may be specified multiple times.
-
-*-f*::
-*--file 'filename'*::
-	Read input from 'filename'. If 'filename' is -, read from stdin.
-
-*-i*::
-*--interactive*::
-	Read input from an interactive readline CLI. You can use quit to exit, or use the EOF marker,
-	normally this is CTRL-D.
-
-*-T*::
-*--numeric-time*::
-	Show time, day and hour values in numeric format.
-
-*-t*::
-*--terse*::
-	Omit contents of sets from output.
+*-d*::
+*--debug* 'level'::
+	Enable debugging output. The debug level can be any of *scanner*, *parser*, *eval*,
+        *netlink*, *mnl*, *proto-ctx*, *segtree*, *all*. You can combine more than one by
+        separating by the ',' symbol, for example '-d eval,mnl'.
 
 INPUT FILE FORMATS
 ------------------
diff --git a/src/main.c b/src/main.c
index 6c18235821fc..3c26f51029ff 100644
--- a/src/main.c
+++ b/src/main.c
@@ -24,17 +24,37 @@
 
 static struct nft_ctx *nft;
 
-/*
- * These options are grouped separately in the help, so we give them named
- * indices for use there.
- */
 enum opt_indices {
+        /* General options */
 	IDX_HELP,
 	IDX_VERSION,
 	IDX_VERSION_LONG,
-	IDX_CHECK,
+        /* Ruleset input handling */
 	IDX_FILE,
+#define IDX_RULESET_INPUT_START	IDX_FILE
 	IDX_INTERACTIVE,
+        IDX_INCLUDEPATH,
+	IDX_CHECK,
+#define IDX_RULESET_INPUT_END	IDX_CHECK
+        /* Ruleset list formatting */
+        IDX_HANDLE,
+#define IDX_RULESET_LIST_START	IDX_HANDLE
+        IDX_STATELESS,
+        IDX_TERSE,
+        IDX_SERVICE,
+        IDX_REVERSEDNS,
+        IDX_GUID,
+        IDX_NUMERIC,
+        IDX_NUMERIC_PRIO,
+        IDX_NUMERIC_PROTO,
+        IDX_NUMERIC_TIME,
+#define IDX_RULESET_LIST_END IDX_NUMERIC_TIME
+        /* Command output formatting */
+        IDX_ECHO,
+#define IDX_CMD_OUTPUT_START	IDX_ECHO
+        IDX_JSON,
+        IDX_DEBUG,
+#define IDX_CMD_OUTPUT_END	IDX_DEBUG
 };
 
 enum opt_vals {
@@ -72,46 +92,46 @@ struct nft_opt {
 	(struct nft_opt) { .name = n, .val = v, .arg = a, .help = h }
 
 static const struct nft_opt nft_options[] = {
-	NFT_OPT("help",			OPT_HELP,		NULL,
-		"Show this help"),
-	NFT_OPT("version",		OPT_VERSION,		NULL,
-		"Show version information"),
-	NFT_OPT(NULL,                   OPT_VERSION_LONG,       NULL,
-		"Show extended version information"),
-	NFT_OPT("check",		OPT_CHECK,		NULL,
-		"Check commands validity without actually applying the changes."),
-	NFT_OPT("file",			OPT_FILE,		"<filename>",
-		"Read input from <filename>"),
-	NFT_OPT("interactive",		OPT_INTERACTIVE,	NULL,
-		"Read input from interactive CLI"),
-	NFT_OPT("numeric",		OPT_NUMERIC,		NULL,
-		"Print fully numerical output."),
-	NFT_OPT("stateless",		OPT_STATELESS,		NULL,
-		"Omit stateful information of ruleset."),
-	NFT_OPT("reversedns",		OPT_IP2NAME,		NULL,
-		"Translate IP addresses to names."),
-	NFT_OPT("service",		OPT_SERVICE,		NULL,
-		"Translate ports to service names as described in /etc/services."),
-	NFT_OPT("includepath",		OPT_INCLUDEPATH,	"<directory>",
-		"Add <directory> to the paths searched for include files. Default is: " DEFAULT_INCLUDE_PATH),
-	NFT_OPT("debug",		OPT_DEBUG,		"<level [,level...]>",
-		"Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
-	NFT_OPT("handle",		OPT_HANDLE_OUTPUT,	NULL,
-		"Output rule handle."),
-	NFT_OPT("echo",			OPT_ECHO,		NULL,
-		"Echo what has been added, inserted or replaced."),
-	NFT_OPT("json",			OPT_JSON,		NULL,
-		"Format output in JSON"),
-	NFT_OPT("guid",			OPT_GUID,		NULL,
-		"Print UID/GID as defined in /etc/passwd and /etc/group."),
-	NFT_OPT("numeric-priority",	OPT_NUMERIC_PRIO,	NULL,
-		"Print chain priority numerically."),
-	NFT_OPT("numeric-protocol",	OPT_NUMERIC_PROTO,	NULL,
-		"Print layer 4 protocols numerically."),
-	NFT_OPT("numeric-time",		OPT_NUMERIC_TIME,	NULL,
-		"Print time values numerically."),
-	NFT_OPT("terse",		OPT_TERSE,		NULL,
-		"Omit contents of sets."),
+	[IDX_HELP]          = NFT_OPT("help",			OPT_HELP,		NULL,
+				     "Show this help"),
+	[IDX_VERSION]       = NFT_OPT("version",			OPT_VERSION,		NULL,
+				     "Show version information"),
+	[IDX_VERSION_LONG]  = NFT_OPT(NULL,			OPT_VERSION_LONG,	NULL,
+				     "Show extended version information"),
+	[IDX_FILE]	    = NFT_OPT("file",			OPT_FILE,		"<filename>",
+				     "Read input from <filename>"),
+	[IDX_INTERACTIVE]   = NFT_OPT("interactive",		OPT_INTERACTIVE,	NULL,
+				     "Read input from interactive CLI"),
+	[IDX_INCLUDEPATH]   = NFT_OPT("includepath",		OPT_INCLUDEPATH,	"<directory>",
+				     "Add <directory> to the paths searched for include files. Default is: " DEFAULT_INCLUDE_PATH),
+	[IDX_CHECK]	    = NFT_OPT("check",			OPT_CHECK,		NULL,
+				     "Check commands validity without actually applying the changes."),
+	[IDX_HANDLE]	    = NFT_OPT("handle",			OPT_HANDLE_OUTPUT,	NULL,
+				     "Output rule handle."),
+	[IDX_STATELESS]     = NFT_OPT("stateless",		OPT_STATELESS,		NULL,
+				     "Omit stateful information of ruleset."),
+	[IDX_TERSE]	    = NFT_OPT("terse",			OPT_TERSE,		NULL,
+				      "Omit contents of sets."),
+	[IDX_SERVICE]       = NFT_OPT("service",			OPT_SERVICE,		NULL,
+				     "Translate ports to service names as described in /etc/services."),
+	[IDX_REVERSEDNS]    = NFT_OPT("reversedns",		OPT_IP2NAME,		NULL,
+				     "Translate IP addresses to names."),
+	[IDX_GUID]	    = NFT_OPT("guid",			OPT_GUID,		NULL,
+				     "Print UID/GID as defined in /etc/passwd and /etc/group."),
+	[IDX_NUMERIC]       = NFT_OPT("numeric",			OPT_NUMERIC,		NULL,
+				     "Print fully numerical output."),
+	[IDX_NUMERIC_PRIO]  = NFT_OPT("numeric-priority",	OPT_NUMERIC_PRIO,	NULL,
+				     "Print chain priority numerically."),
+	[IDX_NUMERIC_PROTO] = NFT_OPT("numeric-protocol",	OPT_NUMERIC_PROTO,	NULL,
+				     "Print layer 4 protocols numerically."),
+	[IDX_NUMERIC_TIME]  = NFT_OPT("numeric-time",		OPT_NUMERIC_TIME,	NULL,
+				      "Print time values numerically."),
+	[IDX_ECHO]	    = NFT_OPT("echo",			OPT_ECHO,		NULL,
+				     "Echo what has been added, inserted or replaced."),
+	[IDX_JSON]	    = NFT_OPT("json",			OPT_JSON,		NULL,
+				     "Format output in JSON"),
+	[IDX_DEBUG]	    = NFT_OPT("debug",			OPT_DEBUG,		"<level [,level...]>",
+				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
 };
 
 #define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
@@ -169,25 +189,35 @@ static void print_option(const struct nft_opt *opt)
 
 static void show_help(const char *name)
 {
-	size_t i;
+	int i;
 
 	printf("Usage: %s [ options ] [ cmds... ]\n"
 	       "\n"
-	       "Options:\n", name);
+	       "Options (general):\n", name);
 
 	print_option(&nft_options[IDX_HELP]);
 	print_option(&nft_options[IDX_VERSION]);
 	print_option(&nft_options[IDX_VERSION_LONG]);
 
-	fputs("\n", stdout);
+	printf("\n"
+	       "Options (ruleset input handling):"
+	       "\n");
 
-	print_option(&nft_options[IDX_CHECK]);
-	print_option(&nft_options[IDX_FILE]);
-	print_option(&nft_options[IDX_INTERACTIVE]);
+	for (i = IDX_RULESET_INPUT_START; i <= IDX_RULESET_INPUT_END; i++)
+		print_option(&nft_options[i]);
 
-	fputs("\n", stdout);
+	printf("\n"
+	       "Options (ruleset list formatting):"
+	       "\n");
+
+	for (i = IDX_RULESET_LIST_START; i <= IDX_RULESET_LIST_END; i++)
+		print_option(&nft_options[i]);
+
+	printf("\n"
+	       "Options (command output formatting):"
+	       "\n");
 
-	for (i = IDX_INTERACTIVE + 1; i < NR_NFT_OPTIONS; ++i)
+	for (i = IDX_CMD_OUTPUT_START; i <= IDX_CMD_OUTPUT_END; i++)
 		print_option(&nft_options[i]);
 
 	fputs("\n", stdout);
-- 
2.20.1

