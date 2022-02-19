Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D68D1C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiBSN3d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:29:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiBSN3d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:29:33 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B706E4E1
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=evWmwDDjD0ZeRsnjt1fwPPGrQSAuqBDNbXIvbdwE9gg=; b=QoDDQC5Qc6UDsbF2C2MI1ly47M
        LR7DJGFUpWbWE+8+cMENzEKMwWSOD2+MddSjGimUEOLxct5QGQoicKIroWIINi85+k9zZmDineHQY
        L9qv1Kkdg9J94ZEfjhN+v4gec8bjGkaKhIUgHV8/siP5KriyqRoa+80n/ZLwIwrvoFdzu8llPR2aL
        BEA0B0Nc+LsqNKcr6+QGdPw2ioiMUfQHahplwFmcVNIE3oXRM+o+zUs2L86iWFgSwKNeuw6VMeRsG
        pbzCDKvvCKt4qE4f1ED896FX1zF+VkdjmyqH5lMZgbL+wtKGJrBDq6AOasGDU3AGQrLAnkRVdIMAa
        ZJaS25KQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPnV-0002YB-Cb; Sat, 19 Feb 2022 14:29:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 01/26] tests: py: Test connlimit statement
Date:   Sat, 19 Feb 2022 14:27:49 +0100
Message-Id: <20220219132814.30823-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220219132814.30823-1-phil@nwl.cc>
References: <20220219132814.30823-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This wasn't covered at all.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/ct.t         |  3 +++
 tests/py/any/ct.t.json    | 19 +++++++++++++++++++
 tests/py/any/ct.t.payload |  8 ++++++++
 3 files changed, 30 insertions(+)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 8b8e68ab7361a..f73fa4e7aedbe 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -144,3 +144,6 @@ ct set invalid original 42;fail
 ct set invalid 42;fail
 
 notrack;ok
+
+ct count 3;ok
+ct count over 3;ok
diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index 6684963b6609c..a2a06025992c7 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -1502,3 +1502,22 @@
     }
 ]
 
+# ct count 3
+[
+    {
+        "ct count": {
+            "val": 3
+        }
+    }
+]
+
+# ct count over 3
+[
+    {
+        "ct count": {
+            "inv": true,
+            "val": 3
+        }
+    }
+]
+
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 733276e196f20..ed868e53277d9 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -508,3 +508,11 @@ ip6
   [ bitwise reg 1 = ( reg 1 & 0x00000020 ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000000 ]
 
+# ct count 3
+ip test-ip4 output
+  [ connlimit count 3 flags 0 ]
+
+# ct count over 3
+ip test-ip4 output
+  [ connlimit count 3 flags 1 ]
+
-- 
2.34.1

