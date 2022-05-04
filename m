Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2424C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 10:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbiEDKiE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 06:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiEDKiD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 06:38:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8636D1402B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 03:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VXo0+UT9yiHuIiX7qgBfSzrdXrAcyamSbzWAfxxDtRE=; b=NumNJXzTeyYiVdUfiDotgpcT0x
        cXZRGBhh34ZQ8iuxox0gvPGC1Sdr426h7LdNW7Sv9iPYlmkVVpLxlMSMwAKtwL5w3Z2/GNFAaVhOx
        TXlSQr8ACMaGgfBeso2UhlYoaVsfK2D7gXQGWtIIg2YXnyLeL2/8jdFzy2oLe3z/omm7u9tw2T17T
        a5Z5E/US82iacZj6R3OLUL434ZxSsYTfMKQS+p2l7zYk/yh6hfEVgXd5iuexaaUWt5Ku9DFq2svt5
        wTFMltQmaLzzY1aY3/g0faQWtyWH8vxxo41sE/+0/dO1sDTBlBiu+we1JWrgt4Du5jIeHiqHfT1hT
        ja0T+9+A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmCKv-0008PQ-4u; Wed, 04 May 2022 12:34:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/4] extensions: DNAT: Merge core printing functions
Date:   Wed,  4 May 2022 12:34:13 +0200
Message-Id: <20220504103416.19712-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504103416.19712-1-phil@nwl.cc>
References: <20220504103416.19712-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Have a versatile __NAT_print() function providing enough flexibility for
DNAT and REDIRECT, IPv4 and IPv6 and 'print' and 'save' output. Then
define macros to simplify calling it.

As a side effect, this fixes ip6tables DNAT revision 1 print output.

Fixes: 14d77c8aa29a7 ("extensions: Merge IPv4 and IPv6 DNAT targets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.c | 58 +++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index 5ac8018c12423..5696d31f2b0c5 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -312,31 +312,40 @@ static char *sprint_range(const struct nf_nat_range2 *r, int family)
 	return buf;
 }
 
-static void __DNAT_print(const struct nf_nat_range2 *r, bool save, int family)
+static void __NAT_print(const struct nf_nat_range2 *r, int family,
+			const char *rangeopt, const char *flag_pfx,
+			bool skip_colon)
 {
-	const char *dashdash = save ? "--" : "";
+	char *range_str = sprint_range(r, family);
 
-	printf(" %s%s", save ? "--to-destination " : "to:",
-	       sprint_range(r, family));
+	if (strlen(range_str)) {
+		if (range_str[0] == ':' && skip_colon)
+			range_str++;
+		printf(" %s%s", rangeopt, range_str);
+	}
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" %srandom", dashdash);
+		printf(" %srandom", flag_pfx);
 	if (r->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" %spersistent", dashdash);
+		printf(" %spersistent", flag_pfx);
 }
+#define __DNAT_print(r, family) __NAT_print(r, family, "to:", "", false)
+#define __DNAT_save(r, family) __NAT_print(r, family, "--to-destination ", "--", false)
+#define __REDIRECT_print(r) __NAT_print(r, AF_INET, "redir ports ", "", true)
+#define __REDIRECT_save(r) __NAT_print(r, AF_INET, "--to-ports ", "--", true)
 
 static void DNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
 	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
 
-	__DNAT_print(&range, false, AF_INET);
+	__DNAT_print(&range, AF_INET);
 }
 
 static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
 
-	__DNAT_print(&range, true, AF_INET);
+	__DNAT_save(&range, AF_INET);
 }
 
 static int
@@ -387,12 +396,12 @@ static void DNAT_fcheck_v2(struct xt_fcheck_call *cb)
 static void DNAT_print_v2(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	__DNAT_print((const void *)target->data, false, AF_INET);
+	__DNAT_print((const void *)target->data, AF_INET);
 }
 
 static void DNAT_save_v2(const void *ip, const struct xt_entry_target *target)
 {
-	__DNAT_print((const void *)target->data, true, AF_INET);
+	__DNAT_save((const void *)target->data, AF_INET);
 }
 
 static int DNAT_xlate_v2(struct xt_xlate *xl,
@@ -429,7 +438,7 @@ static void DNAT_print6(const void *ip, const struct xt_entry_target *target,
 	struct nf_nat_range2 range = {};
 
 	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__DNAT_print(&range, true, AF_INET6);
+	__DNAT_print(&range, AF_INET6);
 }
 
 static void DNAT_save6(const void *ip, const struct xt_entry_target *target)
@@ -437,7 +446,7 @@ static void DNAT_save6(const void *ip, const struct xt_entry_target *target)
 	struct nf_nat_range2 range = {};
 
 	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__DNAT_print(&range, true, AF_INET6);
+	__DNAT_save(&range, AF_INET6);
 }
 
 static int DNAT_xlate6(struct xt_xlate *xl,
@@ -460,12 +469,12 @@ static void DNAT_parse6_v2(struct xt_option_call *cb)
 static void DNAT_print6_v2(const void *ip, const struct xt_entry_target *target,
 			   int numeric)
 {
-	__DNAT_print((const void *)target->data, true, AF_INET6);
+	__DNAT_print((const void *)target->data, AF_INET6);
 }
 
 static void DNAT_save6_v2(const void *ip, const struct xt_entry_target *target)
 {
-	__DNAT_print((const void *)target->data, true, AF_INET6);
+	__DNAT_save((const void *)target->data, AF_INET6);
 }
 
 static int DNAT_xlate6_v2(struct xt_xlate *xl,
@@ -474,19 +483,6 @@ static int DNAT_xlate6_v2(struct xt_xlate *xl,
 	return __DNAT_xlate(xl, (const void *)params->target->data, AF_INET6);
 }
 
-static void __REDIRECT_print(const struct nf_nat_range2 *range, bool save)
-{
-	char *range_str = sprint_range(range, AF_INET);
-	const char *dashdash = save ? "--" : "";
-
-	if (strlen(range_str))
-		/* range_str starts with colon, skip over them */
-		printf(" %s %s", save ? "--to-ports" : "redir ports",
-		       range_str + 1);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" %srandom", dashdash);
-}
-
 static int __REDIRECT_xlate(struct xt_xlate *xl,
 			    const struct nf_nat_range2 *range)
 {
@@ -506,14 +502,14 @@ static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
 {
 	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
 
-	__REDIRECT_print(&range, false);
+	__REDIRECT_print(&range);
 }
 
 static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
 
-	__REDIRECT_print(&range, true);
+	__REDIRECT_save(&range);
 }
 
 static int REDIRECT_xlate(struct xt_xlate *xl,
@@ -531,7 +527,7 @@ static void REDIRECT_print6(const void *ip, const struct xt_entry_target *target
 	struct nf_nat_range2 range = {};
 
 	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__REDIRECT_print(&range, false);
+	__REDIRECT_print(&range);
 }
 
 static void REDIRECT_save6(const void *ip, const struct xt_entry_target *target)
@@ -539,7 +535,7 @@ static void REDIRECT_save6(const void *ip, const struct xt_entry_target *target)
 	struct nf_nat_range2 range = {};
 
 	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
-	__REDIRECT_print(&range, true);
+	__REDIRECT_save(&range);
 }
 
 static int REDIRECT_xlate6(struct xt_xlate *xl,
-- 
2.34.1

