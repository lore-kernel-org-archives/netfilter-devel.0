Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3DAC56201
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BBB2076E
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgKJMdv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 07:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728478AbgKJMdt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:33:49 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D3BC0613CF
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:33:48 -0800 (PST)
Received: from localhost ([::1]:37784 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kcSqH-0005mZ-2G; Tue, 10 Nov 2020 13:33:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] proto: Fix ARP header field ordering
Date:   Tue, 10 Nov 2020 13:33:36 +0100
Message-Id: <20201110123336.29599-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In ARP header, destination ether address sits between source IP and
destination IP addresses. Enum arp_hdr_fields had this wrong, which
in turn caused wrong ordering of entries in proto_arp->templates. When
expanding a combined payload expression, code assumes that template
entries are ordered by header offset, therefore the destination ether
address match was printed as raw if an earlier field was matched as
well:

| arp saddr ip 192.168.1.1 arp daddr ether 3e:d1:3f:d6:12:0b

was printed as:

| arp saddr ip 192.168.1.1 @nh,144,48 69068440080907

Note: Although strictly not necessary, reorder fields in
proto_arp->templates as well to match their actual ordering, just to
avoid confusion.

Fixes: 4b0f2a712b579 ("src: support for arp sender and target ethernet and IPv4 addresses")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/proto.h                   |  2 +-
 src/proto.c                       |  2 +-
 tests/py/arp/arp.t                |  3 ++
 tests/py/arp/arp.t.json           | 56 +++++++++++++++++++++++++++++++
 tests/py/arp/arp.t.json.output    | 28 ++++++++++++++++
 tests/py/arp/arp.t.payload        | 10 ++++++
 tests/py/arp/arp.t.payload.netdev | 14 ++++++++
 7 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/include/proto.h b/include/proto.h
index b78bb9bc2a712..6ef332c3966f0 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -222,8 +222,8 @@ enum arp_hdr_fields {
 	ARPHDR_PLN,
 	ARPHDR_OP,
 	ARPHDR_SADDR_ETHER,
-	ARPHDR_DADDR_ETHER,
 	ARPHDR_SADDR_IP,
+	ARPHDR_DADDR_ETHER,
 	ARPHDR_DADDR_IP,
 };
 
diff --git a/src/proto.c b/src/proto.c
index 725b03851e980..c42e8f517bae6 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -980,8 +980,8 @@ const struct proto_desc proto_arp = {
 		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", plen),
 		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, oper),
 		[ARPHDR_SADDR_ETHER]	= ARPHDR_TYPE("saddr ether", &etheraddr_type, sha),
-		[ARPHDR_DADDR_ETHER]	= ARPHDR_TYPE("daddr ether", &etheraddr_type, tha),
 		[ARPHDR_SADDR_IP]	= ARPHDR_TYPE("saddr ip", &ipaddr_type, spa),
+		[ARPHDR_DADDR_ETHER]	= ARPHDR_TYPE("daddr ether", &etheraddr_type, tha),
 		[ARPHDR_DADDR_IP]	= ARPHDR_TYPE("daddr ip", &ipaddr_type, tpa),
 	},
 	.format		= {
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 2540c0a774191..109d01d7ad506 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -61,4 +61,7 @@ arp daddr ip 4.3.2.1;ok
 arp saddr ether aa:bb:cc:aa:bb:cc;ok
 arp daddr ether aa:bb:cc:aa:bb:cc;ok
 
+arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee;ok
+arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1;ok;arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee
+
 meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566;ok;iifname "invalid" arp htype 1 arp ptype ip arp hlen 6 arp plen 4 arp daddr ip 192.168.143.16 arp daddr ether set 11:22:33:44:55:66
diff --git a/tests/py/arp/arp.t.json b/tests/py/arp/arp.t.json
index 5f2f6cd85b5e6..8508c1703475b 100644
--- a/tests/py/arp/arp.t.json
+++ b/tests/py/arp/arp.t.json
@@ -901,6 +901,62 @@
     }
 ]
 
+# arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr ip",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "192.168.1.1"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr ether",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "fe:ed:00:c0:ff:ee"
+        }
+    }
+]
+
+# arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr ether",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "fe:ed:00:c0:ff:ee"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr ip",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "192.168.1.1"
+        }
+    }
+]
+
 # meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566
 [
     {
diff --git a/tests/py/arp/arp.t.json.output b/tests/py/arp/arp.t.json.output
index b8507bffc8cc4..afa75b2e8a0d7 100644
--- a/tests/py/arp/arp.t.json.output
+++ b/tests/py/arp/arp.t.json.output
@@ -66,6 +66,34 @@
     }
 ]
 
+# arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr ip",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "192.168.1.1"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr ether",
+                    "protocol": "arp"
+                }
+            },
+            "op": "==",
+            "right": "fe:ed:00:c0:ff:ee"
+        }
+    }
+]
+
 # meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566
 [
     {
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index 52c993294810f..f819853f448ed 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -307,3 +307,13 @@ arp test-arp input
   [ payload load 6b @ network header + 18 => reg 1 ]
   [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
 
+# arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee
+arp 
+  [ payload load 10b @ network header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
+
+# arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1
+arp 
+  [ payload load 10b @ network header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
+
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index 667691fff2f65..f57610cf92f71 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -409,3 +409,17 @@ netdev test-netdev ingress
   [ payload load 6b @ network header + 18 => reg 1 ]
   [ cmp eq reg 1 0xaaccbbaa 0x0000ccbb ]
 
+# arp saddr ip 192.168.1.1 arp daddr ether fe:ed:00:c0:ff:ee
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 10b @ network header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
+
+# arp daddr ether fe:ed:00:c0:ff:ee arp saddr ip 192.168.1.1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000608 ]
+  [ payload load 10b @ network header + 14 => reg 1 ]
+  [ cmp eq reg 1 0x0101a8c0 0xc000edfe 0x0000eeff ]
+
-- 
2.28.0

