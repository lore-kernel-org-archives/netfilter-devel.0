Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68883C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 392212084F
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 15:14:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="rw10XOtx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfCKPOd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:14:33 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50354 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727342AbfCKPOc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 11:14:32 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id E0C631A1639
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 08:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552317272; bh=oqVuEC9NaYxoiCdf5EBfKbDrHDBrUPURfdm6uZoexIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rw10XOtx1Ivtil95UnxHBhl3ew93MBa/VrYbv/kHY7oab7JiVBHt2c2734HJGMS+d
         XZVv84tEEt+edsxLaKFgrmtKV2ppKKdZxy9wt+n1PzD+7RqY/hT3SGoNa5wksJkTLz
         HUTVf1cLc49iLmqVF/ilTJmaoId1VATTFdbpq8Z0=
X-Riseup-User-ID: 924E4BADBB8DE823A0C4F2172C7CB0FF3DFCC74C7AED9B662CB0C271C1BD735C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 0EEAB221C5D;
        Mon, 11 Mar 2019 08:14:30 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2 3/6] tests: py: add osf tests with versions
Date:   Mon, 11 Mar 2019 16:14:14 +0100
Message-Id: <20190311151417.17772-3-ffmancera@riseup.net>
In-Reply-To: <20190311151417.17772-1-ffmancera@riseup.net>
References: <20190311151417.17772-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: flags type is now u32
---
 tests/py/inet/osf.t         |  4 +++
 tests/py/inet/osf.t.json    | 16 +++++++++
 tests/py/inet/osf.t.payload | 66 +++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/tests/py/inet/osf.t b/tests/py/inet/osf.t
index fd5d9ed..c8cac9b 100644
--- a/tests/py/inet/osf.t
+++ b/tests/py/inet/osf.t
@@ -7,8 +7,12 @@
 osf name "Linux";ok
 osf ttl loose name "Linux";ok
 osf ttl skip name "Linux";ok
+osf ttl skip name version "Linux:3.0";ok
+osf ttl skip name version "morethan:sixteenbytes";fail
 osf ttl nottl name "Linux";fail
 osf name "morethansixteenbytes";fail
 osf name ;fail
 osf name { "Windows", "MacOs" };ok
+osf name version { "Windows:XP", "MacOs:Sierra" };ok
 ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 };ok
+ct mark set osf name version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 };ok
diff --git a/tests/py/inet/osf.t.json b/tests/py/inet/osf.t.json
index 452f302..82a2638 100644
--- a/tests/py/inet/osf.t.json
+++ b/tests/py/inet/osf.t.json
@@ -45,6 +45,22 @@
     }
 ]
 
+# osf name version "Linux:3.0"
+[
+    {
+        "match": {
+            "left": {
+                "osf": {
+                    "key": "name",
+                    "flags": "version"
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
index 9b8f0bc..8f708f2 100644
--- a/tests/py/inet/osf.t.payload
+++ b/tests/py/inet/osf.t.payload
@@ -43,6 +43,21 @@ inet osfinet osfchain
   [ osf dreg 1 ]
   [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
 
+# osf ttl skip name version "Linux:3.0"
+ip osfip osfchain
+  [ osf dreg 1 ]
+  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
+
+# osf ttl skip name version "Linux:3.0"
+ip6 osfip6 osfchain
+  [ osf dreg 1 ]
+  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
+
+# osf ttl skip name version "Linux:3.0"
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
 
+# osf name version { "Windows:XP", "MacOs:Sierra" }
+__set%d osfip 3 size 2
+__set%d osfip 0
+	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
+ip osfip osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# osf name version { "Windows:XP", "MacOs:Sierra" }
+__set%d osfip6 3 size 2
+__set%d osfip6 0
+	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
+ip6 osfip6 osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# osf name version { "Windows:XP", "MacOs:Sierra" }
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
+# ct mark set osf name version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+__map%d osfip b size 2
+__map%d osfip 0
+	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
+ip osfip osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set osf name version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+__map%d osfip6 b size 2
+__map%d osfip6 0
+	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
+ip6 osfip6 osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set osf name version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+__map%d osfinet b size 2
+__map%d osfinet 0
+	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
+inet osfinet osfchain
+  [ osf dreg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ ct set mark with reg 1 ]
-- 
2.20.1

