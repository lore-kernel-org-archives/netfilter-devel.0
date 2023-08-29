Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20EAC71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjH2Nnw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbjH2Nns (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 09:43:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96194CDD
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 06:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ud9ycw8j+F7UsKYBbtmq1XG0ytnkE/NCJhTXjE7Ugc4=; b=JxjXorniiXJH5kk77VOUEZgl9G
        9Q0Yy+KsOitkOvcwjIlOBeHg/png5c/Jj+br/Rou9XRQiSSncGwFoyKwnZRLipHTpKDcGLj4V3cJg
        gtc9832uccZgBuu+EGMXuasaXVnfBwVua5YkTT2u9vlyDPN9HTwqfP3tfny3ePVbK5oi7DiBZyEad
        EiyBLB3OE08Wpjw9S04oab3yF84/2hB5lmWttbBxM+TRrcT4OgJ82zB5neL34sMv6DvCjaiFkRnTw
        HMiV9t+jHg7ZuhMxxuTjuGvQLtJ9X1YFTJtbLWdto1WEq39BGVmHB1q1iwB7Cb0qROWuscBO6U0mR
        R3zO3j5Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qayzH-0000TI-CA
        for netfilter-devel@vger.kernel.org; Tue, 29 Aug 2023 15:42:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] tests: monitor: Fix for wrong syntax in set-interval.t
Date:   Tue, 29 Aug 2023 15:48:11 +0200
Message-ID: <20230829134812.31863-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829134812.31863-1-phil@nwl.cc>
References: <20230829134812.31863-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expected JSON output must be prefixed 'J'.

Fixes: 7ab453a033c9a ("monitor: do not call interval_map_decompose() for concat intervals")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/set-interval.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/testcases/set-interval.t b/tests/monitor/testcases/set-interval.t
index b0649cdfe01e6..5053c596b3b1b 100644
--- a/tests/monitor/testcases/set-interval.t
+++ b/tests/monitor/testcases/set-interval.t
@@ -27,4 +27,4 @@ J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "ex
 # ... and anon concat range
 I add rule ip t c ether saddr . ip saddr { 08:00:27:40:f7:09 . 192.168.56.10-192.168.56.12 }
 O -
-{"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"concat": [{"payload": {"protocol": "ether", "field": "saddr"}}, {"payload": {"protocol": "ip", "field": "saddr"}}]}, "right": {"set": [{"concat": ["08:00:27:40:f7:09", {"range": ["192.168.56.10", "192.168.56.12"]}]}]}}}]}}}
+J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"match": {"op": "==", "left": {"concat": [{"payload": {"protocol": "ether", "field": "saddr"}}, {"payload": {"protocol": "ip", "field": "saddr"}}]}, "right": {"set": [{"concat": ["08:00:27:40:f7:09", {"range": ["192.168.56.10", "192.168.56.12"]}]}]}}}]}}}
-- 
2.41.0

