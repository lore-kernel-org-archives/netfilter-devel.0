Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E6BC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243677AbiAKPEq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243741AbiAKPEq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:04:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA9BC061748
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:04:46 -0800 (PST)
Received: from localhost ([::1]:59122 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7IhY-0007V5-CV; Tue, 11 Jan 2022 16:04:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 03/11] xtables: Move struct nft_xt_cmd_parse to xshared.h
Date:   Tue, 11 Jan 2022 16:04:21 +0100
Message-Id: <20220111150429.29110-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preparing for shared use with legacy variants, move it to "neutral
ground" and give it a more generic name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h           | 14 +-------------
 iptables/xshared.h              | 12 ++++++++++++
 iptables/xtables-eb-translate.c |  4 ++--
 iptables/xtables-translate.c    |  8 ++++----
 iptables/xtables.c              |  4 ++--
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index bcf8486eb44c4..4948aef761d10 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -210,20 +210,8 @@ struct xtables_args {
 	unsigned long long pcnt_cnt, bcnt_cnt;
 };
 
-struct nft_xt_cmd_parse {
-	unsigned int			command;
-	unsigned int			rulenum;
-	char				*table;
-	const char			*chain;
-	const char			*newname;
-	const char			*policy;
-	bool				restore;
-	int				verbose;
-	bool				xlate;
-};
-
 void do_parse(struct nft_handle *h, int argc, char *argv[],
-	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
+	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args);
 
 struct nftnl_chain_list;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 2c05b0d7c4ace..dde94b7335f6a 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -262,4 +262,16 @@ int print_match_save(const struct xt_entry_match *e, const void *ip);
 void xtables_printhelp(const struct xtables_rule_match *matches);
 void exit_tryhelp(int status, int line) __attribute__((noreturn));
 
+struct xt_cmd_parse {
+	unsigned int			command;
+	unsigned int			rulenum;
+	char				*table;
+	const char			*chain;
+	const char			*newname;
+	const char			*policy;
+	bool				restore;
+	int				verbose;
+	bool				xlate;
+};
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index a6c86b6531e3f..86177024ec703 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -152,7 +152,7 @@ static void print_ebt_cmd(int argc, char *argv[])
 	printf("\n");
 }
 
-static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct nft_xt_cmd_parse *p,
+static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct xt_cmd_parse *p,
 				 const struct iptables_command_state *cs, bool append)
 {
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
@@ -191,7 +191,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 	int selected_chain = -1;
 	struct xtables_rule_match *xtrm_i;
 	struct ebt_match *match;
-	struct nft_xt_cmd_parse p = {
+	struct xt_cmd_parse p = {
 		.table          = *table,
         };
 
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index e2948c5009dd6..9d312b244657e 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -150,7 +150,7 @@ const char *family2str[] = {
 };
 
 static int nft_rule_xlate_add(struct nft_handle *h,
-			      const struct nft_xt_cmd_parse *p,
+			      const struct xt_cmd_parse *p,
 			      const struct iptables_command_state *cs,
 			      bool append)
 {
@@ -186,11 +186,11 @@ err_out:
 	return ret;
 }
 
-static int xlate(struct nft_handle *h, struct nft_xt_cmd_parse *p,
+static int xlate(struct nft_handle *h, struct xt_cmd_parse *p,
 		 struct iptables_command_state *cs,
 		 struct xtables_args *args, bool append,
 		 int (*cb)(struct nft_handle *h,
-			   const struct nft_xt_cmd_parse *p,
+			   const struct xt_cmd_parse *p,
 			   const struct iptables_command_state *cs,
 			   bool append))
 {
@@ -248,7 +248,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 			    char **table, bool restore)
 {
 	int ret = 0;
-	struct nft_xt_cmd_parse p = {
+	struct xt_cmd_parse p = {
 		.table		= *table,
 		.restore	= restore,
 		.xlate		= true,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index ac864eb24a35e..837b399aba5b3 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -187,7 +187,7 @@ static void check_inverse(struct nft_handle *h, const char option[],
 }
 
 void do_parse(struct nft_handle *h, int argc, char *argv[],
-	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
+	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
 {
 	struct xtables_match *m;
@@ -699,7 +699,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		bool restore)
 {
 	int ret = 1;
-	struct nft_xt_cmd_parse p = {
+	struct xt_cmd_parse p = {
 		.table		= *table,
 		.restore	= restore,
 	};
-- 
2.34.1

