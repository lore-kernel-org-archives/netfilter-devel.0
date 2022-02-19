Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB128C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbiBSNae (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiBSNad (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:33 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE07A88B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CYlhjqyqy48v23tKjLjrrVLqdBUQNdhrt3i3hDuzfGE=; b=f9FqxE+P8lj8M/KEGtlKcxZbeq
        8z+kzkrLouWDmr/6LNveDL2+e8/qcleIwR4FDKFmZ7t9Vhtn4qdkooCLEORMORA0K8aCAybiCd+WM
        WT7MUYi0CBIgLuJX5oKWhsfa7R6gm/EXaszGwWuCAlMrKe6Jq6+yKc/tbADEZBnoyw9Ur/USlQ1ln
        uicbUMJl50YQEHtDPcDV++VMxlfhAbUpT9Vcuppjv2wQZXEy7UCAfZXNq3Oqn/B1/GPGEi0ugVje6
        wwfS1iojnj/Lo5kTRF16b9kjYuRlg37tgIyiSldSxXDtZYf/fZEfXn6QfjjhiJ+6AQXdgIrxyg8wZ
        qYs6M/6A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoT-0002dG-6X; Sat, 19 Feb 2022 14:30:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 09/26] scanner: comp: Move to own scope.
Date:   Sat, 19 Feb 2022 14:27:57 +0100
Message-Id: <20220219132814.30823-10-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Isolates only 'cpi' keyword for now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 5 +++--
 src/scanner.l      | 7 +++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 0e75bad482075..c16f210121040 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -45,6 +45,7 @@ enum startcond_type {
 	PARSER_SC_TCP,
 	PARSER_SC_VLAN,
 	PARSER_SC_CMD_LIST,
+	PARSER_SC_EXPR_COMP,
 	PARSER_SC_EXPR_FIB,
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 937bb410fa779..7a02eaf88a58f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -927,6 +927,7 @@ opt_newline		:	NEWLINE
 			;
 
 close_scope_arp		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ARP); };
+close_scope_comp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_COMP); };
 close_scope_ct		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CT); };
 close_scope_counter	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_COUNTER); };
 close_scope_eth		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_ETH); };
@@ -4813,7 +4814,7 @@ primary_rhs_expr	:	symbol_expr		{ $$ = $1; }
 							 BYTEORDER_HOST_ENDIAN,
 							 sizeof(data) * BITS_PER_BYTE, &data);
 			}
-			|	COMP
+			|	COMP	close_scope_comp
 			{
 				uint8_t data = IPPROTO_COMP;
 				$$ = constant_expr_alloc(&@$, &inet_protocol_type,
@@ -5464,7 +5465,7 @@ esp_hdr_field		:	SPI		{ $$ = ESPHDR_SPI; }
 			|	SEQUENCE	{ $$ = ESPHDR_SEQUENCE; }
 			;
 
-comp_hdr_expr		:	COMP	comp_hdr_field
+comp_hdr_expr		:	COMP	comp_hdr_field	close_scope_comp
 			{
 				$$ = payload_expr_alloc(&@$, &proto_comp, $2);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index 01cb501cb8cb3..a27df6c7e3915 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -211,6 +211,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_TCP
 %s SCANSTATE_VLAN
 %s SCANSTATE_CMD_LIST
+%s SCANSTATE_EXPR_COMP
 %s SCANSTATE_EXPR_FIB
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
@@ -544,9 +545,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "esp"			{ return ESP; }
 
-"comp"			{ return COMP; }
+"comp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_COMP); return COMP; }
+<SCANSTATE_EXPR_COMP>{
+	"cpi"			{ return CPI; }
+}
 "flags"			{ return FLAGS; }
-"cpi"			{ return CPI; }
 
 "udp"			{ return UDP; }
 "udplite"		{ return UDPLITE; }
-- 
2.34.1

