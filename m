Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA50EEB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 11:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjFTL6f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 07:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjFTL6e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 07:58:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C6F810F3
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 04:58:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] json: add inner payload support
Date:   Tue, 20 Jun 2023 13:58:24 +0200
Message-Id: <20230620115824.93461-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for vxlan, geneve, gre and gretap.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/json.c                  |  18 +-
 src/parser_json.c           |  50 +++++-
 tests/py/inet/geneve.t.json | 344 ++++++++++++++++++++++++++++++++++++
 tests/py/inet/gre.t.json    | 177 +++++++++++++++++++
 tests/py/inet/gretap.t.json | 195 ++++++++++++++++++++
 tests/py/inet/vxlan.t.json  | 344 ++++++++++++++++++++++++++++++++++++
 6 files changed, 1122 insertions(+), 6 deletions(-)
 create mode 100644 tests/py/inet/geneve.t.json
 create mode 100644 tests/py/inet/gre.t.json
 create mode 100644 tests/py/inet/gretap.t.json
 create mode 100644 tests/py/inet/vxlan.t.json

diff --git a/src/json.c b/src/json.c
index 305eb6e397fe..21199ca467d6 100644
--- a/src/json.c
+++ b/src/json.c
@@ -573,15 +573,23 @@ json_t *payload_expr_json(const struct expr *expr, struct output_ctx *octx)
 {
 	json_t *root;
 
-	if (payload_is_known(expr))
-		root = json_pack("{s:s, s:s}",
-				 "protocol", expr->payload.desc->name,
-				 "field", expr->payload.tmpl->token);
-	else
+	if (payload_is_known(expr)) {
+		if (expr->payload.inner_desc) {
+			root = json_pack("{s:s, s:s, s:s}",
+					 "tunnel", expr->payload.inner_desc->name,
+					 "protocol", expr->payload.desc->name,
+					 "field", expr->payload.tmpl->token);
+		} else {
+			root = json_pack("{s:s, s:s}",
+					 "protocol", expr->payload.desc->name,
+					 "field", expr->payload.tmpl->token);
+		}
+	} else {
 		root = json_pack("{s:s, s:i, s:i}",
 				 "base", proto_base_tokens[expr->payload.base],
 				 "offset", expr->payload.offset,
 				 "len", expr->len);
+	}
 
 	return json_pack("{s:o}", "payload", root);
 }
diff --git a/src/parser_json.c b/src/parser_json.c
index 605dcc49f715..91b37b58f2bf 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -541,6 +541,27 @@ static const struct proto_desc *proto_lookup_byname(const char *name)
 		&proto_dccp,
 		&proto_sctp,
 		&proto_th,
+		&proto_vxlan,
+		&proto_gre,
+		&proto_gretap,
+		&proto_geneve,
+	};
+	unsigned int i;
+
+	for (i = 0; i < array_size(proto_tbl); i++) {
+		if (!strcmp(proto_tbl[i]->name, name))
+			return proto_tbl[i];
+	}
+	return NULL;
+}
+
+static const struct proto_desc *inner_proto_lookup_byname(const char *name)
+{
+	const struct proto_desc *proto_tbl[] = {
+		&proto_geneve,
+		&proto_gre,
+		&proto_gretap,
+		&proto_vxlan,
 	};
 	unsigned int i;
 
@@ -554,7 +575,7 @@ static const struct proto_desc *proto_lookup_byname(const char *name)
 static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 					    const char *type, json_t *root)
 {
-	const char *protocol, *field, *base;
+	const char *tunnel, *protocol, *field, *base;
 	int offset, len, val;
 	struct expr *expr;
 
@@ -576,6 +597,33 @@ static struct expr *json_parse_payload_expr(struct json_ctx *ctx,
 		payload_init_raw(expr, val, offset, len);
 		expr->byteorder		= BYTEORDER_BIG_ENDIAN;
 		expr->payload.is_raw	= true;
+		return expr;
+	} else if (!json_unpack(root, "{s:s, s:s, s:s}",
+				"tunnel", &tunnel, "protocol", &protocol, "field", &field)) {
+		const struct proto_desc *proto = proto_lookup_byname(protocol);
+		const struct proto_desc *inner_proto = inner_proto_lookup_byname(tunnel);
+
+		if (!inner_proto) {
+			json_error(ctx, "Unknown payload tunnel protocol '%s'.",
+				   tunnel);
+			return NULL;
+		}
+		if (!proto) {
+			json_error(ctx, "Unknown payload protocol '%s'.",
+				   protocol);
+			return NULL;
+		}
+		if (json_parse_payload_field(proto, field, &val)) {
+			json_error(ctx, "Unknown %s field '%s'.",
+				   protocol, field);
+			return NULL;
+		}
+		expr = payload_expr_alloc(int_loc, proto, val);
+		expr->payload.inner_desc = inner_proto;
+
+		if (proto == &proto_th)
+			expr->payload.is_raw = true;
+
 		return expr;
 	} else if (!json_unpack(root, "{s:s, s:s}",
 				"protocol", &protocol, "field", &field)) {
diff --git a/tests/py/inet/geneve.t.json b/tests/py/inet/geneve.t.json
new file mode 100644
index 000000000000..a299fcd2d054
--- /dev/null
+++ b/tests/py/inet/geneve.t.json
@@ -0,0 +1,344 @@
+# udp dport 6081 geneve vni 10
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "vni",
+                    "protocol": "geneve",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": 10
+        }
+    }
+]
+
+# udp dport 6081 geneve ip saddr 10.141.11.2
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": "10.141.11.2"
+        }
+    }
+]
+
+# udp dport 6081 geneve ip saddr 10.141.11.0/24
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": {
+                "prefix": {
+                    "addr": "10.141.11.0",
+                    "len": 24
+                }
+            }
+        }
+    }
+]
+
+# udp dport 6081 geneve ip protocol 1
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# udp dport 6081 geneve udp sport 8888
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sport",
+                    "protocol": "udp",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": 8888
+        }
+    }
+]
+
+# udp dport 6081 geneve icmp type echo-reply
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": "echo-reply"
+        }
+    }
+]
+
+# udp dport 6081 geneve ether saddr 62:87:4d:d6:19:05
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ether",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": "62:87:4d:d6:19:05"
+        }
+    }
+]
+
+# udp dport 6081 geneve vlan id 10
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": 10
+        }
+    }
+]
+
+# udp dport 6081 geneve ip dscp 0x02
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# udp dport 6081 geneve ip dscp 0x02
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "geneve"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# udp dport 6081 geneve ip saddr . geneve ip daddr { 1.2.3.4 . 4.3.2.1 }
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
+            "right": 6081
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip",
+                            "tunnel": "geneve"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip",
+                            "tunnel": "geneve"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            "4.3.2.1"
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/gre.t.json b/tests/py/inet/gre.t.json
new file mode 100644
index 000000000000..c4431764849f
--- /dev/null
+++ b/tests/py/inet/gre.t.json
@@ -0,0 +1,177 @@
+# gre version 0
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "version",
+                    "protocol": "gre"
+                }
+            },
+            "op": "==",
+            "right": 0
+        }
+    }
+]
+
+# gre ip saddr 10.141.11.2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "gre"
+                }
+            },
+            "op": "==",
+            "right": "10.141.11.2"
+        }
+    }
+]
+
+# gre ip saddr 10.141.11.0/24
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "gre"
+                }
+            },
+            "op": "==",
+            "right": {
+                "prefix": {
+                    "addr": "10.141.11.0",
+                    "len": 24
+                }
+            }
+        }
+    }
+]
+
+# gre ip protocol 1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip",
+                    "tunnel": "gre"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# gre udp sport 8888
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sport",
+                    "protocol": "udp",
+                    "tunnel": "gre"
+                }
+            },
+            "op": "==",
+            "right": 8888
+        }
+    }
+]
+
+# gre icmp type echo-reply
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp",
+                    "tunnel": "gre"
+                }
+            },
+            "op": "==",
+            "right": "echo-reply"
+        }
+    }
+]
+
+# gre ip dscp 0x02
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "gre"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# gre ip dscp 0x02
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "gre"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# gre ip saddr . gre ip daddr { 1.2.3.4 . 4.3.2.1 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip",
+                            "tunnel": "gre"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip",
+                            "tunnel": "gre"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            "4.3.2.1"
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/gretap.t.json b/tests/py/inet/gretap.t.json
new file mode 100644
index 000000000000..36fa97825f9a
--- /dev/null
+++ b/tests/py/inet/gretap.t.json
@@ -0,0 +1,195 @@
+# gretap ip saddr 10.141.11.2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": "10.141.11.2"
+        }
+    }
+]
+
+# gretap ip saddr 10.141.11.0/24
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": {
+                "prefix": {
+                    "addr": "10.141.11.0",
+                    "len": 24
+                }
+            }
+        }
+    }
+]
+
+# gretap ip protocol 1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# gretap udp sport 8888
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sport",
+                    "protocol": "udp",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": 8888
+        }
+    }
+]
+
+# gretap icmp type echo-reply
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": "echo-reply"
+        }
+    }
+]
+
+# gretap ether saddr 62:87:4d:d6:19:05
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ether",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": "62:87:4d:d6:19:05"
+        }
+    }
+]
+
+# gretap vlan id 10
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": 10
+        }
+    }
+]
+
+# gretap ip dscp 0x02
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# gretap ip dscp 0x02
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "gretap"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# gretap ip saddr . gretap ip daddr { 1.2.3.4 . 4.3.2.1 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip",
+                            "tunnel": "gretap"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip",
+                            "tunnel": "gretap"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            "4.3.2.1"
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/vxlan.t.json b/tests/py/inet/vxlan.t.json
new file mode 100644
index 000000000000..91b3d29458b3
--- /dev/null
+++ b/tests/py/inet/vxlan.t.json
@@ -0,0 +1,344 @@
+# udp dport 4789 vxlan vni 10
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "vni",
+                    "protocol": "vxlan",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": 10
+        }
+    }
+]
+
+# udp dport 4789 vxlan ip saddr 10.141.11.2
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": "10.141.11.2"
+        }
+    }
+]
+
+# udp dport 4789 vxlan ip saddr 10.141.11.0/24
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": {
+                "prefix": {
+                    "addr": "10.141.11.0",
+                    "len": 24
+                }
+            }
+        }
+    }
+]
+
+# udp dport 4789 vxlan ip protocol 1
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# udp dport 4789 vxlan udp sport 8888
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sport",
+                    "protocol": "udp",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": 8888
+        }
+    }
+]
+
+# udp dport 4789 vxlan icmp type echo-reply
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": "echo-reply"
+        }
+    }
+]
+
+# udp dport 4789 vxlan ether saddr 62:87:4d:d6:19:05
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ether",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": "62:87:4d:d6:19:05"
+        }
+    }
+]
+
+# udp dport 4789 vxlan vlan id 10
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": 10
+        }
+    }
+]
+
+# udp dport 4789 vxlan ip dscp 0x02
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# udp dport 4789 vxlan ip dscp 0x02
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip",
+                    "tunnel": "vxlan"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# udp dport 4789 vxlan ip saddr . vxlan ip daddr { 1.2.3.4 . 4.3.2.1 }
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
+            "right": 4789
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip",
+                            "tunnel": "vxlan"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip",
+                            "tunnel": "vxlan"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.2.3.4",
+                            "4.3.2.1"
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
-- 
2.30.2

