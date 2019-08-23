Return-Path: <SRS0=Ar4o=WT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37466C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 13:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 183652339D
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Aug 2019 13:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405714AbfHWNpg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:45:36 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:16542 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731976AbfHWNpg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Aug 2019 09:45:36 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id B82E441432;
        Fri, 23 Aug 2019 21:45:28 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v5] meta: add ibrpvid and ibrvproto support
Date:   Fri, 23 Aug 2019 21:45:28 +0800
Message-Id: <1566567928-18121-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSEtCQkJCQk9JTExCTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KxQ6TTo*HDgyNT0xKRgyPA4X
        PhMwCkxVSlVKTk1NTk1MQklDQ0hMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhKQ003Bg++
X-HM-Tid: 0a6cbeb993bb2086kuqyb82e441432
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
+	[NFT_META_BRI_IIFVPROTO] = META_TEMPLATE("ibrvproto",   &ethertype_type,
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
+meta ibrvproto 0x8100;ok
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
+# meta ibrvproto 0x8100
+[
+    {
+        "match": {
+            "left": {
+                "meta": { "key": "ibrvproto" }
+            },
+	    "op": "==",
+            "right": "0x8100"
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
 
+# meta ibrvproto 0x8100
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

