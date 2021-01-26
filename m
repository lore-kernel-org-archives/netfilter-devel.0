Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA5CC433E6
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223102076E
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316816AbhAZXKl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392161AbhAZR67 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 12:58:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19756C0613ED
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2021 09:55:51 -0800 (PST)
Received: from localhost ([::1]:44164 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1l4SZA-0004pX-Vl; Tue, 26 Jan 2021 18:55:49 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        "Jose M . Guisado Gomez" <guigom@riseup.net>
Subject: [nft PATCH 2/2] reject: Unify inet, netdev and bridge delinearization
Date:   Tue, 26 Jan 2021 18:55:40 +0100
Message-Id: <20210126175540.9557-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210126175540.9557-1-phil@nwl.cc>
References: <20210126175540.9557-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Postprocessing for inet family did not attempt to kill any existing
payload dependency, although it is perfectly fine to do so. The mere
culprit is to not abbreviate default code rejects as that would drop
needed protocol info as a side-effect. Since postprocessing is then
almost identical to that of bridge and netdev families, merge them.

While being at it, extend tests/py/netdev/reject.t by a few more tests
taken from inet/reject.t so this covers icmpx rejects as well.

Cc: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_delinearize.c          |  24 +---
 tests/py/inet/reject.t             |  33 +++--
 tests/py/inet/reject.t.json.output | 195 +++--------------------------
 tests/py/netdev/reject.t           |  20 +++
 tests/py/netdev/reject.t.json      | 180 ++++++++++++++++++++++++++
 tests/py/netdev/reject.t.payload   |  60 +++++++++
 6 files changed, 296 insertions(+), 216 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ca4d723dea0ec..04560b9769746 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2473,23 +2473,6 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 			payload_dependency_release(&rctx->pdctx);
 		break;
 	case NFPROTO_INET:
-		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
-			datatype_set(stmt->reject.expr, &icmpx_code_type);
-			break;
-		}
-		base = rctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = rctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-		protocol = proto_find_num(base, desc);
-		switch (protocol) {
-		case NFPROTO_IPV4:
-			datatype_set(stmt->reject.expr, &icmp_code_type);
-			break;
-		case NFPROTO_IPV6:
-			datatype_set(stmt->reject.expr, &icmpv6_code_type);
-			break;
-		}
-		stmt->reject.family = protocol;
-		break;
 	case NFPROTO_BRIDGE:
 	case NFPROTO_NETDEV:
 		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
@@ -2506,11 +2489,13 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 		desc = rctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
-		case __constant_htons(ETH_P_IP):
+		case NFPROTO_IPV4:			/* INET */
+		case __constant_htons(ETH_P_IP):	/* BRIDGE, NETDEV */
 			stmt->reject.family = NFPROTO_IPV4;
 			datatype_set(stmt->reject.expr, &icmp_code_type);
 			break;
-		case __constant_htons(ETH_P_IPV6):
+		case NFPROTO_IPV6:			/* INET */
+		case __constant_htons(ETH_P_IPV6):	/* BRIDGE, NETDEV */
 			stmt->reject.family = NFPROTO_IPV6;
 			datatype_set(stmt->reject.expr, &icmpv6_code_type);
 			break;
@@ -2520,7 +2505,6 @@ static void stmt_reject_postprocess(struct rule_pp_ctx *rctx)
 
 		if (payload_dependency_exists(&rctx->pdctx, PROTO_BASE_NETWORK_HDR))
 			payload_dependency_release(&rctx->pdctx);
-
 		break;
 	default:
 		break;
diff --git a/tests/py/inet/reject.t b/tests/py/inet/reject.t
index 0e8966c9a389c..a9ecd2ea03088 100644
--- a/tests/py/inet/reject.t
+++ b/tests/py/inet/reject.t
@@ -2,33 +2,32 @@
 
 *inet;test-inet;input
 
-# The output is specific for inet family
-reject with icmp type host-unreachable;ok;meta nfproto ipv4 reject with icmp type host-unreachable
-reject with icmp type net-unreachable;ok;meta nfproto ipv4 reject with icmp type net-unreachable
-reject with icmp type prot-unreachable;ok;meta nfproto ipv4 reject with icmp type prot-unreachable
-reject with icmp type port-unreachable;ok;meta nfproto ipv4 reject
-reject with icmp type net-prohibited;ok;meta nfproto ipv4 reject with icmp type net-prohibited
-reject with icmp type host-prohibited;ok;meta nfproto ipv4 reject with icmp type host-prohibited
-reject with icmp type admin-prohibited;ok;meta nfproto ipv4 reject with icmp type admin-prohibited
-
-reject with icmpv6 type no-route;ok;meta nfproto ipv6 reject with icmpv6 type no-route
-reject with icmpv6 type admin-prohibited;ok;meta nfproto ipv6 reject with icmpv6 type admin-prohibited
-reject with icmpv6 type addr-unreachable;ok;meta nfproto ipv6 reject with icmpv6 type addr-unreachable
-reject with icmpv6 type port-unreachable;ok;meta nfproto ipv6 reject
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
 
 mark 12345 reject with tcp reset;ok;meta l4proto 6 meta mark 0x00003039 reject with tcp reset
 
 reject;ok
-meta nfproto ipv4 reject;ok
-meta nfproto ipv6 reject;ok
+meta nfproto ipv4 reject;ok;reject with icmp type port-unreachable
+meta nfproto ipv6 reject;ok;reject with icmpv6 type port-unreachable
 
 reject with icmpx type host-unreachable;ok
 reject with icmpx type no-route;ok
 reject with icmpx type admin-prohibited;ok
 reject with icmpx type port-unreachable;ok;reject
 
-meta nfproto ipv4 reject with icmp type host-unreachable;ok
-meta nfproto ipv6 reject with icmpv6 type no-route;ok
+meta nfproto ipv4 reject with icmp type host-unreachable;ok;reject with icmp type host-unreachable
+meta nfproto ipv6 reject with icmpv6 type no-route;ok;reject with icmpv6 type no-route
 
 meta nfproto ipv6 reject with icmp type host-unreachable;fail
 meta nfproto ipv4 ip protocol icmp reject with icmpv6 type no-route;fail
diff --git a/tests/py/inet/reject.t.json.output b/tests/py/inet/reject.t.json.output
index 73846fb0725e1..6e18b96bd807d 100644
--- a/tests/py/inet/reject.t.json.output
+++ b/tests/py/inet/reject.t.json.output
@@ -1,144 +1,69 @@
-# reject with icmp type host-unreachable
+# mark 12345 reject with tcp reset
 [
     {
         "match": {
             "left": {
-                "meta": { "key": "nfproto" }
+                "meta": { "key": "l4proto" }
             },
 	    "op": "==",
-            "right": "ipv4"
+            "right": 6
         }
     },
-    {
-        "reject": {
-            "expr": "host-unreachable",
-            "type": "icmp"
-        }
-    }
-]
-
-# reject with icmp type net-unreachable
-[
     {
         "match": {
             "left": {
-                "meta": { "key": "nfproto" }
+                "meta": { "key": "mark" }
             },
 	    "op": "==",
-            "right": "ipv4"
+            "right": 12345
         }
     },
     {
         "reject": {
-            "expr": "net-unreachable",
-            "type": "icmp"
+            "type": "tcp reset"
         }
     }
 ]
 
-# reject with icmp type prot-unreachable
+# meta nfproto ipv4 reject
 [
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv4"
-        }
-    },
     {
         "reject": {
-            "expr": "prot-unreachable",
+            "expr": "port-unreachable",
             "type": "icmp"
         }
     }
 ]
 
-# reject with icmp type port-unreachable
+# meta nfproto ipv6 reject
 [
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv4"
-        }
-    },
-    {
-        "reject": null
-    }
-]
-
-# reject with icmp type net-prohibited
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv4"
-        }
-    },
     {
         "reject": {
-            "expr": "net-prohibited",
-            "type": "icmp"
+            "expr": "port-unreachable",
+            "type": "icmpv6"
         }
     }
 ]
 
-# reject with icmp type host-prohibited
+# reject with icmpx type port-unreachable
 [
     {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv4"
-        }
-    },
-    {
-        "reject": {
-            "expr": "host-prohibited",
-            "type": "icmp"
-        }
+        "reject": null
     }
 ]
 
-# reject with icmp type admin-prohibited
+# meta nfproto ipv4 reject with icmp type host-unreachable
 [
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv4"
-        }
-    },
     {
         "reject": {
-            "expr": "admin-prohibited",
+            "expr": "host-unreachable",
             "type": "icmp"
         }
     }
 ]
 
-# reject with icmpv6 type no-route
+# meta nfproto ipv6 reject with icmpv6 type no-route
 [
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv6"
-        }
-    },
     {
         "reject": {
             "expr": "no-route",
@@ -147,91 +72,3 @@
     }
 ]
 
-# reject with icmpv6 type admin-prohibited
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv6"
-        }
-    },
-    {
-        "reject": {
-            "expr": "admin-prohibited",
-            "type": "icmpv6"
-        }
-    }
-]
-
-# reject with icmpv6 type addr-unreachable
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv6"
-        }
-    },
-    {
-        "reject": {
-            "expr": "addr-unreachable",
-            "type": "icmpv6"
-        }
-    }
-]
-
-# reject with icmpv6 type port-unreachable
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "nfproto" }
-            },
-	    "op": "==",
-            "right": "ipv6"
-        }
-    },
-    {
-        "reject": null
-    }
-]
-
-# mark 12345 reject with tcp reset
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "l4proto" }
-            },
-	    "op": "==",
-            "right": 6
-        }
-    },
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "mark" }
-            },
-	    "op": "==",
-            "right": 12345
-        }
-    },
-    {
-        "reject": {
-            "type": "tcp reset"
-        }
-    }
-]
-
-# reject with icmpx type port-unreachable
-[
-    {
-        "reject": null
-    }
-]
-
diff --git a/tests/py/netdev/reject.t b/tests/py/netdev/reject.t
index 8f8c4e0375977..af1090860fd58 100644
--- a/tests/py/netdev/reject.t
+++ b/tests/py/netdev/reject.t
@@ -17,4 +17,24 @@ reject with icmpv6 type port-unreachable;ok
 reject with icmpv6 type policy-fail;ok
 reject with icmpv6 type reject-route;ok
 
+mark 12345 reject with tcp reset;ok;meta l4proto 6 meta mark 0x00003039 reject with tcp reset
+
 reject;ok
+meta protocol ip reject;ok;reject with icmp type port-unreachable
+meta protocol ip6 reject;ok;reject with icmpv6 type port-unreachable
+
+reject with icmpx type host-unreachable;ok
+reject with icmpx type no-route;ok
+reject with icmpx type admin-prohibited;ok
+reject with icmpx type port-unreachable;ok;reject
+
+meta protocol ip reject with icmp type host-unreachable;ok;reject with icmp type host-unreachable
+meta protocol ip6 reject with icmpv6 type no-route;ok;reject with icmpv6 type no-route
+
+meta protocol ip6 reject with icmp type host-unreachable;fail
+meta protocol ip ip protocol icmp reject with icmpv6 type no-route;fail
+meta protocol ip6 ip protocol icmp reject with icmp type host-unreachable;fail
+meta l4proto udp reject with tcp reset;fail
+
+meta protocol ip reject with icmpx type admin-prohibited;ok
+meta protocol ip6 reject with icmpx type admin-prohibited;ok
diff --git a/tests/py/netdev/reject.t.json b/tests/py/netdev/reject.t.json
index ffc72794ac611..21e6ebb5117b7 100644
--- a/tests/py/netdev/reject.t.json
+++ b/tests/py/netdev/reject.t.json
@@ -128,6 +128,26 @@
     }
 ]
 
+# mark 12345 reject with tcp reset
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "op": "==",
+            "right": 12345
+        }
+    },
+    {
+        "reject": {
+            "type": "tcp reset"
+        }
+    }
+]
+
 # reject
 [
     {
@@ -135,3 +155,163 @@
     }
 ]
 
+# meta protocol ip reject
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip"
+        }
+    },
+    {
+        "reject": null
+    }
+]
+
+# meta protocol ip6 reject
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip6"
+        }
+    },
+    {
+        "reject": null
+    }
+]
+
+# reject with icmpx type host-unreachable
+[
+    {
+        "reject": {
+            "expr": "host-unreachable",
+            "type": "icmpx"
+        }
+    }
+]
+
+# reject with icmpx type no-route
+[
+    {
+        "reject": {
+            "expr": "no-route",
+            "type": "icmpx"
+        }
+    }
+]
+
+# reject with icmpx type admin-prohibited
+[
+    {
+        "reject": {
+            "expr": "admin-prohibited",
+            "type": "icmpx"
+        }
+    }
+]
+
+# reject with icmpx type port-unreachable
+[
+    {
+        "reject": {
+            "expr": "port-unreachable",
+            "type": "icmpx"
+        }
+    }
+]
+
+# meta protocol ip reject with icmp type host-unreachable
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip"
+        }
+    },
+    {
+        "reject": {
+            "expr": "host-unreachable",
+            "type": "icmp"
+        }
+    }
+]
+
+# meta protocol ip6 reject with icmpv6 type no-route
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip6"
+        }
+    },
+    {
+        "reject": {
+            "expr": "no-route",
+            "type": "icmpv6"
+        }
+    }
+]
+
+# meta protocol ip reject with icmpx type admin-prohibited
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip"
+        }
+    },
+    {
+        "reject": {
+            "expr": "admin-prohibited",
+            "type": "icmpx"
+        }
+    }
+]
+
+# meta protocol ip6 reject with icmpx type admin-prohibited
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "protocol"
+                }
+            },
+            "op": "==",
+            "right": "ip6"
+        }
+    },
+    {
+        "reject": {
+            "expr": "admin-prohibited",
+            "type": "icmpx"
+        }
+    }
+]
+
diff --git a/tests/py/netdev/reject.t.payload b/tests/py/netdev/reject.t.payload
index aead412772c0d..5f76b0915d5cd 100644
--- a/tests/py/netdev/reject.t.payload
+++ b/tests/py/netdev/reject.t.payload
@@ -76,7 +76,67 @@ netdev
   [ cmp eq reg 1 0x0000dd86 ]
   [ reject type 0 code 6 ]
 
+# mark 12345 reject with tcp reset
+netdev 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ meta load mark => reg 1 ]
+  [ cmp eq reg 1 0x00003039 ]
+  [ reject type 1 code 0 ]
+
 # reject
 netdev 
   [ reject type 2 code 1 ]
 
+# meta protocol ip reject
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ reject type 0 code 3 ]
+
+# meta protocol ip6 reject
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ reject type 0 code 4 ]
+
+# reject with icmpx type host-unreachable
+netdev 
+  [ reject type 2 code 2 ]
+
+# reject with icmpx type no-route
+netdev 
+  [ reject type 2 code 0 ]
+
+# reject with icmpx type admin-prohibited
+netdev 
+  [ reject type 2 code 3 ]
+
+# reject with icmpx type port-unreachable
+netdev 
+  [ reject type 2 code 1 ]
+
+# meta protocol ip reject with icmp type host-unreachable
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ reject type 0 code 1 ]
+
+# meta protocol ip6 reject with icmpv6 type no-route
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ reject type 0 code 0 ]
+
+# meta protocol ip reject with icmpx type admin-prohibited
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ reject type 2 code 3 ]
+
+# meta protocol ip6 reject with icmpx type admin-prohibited
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ reject type 2 code 3 ]
+
-- 
2.28.0

