Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDBAC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 196DB64FA0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbhCKNYE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhCKNXt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:23:49 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33897C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 05:23:49 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lKLI3-0003hF-SY; Thu, 11 Mar 2021 14:23:47 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 07/12] scanner: remove saddr/daddr from initial state
Date:   Thu, 11 Mar 2021 14:23:08 +0100
Message-Id: <20210311132313.24403-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311132313.24403-1-fw@strlen.de>
References: <20210311132313.24403-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This can now be reduced to expressions that can expect saddr/daddr tokens.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/scanner.l | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 509b1b0d77a2..728b2c79b395 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -396,8 +396,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "bridge"		{ return BRIDGE; }
 
 "ether"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ETH); return ETHER; }
-"saddr"			{ return SADDR; }
-"daddr"			{ return DADDR; }
+<SCANSTATE_ARP,SCANSTATE_CT,SCANSTATE_ETH,SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_FIB,SCANSTATE_EXPR_IPSEC>{
+	"saddr"			{ return SADDR; }
+	"daddr"			{ return DADDR; }
+}
 "type"			{ return TYPE; }
 "typeof"		{ return TYPEOF; }
 
-- 
2.26.2

