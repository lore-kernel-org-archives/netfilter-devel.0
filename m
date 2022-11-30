Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06838C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiK3TOW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3TOV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563A25E3E5
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I4bi7CyOKnpmg63CYLTBJJKTpCEJ4w9k18R3W/OWgMo=; b=BG4R3UHm+LIUgA6uMabOxPxvWL
        xYnh9ncVT4jsh/PaPL5nTjoFXhy/yljDBUsd9xt1wT5P5clC1FRkMR1PyDWmjbnXmno18QF+F9dH9
        J+WpQr6s7bV4Jsnydf00HW2AgjFQao1NkbDwf+ESYbSRfIki3qlm3JFeRtkZEYhsMFuMMszbt4QW7
        j1PjrncXjtpLWMN/1gslEtYLu9u65PbKcgyo6rZxRfdpPIpW2DJ8fmiv3ZD6ldUTq5oo57jxiF2NV
        R9CxijCsSFtSTLS4yPuXzdANONC5K5zKQPZY3QsKFNqJGVBx8NF/YcYAHMRAAo0o6vjieq/4b7j+I
        xDozlBew==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SXD-0001Az-ME
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/9] iptables-xml: Free allocated chain strings
Date:   Wed, 30 Nov 2022 20:13:39 +0100
Message-Id: <20221130191345.14543-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Freeing only if 'created' is non-zero is wrong - the data was still
allocated. In fact, the field is supposed to prevent only the call to
openChain().

Fixes: 8d3eccb19a9c6 ("Add iptables-xml tool (Amin Azez <azez@ufomechanic.net>)")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-xml.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index d28cf7481b55d..396c0a123ea08 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -225,13 +225,13 @@ finishChains(void)
 {
 	int c;
 
-	for (c = 0; c < nextChain; c++)
-		if (!chains[c].created) {
+	for (c = 0; c < nextChain; c++) {
+		if (!chains[c].created)
 			openChain(chains[c].chain, chains[c].policy,
 				  &(chains[c].count), '/');
-			free(chains[c].chain);
-			free(chains[c].policy);
-		}
+		free(chains[c].chain);
+		free(chains[c].policy);
+	}
 	nextChain = 0;
 }
 
-- 
2.38.0

