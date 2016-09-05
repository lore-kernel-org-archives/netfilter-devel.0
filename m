From: Manuel Johannes Messner <manuel.johannes.messner@hs-furtwangen.de>
Subject: [PATCH 3/3] tests: py: any: Remove duplicate tests
Date: Mon,  5 Sep 2016 20:20:14 +0200
Message-ID: <20160905182014.8762-4-manuel.johannes.messner@hs-furtwangen.de>
References: <20160905182014.8762-1-manuel.johannes.messner@hs-furtwangen.de>
Cc: fw@strlen.de, messnera@hs-furtwangen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx.rz.hs-furtwangen.de ([141.28.2.11]:39109 "HELO
        mx.rz.hs-furtwangen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754731AbcIES1d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 14:27:33 -0400
In-Reply-To: <20160905182014.8762-1-manuel.johannes.messner@hs-furtwangen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit removes some duplicated tests.

Signed-off-by: Manuel Johannes Messner <manuel.johannes.messner@hs-furtwangen.de>
---
 tests/py/any/meta.t         |  3 ---
 tests/py/any/meta.t.payload | 12 ------------
 2 files changed, 15 deletions(-)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 852ef82..a1249e8 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -66,8 +66,6 @@ meta mark xor 0x03 == 0x01;ok;mark 0x00000002
 meta mark xor 0x03 != 0x01;ok;mark != 0x00000002
 
 meta iif "lo" accept;ok;iif "lo" accept
-meta iif "lo" accept;ok;iif "lo" accept
-meta iif != "lo" accept;ok;iif != "lo" accept
 meta iif != "lo" accept;ok;iif != "lo" accept
 
 meta iifname "dummy0";ok;iifname "dummy0"
@@ -92,7 +90,6 @@ meta oif {"lo"} accept;ok
 meta oifname "dummy0";ok;oifname "dummy0"
 meta oifname != "dummy0";ok;oifname != "dummy0"
 meta oifname { "dummy0", "lo"};ok
-- meta iifname != {"dummy0", "lo"};ok
 meta oifname "dummy*";ok;oifname "dummy*"
 meta oifname "dummy\*";ok;oifname "dummy\*"
 
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 19cc6ac..5fff76e 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -199,18 +199,6 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
-# meta iif "lo" accept
-ip test-ip4 input
-  [ meta load iif => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ immediate reg 0 accept ]
-
-# meta iif != "lo" accept
-ip test-ip4 input
-  [ meta load iif => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
-  [ immediate reg 0 accept ]
-
 # meta iif != "lo" accept
 ip test-ip4 input
   [ meta load iif => reg 1 ]
-- 
2.9.3

