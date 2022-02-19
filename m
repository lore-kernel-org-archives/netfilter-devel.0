Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492A5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242368AbiBSNaz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242352AbiBSNaz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F4E88B33
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GaUR2jXs+TL2skJIu0i+FxR9QJFEKg9p4fVPPXfybBs=; b=nElKiA5kmnywUuydaWJvy+Brrr
        vcxRb7FOCymAciArLDqiGEUv03T7UN4RhmKO7YGmSl7Rye8SJXiZT/xn46Mym2WdViNrZP2dWSMdr
        CmDEjc5QoqirQ6qXHZimOo1aghMfUc/shADNUl+z7OtrZ5tis7CWNacPYuHZZILIPXpD4ROoanO8L
        wu5e1SPL75TacSZu1qQdi+cPocPJRLiN1GeSz/ja3k1IDA9vAOKzudj7l4vYRh3UQeKIMVyenq2hm
        HxWe7JtWiS0GrAxcNbjlYhtpgUFiRCiJnodRKNCUYs0kfnMqjpR3qiQnO6TWFT3Nv7SjOVF2DkMfu
        kJhP1hqg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPoo-0002eH-Do; Sat, 19 Feb 2022 14:30:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 04/26] scanner: rt: Move seg-left keyword into scope
Date:   Sat, 19 Feb 2022 14:27:52 +0100
Message-Id: <20220219132814.30823-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's not used outside of rt_hdr_expr, so move it out of INIT scope.

Fixes: 8861db1b771a6 ("scanner: rt: move to own scope")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index eaf5460870a09..9a189ec391328 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -590,7 +590,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "rt0"			{ return RT0; }
 "rt2"			{ return RT2; }
 "srh"			{ return RT4; }
-"seg-left"		{ return SEG_LEFT; }
 "addr"			{ return ADDR; }
 "last-entry"		{ return LAST_ENT; }
 "tag"			{ return TAG; }
@@ -631,6 +630,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_EXPR_RT>{
 	"classid"		{ return CLASSID; }
 	"nexthop"		{ return NEXTHOP; }
+	"seg-left"		{ return SEG_LEFT; }
 }
 
 "ct"			{ scanner_push_start_cond(yyscanner, SCANSTATE_CT); return CT; }
-- 
2.34.1

