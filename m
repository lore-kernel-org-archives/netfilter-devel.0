Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1ABC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237835AbiBSN3F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiBSN3E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:04 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83811016
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8zqnV/dLl1DzAmAoDN/ha4/TOffDSNDhzW/ZZwcdFFg=; b=RNKkpeh5AHQl7hHIQ0+ZH5JmF7
        WscPWOyadqBDQP5K5Dh10f394UIyDuKjVLjJaI8OLrNkwSbbNBo0z+rcPnffKZGGJ/0kF+hgaS/Go
        affkEP/qa+XeqT/KRnAk/Qi6kCtj1vC+5efJjxbBtQG66K2yraW5/o4dhwJ1U8fJn++48cpWyDC4K
        3lYCQv3nZ0Ax0jMK73jMDwoeamgX8crmCcRkEfAJin6pzFjmLnUYlgV9WsRbnLCFus9wToLlXQSq2
        SBhAO7Anq+bNYwhxRIq8pdZasfTqaPqCIjFb36/66DCVK7nr8ZN3MEpUmcub/k9XDEutVovvPVuOg
        1VAvBLYQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPn2-0002Wj-47; Sat, 19 Feb 2022 14:28:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 12/26] scanner: osf: Move to own scope
Date:   Sat, 19 Feb 2022 14:28:00 +0100
Message-Id: <20220219132814.30823-13-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It shares two keywords with PARSER_SC_IP.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   |  1 +
 src/parser_bison.y |  5 +++--
 src/scanner.l      | 13 +++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index ab372ad0bae88..82402dbc54a70 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -51,6 +51,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_HASH,
 	PARSER_SC_EXPR_IPSEC,
 	PARSER_SC_EXPR_NUMGEN,
+	PARSER_SC_EXPR_OSF,
 	PARSER_SC_EXPR_QUEUE,
 	PARSER_SC_EXPR_RT,
 	PARSER_SC_EXPR_SCTP_CHUNK,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index adfaa460caf36..2deee99394999 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -943,6 +943,7 @@ close_scope_ipsec	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_IPSEC)
 close_scope_list	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_LIST); };
 close_scope_limit	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_LIMIT); };
 close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGEN); };
+close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
@@ -4104,11 +4105,11 @@ fib_tuple		:  	fib_flag	DOT	fib_tuple
 			|	fib_flag
 			;
 
-osf_expr		:	OSF	osf_ttl		HDRVERSION
+osf_expr		:	OSF	osf_ttl		HDRVERSION	close_scope_osf
 			{
 				$$ = osf_expr_alloc(&@$, $2, NFT_OSF_F_VERSION);
 			}
-			|	OSF	osf_ttl		NAME
+			|	OSF	osf_ttl		NAME	close_scope_osf
 			{
 				$$ = osf_expr_alloc(&@$, $2, 0);
 			}
diff --git a/src/scanner.l b/src/scanner.l
index ed26811c5d906..65640ebbf40eb 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -217,6 +217,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_HASH
 %s SCANSTATE_EXPR_IPSEC
 %s SCANSTATE_EXPR_NUMGEN
+%s SCANSTATE_EXPR_OSF
 %s SCANSTATE_EXPR_QUEUE
 %s SCANSTATE_EXPR_RT
 %s SCANSTATE_EXPR_SCTP_CHUNK
@@ -367,7 +368,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "counter"		{ scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
-"name"			{ return NAME; }
+<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF>"name"			{ return NAME; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"		{ return PACKETS; }
 <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"	{ return BYTES; }
 
@@ -456,13 +457,17 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 }
 
 "ip"			{ scanner_push_start_cond(yyscanner, SCANSTATE_IP); return IP; }
-"version"		{ return HDRVERSION; }
+<SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_OSF>{
+	"version"		{ return HDRVERSION; }
+}
 "hdrlength"		{ return HDRLENGTH; }
 "dscp"			{ return DSCP; }
 "ecn"			{ return ECN; }
 "length"		{ return LENGTH; }
 "frag-off"		{ return FRAG_OFF; }
-"ttl"			{ return TTL; }
+<SCANSTATE_EXPR_OSF,SCANSTATE_IP>{
+	"ttl"			{ return TTL; }
+}
 "protocol"		{ return PROTOCOL; }
 "checksum"		{ return CHECKSUM; }
 
@@ -705,7 +710,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "fib"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_FIB); return FIB; }
 
-"osf"			{ return OSF; }
+"osf"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_OSF); return OSF; }
 
 "synproxy"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_SYNPROXY); return SYNPROXY; }
 <SCANSTATE_STMT_SYNPROXY>{
-- 
2.34.1

