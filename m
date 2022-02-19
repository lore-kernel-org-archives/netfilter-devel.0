Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA26C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbiBSN2t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:28:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiBSN2s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:28:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED061011
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TfNWabBQb9+SCUctZEyjjI+ylA5JdpK85zMvAxu5nyQ=; b=n0hxVx+noVOQ3Ya/Gclm5q3Et2
        teZ8+MxE0/APfizg7fd0bXNFHpLgdpJWe+qG1YfwqXMvY1ewhzZAjWaZKWirDWjvDyoY+jMFey+O1
        xQ71PmV3Il0PN57/F2WVqpTBR13NqFY8HfvWwOCapTf5iKzWfS1knv2h7aySAS1VaStj/1uHUht80
        rNkQd6RSndnQoe8ItuUS+XzRi1ilympqE51mUq8ZrLiFzzuA5vsbsF5sCEZsmhrt3pxRDsFlx4Z9J
        awMsbC6vNiW6q9pW21HMPVG5NGd7kK6MpywO6A3Ma2nylQ9Mv7Kvo6W+SfewIUc27GRc12e9XHb/x
        SAhBZbfA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPmm-0002Vd-24; Sat, 19 Feb 2022 14:28:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 20/26] scanner: reject: Move to own scope
Date:   Sat, 19 Feb 2022 14:28:08 +0100
Message-Id: <20220219132814.30823-21-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two more keywords isolated.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/parser.h   | 1 +
 src/parser_bison.y | 3 ++-
 src/scanner.l      | 9 ++++++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/parser.h b/include/parser.h
index 090fd78871a6e..08bdeaca250b2 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -72,6 +72,7 @@ enum startcond_type {
 	PARSER_SC_EXPR_UDPLITE,
 
 	PARSER_SC_STMT_LOG,
+	PARSER_SC_STMT_REJECT,
 	PARSER_SC_STMT_SYNPROXY,
 };
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 22e953eaf77e6..1cdf4cc88376f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -955,6 +955,7 @@ close_scope_numgen	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_NUMGE
 close_scope_osf		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_OSF); };
 close_scope_quota	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_QUOTA); };
 close_scope_queue	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_QUEUE); };
+close_scope_reject	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_REJECT); };
 close_scope_reset	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_CMD_RESET); };
 close_scope_rt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_RT); };
 close_scope_sctp	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_SCTP); };
@@ -2835,7 +2836,7 @@ stmt			:	verdict_stmt
 			|	stateful_stmt
 			|	meta_stmt
 			|	log_stmt	close_scope_log
-			|	reject_stmt
+			|	reject_stmt	close_scope_reject
 			|	nat_stmt
 			|	tproxy_stmt
 			|	queue_stmt
diff --git a/src/scanner.l b/src/scanner.l
index 97545b7057ab7..6ef20512f6b35 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -238,6 +238,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_EXPR_UDPLITE
 
 %s SCANSTATE_STMT_LOG
+%s SCANSTATE_STMT_REJECT
 %s SCANSTATE_STMT_SYNPROXY
 
 %%
@@ -428,9 +429,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "hour"			{ return HOUR; }
 "day"			{ return DAY; }
 
-"reject"		{ return _REJECT; }
-"with"			{ return WITH; }
-"icmpx"			{ return ICMPX; }
+"reject"		{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_REJECT); return _REJECT; }
+<SCANSTATE_STMT_REJECT>{
+	"with"			{ return WITH; }
+	"icmpx"			{ return ICMPX; }
+}
 
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
-- 
2.34.1

