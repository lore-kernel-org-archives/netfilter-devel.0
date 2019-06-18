Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F20AC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F5C9206BA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730314AbfFRSz5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:55:57 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54550 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730162AbfFRSz4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 14:55:56 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hdJGq-0002eg-T2; Tue, 18 Jun 2019 20:55:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] netlink_delinerize: remove network header dep for reject statement also in bridge family
Date:   Tue, 18 Jun 2019 20:43:57 +0200
Message-Id: <20190618184359.29760-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618184359.29760-1-fw@strlen.de>
References: <20190618184359.29760-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

add rule bridge test-bridge input reject with icmp type ...

is shown as

ether type ip reject type ...

i.e., the dependency is not removed.

Allow dependency removal -- this adds a problem where some icmp types
will be shortened to 'reject', losing the icmp ipv4 dependency.

Next patch resolves this problem by disabling short-hand abbreviations
for bridge reject statements.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c            |   4 +
 tests/py/bridge/ether.t.json.output  |  48 +-------
 tests/py/bridge/reject.t             |  28 ++---
 tests/py/bridge/reject.t.json.output | 170 +++++----------------------
 4 files changed, 50 insertions(+), 200 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1f63d9d5e2c2..4d720d2938fc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2217,6 +2217,10 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		default:
 			break;
 		}
+
+		if (payload_dependency_exists(&rctx->pdctx, PROTO_BASE_NETWORK_HDR))
+			payload_dependency_release(&rctx->pdctx);
+
 		break;
 	default:
 		break;
diff --git a/tests/py/bridge/ether.t.json.output b/tests/py/bridge/ether.t.json.output
index 05e568f6592d..5bb2e47a458a 100644
--- a/tests/py/bridge/ether.t.json.output
+++ b/tests/py/bridge/ether.t.json.output
@@ -8,22 +8,10 @@
                     "protocol": "tcp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 22
         }
     },
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "saddr",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "00:0f:54:0c:11:04"
-        }
-    },
     {
         "match": {
             "left": {
@@ -32,29 +20,10 @@
                     "protocol": "ip"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "1.2.3.4"
         }
     },
-    {
-        "accept": null
-    }
-]
-
-# tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
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
-            "right": 22
-        }
-    },
     {
         "match": {
             "left": {
@@ -63,21 +32,12 @@
                     "protocol": "ether"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "00:0f:54:0c:11:04"
         }
     },
     {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "daddr",
-                    "protocol": "ip"
-                }
-            },
-	    "op": "==",
-            "right": "1.2.3.4"
-        }
+        "accept": null
     }
 ]
 
diff --git a/tests/py/bridge/reject.t b/tests/py/bridge/reject.t
index ad5280f7d573..ee7e93c81449 100644
--- a/tests/py/bridge/reject.t
+++ b/tests/py/bridge/reject.t
@@ -3,24 +3,24 @@
 *bridge;test-bridge;input
 
 # The output is specific for bridge family
-reject with icmp type host-unreachable;ok;ether type ip reject with icmp type host-unreachable
-reject with icmp type net-unreachable;ok;ether type ip reject with icmp type net-unreachable
-reject with icmp type prot-unreachable;ok;ether type ip reject with icmp type prot-unreachable
-reject with icmp type port-unreachable;ok;ether type ip reject
-reject with icmp type net-prohibited;ok;ether type ip reject with icmp type net-prohibited
-reject with icmp type host-prohibited;ok;ether type ip reject with icmp type host-prohibited
-reject with icmp type admin-prohibited;ok;ether type ip reject with icmp type admin-prohibited
-
-reject with icmpv6 type no-route;ok;ether type ip6 reject with icmpv6 type no-route
-reject with icmpv6 type admin-prohibited;ok;ether type ip6 reject with icmpv6 type admin-prohibited
-reject with icmpv6 type addr-unreachable;ok;ether type ip6 reject with icmpv6 type addr-unreachable
-reject with icmpv6 type port-unreachable;ok;ether type ip6 reject
+reject with icmp type host-unreachable;ok
+reject with icmp type net-unreachable;ok
+reject with icmp type prot-unreachable;ok
+reject with icmp type port-unreachable;ok
+reject with icmp type net-prohibited;ok
+reject with icmp type host-prohibited;ok
+reject with icmp type admin-prohibited;ok
+
+reject with icmpv6 type no-route;ok
+reject with icmpv6 type admin-prohibited;ok
+reject with icmpv6 type addr-unreachable;ok
+reject with icmpv6 type port-unreachable;ok
 
 mark 12345 ip protocol tcp reject with tcp reset;ok;meta mark 0x00003039 ip protocol 6 reject with tcp reset
 
 reject;ok
-ether type ip reject;ok
-ether type ip6 reject;ok
+ether type ip reject;ok;reject with icmp type port-unreachable
+ether type ip6 reject;ok;reject with icmpv6 type port-unreachable
 
 reject with icmpx type host-unreachable;ok
 reject with icmpx type no-route;ok
diff --git a/tests/py/bridge/reject.t.json.output b/tests/py/bridge/reject.t.json.output
index 08dfaf6a1778..dcfeceb88b13 100644
--- a/tests/py/bridge/reject.t.json.output
+++ b/tests/py/bridge/reject.t.json.output
@@ -1,17 +1,5 @@
 # reject with icmp type host-unreachable
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip"
-        }
-    },
     {
         "reject": {
             "expr": "host-unreachable",
@@ -22,18 +10,6 @@
 
 # reject with icmp type net-unreachable
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip"
-        }
-    },
     {
         "reject": {
             "expr": "net-unreachable",
@@ -44,18 +20,6 @@
 
 # reject with icmp type prot-unreachable
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip"
-        }
-    },
     {
         "reject": {
             "expr": "prot-unreachable",
@@ -64,39 +28,8 @@
     }
 ]
 
-# reject with icmp type port-unreachable
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip"
-        }
-    },
-    {
-        "reject": null
-    }
-]
-
 # reject with icmp type net-prohibited
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip"
-        }
-    },
     {
         "reject": {
             "expr": "net-prohibited",
@@ -107,18 +40,6 @@
 
 # reject with icmp type host-prohibited
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip"
-        }
-    },
     {
         "reject": {
             "expr": "host-prohibited",
@@ -129,18 +50,6 @@
 
 # reject with icmp type admin-prohibited
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip"
-        }
-    },
     {
         "reject": {
             "expr": "admin-prohibited",
@@ -151,18 +60,6 @@
 
 # reject with icmpv6 type no-route
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip6"
-        }
-    },
     {
         "reject": {
             "expr": "no-route",
@@ -173,18 +70,6 @@
 
 # reject with icmpv6 type admin-prohibited
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip6"
-        }
-    },
     {
         "reject": {
             "expr": "admin-prohibited",
@@ -195,18 +80,6 @@
 
 # reject with icmpv6 type addr-unreachable
 [
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip6"
-        }
-    },
     {
         "reject": {
             "expr": "addr-unreachable",
@@ -218,19 +91,10 @@
 # reject with icmpv6 type port-unreachable
 [
     {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "type",
-                    "protocol": "ether"
-                }
-            },
-	    "op": "==",
-            "right": "ip6"
+         "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpv6"
         }
-    },
-    {
-        "reject": null
     }
 ]
 
@@ -239,9 +103,11 @@
     {
         "match": {
             "left": {
-                "meta": { "key": "mark" }
+                "meta": {
+                    "key": "mark"
+                }
             },
-	    "op": "==",
+            "op": "==",
             "right": 12345
         }
     },
@@ -253,7 +119,7 @@
                     "protocol": "ip"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 6
         }
     },
@@ -271,3 +137,23 @@
     }
 ]
 
+# ether type ip reject
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# ether type ip6 reject
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpv6"
+        }
+    }
+]
+
-- 
2.21.0

