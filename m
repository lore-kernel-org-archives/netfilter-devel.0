Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245A6C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 161E42147C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 10:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="baJn99yK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732995AbfC0KiE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 06:38:04 -0400
Received: from mx1.riseup.net ([198.252.153.129]:55522 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfC0KiE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 06:38:04 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 9EEFA1A64FF
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Mar 2019 03:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1553683083; bh=/Yo7n35opzz2tW+oXv1aXXzLmA93bksSoZSGmm27u5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baJn99yKqzVWLY3ofq+KyGfB+Be0rK3UOgTjO0zDfZNP2O70HBMkwhtJ3vSqJ6i4U
         9MuejZ+sUaNA9sa8O/6kgfrFI1S4teXiXlCRTFRKc2m+XaM7rOumapsKswXO3LUYCV
         SEpk2YGabCk1uycO/2uXB+u4J4JHKkwovY8pGJZE=
X-Riseup-User-ID: 027A305015ACAE1A095CE8A7C82A107E28E0B5E7AEA07C8BEE7B458CBF0B8494
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id CB3B91205E8;
        Wed, 27 Mar 2019 03:38:02 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 3/6 nft v3] tests: py: add osf tests with versions
Date:   Wed, 27 Mar 2019 11:37:58 +0100
Message-Id: <20190327103801.2049-3-ffmancera@riseup.net>
In-Reply-To: <20190327103801.2049-1-ffmancera@riseup.net>
References: <20190327103801.2049-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 tests/py/inet/osf.t         |  4 +++
 tests/py/inet/osf.t.json    | 15 +++++++++
 tests/py/inet/osf.t.payload | 66 +++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/tests/py/inet/osf.t b/tests/py/inet/osf.t
index fd5d9ed..c828541 100644
--- a/tests/py/inet/osf.t
+++ b/tests/py/inet/osf.t
@@ -7,8 +7,12 @@
 osf name "Linux";ok
 osf ttl loose name "Linux";ok
 osf ttl skip name "Linux";ok
+osf ttl skip version "Linux:3.0";ok
+osf ttl skip version "morethan:sixteenbytes";fail
 osf ttl nottl name "Linux";fail
 osf name "morethansixteenbytes";fail
 osf name ;fail
 osf name { "Windows", "MacOs" };ok
+osf version { "Windows:XP", "MacOs:Sierra" };ok
 ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 };ok
+ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 };ok
diff --git a/tests/py/inet/osf.t.json b/tests/py/inet/osf.t.json
index 452f302..a2e7449 100644
--- a/tests/py/inet/osf.t.json
+++ b/tests/py/inet/osf.t.json
@@ -45,6 +45,21 @@
     }
 ]
 
+# osf name version "Linux:3.0"
+[
+    {
+        "match": {
+            "left": {
+                "osf": {
+                    "key": "version"
+                }
+            },
+            "op": "==",
+            "right": "Linux:3.0"
+        }
+    }
+]
+
 # osf name { "Windows", "MacOs" }
 [
     {
diff --git a/tests/py/inet/osf.t.payload b/tests/py/inet/osf.t.payload
index 9b8f0bc..6f5fba3 100644
--- a/tests/py/inet/osf.t.payload
+++ b/tests/py/inet/osf.t.payload
@@ -43,6 +43,21 @@ inet osfinet osfchain
   [ osf dreg 1 ]
   [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
 
+# osf ttl skip version "Linux:3.0"
+ip osfip osfchain
+  [ osf dreg 1 ]
+  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
+
+# osf ttl skip version "Linux:3.0"
+ip6 osfip6 osfchain
+  [ osf dreg 1 ]
+  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
+
+# osf ttl skip version "Linux:3.0"
+inet osfinet osfchain
+  [ osf dreg 1 ]
+  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
+
 # osf name { "Windows", "MacOs" }
 __set%d osfip 3 size 2
 __set%d osfip 0
@@ -67,6 +82,30 @@ inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __set%d ]
 
+# osf version { "Windows:XP", "MacOs:Sierra" }
+__set%d osfip 3 size 2
+__set%d osfip 0
+	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
+ip osfip osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# osf version { "Windows:XP", "MacOs:Sierra" }
+__set%d osfip6 3 size 2
+__set%d osfip6 0
+	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
+ip6 osfip6 osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# osf version { "Windows:XP", "MacOs:Sierra" }
+__set%d osfinet 3 size 2
+__set%d osfinet 0
+	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
+inet osfinet osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __set%d ]
+
 # ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
 __map%d osfip b size 2
 __map%d osfip 0
@@ -93,3 +132,30 @@ inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+__map%d osfip b size 2
+__map%d osfip 0
+	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
+ip osfip osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+__map%d osfip6 b size 2
+__map%d osfip6 0
+	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
+ip6 osfip6 osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+__map%d osfinet b size 2
+__map%d osfinet 0
+	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
+inet osfinet osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set mark with reg 1 ]
-- 
2.20.1

