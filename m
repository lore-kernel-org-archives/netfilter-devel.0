Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A80C35656
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCCF920679
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgBUODe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:03:34 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:56994 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbgBUODe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 09:03:34 -0500
Received: from localhost ([::1]:41852 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j58tw-0000gB-Rv; Fri, 21 Feb 2020 15:03:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] xtables: Drop -4 and -6 support from xtables-{save,restore}
Date:   Fri, 21 Feb 2020 15:03:23 +0100
Message-Id: <20200221140324.21082-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221140324.21082-1-phil@nwl.cc>
References: <20200221140324.21082-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Legacy tools don't support those options, either.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-restore.c |  9 +--------
 iptables/xtables-save.c    | 11 +----------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index fb2ac8b5c12a3..61a3c92001615 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -381,7 +381,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 
-	while ((c = getopt_long(argc, argv, "bcvVthnM:T:46wW", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "bcvVthnM:T:wW", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
 				fprintf(stderr, "-b/--binary option is not implemented\n");
@@ -410,13 +410,6 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			case 'T':
 				p.tablename = optarg;
 				break;
-			case '4':
-				h.family = AF_INET;
-				break;
-			case '6':
-				h.family = AF_INET6;
-				xtables_set_nfproto(AF_INET6);
-				break;
 			case 'w': /* fallthrough.  Ignored by xt-restore */
 			case 'W':
 				if (!optarg && xs_has_arg(argc, argv))
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 3a52f8c3d8209..1b6c363bef7c1 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -32,7 +32,7 @@
 #define prog_name xtables_globals.program_name
 #define prog_vers xtables_globals.program_version
 
-static const char *ipt_save_optstring = "bcdt:M:f:46V";
+static const char *ipt_save_optstring = "bcdt:M:f:V";
 static const struct option ipt_save_options[] = {
 	{.name = "counters", .has_arg = false, .val = 'c'},
 	{.name = "version",  .has_arg = false, .val = 'V'},
@@ -40,8 +40,6 @@ static const struct option ipt_save_options[] = {
 	{.name = "table",    .has_arg = true,  .val = 't'},
 	{.name = "modprobe", .has_arg = true,  .val = 'M'},
 	{.name = "file",     .has_arg = true,  .val = 'f'},
-	{.name = "ipv4",     .has_arg = false, .val = '4'},
-	{.name = "ipv6",     .has_arg = false, .val = '6'},
 	{NULL},
 };
 
@@ -189,13 +187,6 @@ xtables_save_main(int family, int argc, char *argv[],
 		case 'd':
 			dump = true;
 			break;
-		case '4':
-			h.family = AF_INET;
-			break;
-		case '6':
-			h.family = AF_INET6;
-			xtables_set_nfproto(AF_INET6);
-			break;
 		case 'V':
 			printf("%s v%s (nf_tables)\n", prog_name, prog_vers);
 			exit(0);
-- 
2.25.1

