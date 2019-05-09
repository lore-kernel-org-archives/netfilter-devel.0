Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F063C04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2108320989
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfEILgR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 07:36:17 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35056 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEILgR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 07:36:17 -0400
Received: from localhost ([::1]:48146 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hOhLU-0000db-6f; Thu, 09 May 2019 13:36:16 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/9] json: Support nat in inet family
Date:   Thu,  9 May 2019 13:35:37 +0200
Message-Id: <20190509113545.4017-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509113545.4017-1-phil@nwl.cc>
References: <20190509113545.4017-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add the missing bits to JSON parser, printer, man page and testsuite.

Fixes: fbe27464dee45 ("src: add nat support for the inet family")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc |   5 ++
 src/json.c                |   8 ++
 src/parser_json.c         |   7 +-
 tests/py/inet/dnat.t.json | 166 ++++++++++++++++++++++++++++++++++++++
 tests/py/inet/snat.t.json | 131 ++++++++++++++++++++++++++++++
 5 files changed, 316 insertions(+), 1 deletion(-)
 create mode 100644 tests/py/inet/dnat.t.json
 create mode 100644 tests/py/inet/snat.t.json

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index dbe5ac33d999e..429f530db913c 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -808,12 +808,14 @@ Duplicate a packet to a different destination.
 ____
 *{ "snat": {
 	"addr":* 'EXPRESSION'*,
+	"family":* 'STRING'*,
 	"port":* 'EXPRESSION'*,
 	"flags":* 'FLAGS'
 *}}*
 
 *{ "dnat": {
 	"addr":* 'EXPRESSION'*,
+	"family":* 'STRING'*,
 	"port":* 'EXPRESSION'*,
 	"flags":* 'FLAGS'
 *}}*
@@ -837,6 +839,9 @@ Perform Network Address Translation.
 
 *addr*::
 	Address to translate to.
+*family*::
+	Family of *addr*, either *ip* or *ip6*. Required in *inet*
+	table family.
 *port*::
 	Port to translate to.
 *flags*::
diff --git a/src/json.c b/src/json.c
index 4900c02336b56..a8538bdca973b 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1260,6 +1260,14 @@ json_t *nat_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	json_t *root = json_object();
 	json_t *array = nat_flags_json(stmt->nat.flags);
 
+	switch (stmt->nat.family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		json_object_set_new(root, "family",
+				    json_string(family2str(stmt->nat.family)));
+		break;
+	}
+
 	if (stmt->nat.addr)
 		json_object_set_new(root, "addr",
 				    expr_print_json(stmt->nat.addr, octx));
diff --git a/src/parser_json.c b/src/parser_json.c
index 315f247811567..0c4f5d913813a 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1840,9 +1840,9 @@ static int nat_type_parse(const char *type)
 static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 					const char *key, json_t *value)
 {
+	int type, familyval;
 	struct stmt *stmt;
 	json_t *tmp;
-	int type;
 
 	type = nat_type_parse(key);
 	if (type < 0) {
@@ -1850,7 +1850,12 @@ static struct stmt *json_parse_nat_stmt(struct json_ctx *ctx,
 		return NULL;
 	}
 
+	familyval = json_parse_family(ctx, value);
+	if (familyval < 0)
+		return NULL;
+
 	stmt = nat_stmt_alloc(int_loc, type);
+	stmt->nat.family = familyval;
 
 	if (!json_unpack(value, "{s:o}", "addr", &tmp)) {
 		stmt->nat.addr = json_parse_stmt_expr(ctx, tmp);
diff --git a/tests/py/inet/dnat.t.json b/tests/py/inet/dnat.t.json
new file mode 100644
index 0000000000000..ac6dac620a85e
--- /dev/null
+++ b/tests/py/inet/dnat.t.json
@@ -0,0 +1,166 @@
+# iifname "foo" tcp dport 80 redirect to :8080
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "foo"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 80
+        }
+    },
+    {
+        "redirect": {
+            "port": 8080
+        }
+    }
+]
+
+# iifname "eth0" tcp dport 443 dnat ip to 192.168.3.2
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "eth0"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 443
+        }
+    },
+    {
+        "dnat": {
+            "addr": "192.168.3.2",
+            "family": "ip"
+        }
+    }
+]
+
+# iifname "eth0" tcp dport 443 dnat ip6 to [dead::beef]:4443
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "eth0"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 443
+        }
+    },
+    {
+        "dnat": {
+            "addr": "dead::beef",
+            "family": "ip6",
+            "port": 4443
+        }
+    }
+]
+
+# dnat ip to ct mark map { 0x00000014 : 1.2.3.4}
+[
+    {
+        "dnat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                20,
+                                "1.2.3.4"
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "ct": {
+                            "key": "mark"
+                        }
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
+[
+    {
+        "dnat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        20,
+                                        "1.1.1.1"
+                                    ]
+                                },
+                                "1.2.3.4"
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "daddr",
+                                    "protocol": "ip"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
diff --git a/tests/py/inet/snat.t.json b/tests/py/inet/snat.t.json
new file mode 100644
index 0000000000000..4671625dc06d9
--- /dev/null
+++ b/tests/py/inet/snat.t.json
@@ -0,0 +1,131 @@
+# iifname "eth0" tcp dport 81 snat ip to 192.168.3.2
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "eth0"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 81
+        }
+    },
+    {
+        "snat": {
+            "addr": "192.168.3.2",
+            "family": "ip"
+        }
+    }
+]
+
+# iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat to 192.168.3.2
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "eth0"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 81
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "10.1.1.1"
+        }
+    },
+    {
+        "snat": {
+            "addr": "192.168.3.2",
+            "family": "ip"
+        }
+    }
+]
+
+# iifname "eth0" tcp dport 81 snat ip6 to dead::beef
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "eth0"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 81
+        }
+    },
+    {
+        "snat": {
+            "addr": "dead::beef",
+            "family": "ip6"
+        }
+    }
+]
+
+# iifname "foo" masquerade random
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iifname"
+                }
+            },
+            "op": "==",
+            "right": "foo"
+        }
+    },
+    {
+        "masquerade": {
+            "flags": "random"
+        }
+    }
+]
+
-- 
2.21.0

