Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F003CC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 01:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiKCBll (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBlk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 21:41:40 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF2D1114D
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 18:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xhdu8+0fsczqiJtiUnBNiCSloNBySTJ9FJRRaM5+H84=; b=lKtec4BmuRGb/6/IrdjZE+Nmr/
        1l7ts2gGOpby/DwY/CSh0L9Nb467/+ZkuADO0/P8bvA8bLpslubuEHWEy7QqHRnK1OG9bxABgMZfY
        yKaitvNlZvjy2i6WIC/fPrZS5UmbozNzrduOVXzHN0ExhvgknRnse3sXoNzp1frchvoM60YkmYnQt
        Oh4caaxm2k3Kv/875k/LrfD6V7t3yYPYdpmoV2LAmfI8z1+zSV26YXzFNxYkyXXUE1YQexoaRX87M
        fhXuFuBio0eCCFXq0zQFr9QuZYNmaFBLOslsBo8tvt8DHo7/QyquymjFQLbyEKHDG9vqOUjxki/5k
        VPLpqUnA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oqPEf-0005Gc-NV
        for netfilter-devel@vger.kernel.org; Thu, 03 Nov 2022 02:41:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/6] extensions: DNAT: Rename some symbols
Date:   Thu,  3 Nov 2022 02:41:12 +0100
Message-Id: <20221103014113.10851-6-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221103014113.10851-1-phil@nwl.cc>
References: <20221103014113.10851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No functional change intended, just a more generic name for some symbols
which won't be DNAT-specific soon.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index e53002541ee03..fbb10e410a221 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -214,8 +214,8 @@ parse_to(const char *orig_arg, bool portok,
 	return;
 }
 
-static void __DNAT_parse(struct xt_option_call *cb, __u16 proto,
-			 struct nf_nat_range2 *range, int family)
+static void __NAT_parse(struct xt_option_call *cb, __u16 proto,
+			struct nf_nat_range2 *range, int family)
 {
 	bool portok = proto == IPPROTO_TCP ||
 		      proto == IPPROTO_UDP ||
@@ -240,13 +240,13 @@ static void __DNAT_parse(struct xt_option_call *cb, __u16 proto,
 	}
 }
 
-static void DNAT_parse(struct xt_option_call *cb)
+static void NAT_parse(struct xt_option_call *cb)
 {
 	struct nf_nat_ipv4_multi_range_compat *mr = (void *)cb->data;
 	const struct ipt_entry *entry = cb->xt_entry;
 	struct nf_nat_range2 range = {};
 
-	__DNAT_parse(cb, entry->ip.proto, &range, AF_INET);
+	__NAT_parse(cb, entry->ip.proto, &range, AF_INET);
 
 	switch (cb->entry->id) {
 	case O_TO_DEST:
@@ -264,13 +264,13 @@ static void DNAT_parse(struct xt_option_call *cb)
 	}
 }
 
-static void DNAT_parse6(struct xt_option_call *cb)
+static void NAT_parse6(struct xt_option_call *cb)
 {
 	struct nf_nat_range2 range = RANGE2_INIT_FROM_RANGE(cb->data);
 	struct nf_nat_range *range_v1 = (void *)cb->data;
 	const struct ip6t_entry *entry = cb->xt_entry;
 
-	__DNAT_parse(cb, entry->ipv6.proto, &range, AF_INET6);
+	__NAT_parse(cb, entry->ipv6.proto, &range, AF_INET6);
 	memcpy(range_v1, &range, sizeof(*range_v1));
 }
 
@@ -278,14 +278,14 @@ static void DNAT_parse_v2(struct xt_option_call *cb)
 {
 	const struct ipt_entry *entry = cb->xt_entry;
 
-	__DNAT_parse(cb, entry->ip.proto, cb->data, AF_INET);
+	__NAT_parse(cb, entry->ip.proto, cb->data, AF_INET);
 }
 
 static void DNAT_parse6_v2(struct xt_option_call *cb)
 {
 	const struct ip6t_entry *entry = cb->xt_entry;
 
-	__DNAT_parse(cb, entry->ipv6.proto, cb->data, AF_INET6);
+	__NAT_parse(cb, entry->ipv6.proto, cb->data, AF_INET6);
 }
 
 static void DNAT_fcheck(struct xt_fcheck_call *cb)
@@ -425,7 +425,7 @@ PSX_GEN(REDIRECT, RANGE2_INIT_FROM_IPV4_MRC, \
 PSX_GEN(REDIRECT6, RANGE2_INIT_FROM_RANGE, \
 	AF_INET6, "redir ports ", "--to-ports ", true, "redirect")
 
-static struct xtables_target dnat_tg_reg[] = {
+static struct xtables_target nat_tg_reg[] = {
 	{
 		.name		= "DNAT",
 		.version	= XTABLES_VERSION,
@@ -436,7 +436,7 @@ static struct xtables_target dnat_tg_reg[] = {
 		.help		= DNAT_help,
 		.print		= DNAT_print,
 		.save		= DNAT_save,
-		.x6_parse	= DNAT_parse,
+		.x6_parse	= NAT_parse,
 		.x6_fcheck	= DNAT_fcheck,
 		.x6_options	= DNAT_opts,
 		.xlate		= DNAT_xlate,
@@ -451,7 +451,7 @@ static struct xtables_target dnat_tg_reg[] = {
 		.help		= REDIRECT_help,
 		.print		= REDIRECT_print,
 		.save		= REDIRECT_save,
-		.x6_parse	= DNAT_parse,
+		.x6_parse	= NAT_parse,
 		.x6_fcheck	= DNAT_fcheck,
 		.x6_options	= REDIRECT_opts,
 		.xlate		= REDIRECT_xlate,
@@ -466,7 +466,7 @@ static struct xtables_target dnat_tg_reg[] = {
 		.help		= DNAT_help,
 		.print		= DNAT6_print,
 		.save		= DNAT6_save,
-		.x6_parse	= DNAT_parse6,
+		.x6_parse	= NAT_parse6,
 		.x6_fcheck	= DNAT_fcheck6,
 		.x6_options	= DNAT_opts,
 		.xlate		= DNAT6_xlate,
@@ -480,7 +480,7 @@ static struct xtables_target dnat_tg_reg[] = {
 		.help		= REDIRECT_help,
 		.print		= REDIRECT6_print,
 		.save		= REDIRECT6_save,
-		.x6_parse	= DNAT_parse6,
+		.x6_parse	= NAT_parse6,
 		.x6_fcheck	= DNAT_fcheck6,
 		.x6_options	= REDIRECT_opts,
 		.xlate		= REDIRECT6_xlate,
@@ -517,5 +517,5 @@ static struct xtables_target dnat_tg_reg[] = {
 
 void _init(void)
 {
-	xtables_register_targets(dnat_tg_reg, ARRAY_SIZE(dnat_tg_reg));
+	xtables_register_targets(nat_tg_reg, ARRAY_SIZE(nat_tg_reg));
 }
-- 
2.38.0

