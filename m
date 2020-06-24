Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE8AC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6416F20836
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403931AbgFXNaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391057AbgFXNaK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:30:10 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80CEC061795
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 06:30:09 -0700 (PDT)
Received: janet.servers.dxld.at; Wed, 24 Jun 2020 15:30:07 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Subject: [libnf_ct PATCH v2 3/9] Replace strncpy with snprintf to improve null byte handling
Date:   Wed, 24 Jun 2020 15:29:59 +0200
Message-Id: <20200624133005.22046-3-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200624133005.22046-1-dxld@darkboxed.org>
References: <20200624133005.22046-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We currently use strncpy in a bunch of places which has this weird quirk
where it doesn't write a terminating null byte if the input string is >=
the max length. To mitigate this we write a null byte to the last character
manually.

While this works it is easy to forget. Instead we should just be using
snprintf which has more sensible behaviour as it always writes a null byte
even when truncating the string.

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 src/conntrack/copy.c      |  4 ++--
 src/conntrack/parse_mnl.c |  5 ++---
 src/conntrack/setter.c    |  3 +--
 src/expect/parse_mnl.c    | 15 ++++++++-------
 src/expect/setter.c       |  6 ++----
 5 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index eca202e..402f994 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -427,8 +427,8 @@ static void copy_attr_repl_off_aft(struct nf_conntrack *dest,
 static void copy_attr_helper_name(struct nf_conntrack *dest,
 				  const struct nf_conntrack *orig)
 {
-	strncpy(dest->helper_name, orig->helper_name, NFCT_HELPER_NAME_MAX);
-	dest->helper_name[NFCT_HELPER_NAME_MAX-1] = '\0';
+	snprintf(dest->helper_name, NFCT_HELPER_NAME_MAX, "%s",
+		 orig->helper_name);
 }
 
 static void copy_attr_zone(struct nf_conntrack *dest,
diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 515deff..3cbfc6a 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -690,9 +690,8 @@ nfct_parse_helper(const struct nlattr *attr, struct nf_conntrack *ct)
 	if (!tb[CTA_HELP_NAME])
 		return 0;
 
-	strncpy(ct->helper_name, mnl_attr_get_str(tb[CTA_HELP_NAME]),
-		NFCT_HELPER_NAME_MAX);
-	ct->helper_name[NFCT_HELPER_NAME_MAX-1] = '\0';
+	snprintf(ct->helper_name, NFCT_HELPER_NAME_MAX, "%s",
+		 mnl_attr_get_str(tb[CTA_HELP_NAME]));
 	set_bit(ATTR_HELPER_NAME, ct->head.set);
 
 	if (!tb[CTA_HELP_INFO])
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index 7b96936..3a293b0 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -389,8 +389,7 @@ set_attr_repl_off_aft(struct nf_conntrack *ct, const void *value, size_t len)
 static void
 set_attr_helper_name(struct nf_conntrack *ct, const void *value, size_t len)
 {
-	strncpy(ct->helper_name, value, NFCT_HELPER_NAME_MAX);
-	ct->helper_name[NFCT_HELPER_NAME_MAX-1] = '\0';
+	snprintf(ct->helper_name, NFCT_HELPER_NAME_MAX, "%s", (char *)value);
 }
 
 static void
diff --git a/src/expect/parse_mnl.c b/src/expect/parse_mnl.c
index 091a8ae..fb4bdb7 100644
--- a/src/expect/parse_mnl.c
+++ b/src/expect/parse_mnl.c
@@ -10,6 +10,7 @@
  */
 
 #include "internal/internal.h"
+#include <assert.h>
 #include <libmnl/libmnl.h>
 
 static int nlmsg_parse_expection_attr_cb(const struct nlattr *attr, void *data)
@@ -139,10 +140,8 @@ int nfexp_nlmsg_parse(const struct nlmsghdr *nlh, struct nf_expect *exp)
 		set_bit(ATTR_EXP_FLAGS, exp->set);
 	}
 	if (tb[CTA_EXPECT_HELP_NAME]) {
-		strncpy(exp->helper_name,
-			mnl_attr_get_str(tb[CTA_EXPECT_HELP_NAME]),
-			NFCT_HELPER_NAME_MAX);
-		exp->helper_name[NFCT_HELPER_NAME_MAX - 1] = '\0';
+		snprintf(exp->helper_name, NFCT_HELPER_NAME_MAX, "%s",
+			 mnl_attr_get_str(tb[CTA_EXPECT_HELP_NAME]));
 		set_bit(ATTR_EXP_HELPER_NAME, exp->set);
 	}
 	if (tb[CTA_EXPECT_CLASS]) {
@@ -153,9 +152,11 @@ int nfexp_nlmsg_parse(const struct nlmsghdr *nlh, struct nf_expect *exp)
 		nfexp_nlmsg_parse_nat(nfg, tb[CTA_EXPECT_NAT], exp);
 
 	if (tb[CTA_EXPECT_FN]) {
-		strncpy(exp->expectfn, mnl_attr_get_payload(tb[CTA_EXPECT_FN]),
-			__NFCT_EXPECTFN_MAX);
-		exp->expectfn[__NFCT_EXPECTFN_MAX - 1] = '\0';
+		int len = mnl_attr_get_payload_len(tb[CTA_EXPECT_FN]);
+		/* the kernel doesn't impose a max length on this str */
+		assert(len <= __NFCT_EXPECTFN_MAX);
+		snprintf(exp->expectfn, __NFCT_EXPECTFN_MAX, "%s",
+			 (char *)mnl_attr_get_payload(tb[CTA_EXPECT_FN]));
 		set_bit(ATTR_EXP_FN, exp->set);
 	}
 
diff --git a/src/expect/setter.c b/src/expect/setter.c
index 18c925a..c2ca412 100644
--- a/src/expect/setter.c
+++ b/src/expect/setter.c
@@ -46,8 +46,7 @@ static void set_exp_attr_class(struct nf_expect *exp, const void *value)
 
 static void set_exp_attr_helper_name(struct nf_expect *exp, const void *value)
 {
-	strncpy(exp->helper_name, value, NFCT_HELPER_NAME_MAX);
-	exp->helper_name[NFCT_HELPER_NAME_MAX-1] = '\0';
+	snprintf(exp->helper_name, NFCT_HELPER_NAME_MAX, "%s", (char *)value);
 }
 
 static void set_exp_attr_nat_dir(struct nf_expect *exp, const void *value)
@@ -62,8 +61,7 @@ static void set_exp_attr_nat_tuple(struct nf_expect *exp, const void *value)
 
 static void set_exp_attr_expectfn(struct nf_expect *exp, const void *value)
 {
-	strncpy(exp->expectfn, value, __NFCT_EXPECTFN_MAX);
-	exp->expectfn[__NFCT_EXPECTFN_MAX-1] = '\0';
+	snprintf(exp->expectfn, __NFCT_EXPECTFN_MAX, "%s", (char *)value);
 }
 
 const set_exp_attr set_exp_attr_array[ATTR_EXP_MAX] = {
-- 
2.20.1

