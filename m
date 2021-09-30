Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C45C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0922861A03
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351685AbhI3OHt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351633AbhI3OHs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:07:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF76C06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:06:05 -0700 (PDT)
Received: from localhost ([::1]:51762 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwhH-0007Ti-C2; Thu, 30 Sep 2021 16:06:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/17] libxtables: Introduce xtables_globals print_help callback
Date:   Thu, 30 Sep 2021 16:04:09 +0200
Message-Id: <20210930140419.6170-8-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With optstring being stored in struct xtables_globals as well, it is a
natural choice to store a pointer to a help printer also which matches
the supported options.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      | 1 +
 iptables/xtables-arp.c | 6 ++++--
 iptables/xtables.c     | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index c872a04220867..ca674c2663eb4 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -425,6 +425,7 @@ struct xtables_globals
 	struct option *opts;
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 	int (*compat_rev)(const char *name, uint8_t rev, int opt);
+	void (*print_help)(const struct xtables_rule_match *m);
 };
 
 #define XT_GETOPT_TABLEEND {.name = NULL, .has_arg = false}
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index a028ac340cba0..2e4bb3f2313c8 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -97,6 +97,7 @@ static struct option original_opts[] = {
 #define opts xt_params->opts
 
 extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+static void printhelp(const struct xtables_rule_match *m);
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
 	.program_version	= PACKAGE_VERSION,
@@ -104,6 +105,7 @@ struct xtables_globals arptables_globals = {
 	.orig_opts		= original_opts,
 	.exit_err		= xtables_exit_error,
 	.compat_rev		= nft_compatible_revision,
+	.print_help		= printhelp,
 };
 
 /***********************************************/
@@ -164,7 +166,7 @@ exit_tryhelp(int status)
 }
 
 static void
-printhelp(void)
+printhelp(const struct xtables_rule_match *m)
 {
 	struct xtables_target *t = NULL;
 	int i;
@@ -563,7 +565,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			if (!optarg)
 				optarg = argv[optind];
 
-			printhelp();
+			xt_params->print_help(NULL);
 			command = CMD_NONE;
 			break;
 		case 's':
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 9abfc8f8d7f32..2b3cc9301c455 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -85,6 +85,7 @@ static struct option original_opts[] = {
 };
 
 void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+static void printhelp(const struct xtables_rule_match *m);
 
 struct xtables_globals xtables_globals = {
 	.option_offset = 0,
@@ -93,6 +94,7 @@ struct xtables_globals xtables_globals = {
 	.orig_opts = original_opts,
 	.exit_err = xtables_exit_error,
 	.compat_rev = nft_compatible_revision,
+	.print_help = printhelp,
 };
 
 #define opts xt_params->opts
@@ -435,7 +437,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				xtables_find_match(cs->protocol,
 					XTF_TRY_LOAD, &cs->matches);
 
-			printhelp(cs->matches);
+			xt_params->print_help(cs->matches);
 			p->command = CMD_NONE;
 			return;
 
-- 
2.33.0

