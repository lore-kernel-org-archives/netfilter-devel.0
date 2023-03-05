Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D690CC6FD1B
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCEKaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCEKaH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7D2D507
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fRCEqMhBHbWetvu4+PPrDgbwXDNwlaoXp+fIim5z7PY=; b=IEcFxHVrLTxCCDt5NGFf45kt4D
        XhusbAEzXAAvxx3o3TUQUj4647cJXRi3Mo+f46wZPQwJcO99faTGqBvrXvzBMu67/kffoZLaVYnt8
        z8XvmqbtrjOLK/R/4sd/bpHXH8CwzZEKX3JiK/ytf7G8AKOR2ctjQpitfmgh2iy3Yu8rVHfHTeoyX
        /24N1dxJL1RcCJgfESexEBg4Cog00/zdAmuSqcqoVGn0tjnrXnKIg1Vv96a72pyuNGdMQZIsAGgXg
        9exLXsFChhxkqD9hS9Y32sXZIFEci2eWssQJ8s7SMms8Hg4ZNjZ6YjWlAREqIbZKv15a8EBzJi+YT
        +L/lAZIw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcv-00DzC0-JL
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 6/8] doc: correct NAT statement description
Date:   Sun,  5 Mar 2023 10:14:16 +0000
Message-Id: <20230305101418.2233910-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305101418.2233910-1-jeremy@azazel.net>
References: <20230305101418.2233910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Specifying a port specifies that a port, not an address, should be
modified.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/statements.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 0532b2b16c7d..b2794bcd6821 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -405,7 +405,7 @@ You may specify a mapping to relate a list of tuples composed of arbitrary
 expression key with address value. |
 ipv4_addr, ipv6_addr, e.g. abcd::1234, or you can use a mapping, e.g. meta mark map { 10 : 192.168.1.2, 20 : 192.168.1.3 }
 |port|
-Specifies that the source/destination address of the packet should be modified. |
+Specifies that the source/destination port of the packet should be modified. |
 port number (16 bit)
 |===============================
 
-- 
2.39.2

