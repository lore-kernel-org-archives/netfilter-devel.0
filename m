Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E83C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD9761075
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 20:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhJ2Umy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 16:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhJ2Umr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 16:42:47 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926F3C061767
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Oct 2021 13:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WMLNYCdgvHhxiAWw6Qp2xt5WnQ0337jRvmojQmzQrDg=; b=k7I7VJiY+hEmIlehwYN3IwldlU
        9hLsvbbO9A0GW2lTKnytUirMm4meBXp8dT/daQ0f4X9L5NoOQsKnL2CVUbVhsb+VkroshMLJ0OrzZ
        Y4JO6kAx2oEk7qvgXGax+YgvzuOdIkG+cqVQLvV/A2cibBtlZDrgMAcfMhF4jlb+7dtpGSdRaS4Gz
        InbTWL2jl2vqBIwy8OrsBfTuxNSf2Soz4z3Gf5V1ANHtGrfMQHxuqhEffplABHvJ8dvaZXobcWTBj
        5sqyT0p161VScW8MSq4ZbEUSyx8ngE8dS2WVxanjso5nax5KOkM4+1TTsMeii6sO0JiOBSOnjpjNz
        u/JKIWrA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgYfb-009Imx-9i; Fri, 29 Oct 2021 21:40:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 3/3] parser: extend limit syntax
Date:   Fri, 29 Oct 2021 21:40:09 +0100
Message-Id: <20211029204009.954315-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211029204009.954315-1-jeremy@azazel.net>
References: <20211029204009.954315-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The documentation describes the syntax of limit statements thus:

  limit rate [over] packet_number / TIME_UNIT [burst packet_number packets]
  limit rate [over] byte_number BYTE_UNIT / TIME_UNIT [burst byte_number BYTE_UNIT]

  TIME_UNIT := second | minute | hour | day
  BYTE_UNIT := bytes | kbytes | mbytes

From this one might infer that a limit may be specified by any of the
following:

  limit rate 1048576/second
  limit rate 1048576 mbytes/second

  limit rate 1048576 / second
  limit rate 1048576 mbytes / second

However, the last does not currently parse:

  $ sudo /usr/sbin/nft add filter input limit rate 1048576 mbytes / second
  Error: wrong rate format
  add filter input limit rate 1048576 mbytes / second
                   ^^^^^^^^^^^^^^^^^^^^^^^^^

Extend the `limit_rate_bytes` parser rule to support it, and add some
new Python test-cases.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/parser_bison.y           |  5 +++++
 tests/py/any/limit.t         |  5 +++++
 tests/py/any/limit.t.json    | 39 ++++++++++++++++++++++++++++++++++++
 tests/py/any/limit.t.payload | 13 ++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index cf1e139d42f3..65fd35a36cde 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3268,6 +3268,11 @@ limit_rate_bytes	:	NUM     STRING
 				$$.rate = rate * $1;
 				$$.unit = unit;
 			}
+			|	limit_bytes SLASH time_unit
+			{
+				$$.rate = $1;
+				$$.unit = $3;
+			}
 			;
 
 limit_bytes		:	NUM	BYTES		{ $$ = $1; }
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index 0110e77f2e85..86e8d43009b9 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -25,6 +25,11 @@ limit rate 10230 mbytes/second;ok
 limit rate 1023000 mbytes/second;ok
 limit rate 512 kbytes/second burst 5 packets;fail
 
+limit rate 1 bytes / second;ok;limit rate 1 bytes/second
+limit rate 1 kbytes / second;ok;limit rate 1 kbytes/second
+limit rate 1 mbytes / second;ok;limit rate 1 mbytes/second
+limit rate 1 gbytes / second;fail
+
 limit rate 1025 bytes/second burst 512 bytes;ok
 limit rate 1025 kbytes/second burst 1023 kbytes;ok
 limit rate 1025 mbytes/second burst 1025 kbytes;ok
diff --git a/tests/py/any/limit.t.json b/tests/py/any/limit.t.json
index 8bab7e3d79b4..b41ae60a3bd6 100644
--- a/tests/py/any/limit.t.json
+++ b/tests/py/any/limit.t.json
@@ -125,6 +125,45 @@
     }
 ]
 
+# limit rate 1 bytes / second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "bytes"
+        }
+    }
+]
+
+# limit rate 1 kbytes / second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "kbytes"
+        }
+    }
+]
+
+# limit rate 1 mbytes / second
+[
+    {
+        "limit": {
+            "burst": 5,
+            "burst_unit": "bytes",
+            "per": "second",
+            "rate": 1,
+            "rate_unit": "mbytes"
+        }
+    }
+]
+
 # limit rate 1025 bytes/second burst 512 bytes
 [
     {
diff --git a/tests/py/any/limit.t.payload b/tests/py/any/limit.t.payload
index dc6cea9b2846..3bd85f4ebf45 100644
--- a/tests/py/any/limit.t.payload
+++ b/tests/py/any/limit.t.payload
@@ -46,6 +46,19 @@ ip test-ip4 output
 ip test-ip4 output
   [ limit rate 1072693248000/second burst 5 type bytes flags 0x0 ]
 
+# limit rate 1 bytes / second
+ip
+  [ limit rate 1/second burst 5 type bytes flags 0x0 ]
+
+# limit rate 1 kbytes / second
+ip
+  [ limit rate 1024/second burst 5 type bytes flags 0x0 ]
+
+# limit rate 1 mbytes / second
+ip
+  [ limit rate 1048576/second burst 5 type bytes flags 0x0 ]
+
+
 # limit rate 1025 bytes/second burst 512 bytes
 ip test-ip4 output
   [ limit rate 1025/second burst 512 type bytes flags 0x0 ]
-- 
2.33.0

