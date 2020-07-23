Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8526C433E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 10:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46E220737
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 10:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgGWKiP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jul 2020 06:38:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50901 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728123AbgGWKiP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 06:38:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id c80so4516604wme.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 03:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=kO9V8JhFlxTn5JCtK6rPpmYwFb9gUDtxGIt8XuZ7rJU=;
        b=o/trqbj0fM/uk189Zu3vFhJbKGBOiRBHgsth80BDGdnfOHlIuFl/MVN30wBjUZcpwq
         xH+hYgkXb+HOWST4rACH6TAstuG18mVijwbTV1yiXKM15q+xS0gRySOeJ9zTEpMDd5Qp
         6YYLLt6gPItDVmVeB/2G2Vy3+iZ9OLN8SqnEbwml6WUTPwnbqKTNe2m/dWPCRqAx/c6w
         PtpjVXv2BB+7mmJQpyzVdsfO5SlWzZ6Y6UXP04ZYDWKL6S1Djtmz/xYv4XW6WrL9Qg62
         FddUk9KOcTK2mRu6I5ESZrogCqxf2mukupjK0qefpBRjE1FzxzpBzoEJYXoKScaDuNjl
         wTAA==
X-Gm-Message-State: AOAM530onu8UAu1fMiqXLvjkR05uK8VRRqLwOO1ey2rObdZhig5W/vP+
        0WG5i7fx6C/OFXtORo20iMoyHlwgZP4=
X-Google-Smtp-Source: ABdhPJxnmw33LW7vUCgEiccka4fqyPLAILiS6W6ouQO8e95IBnkLpMxMclHEiXoMhCbs2Vym5wbHjA==
X-Received: by 2002:a1c:3bc1:: with SMTP id i184mr3506977wma.119.1595500690896;
        Thu, 23 Jul 2020 03:38:10 -0700 (PDT)
Received: from localhost (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id c136sm3068939wmd.10.2020.07.23.03.38.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 03:38:10 -0700 (PDT)
Subject: [nft PATCH] nft: rearrange help output to group related options
 together
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Thu, 23 Jul 2020 12:38:09 +0200
Message-ID: <159550068914.41232.11789462187226358215.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It has been reported that nft options are a bit chaotic. With a growing list of options for the nft
CLI, we can do better when presenting them to the user who requests help.

This patch introduces a textual output grouping for options, in 4 groups:
  * Options (general)     -- common Unix utility options
  * Options (operative)   -- the options that modify the operative behaviour of nft
  * Options (translation) -- output text modifiers for data translation
  * Options (parsing)     -- output text modifiers for parsing and other operations

There is no behavior change in this patch, is mostly a cosmetic change in the hope that users will
find the nft tool a bit less confusing to use.

Before this patch, the help output was:

=== 8< ===
% nft --help
Usage: nft [ options ] [ cmds... ]

Options:
  -h, help                      Show this help
  -v, version                   Show version information
  -V                            Show extended version information

  -c, check                     Check commands validity without actually applying the changes.
  -f, file <filename>           Read input from <filename>
  -i, interactive               Read input from interactive CLI

  -n, numeric                   Print fully numerical output.
  -s, stateless                 Omit stateful information of ruleset.
  -N, reversedns                Translate IP addresses to names.
  -S, service                   Translate ports to service names as described in /etc/services.
  -I, includepath <directory>   Add <directory> to the paths searched for include files. Defaul[..]
  -d, debug <level [,level...]> Specify debugging level (scanner, parser, eval, netlink, mnl, p[..]
  -a, handle                    Output rule handle.
  -e, echo                      Echo what has been added, inserted or replaced.
  -j, json                      Format output in JSON
  -u, guid                      Print UID/GID as defined in /etc/passwd and /etc/group.
  -y, numeric-priority          Print chain priority numerically.
  -p, numeric-protocol          Print layer 4 protocols numerically.
  -T, numeric-time              Print time values numerically.
  -t, terse                     Omit contents of sets.
=== 8< ===

After this patch, the help output is:

=== 8< ===
% nft --help
Usage: nft [ options ] [ cmds... ]

Options (general):
  -h, help                      Show this help
  -v, version                   Show version information
  -V                            Show extended version information

Options (with operative meaning):
  -c, check                     Check commands validity without actually applying the changes.
  -f, file <filename>           Read input from <filename>
  -i, interactive               Read input from interactive CLI
  -I, includepath <directory>   Add <directory> to the paths searched for include files. Defaul[..]

Options (output text modifiers for data translation):
  -N, reversedns                Translate IP addresses to names.
  -S, service                   Translate ports to service names as described in /etc/services.
  -u, guid                      Print UID/GID as defined in /etc/passwd and /etc/group.
  -n, numeric                   Print fully numerical output.
  -y, numeric-priority          Print chain priority numerically.
  -p, numeric-protocol          Print layer 4 protocols numerically.
  -T, numeric-time              Print time values numerically.

Options (output text modifiers for parsing and other operations):
  -d, debug <level [,level...]> Specify debugging level (scanner, parser, eval, netlink, mnl, p[..]
  -e, echo                      Echo what has been added, inserted or replaced.
  -s, stateless                 Omit stateful information of ruleset.
  -a, handle                    Output rule handle.
  -j, json                      Format output in JSON
  -t, terse                     Omit contents of sets.
=== 8< ===

While at it, refresh the man page to better reflex this new grouping, and add some missing options.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 doc/nft.txt |   86 ++++++++++++++++++++++---------------
 src/main.c  |  139 +++++++++++++++++++++++++++++++++++++----------------------
 2 files changed, 138 insertions(+), 87 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index ba0c8c0b..e64c8e13 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -22,7 +22,10 @@ for Netfilter.
 
 OPTIONS
 -------
-For a full summary of options, run *nft --help*.
+The command accepts several different options which are documented here in groups for better
+understanding of their meaning. You can get information about options by running *nft --help*.
+
+.General options, common Unix utility options:
 
 *-h*::
 *--help*::
@@ -32,13 +35,30 @@ For a full summary of options, run *nft --help*.
 *--version*::
 	Show version.
 
-*-n*::
-*--numeric*::
-	Print fully numerical output.
+*-V*::
+	Show long version information, including compile-time configuration.
 
-*-s*::
-*--stateless*::
-	Omit stateful information of rules and stateful objects.
+.Operative options, options that modify the operative behavior of nft:
+
+*-c*::
+*--check*::
+	Check commands validity without actually applying the changes.
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
+.Output text modifiers options for data translation:
 
 *-N*::
 *--reversedns*::
@@ -53,49 +73,47 @@ For a full summary of options, run *nft --help*.
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
+.Output text modifiers options for parsing and other operations:
+
+*-d*::
+*--debug* 'level'::
+	Enable debugging output. The debug level can be any of *scanner*, *parser*, *eval*,
+        *netlink*, *mnl*, *proto-ctx*, *segtree*, *all*. You can combine more than one by
+        separating by the ',' symbol, for example '-d eval,mnl'.
 
 *-e*::
 *--echo*::
 	When inserting items into the ruleset using *add*, *insert* or *replace* commands, print notifications
 	just like *nft monitor*.
 
+*-s*::
+*--stateless*::
+	Omit stateful information of rules and stateful objects.
+
+*-a*::
+*--handle*::
+	Show object handles in output.
+
 *-j*::
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
 *-t*::
 *--terse*::
 	Omit contents of sets from output.
diff --git a/src/main.c b/src/main.c
index 6c182358..b4000710 100644
--- a/src/main.c
+++ b/src/main.c
@@ -24,17 +24,31 @@
 
 static struct nft_ctx *nft;
 
-/*
- * These options are grouped separately in the help, so we give them named
- * indices for use there.
- */
 enum opt_indices {
+        /* common options */
 	IDX_HELP,
 	IDX_VERSION,
 	IDX_VERSION_LONG,
+        /* operative options */
 	IDX_CHECK,
 	IDX_FILE,
 	IDX_INTERACTIVE,
+        IDX_INCLUDEPATH,
+        /* output text modifiers: translations */
+        IDX_REVERSEDNS,
+        IDX_SERVICE,
+        IDX_GUID,
+        IDX_NUMERIC,
+        IDX_NUMERIC_PRIO,
+        IDX_NUMERIC_PROTO,
+        IDX_NUMERIC_TIME,
+        /* output text modifiers: parsing and other operations */
+        IDX_DEBUG,
+        IDX_ECHO,
+        IDX_STATELESS,
+        IDX_HANDLE,
+        IDX_JSON,
+        IDX_TERSE,
 };
 
 enum opt_vals {
@@ -72,46 +86,46 @@ struct nft_opt {
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
+	[IDX_CHECK]	    = NFT_OPT("check",			OPT_CHECK,		NULL,
+				     "Check commands validity without actually applying the changes."),
+	[IDX_FILE]	    = NFT_OPT("file",			OPT_FILE,		"<filename>",
+				     "Read input from <filename>"),
+	[IDX_INTERACTIVE]   = NFT_OPT("interactive",		OPT_INTERACTIVE,	NULL,
+				     "Read input from interactive CLI"),
+	[IDX_NUMERIC]       = NFT_OPT("numeric",			OPT_NUMERIC,		NULL,
+				     "Print fully numerical output."),
+	[IDX_STATELESS]     = NFT_OPT("stateless",		OPT_STATELESS,		NULL,
+				     "Omit stateful information of ruleset."),
+	[IDX_REVERSEDNS]    = NFT_OPT("reversedns",		OPT_IP2NAME,		NULL,
+				     "Translate IP addresses to names."),
+	[IDX_SERVICE]       = NFT_OPT("service",			OPT_SERVICE,		NULL,
+				     "Translate ports to service names as described in /etc/services."),
+	[IDX_INCLUDEPATH]   = NFT_OPT("includepath",		OPT_INCLUDEPATH,	"<directory>",
+				     "Add <directory> to the paths searched for include files. Default is: " DEFAULT_INCLUDE_PATH),
+	[IDX_DEBUG]	    = NFT_OPT("debug",			OPT_DEBUG,		"<level [,level...]>",
+				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
+	[IDX_HANDLE]	    = NFT_OPT("handle",			OPT_HANDLE_OUTPUT,	NULL,
+				     "Output rule handle."),
+	[IDX_ECHO]	    = NFT_OPT("echo",			OPT_ECHO,		NULL,
+				     "Echo what has been added, inserted or replaced."),
+	[IDX_JSON]	    = NFT_OPT("json",			OPT_JSON,		NULL,
+				     "Format output in JSON"),
+	[IDX_GUID]	    = NFT_OPT("guid",			OPT_GUID,		NULL,
+				     "Print UID/GID as defined in /etc/passwd and /etc/group."),
+	[IDX_NUMERIC_PRIO]  = NFT_OPT("numeric-priority",	OPT_NUMERIC_PRIO,	NULL,
+				     "Print chain priority numerically."),
+	[IDX_NUMERIC_PROTO] = NFT_OPT("numeric-protocol",	OPT_NUMERIC_PROTO,	NULL,
+				     "Print layer 4 protocols numerically."),
+	[IDX_NUMERIC_TIME]  = NFT_OPT("numeric-time",		OPT_NUMERIC_TIME,	NULL,
+				      "Print time values numerically."),
+	[IDX_TERSE]	    = NFT_OPT("terse",			OPT_TERSE,		NULL,
+				      "Omit contents of sets."),
 };
 
 #define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
@@ -169,26 +183,45 @@ static void print_option(const struct nft_opt *opt)
 
 static void show_help(const char *name)
 {
-	size_t i;
-
 	printf("Usage: %s [ options ] [ cmds... ]\n"
 	       "\n"
-	       "Options:\n", name);
+	       "Options (general):\n", name);
 
 	print_option(&nft_options[IDX_HELP]);
 	print_option(&nft_options[IDX_VERSION]);
 	print_option(&nft_options[IDX_VERSION_LONG]);
 
-	fputs("\n", stdout);
+        printf("\n"
+               "Options (with operative meaning):"
+               "\n");
 
 	print_option(&nft_options[IDX_CHECK]);
 	print_option(&nft_options[IDX_FILE]);
 	print_option(&nft_options[IDX_INTERACTIVE]);
-
-	fputs("\n", stdout);
-
-	for (i = IDX_INTERACTIVE + 1; i < NR_NFT_OPTIONS; ++i)
-		print_option(&nft_options[i]);
+	print_option(&nft_options[IDX_INCLUDEPATH]);
+
+        printf("\n"
+               "Options (output text modifiers for data translation):"
+               "\n");
+
+	print_option(&nft_options[IDX_REVERSEDNS]);
+	print_option(&nft_options[IDX_SERVICE]);
+	print_option(&nft_options[IDX_GUID]);
+	print_option(&nft_options[IDX_NUMERIC]);
+	print_option(&nft_options[IDX_NUMERIC_PRIO]);
+	print_option(&nft_options[IDX_NUMERIC_PROTO]);
+	print_option(&nft_options[IDX_NUMERIC_TIME]);
+
+        printf("\n"
+               "Options (output text modifiers for parsing and other operations):"
+               "\n");
+
+	print_option(&nft_options[IDX_DEBUG]);
+	print_option(&nft_options[IDX_ECHO]);
+	print_option(&nft_options[IDX_STATELESS]);
+	print_option(&nft_options[IDX_HANDLE]);
+	print_option(&nft_options[IDX_JSON]);
+	print_option(&nft_options[IDX_TERSE]);
 
 	fputs("\n", stdout);
 }

