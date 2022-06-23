Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D52C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 14:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiFWO3F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 10:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiFWO3E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 10:29:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D86610553
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 07:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mK+fAkmDoVKnHHmHZGANHOl7nj3TJu8Oeo/UUt4KKeI=; b=RXv8mb95YcEsQp5TjGGzptQiNO
        NTWS8pLa9Y1+oxD4vZ+3bi2pnYJwgcuKz57tlU94ITLIZ6wLzefpA+wKR8vF16ikMEEh2+zbO/v2V
        +O6CUax6m8kkWu7cZ3eeKKFm+PK/BEA4pzrxSXvW2XgoBKeG2chnHcPmxutHy/hgHUvZAYHSfNkOl
        Rl4g3upLIHpDhKhojPvxsKcX1X/LstL32z8TwqPdqaX/jpo/dOZnE9us4jysGd9atfc4YmiN+8qj9
        bkyTaMxTi7psu0iezf9eluj7/rw+92X+7WJGWZbb6Z5z1OfNyATQSmz8+AQnMuuKZMhpEAjKaSqn8
        jXJ36olw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1o4NpO-0007Qq-MI; Thu, 23 Jun 2022 16:29:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 1/2] tests/py: Add a test for failing ipsec after counter
Date:   Thu, 23 Jun 2022 16:28:42 +0200
Message-Id: <20220623142843.32309-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220623142843.32309-1-phil@nwl.cc>
References: <20220623142843.32309-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a bug in parser/scanner due to scoping:

| Error: syntax error, unexpected string, expecting saddr or daddr
| add rule ip ipsec-ip4 ipsec-forw counter ipsec out ip daddr 192.168.1.2
|                                                       ^^^^^

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/ipsec.t         |  2 ++
 tests/py/inet/ipsec.t.json    | 21 +++++++++++++++++++++
 tests/py/inet/ipsec.t.payload |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/tests/py/inet/ipsec.t b/tests/py/inet/ipsec.t
index e924e9bcbdbc4..b18df395de6ce 100644
--- a/tests/py/inet/ipsec.t
+++ b/tests/py/inet/ipsec.t
@@ -19,3 +19,5 @@ ipsec in ip6 daddr dead::beef;ok
 ipsec out ip6 saddr dead::feed;ok
 
 ipsec in spnum 256 reqid 1;fail
+
+counter ipsec out ip daddr 192.168.1.2;ok
diff --git a/tests/py/inet/ipsec.t.json b/tests/py/inet/ipsec.t.json
index d7d3a03c21131..18a64f3533b34 100644
--- a/tests/py/inet/ipsec.t.json
+++ b/tests/py/inet/ipsec.t.json
@@ -134,3 +134,24 @@
         }
     }
 ]
+
+# counter ipsec out ip daddr 192.168.1.2
+[
+    {
+        "counter": null
+    },
+    {
+        "match": {
+            "left": {
+                "ipsec": {
+                    "dir": "out",
+                    "family": "ip",
+                    "key": "daddr",
+                    "spnum": 0
+                }
+            },
+            "op": "==",
+            "right": "192.168.1.2"
+        }
+    }
+]
diff --git a/tests/py/inet/ipsec.t.payload b/tests/py/inet/ipsec.t.payload
index c46a2263f6c01..9648255df02e9 100644
--- a/tests/py/inet/ipsec.t.payload
+++ b/tests/py/inet/ipsec.t.payload
@@ -37,3 +37,9 @@ ip ipsec-ip4 ipsec-forw
   [ xfrm load out 0 saddr6 => reg 1 ]
   [ cmp eq reg 1 0x0000adde 0x00000000 0x00000000 0xedfe0000 ]
 
+# counter ipsec out ip daddr 192.168.1.2
+ip ipsec-ip4 ipsec-forw
+  [ counter pkts 0 bytes 0 ]
+  [ xfrm load out 0 daddr4 => reg 1 ]
+  [ cmp eq reg 1 0x0201a8c0 ]
+
-- 
2.34.1

