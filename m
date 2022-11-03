Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E334FC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 01:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiKCBlp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBlp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 21:41:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3DD1114D
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 18:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cUXPK4jT//tReTpFGuZKUuyW2nm4214ayvTd18O4hOM=; b=TCfasnxnd4GoD3KSQKJmC4N+OF
        qyVqbDVEauMkHKFvT2bdtBRJluyy1LLaETZk6yXiHHKQx/Jue/GMFZ01OOXCm4VFPscxlGGdl4rTc
        xGXtK2vFZqLKwH8FmNxUwLWRlaGT76JBgkqP/jdEJnqppqpYAVF9bTta26uAoNBik9Zenxx0vQndo
        oWkE+du+WX/2OD/9mYQSsGx3IhehWlyIeOD0uPPtCxK8kGlusj6/Y9Gd/96hETZEMjlHOpAPiJMM8
        MuB8mBcXP79J5O1ZQ35kdx/VaaTBlyCZUox2YarD6wzTlusRRl2opb0cc4FJIc4vrBZCGR15nTbi2
        Ar0QnLqw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oqPEl-0005Gu-0m
        for netfilter-devel@vger.kernel.org; Thu, 03 Nov 2022 02:41:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/6] extensions: DNAT: Use __DNAT_xlate for REDIRECT, too
Date:   Thu,  3 Nov 2022 02:41:10 +0100
Message-Id: <20221103014113.10851-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221103014113.10851-1-phil@nwl.cc>
References: <20221103014113.10851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make the common function a bit more versatile and give it a more
generic name, then use it for REDIRECT target, too.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index af44518798aef..9b94062512c09 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -338,7 +338,8 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static int
-__DNAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r, int family)
+__NAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r,
+	     int family, const char *tgt)
 {
 	char *range_str = sprint_range(r, family);
 	const char *sep = " ";
@@ -347,7 +348,7 @@ __DNAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r, int family)
 	if (r->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		return 0;
 
-	xt_xlate_add(xl, "dnat");
+	xt_xlate_add(xl, tgt);
 	if (strlen(range_str))
 		xt_xlate_add(xl, " to %s", range_str);
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM) {
@@ -367,7 +368,7 @@ static int DNAT_xlate(struct xt_xlate *xl,
 	struct nf_nat_range2 range =
 		RANGE2_INIT_FROM_IPV4_MRC(params->target->data);
 
-	return __DNAT_xlate(xl, &range, AF_INET);
+	return __NAT_xlate(xl, &range, AF_INET, "dnat");
 }
 
 static void DNAT_parse_v2(struct xt_option_call *cb)
@@ -391,7 +392,8 @@ static void DNAT_save_v2(const void *ip, const struct xt_entry_target *target)
 static int DNAT_xlate_v2(struct xt_xlate *xl,
 			  const struct xt_xlate_tg_params *params)
 {
-	return __DNAT_xlate(xl, (const void *)params->target->data, AF_INET);
+	return __NAT_xlate(xl, (const void *)params->target->data,
+			   AF_INET, "dnat");
 }
 
 static void DNAT_parse6(struct xt_option_call *cb)
@@ -438,7 +440,7 @@ static int DNAT_xlate6(struct xt_xlate *xl,
 
 	memcpy(&range, (const void *)params->target->data,
 	       sizeof(struct nf_nat_range));
-	return __DNAT_xlate(xl, &range, AF_INET6);
+	return __NAT_xlate(xl, &range, AF_INET6, "dnat");
 }
 
 static void DNAT_parse6_v2(struct xt_option_call *cb)
@@ -462,21 +464,8 @@ static void DNAT_save6_v2(const void *ip, const struct xt_entry_target *target)
 static int DNAT_xlate6_v2(struct xt_xlate *xl,
 			  const struct xt_xlate_tg_params *params)
 {
-	return __DNAT_xlate(xl, (const void *)params->target->data, AF_INET6);
-}
-
-static int __REDIRECT_xlate(struct xt_xlate *xl,
-			    const struct nf_nat_range2 *range)
-{
-	char *range_str = sprint_range(range, AF_INET);
-
-	xt_xlate_add(xl, "redirect");
-	if (strlen(range_str))
-		xt_xlate_add(xl, " to %s", range_str);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		xt_xlate_add(xl, " random");
-
-	return 1;
+	return __NAT_xlate(xl, (const void *)params->target->data,
+			   AF_INET6, "dnat");
 }
 
 static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
@@ -500,7 +489,7 @@ static int REDIRECT_xlate(struct xt_xlate *xl,
 	struct nf_nat_range2 range =
 		RANGE2_INIT_FROM_IPV4_MRC(params->target->data);
 
-	return __REDIRECT_xlate(xl, &range);
+	return __NAT_xlate(xl, &range, AF_INET, "redirect");
 }
 
 static void REDIRECT_print6(const void *ip, const struct xt_entry_target *target,
@@ -527,7 +516,7 @@ static int REDIRECT_xlate6(struct xt_xlate *xl,
 
 	memcpy(&range, (const void *)params->target->data,
 	       sizeof(struct nf_nat_range));
-	return __REDIRECT_xlate(xl, &range);
+	return __NAT_xlate(xl, &range, AF_INET6, "redirect");
 }
 
 static struct xtables_target dnat_tg_reg[] = {
-- 
2.38.0

