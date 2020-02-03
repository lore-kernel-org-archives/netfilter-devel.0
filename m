Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BB2C3524F
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 909F92080D
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Kj4LFQbg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBCLUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:20:25 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33254 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbgBCLUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 06:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s1M7Tq3zuK7LKJxiGhvzc5i0R3g7YNRg5FeTNQ5oKq8=; b=Kj4LFQbg9FyPv6AoU0mM1WzReX
        32hB1E4qMockE7uSjjotbVw2Xw1HXaf2OsV5QubtvWz98FE7RfTCi4z1XDd7/cCr+uuEZbsvNaxMS
        1puMw4g7xmyNBlYu2GFzYQyjmDiF6zOkdPsd03SK8W/Uf25oI5ErdOu3XUTzcRcwCx7vQ4vfW+gug
        OrCKyRyXOeXxxBb3HgGBHBR/B28wQfoxSRI1wUlZ0SpBFt1q/lU7d8naovRvYVQir+jwlIu4508Uv
        EfVAaNiug2JDZTHkvSbABnY1iljqpsPWM21q85OweJ3JpGwUzYdkl/QopqFk6n7BbJwWGkFKVhpv9
        PbskOKew==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyZmB-0007Br-QU
        for netfilter-devel@vger.kernel.org; Mon, 03 Feb 2020 11:20:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v4 5/6] tests: py: add missing JSON output.
Date:   Mon,  3 Feb 2020 11:20:22 +0000
Message-Id: <20200203112023.646840-6-jeremy@azazel.net>
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

The JSON output was missing for some existing tests.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t.json   | 23 +++++++++++++++++++++++
 tests/py/ip/meta.t.json  | 35 +++++++++++++++++++++++++++++++++++
 tests/py/ip6/meta.t.json | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index 7c16f9df2195..8d56db2aaedb 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -499,6 +499,29 @@
     }
 ]
 
+# ct mark set ct mark or 0x00000001
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "ct": {
+                            "key": "mark"
+                        }
+                    },
+                    1
+                ]
+            }
+        }
+    }
+]
+
 # ct mark 0x00000032
 [
     {
diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
index f873aa88598b..f83864f672d5 100644
--- a/tests/py/ip/meta.t.json
+++ b/tests/py/ip/meta.t.json
@@ -105,3 +105,38 @@
     }
 ]
 
+# meta sdif "lo" accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "sdif"
+                }
+            },
+            "op": "==",
+            "right": "lo"
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
+# meta sdifname != "vrf1" accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "sdifname"
+                }
+            },
+            "op": "!=",
+            "right": "vrf1"
+        }
+    },
+    {
+        "accept": null
+    }
+]
diff --git a/tests/py/ip6/meta.t.json b/tests/py/ip6/meta.t.json
index 29cf9fd2d0cf..e72350f375e9 100644
--- a/tests/py/ip6/meta.t.json
+++ b/tests/py/ip6/meta.t.json
@@ -105,3 +105,38 @@
     }
 ]
 
+# meta sdif "lo" accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "sdif"
+                }
+            },
+            "op": "==",
+            "right": "lo"
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
+# meta sdifname != "vrf1" accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "sdifname"
+                }
+            },
+            "op": "!=",
+            "right": "vrf1"
+        }
+    },
+    {
+        "accept": null
+    }
+]
-- 
2.24.1

