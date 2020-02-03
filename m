Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23ACAC3524D
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5C120721
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="fYuuJBaM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgBCLU1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:20:27 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33256 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgBCLUZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 06:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1eZaUGvUJYxikXyhF/0Nn9US3t8y2qxpRWZ6w9MgNp4=; b=fYuuJBaMuFLgyZBQBPEb8Ry0q3
        EeNmubYb/OiFQlW/5D/0cXFXwcc4xpYdFAjKsJntiZyVx+EdUF3MWwJsqH2A1V3RQIHd3qSKT0IBk
        AfXUSwaZHg3cLCB6aIQbrWIwOD6PZUF/HvGzBW5YSWfxqxvMwG6kg9I8sPLeaGuxQRI7/fjEXOypu
        E6R4B4BCXV0L2DHhash/QydvKJH0rOo4NFysZiHjckVDqhQrWRk3a7RQtYE1wWl1s2t4IKJ14PCny
        HB34BN4U3Qol0vy+0MnRwuJlegYT5sMf8KLwcNv/4RuUlY4IdUQyRN6I18j98XMnZ+4PwhbUOVqfN
        QeoHhr7Q==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyZmC-0007Br-0S
        for netfilter-devel@vger.kernel.org; Mon, 03 Feb 2020 11:20:24 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v4 6/6] tests: py: add bit-shift tests.
Date:   Mon,  3 Feb 2020 11:20:23 +0000
Message-Id: <20200203112023.646840-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203112023.646840-1-jeremy@azazel.net>
References: <20200203112023.646840-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a couple of Python test-cases for setting the CT mark to a bitwise
expression derived from the packet mark and vice versa.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t            |  1 +
 tests/py/any/ct.t.json       | 28 ++++++++++++++++++++++++++++
 tests/py/any/ct.t.payload    | 21 +++++++++++++++++++++
 tests/py/inet/meta.t         |  1 +
 tests/py/inet/meta.t.json    | 22 ++++++++++++++++++++++
 tests/py/inet/meta.t.payload |  6 ++++++
 6 files changed, 79 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index ebc086445567..f65d275987cd 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -57,6 +57,7 @@ ct mark set 0x11333 and 0x11;ok;ct mark set 0x00000011
 ct mark set 0x12 or 0x11;ok;ct mark set 0x00000013
 ct mark set 0x11;ok;ct mark set 0x00000011
 ct mark set mark;ok;ct mark set meta mark
+ct mark set (meta mark | 0x10) << 8;ok;ct mark set (meta mark | 0x00000010) << 8
 ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set meta mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
 
 ct mark set {0x11333, 0x11};fail
diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index 8d56db2aaedb..59ac27c3055c 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -724,6 +724,34 @@
     }
 ]
 
+# ct mark set (meta mark | 0x10) << 8
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "<<": [
+                    {
+                        "|": [
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            },
+                            16
+                        ]
+                    },
+                    8
+                ]
+            }
+        }
+    }
+]
+
 # ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 }
 [
     {
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index bdc6a70e3672..661591257804 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -329,6 +329,27 @@ ip test-ip4 output
   [ meta load mark => reg 1 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set (meta mark | 0x10) << 8
+ip test-ip4 output
+  [ meta load mark => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xffffffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000008 ) ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set (meta mark | 0x10) << 8
+ip6 test-ip6 output
+  [ meta load mark => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xffffffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000008 ) ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set (meta mark | 0x10) << 8
+inet test-inet output
+  [ meta load mark => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xffffffef ) ^ 0x00000010 ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000008 ) ]
+  [ ct set mark with reg 1 ]
+
 # ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 }
 __map%d test-ip4 b
 __map%d test-ip4 0
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index df32332f0621..3638898b5dbb 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -16,3 +16,4 @@ meta ipsec exists;ok
 meta secpath missing;ok;meta ipsec missing
 meta ibrname "br0";fail
 meta obrname "br0";fail
+meta mark set ct mark >> 8;ok
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index 5501f0bec6ed..5c0e7d2e0e42 100644
--- a/tests/py/inet/meta.t.json
+++ b/tests/py/inet/meta.t.json
@@ -213,3 +213,25 @@
     }
 ]
 
+# meta mark set ct mark >> 8
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                ">>": [
+                    {
+                        "ct": {
+                            "key": "mark"
+                        }
+                    },
+                    8
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index d7ff7e2d41fa..6ccf6d24210a 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -73,3 +73,9 @@ inet test-inet input
 inet test-inet input
   [ meta load secpath => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
+
+# meta mark set ct mark >> 8
+inet test-inet input
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000008 ) ]
+  [ meta set mark with reg 1 ]
-- 
2.24.1

