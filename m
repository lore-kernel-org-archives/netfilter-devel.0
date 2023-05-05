Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5A4AC77B7D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 18:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbjEESfS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 14:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjEESfR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 14:35:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5B815EDD
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 11:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W48Cz7aT9udSFsP4LStqvS/mLOKDebugg5dyr3j0afI=; b=TP3Z79vNU+9fjvVAtTSO1kwD7E
        0ZFT02W3MtopJno56VjJ8sYMfpDIJutoR4DPwafWcHYbLAXJtw9E8je0M71vHEE9d0Rj+hHBtJtQR
        48uyQRi8G/9Jfu7ULX8PZm3w2IGn56mLNt94tcDjUx41v4+LyxwKghPRMt+f932a0dEM3/GSV+QN2
        RaqhhngqaoJkcXj8+doOo7VYT0AP9FJe3MB/Q2FDw3nck+xiA60zVeP3mjBmnaU4OwecELuK7F1PU
        RtWH3T0zpUWPFyTvwhOtNw8gVOQjFyb6CFn0ex73Z6SVLL/0OECMVaaCqtcS8Arh0r98Q6IPAjyMP
        FKshzuKw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pv0Gu-0004Q1-Qq; Fri, 05 May 2023 20:35:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
Subject: [iptables PATCH 3/4] Add --compat option to *tables-nft and *-nft-restore commands
Date:   Fri,  5 May 2023 20:34:45 +0200
Message-Id: <20230505183446.28822-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230505183446.28822-1-phil@nwl.cc>
References: <20230505183446.28822-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The flag sets nft_handle::compat boolean, indicating a compatible rule
implementation is wanted. Users expecting their created rules to be
fetched from kernel by an older version of *tables-nft may use this to
avoid potential compatibility issues.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c         |  7 ++++++-
 iptables/xshared.h         |  1 +
 iptables/xtables-arp.c     |  1 +
 iptables/xtables-eb.c      |  7 ++++++-
 iptables/xtables-restore.c | 17 +++++++++++++++--
 iptables/xtables.c         |  2 ++
 6 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 17aed04e02b09..502d0a9bda4c6 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1273,7 +1273,8 @@ xtables_printhelp(const struct xtables_rule_match *matches)
 	printf(
 "  --modprobe=<command>		try to insert modules using this command\n"
 "  --set-counters -c PKTS BYTES	set the counter during insert/append\n"
-"[!] --version	-V		print package version.\n");
+"[!] --version	-V		print package version\n"
+"  --compat			create rules compatible for parsing with old binaries\n");
 
 	if (afinfo->family == NFPROTO_ARP) {
 		int i;
@@ -1796,6 +1797,10 @@ void do_parse(int argc, char *argv[],
 
 			exit_tryhelp(2, p->line);
 
+		case 15: /* --compat */
+			p->compat = true;
+			break;
+
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
 				if (invert)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 0ed9f3c29c600..d8c56cf38790d 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -276,6 +276,7 @@ struct xt_cmd_parse {
 	int				line;
 	int				verbose;
 	bool				xlate;
+	bool				compat;
 	struct xt_cmd_parse_ops		*ops;
 };
 
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 71518a9cbdb6a..c6a9c6d68cb10 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -78,6 +78,7 @@ static struct option original_opts[] = {
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
+	{ "compat", 0, 0, 15 },
 	{ 0 }
 };
 
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index bf35f52b7585d..857a3c6f19d82 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -199,6 +199,7 @@ struct option ebt_original_options[] =
 	{ "init-table"     , no_argument      , 0, 11  },
 	{ "concurrent"     , no_argument      , 0, 13  },
 	{ "check"          , required_argument, 0, 14  },
+	{ "compat"         , no_argument      , 0, 15  },
 	{ 0 }
 };
 
@@ -311,7 +312,8 @@ static void print_help(const struct xtables_target *t,
 "--modprobe -M program         : try to insert modules using this program\n"
 "--concurrent                  : use a file lock to support concurrent scripts\n"
 "--verbose -v                  : verbose mode\n"
-"--version -V                  : print package version\n\n"
+"--version -V                  : print package version\n"
+"--compat                      : create rules compatible for parsing with old binaries\n\n"
 "Environment variable:\n"
 /*ATOMIC_ENV_VARIABLE "          : if set <FILE> (see above) will equal its value"*/
 "\n\n");
@@ -1074,6 +1076,9 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 			return 1;
 		case 13 :
 			break;
+		case 15:
+			h->compat = true;
+			break;
 		case 1 :
 			if (!strcmp(optarg, "!"))
 				ebt_check_inverse2(optarg, argc, argv);
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index abe56374289f4..14699a514f5ce 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -26,6 +26,7 @@ static int counters, verbose;
 /* Keeping track of external matches and targets.  */
 static const struct option options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
+	{.name = "compat",   .has_arg = false, .val = 'C'},
 	{.name = "verbose",  .has_arg = false, .val = 'v'},
 	{.name = "version",       .has_arg = 0, .val = 'V'},
 	{.name = "test",     .has_arg = false, .val = 't'},
@@ -45,8 +46,9 @@ static const struct option options[] = {
 
 static void print_usage(const char *name, const char *version)
 {
-	fprintf(stderr, "Usage: %s [-c] [-v] [-V] [-t] [-h] [-n] [-T table] [-M command] [-4] [-6] [file]\n"
+	fprintf(stderr, "Usage: %s [-c] [-C] [-v] [-V] [-t] [-h] [-n] [-T table] [-M command] [-4] [-6] [file]\n"
 			"	   [ --counters ]\n"
+			"	   [ --compat ]\n"
 			"	   [ --verbose ]\n"
 			"	   [ --version]\n"
 			"	   [ --test ]\n"
@@ -291,6 +293,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		.cb = &restore_cb,
 	};
 	bool noflush = false;
+	bool compat = false;
 	struct nft_handle h;
 	int c;
 
@@ -313,6 +316,9 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			case 'c':
 				counters = 1;
 				break;
+			case 'C':
+				compat = true;
+				break;
 			case 'v':
 				verbose++;
 				break;
@@ -389,6 +395,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	}
 	h.noflush = noflush;
 	h.restore = true;
+	h.compat = compat;
 
 	xtables_restore_parse(&h, &p);
 
@@ -419,6 +426,7 @@ static const struct nft_xt_restore_cb ebt_restore_cb = {
 };
 
 static const struct option ebt_restore_options[] = {
+	{.name = "compat",  .has_arg = 0, .val = 'C'},
 	{.name = "noflush", .has_arg = 0, .val = 'n'},
 	{.name = "verbose", .has_arg = 0, .val = 'v'},
 	{ 0 }
@@ -431,12 +439,16 @@ int xtables_eb_restore_main(int argc, char *argv[])
 		.cb = &ebt_restore_cb,
 	};
 	bool noflush = false;
+	bool compat = false;
 	struct nft_handle h;
 	int c;
 
 	while ((c = getopt_long(argc, argv, "nv",
 				ebt_restore_options, NULL)) != -1) {
 		switch(c) {
+		case 'C':
+			compat = true;
+			break;
 		case 'n':
 			noflush = 1;
 			break;
@@ -445,7 +457,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 			break;
 		default:
 			fprintf(stderr,
-				"Usage: ebtables-restore [ --verbose ] [ --noflush ]\n");
+				"Usage: ebtables-restore [ --compat ] [ --verbose ] [ --noflush ]\n");
 			exit(1);
 			break;
 		}
@@ -453,6 +465,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 
 	nft_init_eb(&h, "ebtables-restore");
 	h.noflush = noflush;
+	h.compat = compat;
 	xtables_restore_parse(&h, &p);
 	nft_fini_eb(&h);
 
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 22d6ea58376fc..25b4dbc6b8475 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -82,6 +82,7 @@ static struct option original_opts[] = {
 	{.name = "goto",	  .has_arg = 1, .val = 'g'},
 	{.name = "ipv4",	  .has_arg = 0, .val = '4'},
 	{.name = "ipv6",	  .has_arg = 0, .val = '6'},
+	{.name = "compat",        .has_arg = 0, .val = 15 },
 	{NULL},
 };
 
@@ -161,6 +162,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	do_parse(argc, argv, &p, &cs, &args);
 	h->verbose = p.verbose;
+	h->compat = p.compat;
 
 	if (!nft_table_builtin_find(h, p.table))
 		xtables_error(VERSION_PROBLEM,
-- 
2.40.0

