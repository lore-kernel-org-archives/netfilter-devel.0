Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F8DC04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A28220989
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfEILgH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 07:36:07 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35044 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEILgH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 07:36:07 -0400
Received: from localhost ([::1]:48134 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hOhLJ-0000cs-Er; Thu, 09 May 2019 13:36:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/9] json: Fix tproxy support regarding latest changes
Date:   Thu,  9 May 2019 13:35:41 +0200
Message-Id: <20190509113545.4017-6-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509113545.4017-1-phil@nwl.cc>
References: <20190509113545.4017-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Family may be specified also if no address is given at the same time,
make parser/printer tolerant to that. Also fix for missing/incorrect
JSON equivalents in tests/py.

While being at it, fix two issues in non-JSON tests:

* Ruleset is printed in numeric mode, so use 'l4proto 6' instead of
  'l4proto tcp' in rules to avoid having to specify expected output for
  that unrelated bit.

* In ip and ip6 family tables, family parameter is not deserialized on
  output.

Fixes: 3edb96200690b ("parser_bison: missing tproxy syntax with port only for inet family")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c                        | 23 ++++-----
 src/parser_json.c                 | 16 +++----
 tests/py/inet/tproxy.t            |  2 +-
 tests/py/inet/tproxy.t.json       | 80 +++++++++++++++++++++++++++++++
 tests/py/inet/tproxy.t.payload    |  2 +-
 tests/py/ip/tproxy.t              |  2 +-
 tests/py/ip/tproxy.t.json         | 26 ++++++++--
 tests/py/ip/tproxy.t.json.output  | 61 +++++++++++++++++++++++
 tests/py/ip6/tproxy.t             |  2 +-
 tests/py/ip6/tproxy.t.json        | 26 ++++++++--
 tests/py/ip6/tproxy.t.json.output | 60 +++++++++++++++++++++++
 11 files changed, 268 insertions(+), 32 deletions(-)
 create mode 100644 tests/py/ip/tproxy.t.json.output
 create mode 100644 tests/py/ip6/tproxy.t.json.output

diff --git a/src/json.c b/src/json.c
index a8538bdca973b..ff79b0cc729c7 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1437,26 +1437,23 @@ json_t *connlimit_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 
 json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 {
-	json_t *root = json_object();
-
-	if (stmt->tproxy.addr) {
-		int family;
-		json_t *tmp;
-
-		family = stmt->tproxy.table_family;
-		if (family == NFPROTO_INET)
-			family = stmt->tproxy.family;
+	json_t *tmp, *root = json_object();
 
-		tmp = json_string(family2str(family));
+	if (stmt->tproxy.table_family == NFPROTO_INET &&
+	    stmt->tproxy.family != NFPROTO_UNSPEC) {
+		tmp = json_string(family2str(stmt->tproxy.family));
 		json_object_set_new(root, "family", tmp);
+	}
 
+	if (stmt->tproxy.addr) {
 		tmp = expr_print_json(stmt->tproxy.addr, octx);
 		json_object_set_new(root, "addr", tmp);
 	}
 
-	if (stmt->tproxy.port)
-		json_object_set_new(root, "port",
-				    expr_print_json(stmt->tproxy.port, octx));
+	if (stmt->tproxy.port) {
+		tmp = expr_print_json(stmt->tproxy.port, octx);
+		json_object_set_new(root, "port", tmp);
+	}
 
 	return json_pack("{s:o}", "tproxy", root);
 }
diff --git a/src/parser_json.c b/src/parser_json.c
index 3a78f8860aaca..8707d2c74d0a7 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1899,17 +1899,15 @@ static struct stmt *json_parse_tproxy_stmt(struct json_ctx *ctx,
 	if (familyval < 0)
 		goto out_free;
 
-	if (familyval == NFPROTO_UNSPEC ||
-	    json_unpack(value, "{s:o}", "addr", &jaddr))
-		goto try_port;
-
 	stmt->tproxy.family = familyval;
-	stmt->tproxy.addr = json_parse_stmt_expr(ctx, jaddr);
-	if (!stmt->tproxy.addr) {
-		json_error(ctx, "Invalid addr.");
-		goto out_free;
+
+	if (!json_unpack(value, "{s:o}", "addr", &jaddr)) {
+		stmt->tproxy.addr = json_parse_stmt_expr(ctx, jaddr);
+		if (!stmt->tproxy.addr) {
+			json_error(ctx, "Invalid addr.");
+			goto out_free;
+		}
 	}
-try_port:
 	if (!json_unpack(value, "{s:o}", "port", &tmp)) {
 		stmt->tproxy.port = json_parse_stmt_expr(ctx, tmp);
 		if (!stmt->tproxy.port) {
diff --git a/tests/py/inet/tproxy.t b/tests/py/inet/tproxy.t
index 0ba78ef1826a2..d23bbcb56cdcd 100644
--- a/tests/py/inet/tproxy.t
+++ b/tests/py/inet/tproxy.t
@@ -18,4 +18,4 @@ ip6 nexthdr 6 tproxy ip to 192.0.2.1;fail
 meta l4proto 17 tproxy ip to :50080;ok
 meta l4proto 17 tproxy ip6 to :50080;ok
 meta l4proto 17 tproxy to :50080;ok
-ip daddr 0.0.0.0/0 meta l4proto tcp tproxy ip to :2000;ok
+ip daddr 0.0.0.0/0 meta l4proto 6 tproxy ip to :2000;ok
diff --git a/tests/py/inet/tproxy.t.json b/tests/py/inet/tproxy.t.json
index 2897d2007192a..7b3b11c49205a 100644
--- a/tests/py/inet/tproxy.t.json
+++ b/tests/py/inet/tproxy.t.json
@@ -84,6 +84,48 @@
     }
 ]
 
+# meta l4proto 17 tproxy ip to :50080
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 17
+        }
+    },
+    {
+        "tproxy": {
+            "family": "ip",
+            "port": 50080
+        }
+    }
+]
+
+# meta l4proto 17 tproxy ip6 to :50080
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 17
+        }
+    },
+    {
+        "tproxy": {
+            "family": "ip6",
+            "port": 50080
+        }
+    }
+]
+
 # meta l4proto 17 tproxy to :50080
 [
     {
@@ -103,3 +145,41 @@
         }
     }
 ]
+
+# ip daddr 0.0.0.0/0 meta l4proto 6 tproxy ip to :2000
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": {
+                "prefix": {
+			"addr": "0.0.0.0",
+			"len": 0
+		}
+	    }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+	    "family": "ip",
+            "port": 2000
+        }
+    }
+]
diff --git a/tests/py/inet/tproxy.t.payload b/tests/py/inet/tproxy.t.payload
index 8a6ba03656059..82ff928db772f 100644
--- a/tests/py/inet/tproxy.t.payload
+++ b/tests/py/inet/tproxy.t.payload
@@ -49,7 +49,7 @@ inet x y
   [ immediate reg 1 0x0000a0c3 ]
   [ tproxy ip6 port reg 1 ]
 
-# ip daddr 0.0.0.0/0 meta l4proto tcp tproxy ip to :2000
+# ip daddr 0.0.0.0/0 meta l4proto 6 tproxy ip to :2000
 inet x y 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
diff --git a/tests/py/ip/tproxy.t b/tests/py/ip/tproxy.t
index 966898c037b26..544c5193efea6 100644
--- a/tests/py/ip/tproxy.t
+++ b/tests/py/ip/tproxy.t
@@ -11,4 +11,4 @@ meta l4proto 6 tproxy to 192.0.2.1:50080;ok
 ip protocol 6 tproxy to :50080;ok
 meta l4proto 17 tproxy ip to 192.0.2.1;ok;meta l4proto 17 tproxy to 192.0.2.1
 meta l4proto 6 tproxy ip to 192.0.2.1:50080;ok;meta l4proto 6 tproxy to 192.0.2.1:50080
-ip protocol 6 tproxy ip to :50080;ok
+ip protocol 6 tproxy ip to :50080;ok;ip protocol 6 tproxy to :50080
diff --git a/tests/py/ip/tproxy.t.json b/tests/py/ip/tproxy.t.json
index 1936b5f43be00..4635fc1f84e4b 100644
--- a/tests/py/ip/tproxy.t.json
+++ b/tests/py/ip/tproxy.t.json
@@ -13,8 +13,7 @@
     },
     {
         "tproxy": {
-            "addr": "192.0.2.1",
-            "family": "ip"
+            "addr": "192.0.2.1"
         }
     }
 ]
@@ -35,7 +34,6 @@
     {
         "tproxy": {
             "addr": "192.0.2.1",
-            "family": "ip",
             "port": 50080
         }
     }
@@ -104,3 +102,25 @@
         }
     }
 ]
+
+# ip protocol 6 tproxy ip to :50080
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+            "family": "ip",
+            "port": 50080
+        }
+    }
+]
diff --git a/tests/py/ip/tproxy.t.json.output b/tests/py/ip/tproxy.t.json.output
new file mode 100644
index 0000000000000..2690f22539867
--- /dev/null
+++ b/tests/py/ip/tproxy.t.json.output
@@ -0,0 +1,61 @@
+# meta l4proto 17 tproxy ip to 192.0.2.1
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 17
+        }
+    },
+    {
+        "tproxy": {
+            "addr": "192.0.2.1"
+        }
+    }
+]
+
+# meta l4proto 6 tproxy ip to 192.0.2.1:50080
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+            "addr": "192.0.2.1",
+            "port": 50080
+        }
+    }
+]
+
+# ip protocol 6 tproxy ip to :50080
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+            "port": 50080
+        }
+    }
+]
diff --git a/tests/py/ip6/tproxy.t b/tests/py/ip6/tproxy.t
index 48fe4ca765052..d4c6bffb969bc 100644
--- a/tests/py/ip6/tproxy.t
+++ b/tests/py/ip6/tproxy.t
@@ -11,4 +11,4 @@ meta l4proto 17 tproxy to [2001:db8::1]:50080;ok
 meta l4proto 6 tproxy to :50080;ok
 meta l4proto 6 tproxy ip6 to [2001:db8::1];ok;meta l4proto 6 tproxy to [2001:db8::1]
 meta l4proto 17 tproxy ip6 to [2001:db8::1]:50080;ok;meta l4proto 17 tproxy to [2001:db8::1]:50080
-meta l4proto 6 tproxy ip6 to :50080;ok
+meta l4proto 6 tproxy ip6 to :50080;ok;meta l4proto 6 tproxy to :50080
diff --git a/tests/py/ip6/tproxy.t.json b/tests/py/ip6/tproxy.t.json
index 7372acb93f500..0e02d49c9b9db 100644
--- a/tests/py/ip6/tproxy.t.json
+++ b/tests/py/ip6/tproxy.t.json
@@ -13,8 +13,7 @@
     },
     {
         "tproxy": {
-            "addr": "2001:db8::1",
-            "family": "ip6"
+            "addr": "2001:db8::1"
         }
     }
 ]
@@ -35,7 +34,6 @@
     {
         "tproxy": {
             "addr": "2001:db8::1",
-            "family": "ip6",
             "port": 50080
         }
     }
@@ -103,3 +101,25 @@
         }
     }
 ]
+
+# meta l4proto 6 tproxy ip6 to :50080
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+            "family": "ip6",
+            "port": 50080
+        }
+    }
+]
+
diff --git a/tests/py/ip6/tproxy.t.json.output b/tests/py/ip6/tproxy.t.json.output
new file mode 100644
index 0000000000000..461738bd2061f
--- /dev/null
+++ b/tests/py/ip6/tproxy.t.json.output
@@ -0,0 +1,60 @@
+# meta l4proto 6 tproxy ip6 to [2001:db8::1]
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+            "addr": "2001:db8::1"
+        }
+    }
+]
+
+# meta l4proto 17 tproxy ip6 to [2001:db8::1]:50080
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 17
+        }
+    },
+    {
+        "tproxy": {
+            "addr": "2001:db8::1",
+            "port": 50080
+        }
+    }
+]
+
+# meta l4proto 6 tproxy ip6 to :50080
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "tproxy": {
+            "port": 50080
+        }
+    }
+]
-- 
2.21.0

