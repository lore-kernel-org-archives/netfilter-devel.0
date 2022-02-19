Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653B0C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbiBSNao (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:30:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiBSNan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:30:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0FE88B32
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2fycDfU5E94lfji7pjc+DOBhOK+IcMRIplrBloAyNa8=; b=DEYvRI9Szf/Nj0wXqb0ZeGU/IA
        5PIPWs9z9hatKzUWyPqV0neC+c+c8hK19Z5Lk0txjTP9rqd2G1X5t1WmqmpJJdnEbOlZ4HXCr9jOA
        wCsTe5Hl2rhS0zlXt4q1p5BB9ADOyKgNhoQ8LR+p5ygYQUQLjXRqpSRXee1HeijDiWA4Wfv94ykXq
        9ZRbpzfXt1m3KmsaC0YLPTtCfZVNb/Xy9Vrx0d4bwB3AKoprxL+pCzlJ1vq5/fWW9RjgCWxVNX+1o
        egY1rTlRwdN0knCRdawUdhNNJ6mgVrVWyZKBDCng3zgz4xZb+ICddwwzfJ5FVYigv348ruaBHwrAa
        pjQ1nMxg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPod-0002dr-Pd; Sat, 19 Feb 2022 14:30:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 03/26] scanner: Some time units are only used in limit scope
Date:   Sat, 19 Feb 2022 14:27:51 +0100
Message-Id: <20220219132814.30823-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

'hour' and 'day' are allowed as unqualified meta expressions, so leave
them alone.

Fixes: eae2525685252 ("scanner: limit: move to own scope")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index ce78fcd6fa995..eaf5460870a09 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -385,6 +385,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_LIMIT>{
 	"rate"			{ return RATE; }
 	"burst"			{ return BURST; }
+
+	/* time_unit */
+	"second"		{ return SECOND; }
+	"minute"		{ return MINUTE; }
+	"week"			{ return WEEK; }
 }
 <SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"over"		{ return OVER; }
 
@@ -394,11 +399,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"until"		{ return UNTIL; }
 }
 
-"second"		{ return SECOND; }
-"minute"		{ return MINUTE; }
 "hour"			{ return HOUR; }
 "day"			{ return DAY; }
-"week"			{ return WEEK; }
 
 "reject"		{ return _REJECT; }
 "with"			{ return WITH; }
-- 
2.34.1

