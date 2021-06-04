Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734A9C07E94
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A51561423
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Jun 2021 11:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFDLmp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Jun 2021 07:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhFDLmp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Jun 2021 07:42:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893AAC06174A
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 04:40:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lp8C8-0004vR-TO; Fri, 04 Jun 2021 13:40:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/4] tests: remove redundant test cases
Date:   Fri,  4 Jun 2021 13:40:41 +0200
Message-Id: <20210604114043.4153-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210604114043.4153-1-fw@strlen.de>
References: <20210604114043.4153-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check for
... 23-42 ...
... { 23-42 } ...

and remove the latter.  Followup patch will translate the former to the
latter during evaluation step to avoid the unneded anon set.

A separate test case will be added that checks for such rewrites.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/meta.t               |   4 -
 tests/py/any/meta.t.json          |  40 ---
 tests/py/any/meta.t.payload       |  38 ---
 tests/py/arp/arp.t                |   6 -
 tests/py/arp/arp.t.json           | 120 ---------
 tests/py/arp/arp.t.payload        |  48 ----
 tests/py/arp/arp.t.payload.netdev |  60 -----
 tests/py/inet/ah.t                |   8 -
 tests/py/inet/ah.t.json           | 160 ------------
 tests/py/inet/ah.t.payload        |  80 ------
 tests/py/inet/comp.t              |   4 -
 tests/py/inet/comp.t.json         |  80 ------
 tests/py/inet/comp.t.payload      |  40 ---
 tests/py/inet/dccp.t              |   5 -
 tests/py/inet/dccp.t.json         | 100 --------
 tests/py/inet/dccp.t.payload      |  50 ----
 tests/py/inet/esp.t               |   5 -
 tests/py/inet/esp.t.json          |  80 ------
 tests/py/inet/esp.t.payload       |  40 ---
 tests/py/inet/sctp.t              |   8 -
 tests/py/inet/sctp.t.json         | 160 ------------
 tests/py/inet/sctp.t.payload      |  80 ------
 tests/py/inet/tcp.t               |  16 --
 tests/py/inet/tcp.t.json          | 280 --------------------
 tests/py/inet/tcp.t.payload       | 140 ----------
 tests/py/inet/udp.t               |   8 -
 tests/py/inet/udp.t.json          | 166 ------------
 tests/py/inet/udp.t.payload       |  82 ------
 tests/py/inet/udplite.t           |   8 -
 tests/py/inet/udplite.t.json      | 126 ---------
 tests/py/inet/udplite.t.payload   |  62 -----
 tests/py/ip/icmp.t                |  14 -
 tests/py/ip/icmp.t.json           | 407 ------------------------------
 tests/py/ip/icmp.t.payload.ip     | 174 -------------
 tests/py/ip/igmp.t                |   2 -
 tests/py/ip/igmp.t.json           |  50 ----
 tests/py/ip/igmp.t.payload        |  20 --
 tests/py/ip/ip.t                  |  12 -
 tests/py/ip/ip.t.json             | 240 ------------------
 tests/py/ip/ip.t.payload          |  96 -------
 tests/py/ip/ip.t.payload.bridge   | 120 ---------
 tests/py/ip/ip.t.payload.inet     | 120 ---------
 tests/py/ip/ip.t.payload.netdev   | 120 ---------
 tests/py/ip6/dst.t                |   5 -
 tests/py/ip6/dst.t.json           |  81 ------
 tests/py/ip6/dst.t.payload.inet   |  41 ---
 tests/py/ip6/dst.t.payload.ip6    |  34 ---
 tests/py/ip6/frag.t               |   6 -
 tests/py/ip6/frag.t.payload.inet  |  62 -----
 tests/py/ip6/frag.t.payload.ip6   |  50 ----
 tests/py/ip6/hbh.t                |   4 -
 tests/py/ip6/hbh.t.json           |  80 ------
 tests/py/ip6/hbh.t.payload.inet   |  40 ---
 tests/py/ip6/hbh.t.payload.ip6    |  32 ---
 tests/py/ip6/icmpv6.t             |  12 -
 tests/py/ip6/icmpv6.t.json        | 240 ------------------
 tests/py/ip6/icmpv6.t.payload.ip6 | 148 -----------
 tests/py/ip6/ip6.t                |   8 -
 tests/py/ip6/ip6.t.json           | 122 ---------
 tests/py/ip6/ip6.t.payload.inet   |  82 ------
 tests/py/ip6/ip6.t.payload.ip6    |  66 -----
 tests/py/ip6/mh.t                 |   8 -
 tests/py/ip6/mh.t.json            | 162 ------------
 tests/py/ip6/mh.t.payload.inet    |  81 ------
 tests/py/ip6/mh.t.payload.ip6     |  65 -----
 tests/py/ip6/rt.t                 |   8 -
 tests/py/ip6/rt.t.json            | 160 ------------
 tests/py/ip6/rt.t.payload.inet    |  80 ------
 tests/py/ip6/rt.t.payload.ip6     |  64 -----
 69 files changed, 5220 deletions(-)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 0b894cce19c8..125b0a3f5697 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -115,8 +115,6 @@ meta skgid gt 3000 accept;ok;meta skgid > 3000 accept
 meta skgid eq 3000 accept;ok;meta skgid 3000 accept
 meta skgid 2001-2005 accept;ok
 meta skgid != 2001-2005 accept;ok
-meta skgid { 2001-2005} accept;ok
-meta skgid != { 2001-2005} accept;ok
 
 # BUG: meta nftrace 2 and meta nftrace 1
 # $ sudo nft add rule ip test input meta nftrace 2
@@ -194,8 +192,6 @@ meta cgroup { 1048577, 1048578 };ok
 meta cgroup != { 1048577, 1048578};ok
 meta cgroup 1048577-1048578;ok
 meta cgroup != 1048577-1048578;ok
-meta cgroup {1048577-1048578};ok
-meta cgroup != { 1048577-1048578};ok
 
 meta iif . meta oif { "lo" . "lo" };ok;iif . oif { "lo" . "lo" }
 meta iif . meta oif . meta mark { "lo" . "lo" . 0x0000000a };ok;iif . oif . meta mark { "lo" . "lo" . 0x0000000a }
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 1a98843c7b0e..fd4d1c2ae57b 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -1476,46 +1476,6 @@
     }
 ]
 
-# meta skgid { 2001-2005} accept
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "skgid" }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 2001, 2005 ] }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
-# meta skgid != { 2001-2005} accept
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "skgid" }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 2001, 2005 ] }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
 # meta mark set 0xffffffc8 xor 0x16
 [
     {
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 4e43905e3094..b79a0255f778 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -961,44 +961,6 @@ ip test-ip4 input
   [ meta load oifgroup => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# meta skgid { 2001-2005} accept
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
-ip test-ip4 input 
-  [ meta load skgid => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# meta skgid != { 2001-2005} accept
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element d1070000  : 0 [end]	element d6070000  : 1 [end]
-ip test-ip4 input 
-  [ meta load skgid => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
-# meta cgroup {1048577-1048578}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
-ip test-ip4 input 
-  [ meta load cgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d ]
-
-# meta cgroup != { 1048577-1048578}
-__set%d test-ip4 7 size 3
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 01001000  : 0 [end]	element 03001000  : 1 [end]
-ip test-ip4 input 
-  [ meta load cgroup => reg 1 ]
-  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # meta time "1970-05-23 21:07:14" drop
 ip meta-test input
   [ meta load time => reg 1 ]
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 2eee78381599..178cf82b65ed 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -13,8 +13,6 @@ arp htype 33-45;ok
 arp htype != 33-45;ok
 arp htype { 33, 55, 67, 88};ok
 arp htype != { 33, 55, 67, 88};ok
-arp htype { 33-55};ok
-arp htype != { 33-55};ok
 
 arp ptype 0x0800;ok;arp ptype ip
 
@@ -24,8 +22,6 @@ arp hlen 33-45;ok
 arp hlen != 33-45;ok
 arp hlen { 33, 55, 67, 88};ok
 arp hlen != { 33, 55, 67, 88};ok
-arp hlen { 33-55};ok
-arp hlen != { 33-55};ok
 
 arp plen 22;ok
 arp plen != 233;ok
@@ -33,8 +29,6 @@ arp plen 33-45;ok
 arp plen != 33-45;ok
 arp plen { 33, 55, 67, 88};ok
 arp plen != { 33, 55, 67, 88};ok
-arp plen { 33-55};ok
-arp plen != {33-55};ok
 
 arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
 arp operation != {nak, inreply, inrequest, rreply, rrequest, reply, request};ok
diff --git a/tests/py/arp/arp.t.json b/tests/py/arp/arp.t.json
index 73224f7e185e..7ce7609539ba 100644
--- a/tests/py/arp/arp.t.json
+++ b/tests/py/arp/arp.t.json
@@ -144,46 +144,6 @@
     }
 ]
 
-# arp htype { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "htype",
-                    "protocol": "arp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# arp htype != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "htype",
-                    "protocol": "arp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # arp ptype 0x0800
 [
     {
@@ -314,46 +274,6 @@
     }
 ]
 
-# arp hlen { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "hlen",
-                    "protocol": "arp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# arp hlen != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "hlen",
-                    "protocol": "arp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # arp plen 22
 [
     {
@@ -468,46 +388,6 @@
     }
 ]
 
-# arp plen { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "plen",
-                    "protocol": "arp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# arp plen != {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "plen",
-                    "protocol": "arp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
 [
     {
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index a95c834eff5a..d56927b55ad8 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -45,22 +45,6 @@ arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# arp htype { 33-55}
-__set%d test-arp 7
-__set%d test-arp 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-arp test-arp input
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# arp htype != { 33-55}
-__set%d test-arp 7
-__set%d test-arp 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-arp test-arp input
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # arp ptype 0x0800
 arp test-arp input
   [ payload load 2b @ network header + 2 => reg 1 ]
@@ -103,22 +87,6 @@ arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# arp hlen { 33-55}
-__set%d test-arp 7
-__set%d test-arp 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-arp test-arp input
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# arp hlen != { 33-55}
-__set%d test-arp 7
-__set%d test-arp 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-arp test-arp input
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # arp plen 22
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
@@ -156,22 +124,6 @@ arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# arp plen { 33-55}
-__set%d test-arp 7
-__set%d test-arp 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-arp test-arp input
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# arp plen != {33-55}
-__set%d test-arp 7
-__set%d test-arp 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-arp test-arp input
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-arp 3
 __set%d test-arp 0
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index ac985a9a794e..92df24002018 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -61,26 +61,6 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# arp htype { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# arp htype != { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 2b @ network header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # arp ptype 0x0800
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -137,26 +117,6 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# arp hlen { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# arp hlen != { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 1b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # arp plen 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -206,26 +166,6 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 5 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# arp plen { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# arp plen != {33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000608 ]
-  [ payload load 1b @ network header + 5 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # arp operation {nak, inreply, inrequest, rreply, rrequest, reply, request}
 __set%d test-netdev 3
 __set%d test-netdev 0
diff --git a/tests/py/inet/ah.t b/tests/py/inet/ah.t
index 945db99621ff..78c454f76bbe 100644
--- a/tests/py/inet/ah.t
+++ b/tests/py/inet/ah.t
@@ -20,8 +20,6 @@
 
 ah hdrlength 11-23;ok
 ah hdrlength != 11-23;ok
-ah hdrlength { 11-23};ok
-ah hdrlength != { 11-23};ok
 ah hdrlength {11, 23, 44 };ok
 ah hdrlength != {11, 23, 44 };ok
 
@@ -31,8 +29,6 @@ ah reserved 33-45;ok
 ah reserved != 33-45;ok
 ah reserved {23, 100};ok
 ah reserved != {23, 100};ok
-ah reserved { 33-55};ok
-ah reserved != { 33-55};ok
 
 ah spi 111;ok
 ah spi != 111;ok
@@ -40,15 +36,11 @@ ah spi 111-222;ok
 ah spi != 111-222;ok
 ah spi {111, 122};ok
 ah spi != {111, 122};ok
-ah spi { 111-122};ok
-ah spi != { 111-122};ok
 
 # sequence
 ah sequence 123;ok
 ah sequence != 123;ok
 ah sequence {23, 25, 33};ok
 ah sequence != {23, 25, 33};ok
-ah sequence { 23-33};ok
-ah sequence != { 23-33};ok
 ah sequence 23-33;ok
 ah sequence != 23-33;ok
diff --git a/tests/py/inet/ah.t.json b/tests/py/inet/ah.t.json
index 4efdb0dd1395..217280b6c367 100644
--- a/tests/py/inet/ah.t.json
+++ b/tests/py/inet/ah.t.json
@@ -34,46 +34,6 @@
     }
 ]
 
-# ah hdrlength { 11-23}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "hdrlength",
-                    "protocol": "ah"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 11, 23 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ah hdrlength != { 11-23}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "hdrlength",
-                    "protocol": "ah"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 11, 23 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ah hdrlength {11, 23, 44 }
 [
     {
@@ -228,46 +188,6 @@
     }
 ]
 
-# ah reserved { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "reserved",
-                    "protocol": "ah"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ah reserved != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "reserved",
-                    "protocol": "ah"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ah spi 111
 [
     {
@@ -378,46 +298,6 @@
     }
 ]
 
-# ah spi { 111-122}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "spi",
-                    "protocol": "ah"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 111, 122 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ah spi != { 111-122}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "spi",
-                    "protocol": "ah"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 111, 122 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ah sequence 123
 [
     {
@@ -494,46 +374,6 @@
     }
 ]
 
-# ah sequence { 23-33}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "ah"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 23, 33 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ah sequence != { 23-33}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "ah"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 23, 33 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ah sequence 23-33
 [
     {
diff --git a/tests/py/inet/ah.t.payload b/tests/py/inet/ah.t.payload
index 5ec5fba184fa..7ddd72d57363 100644
--- a/tests/py/inet/ah.t.payload
+++ b/tests/py/inet/ah.t.payload
@@ -13,26 +13,6 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ range neq reg 1 0x0000000b 0x00000017 ]
 
-# ah hdrlength { 11-23}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah hdrlength != { 11-23}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 0000000b  : 0 [end]	element 00000018  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ah hdrlength {11, 23, 44 }
 __set%d test-inet 3
 __set%d test-inet 0
@@ -102,26 +82,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ah reserved { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah reserved != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ah spi 111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -171,26 +131,6 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ah spi { 111-122}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah spi != { 111-122}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 6f000000  : 0 [end]	element 7b000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ah sequence 123
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -225,26 +165,6 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ah sequence { 23-33}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ah sequence != { 23-33}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 17000000  : 0 [end]	element 22000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ah sequence 23-33
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/comp.t b/tests/py/inet/comp.t
index 0df1813900ab..ec9924ff1c71 100644
--- a/tests/py/inet/comp.t
+++ b/tests/py/inet/comp.t
@@ -20,8 +20,6 @@ comp flags 0x33-0x45;ok
 comp flags != 0x33-0x45;ok
 comp flags {0x33, 0x55, 0x67, 0x88};ok
 comp flags != {0x33, 0x55, 0x67, 0x88};ok
-comp flags { 0x33-0x55};ok
-comp flags != { 0x33-0x55};ok
 
 comp cpi 22;ok
 comp cpi != 233;ok
@@ -29,5 +27,3 @@ comp cpi 33-45;ok
 comp cpi != 33-45;ok
 comp cpi {33, 55, 67, 88};ok
 comp cpi != {33, 55, 67, 88};ok
-comp cpi { 33-55};ok
-comp cpi != { 33-55};ok
diff --git a/tests/py/inet/comp.t.json b/tests/py/inet/comp.t.json
index b9b24f98c7ab..c9f6fcacec95 100644
--- a/tests/py/inet/comp.t.json
+++ b/tests/py/inet/comp.t.json
@@ -128,46 +128,6 @@
     }
 ]
 
-# comp flags { 0x33-0x55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "flags",
-                    "protocol": "comp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ "0x33", "0x55" ] }
-                ]
-            }
-        }
-    }
-]
-
-# comp flags != { 0x33-0x55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "flags",
-                    "protocol": "comp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ "0x33", "0x55" ] }
-                ]
-            }
-        }
-    }
-]
-
 # comp cpi 22
 [
     {
@@ -282,43 +242,3 @@
     }
 ]
 
-# comp cpi { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "cpi",
-                    "protocol": "comp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# comp cpi != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "cpi",
-                    "protocol": "comp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/inet/comp.t.payload b/tests/py/inet/comp.t.payload
index dec38aea6c5a..024e47cd99ed 100644
--- a/tests/py/inet/comp.t.payload
+++ b/tests/py/inet/comp.t.payload
@@ -54,26 +54,6 @@ inet test-inet input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# comp flags { 0x33-0x55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp flags != { 0x33-0x55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000033  : 0 [end]	element 00000056  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # comp cpi 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -123,23 +103,3 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# comp cpi { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# comp cpi != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000006c ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index 9a81bb2e60f3..2216fa2aed6d 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -11,17 +11,12 @@ dccp sport != 21-35;ok
 dccp sport {23, 24, 25};ok
 dccp sport != {23, 24, 25};ok
 
-dccp sport { 20-50 };ok
 dccp sport 20-50;ok
-dccp sport { 20-50};ok
-dccp sport != { 20-50};ok
 
 # dccp dport 21-35;ok
 # dccp dport != 21-35;ok
 dccp dport {23, 24, 25};ok
 dccp dport != {23, 24, 25};ok
-dccp dport { 20-50};ok
-dccp dport != { 20-50};ok
 
 dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
 dccp type != {request, response, data, ack, dataack, closereq, close, reset, sync, syncack};ok
diff --git a/tests/py/inet/dccp.t.json b/tests/py/inet/dccp.t.json
index 97e33c141035..806ef5eefca3 100644
--- a/tests/py/inet/dccp.t.json
+++ b/tests/py/inet/dccp.t.json
@@ -78,26 +78,6 @@
     }
 ]
 
-# dccp sport { 20-50 }
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
-                "set": [
-                    { "range": [ 20, 50 ] }
-                ]
-            }
-        }
-    }
-]
-
 # dccp sport 20-50
 [
     {
@@ -116,46 +96,6 @@
     }
 ]
 
-# dccp sport { 20-50}
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
-                "set": [
-                    { "range": [ 20, 50 ] }
-                ]
-            }
-        }
-    }
-]
-
-# dccp sport != { 20-50}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "dccp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 20, 50 ] }
-                ]
-            }
-        }
-    }
-]
-
 # dccp dport {23, 24, 25}
 [
     {
@@ -200,46 +140,6 @@
     }
 ]
 
-# dccp dport { 20-50}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "dccp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 20, 50 ] }
-                ]
-            }
-        }
-    }
-]
-
-# dccp dport != { 20-50}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "dccp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 20, 50 ] }
-                ]
-            }
-        }
-    }
-]
-
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 [
     {
diff --git a/tests/py/inet/dccp.t.payload b/tests/py/inet/dccp.t.payload
index b252d8294468..fbe9dc5b0016 100644
--- a/tests/py/inet/dccp.t.payload
+++ b/tests/py/inet/dccp.t.payload
@@ -33,16 +33,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# dccp sport { 20-50 }
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
 # dccp sport 20-50
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -51,26 +41,6 @@ inet test-inet input
   [ cmp gte reg 1 0x00001400 ]
   [ cmp lte reg 1 0x00003200 ]
 
-# dccp sport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp sport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # dccp dport {23, 24, 25}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -91,26 +61,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# dccp dport { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dccp dport != { 20-50}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001400  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000021 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # dccp type {request, response, data, ack, dataack, closereq, close, reset, sync, syncack}
 __set%d test-inet 3
 __set%d test-inet 0
diff --git a/tests/py/inet/esp.t b/tests/py/inet/esp.t
index ebba7d87395e..58e9f884724b 100644
--- a/tests/py/inet/esp.t
+++ b/tests/py/inet/esp.t
@@ -12,14 +12,9 @@ esp spi 111-222;ok
 esp spi != 111-222;ok
 esp spi { 100, 102};ok
 esp spi != { 100, 102};ok
-esp spi { 100-102};ok
-esp spi != { 100-102};ok
-- esp spi {100-102};ok
 
 esp sequence 22;ok
 esp sequence 22-24;ok
 esp sequence != 22-24;ok
 esp sequence { 22, 24};ok
 esp sequence != { 22, 24};ok
-esp sequence { 22-25};ok
-esp sequence != { 22-25};ok
diff --git a/tests/py/inet/esp.t.json b/tests/py/inet/esp.t.json
index ee690f96a2d4..a9dedd6f58c1 100644
--- a/tests/py/inet/esp.t.json
+++ b/tests/py/inet/esp.t.json
@@ -108,46 +108,6 @@
     }
 ]
 
-# esp spi { 100-102}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "spi",
-                    "protocol": "esp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 100, 102 ] }
-                ]
-            }
-        }
-    }
-]
-
-# esp spi != { 100-102}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "spi",
-                    "protocol": "esp"
-                }
-            },
-	    "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 100, 102 ] }
-                ]
-            }
-        }
-    }
-]
-
 # esp sequence 22
 [
     {
@@ -242,43 +202,3 @@
     }
 ]
 
-# esp sequence { 22-25}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "esp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 22, 25 ] }
-                ]
-            }
-        }
-    }
-]
-
-# esp sequence != { 22-25}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "esp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 22, 25 ] }
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/inet/esp.t.payload b/tests/py/inet/esp.t.payload
index ad68530be19a..0353b056bb66 100644
--- a/tests/py/inet/esp.t.payload
+++ b/tests/py/inet/esp.t.payload
@@ -47,26 +47,6 @@ inet test-inet input
   [ payload load 4b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# esp spi { 100-102}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp spi != { 100-102}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 64000000  : 0 [end]	element 67000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # esp sequence 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -109,23 +89,3 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# esp sequence { 22-25}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# esp sequence != { 22-25}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 1a000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/inet/sctp.t b/tests/py/inet/sctp.t
index 3d1c2fd6cd2f..57b9e67bb74e 100644
--- a/tests/py/inet/sctp.t
+++ b/tests/py/inet/sctp.t
@@ -12,8 +12,6 @@ sctp sport 23-44;ok
 sctp sport != 23-44;ok
 sctp sport { 23, 24, 25};ok
 sctp sport != { 23, 24, 25};ok
-sctp sport { 23-44};ok
-sctp sport != { 23-44};ok
 
 sctp dport 23;ok
 sctp dport != 23;ok
@@ -21,8 +19,6 @@ sctp dport 23-44;ok
 sctp dport != 23-44;ok
 sctp dport { 23, 24, 25};ok
 sctp dport != { 23, 24, 25};ok
-sctp dport { 23-44};ok
-sctp dport != { 23-44};ok
 
 sctp checksum 1111;ok
 sctp checksum != 11;ok
@@ -30,8 +26,6 @@ sctp checksum 21-333;ok
 sctp checksum != 32-111;ok
 sctp checksum { 22, 33, 44};ok
 sctp checksum != { 22, 33, 44};ok
-sctp checksum { 22-44};ok
-sctp checksum != { 22-44};ok
 
 sctp vtag 22;ok
 sctp vtag != 233;ok
@@ -39,8 +33,6 @@ sctp vtag 33-45;ok
 sctp vtag != 33-45;ok
 sctp vtag {33, 55, 67, 88};ok
 sctp vtag != {33, 55, 67, 88};ok
-sctp vtag { 33-55};ok
-sctp vtag != { 33-55};ok
 
 # assert all chunk types are recognized
 sctp chunk data exists;ok
diff --git a/tests/py/inet/sctp.t.json b/tests/py/inet/sctp.t.json
index 813568623012..75a9b01c38cf 100644
--- a/tests/py/inet/sctp.t.json
+++ b/tests/py/inet/sctp.t.json
@@ -110,46 +110,6 @@
     }
 ]
 
-# sctp sport { 23-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "sctp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 23, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
-# sctp sport != { 23-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "sctp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 23, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
 # sctp dport 23
 [
     {
@@ -262,46 +222,6 @@
     }
 ]
 
-# sctp dport { 23-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "sctp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 23, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
-# sctp dport != { 23-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "sctp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 23, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
 # sctp checksum 1111
 [
     {
@@ -414,46 +334,6 @@
     }
 ]
 
-# sctp checksum { 22-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "sctp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 22, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
-# sctp checksum != { 22-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "sctp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 22, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
 # sctp vtag 22
 [
     {
@@ -568,46 +448,6 @@
     }
 ]
 
-# sctp vtag { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "vtag",
-                    "protocol": "sctp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# sctp vtag != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "vtag",
-                    "protocol": "sctp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # sctp chunk data exists
 [
     {
diff --git a/tests/py/inet/sctp.t.payload b/tests/py/inet/sctp.t.payload
index 9c4854cfe71c..7337e2eab490 100644
--- a/tests/py/inet/sctp.t.payload
+++ b/tests/py/inet/sctp.t.payload
@@ -47,26 +47,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# sctp sport { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp sport != { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # sctp dport 23
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -116,26 +96,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# sctp dport { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp dport != { 23-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00001700  : 0 [end]	element 00002d00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # sctp checksum 1111
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -185,26 +145,6 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# sctp checksum { 22-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp checksum != { 22-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 16000000  : 0 [end]	element 2d000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # sctp vtag 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -254,26 +194,6 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# sctp vtag { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# sctp vtag != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000084 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # sctp chunk data exists
 ip
   [ exthdr load 1b @ 0 + 0 present => reg 1 ]
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index a8d46831213a..532da2776d24 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -14,8 +14,6 @@ tcp dport 33-45;ok
 tcp dport != 33-45;ok
 tcp dport { 33, 55, 67, 88};ok
 tcp dport != { 33, 55, 67, 88};ok
-tcp dport { 33-55};ok
-tcp dport != { 33-55};ok
 tcp dport {telnet, http, https} accept;ok;tcp dport { 443, 23, 80} accept
 tcp dport vmap { 22 : accept, 23 : drop };ok
 tcp dport vmap { 25:accept, 28:drop };ok
@@ -30,8 +28,6 @@ tcp sport 33-45;ok
 tcp sport != 33-45;ok
 tcp sport { 33, 55, 67, 88};ok
 tcp sport != { 33, 55, 67, 88};ok
-tcp sport { 33-55};ok
-tcp sport != { 33-55};ok
 tcp sport vmap { 25:accept, 28:drop };ok
 
 tcp sport 8080 drop;ok
@@ -47,8 +43,6 @@ tcp sequence 33-45;ok
 tcp sequence != 33-45;ok
 tcp sequence { 33, 55, 67, 88};ok
 tcp sequence != { 33, 55, 67, 88};ok
-tcp sequence { 33-55};ok
-tcp sequence != { 33-55};ok
 
 tcp ackseq 42949672 drop;ok
 tcp ackseq 22;ok
@@ -57,8 +51,6 @@ tcp ackseq 33-45;ok
 tcp ackseq != 33-45;ok
 tcp ackseq { 33, 55, 67, 88};ok
 tcp ackseq != { 33, 55, 67, 88};ok
-tcp ackseq { 33-55};ok
-tcp ackseq != { 33-55};ok
 
 - tcp doff 22;ok
 - tcp doff != 233;ok
@@ -66,8 +58,6 @@ tcp ackseq != { 33-55};ok
 - tcp doff != 33-45;ok
 - tcp doff { 33, 55, 67, 88};ok
 - tcp doff != { 33, 55, 67, 88};ok
-- tcp doff { 33-55};ok
-- tcp doff != { 33-55};ok
 
 # BUG reserved
 # BUG: It is accepted but it is not shown then. tcp reserver
@@ -90,8 +80,6 @@ tcp window 33-45;ok
 tcp window != 33-45;ok
 tcp window { 33, 55, 67, 88};ok
 tcp window != { 33, 55, 67, 88};ok
-tcp window { 33-55};ok
-tcp window != { 33-55};ok
 
 tcp checksum 22;ok
 tcp checksum != 233;ok
@@ -99,8 +87,6 @@ tcp checksum 33-45;ok
 tcp checksum != 33-45;ok
 tcp checksum { 33, 55, 67, 88};ok
 tcp checksum != { 33, 55, 67, 88};ok
-tcp checksum { 33-55};ok
-tcp checksum != { 33-55};ok
 
 tcp urgptr 1234 accept;ok
 tcp urgptr 22;ok
@@ -109,7 +95,5 @@ tcp urgptr 33-45;ok
 tcp urgptr != 33-45;ok
 tcp urgptr { 33, 55, 67, 88};ok
 tcp urgptr != { 33, 55, 67, 88};ok
-tcp urgptr { 33-55};ok
-tcp urgptr != { 33-55};ok
 
 tcp doff 8;ok
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index b04556769c81..8c2a376b2e60 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -112,46 +112,6 @@
     }
 ]
 
-# tcp dport { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "tcp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# tcp dport != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # tcp dport {telnet, http, https} accept
 [
     {
@@ -397,46 +357,6 @@
     }
 ]
 
-# tcp sport { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "tcp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# tcp sport != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # tcp sport vmap { 25:accept, 28:drop }
 [
     {
@@ -753,46 +673,6 @@
     }
 ]
 
-# tcp sequence { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "tcp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# tcp sequence != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # tcp ackseq 42949672 drop
 [
     {
@@ -926,46 +806,6 @@
     }
 ]
 
-# tcp ackseq { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "ackseq",
-                    "protocol": "tcp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# tcp ackseq != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "ackseq",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
 [
     {
@@ -1254,46 +1094,6 @@
     }
 ]
 
-# tcp window { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "window",
-                    "protocol": "tcp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# tcp window != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "window",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # tcp checksum 22
 [
     {
@@ -1408,46 +1208,6 @@
     }
 ]
 
-# tcp checksum { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "tcp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# tcp checksum != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # tcp urgptr 1234 accept
 [
     {
@@ -1581,46 +1341,6 @@
     }
 ]
 
-# tcp urgptr { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "urgptr",
-                    "protocol": "tcp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# tcp urgptr != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "urgptr",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # tcp doff 8
 [
     {
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 07ac151c2d27..ee61b1a722d5 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -47,26 +47,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# tcp dport { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp dport != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # tcp dport {telnet, http, https} accept
 __set%d test-inet 3
 __set%d test-inet 0
@@ -167,26 +147,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# tcp sport { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sport != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # tcp sport vmap { 25:accept, 28:drop }
 __map%d test-inet b
 __map%d test-inet 0
@@ -293,26 +253,6 @@ inet test-inet input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# tcp sequence { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp sequence != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # tcp ackseq 42949672 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -370,26 +310,6 @@ inet test-inet input
   [ payload load 4b @ transport header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# tcp ackseq { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp ackseq != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # tcp flags { fin, syn, rst, psh, ack, urg, ecn, cwr} drop
 __set%d test-inet 3
 __set%d test-inet 0
@@ -506,26 +426,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 14 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# tcp window { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp window != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # tcp checksum 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -575,26 +475,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 16 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# tcp checksum { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp checksum != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # tcp urgptr 1234 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -652,26 +532,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 18 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# tcp urgptr { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# tcp urgptr != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # tcp doff 8
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index 4e3eaa5105dc..c434f2edffb1 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -12,8 +12,6 @@ udp sport 50-70 accept;ok
 udp sport != 50-60 accept;ok
 udp sport { 49, 50} drop;ok
 udp sport != { 50, 60} accept;ok
-udp sport { 12-40};ok
-udp sport != { 13-24};ok
 
 udp dport set {1, 2, 3};fail
 
@@ -23,8 +21,6 @@ udp dport 70-75 accept;ok
 udp dport != 50-60 accept;ok
 udp dport { 49, 50} drop;ok
 udp dport != { 50, 60} accept;ok
-udp dport { 70-75} accept;ok
-udp dport != { 50-60} accept;ok
 
 udp length 6666;ok
 udp length != 6666;ok
@@ -32,8 +28,6 @@ udp length 50-65 accept;ok
 udp length != 50-65 accept;ok
 udp length { 50, 65} accept;ok
 udp length != { 50, 65} accept;ok
-udp length { 35-50};ok
-udp length != { 35-50};ok
 
 udp checksum 6666 drop;ok
 udp checksum != { 444, 555} accept;ok
@@ -44,8 +38,6 @@ udp checksum 33-45;ok
 udp checksum != 33-45;ok
 udp checksum { 33, 55, 67, 88};ok
 udp checksum != { 33, 55, 67, 88};ok
-udp checksum { 33-55};ok
-udp checksum != { 33-55};ok
 
 # limit impact to lo
 iif "lo" udp checksum set 0;ok
diff --git a/tests/py/inet/udp.t.json b/tests/py/inet/udp.t.json
index f88266408341..665998ecd3a0 100644
--- a/tests/py/inet/udp.t.json
+++ b/tests/py/inet/udp.t.json
@@ -126,46 +126,6 @@
     }
 ]
 
-# udp sport { 12-40}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "udp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 12, 40 ] }
-                ]
-            }
-        }
-    }
-]
-
-# udp sport != { 13-24}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "udp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 13, 24 ] }
-                ]
-            }
-        }
-    }
-]
-
 # udp dport 80 accept
 [
     {
@@ -294,52 +254,6 @@
     }
 ]
 
-# udp dport { 70-75} accept
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "udp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 70, 75 ] }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
-# udp dport != { 50-60} accept
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "udp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 50, 60 ] }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
 # udp length 6666
 [
     {
@@ -462,46 +376,6 @@
     }
 ]
 
-# udp length { 35-50}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "length",
-                    "protocol": "udp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 35, 50 ] }
-                ]
-            }
-        }
-    }
-]
-
-# udp length != { 35-50}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "length",
-                    "protocol": "udp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 35, 50 ] }
-                ]
-            }
-        }
-    }
-]
-
 # udp checksum 6666 drop
 [
     {
@@ -659,46 +533,6 @@
     }
 ]
 
-# udp checksum { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "udp"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# udp checksum != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "udp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # iif "lo" udp checksum set 0
 [
     {
diff --git a/tests/py/inet/udp.t.payload b/tests/py/inet/udp.t.payload
index d91eb784ee96..e6beda7f61fd 100644
--- a/tests/py/inet/udp.t.payload
+++ b/tests/py/inet/udp.t.payload
@@ -53,26 +53,6 @@ inet test-inet input
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
 
-# udp sport { 12-40}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp sport != { 13-24}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000d00  : 0 [end]	element 00001900  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # udp dport 80 accept
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -128,28 +108,6 @@ inet test-inet input
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
 
-# udp dport { 70-75} accept
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udp dport != { 50-60} accept
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00003200  : 0 [end]	element 00003d00  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
 # udp length 6666
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -203,26 +161,6 @@ inet test-inet input
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
 
-# udp length { 35-50}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp length != { 35-50}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # udp checksum 6666 drop
 inet test-inet input 
   [ meta load l4proto => reg 1 ]
@@ -291,26 +229,6 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# udp checksum { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udp checksum != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000011 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # iif "lo" udp checksum set 0
 inet test-inet input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/inet/udplite.t b/tests/py/inet/udplite.t
index 7c22acb977f3..a8fdc8eae72c 100644
--- a/tests/py/inet/udplite.t
+++ b/tests/py/inet/udplite.t
@@ -12,8 +12,6 @@ udplite sport 50-70 accept;ok
 udplite sport != 50-60 accept;ok
 udplite sport { 49, 50} drop;ok
 udplite sport != { 49, 50} accept;ok
-udplite sport { 12-40};ok
-udplite sport != { 12-40};ok
 
 udplite dport 80 accept;ok
 udplite dport != 60 accept;ok
@@ -21,8 +19,6 @@ udplite dport 70-75 accept;ok
 udplite dport != 50-60 accept;ok
 udplite dport { 49, 50} drop;ok
 udplite dport != { 49, 50} accept;ok
-udplite dport { 70-75} accept;ok
-udplite dport != { 70-75} accept;ok
 
 - udplite csumcov 6666;ok
 - udplite csumcov != 6666;ok
@@ -30,8 +26,6 @@ udplite dport != { 70-75} accept;ok
 - udplite csumcov != 50-65 accept;ok
 - udplite csumcov { 50, 65} accept;ok
 - udplite csumcov != { 50, 65} accept;ok
-- udplite csumcov { 35-50};ok
-- udplite csumcov != { 35-50};ok
 
 udplite checksum 6666 drop;ok
 udplite checksum != { 444, 555} accept;ok
@@ -41,5 +35,3 @@ udplite checksum 33-45;ok
 udplite checksum != 33-45;ok
 udplite checksum { 33, 55, 67, 88};ok
 udplite checksum != { 33, 55, 67, 88};ok
-udplite checksum { 33-55};ok
-udplite checksum != { 33-55};ok
diff --git a/tests/py/inet/udplite.t.json b/tests/py/inet/udplite.t.json
index f56bee47fe03..713a534f47b5 100644
--- a/tests/py/inet/udplite.t.json
+++ b/tests/py/inet/udplite.t.json
@@ -126,46 +126,6 @@
     }
 ]
 
-# udplite sport { 12-40}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "udplite"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 12, 40 ] }
-                ]
-            }
-        }
-    }
-]
-
-# udplite sport != { 12-40}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sport",
-                    "protocol": "udplite"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 12, 40 ] }
-                ]
-            }
-        }
-    }
-]
-
 # udplite dport 80 accept
 [
     {
@@ -294,52 +254,6 @@
     }
 ]
 
-# udplite dport { 70-75} accept
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "udplite"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 70, 75 ] }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
-# udplite dport != { 70-75} accept
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dport",
-                    "protocol": "udplite"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 70, 75 ] }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
 # udplite checksum 6666 drop
 [
     {
@@ -497,43 +411,3 @@
     }
 ]
 
-# udplite checksum { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "udplite"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# udplite checksum != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "udplite"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/inet/udplite.t.payload b/tests/py/inet/udplite.t.payload
index eb3dc075249d..de9d09edf5ee 100644
--- a/tests/py/inet/udplite.t.payload
+++ b/tests/py/inet/udplite.t.payload
@@ -53,26 +53,6 @@ inet test-inet input
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
 
-# udplite sport { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite sport != { 12-40}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # udplite dport 80 accept
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -128,28 +108,6 @@ inet test-inet input
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
 
-# udplite dport { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# udplite dport != { 70-75} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
 # udplite checksum 6666 drop
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -218,23 +176,3 @@ inet test-inet input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# udplite checksum { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# udplite checksum != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000088 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip/icmp.t b/tests/py/ip/icmp.t
index 11f3662e2b02..fd89af0dff20 100644
--- a/tests/py/ip/icmp.t
+++ b/tests/py/ip/icmp.t
@@ -26,8 +26,6 @@ icmp code 111 accept;ok
 icmp code != 111 accept;ok
 icmp code 33-55;ok
 icmp code != 33-55;ok
-icmp code { 33-55};ok
-icmp code != { 33-55};ok
 icmp code { 2, 4, 54, 33, 56};ok;icmp code { prot-unreachable, frag-needed, 33, 54, 56}
 icmp code != { prot-unreachable, frag-needed, 33, 54, 56};ok
 
@@ -35,8 +33,6 @@ icmp checksum 12343 accept;ok
 icmp checksum != 12343 accept;ok
 icmp checksum 11-343 accept;ok
 icmp checksum != 11-343 accept;ok
-icmp checksum { 11-343} accept;ok
-icmp checksum != { 11-343} accept;ok
 icmp checksum { 1111, 222, 343} accept;ok
 icmp checksum != { 1111, 222, 343} accept;ok
 
@@ -45,8 +41,6 @@ icmp id 22;ok;icmp type { echo-reply, echo-request} icmp id 22
 icmp id != 233;ok;icmp type { echo-reply, echo-request} icmp id != 233
 icmp id 33-45;ok;icmp type { echo-reply, echo-request} icmp id 33-45
 icmp id != 33-45;ok;icmp type { echo-reply, echo-request} icmp id != 33-45
-icmp id { 33-55};ok;icmp type { echo-reply, echo-request} icmp id { 33-55}
-icmp id != { 33-55};ok;icmp type { echo-reply, echo-request} icmp id != { 33-55}
 
 icmp id { 22, 34, 333};ok;icmp type { echo-request, echo-reply} icmp id { 22, 34, 333}
 icmp id != { 22, 34, 333};ok;icmp type { echo-request, echo-reply} icmp id != { 22, 34, 333}
@@ -57,23 +51,17 @@ icmp sequence 33-45;ok;icmp type { echo-reply, echo-request} icmp sequence 33-45
 icmp sequence != 33-45;ok;icmp type { echo-reply, echo-request} icmp sequence != 33-45
 icmp sequence { 33, 55, 67, 88};ok;icmp type { echo-request, echo-reply} icmp sequence { 33, 55, 67, 88}
 icmp sequence != { 33, 55, 67, 88};ok;icmp type { echo-request, echo-reply} icmp sequence != { 33, 55, 67, 88}
-icmp sequence { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence { 33-55}
-icmp sequence != { 33-55};ok;icmp type { echo-request, echo-reply} icmp sequence != { 33-55}
 icmp id 1 icmp sequence 2;ok;icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2
 icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2;ok
 
 icmp mtu 33;ok
 icmp mtu 22-33;ok
-icmp mtu { 22-33};ok
-icmp mtu != { 22-33};ok
 icmp mtu 22;ok
 icmp mtu != 233;ok
 icmp mtu 33-45;ok
 icmp mtu != 33-45;ok
 icmp mtu { 33, 55, 67, 88};ok
 icmp mtu != { 33, 55, 67, 88};ok
-icmp mtu { 33-55};ok
-icmp mtu != { 33-55};ok
 
 icmp gateway 22;ok
 icmp gateway != 233;ok
@@ -81,8 +69,6 @@ icmp gateway 33-45;ok
 icmp gateway != 33-45;ok
 icmp gateway { 33, 55, 67, 88};ok
 icmp gateway != { 33, 55, 67, 88};ok
-icmp gateway { 33-55};ok
-icmp gateway != { 33-55};ok
 icmp gateway != 34;ok
 icmp gateway != { 333, 334};ok
 
diff --git a/tests/py/ip/icmp.t.json b/tests/py/ip/icmp.t.json
index 12b53b0fe2cc..576335cc63d2 100644
--- a/tests/py/ip/icmp.t.json
+++ b/tests/py/ip/icmp.t.json
@@ -422,56 +422,6 @@
     }
 ]
 
-# icmp code { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# icmp code != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # icmp code { 2, 4, 54, 33, 56}
 [
     {
@@ -606,62 +556,6 @@
     }
 ]
 
-# icmp checksum { 11-343} accept
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            11,
-                            343
-                        ]
-                    }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
-# icmp checksum != { 11-343} accept
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            11,
-                            343
-                        ]
-                    }
-                ]
-            }
-        }
-    },
-    {
-        "accept": null
-    }
-]
-
 # icmp checksum { 1111, 222, 343} accept
 [
     {
@@ -839,73 +733,6 @@
     }
 ]
 
-# icmp id { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "id",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# icmp id != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "echo-reply",
-                    "echo-request"
-                ]
-            }
-        }
-    },
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "id",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # icmp id { 22, 34, 333}
 [
     {
@@ -1206,90 +1033,6 @@
     }
 ]
 
-# icmp sequence { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "echo-reply",
-                    "echo-request"
-                ]
-            }
-        }
-    },
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# icmp sequence != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "echo-reply",
-                    "echo-request"
-                ]
-            }
-        }
-    },
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # icmp id 1 icmp sequence 2
 [
     {
@@ -1417,56 +1160,6 @@
     }
 ]
 
-# icmp mtu { 22-33}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "mtu",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            22,
-                            33
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# icmp mtu != { 22-33}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "mtu",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            22,
-                            33
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # icmp mtu 22
 [
     {
@@ -1587,56 +1280,6 @@
     }
 ]
 
-# icmp mtu { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "mtu",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# icmp mtu != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "mtu",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # icmp gateway 22
 [
     {
@@ -1757,56 +1400,6 @@
     }
 ]
 
-# icmp gateway { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "gateway",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# icmp gateway != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "gateway",
-                    "protocol": "icmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            33,
-                            55
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # icmp gateway != 34
 [
     {
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index dccff4c0fba7..024739c0c3cc 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -143,26 +143,6 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 1 => reg 1 ]
   [ range neq reg 1 0x00000021 0x00000037 ]
 
-# icmp code { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmp code != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmp code { 2, 4, 54, 33, 56}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -216,28 +196,6 @@ ip test-ip4 input
   [ range neq reg 1 0x00000b00 0x00005701 ]
   [ immediate reg 0 accept ]
 
-# icmp checksum { 11-343} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ immediate reg 0 accept ]
-
-# icmp checksum != { 11-343} accept
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000b00  : 0 [end]	element 00005801  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-  [ immediate reg 0 accept ]
-
 # icmp checksum { 1111, 222, 343} accept
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -322,36 +280,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ range neq reg 1 0x00002100 0x00002d00 ]
 
-# icmp id { 33-55}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmp id != { 33-55}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmp id { 22, 34, 333}
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -461,36 +389,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# icmp sequence { 33-55}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmp sequence != { 33-55}
-__set%d test-ip4 3
-__set%d test-ip4 0
-	element 00000008  : 0 [end]	element 00000000  : 0 [end]
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmp id 1 icmp sequence 2
 __set%d test-ip4 3
 __set%d test-ip4 0
@@ -534,30 +432,6 @@ ip test-ip4 input
   [ cmp gte reg 1 0x00001600 ]
   [ cmp lte reg 1 0x00002100 ]
 
-# icmp mtu { 22-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001600  : 0 [end]	element 00002200  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmp mtu != { 22-33}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00001600  : 0 [end]	element 00002200  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmp mtu 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
@@ -619,30 +493,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# icmp mtu { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmp mtu != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000003 ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmp gateway 22
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
@@ -704,30 +554,6 @@ ip test-ip4 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# icmp gateway { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmp gateway != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmp gateway != 34
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/ip/igmp.t b/tests/py/ip/igmp.t
index 939dcc32b248..a556e475fda0 100644
--- a/tests/py/ip/igmp.t
+++ b/tests/py/ip/igmp.t
@@ -16,8 +16,6 @@ igmp checksum 12343;ok
 igmp checksum != 12343;ok
 igmp checksum 11-343;ok
 igmp checksum != 11-343;ok
-igmp checksum { 11-343};ok
-igmp checksum != { 11-343};ok
 igmp checksum { 1111, 222, 343};ok
 igmp checksum != { 1111, 222, 343};ok
 
diff --git a/tests/py/ip/igmp.t.json b/tests/py/ip/igmp.t.json
index 66dd3bb70c5b..0e2a43f361b9 100644
--- a/tests/py/ip/igmp.t.json
+++ b/tests/py/ip/igmp.t.json
@@ -196,56 +196,6 @@
     }
 ]
 
-# igmp checksum { 11-343}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "igmp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            11,
-                            343
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# igmp checksum != { 11-343}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "igmp"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [
-                            11,
-                            343
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # igmp checksum { 1111, 222, 343}
 [
     {
diff --git a/tests/py/ip/igmp.t.payload b/tests/py/ip/igmp.t.payload
index b520747597f6..940fe2cd3014 100644
--- a/tests/py/ip/igmp.t.payload
+++ b/tests/py/ip/igmp.t.payload
@@ -62,26 +62,6 @@ ip test-ip4 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00000b00 0x00005701 ]
 
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
 # igmp checksum { 1111, 222, 343}
 __set%d test-ip4 3 size 3
 __set%d test-ip4 0
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 04aada2dbcce..43c345cfa385 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -39,8 +39,6 @@ ip length 333-435;ok
 ip length != 333-453;ok
 ip length { 333, 553, 673, 838};ok
 ip length != { 333, 553, 673, 838};ok
-ip length { 333-535};ok
-ip length != { 333-535};ok
 
 ip id 22;ok
 ip id != 233;ok
@@ -48,8 +46,6 @@ ip id 33-45;ok
 ip id != 33-45;ok
 ip id { 33, 55, 67, 88};ok
 ip id != { 33, 55, 67, 88};ok
-ip id { 33-55};ok
-ip id != { 33-55};ok
 
 ip frag-off 222 accept;ok
 ip frag-off != 233;ok
@@ -57,8 +53,6 @@ ip frag-off 33-45;ok
 ip frag-off != 33-45;ok
 ip frag-off { 33, 55, 67, 88};ok
 ip frag-off != { 33, 55, 67, 88};ok
-ip frag-off { 33-55};ok
-ip frag-off != { 33-55};ok
 
 ip ttl 0 drop;ok
 ip ttl 233;ok
@@ -66,8 +60,6 @@ ip ttl 33-55;ok
 ip ttl != 45-50;ok
 ip ttl {43, 53, 45 };ok
 ip ttl != {43, 53, 45 };ok
-ip ttl { 33-55};ok
-ip ttl != { 33-55};ok
 
 ip protocol tcp;ok;ip protocol 6
 ip protocol != tcp;ok;ip protocol != 6
@@ -84,8 +76,6 @@ ip checksum 33-45;ok
 ip checksum != 33-45;ok
 ip checksum { 33, 55, 67, 88};ok
 ip checksum != { 33, 55, 67, 88};ok
-ip checksum { 33-55};ok
-ip checksum != { 33-55};ok
 
 ip saddr set {192.19.1.2, 191.1.22.1};fail
 
@@ -99,8 +89,6 @@ ip daddr 10.0.0.0-10.255.255.255;ok
 ip daddr 172.16.0.0-172.31.255.255;ok
 ip daddr 192.168.3.1-192.168.4.250;ok
 ip daddr != 192.168.0.1-192.168.0.250;ok
-ip daddr { 192.168.0.1-192.168.0.250};ok
-ip daddr != { 192.168.0.1-192.168.0.250};ok
 ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
 ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
 
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 3131ab790c04..42f936c163b2 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -270,46 +270,6 @@
     }
 ]
 
-# ip length { 333-535}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "length",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 333, 535 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip length != { 333-535}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "length",
-                    "protocol": "ip"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 333, 535 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip id 22
 [
     {
@@ -424,46 +384,6 @@
     }
 ]
 
-# ip id { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "id",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip id != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "id",
-                    "protocol": "ip"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip frag-off 222 accept
 [
     {
@@ -581,46 +501,6 @@
     }
 ]
 
-# ip frag-off { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "frag-off",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip frag-off != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "frag-off",
-                    "protocol": "ip"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip ttl 0 drop
 [
     {
@@ -736,46 +616,6 @@
     }
 ]
 
-# ip ttl { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "ttl",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip ttl != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "ttl",
-                    "protocol": "ip"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip protocol tcp
 [
     {
@@ -1019,46 +859,6 @@
     }
 ]
 
-# ip checksum { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip checksum != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "ip"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip saddr 192.168.2.0/24
 [
     {
@@ -1251,46 +1051,6 @@
     }
 ]
 
-# ip daddr { 192.168.0.1-192.168.0.250}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "daddr",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ "192.168.0.1", "192.168.0.250" ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip daddr != { 192.168.0.1-192.168.0.250}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "daddr",
-                    "protocol": "ip"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ "192.168.0.1", "192.168.0.250" ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 [
     {
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index bbff508bc604..5ba7d6e963ac 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -87,22 +87,6 @@ ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip length { 333-535}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip length != { 333-535}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip id 22
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
@@ -140,22 +124,6 @@ ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip id { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip id != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip frag-off 222 accept
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
@@ -194,22 +162,6 @@ ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip frag-off != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip ttl 0 drop
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
@@ -248,22 +200,6 @@ ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip ttl { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip ttl != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip test-ip4 input
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip protocol tcp
 ip test-ip4 input
   [ payload load 1b @ network header + 9 => reg 1 ]
@@ -340,22 +276,6 @@ ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip checksum { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip checksum != { 33-55}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip test-ip4 input
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip saddr 192.168.2.0/24
 ip test-ip4 input
   [ payload load 3b @ network header + 12 => reg 1 ]
@@ -412,22 +332,6 @@ ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
-# ip daddr { 192.168.0.1-192.168.0.250}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-ip test-ip4 input
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip daddr != { 192.168.0.1-192.168.0.250}
-__set%d test-ip4 7
-__set%d test-ip4 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-ip test-ip4 input
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-ip4 3
 __set%d test-ip4 0
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 33c9654f1c34..ead3156bc509 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -113,26 +113,6 @@ bridge test-bridge input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip length { 333-535}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip length != { 333-535}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip id 22
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
@@ -182,26 +162,6 @@ bridge test-bridge input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip id { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip id != { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip frag-off 222 accept
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
@@ -252,26 +212,6 @@ bridge test-bridge input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip frag-off != { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip ttl 0 drop
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
@@ -322,26 +262,6 @@ bridge test-bridge input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip ttl { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip ttl != { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip protocol tcp
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
@@ -442,26 +362,6 @@ bridge test-bridge input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip checksum { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip checksum != { 33-55}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip saddr 192.168.2.0/24
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
@@ -538,26 +438,6 @@ bridge test-bridge input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
-# ip daddr { 192.168.0.1-192.168.0.250}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip daddr != { 192.168.0.1-192.168.0.250}
-__set%d test-bridge 7 size 3
-__set%d test-bridge 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-bridge test-bridge input 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-bridge 3 size 3
 __set%d test-bridge 0
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 0d387da946d2..0b08e0bf5756 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -113,26 +113,6 @@ inet test-inet input
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip length { 333-535}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip length != { 333-535}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip id 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -182,26 +162,6 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip id { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip id != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip frag-off 222 accept
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -252,26 +212,6 @@ inet test-inet input
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip frag-off != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip ttl 0 drop
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -322,26 +262,6 @@ inet test-inet input
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip ttl { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip ttl != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip protocol tcp
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -442,26 +362,6 @@ inet test-inet input
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip checksum { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip checksum != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip saddr 192.168.2.0/24
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -538,26 +438,6 @@ inet test-inet input
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
-# ip daddr { 192.168.0.1-192.168.0.250}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip daddr != { 192.168.0.1-192.168.0.250}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-inet 3
 __set%d test-inet 0
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index f75f789fe75f..a4f56103d09a 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -47,26 +47,6 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip length { 333-535}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip length != { 333-535}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00004d01  : 0 [end]	element 00001802  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip id 22
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -116,26 +96,6 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip id { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip id != { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip frag-off 222 accept
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -186,26 +146,6 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 6 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip frag-off { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip frag-off != { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip ttl 0 drop
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -249,26 +189,6 @@ netdev test-netdev ingress
   [ payload load 1b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip ttl { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip ttl != { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 8 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept
 __set%d test-netdev 3
 __set%d test-netdev 0
@@ -355,26 +275,6 @@ netdev test-netdev ingress
   [ payload load 2b @ network header + 10 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip checksum { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip checksum != { 33-55}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 2b @ network header + 10 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip saddr 192.168.2.0/24
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
@@ -444,26 +344,6 @@ netdev test-netdev ingress
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ range neq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
-# ip daddr { 192.168.0.1-192.168.0.250}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip daddr != { 192.168.0.1-192.168.0.250}
-__set%d test-netdev 7
-__set%d test-netdev 0
-	element 00000000  : 1 [end]	element 0100a8c0  : 0 [end]	element fb00a8c0  : 1 [end]
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept
 __set%d test-netdev 3
 __set%d test-netdev 0
diff --git a/tests/py/ip6/dst.t b/tests/py/ip6/dst.t
index 9e7c554fa578..cd1fd3b2d9ad 100644
--- a/tests/py/ip6/dst.t
+++ b/tests/py/ip6/dst.t
@@ -9,8 +9,6 @@ dst nexthdr 33-45;ok
 dst nexthdr != 33-45;ok
 dst nexthdr { 33, 55, 67, 88};ok
 dst nexthdr != { 33, 55, 67, 88};ok
-dst nexthdr { 33-55};ok
-dst nexthdr != { 33-55};ok
 dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok;dst nexthdr { 51, 50, 17, 136, 58, 6, 33, 132, 108}
 dst nexthdr != { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp};ok;dst nexthdr != { 51, 50, 17, 136, 58, 6, 33, 132, 108}
 dst nexthdr icmp;ok;dst nexthdr 1
@@ -21,6 +19,3 @@ dst hdrlength != 233;ok
 dst hdrlength 33-45;ok
 dst hdrlength != 33-45;ok
 dst hdrlength { 33, 55, 67, 88};ok
-dst hdrlength != { 33, 55, 67, 88};ok
-dst hdrlength { 33-55};ok
-dst hdrlength != { 33-55};ok
diff --git a/tests/py/ip6/dst.t.json b/tests/py/ip6/dst.t.json
index 1373e1778072..e947a76f4f4a 100644
--- a/tests/py/ip6/dst.t.json
+++ b/tests/py/ip6/dst.t.json
@@ -112,46 +112,6 @@
     }
 ]
 
-# dst nexthdr { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "dst"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# dst nexthdr != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "dst"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 [
     {
@@ -353,44 +313,3 @@
         }
     }
 ]
-
-# dst hdrlength { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "dst"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# dst hdrlength != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "dst"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index ff22237eac79..90d6bda1e0b4 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -47,26 +47,6 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# dst nexthdr { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dst nexthdr != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -149,24 +129,3 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
-# dst hdrlength { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dst hdrlength != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index 9bf564cb9e6f..941140d0c0e7 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -35,22 +35,6 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# dst nexthdr { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dst nexthdr != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # dst nexthdr { udplite, ipcomp, udp, ah, sctp, esp, dccp, tcp, ipv6-icmp}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -113,21 +97,3 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
-# dst hdrlength { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# dst hdrlength != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-
diff --git a/tests/py/ip6/frag.t b/tests/py/ip6/frag.t
index e16529ad60b1..945398dbc7d1 100644
--- a/tests/py/ip6/frag.t
+++ b/tests/py/ip6/frag.t
@@ -17,8 +17,6 @@ frag reserved 33-45;ok
 frag reserved != 33-45;ok
 frag reserved { 33, 55, 67, 88};ok
 frag reserved != { 33, 55, 67, 88};ok
-frag reserved { 33-55};ok
-frag reserved != { 33-55};ok
 
 frag frag-off 22;ok
 frag frag-off != 233;ok
@@ -26,8 +24,6 @@ frag frag-off 33-45;ok
 frag frag-off != 33-45;ok
 frag frag-off { 33, 55, 67, 88};ok
 frag frag-off != { 33, 55, 67, 88};ok
-frag frag-off { 33-55};ok
-frag frag-off != { 33-55};ok
 
 frag reserved2 1;ok
 frag more-fragments 0;ok
@@ -40,5 +36,3 @@ frag id 33-45;ok
 frag id != 33-45;ok
 frag id { 33, 55, 67, 88};ok
 frag id != { 33, 55, 67, 88};ok
-frag id { 33-55};ok
-frag id != { 33-55};ok
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index ff1458d2b3b1..20334f441158 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -95,26 +95,6 @@ inet test-inet output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag reserved { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# frag reserved != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # frag frag-off 22
 inet test-inet output
   [ meta load nfproto => reg 1 ]
@@ -170,28 +150,6 @@ inet test-inet output
   [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag frag-off { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
-inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d ]
-
-# frag frag-off != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
-inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # frag id 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
@@ -248,26 +206,6 @@ inet test-inet output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag id { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# frag id != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-inet test-inet output
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # frag reserved2 1
 inet test-inet output
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index dc4103fd11ed..7c3e7a4e7264 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -71,22 +71,6 @@ ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag reserved { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 output
-  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# frag reserved != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 output
-  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # frag frag-off 22
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
@@ -130,24 +114,6 @@ ip6 test-ip6 output
   [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag frag-off { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
-ip6 test-ip6 output 
-  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d ]
-
-# frag frag-off != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
-ip6 test-ip6 output 
-  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # frag id 1
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
@@ -190,22 +156,6 @@ ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# frag id { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 output
-  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# frag id != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 output
-  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # frag reserved2 1
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
diff --git a/tests/py/ip6/hbh.t b/tests/py/ip6/hbh.t
index f367a384a054..fce5feaee6ab 100644
--- a/tests/py/ip6/hbh.t
+++ b/tests/py/ip6/hbh.t
@@ -9,8 +9,6 @@ hbh hdrlength 33-45;ok
 hbh hdrlength != 33-45;ok
 hbh hdrlength {33, 55, 67, 88};ok
 hbh hdrlength != {33, 55, 67, 88};ok
-hbh hdrlength { 33-55};ok
-hbh hdrlength != { 33-55};ok
 
 hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;hbh nexthdr { 58, 136, 51, 50, 6, 17, 132, 33, 108}
 hbh nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;hbh nexthdr != { 58, 136, 51, 50, 6, 17, 132, 33, 108}
@@ -20,7 +18,5 @@ hbh nexthdr 33-45;ok
 hbh nexthdr != 33-45;ok
 hbh nexthdr {33, 55, 67, 88};ok
 hbh nexthdr != {33, 55, 67, 88};ok
-hbh nexthdr { 33-55};ok
-hbh nexthdr != { 33-55};ok
 hbh nexthdr ip;ok;hbh nexthdr 0
 hbh nexthdr != ip;ok;hbh nexthdr != 0
diff --git a/tests/py/ip6/hbh.t.json b/tests/py/ip6/hbh.t.json
index 441d3bfe96c3..68670a3ba45e 100644
--- a/tests/py/ip6/hbh.t.json
+++ b/tests/py/ip6/hbh.t.json
@@ -112,46 +112,6 @@
     }
 ]
 
-# hbh hdrlength { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "hbh"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# hbh hdrlength != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "hbh"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 [
     {
@@ -322,46 +282,6 @@
     }
 ]
 
-# hbh nexthdr { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "hbh"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# hbh nexthdr != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "hbh"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # hbh nexthdr ip
 [
     {
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index e358351d3e77..63afd832b235 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -47,26 +47,6 @@ inet test-inet filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# hbh hdrlength { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet filter-input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# hbh hdrlength != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet filter-input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -136,26 +116,6 @@ inet test-inet filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# hbh nexthdr { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet filter-input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# hbh nexthdr != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet filter-input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # hbh nexthdr ip
 inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
index a4b131a52855..913505a5b779 100644
--- a/tests/py/ip6/hbh.t.payload.ip6
+++ b/tests/py/ip6/hbh.t.payload.ip6
@@ -35,22 +35,6 @@ ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# hbh hdrlength { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 filter-input
-  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# hbh hdrlength != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 filter-input
-  [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # hbh nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -104,22 +88,6 @@ ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# hbh nexthdr { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 filter-input
-  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# hbh nexthdr != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 filter-input
-  [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # hbh nexthdr ip
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
diff --git a/tests/py/ip6/icmpv6.t b/tests/py/ip6/icmpv6.t
index a45efed62fdf..c8d4cffcd9d7 100644
--- a/tests/py/ip6/icmpv6.t
+++ b/tests/py/ip6/icmpv6.t
@@ -32,8 +32,6 @@ icmpv6 code 4;ok;icmpv6 code port-unreachable
 icmpv6 code 3-66;ok
 icmpv6 code {5, 6, 7} accept;ok;icmpv6 code {policy-fail, reject-route, 7} accept
 icmpv6 code != {policy-fail, reject-route, 7} accept;ok
-icmpv6 code { 3-66};ok
-icmpv6 code != { 3-66};ok
 
 icmpv6 checksum 2222 log;ok
 icmpv6 checksum != 2222 log;ok
@@ -41,8 +39,6 @@ icmpv6 checksum 222-226;ok
 icmpv6 checksum != 222-226;ok
 icmpv6 checksum { 222, 226};ok
 icmpv6 checksum != { 222, 226};ok
-icmpv6 checksum { 222-226};ok
-icmpv6 checksum != { 222-226};ok
 
 # BUG: icmpv6 parameter-problem, pptr
 # [ICMP6HDR_PPTR]         = ICMP6HDR_FIELD("parameter-problem", icmp6_pptr),
@@ -64,16 +60,12 @@ icmpv6 mtu 33-45;ok
 icmpv6 mtu != 33-45;ok
 icmpv6 mtu {33, 55, 67, 88};ok
 icmpv6 mtu != {33, 55, 67, 88};ok
-icmpv6 mtu {33-55};ok
-icmpv6 mtu != {33-55};ok
 icmpv6 type packet-too-big icmpv6 mtu 1280;ok;icmpv6 mtu 1280
 
 icmpv6 id 33-45;ok;icmpv6 type { echo-request, echo-reply} icmpv6 id 33-45
 icmpv6 id != 33-45;ok;icmpv6 type { echo-request, echo-reply} icmpv6 id != 33-45
 icmpv6 id {33, 55, 67, 88};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id { 33, 55, 67, 88}
 icmpv6 id != {33, 55, 67, 88};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id != { 33, 55, 67, 88}
-icmpv6 id {33-55};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id { 33-55}
-icmpv6 id != {33-55};ok;icmpv6 type { echo-request, echo-reply} icmpv6 id != { 33-55}
 
 icmpv6 sequence 2;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence 2
 icmpv6 sequence {3, 4, 5, 6, 7} accept;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence { 3, 4, 5, 6, 7} accept
@@ -83,14 +75,10 @@ icmpv6 sequence {2, 4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequenc
 icmpv6 sequence != {2, 4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence != { 2, 4}
 icmpv6 sequence 2-4;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence 2-4
 icmpv6 sequence != 2-4;ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence != 2-4
-icmpv6 sequence { 2-4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence { 2-4}
-icmpv6 sequence != { 2-4};ok;icmpv6 type { echo-request, echo-reply} icmpv6 sequence != { 2-4}
 
 icmpv6 max-delay 33-45;ok
 icmpv6 max-delay != 33-45;ok
 icmpv6 max-delay {33, 55, 67, 88};ok
 icmpv6 max-delay != {33, 55, 67, 88};ok
-icmpv6 max-delay {33-55};ok
-icmpv6 max-delay != {33-55};ok
 
 icmpv6 type parameter-problem icmpv6 code no-route;ok
diff --git a/tests/py/ip6/icmpv6.t.json b/tests/py/ip6/icmpv6.t.json
index 96079042e105..30d2ad988185 100644
--- a/tests/py/ip6/icmpv6.t.json
+++ b/tests/py/ip6/icmpv6.t.json
@@ -544,46 +544,6 @@
     }
 ]
 
-# icmpv6 code { 3-66}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmpv6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 3, 66 ] }
-                ]
-            }
-        }
-    }
-]
-
-# icmpv6 code != { 3-66}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "code",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 3, 66 ] }
-                ]
-            }
-        }
-    }
-]
-
 # icmpv6 checksum 2222 log
 [
     {
@@ -700,46 +660,6 @@
     }
 ]
 
-# icmpv6 checksum { 222-226}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "icmpv6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 222, 226 ] }
-                ]
-            }
-        }
-    }
-]
-
-# icmpv6 checksum != { 222-226}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "checksum",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 222, 226 ] }
-                ]
-            }
-        }
-    }
-]
-
 # icmpv6 mtu 22
 [
     {
@@ -854,46 +774,6 @@
     }
 ]
 
-# icmpv6 mtu {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "mtu",
-                    "protocol": "icmpv6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# icmpv6 mtu != {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "mtu",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # icmpv6 id 33-45
 [
     {
@@ -976,46 +856,6 @@
     }
 ]
 
-# icmpv6 id {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "id",
-                    "protocol": "icmpv6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# icmpv6 id != {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "id",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # icmpv6 sequence 2
 [
     {
@@ -1137,46 +977,6 @@
     }
 ]
 
-# icmpv6 sequence { 2-4}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "icmpv6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 2, 4 ] }
-                ]
-            }
-        }
-    }
-]
-
-# icmpv6 sequence != { 2-4}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "sequence",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 2, 4 ] }
-                ]
-            }
-        }
-    }
-]
-
 # icmpv6 max-delay 33-45
 [
     {
@@ -1259,46 +1059,6 @@
     }
 ]
 
-# icmpv6 max-delay {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "max-delay",
-                    "protocol": "icmpv6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# icmpv6 max-delay != {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "max-delay",
-                    "protocol": "icmpv6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # icmpv6 type packet-too-big icmpv6 mtu 1280
 [
     {
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index c98a254865dc..76df184cd0d0 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -231,26 +231,6 @@ ip6 test-ip6 input
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 0 accept ]
 
-# icmpv6 code { 3-66}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000003  : 0 [end]	element 00000043  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmpv6 code != { 3-66}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000003  : 0 [end]	element 00000043  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmpv6 checksum 2222 log
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
@@ -302,26 +282,6 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# icmpv6 checksum { 222-226}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 0000de00  : 0 [end]	element 0000e300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmpv6 checksum != { 222-226}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 0000de00  : 0 [end]	element 0000e300  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmpv6 mtu 22
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
@@ -383,30 +343,6 @@ ip6 test-ip6 input
   [ payload load 4b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# icmpv6 mtu {33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmpv6 mtu != {33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
-  [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmpv6 type packet-too-big icmpv6 mtu 1280
 ip6 
   [ meta load l4proto => reg 1 ]
@@ -471,36 +407,6 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# icmpv6 id {33-55}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmpv6 id != {33-55}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmpv6 sequence 2
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -584,36 +490,6 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 6 => reg 1 ]
   [ range neq reg 1 0x00000200 0x00000400 ]
 
-# icmpv6 sequence { 2-4}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmpv6 sequence != { 2-4}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000080  : 0 [end]	element 00000081  : 0 [end]
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000200  : 0 [end]	element 00000500  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-  [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmpv6 max-delay 33-45
 ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
@@ -657,30 +533,6 @@ ip6 test-ip6 input
   [ payload load 2b @ transport header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# icmpv6 max-delay {33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# icmpv6 max-delay != {33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x0000003a ]
-  [ payload load 1b @ transport header + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000082 ]
-  [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # icmpv6 type parameter-problem icmpv6 code no-route
 ip6 
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index dbb56fa3085b..2ffe318e1e6d 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -24,8 +24,6 @@ ip6 flowlabel != 233;ok
 ip6 flowlabel { 33, 55, 67, 88};ok
 # BUG ip6 flowlabel { 5046528, 2883584, 13522432 }
 ip6 flowlabel != { 33, 55, 67, 88};ok
-ip6 flowlabel { 33-55};ok
-ip6 flowlabel != { 33-55};ok
 ip6 flowlabel vmap { 0 : accept, 2 : continue };ok
 
 ip6 length 22;ok
@@ -34,16 +32,12 @@ ip6 length 33-45;ok
 ip6 length != 33-45;ok
 ip6 length { 33, 55, 67, 88};ok
 ip6 length != {33, 55, 67, 88};ok
-ip6 length { 33-55};ok
-ip6 length != { 33-55};ok
 
 ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp};ok;ip6 nexthdr { 132, 51, 108, 136, 17, 33, 6}
 ip6 nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;ip6 nexthdr { 6, 136, 108, 33, 50, 17, 132, 58, 51}
 ip6 nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp, icmpv6};ok;ip6 nexthdr != { 6, 136, 108, 33, 50, 17, 132, 58, 51}
 ip6 nexthdr esp;ok;ip6 nexthdr 50
 ip6 nexthdr != esp;ok;ip6 nexthdr != 50
-ip6 nexthdr { 33-44};ok
-ip6 nexthdr != { 33-44};ok
 ip6 nexthdr 33-44;ok
 ip6 nexthdr != 33-44;ok
 
@@ -53,8 +47,6 @@ ip6 hoplimit 33-45;ok
 ip6 hoplimit != 33-45;ok
 ip6 hoplimit {33, 55, 67, 88};ok
 ip6 hoplimit != {33, 55, 67, 88};ok
-ip6 hoplimit {33-55};ok
-ip6 hoplimit != {33-55};ok
 
 # from src/scanner.l
 # v680		(({hex4}:){7}{hex4})
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index f898240fb418..cf802175b792 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -213,46 +213,6 @@
     }
 ]
 
-# ip6 flowlabel { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "flowlabel",
-                    "protocol": "ip6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip6 flowlabel != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "flowlabel",
-                    "protocol": "ip6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip6 flowlabel vmap { 0 : accept, 2 : continue } 
 [
     {
@@ -397,48 +357,6 @@
     }
 ]
 
-# ip6 length { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "length",
-                    "protocol": "ip6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [ 33, 55 ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# ip6 length != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "length",
-                    "protocol": "ip6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 [
     {
@@ -743,46 +661,6 @@
     }
 ]
 
-# ip6 hoplimit {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "hoplimit",
-                    "protocol": "ip6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip6 hoplimit != {33-55}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "hoplimit",
-                    "protocol": "ip6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 [
     {
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index a107abd7adc8..20dfe5497367 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -91,28 +91,6 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 flowlabel { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 flowlabel != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-inet b size 2
 __map%d test-inet 0
@@ -173,26 +151,6 @@ inet test-inet input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 length { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 length != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -237,26 +195,6 @@ inet test-inet input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x00000032 ]
 
-# ip6 nexthdr { 33-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 nexthdr != { 33-44}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 nexthdr 33-44
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -321,26 +259,6 @@ inet test-inet input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 hoplimit {33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 hoplimit != {33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index 6766622085e1..f8e3ca3cb622 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -71,24 +71,6 @@ ip6 test-ip6 input
   [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 flowlabel { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 flowlabel != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00210000  : 0 [end]	element 00380000  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 3b @ network header + 1 => reg 1 ]
-  [ bitwise reg 1 = ( reg 1 & 0x00ffff0f ) ^ 0x00000000 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 flowlabel vmap { 0 : accept, 2 : continue }
 __map%d test-ip6 b size 2
 __map%d test-ip6 0
@@ -135,22 +117,6 @@ ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 length { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 length != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 2b @ network header + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 nexthdr {udp, ah, comp, udplite, tcp, dccp, sctp}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -185,22 +151,6 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
   [ cmp neq reg 1 0x00000032 ]
 
-# ip6 nexthdr { 33-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 nexthdr != { 33-44}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 0000002d  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 1b @ network header + 6 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 nexthdr 33-44
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
@@ -249,22 +199,6 @@ ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# ip6 hoplimit {33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# ip6 hoplimit != {33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ payload load 1b @ network header + 7 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
diff --git a/tests/py/ip6/mh.t b/tests/py/ip6/mh.t
index 2f90372e83a9..46f4ba05320c 100644
--- a/tests/py/ip6/mh.t
+++ b/tests/py/ip6/mh.t
@@ -15,8 +15,6 @@ mh nexthdr 33-45;ok
 mh nexthdr != 33-45;ok
 mh nexthdr { 33, 55, 67, 88 };ok
 mh nexthdr != { 33, 55, 67, 88 };ok
-mh nexthdr { 33-55 };ok
-mh nexthdr != { 33-55 };ok
 
 mh hdrlength 22;ok
 mh hdrlength != 233;ok
@@ -24,8 +22,6 @@ mh hdrlength 33-45;ok
 mh hdrlength != 33-45;ok
 mh hdrlength { 33, 55, 67, 88 };ok
 mh hdrlength != { 33, 55, 67, 88 };ok
-mh hdrlength { 33-55 };ok
-mh hdrlength != { 33-55 };ok
 
 mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message};ok
 mh type home-agent-switch-message;ok
@@ -37,8 +33,6 @@ mh reserved 33-45;ok
 mh reserved != 33-45;ok
 mh reserved { 33, 55, 67, 88};ok
 mh reserved != { 33, 55, 67, 88};ok
-mh reserved { 33-55};ok
-mh reserved != { 33-55};ok
 
 mh checksum 22;ok
 mh checksum != 233;ok
@@ -46,5 +40,3 @@ mh checksum 33-45;ok
 mh checksum != 33-45;ok
 mh checksum { 33, 55, 67, 88};ok
 mh checksum != { 33, 55, 67, 88};ok
-mh checksum { 33-55};ok
-mh checksum != { 33-55};ok
diff --git a/tests/py/ip6/mh.t.json b/tests/py/ip6/mh.t.json
index 211477d32f5e..3159b14bd5e7 100644
--- a/tests/py/ip6/mh.t.json
+++ b/tests/py/ip6/mh.t.json
@@ -232,48 +232,6 @@
     }
 ]
 
-# mh nexthdr { 33-55 }
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "mh"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [ 33, 55 ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# mh nexthdr != { 33-55 }
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "mh"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # mh hdrlength 22
 [
     {
@@ -388,46 +346,6 @@
     }
 ]
 
-# mh hdrlength { 33-55 }
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "mh"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# mh hdrlength != { 33-55 }
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "mh"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
 [
     {
@@ -606,46 +524,6 @@
     }
 ]
 
-# mh reserved { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "reserved",
-                    "name": "mh"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# mh reserved != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "reserved",
-                    "name": "mh"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # mh checksum 22
 [
     {
@@ -760,43 +638,3 @@
     }
 ]
 
-# mh checksum { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "checksum",
-                    "name": "mh"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# mh checksum != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "checksum",
-                    "name": "mh"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 2c473fbd7634..54eaa70ea671 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -95,26 +95,6 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# mh nexthdr { 33-55 }
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh nexthdr != { 33-55 }
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # mh hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -164,26 +144,6 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# mh hdrlength { 33-55 }
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh hdrlength != { 33-55 }
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
 __set%d test-inet 3
 __set%d test-inet 0
@@ -257,26 +217,6 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# mh reserved { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh reserved != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # mh checksum 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -325,24 +265,3 @@ inet test-inet input
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
-# mh checksum { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh checksum != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
index 93744dac769d..73bd4226d745 100644
--- a/tests/py/ip6/mh.t.payload.ip6
+++ b/tests/py/ip6/mh.t.payload.ip6
@@ -71,22 +71,6 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# mh nexthdr { 33-55 }
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh nexthdr != { 33-55 }
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # mh hdrlength 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
@@ -124,22 +108,6 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# mh hdrlength { 33-55 }
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh hdrlength != { 33-55 }
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # mh type {binding-refresh-request, home-test-init, careof-test-init, home-test, careof-test, binding-update, binding-acknowledgement, binding-error, fast-binding-update, fast-binding-acknowledgement, fast-binding-advertisement, experimental-mobility-header, home-agent-switch-message}
 __set%d test-ip6 3
 __set%d test-ip6 0
@@ -195,22 +163,6 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# mh reserved { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh reserved != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # mh checksum 22
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
@@ -247,20 +199,3 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
-
-# mh checksum { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# mh checksum != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip6/rt.t b/tests/py/ip6/rt.t
index c3feaabee483..c33d38a52332 100644
--- a/tests/py/ip6/rt.t
+++ b/tests/py/ip6/rt.t
@@ -15,8 +15,6 @@ rt nexthdr 33-45;ok
 rt nexthdr != 33-45;ok
 rt nexthdr { 33, 55, 67, 88};ok
 rt nexthdr != { 33, 55, 67, 88};ok
-rt nexthdr { 33-55};ok
-rt nexthdr != { 33-55};ok
 
 rt hdrlength 22;ok
 rt hdrlength != 233;ok
@@ -24,8 +22,6 @@ rt hdrlength 33-45;ok
 rt hdrlength != 33-45;ok
 rt hdrlength { 33, 55, 67, 88};ok
 rt hdrlength != { 33, 55, 67, 88};ok
-rt hdrlength { 33-55};ok
-rt hdrlength != { 33-55};ok
 
 rt type 22;ok
 rt type != 233;ok
@@ -33,8 +29,6 @@ rt type 33-45;ok
 rt type != 33-45;ok
 rt type { 33, 55, 67, 88};ok
 rt type != { 33, 55, 67, 88};ok
-rt type { 33-55};ok
-rt type != { 33-55};ok
 
 rt seg-left 22;ok
 rt seg-left != 233;ok
@@ -42,5 +36,3 @@ rt seg-left 33-45;ok
 rt seg-left != 33-45;ok
 rt seg-left { 33, 55, 67, 88};ok
 rt seg-left != { 33, 55, 67, 88};ok
-rt seg-left { 33-55};ok
-rt seg-left != { 33-55};ok
diff --git a/tests/py/ip6/rt.t.json b/tests/py/ip6/rt.t.json
index 86a4640213ce..b12873d671f0 100644
--- a/tests/py/ip6/rt.t.json
+++ b/tests/py/ip6/rt.t.json
@@ -232,46 +232,6 @@
     }
 ]
 
-# rt nexthdr { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "rt"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# rt nexthdr != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "nexthdr",
-                    "name": "rt"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # rt hdrlength 22
 [
     {
@@ -386,46 +346,6 @@
     }
 ]
 
-# rt hdrlength { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "rt"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# rt hdrlength != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "rt"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # rt type 22
 [
     {
@@ -540,46 +460,6 @@
     }
 ]
 
-# rt type { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "type",
-                    "name": "rt"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# rt type != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "type",
-                    "name": "rt"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # rt seg-left 22
 [
     {
@@ -694,43 +574,3 @@
     }
 ]
 
-# rt seg-left { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "seg-left",
-                    "name": "rt"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# rt seg-left != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "seg-left",
-                    "name": "rt"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index eafb4a004042..864d3114b930 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -95,26 +95,6 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt nexthdr { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt nexthdr != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # rt hdrlength 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -164,26 +144,6 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt hdrlength { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt hdrlength != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # rt type 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -233,26 +193,6 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt type { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt type != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # rt seg-left 22
 inet test-inet input
   [ meta load nfproto => reg 1 ]
@@ -302,23 +242,3 @@ inet test-inet input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt seg-left { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt seg-left != { 33-55}
-__set%d test-inet 7
-__set%d test-inet 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-inet test-inet input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
diff --git a/tests/py/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
index 929cf9e19331..c7b52f82dc28 100644
--- a/tests/py/ip6/rt.t.payload.ip6
+++ b/tests/py/ip6/rt.t.payload.ip6
@@ -71,22 +71,6 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt nexthdr { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt nexthdr != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # rt hdrlength 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
@@ -124,22 +108,6 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt hdrlength { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt hdrlength != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # rt type 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
@@ -177,22 +145,6 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt type { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt type != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
 # rt seg-left 22
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
@@ -230,19 +182,3 @@ ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
 
-# rt seg-left { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# rt seg-left != { 33-55}
-__set%d test-ip6 7
-__set%d test-ip6 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
-
-- 
2.26.3

