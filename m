Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C06FC43619
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFC1961386
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhDARl7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbhDARk7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 13:40:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A893C08ECBF
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 07:09:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRy0K-0001XX-MP; Thu, 01 Apr 2021 16:09:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/4] proto: add 8021ad as mnemonic for IEEE 802.1AD (0x88a8) ether type
Date:   Thu,  1 Apr 2021 16:08:44 +0200
Message-Id: <20210401140846.24452-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210401140846.24452-1-fw@strlen.de>
References: <20210401140846.24452-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/proto.c   | 1 +
 src/scanner.l | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/proto.c b/src/proto.c
index b6466f8b65d4..67c519be1382 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -1058,6 +1058,7 @@ static const struct symbol_table ethertype_tbl = {
 		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
 		SYMBOL("ip6",		__constant_htons(ETH_P_IPV6)),
 		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
+		SYMBOL("8021ad",	__constant_htons(ETH_P_8021AD)),
 		SYMBOL_LIST_END
 	},
 };
diff --git a/src/scanner.l b/src/scanner.l
index b4e7cf199ccd..9eb79d2d2454 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -422,6 +422,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"cfi"		{ return CFI; }
 	"pcp"		{ return PCP; }
 }
+"8021ad"		{ yylval->string = xstrdup(yytext); return STRING; }
 
 "arp"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ARP); return ARP; }
 <SCANSTATE_ARP>{
-- 
2.26.3

