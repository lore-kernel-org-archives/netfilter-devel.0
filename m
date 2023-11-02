Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823BFC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 15:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjKBPAH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjKBPAH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 11:00:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3042D13D
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 07:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9mAv6lSO74QuXZKVhYaKGMNwquil773pFWdjDAifr1c=; b=Ia0sLsKFUTlHKeC/io2VDRSsN+
        xq+849FxAyk0SgJCV/x8Go+PsKHI+HtjW9wcEPPOHyS7ST//5yknSmoGJcmladcqXX/tQJTmdoWx/
        vzhd1NpkwWoHISOgElk+ZgZfyHei3u+GclVYZWAchVN3nHNpQuREDnF0ATzpXYiUFCgyHFPFd5EyS
        MYQIZ46WwZE9a/xBZuFTFn7pTtROuDVpS5nsro2m51RCpgKOMf8VPhhxhoRLghSoZAgMA9NuSa86L
        k8pJpjgFlpVteZ416lwQaL+T77K0eU6EMZemsjvQqz94pt66wwZpPBbJWljpACGCLP4KSEnGMCArk
        cZ0ZqZEA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qyZAr-0004h6-Dv; Thu, 02 Nov 2023 15:59:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tproxy: Drop artificial port printing restriction
Date:   Thu,  2 Nov 2023 14:52:58 +0100
Message-ID: <20231102135258.17214-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It does not make much sense to omit printing the port expression if it's
not a value expression: On one hand, input allows for more advanced
uses. On the other, if it is in-kernel, best nft can do is to try and
print it no matter what. Just ignoring ruleset elements can't be
correct.

Fixes: 2be1d52644cf7 ("src: Add tproxy support")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1721
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/statement.c                |  2 +-
 tests/py/inet/tproxy.t         |  2 ++
 tests/py/inet/tproxy.t.json    | 35 ++++++++++++++++++++++++++++++++++
 tests/py/inet/tproxy.t.payload | 12 ++++++++++++
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/src/statement.c b/src/statement.c
index 475611664946a..f5176e6d87f95 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -989,7 +989,7 @@ static void tproxy_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 			expr_print(stmt->tproxy.addr, octx);
 		}
 	}
-	if (stmt->tproxy.port && stmt->tproxy.port->etype == EXPR_VALUE) {
+	if (stmt->tproxy.port) {
 		if (!stmt->tproxy.addr)
 			nft_print(octx, " ");
 		nft_print(octx, ":");
diff --git a/tests/py/inet/tproxy.t b/tests/py/inet/tproxy.t
index d23bbcb56cdcd..9901df75a91a8 100644
--- a/tests/py/inet/tproxy.t
+++ b/tests/py/inet/tproxy.t
@@ -19,3 +19,5 @@ meta l4proto 17 tproxy ip to :50080;ok
 meta l4proto 17 tproxy ip6 to :50080;ok
 meta l4proto 17 tproxy to :50080;ok
 ip daddr 0.0.0.0/0 meta l4proto 6 tproxy ip to :2000;ok
+
+meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 23, 1 : 42 };ok
diff --git a/tests/py/inet/tproxy.t.json b/tests/py/inet/tproxy.t.json
index 7b3b11c49205a..71b6fd2f678dd 100644
--- a/tests/py/inet/tproxy.t.json
+++ b/tests/py/inet/tproxy.t.json
@@ -183,3 +183,38 @@
         }
     }
 ]
+
+# meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 23, 1 : 42 }
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+            "addr": "127.0.0.1",
+            "family": "ip",
+            "port": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [ 0, 23 ],
+                            [ 1, 42 ]
+                        ]
+                    },
+                    "key": {
+                        "symhash": { "mod": 2 }
+                    }
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/tproxy.t.payload b/tests/py/inet/tproxy.t.payload
index 24bf8f6002f8f..2f41904261144 100644
--- a/tests/py/inet/tproxy.t.payload
+++ b/tests/py/inet/tproxy.t.payload
@@ -61,3 +61,15 @@ inet x y
   [ immediate reg 1 0x0000d007 ]
   [ tproxy ip port reg 1 ]
 
+# meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 23, 1 : 42 }
+__map%d x b size 2
+__map%d x 0
+	element 00000000  : 00001700 0 [end]	element 00000001  : 00002a00 0 [end]
+inet x y
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x0100007f ]
+  [ hash reg 2 = symhash() % mod 2 ]
+  [ lookup reg 2 set __map%d dreg 2 ]
+  [ tproxy ip addr reg 1 port reg 2 ]
+
-- 
2.41.0

