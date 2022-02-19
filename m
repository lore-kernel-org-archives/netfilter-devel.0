Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DACC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiBSNaG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238414AbiBSNaG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AAA88B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GRe0coO4we9AhjI+LC/byJ0vY4AKLeIW09hAH1qrIPY=; b=aCgWSb1Gd9z4E5RRpC52SYyygs
        YzDvMyvonZ1EdbYJJwDprNJYoE29DvuLwDntGN02rduuwjQHNVyzV0QEy4hRP+oGyJVW6j73DY5G7
        VrEnmBoNd9KxX2+5nkdHtNB8l4TvjyE3OuBuDQzp4ZVEAQrl5prK5SKYlJlAG+jXgXBnGAQQPBW3M
        oeMlQBEzE4p/UkYU/qNOUu+F+6ZQXqRZpt4TaeaIXV0uIbX1KjWLM0hGDeQ/xtSnH3SHIoz0MkTIU
        HxOWv112gcefhB6gnNiuNy8RPr82rMC5G58fpBW7pPJU21QapF7yegp3HGRx58spG4umGe5PbYVh+
        tdXKyYXA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPo2-0002ae-2R; Sat, 19 Feb 2022 14:29:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 22/26] scanner: policy: move to own scope
Date:   Sat, 19 Feb 2022 14:28:10 +0100
Message-Id: <20220219132814.30823-23-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Isolate 'performance' and 'memory' keywords.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 7 ++++---
 src/scanner.l      | 9 ++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 57f1fcc56bd54..79eadc0d7e52f 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -40,6 +40,7 @@ enum startcond_type {
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
 	PARSER_SC_LIMIT,
+	PARSER_SC_POLICY,
 	PARSER_SC_QUOTA,
 	PARSER_SC_SCTP,
 	PARSER_SC_SECMARK,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index af31f72fd6c99..eca51617e1713 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -954,6 +954,7 @@ close_scope_mh		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_MH); };
 close_scope_monitor	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_MONITOR); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
 close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); };
+close_scope_policy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_POLICY); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_reject	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_REJECT); };
@@ -2098,7 +2099,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	set_mechanism	stmt_separator
 			;
 
-set_mechanism		:	POLICY		set_policy_spec
+set_mechanism		:	POLICY		set_policy_spec	close_scope_policy
 			{
 				$<set>0->policy = $2;
 			}
@@ -2516,7 +2517,7 @@ flags_spec		:	FLAGS		OFFLOAD	close_scope_flags
 			}
 			;
 
-policy_spec		:	POLICY		policy_expr
+policy_spec		:	POLICY		policy_expr	close_scope_policy
 			{
 				if ($<chain>0->policy) {
 					erec_queue(error(&@$, "you cannot set chain policy twice"),
@@ -4563,7 +4564,7 @@ ct_timeout_config	:	PROTOCOL	ct_l4protoname	stmt_separator
 				ct = &$<obj>0->ct_timeout;
 				ct->l4proto = l4proto;
 			}
-			|	POLICY 	'=' 	'{' 	timeout_states 	'}'	 stmt_separator
+			|	POLICY 	'=' 	'{' 	timeout_states 	'}'	 stmt_separator	close_scope_policy
 			{
 				struct ct_timeout *ct;
 
diff --git a/src/scanner.l b/src/scanner.l
index 608471b39898d..b885f84523b97 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -206,6 +206,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
 %s SCANSTATE_LIMIT
+%s SCANSTATE_POLICY
 %s SCANSTATE_QUOTA
 %s SCANSTATE_SCTP
 %s SCANSTATE_SECMARK
@@ -370,10 +371,12 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "elements"		{ return ELEMENTS; }
 "expires"		{ return EXPIRES; }
 
-"policy"		{ return POLICY; }
+"policy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_POLICY); return POLICY; }
 "size"			{ return SIZE; }
-"performance"		{ return PERFORMANCE; }
-"memory"		{ return MEMORY; }
+<SCANSTATE_POLICY>{
+	"performance"		{ return PERFORMANCE; }
+	"memory"		{ return MEMORY; }
+}
 
 "flow"			{ return FLOW; }
 "offload"		{ return OFFLOAD; }
-- 
2.34.1

