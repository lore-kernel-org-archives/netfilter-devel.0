Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34313C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 13:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236210AbiCBNtw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 08:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbiCBNtw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 08:49:52 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBD26E8F4
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 05:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZjhIuET/q6Re7U/Q0OEzbv8aKM0W0CYpLEXq4NBX07c=; b=WjMQsf76s0JF/Rt1aAsiMOnMUS
        BEPlyfUqIycGkwl19kBIQ43V0BU+jtMpDmeKRcQIvRkQYwE4hFdqkOkV/QJpnapAzg0uotQZb120l
        nTk3iQ7XgJvWNN7XtsoWbTbcJLwEK+vjnAt+EPj9OVwoeG31rtsc95upm16Agv4EIZX47iZsu2TDS
        WBo3D0O5PHSf17pZc8r2QcGnxlYS9t2Ocb3+MBrizj42AeJKKs4AtsbqdH3TOvlKn8j3Cs63FmXH5
        yxsSJSQPflh71Xf83QD1ob9HSNglJLHXe/MJBrxHwz4X04BYZ2q7s3B3tuRWsyreClU7s0g/aSk1l
        vhb0Bouw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nPPLm-0002EV-JW; Wed, 02 Mar 2022 14:49:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] scanner: Fix for ipportmap nat statements
Date:   Wed,  2 Mar 2022 14:49:05 +0100
Message-Id: <20220302134905.4673-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Due to lookahead, "addr" keyword is still found in IP/IP6 scope, not
STMT_NAT one.

Fixes: a67fce7ffe7e4 ("scanner: nat: Move to own scope")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index fd1cf059a608f..2154281e76572 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -678,7 +678,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rt0"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT0; }
 "rt2"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT2; }
 "srh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_RT); return RT4; }
-<SCANSTATE_EXPR_RT,SCANSTATE_STMT_NAT>"addr"			{ return ADDR; }
+<SCANSTATE_EXPR_RT,SCANSTATE_STMT_NAT,SCANSTATE_IP,SCANSTATE_IP6>"addr"			{ return ADDR; }
 
 "hbh"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_HBH); return HBH; }
 
-- 
2.34.1

