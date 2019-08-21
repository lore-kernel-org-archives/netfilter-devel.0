Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF28C3A59B
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 10:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8F1422D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 10:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfHUKKo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 06:10:44 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:57597 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfHUKKo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 06:10:44 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8688941701;
        Wed, 21 Aug 2019 18:10:39 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v4] meta: add ibrpvid and ibrvproto support
Date:   Wed, 21 Aug 2019 18:10:38 +0800
Message-Id: <1566382238-5286-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJTEJCQkJCTEpIQ0JMTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PSo6HRw*LzgrTD46Ew4cKUIS
        GBBPCU5VSlVKTk1NSENJSUhCTUhIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhKTE03Bg++
X-HM-Tid: 0a6cb3a82f482086kuqy8688941701
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This allows you to match the bridge pvid and vlan protocol, for
instance:

nft add rule bridge firewall zones meta ibrvproto 0x8100
nft add rule bridge firewall zones meta ibrpvid 100

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 src/meta.c                     |  6 ++++++
 tests/py/bridge/meta.t         |  2 ++
 tests/py/bridge/meta.t.json    | 26 ++++++++++++++++++++++++++
 tests/py/bridge/meta.t.payload |  9 +++++++++
 4 files changed, 43 insertions(+)

diff --git a/src/meta.c b/src/meta.c
index 5901c99..d45d757 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -442,6 +442,12 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFPVID]	= META_TEMPLATE("ibrpvid",   &integer_type,
+						2 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFVPROTO] = META_TEMPLATE("ibrvproto",   &integer_type,
+						2 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/tests/py/bridge/meta.t b/tests/py/bridge/meta.t
index 88e819f..d9fb681 100644
--- a/tests/py/bridge/meta.t
+++ b/tests/py/bridge/meta.t
@@ -4,3 +4,5 @@
 
 meta obrname "br0";ok
 meta ibrname "br0";ok
+meta ibrvproto 33024;ok
+meta ibrpvid 100;ok
diff --git a/tests/py/bridge/meta.t.json b/tests/py/bridge/meta.t.json
index 5df4773..0a5e64a 100644
--- a/tests/py/bridge/meta.t.json
+++ b/tests/py/bridge/meta.t.json
@@ -23,3 +23,29 @@
         }
     }
 ]
+
+# meta ibrvproto 33024
+[
+    {
+        "match": {
+            "left": {
+                "meta": { "key": "ibrvproto" }
+            },
+	    "op": "==",
+            "right": 33024
+        }
+    }
+]
+
+# meta ibrpvid 100
+[
+    {
+        "match": {
+            "left": {
+                "meta": { "key": "ibrpvid" }
+            },
+	    "op": "==",
+            "right": 100
+        }
+    }
+]
diff --git a/tests/py/bridge/meta.t.payload b/tests/py/bridge/meta.t.payload
index 0f0d101..e5793a9 100644
--- a/tests/py/bridge/meta.t.payload
+++ b/tests/py/bridge/meta.t.payload
@@ -8,3 +8,12 @@ bridge test-bridge input
   [ meta load bri_iifname => reg 1 ]
   [ cmp eq reg 1 0x00307262 0x00000000 0x00000000 0x00000000 ]
 
+# meta ibrvproto 33024
+bridge test-bridge input
+  [ meta load bri_iifvproto => reg 1 ]
+  [ cmp eq reg 1 0x00008100 ]
+
+# meta ibrpvid 100
+bridge test-bridge input
+  [ meta load bri_iifpvid => reg 1 ]
+  [ cmp eq reg 1 0x00000064 ]
-- 
2.15.1

