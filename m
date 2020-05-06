Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13F0C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9527A20936
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgEFRev (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRev (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A2DC061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:51 -0700 (PDT)
Received: from localhost ([::1]:58768 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNwX-0002nZ-Uf; Wed, 06 May 2020 19:34:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 15/15] nft: Don't exit early after printing help texts
Date:   Wed,  6 May 2020 19:33:31 +0200
Message-Id: <20200506173331.9347-16-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Follow regular code path after handling --help option to gracefully
deinit and free stuff.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-arp.c | 10 +++++-----
 iptables/xtables-eb.c  |  2 +-
 iptables/xtables.c     |  7 ++++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index e64938fbf5d36..8632774dfb705 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -235,7 +235,7 @@ exit_tryhelp(int status)
 }
 
 static void
-exit_printhelp(void)
+printhelp(void)
 {
 	struct xtables_target *t = NULL;
 	int i;
@@ -325,7 +325,6 @@ exit_printhelp(void)
 		printf("\n");
 		t->help();
 	}
-	exit(0);
 }
 
 static char
@@ -666,7 +665,8 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			if (!optarg)
 				optarg = argv[optind];
 
-			exit_printhelp();
+			printhelp();
+			command = CMD_NONE;
 			break;
 		case 's':
 			check_inverse(optarg, &invert, &optind, argc);
@@ -881,8 +881,6 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 	if (optind < argc)
 		xtables_error(PARAMETER_PROBLEM,
 			      "unknown arguments found on commandline");
-	if (!command)
-		xtables_error(PARAMETER_PROBLEM, "no command specified");
 	if (invert)
 		xtables_error(PARAMETER_PROBLEM,
 			      "nothing appropriate following !");
@@ -1009,6 +1007,8 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy `%s'\n",
 				      policy);
 		break;
+	case CMD_NONE:
+		break;
 	default:
 		/* We should never reach this... */
 		exit_tryhelp(2);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 5764d1803cba7..375a95d1d5c75 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -1218,7 +1218,7 @@ print_zero:
 
 	if (command == 'h' && !(flags & OPT_ZERO)) {
 		print_help(cs.target, cs.matches, *table);
-		exit(0);
+		ret = 1;
 	}
 
 	/* Do the final checks */
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 63a37ae867069..9d2e441e0b773 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -161,7 +161,7 @@ exit_tryhelp(int status)
 }
 
 static void
-exit_printhelp(const struct xtables_rule_match *matches)
+printhelp(const struct xtables_rule_match *matches)
 {
 	printf("%s v%s\n\n"
 "Usage: %s -[ACD] chain rule-specification [options]\n"
@@ -240,7 +240,6 @@ exit_printhelp(const struct xtables_rule_match *matches)
 "[!] --version	-V		print package version.\n");
 
 	print_extension_helps(xtables_targets, matches);
-	exit(0);
 }
 
 void
@@ -724,7 +723,9 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				xtables_find_match(cs->protocol,
 					XTF_TRY_LOAD, &cs->matches);
 
-			exit_printhelp(cs->matches);
+			printhelp(cs->matches);
+			p->command = CMD_NONE;
+			return;
 
 			/*
 			 * Option selection
-- 
2.25.1

