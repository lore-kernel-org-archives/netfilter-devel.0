Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D932D157A6C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897942; cv=none; b=aD/TlX7DUaLIYLBFJLXJ27tOJjb1JkVBuemBYJ6CvTRzk20kb+mr4uFRFizSniKvoe85sRUTWstFYIMPRc9o8c8J76C9um+OHG7YJZPjKXR7URUbF5QVPfJxL+IA5AkE4rTwZ6i/ugvY+l3YHYJt9ez1yNfrUYNJYfRsevK6dso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897942; c=relaxed/simple;
	bh=3s293thHo04txU8rSKHspo6pIl/l/RC0RuDJjRyzO2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjG4wmRQlwfbSTpbvm9dItFpK+UHWAjqjkpSiknhnWb0hF/DM+lhjwRDzZTZgS9HYy/nE/8fJd7EnxJIjsZ142V6cosAYS5+Phx+A8BJSN7Mcbza5nhO0QMSeRatTJ7NNEVNtsqsrsZqeCl8V+g6GlApG8oQ40jDBrYSeRGN5FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Q0vIyk8h; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Q0vIyk8h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C0e8tUF8zM2X/jOtO8ofNlxinbhLsF+r1tJKBbCpDi8=; b=Q0vIyk8hPHtXu3GToPr++9LFpS
	eX/YBtgu4AoSV6ZRfQjAdSyfht4c4u5Q27U2puh3rJZQJki0Bz5EGtNN0PxHktyCoXGcgrDnTKfyG
	9hYDCBFoUnCQ+SoablI3bnHHFEAmGikaGZaoer8T1s9k0cn3Zz5av+FMBwiGhhha8DmnpXyMsFswu
	+d7VJPJf7BBUei/PMmVDtVOq0UAWQyAZIBqgyFrInbAIAMt5q+P1TOTS6Ssu5GvDN6khRgVVk3T0V
	2OYEw2zuVvBSGOzg+U3MR9546c4UlGVakRTHHyAYTrMpbXtweEoodNQZypHDTimpFITHGEp8w8yJm
	Gdr69FMg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5BZ-0000000030U-1QhF;
	Wed, 02 Oct 2024 21:38:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/9] json: Support typeof in set and map types
Date: Wed,  2 Oct 2024 21:38:45 +0200
Message-ID: <20241002193853.13818-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement this as a special "type" property value which is an object
with sole property "typeof". The latter's value is the JSON
representation of the expression in set->key, so for concatenated
typeofs it is a concat expression.

All this is a bit clumsy right now but it works and it should be
possible to tear it down a bit for more user-friendliness in a
compatible way by either replacing the concat expression by the array it
contains or even the whole "typeof" object - the parser would just
assume any object (or objects in an array) in the "type" property value
are expressions to extract a type from.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/libnftables-json.adoc                     |  7 ++-
 src/json.c                                    | 13 ++++-
 src/parser_json.c                             |  9 +++
 tests/monitor/testcases/map-expr.t            |  2 +-
 tests/monitor/testcases/set-concat-interval.t |  3 +
 .../maps/dumps/0012map_concat_0.json-nft      | 21 +++++--
 .../maps/dumps/0017_map_variable_0.json-nft   | 18 +++++-
 .../maps/dumps/named_limits.json-nft          | 55 ++++++++++++++++---
 .../dumps/typeof_maps_add_delete.json-nft     |  9 ++-
 .../maps/dumps/typeof_maps_update_0.json-nft  |  9 ++-
 .../maps/dumps/vmap_timeout.json-nft          | 22 ++++++--
 .../packetpath/dumps/set_lookups.json-nft     | 42 +++++++++++---
 .../sets/dumps/0048set_counters_0.json-nft    |  9 ++-
 .../testcases/sets/dumps/inner_0.json-nft     | 34 ++++++++++--
 .../set_element_timeout_updates.json-nft      |  9 ++-
 15 files changed, 222 insertions(+), 40 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index a8a6165fde59d..593d407c924e9 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -341,7 +341,7 @@ ____
 	"auto-merge":* 'BOOLEAN'
 *}}*
 
-'SET_TYPE' := 'STRING' | *[* 'SET_TYPE_LIST' *]*
+'SET_TYPE' := 'STRING' | *[* 'SET_TYPE_LIST' *]* | *{ "typeof":* 'EXPRESSION' *}*
 'SET_TYPE_LIST' := 'STRING' [*,* 'SET_TYPE_LIST' ]
 'SET_POLICY' := *"performance"* | *"memory"*
 'SET_FLAG_LIST' := 'SET_FLAG' [*,* 'SET_FLAG_LIST' ]
@@ -381,8 +381,9 @@ that they translate a unique key to a value.
 	Automatic merging of adjacent/overlapping set elements in interval sets.
 
 ==== TYPE
-The set type might be a string, such as *"ipv4_addr"* or an array
-consisting of strings (for concatenated types).
+The set type might be a string, such as *"ipv4_addr"*, an array
+consisting of strings (for concatenated types) or a *typeof* object containing
+an expression to extract the type from.
 
 ==== ELEM
 A single set element might be given as string, integer or boolean value for
diff --git a/src/json.c b/src/json.c
index b1531ff3f4c9e..1f609bf2b03e9 100644
--- a/src/json.c
+++ b/src/json.c
@@ -96,6 +96,17 @@ static json_t *set_dtype_json(const struct expr *key)
 	return root;
 }
 
+static json_t *set_key_dtype_json(const struct set *set,
+				  struct output_ctx *octx)
+{
+	bool use_typeof = set->key_typeof_valid;
+
+	if (!use_typeof)
+		return set_dtype_json(set->key);
+
+	return json_pack("{s:o}", "typeof", expr_print_json(set->key, octx));
+}
+
 static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 {
 	char buf[1024];
@@ -158,7 +169,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 			"family", family2str(set->handle.family),
 			"name", set->handle.set.name,
 			"table", set->handle.table.name,
-			"type", set_dtype_json(set->key),
+			"type", set_key_dtype_json(set, octx),
 			"handle", set->handle.handle.id);
 
 	if (set->comment)
diff --git a/src/parser_json.c b/src/parser_json.c
index bbe3b1c59192c..f8200db1fe114 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1729,7 +1729,16 @@ static struct expr *json_parse_dtype_expr(struct json_ctx *ctx, json_t *root)
 			compound_expr_add(expr, i);
 		}
 		return expr;
+	} else if (json_is_object(root)) {
+		const char *key;
+		json_t *val;
+
+		if (!json_unpack_stmt(ctx, root, &key, &val) &&
+		    !strcmp(key, "typeof")) {
+			return json_parse_expr(ctx, val);
+		}
 	}
+
 	json_error(ctx, "Invalid set datatype.");
 	return NULL;
 }
diff --git a/tests/monitor/testcases/map-expr.t b/tests/monitor/testcases/map-expr.t
index 8729c0b44ee2c..d11ad0ebc0d57 100644
--- a/tests/monitor/testcases/map-expr.t
+++ b/tests/monitor/testcases/map-expr.t
@@ -3,4 +3,4 @@ I add table ip t
 I add map ip t m { typeof meta day . meta hour : verdict; flags interval; counter; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"map": {"family": "ip", "name": "m", "table": "t", "type": ["day", "hour"], "handle": 0, "map": "verdict", "flags": ["interval"], "stmt": [{"counter": null}]}}}
+J {"add": {"map": {"family": "ip", "name": "m", "table": "t", "type": {"typeof": {"concat": [{"meta": {"key": "day"}}, {"meta": {"key": "hour"}}]}}, "handle": 0, "map": "verdict", "flags": ["interval"], "stmt": [{"counter": null}]}}}
diff --git a/tests/monitor/testcases/set-concat-interval.t b/tests/monitor/testcases/set-concat-interval.t
index 763dc319f0d13..3542b8225ebd1 100644
--- a/tests/monitor/testcases/set-concat-interval.t
+++ b/tests/monitor/testcases/set-concat-interval.t
@@ -10,3 +10,6 @@ I add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; elem
 O add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; }
 O add element ip t s { 20-80 . 0x14 : accept }
 O add element ip t s { 1-10 . 0xa : drop }
+J {"add": {"map": {"family": "ip", "name": "s", "table": "t", "type": {"typeof": {"concat": [{"payload": {"protocol": "udp", "field": "length"}}, {"payload": {"base": "ih", "offset": 32, "len": 32}}]}}, "handle": 0, "map": "verdict", "flags": ["interval"]}}}
+J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [20, 80]}, 20]}, {"accept": null}]]}}}}
+J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [1, 10]}, 10]}, {"drop": null}]]}}}}
diff --git a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
index 000522365df9f..88bf4984dbde7 100644
--- a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
@@ -31,10 +31,23 @@
         "family": "ip",
         "name": "w",
         "table": "x",
-        "type": [
-          "ipv4_addr",
-          "mark"
-        ],
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              {
+                "meta": {
+                  "key": "mark"
+                }
+              }
+            ]
+          }
+        },
         "handle": 0,
         "map": "verdict",
         "flags": [
diff --git a/tests/shell/testcases/maps/dumps/0017_map_variable_0.json-nft b/tests/shell/testcases/maps/dumps/0017_map_variable_0.json-nft
index 725498cdcbef8..8eacf612d12fb 100644
--- a/tests/shell/testcases/maps/dumps/0017_map_variable_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0017_map_variable_0.json-nft
@@ -19,7 +19,14 @@
         "family": "ip",
         "name": "y",
         "table": "x",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "map": "mark",
         "elem": [
@@ -39,7 +46,14 @@
         "family": "ip",
         "name": "z",
         "table": "x",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "map": "mark",
         "elem": [
diff --git a/tests/shell/testcases/maps/dumps/named_limits.json-nft b/tests/shell/testcases/maps/dumps/named_limits.json-nft
index 7fa1298103832..3c6845ac43b42 100644
--- a/tests/shell/testcases/maps/dumps/named_limits.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_limits.json-nft
@@ -75,7 +75,14 @@
         "family": "inet",
         "name": "tarpit4",
         "table": "filter",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "size": 10000,
         "flags": [
@@ -90,7 +97,14 @@
         "family": "inet",
         "name": "tarpit6",
         "table": "filter",
-        "type": "ipv6_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip6",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "size": 10000,
         "flags": [
@@ -105,11 +119,29 @@
         "family": "inet",
         "name": "addr4limit",
         "table": "filter",
-        "type": [
-          "inet_proto",
-          "ipv4_addr",
-          "inet_service"
-        ],
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "meta": {
+                  "key": "l4proto"
+                }
+              },
+              {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "sport"
+                }
+              }
+            ]
+          }
+        },
         "handle": 0,
         "map": "limit",
         "flags": [
@@ -244,7 +276,14 @@
         "family": "inet",
         "name": "saddr6limit",
         "table": "filter",
-        "type": "ipv6_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip6",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "map": "limit",
         "flags": [
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
index b3204a283d0ad..effe02dcf8364 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
@@ -39,7 +39,14 @@
         "family": "ip",
         "name": "dynmark",
         "table": "dynset",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "daddr"
+            }
+          }
+        },
         "handle": 0,
         "map": "mark",
         "size": 64,
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
index 1d50477d783df..731514663b1aa 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
@@ -50,7 +50,14 @@
         "family": "ip",
         "name": "sticky-set-svc-153CN2XYVUHRQ7UB",
         "table": "kube-nfproxy-v4",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "daddr"
+            }
+          }
+        },
         "handle": 0,
         "map": "mark",
         "size": 65535,
diff --git a/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
index 1c3aa590f846e..71e9a9ee9f21b 100644
--- a/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
+++ b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
@@ -87,10 +87,24 @@
         "family": "inet",
         "name": "portaddrmap",
         "table": "filter",
-        "type": [
-          "ipv4_addr",
-          "inet_service"
-        ],
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "daddr"
+                }
+              },
+              {
+                "payload": {
+                  "protocol": "th",
+                  "field": "dport"
+                }
+              }
+            ]
+          }
+        },
         "handle": 0,
         "map": "verdict",
         "flags": [
diff --git a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
index 24363f9071b22..bcf6914e95cb9 100644
--- a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
+++ b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
@@ -60,10 +60,23 @@
         "family": "ip",
         "name": "s2",
         "table": "t",
-        "type": [
-          "ipv4_addr",
-          "iface_index"
-        ],
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              {
+                "meta": {
+                  "key": "iif"
+                }
+              }
+            ]
+          }
+        },
         "handle": 0,
         "elem": [
           {
@@ -113,10 +126,23 @@
         "family": "ip",
         "name": "nomatch",
         "table": "t",
-        "type": [
-          "ipv4_addr",
-          "iface_index"
-        ],
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              {
+                "meta": {
+                  "key": "iif"
+                }
+              }
+            ]
+          }
+        },
         "handle": 0,
         "elem": [
           {
diff --git a/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft b/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft
index 62a6a177b7776..4be4112bf7935 100644
--- a/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft
@@ -31,7 +31,14 @@
         "family": "ip",
         "name": "y",
         "table": "x",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "elem": [
           {
diff --git a/tests/shell/testcases/sets/dumps/inner_0.json-nft b/tests/shell/testcases/sets/dumps/inner_0.json-nft
index 8d84e1ccecb9f..e5dc198f436be 100644
--- a/tests/shell/testcases/sets/dumps/inner_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/inner_0.json-nft
@@ -27,10 +27,26 @@
         "family": "netdev",
         "name": "x",
         "table": "x",
-        "type": [
-          "ipv4_addr",
-          "ipv4_addr"
-        ],
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "payload": {
+                  "tunnel": "vxlan",
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              {
+                "payload": {
+                  "tunnel": "vxlan",
+                  "protocol": "ip",
+                  "field": "daddr"
+                }
+              }
+            ]
+          }
+        },
         "handle": 0,
         "elem": [
           {
@@ -47,7 +63,15 @@
         "family": "netdev",
         "name": "y",
         "table": "x",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "tunnel": "vxlan",
+              "protocol": "ip",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "size": 65535,
         "flags": [
diff --git a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
index aa908297e49ea..d92d8d7a54940 100644
--- a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
+++ b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
@@ -31,7 +31,14 @@
         "family": "ip",
         "name": "s",
         "table": "t",
-        "type": "ipv4_addr",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "ip",
+              "field": "saddr"
+            }
+          }
+        },
         "handle": 0,
         "flags": [
           "timeout"
-- 
2.43.0

