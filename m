Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FABC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82EDA64E41
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhBCWrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 17:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhBCWrB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 17:47:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9490C0613D6
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 14:46:20 -0800 (PST)
Received: from localhost ([::1]:39974 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l7Quh-0003gi-AR; Wed, 03 Feb 2021 23:46:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] tests/py: Add a test sanitizer and fix its findings
Date:   Wed,  3 Feb 2021 23:46:05 +0100
Message-Id: <20210203224605.8140-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210203224605.8140-1-phil@nwl.cc>
References: <20210203224605.8140-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is just basic housekeeping:

- Remove duplicate tests in any of the *.t files
- Remove explicit output if equal to command itself in *.t files
- Remove duplicate payload records in any of the *.t.payload* files
- Remove stale payload records (for which no commands exist in the
  respective *.t file
- Remove duplicate/stale entries in any of the *.t.json files

In some cases, tests were added instead of removing a stale payload
record if it fit nicely into the sequence of tests.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/ct.t                    |   1 +
 tests/py/any/ct.t.json               |  56 +++----
 tests/py/any/ct.t.payload            |   9 --
 tests/py/any/meta.t                  |  34 ++--
 tests/py/any/meta.t.payload          |  44 ------
 tests/py/any/tcpopt.t                |   1 -
 tests/py/arp/arp.t                   |   2 -
 tests/py/arp/arp.t.json              |  32 ----
 tests/py/arp/arp.t.payload           |  10 --
 tests/py/arp/arp.t.payload.netdev    |  14 --
 tests/py/inet/ah.t                   |   2 -
 tests/py/inet/dccp.t.json            |  18 ---
 tests/py/inet/dccp.t.payload         |   8 -
 tests/py/inet/esp.t                  |   1 +
 tests/py/inet/esp.t.json             |  20 +++
 tests/py/inet/ether.t.payload.bridge |  21 ---
 tests/py/inet/ether.t.payload.ip     |  23 ---
 tests/py/inet/reject.t.payload.inet  | 104 ------------
 tests/py/inet/rt.t                   |   5 +-
 tests/py/inet/sets.t.payload.netdev  |   2 +-
 tests/py/inet/synproxy.t.json        |  32 ----
 tests/py/ip/icmp.t.payload.ip        |  11 --
 tests/py/ip/igmp.t.payload           | 228 ---------------------------
 tests/py/ip/ip.t                     |   4 +-
 tests/py/ip/ip.t.payload             |  10 --
 tests/py/ip/ip.t.payload.inet        |  12 --
 tests/py/ip/ip.t.payload.netdev      | 112 -------------
 tests/py/ip6/dnat.t                  |   2 +-
 tests/py/ip6/ether.t                 |   2 +-
 tests/py/ip6/frag.t.payload.inet     |   8 -
 tests/py/ip6/frag.t.payload.ip6      |   6 -
 tests/py/ip6/icmpv6.t                |   2 +-
 tests/py/ip6/icmpv6.t.json           |  11 +-
 tests/py/ip6/icmpv6.t.payload.ip6    |   7 +-
 tests/py/ip6/ip6.t                   |   2 +-
 tests/py/ip6/ip6.t.payload.inet      |   2 +-
 tests/py/ip6/ip6.t.payload.ip6       |   2 +-
 tests/py/ip6/snat.t                  |   2 +-
 tests/py/tools/test-sanitizer.sh     |  78 +++++++++
 39 files changed, 160 insertions(+), 780 deletions(-)
 create mode 100755 tests/py/tools/test-sanitizer.sh

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index cc09aebcbc448..0ec027f55c237 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -26,6 +26,7 @@ ct status != expected;ok
 ct status seen-reply;ok
 ct status != seen-reply;ok
 ct status {expected, seen-reply, assured, confirmed, dying};ok
+ct status != {expected, seen-reply, assured, confirmed, dying};ok
 ct status expected,seen-reply,assured,confirmed,snat,dnat,dying;ok
 ct status snat;ok
 ct status dnat;ok
diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index c5c15b9c8b944..d429ae73ea5cc 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -311,6 +311,29 @@
     }
 ]
 
+# ct status != {expected, seen-reply, assured, confirmed, dying}
+[
+    {
+        "match": {
+            "left": {
+                "ct": {
+                    "key": "status"
+                }
+            },
+	    "op": "!=",
+            "right": {
+                "set": [
+                    "expected",
+                    "seen-reply",
+                    "assured",
+                    "confirmed",
+                    "dying"
+                ]
+            }
+        }
+    }
+]
+
 # ct status expected,seen-reply,assured,confirmed,snat,dnat,dying
 [
     {
@@ -989,39 +1012,6 @@
     }
 ]
 
-# ct state . ct mark { new . 0x12345678}
-[
-    {
-        "match": {
-            "left": {
-                "concat": [
-                    {
-                        "ct": {
-                            "key": "state"
-                        }
-                    },
-                    {
-                        "ct": {
-                            "key": "mark"
-                        }
-                    }
-                ]
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "concat": [
-                            "new",
-                            "0x12345678"
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634}
 [
     {
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 51a8250349015..9223201f576d0 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -306,15 +306,6 @@ ip test-ip4 output
   [ ct load helper => reg 1 ]
   [ cmp eq reg 1 0x00707466 0x00000000 0x00000000 0x00000000 ]
 
-# ct state . ct mark { new . 0x12345678}
-__set%d test 3
-__set%d test 0
-	element 00000008 12345678  : 0 [end]
-ip test-ip4 output
-  [ ct load state => reg 1 ]
-  [ ct load mark => reg 9 ]
-  [ lookup reg 1 set __set%d ]
-
 # ct state . ct mark { new . 0x12345678, new . 0x34127856, established . 0x12785634}
 __set%d test-ip4 3
 __set%d test-ip4 0
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 327f973f1bd5a..7b5825051c8af 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -29,7 +29,7 @@ meta l4proto 22;ok
 meta l4proto != 233;ok
 meta l4proto 33-45;ok
 meta l4proto != 33-45;ok
-meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
+meta l4proto { 33, 55, 67, 88};ok
 meta l4proto != { 33, 55, 67, 88};ok
 meta l4proto { 33-55, 66-88};ok
 meta l4proto != { 33-55, 66-88};ok
@@ -101,10 +101,10 @@ meta skuid != "root";ok;meta skuid != 0
 meta skuid lt 3000 accept;ok;meta skuid < 3000 accept
 meta skuid gt 3000 accept;ok;meta skuid > 3000 accept
 meta skuid eq 3000 accept;ok;meta skuid 3000 accept
-meta skuid 3001-3005 accept;ok;meta skuid 3001-3005 accept
-meta skuid != 2001-2005 accept;ok;meta skuid != 2001-2005 accept
-meta skuid { 2001-2005, 3001-3005} accept;ok;meta skuid { 2001-2005, 3001-3005} accept
-meta skuid != { 2001-2005, 3001-3005} accept;ok;meta skuid != { 2001-2005, 3001-3005} accept
+meta skuid 3001-3005 accept;ok
+meta skuid != 2001-2005 accept;ok
+meta skuid { 2001-2005, 3001-3005} accept;ok
+meta skuid != { 2001-2005, 3001-3005} accept;ok
 
 meta skgid {"bin", "root", "daemon"} accept;ok;meta skgid { 0, 1, 2} accept
 meta skgid != {"bin", "root", "daemon"} accept;ok;meta skgid != { 1, 0, 2} accept
@@ -113,10 +113,10 @@ meta skgid != "root";ok;meta skgid != 0
 meta skgid lt 3000 accept;ok;meta skgid < 3000 accept
 meta skgid gt 3000 accept;ok;meta skgid > 3000 accept
 meta skgid eq 3000 accept;ok;meta skgid 3000 accept
-meta skgid 2001-2005 accept;ok;meta skgid 2001-2005 accept
-meta skgid != 2001-2005 accept;ok;meta skgid != 2001-2005 accept
-meta skgid { 2001-2005} accept;ok;meta skgid { 2001-2005} accept
-meta skgid != { 2001-2005} accept;ok;meta skgid != { 2001-2005} accept
+meta skgid 2001-2005 accept;ok
+meta skgid != 2001-2005 accept;ok
+meta skgid { 2001-2005} accept;ok
+meta skgid != { 2001-2005} accept;ok
 
 # BUG: meta nftrace 2 and meta nftrace 1
 # $ sudo nft add rule ip test input meta nftrace 2
@@ -188,14 +188,14 @@ meta oifgroup {11-33, 44-55};ok;oifgroup {11-33, 44-55}
 meta oifgroup != { 11,33};ok;oifgroup != { 11,33}
 meta oifgroup != {11-33, 44-55};ok;oifgroup != {11-33, 44-55}
 
-meta cgroup 1048577;ok;meta cgroup 1048577
-meta cgroup != 1048577;ok;meta cgroup != 1048577
-meta cgroup { 1048577, 1048578 };ok;meta cgroup { 1048577, 1048578}
-meta cgroup != { 1048577, 1048578};ok;meta cgroup != { 1048577, 1048578}
-meta cgroup 1048577-1048578;ok;meta cgroup 1048577-1048578
-meta cgroup != 1048577-1048578;ok;meta cgroup != 1048577-1048578
-meta cgroup {1048577-1048578};ok;meta cgroup { 1048577-1048578}
-meta cgroup != { 1048577-1048578};ok;meta cgroup != { 1048577-1048578}
+meta cgroup 1048577;ok
+meta cgroup != 1048577;ok
+meta cgroup { 1048577, 1048578 };ok
+meta cgroup != { 1048577, 1048578};ok
+meta cgroup 1048577-1048578;ok
+meta cgroup != 1048577-1048578;ok
+meta cgroup {1048577-1048578};ok
+meta cgroup != { 1048577-1048578};ok
 
 meta iif . meta oif { "lo" . "lo" };ok;iif . oif { "lo" . "lo" }
 meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a };ok;iif . oif . meta mark { "lo" . "lo" . 0x0000000a }
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 463365e203ad8..c366452514389 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -631,22 +631,6 @@ ip test-ip4 input
   [ meta load iifgroup => reg 1 ]
   [ cmp neq reg 1 0x00000000 ]
 
-# meta iifgroup {"default"}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]
-ip test-ip4 input
-  [ meta load iifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# meta iifgroup != {"default"}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]
-ip test-ip4 input
-  [ meta load iifgroup => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta iifgroup { 11,33}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -977,34 +961,6 @@ ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# meta iif . meta oif { "lo" . "lo" , "dummy0" . "dummy0" }
-__set%d test-ip4 3 size 2
-__set%d test-ip4 0
-	element 00000001 00000001  : 0 [end]	element 00000005 00000005  : 0 [end]
-ip test-ip4 input 
-  [ meta load iif => reg 1 ]
-  [ meta load oif => reg 9 ]
-  [ lookup reg 1 set __set%d ]
-
-# meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a, "dummy0" . "dummy0" . 0x0000000b }
-__set%d test-ip4 3 size 2
-__set%d test-ip4 0
-	element 00000001 00000001 0000000a  : 0 [end]	element 00000005 00000005 0000000b  : 0 [end]
-ip test-ip4 input 
-  [ meta load iif => reg 1 ]
-  [ meta load oif => reg 9 ]
-  [ meta load mark => reg 10 ]
-  [ lookup reg 1 set __set%d ]
-
-# meta iif . meta oif vmap { "lo" . "lo" : drop, "dummy0" . "dummy0" : accept }
-__map%d test-ip4 b size 2
-__map%d test-ip4 0
-	element 00000001 00000001  : 0 [end]	element 00000005 00000005  : 0 [end]
-ip test-ip4 input 
-  [ meta load iif => reg 1 ]
-  [ meta load oif => reg 9 ]
-  [ lookup reg 1 set __map%d dreg 0 ]
-
 # meta skgid { 2001-2005} accept
 __set%d test-ip4 7 size 3
 __set%d test-ip4 0
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index e759ac6132d91..f17a20b594926 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -37,7 +37,6 @@ tcp option foobar;fail
 tcp option foo bar;fail
 tcp option eol left;fail
 tcp option eol left 1;fail
-tcp option eol left 1;fail
 tcp option sack window;fail
 tcp option sack window 1;fail
 tcp option 256 exists;fail
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 109d01d7ad506..2eee78381599c 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -46,7 +46,6 @@ arp operation rreply;ok
 arp operation inrequest;ok
 arp operation inreply;ok
 arp operation nak;ok
-arp operation reply;ok
 arp operation != request;ok
 arp operation != reply;ok
 arp operation != rrequest;ok
@@ -54,7 +53,6 @@ arp operation != rreply;ok
 arp operation != inrequest;ok
 arp operation != inreply;ok
 arp operation != nak;ok
-arp operation != reply;ok
 
 arp saddr ip 1.2.3.4;ok
 arp daddr ip 4.3.2.1;ok
diff --git a/tests/py/arp/arp.t.json b/tests/py/arp/arp.t.json
index 8508c1703475b..73224f7e185ec 100644
--- a/tests/py/arp/arp.t.json
+++ b/tests/py/arp/arp.t.json
@@ -693,22 +693,6 @@
     }
 ]
 
-# arp operation reply
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "operation",
-                    "protocol": "arp"
-                }
-            },
-	    "op": "==",
-            "right": "reply"
-        }
-    }
-]
-
 # arp operation != request
 [
     {
@@ -821,22 +805,6 @@
     }
 ]
 
-# arp operation != reply
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "operation",
-                    "protocol": "arp"
-                }
-            },
-            "op": "!=",
-            "right": "reply"
-        }
-    }
-]
-
 # arp saddr ip 1.2.3.4
 [
     {
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index f819853f448ed..a95c834eff5a2 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -229,11 +229,6 @@ arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000a00 ]
 
-# arp operation reply
-arp test-arp input
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
-
 # arp operation != request
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
@@ -269,11 +264,6 @@ arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x00000a00 ]
 
-# arp operation != reply
-arp test-arp input
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000200 ]
-
 # meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566
 arp test-arp input
   [ meta load iifname => reg 1 ]
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index f57610cf92f71..ac985a9a794e4 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -303,13 +303,6 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp eq reg 1 0x00000a00 ]
 
-# arp operation reply
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x00000200 ]
-
 # arp operation != request
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -359,13 +352,6 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x00000a00 ]
 
-# arp operation != reply
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp neq reg 1 0x00000200 ]
-
 # meta iifname "invalid" arp ptype 0x0800 arp htype 1 arp hlen 6 arp plen 4 @nh,192,32 0xc0a88f10 @nh,144,48 set 0x112233445566
 netdev test-netdev ingress
   [ meta load iifname => reg 1 ]
diff --git a/tests/py/inet/ah.t b/tests/py/inet/ah.t
index 8544d9dd3f47d..945db99621ffe 100644
--- a/tests/py/inet/ah.t
+++ b/tests/py/inet/ah.t
@@ -6,8 +6,6 @@
 *inet;test-inet;input
 *netdev;test-netdev;ingress
 
-# nexthdr Bug to list table.
-
 - ah nexthdr esp;ok
 - ah nexthdr ah;ok
 - ah nexthdr comp;ok
diff --git a/tests/py/inet/dccp.t.json b/tests/py/inet/dccp.t.json
index 9260fbc5ee00f..97e33c141035d 100644
--- a/tests/py/inet/dccp.t.json
+++ b/tests/py/inet/dccp.t.json
@@ -98,24 +98,6 @@
     }
 ]
 
-# dccp sport ftp-data - re-mail-ck
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "dccp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "range": [ "ftp-data", "re-mail-ck" ]
-            }
-        }
-    }
-]
-
 # dccp sport 20-50
 [
     {
diff --git a/tests/py/inet/dccp.t.payload b/tests/py/inet/dccp.t.payload
index b830aa4f3e648..b252d8294468c 100644
--- a/tests/py/inet/dccp.t.payload
+++ b/tests/py/inet/dccp.t.payload
@@ -43,14 +43,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# dccp sport ftp-data - re-mail-ck
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
-
 # dccp sport 20-50
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/esp.t b/tests/py/inet/esp.t
index e79eeada71849..ebba7d87395e5 100644
--- a/tests/py/inet/esp.t
+++ b/tests/py/inet/esp.t
@@ -13,6 +13,7 @@ esp spi != 111-222;ok
 esp spi { 100, 102};ok
 esp spi != { 100, 102};ok
 esp spi { 100-102};ok
+esp spi != { 100-102};ok
 - esp spi {100-102};ok
 
 esp sequence 22;ok
diff --git a/tests/py/inet/esp.t.json b/tests/py/inet/esp.t.json
index 84ea9eeaf2fdf..ee690f96a2d4e 100644
--- a/tests/py/inet/esp.t.json
+++ b/tests/py/inet/esp.t.json
@@ -128,6 +128,26 @@
     }
 ]
 
+# esp spi != { 100-102}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "spi",
+                    "protocol": "esp"
+                }
+            },
+	    "op": "!=",
+            "right": {
+                "set": [
+                    { "range": [ 100, 102 ] }
+                ]
+            }
+        }
+    }
+]
+
 # esp sequence 22
 [
     {
diff --git a/tests/py/inet/ether.t.payload.bridge b/tests/py/inet/ether.t.payload.bridge
index 4a6bccbe2553c..e9208008214a3 100644
--- a/tests/py/inet/ether.t.payload.bridge
+++ b/tests/py/inet/ether.t.payload.bridge
@@ -1,17 +1,3 @@
-# tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept
-bridge test-bridge input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ immediate reg 0 accept ]
-
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 bridge test-bridge input
   [ meta load l4proto => reg 1 ]
@@ -40,10 +26,3 @@ bridge test-bridge input
   [ cmp eq reg 1 0x0c540f00 0x00000411 ]
   [ immediate reg 0 accept ]
 
-# ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4
-bridge test-bridge input
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-
diff --git a/tests/py/inet/ether.t.payload.ip b/tests/py/inet/ether.t.payload.ip
index 196930fd8ff52..a604f603c69eb 100644
--- a/tests/py/inet/ether.t.payload.ip
+++ b/tests/py/inet/ether.t.payload.ip
@@ -1,17 +1,3 @@
-# tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 meta nfproto ipv4 accept
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ immediate reg 0 accept ]
-
 # tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
@@ -44,12 +30,3 @@ ip test-ip4 input
   [ cmp eq reg 1 0x0c540f00 0x00000411 ]
   [ immediate reg 0 accept ]
 
-# ether saddr 00:0f:54:0c:11:04 meta nfproto ipv4
-ip test-ip4 input
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-
diff --git a/tests/py/inet/reject.t.payload.inet b/tests/py/inet/reject.t.payload.inet
index ee1aae02f1e1d..3f2202824b8ca 100644
--- a/tests/py/inet/reject.t.payload.inet
+++ b/tests/py/inet/reject.t.payload.inet
@@ -116,110 +116,6 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ reject type 0 code 0 ]
 
-# reject with icmp type prot-unreachable
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ reject type 0 code 2 ]
-
-# reject with icmp type port-unreachable
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ reject type 0 code 3 ]
-
-# reject with icmp type net-prohibited
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ reject type 0 code 9 ]
-
-# reject with icmp type host-prohibited
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ reject type 0 code 10 ]
-
-# reject with icmp type admin-prohibited
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ reject type 0 code 13 ]
-
-# reject with icmpv6 type no-route
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ reject type 0 code 0 ]
-
-# reject with icmpv6 type admin-prohibited
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ reject type 0 code 1 ]
-
-# reject with icmpv6 type addr-unreachable
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ reject type 0 code 3 ]
-
-# reject with icmpv6 type port-unreachable
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ reject type 0 code 4 ]
-
-# reject with tcp reset
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ reject type 1 code 0 ]
-
-# reject
-inet test-inet input
-  [ reject type 2 code 1 ]
-
-# meta nfproto ipv4 reject
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ reject type 0 code 3 ]
-
-# meta nfproto ipv6 reject
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ reject type 0 code 4 ]
-
-# reject with icmpx type host-unreachable
-inet test-inet input
-  [ reject type 2 code 2 ]
-
-# reject with icmpx type no-route
-inet test-inet input
-  [ reject type 2 code 0 ]
-
-# reject with icmpx type admin-prohibited
-inet test-inet input
-  [ reject type 2 code 3 ]
-
-# reject with icmpx type port-unreachable
-inet test-inet input
-  [ reject type 2 code 1 ]
-
-# meta nfproto ipv4 reject with icmp type host-unreachable
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ reject type 0 code 1 ]
-
-# meta nfproto ipv6 reject with icmpv6 type no-route
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ reject type 0 code 0 ]
-
 # meta nfproto ipv4 reject with icmpx type admin-prohibited
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/inet/rt.t b/tests/py/inet/rt.t
index 23608ab2c2f9a..a0e0d00305c84 100644
--- a/tests/py/inet/rt.t
+++ b/tests/py/inet/rt.t
@@ -2,14 +2,13 @@
 
 *inet;test-inet;output
 
-rt nexthop 192.168.0.1;fail
-rt nexthop fd00::1;fail
-
 meta nfproto ipv4 rt nexthop 192.168.0.1;ok;meta nfproto ipv4 rt ip nexthop 192.168.0.1
 rt ip6 nexthop fd00::1;ok
 
 # missing context
+rt nexthop 192.168.0.1;fail
 rt nexthop fd00::1;fail
+
 # wrong context
 rt ip nexthop fd00::1;fail
 
diff --git a/tests/py/inet/sets.t.payload.netdev b/tests/py/inet/sets.t.payload.netdev
index 51938c858332a..9d6f6bbd62b1e 100644
--- a/tests/py/inet/sets.t.payload.netdev
+++ b/tests/py/inet/sets.t.payload.netdev
@@ -14,7 +14,7 @@ netdev test-netdev ingress
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 accept ]
 
-# ip saddr . ip daddr . tcp dport @ set3 accept
+# ip saddr . ip daddr . tcp dport @set3 accept
 inet 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
diff --git a/tests/py/inet/synproxy.t.json b/tests/py/inet/synproxy.t.json
index 92c69d75161aa..1dd85a6144db6 100644
--- a/tests/py/inet/synproxy.t.json
+++ b/tests/py/inet/synproxy.t.json
@@ -5,24 +5,6 @@
     }
 ]
 
-# synproxy mss 1460
-[
-    {
-        "synproxy": {
-            "mss": 1460
-        }
-    }
-]
-
-# synproxy wscale 7
-[
-    {
-        "synproxy": {
-            "wscale": 7
-        }
-    }
-]
-
 # synproxy mss 1460 wscale 7
 [
     {
@@ -56,20 +38,6 @@
     }
 ]
 
-# synproxy mss 1460 wscale 7 timestamp sack-perm
-[
-    {
-        "synproxy": {
-            "mss": 1460,
-            "wscale": 7,
-            "flags": [
-                "timestamp",
-                "sack-perm"
-            ]
-        }
-    }
-]
-
 # synproxy mss 1460 wscale 5 timestamp sack-perm
 [
     {
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index d75d12a061252..a9001f3164527 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -102,17 +102,6 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000012 ]
   [ immediate reg 0 accept ]
 
-# icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply} accept
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000000  : 0 [end]	element 00000003  : 0 [end]	element 00000004  : 0 [end]	element 00000005  : 0 [end]	element 00000008  : 0 [end]	element 0000000b  : 0 [end]	element 0000000c  : 0 [end]	element 0000000d  : 0 [end]	element 0000000e  : 0 [end]	element 0000000f  : 0 [end]	element 00000010  : 0 [end]	element 00000011  : 0 [end]	element 00000012  : 0 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
 # icmp type != {echo-reply, destination-unreachable, source-quench}
 __set%d test-ip4 3
 __set%d test-ip4 0
diff --git a/tests/py/ip/igmp.t.payload b/tests/py/ip/igmp.t.payload
index 1319c3246f0b9..b520747597f68 100644
--- a/tests/py/ip/igmp.t.payload
+++ b/tests/py/ip/igmp.t.payload
@@ -102,165 +102,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# igmp type membership-query
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-
-# igmp type membership-report-v1
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000012 ]
-
-# igmp type membership-report-v2
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
-
-# igmp type membership-report-v3
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000022 ]
-
-# igmp type leave-group
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000017 ]
-
-# igmp type { membership-report-v1, membership-report-v2, membership-report-v3}
-__set%d test-ip4 3 size 3
-__set%d test-ip4 0
-	element 00000012  : 0 [end]	element 00000016  : 0 [end]	element 00000022  : 0 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp type != { membership-report-v1, membership-report-v2, membership-report-v3}
-__set%d test-ip4 3 size 3
-__set%d test-ip4 0
-	element 00000012  : 0 [end]	element 00000016  : 0 [end]	element 00000022  : 0 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# igmp checksum 12343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003730 ]
-
-# igmp checksum != 12343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003730 ]
-
-# igmp checksum 11-343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00000b00 ]
-  [ cmp lte reg 1 0x00005701 ]
-
-# igmp checksum != 11-343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00000b00 0x00005701 ]
-
-# igmp checksum { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp checksum != { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# igmp checksum { 1111, 222, 343}
-__set%d test-ip4 3 size 3
-__set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp checksum != { 1111, 222, 343}
-__set%d test-ip4 3 size 3
-__set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# igmp type membership-query
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-
-# igmp type membership-report-v1
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000012 ]
-
-# igmp type membership-report-v2
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
-
-# igmp type membership-report-v3
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000022 ]
-
-# igmp type leave-group
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000017 ]
-
 # igmp type { membership-report-v1, membership-report-v2, membership-report-v3}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
@@ -281,75 +122,6 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# igmp checksum 12343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00003730 ]
-
-# igmp checksum != 12343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x00003730 ]
-
-# igmp checksum 11-343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00000b00 ]
-  [ cmp lte reg 1 0x00005701 ]
-
-# igmp checksum != 11-343
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ range neq reg 1 0x00000b00 0x00005701 ]
-
-# igmp checksum { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp checksum != { 11-343}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-# igmp checksum { 1111, 222, 343}
-__set%d test-ip4 3 size 3
-__set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# igmp checksum != { 1111, 222, 343}
-__set%d test-ip4 3 size 3
-__set%d test-ip4 0
-	element 00005704  : 0 [end]	element 0000de00  : 0 [end]	element 00005701  : 0 [end]
-ip test-ip4 input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # igmp mrt 10
 ip test-ip4 input 
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 0421d01bf6e49..04aada2dbccec 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -92,8 +92,8 @@ ip saddr set {192.19.1.2, 191.1.22.1};fail
 ip saddr 192.168.2.0/24;ok
 ip saddr != 192.168.2.0/24;ok
 ip saddr 192.168.3.1 ip daddr 192.168.3.100;ok
-ip saddr != 1.1.1.1;ok;ip saddr != 1.1.1.1
-ip saddr 1.1.1.1;ok;ip saddr 1.1.1.1
+ip saddr != 1.1.1.1;ok
+ip saddr 1.1.1.1;ok
 ip daddr 192.168.0.1-192.168.0.250;ok
 ip daddr 10.0.0.0-10.255.255.255;ok
 ip daddr 172.16.0.0-172.31.255.255;ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 161ff0a5802b5..578c8d3705930 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -502,16 +502,6 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
-# ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
-__set%d test-ip 3
-__set%d test-ip 0
-	element 01010101 02020202 00000006  : 0 [end]   element 01010101 03030303 00000011  : 0 [end]
-ip test-ip input
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ payload load 4b @ network header + 16 => reg 9 ]
-  [ payload load 1b @ network header + 9 => reg 10 ]
-  [ lookup reg 1 set __set%d ]
-
 # ip version 4 ip hdrlength 5
 ip test-ip4 input
   [ payload load 1b @ network header + 0 => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index c1d707481e863..8c778f99b0fa1 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -656,18 +656,6 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x0000ffff ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x0000ffff ]
 
-# ip saddr . ip daddr . ip protocol { 1.1.1.1 . 2.2.2.2 . tcp, 1.1.1.1 . 3.3.3.3 . udp}
-__set%d test-ip 3
-__set%d test-ip 0
-        element 01010101 02020202 00000006  : 0 [end]   element 01010101 03030303 00000011  : 0 [end]
-inet test-ip input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ payload load 4b @ network header + 16 => reg 9 ]
-  [ payload load 1b @ network header + 9 => reg 10 ]
-  [ lookup reg 1 set __set%d ]
-
 # ip version 4 ip hdrlength 5
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 01044a583f6ab..d4e029b07a8ac 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -629,118 +629,6 @@ netdev test-netdev ingress
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x0200a8c0 ]
 
-# ip ttl 233
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
-
-# ip protocol tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-
-# ip protocol != tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
-
-# ip saddr != 1.1.1.1
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp neq reg 1 0x01010101 ]
-
-# ip daddr 192.168.0.2
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0200a8c0 ]
-
-# ip ttl 233
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
-
-# ip protocol tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-
-# ip protocol != tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
-
-# ip saddr != 1.1.1.1
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp neq reg 1 0x01010101 ]
-
-# ip daddr 192.168.0.2
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x0200a8c0 ]
-
-# ip ttl 233
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
-
-# ip protocol tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-
-# ip protocol != tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
-
-# ip ttl 233
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp eq reg 1 0x000000e9 ]
-
-# ip protocol tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-
-# ip protocol != tcp
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp neq reg 1 0x00000006 ]
-
 # ip dscp cs1
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/ip6/dnat.t b/tests/py/ip6/dnat.t
index 28bd7ef97859e..89d5a5f9ee7ae 100644
--- a/tests/py/ip6/dnat.t
+++ b/tests/py/ip6/dnat.t
@@ -3,7 +3,7 @@
 *ip6;test-ip6;prerouting
 
 tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100;ok
-tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100;ok;tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100
+tcp dport 80-90 dnat to [2001:838:35f:1::]-[2001:838:35f:2::]:100;ok
 tcp dport 80-90 dnat to [2001:838:35f:1::]:80;ok
 dnat to [2001:838:35f:1::]/64;ok;dnat to 2001:838:35f:1::/64
 dnat to 2001:838:35f:1::-2001:838:35f:1:ffff:ffff:ffff:ffff;ok;dnat to 2001:838:35f:1::/64
diff --git a/tests/py/ip6/ether.t b/tests/py/ip6/ether.t
index d94a0d2110c93..49d7d06317eca 100644
--- a/tests/py/ip6/ether.t
+++ b/tests/py/ip6/ether.t
@@ -3,6 +3,6 @@
 *ip6;test-ip6;input
 
 tcp dport 22 iiftype ether ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04 accept
-tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04;ok;tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04
+tcp dport 22 ip6 daddr 1::2 ether saddr 00:0f:54:0c:11:04;ok
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip6 daddr 1::2;ok
 ether saddr 00:0f:54:0c:11:04 ip6 daddr 1::2 accept;ok
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 917742ffbcf03..ff1458d2b3b1b 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -192,14 +192,6 @@ inet test-inet output
   [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag more-fragments 1
-inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # frag id 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index 2405fff81389f..dc4103fd11ede 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -148,12 +148,6 @@ ip6 test-ip6 output
   [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag more-fragments 1
-ip6 test-ip6 output
-  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # frag id 1
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index 8b411a8bf4392..9a4c8a6be4b12 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -38,7 +38,7 @@ icmpv6 code != { 3-66};ok
 icmpv6 checksum 2222 log;ok
 icmpv6 checksum != 2222 log;ok
 icmpv6 checksum 222-226;ok
-icmpv6 checksum != 2222 log;ok
+icmpv6 checksum != 222-226;ok
 icmpv6 checksum { 222, 226};ok
 icmpv6 checksum != { 222, 226};ok
 icmpv6 checksum { 222-226};ok
diff --git a/tests/py/ip6/icmpv6.t.json b/tests/py/ip6/icmpv6.t.json
index ffc4931c4e0c4..2825d4cc5594a 100644
--- a/tests/py/ip6/icmpv6.t.json
+++ b/tests/py/ip6/icmpv6.t.json
@@ -640,7 +640,7 @@
     }
 ]
 
-# icmpv6 checksum != 2222 log
+# icmpv6 checksum != 222-226
 [
     {
         "match": {
@@ -650,12 +650,11 @@
                     "protocol": "icmpv6"
                 }
             },
-            "op": "!=",
-            "right": 2222
+	    "op": "!=",
+            "right": {
+                "range": [ 222, 226 ]
+            }
         }
-    },
-    {
-        "log": null
     }
 ]
 
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 171b7eade6d3e..333801c1c3e6b 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -275,13 +275,12 @@ ip6 test-ip6 input
   [ cmp gte reg 1 0x0000de00 ]
   [ cmp lte reg 1 0x0000e200 ]
 
-# icmpv6 checksum != 2222 log
-ip6 test-ip6 input
+# icmpv6 checksum != 222-226
+ip6
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp neq reg 1 0x0000ae08 ]
-  [ log ]
+  [ range neq reg 1 0x0000de00 0x0000e200 ]
 
 # icmpv6 checksum { 222, 226}
 __set%d test-ip6 3
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 8210d22be3d58..dbb56fa3085b9 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -26,7 +26,7 @@ ip6 flowlabel { 33, 55, 67, 88};ok
 ip6 flowlabel != { 33, 55, 67, 88};ok
 ip6 flowlabel { 33-55};ok
 ip6 flowlabel != { 33-55};ok
-ip6 flowlabel vmap { 0 : accept, 2 : continue } ;ok
+ip6 flowlabel vmap { 0 : accept, 2 : continue };ok
 
 ip6 length 22;ok
 ip6 length != 233;ok
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 8912aadf116cf..11ba34a1bca2b 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -113,7 +113,7 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 flowlabel vmap { 0 : accept, 2 : continue } 
+# ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-inet b size 2
 __map%d test-inet 0
 	element 00000000  : 0 [end]	element 00020000  : 0 [end]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 287d58ac00bf6..78479253abbdf 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -89,7 +89,7 @@ ip6 test-ip6 input
   [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 flowlabel vmap { 0 : accept, 2 : continue } 
+# ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-ip6 b size 2
 __map%d test-ip6 0
 	element 00000000  : 0 [end]	element 00020000  : 0 [end]
diff --git a/tests/py/ip6/snat.t b/tests/py/ip6/snat.t
index c259f9342cddf..564f0894937c6 100644
--- a/tests/py/ip6/snat.t
+++ b/tests/py/ip6/snat.t
@@ -2,5 +2,5 @@
 
 *ip6;test-ip6;postrouting
 
-tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100;ok;tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100
+tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:80-100;ok
 tcp dport 80-90 snat to [2001:838:35f:1::]-[2001:838:35f:2::]:100;ok
diff --git a/tests/py/tools/test-sanitizer.sh b/tests/py/tools/test-sanitizer.sh
new file mode 100755
index 0000000000000..92354d2b04e39
--- /dev/null
+++ b/tests/py/tools/test-sanitizer.sh
@@ -0,0 +1,78 @@
+#!/bin/bash
+
+# Do some simple sanity checks on tests:
+# - Report tests where reply matches command
+# - Report tests with non-ok exit but reply
+# - Check for duplicate test commands in *.t files
+# - Check for duplicate or stale payload records in *.t.payload* files
+# - Check for duplicate or stale json equivalents in *.t.json files
+
+cd $(dirname $0)/../
+
+[[ $1 ]] && tests="$@" || tests="*/*.t"
+
+reportfile=""
+report() { # (file, msg)
+	[[ "$reportfile" == "$1" ]] || {
+		reportfile="$1"
+		echo ""
+		echo "In $reportfile:"
+	}
+	shift
+	echo "$@"
+}
+
+for t in $tests; do
+	[[ -f $t ]] || continue
+
+	readarray -t cmdlines <<< $(grep -v -e '^ *[:*#-?]' -e '^ *$' $t)
+
+	cmds=""
+	for cmdline in "${cmdlines[@]}"; do
+		readarray -t -d ';' cmdparts <<< "$cmdline"
+		cmd="${cmdparts[0]}"
+		rc="${cmdparts[1]}"
+		out="${cmdparts[2]}"
+
+		[[ -n $cmd ]] || continue
+
+		#echo "cmdline: $cmdline"
+		#echo "cmd: $cmd"
+		#echo "rc: $rc"
+		#echo "out: $out"
+
+		[[ "$cmd" != "$out" ]] || \
+			report $t "reply matches cmd: $cmd"
+		[[ "$rc" != "ok" && "$out" ]] && \
+			report $t "output record with non-ok exit: $cmd"
+
+		cmds+="${cmd}\n"
+	done
+
+	readarray -t dups <<< $(echo -e "$cmds" | sort | uniq -d)
+	for dup in "${dups[@]}"; do
+		[[ -n $dup ]] || continue
+		report $t "duplicate command: $dup"
+	done
+
+	for p in $t.payload* $t.json; do
+		[[ -f $p ]] || continue
+		[[ $p == *.got ]] && continue
+		[[ $p == *.json ]] && t="json" || t="payload"
+
+		pcmds=$(grep '^#' $p)
+		readarray -t dups <<< $(echo "$pcmds" | sort | uniq -d)
+		readarray -t stales <<< $(echo "$pcmds" | while read hash pcmd; do
+			echo -e "$cmds" | grep -qxF "${pcmd}" || echo "# ${pcmd}"
+		done)
+
+		for stale in "${stales[@]}"; do
+			[[ -n $stale ]] || continue
+			report $p "stale $t record: $stale"
+		done
+		for dup in "${dups[@]}"; do
+			[[ -n $dup ]] || continue
+			report $p "duplicate $t record: $dup"
+		done
+	done
+done
-- 
2.28.0

