Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF89CC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJLPTg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJLPTL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:19:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A907E312D
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BHG43aALjjoJdJ33U/T/j9QOU0VyKdlXOQD0yID+HSw=; b=XdaVyBlze68tuFfsEWLNJbns4M
        YKDAafZwdFzWTqgFNEzGmwmOtTsFPrGxAjcpxxFxXzwNax1ENjN2Q1cWqRTeLTQTTl/WZZsriWJFJ
        oxmOrR4ELC4QR8Q1BDUHXRmrEViY9Ha4EE42bocNsBS2OXDziC+cRm9e9rycr6wKvsgHZWJTETfiH
        dcjFour2C3R6tuWIp/fnEhSElMIcUAgBedATaQiuL3O0w7q+Eq8BAE3PgwwQqF/Pxa5mG5kCtezy5
        xgGYUpGMEqvwevMJ2witf+DCKae6/omJq/F+LOYTrgRsLSBS1kXz0mg28+nTelU7YFSi7ZZDM6Urx
        puj0FXVA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidVg-0002qN-HP; Wed, 12 Oct 2022 17:19:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 07/12] tests: libxt_length.t: Fix odd use-case output
Date:   Wed, 12 Oct 2022 17:17:57 +0200
Message-Id: <20221012151802.11339-8-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Specifying the lower boundary suffixed by colon is an undocumented
feature. Explicitly printing the upper boundary in that case seems sane.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_length.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_length.t b/extensions/libxt_length.t
index 0b6624ee069f6..8b70fc317485c 100644
--- a/extensions/libxt_length.t
+++ b/extensions/libxt_length.t
@@ -2,7 +2,7 @@
 -m length --length 1;=;OK
 -m length --length :2;-m length --length 0:2;OK
 -m length --length 0:3;=;OK
--m length --length 4:;=;OK
+-m length --length 4:;-m length --length 4:65535;OK
 -m length --length 0:65535;=;OK
 -m length ! --length 0:65535;=;OK
 -m length --length 0:65536;;FAIL
-- 
2.34.1

