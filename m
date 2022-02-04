Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519C3C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 17:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiBDRAL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbiBDRAL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 12:00:11 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07CEC061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 09:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oYwQvU3Pw9c8nQOATLApDJ618FRz4vc7ZTDJ+/tSaS0=; b=WzzDDcS3qXETSDyOaFHd/TFYEp
        XSiKctBoklizZp0yvuzelGbfGWzZYE/XsV1d8EJpBEi6lSCHK4YF0A+GebJDnBHCoB73iuj83OCHA
        C0lPb2eCzBnSb1UxKLxRWEJcoEr9BeqLEY9FkK9LlvWxTif4yAIHjf/lLDh4S3bAdivro2mIuVpwz
        IH4rGOF0z7hf+o1cD4n0MGgnXilvRByyptnL+0vZSSyhxcoS4yMLDuF2UEZd0UA7Yo6EPbY5HS3Je
        zLp9KssZPaE6wZGSwYpsDnoWbn0dCUB80YYzBfjP7dL8Cvlkp6JfI1LrubWxFoC5pfmWVpK9KGff0
        Tdc6QaJw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nG1wN-00049L-SI; Fri, 04 Feb 2022 18:00:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] ebtables: Support verbose mode
Date:   Fri,  4 Feb 2022 17:59:59 +0100
Message-Id: <20220204170001.27198-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204170001.27198-1-phil@nwl.cc>
References: <20220204170001.27198-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept '-v' flag in both ebtables-nft and ebtables-nft-restore. Mostly
interesting because it allows for netlink debug output when specified
multiple times.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ebtables-nft.8    |  6 ++++++
 iptables/xtables-eb.c      | 25 ++++++++++++++++++-------
 iptables/xtables-restore.c |  8 ++++++--
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 08e9766f2cc74..d75aae240bc05 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -307,6 +307,12 @@ of the ebtables kernel table.
 Replace the current table data by the initial table data.
 .SS MISCELLANOUS COMMANDS
 .TP
+.B "-v, --verbose"
+Verbose mode.
+For appending, insertion, deletion and replacement, this causes
+detailed information on the rule or rules to be printed. \fB\-v\fP may be
+specified multiple times to possibly emit more detailed debug statements.
+.TP
 .B "-V, --version"
 Show the version of the ebtables userspace program.
 .TP
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 060e06c57a481..1e5b50ba5b0ab 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -195,6 +195,7 @@ struct option ebt_original_options[] =
 	{ "out-interface"  , required_argument, 0, 'o' },
 	{ "out-if"         , required_argument, 0, 'o' },
 	{ "version"        , no_argument      , 0, 'V' },
+	{ "verbose"        , no_argument      , 0, 'v' },
 	{ "help"           , no_argument      , 0, 'h' },
 	{ "jump"           , required_argument, 0, 'j' },
 	{ "set-counters"   , required_argument, 0, 'c' },
@@ -219,7 +220,7 @@ struct option ebt_original_options[] =
 struct xtables_globals ebtables_globals = {
 	.option_offset 		= 0,
 	.program_version	= PACKAGE_VERSION " (nf_tables)",
-	.optstring		= OPTSTRING_COMMON "h",
+	.optstring		= OPTSTRING_COMMON "hv",
 	.orig_opts		= ebt_original_options,
 	.compat_rev		= nft_compatible_revision,
 };
@@ -325,6 +326,7 @@ static void print_help(const struct xtables_target *t,
 "          pcnt bcnt           : set the counters of the to be added rule\n"
 "--modprobe -M program         : try to insert modules using this program\n"
 "--concurrent                  : use a file lock to support concurrent scripts\n"
+"--verbose -v                  : verbose mode\n"
 "--version -V                  : print package version\n\n"
 "Environment variable:\n"
 /*ATOMIC_ENV_VARIABLE "          : if set <FILE> (see above) will equal its value"*/
@@ -726,6 +728,9 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	struct ebt_match *match;
 	bool table_set = false;
 
+	/* avoid cumulating verbosity with ebtables-restore */
+	h->verbose = 0;
+
 	/* prevent getopt to spoil our error reporting */
 	optind = 0;
 	opterr = false;
@@ -854,6 +859,10 @@ print_zero:
 				optind++;
 			}
 			break;
+		case 'v': /* verbose */
+			flags |= OPT_VERBOSE;
+			h->verbose++;
+			break;
 		case 'V': /* Version */
 			if (OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
@@ -1146,24 +1155,26 @@ print_zero:
 		}
 	} else if (command == 'L') {
 		ret = list_rules(h, chain, *table, rule_nr,
-				 0,
+				 flags & OPT_VERBOSE,
 				 0,
 				 /*flags&OPT_EXPANDED*/0,
 				 flags&LIST_N,
 				 flags&LIST_C);
 	}
 	if (flags & OPT_ZERO) {
-		ret = nft_cmd_chain_zero_counters(h, chain, *table, 0);
+		ret = nft_cmd_chain_zero_counters(h, chain, *table,
+						  flags & OPT_VERBOSE);
 	} else if (command == 'F') {
-		ret = nft_cmd_rule_flush(h, chain, *table, 0);
+		ret = nft_cmd_rule_flush(h, chain, *table, flags & OPT_VERBOSE);
 	} else if (command == 'A') {
-		ret = append_entry(h, chain, *table, &cs, 0, 0, true);
+		ret = append_entry(h, chain, *table, &cs, 0,
+				   flags & OPT_VERBOSE, true);
 	} else if (command == 'I') {
 		ret = append_entry(h, chain, *table, &cs, rule_nr - 1,
-				   0, false);
+				   flags & OPT_VERBOSE, false);
 	} else if (command == 'D') {
 		ret = delete_entry(h, chain, *table, &cs, rule_nr - 1,
-				   rule_nr_end, 0);
+				   rule_nr_end, flags & OPT_VERBOSE);
 	} /*else if (replace->command == 'C') {
 		ebt_change_counters(replace, new_entry, rule_nr, rule_nr_end, &(new_entry->cnt_surplus), chcounter);
 		if (ebt_errormsg[0] != '\0')
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index f5aabf3cc1944..81b25a43c9a04 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -417,6 +417,7 @@ static const struct nft_xt_restore_cb ebt_restore_cb = {
 
 static const struct option ebt_restore_options[] = {
 	{.name = "noflush", .has_arg = 0, .val = 'n'},
+	{.name = "verbose", .has_arg = 0, .val = 'v'},
 	{ 0 }
 };
 
@@ -430,15 +431,18 @@ int xtables_eb_restore_main(int argc, char *argv[])
 	struct nft_handle h;
 	int c;
 
-	while ((c = getopt_long(argc, argv, "n",
+	while ((c = getopt_long(argc, argv, "nv",
 				ebt_restore_options, NULL)) != -1) {
 		switch(c) {
 		case 'n':
 			noflush = 1;
 			break;
+		case 'v':
+			verbose++;
+			break;
 		default:
 			fprintf(stderr,
-				"Usage: ebtables-restore [ --noflush ]\n");
+				"Usage: ebtables-restore [ --verbose ] [ --noflush ]\n");
 			exit(1);
 			break;
 		}
-- 
2.34.1

