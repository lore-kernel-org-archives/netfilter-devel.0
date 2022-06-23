Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AE1C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 14:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiFWO24 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 10:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiFWO2z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 10:28:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8326342ECC
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 07:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=taY2Alc+aiMHxLMb9HstrgTYXswM0q7Ywi4GoWkyxVM=; b=Tr3FVNt6CPgNehbYKunGdnPnAF
        wbHd6ianiUTeAEaJaxg/Th+inyO+VO+6SPjPvI/Kkgxft7ne/fEWZVl28dN7euIBJ0w17mtQwyRV4
        X/bSJJejVqFvv5MOewhomhwQIhyVZv0fPOEOWdUlk21gkdvksTU0cf6ACaf7+bOCBp8a+PpapbViZ
        KzzEQEQe7MhwxE6sLqpVcWoUd5q5xOUN3Kiwb1UTy95WtNAiKlraSENyvDgeicsV4mKwZGFTxxevY
        799fkTWpBPhFX1fx71+3n9rVcskjnNOlx9XI3Yx/2rsdv26GpD+o4Tc0HBW1OYmH5RVanxey5xosZ
        aftIRylg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1o4NpE-0007QC-0c; Thu, 23 Jun 2022 16:28:52 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 2/2] Revert "scanner: remove saddr/daddr from initial state"
Date:   Thu, 23 Jun 2022 16:28:43 +0200
Message-Id: <20220623142843.32309-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220623142843.32309-1-phil@nwl.cc>
References: <20220623142843.32309-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit df4ee3171f3e3c0e85dd45d555d7d06e8c1647c5 as it
breaks ipsec expression if preceeded by a counter statement:

| Error: syntax error, unexpected string, expecting saddr or daddr
| add rule ip ipsec-ip4 ipsec-forw counter ipsec out ip daddr 192.168.1.2
|                                                       ^^^^^

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index 7eb74020ef848..6d6396bbb7413 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -464,10 +464,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "bridge"		{ return BRIDGE; }
 
 "ether"			{ scanner_push_start_cond(yyscanner, SCANSTATE_ETH); return ETHER; }
-<SCANSTATE_ARP,SCANSTATE_CT,SCANSTATE_ETH,SCANSTATE_IP,SCANSTATE_IP6,SCANSTATE_EXPR_FIB,SCANSTATE_EXPR_IPSEC>{
-	"saddr"			{ return SADDR; }
-	"daddr"			{ return DADDR; }
-}
+"saddr"			{ return SADDR; }
+"daddr"			{ return DADDR; }
 "type"			{ scanner_push_start_cond(yyscanner, SCANSTATE_TYPE); return TYPE; }
 "typeof"		{ return TYPEOF; }
 
-- 
2.34.1

