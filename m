Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88920C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241603AbiBSNa2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbiBSNa2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:28 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693C988B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vBm1pH7OljdG617zsZyeXCjVBAfSQQ01MfdPt4JtbI0=; b=KC+MNh5FjvG1ydOnGgcmFOr9rI
        sQ56i4Z+ecMRyhY9OprDXpoWx1DY/11eQTWVIRCteOIUMHsh0BhWafWIaAXAM6xVGbi+GHwqibL2X
        UiTBpcPX3YunjAnD7T1bFOcQhoIwLZ2rhSibXDesmSxFspdyb5vgCIV3DBG32gcQ+mBmBORvx7fb5
        d6EwlGkJtF9pBXLpphfQ/4HGsM6c9DyPN0nGqO/h+bG4Kc1qf8gps4vBrdm7T/nRgtq7oFzCgm2W8
        OW1peb83Mc28hoF5VXmJMmcMuh9wIzE4t7jCF4Rij+H4CF3lnzbZ1avZZHVugVGuNyvdOogDdl7Gf
        6TbOIjIg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoN-0002cm-HZ; Sat, 19 Feb 2022 14:30:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 06/26] scanner: igmp: Move to own scope
Date:   Sat, 19 Feb 2022 14:27:54 +0100
Message-Id: <20220219132814.30823-7-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At least isolates 'mrt' and 'group' keywords, the latter is shared with
log statement.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  3 ++-
 src/scanner.l      | 10 +++++++---
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index ba955c9160581..16e02a1ffe129 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -35,6 +35,7 @@ enum startcond_type {
 	PARSER_SC_COUNTER,
 	PARSER_SC_ETH,
 	PARSER_SC_ICMP,
+	PARSER_SC_IGMP,
 	PARSER_SC_IP,
 	PARSER_SC_IP6,
 	PARSER_SC_LIMIT,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ca5140ade098e..6340bda6cc585 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -936,6 +936,7 @@ close_scope_ip		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP); };
 close_scope_ip6		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IP6); };
 close_scope_vlan	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_VLAN); };
 close_scope_icmp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ICMP); };
+close_scope_igmp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_IGMP); };
 close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC); };
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
@@ -5395,7 +5396,7 @@ icmp_hdr_field		:	TYPE		{ $$ = ICMPHDR_TYPE; }
 			|	MTU		{ $$ = ICMPHDR_MTU; }
 			;
 
-igmp_hdr_expr		:	IGMP	igmp_hdr_field
+igmp_hdr_expr		:	IGMP	igmp_hdr_field	close_scope_igmp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_igmp, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index e8ec352f88698..a584b5fba39b4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -201,6 +201,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_COUNTER
 %s SCANSTATE_ETH
 %s SCANSTATE_ICMP
+%s SCANSTATE_IGMP
 %s SCANSTATE_IP
 %s SCANSTATE_IP6
 %s SCANSTATE_LIMIT
@@ -369,11 +370,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
 "prefix"		{ return PREFIX; }
-"group"			{ return GROUP; }
 <SCANSTATE_STMT_LOG>{
 	"snaplen"		{ return SNAPLEN; }
 	"queue-threshold"	{ return QUEUE_THRESHOLD; }
 	"level"			{ return LEVEL; }
+	"group"			{ return GROUP; }
 }
 
 "queue"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
@@ -508,8 +509,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 "sequence"		{ return SEQUENCE; }
 
-"igmp"			{ return IGMP; }
-"mrt"			{ return MRT; }
+"igmp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IGMP); return IGMP; }
+<SCANSTATE_IGMP>{
+	"mrt"			{ return MRT; }
+	"group"			{ return GROUP; }
+}
 
 "ip6"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP6); return IP6; }
 "priority"		{ return PRIORITY; }
-- 
2.34.1

