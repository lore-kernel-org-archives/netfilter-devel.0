Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8F0C001E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 18:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbjHJSzP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 14:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjHJSzO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 14:55:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478E22712
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 11:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5ts0+jJ1oCxJe+Paq9BNu265MpLThI8Lk5lYH+Tv4XA=; b=Fs4raXFOFfIQOir7+dJGDDU1Oh
        vX9sbmj90NcwhFoVQeYAtsX7wVPG6V9NL+bXwIAlIdRImS6AFj5cecimDjnqhM62kRXkaQ0RnFWJV
        nJb1vVVhaVJ4aybEbZEMHht48WQYX6dkAw1AmLmWJ5h2zrFcieVlwVbzrlkgHLqT4iBuCmLLSXwOI
        JnxG2ylKYVH3vO+dpfUMYq9bilFPbwm02TNAPmWSY7oaueR65QiUgzbSRElTshau2AWI7BL4jv/0N
        IFkzao9LBTnPA7TfxdsqYNTVHs7uNbevL3GHE5F3eis/eaKRsFEwlCcrCzKJCEqAX4vi+F86wPuRF
        Fjt8833g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qUAoR-0002Yj-Gg
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 20:55:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 3/4] Add --compat option to *tables-nft and *-nft-restore commands
Date:   Thu, 10 Aug 2023 20:54:51 +0200
Message-Id: <20230810185452.24387-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230810185452.24387-1-phil@nwl.cc>
References: <20230810185452.24387-1-phil@nwl.cc>
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
Changes since v1:
- Expect short option '-C' in {ip,ip6,eb}tables-nft-restore command line
  parser
- Support -C/--compat in arptables-nft-restore, too
- Update man pages with the new flag
---
 iptables/arptables-nft-restore.8 | 15 +++++++----
 iptables/arptables-nft.8         |  8 ++++++
 iptables/ebtables-nft.8          |  6 +++++
 iptables/iptables-restore.8.in   | 11 ++++++--
 iptables/iptables.8.in           |  7 ++++++
 iptables/xshared.c               |  7 +++++-
 iptables/xshared.h               |  1 +
 iptables/xtables-arp.c           |  1 +
 iptables/xtables-eb.c            |  7 +++++-
 iptables/xtables-restore.c       | 43 +++++++++++++++++++++++++++++---
 iptables/xtables.c               |  2 ++
 11 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/iptables/arptables-nft-restore.8 b/iptables/arptables-nft-restore.8
index 09d9082cf9fd3..12ac9ebd5062d 100644
--- a/iptables/arptables-nft-restore.8
+++ b/iptables/arptables-nft-restore.8
@@ -22,18 +22,23 @@
 .SH NAME
 arptables-restore \- Restore ARP Tables (nft-based)
 .SH SYNOPSIS
-\fBarptables\-restore
+.BR arptables\-restore " [" --compat ]
 .SH DESCRIPTION
-.PP
 .B arptables-restore
 is used to restore ARP Tables from data specified on STDIN or
 via a file as first argument.
-Use I/O redirection provided by your shell to read from a file
-.TP
+Use I/O redirection provided by your shell to read from a file.
+.P
 .B arptables-restore
 flushes (deletes) all previous contents of the respective ARP Table.
+.TP
+.BR -C , " --compat"
+Create rules in a mostly compatible way, enabling older versions of
+\fBarptables\-nft\fP to correctly parse the rules received from kernel. This
+mode is only useful in very specific situations and will likely impact packet
+filtering performance.
+
 .SH AUTHOR
 Jesper Dangaard Brouer <brouer@redhat.com>
 .SH SEE ALSO
 \fBarptables\-save\fP(8), \fBarptables\fP(8)
-.PP
diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index ea31e0842acd4..673a7bd58e9cd 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -220,6 +220,14 @@ counters of a rule (during
 .B APPEND,
 .B REPLACE
 operations).
+.SS "OTHER OPTIONS"
+The following additional options can be specified:
+.TP
+\fB\-\-compat\fP
+Create rules in a mostly compatible way, enabling older versions of
+\fBarptables\-nft\fP to correctly parse the rules received from kernel. This
+mode is only useful in very specific situations and will likely impact packet
+filtering performance.
 
 .SS RULE-SPECIFICATIONS
 The following command line arguments make up a rule specification (as used 
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 0304b5088cd8c..baada6c67437f 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -359,6 +359,12 @@ to try to automatically load missing kernel modules.
 .TP
 .B --concurrent
 Use a file lock to support concurrent scripts updating the ebtables kernel tables.
+.TP
+.B --compat
+Create rules in a mostly compatible way, enabling older versions of
+\fBebtables\-nft\fP to correctly parse the rules received from kernel. This
+mode is only useful in very specific situations and will likely impact packet
+filtering performance.
 
 .SS
 RULE SPECIFICATIONS
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index aa816f794d6f3..383099929e3bd 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -23,11 +23,11 @@ iptables-restore \(em Restore IP Tables
 .P
 ip6tables-restore \(em Restore IPv6 Tables
 .SH SYNOPSIS
-\fBiptables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
+\fBiptables\-restore\fP [\fB\-cChntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fIfile\fP]
 .P
-\fBip6tables\-restore\fP [\fB\-chntvV\fP] [\fB\-w\fP \fIseconds\fP]
+\fBip6tables\-restore\fP [\fB\-cChntvV\fP] [\fB\-w\fP \fIseconds\fP]
 [\fB\-M\fP \fImodprobe\fP] [\fB\-T\fP \fIname\fP]
 [\fIfile\fP]
 .SH DESCRIPTION
@@ -74,6 +74,13 @@ determine the executable's path.
 .TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
+.TP
+\fB\-C\fP, \fB\-\-compat\fP
+This flag is only relevant with \fBnft\fP-variants and ignored otherwise. If
+set, rules will be created in a mostly compatible way, enabling older versions
+of \fBiptables\-nft\fP to correctly parse the rules received from kernel. This
+mode is only useful in very specific situations and will likely impact packet
+filtering performance.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index ecaa5553942df..c0e92f27dc722 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -397,6 +397,13 @@ corresponding to that rule's position in the chain.
 \fB\-\-modprobe=\fP\fIcommand\fP
 When adding or inserting rules into a chain, use \fIcommand\fP
 to load any necessary modules (targets, match extensions, etc).
+.TP
+\fB\-\-compat\fP
+This flag is only relevant with \fBnft\fP-variants and ignored otherwise. If
+set, rules will be created in a mostly compatible way, enabling older versions
+of \fBiptables\-nft\fP to correctly parse the rules received from kernel. This
+mode is only useful in very specific situations and will likely impact packet
+filtering performance.
 
 .SH LOCK FILE
 iptables uses the \fI@XT_LOCK_NAME@\fP file to take an exclusive lock at
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 5f75a0a57a023..74b7a041516df 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1263,7 +1263,8 @@ xtables_printhelp(const struct xtables_rule_match *matches)
 	printf(
 "  --modprobe=<command>		try to insert modules using this command\n"
 "  --set-counters -c PKTS BYTES	set the counter during insert/append\n"
-"[!] --version	-V		print package version.\n");
+"[!] --version	-V		print package version\n"
+"  --compat			create rules compatible for parsing with old binaries\n");
 
 	if (afinfo->family == NFPROTO_ARP) {
 		int i;
@@ -1787,6 +1788,10 @@ void do_parse(int argc, char *argv[],
 
 			exit_tryhelp(2, p->line);
 
+		case 15: /* --compat */
+			p->compat = true;
+			break;
+
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
 				if (invert)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index a200e0d620ad3..f69a7b432d33f 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -283,6 +283,7 @@ struct xt_cmd_parse {
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
index 08eec79d80400..ffd51efaaf0f0 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -223,6 +223,7 @@ struct option ebt_original_options[] =
 	{ "init-table"     , no_argument      , 0, 11  },
 	{ "concurrent"     , no_argument      , 0, 13  },
 	{ "check"          , required_argument, 0, 14  },
+	{ "compat"         , no_argument      , 0, 15  },
 	{ 0 }
 };
 
@@ -335,7 +336,8 @@ static void print_help(const struct xtables_target *t,
 "--modprobe -M program         : try to insert modules using this program\n"
 "--concurrent                  : use a file lock to support concurrent scripts\n"
 "--verbose -v                  : verbose mode\n"
-"--version -V                  : print package version\n\n"
+"--version -V                  : print package version\n"
+"--compat                      : create rules compatible for parsing with old binaries\n\n"
 "Environment variable:\n"
 /*ATOMIC_ENV_VARIABLE "          : if set <FILE> (see above) will equal its value"*/
 "\n\n");
@@ -1097,6 +1099,9 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
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
index 23cd349819f4f..bd8c6bc15549f 100644
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
@@ -289,6 +291,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		.cb = &restore_cb,
 	};
 	bool noflush = false;
+	bool compat = false;
 	struct nft_handle h;
 	int c;
 
@@ -303,7 +306,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 
-	while ((c = getopt_long(argc, argv, "bcvVthnM:T:wW", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcCvVthnM:T:wW", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -311,6 +314,9 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			case 'c':
 				counters = 1;
 				break;
+			case 'C':
+				compat = true;
+				break;
 			case 'v':
 				verbose++;
 				break;
@@ -387,6 +393,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	}
 	h.noflush = noflush;
 	h.restore = true;
+	h.compat = compat;
 
 	xtables_restore_parse(&h, &p);
 
@@ -417,6 +424,7 @@ static const struct nft_xt_restore_cb ebt_restore_cb = {
 };
 
 static const struct option ebt_restore_options[] = {
+	{.name = "compat",  .has_arg = 0, .val = 'C'},
 	{.name = "noflush", .has_arg = 0, .val = 'n'},
 	{.name = "verbose", .has_arg = 0, .val = 'v'},
 	{ 0 }
@@ -429,12 +437,16 @@ int xtables_eb_restore_main(int argc, char *argv[])
 		.cb = &ebt_restore_cb,
 	};
 	bool noflush = false;
+	bool compat = false;
 	struct nft_handle h;
 	int c;
 
-	while ((c = getopt_long(argc, argv, "nv",
+	while ((c = getopt_long(argc, argv, "Cnv",
 				ebt_restore_options, NULL)) != -1) {
 		switch(c) {
+		case 'C':
+			compat = true;
+			break;
 		case 'n':
 			noflush = 1;
 			break;
@@ -443,7 +455,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 			break;
 		default:
 			fprintf(stderr,
-				"Usage: ebtables-restore [ --verbose ] [ --noflush ]\n");
+				"Usage: ebtables-restore [ --compat ] [ --verbose ] [ --noflush ]\n");
 			exit(1);
 			break;
 		}
@@ -451,6 +463,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 
 	nft_init_eb(&h, "ebtables-restore");
 	h.noflush = noflush;
+	h.compat = compat;
 	xtables_restore_parse(&h, &p);
 	nft_fini_eb(&h);
 
@@ -465,15 +478,37 @@ static const struct nft_xt_restore_cb arp_restore_cb = {
 	.chain_restore  = nft_cmd_chain_restore,
 };
 
+static const struct option arp_restore_options[] = {
+	{.name = "compat",  .has_arg = 0, .val = 'C'},
+	{ 0 }
+};
+
 int xtables_arp_restore_main(int argc, char *argv[])
 {
 	struct nft_xt_restore_parse p = {
 		.in = stdin,
 		.cb = &arp_restore_cb,
 	};
+	bool compat = false;
 	struct nft_handle h;
+	int c;
+
+	while ((c = getopt_long(argc, argv, "C",
+				arp_restore_options, NULL)) != -1) {
+		switch(c) {
+		case 'C':
+			compat = true;
+			break;
+		default:
+			fprintf(stderr,
+				"Usage: arptables-restore [ --compat ]\n");
+			exit(1);
+			break;
+		}
+	}
 
 	nft_init_arp(&h, "arptables-restore");
+	h.compat = compat;
 	xtables_restore_parse(&h, &p);
 	nft_fini(&h);
 	xtables_fini();
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

