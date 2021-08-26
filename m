Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F59C4320E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 10:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FDA1606A5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 10:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbhHZKut (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Aug 2021 06:50:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58894 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234327AbhHZKut (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 06:50:49 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6FAC860121
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Aug 2021 12:49:05 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_delinearize: incorrect meta protocol dependency kill
Date:   Thu, 26 Aug 2021 12:49:52 +0200
Message-Id: <20210826104952.4812-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

meta protocol is meaningful in bridge, netdev and inet familiiess, do
not remove this.

Fixes: a1bcf8a34975 ("payload: add payload_may_dependency_kill()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c      | 22 ++++++++++++--
 tests/py/bridge/meta.t         |  3 ++
 tests/py/bridge/meta.t.json    | 54 ++++++++++++++++++++++++++++++++++
 tests/py/bridge/meta.t.payload | 18 ++++++++++++
 tests/py/inet/meta.t           |  4 +++
 tests/py/inet/meta.t.json      | 54 ++++++++++++++++++++++++++++++++++
 tests/py/inet/meta.t.payload   | 18 ++++++++++++
 tests/py/ip/meta.t             |  2 ++
 tests/py/ip/meta.t.json        | 16 ++++++++++
 tests/py/ip/meta.t.payload     |  9 ++++++
 tests/py/ip6/meta.t            |  3 ++
 tests/py/ip6/meta.t.json       | 54 ++++++++++++++++++++++++++++++++++
 tests/py/ip6/meta.t.payload    | 18 ++++++++++++
 13 files changed, 272 insertions(+), 3 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5b545701e8b7..92617a46df6f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1993,7 +1993,7 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 				     const struct expr *expr)
 {
 	struct expr *dep = ctx->pdep->expr;
-	uint16_t l3proto;
+	uint16_t l3proto, protocol;
 	uint8_t l4proto;
 
 	if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
@@ -2005,7 +2005,22 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 	case NFPROTO_BRIDGE:
 		break;
 	default:
-		return true;
+		if (dep->left->etype != EXPR_META ||
+		    dep->right->etype != EXPR_VALUE)
+			return false;
+
+		if (dep->left->meta.key == NFT_META_PROTOCOL) {
+			protocol = mpz_get_uint16(dep->right->value);
+
+			if (family == NFPROTO_IPV4 &&
+			    protocol == ETH_P_IP)
+				return true;
+			else if (family == NFPROTO_IPV6 &&
+				 protocol == ETH_P_IPV6)
+				return true;
+		}
+
+		return false;
 	}
 
 	if (expr->left->meta.key != NFT_META_L4PROTO)
@@ -2015,7 +2030,8 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 
 	switch (dep->left->etype) {
 	case EXPR_META:
-		if (dep->left->meta.key != NFT_META_NFPROTO)
+		if (dep->left->meta.key != NFT_META_NFPROTO &&
+		    dep->left->meta.key != NFT_META_PROTOCOL)
 			return true;
 		break;
 	case EXPR_PAYLOAD:
diff --git a/tests/py/bridge/meta.t b/tests/py/bridge/meta.t
index eda7082f02b4..d77ebd899f18 100644
--- a/tests/py/bridge/meta.t
+++ b/tests/py/bridge/meta.t
@@ -6,3 +6,6 @@ meta obrname "br0";ok
 meta ibrname "br0";ok
 meta ibrvproto vlan;ok;meta ibrvproto 8021q
 meta ibrpvid 100;ok
+
+meta protocol ip udp dport 67;ok
+meta protocol ip6 udp dport 67;ok
diff --git a/tests/py/bridge/meta.t.json b/tests/py/bridge/meta.t.json
index 3122774eba8c..d7dc9d7b5ea7 100644
--- a/tests/py/bridge/meta.t.json
+++ b/tests/py/bridge/meta.t.json
@@ -49,3 +49,57 @@
         }
     }
 ]
+
+# meta protocol ip udp dport 67
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
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
+
+# meta protocol ip6 udp dport 67
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
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
diff --git a/tests/py/bridge/meta.t.payload b/tests/py/bridge/meta.t.payload
index aa8c994bfe58..14177767fdfc 100644
--- a/tests/py/bridge/meta.t.payload
+++ b/tests/py/bridge/meta.t.payload
@@ -17,3 +17,21 @@ bridge test-bridge input
 bridge test-bridge input
   [ meta load bri_iifpvid => reg 1 ]
   [ cmp eq reg 1 0x00000064 ]
+
+# meta protocol ip udp dport 67
+bridge
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00004300 ]
+
+# meta protocol ip6 udp dport 67
+bridge
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00004300 ]
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index 3638898b5dbb..423cc5f32cba 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -12,6 +12,10 @@ meta nfproto ipv4 tcp dport 22;ok
 meta nfproto ipv4 ip saddr 1.2.3.4;ok;ip saddr 1.2.3.4
 meta nfproto ipv6 meta l4proto tcp;ok;meta nfproto ipv6 meta l4proto 6
 meta nfproto ipv4 counter ip saddr 1.2.3.4;ok
+
+meta protocol ip udp dport 67;ok
+meta protocol ip6 udp dport 67;ok
+
 meta ipsec exists;ok
 meta secpath missing;ok;meta ipsec missing
 meta ibrname "br0";fail
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index 5c0e7d2e0e42..723a36f74946 100644
--- a/tests/py/inet/meta.t.json
+++ b/tests/py/inet/meta.t.json
@@ -235,3 +235,57 @@
         }
     }
 ]
+
+# meta protocol ip udp dport 67
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
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
+
+# meta protocol ip6 udp dport 67
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
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index 6ccf6d24210a..f2c861378c61 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -79,3 +79,21 @@ inet test-inet input
   [ ct load mark => reg 1 ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000008 ) ]
   [ meta set mark with reg 1 ]
+
+# meta protocol ip udp dport 67
+inet
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00004300 ]
+
+# meta protocol ip6 udp dport 67
+inet
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00004300 ]
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index f733d22de2c3..fecd0caf71a7 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -8,6 +8,8 @@ meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-adv
 meta l4proto 58 icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
 icmpv6 type nd-router-advert;ok
 
+meta protocol ip udp dport 67;ok
+
 meta ibrname "br0";fail
 meta obrname "br0";fail
 
diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
index f83864f672d5..3df31ce381fc 100644
--- a/tests/py/ip/meta.t.json
+++ b/tests/py/ip/meta.t.json
@@ -140,3 +140,19 @@
         "accept": null
     }
 ]
+
+# meta protocol ip udp dport 67
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index 7bc69a290d24..ebff0e4bb3b0 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -44,3 +44,12 @@ ip6 test-ip4 input
   [ meta load sdifname => reg 1 ]
   [ cmp neq reg 1 0x31667276 0x00000000 0x00000000 0x00000000 ]
   [ immediate reg 0 accept ]
+
+# meta protocol ip udp dport 67
+ip
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00004300 ]
diff --git a/tests/py/ip6/meta.t b/tests/py/ip6/meta.t
index dce97f5b0fd0..2c1aee2309a9 100644
--- a/tests/py/ip6/meta.t
+++ b/tests/py/ip6/meta.t
@@ -9,5 +9,8 @@ meta l4proto icmp icmp type echo-request;ok;icmp type echo-request
 meta l4proto 1 icmp type echo-request;ok;icmp type echo-request
 icmp type echo-request;ok
 
+meta protocol ip udp dport 67;ok
+meta protocol ip6 udp dport 67;ok
+
 meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
diff --git a/tests/py/ip6/meta.t.json b/tests/py/ip6/meta.t.json
index e72350f375e9..351320d70f7c 100644
--- a/tests/py/ip6/meta.t.json
+++ b/tests/py/ip6/meta.t.json
@@ -140,3 +140,57 @@
         "accept": null
     }
 ]
+
+# meta protocol ip udp dport 67
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
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
+
+# meta protocol ip6 udp dport 67
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
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index be04816eeec2..d654b019e7a7 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -44,3 +44,21 @@ ip6 test-ip6 input
   [ meta load sdifname => reg 1 ]
   [ cmp neq reg 1 0x31667276 0x00000000 0x00000000 0x00000000 ]
   [ immediate reg 0 accept ]
+
+# meta protocol ip udp dport 67
+ip6
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00004300 ]
+
+# meta protocol ip6 udp dport 67
+ip6
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00004300 ]
-- 
2.20.1

