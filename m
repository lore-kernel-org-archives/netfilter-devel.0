Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80A1C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 15:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiFWPwx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 11:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiFWPwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 11:52:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E85D43EF1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 08:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C4YAh9IczQaKkX5Y/zMQ1foadIx1Pskk/EfNlY5PXdo=; b=orkZHKadH0I1aIFIaUtwFV9R2/
        C/L9k2qUx/rqfyF1CRUWY8KK5nnRTUfa/eJ0zNxIxLhQhVSeVMy0Wk+mI3u8aa+ot2ocTaZTZsdE/
        tmVDd+9IDuVpzLzd0xSJip4yVz+3E3ApwUTcG/4MLt+6iALte1CRRhi9017Bn2irV540YCBW+9h9B
        qraEkac3+ZS/bHTUKPj7bZVO+wWGDA/diyfIKAzGerHSVlkCLVssTFvAWzpNo0LVzoYCPQbpxz/ch
        6mKW5Ag1TO6hq9XpE43PldJjn8n/MMbvkItEY+rzwmSa+yuFKVqVStOfjpGJJ5bJl9UeJC8dvoLqY
        PpsTIxLw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1o4P8U-0008Cn-0K; Thu, 23 Jun 2022 17:52:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2] Revert "scanner: remove saddr/daddr from initial state"
Date:   Thu, 23 Jun 2022 17:52:41 +0200
Message-Id: <20220623155241.28859-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
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
Changes since v1:
- Fold the two patches into one.
---
 src/scanner.l                 |  6 ++----
 tests/py/inet/ipsec.t         |  2 ++
 tests/py/inet/ipsec.t.json    | 21 +++++++++++++++++++++
 tests/py/inet/ipsec.t.payload |  6 ++++++
 4 files changed, 31 insertions(+), 4 deletions(-)

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

