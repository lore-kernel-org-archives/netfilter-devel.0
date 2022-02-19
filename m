Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48203C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbiBSNay (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242352AbiBSNat (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:49 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0E988B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BejZdcYek0sYGGXmdAtL0JLl253mhQrgfYzdmoiWuD8=; b=nBEjgMbMm5tdfvkHQvy+MOnCJJ
        L6pc+LLYfnNLI2va3BSXqnz2jM2u5qSYwcrS3Bv4D8daW5qzfSnv93Mkf8UvXfta2gm6x5v5RUKl3
        YTBt5HxkkqG8NtE+g2a901SQvTbYL7bYfUZkJDkbDmT42NafmrIR41hDHUATCMGEs5zM0pGxbUiSM
        TGh88Y7PJq9o+T9jDnIoJXiAR7JsJRxS/TSg5jKAH9rTkC7T4CBxJRJ4jHiKvxY15zH0ktlyeskes
        mp/k/gFmno2OfmoRCQkodBQLkbjVVFNYVacsasjIpenI1ydnDNAJ4B8ddIM4F68+vGNbOgFzCI+CE
        D72DV76Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoj-0002eB-3O; Sat, 19 Feb 2022 14:30:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 16/26] scanner: rt: Extend scope over rt0, rt2 and srh
Date:   Sat, 19 Feb 2022 14:28:04 +0100
Message-Id: <20220219132814.30823-17-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These are technically all just routing headers with different types, so
unify them under the same scope.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_bison.y |  6 +++---
 src/scanner.l      | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c8fb154353924..a4f98e59e282a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -5792,7 +5792,7 @@ rt_hdr_field		:	NEXTHDR		{ $$ = RTHDR_NEXTHDR; }
 			|	SEG_LEFT	{ $$ = RTHDR_SEG_LEFT; }
 			;
 
-rt0_hdr_expr		:	RT0	rt0_hdr_field
+rt0_hdr_expr		:	RT0	rt0_hdr_field	close_scope_rt
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_rt0, $2);
 			}
@@ -5804,7 +5804,7 @@ rt0_hdr_field		:	ADDR	'['	NUM	']'
 			}
 			;
 
-rt2_hdr_expr		:	RT2	rt2_hdr_field
+rt2_hdr_expr		:	RT2	rt2_hdr_field	close_scope_rt
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_rt2, $2);
 			}
@@ -5813,7 +5813,7 @@ rt2_hdr_expr		:	RT2	rt2_hdr_field
 rt2_hdr_field		:	ADDR		{ $$ = RT2HDR_ADDR; }
 			;
 
-rt4_hdr_expr		:	RT4	rt4_hdr_field
+rt4_hdr_expr		:	RT4	rt4_hdr_field	close_scope_rt
 			{
 				$$ = exthdr_expr_alloc(&@$, &exthdr_rt4, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index eb8c3a130aac9..6975d9f226ef2 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -643,13 +643,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "rt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT; }
-"rt0"			{ return RT0; }
-"rt2"			{ return RT2; }
-"srh"			{ return RT4; }
+"rt0"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT0; }
+"rt2"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT2; }
+"srh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT4; }
 "addr"			{ return ADDR; }
-"last-entry"		{ return LAST_ENT; }
-"tag"			{ return TAG; }
-"sid"			{ return SID; }
 
 "hbh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HBH); return HBH; }
 
@@ -689,6 +686,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"nexthop"		{ return NEXTHOP; }
 	"seg-left"		{ return SEG_LEFT; }
 	"mtu"			{ return MTU; }
+	"last-entry"		{ return LAST_ENT; }
+	"tag"			{ return TAG; }
+	"sid"			{ return SID; }
 }
 <SCANSTATE_EXPR_RT,SCANSTATE_TYPE>{
 	"classid"		{ return CLASSID; }
-- 
2.34.1

