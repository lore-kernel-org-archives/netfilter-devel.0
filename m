Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FBEC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiBSN34 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiBSN3z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39227D282
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kD1k7yOzB+Ru4FpDXJ7PxkxL4GDItNjuQIjuM8tOdLM=; b=PnHchn9Ko2Uy5Ax7mqo8sK77qZ
        ZUOfH8fYiCNXcAtfRfB+1r/xI2NKRoEvOSJKXbgj8sYlgThgUKSLMws89kFGQhaZDkkwGJQa+X8mf
        qCqgaJFOsLS1nnNvYd2p0FOp55NQfbbujoQpGNYN2Pd+1qJ80sVIqrDk0Nqf7uA1cB2EF6fVpbZgc
        dj4fs7LErvM3Jf/rn0pCPsPPEop23KFafAWdO4ms3Syxp1mKfjhitWkIeY/NFfPA3gAwjT3hAokMU
        Dx6zu7rmXRVYX9SU53SlEOEp+igHjEOuDj87dWBZbgLg2lLXx/qNN0jAPOK2B8nj1XPHE5wbEfD8p
        tnKg3rTQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPnq-0002Zi-K4; Sat, 19 Feb 2022 14:29:35 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 02/26] scanner: Move 'maps' keyword into list cmd scope
Date:   Sat, 19 Feb 2022 14:27:50 +0100
Message-Id: <20220219132814.30823-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This was missed when introducing SCANSTATE_CMD_LIST, no other command
operates on "maps".

Fixes: 6a24ffb04642e ("scanner: add list cmd parser scope")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 7dcc45c2fd505..ce78fcd6fa995 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -286,7 +286,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "set"			{ return SET; }
 "element"		{ return ELEMENT; }
 "map"			{ return MAP; }
-"maps"			{ return MAPS; }
 "flowtable"		{ return FLOWTABLE; }
 "handle"		{ return HANDLE; }
 "ruleset"		{ return RULESET; }
@@ -353,6 +352,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"meters"		{ return METERS; }
 	"flowtables"		{ return FLOWTABLES; }
 	"limits"		{ return LIMITS; }
+	"maps"			{ return MAPS; }
 	"secmarks"		{ return SECMARKS; }
 	"synproxys"		{ return SYNPROXYS; }
 	"hooks"			{ return HOOKS; }
-- 
2.34.1

