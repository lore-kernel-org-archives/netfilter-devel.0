Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C16F28D827
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104767; cv=none; b=uVr/vgvqwQg62FurhUbfyTeZ4qD8Qhk0OATzkLtkxjOnXfw+EkTEBuZDio4u5JAMz4Gmtx0aXBh3ptkMvNvMC3yH9h/GJFNN6VsDc3llMMhpb1zt98/DoJXS7X542LrlxhfCzsAcetzuxVYmPEEX5YXZpmZ/GmMHo6EdKkDpYVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104767; c=relaxed/simple;
	bh=WsRyWzWPgZKiS3dVZERG7CDW5xQty5teOW8wzg0uWYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlZDPqLAYdTlVSrgYs9YgEZYgHFL+GE2Ai5mu60DysKAU6WtzLKWl5GAe2IBe9IWdQy4oONGZI6AVsnaoko4uSp3lDN2oR3nZgbVaE4qm/3RHfQEZEdTIBGZqT2Uso4+kigFSXLBTDIAhF9UQTKKkvCTUwaMwFGe63YRTkwzH8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hM2JvrF1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hM2JvrF1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nyYB+N8UV2pdEGzNIZ3y543/FPRLzjZAMGzZUwctywQ=; b=hM2JvrF137QZM4IkbTa1cqAb0u
	Q7HZenp1knMkyRixxuhEe0sPaI8xtu3iUdez4PAkZWwzm34dZEuDME6sHIFzy32bSWqjchWfeXupz
	wc1m3vgL2Q81V5/6M9bdSZnQFeRavtmC2IiH9r1NIQ8Nf59KaMheOYnEN7ZsGFeiGQLavRf14/KTT
	jlqvYzHutf930e2F5i6QFeUbFgeigrKxUWWeoBr2XrEPPAbBaNJh8aAJx/n+2f7aPM6cdcCSA5QOa
	D7eFrQ88oYnPzSPBgAFye73z17WbP2ff8nt7btrxEYaFu8sSeQ4jpVIuJf0FIDDK7zLesuvZMF/gg
	4a2qJdEA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvJ-000000003oU-4AQR;
	Wed, 13 Aug 2025 19:06:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 14/14] json: Do not reduce single-item arrays on output
Date: Wed, 13 Aug 2025 19:05:49 +0200
Message-ID: <20250813170549.27880-15-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a partial revert of commit a740f2036ad0d ("json: Introduce
json_add_array_new()"), keeping the function but eliminating its primary
task which is to replace arrays of size 1 by their only item. While
support for this on input is convenient for users, it means extra casing
in JSON output parsers to cover for it. The minor reduction in output
size does not justify that.

Fixes: a740f2036ad0d ("json: Introduce json_add_array_new()")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1806
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c                                    |   8 +-
 tests/py/any/log.t.json.output                |  15 ++-
 tests/py/any/queue.t.json.output              | 117 +++++++++++++++++
 tests/py/inet/fib.t.json                      |   8 +-
 tests/py/inet/fib.t.json.output               |  87 ++++++++++++-
 tests/py/inet/snat.t.json.output              |  22 ++++
 tests/py/inet/synproxy.t.json                 |   8 +-
 tests/py/inet/synproxy.t.json.output          |   8 +-
 tests/py/ip/masquerade.t.json.output          |  46 +++++++
 tests/py/ip/redirect.t.json.output            | 118 ++++++++++++++++++
 tests/py/ip/snat.t.json.output                |   8 +-
 tests/py/ip6/masquerade.t.json.output         |  46 +++++++
 tests/py/ip6/redirect.t.json.output           |  70 +++++++++++
 .../cache/dumps/0002_interval_0.json-nft      |   4 +-
 .../netdev_chain_dormant_autoremove.json-nft  |   4 +-
 .../json/dumps/0001set_statements_0.json-nft  |   4 +-
 tests/shell/testcases/json/single_flag        |  48 +++----
 .../listing/dumps/0010sets_0.json-nft         |   8 +-
 .../listing/dumps/0012sets_0.json-nft         |   8 +-
 .../listing/dumps/0022terse_0.json-nft        |   4 +-
 ...5interval_map_add_many_elements_0.json-nft |   4 +-
 .../dumps/0006interval_map_overlap_0.json-nft |   4 +-
 .../dumps/0008interval_map_delete_0.json-nft  |   4 +-
 .../maps/dumps/0012map_concat_0.json-nft      |   4 +-
 .../testcases/maps/dumps/0013map_0.json-nft   |   4 +-
 .../maps/dumps/delete_element.json-nft        |   4 +-
 .../dumps/delete_element_catchall.json-nft    |   4 +-
 .../maps/dumps/map_with_flags_0.json-nft      |   4 +-
 .../maps/dumps/named_ct_objects.json-nft      |   8 +-
 .../maps/dumps/named_limits.json-nft          |   8 +-
 .../maps/dumps/pipapo_double_flush.json-nft   |   4 +-
 .../maps/dumps/typeof_integer_0.json-nft      |   4 +-
 .../dumps/typeof_maps_add_delete.json-nft     |   4 +-
 .../maps/dumps/typeof_maps_update_0.json-nft  |   8 +-
 .../maps/dumps/vmap_timeout.json-nft          |   8 +-
 .../testcases/maps/dumps/vmap_unary.json-nft  |   4 +-
 .../dumps/0012different_defines_0.json-nft    |   8 +-
 .../nft-f/dumps/0025empty_dynset_0.json-nft   |  12 +-
 .../testcases/nft-i/dumps/set_0.json-nft      |   4 +-
 .../optimizations/dumps/merge_vmaps.json-nft  |   4 +-
 .../dumps/skip_unsupported.json-nft           |   4 +-
 .../packetpath/dumps/set_lookups.json-nft     |   8 +-
 .../dumps/0004replace_0.json-nft              |   4 +-
 .../dumps/0011reset_0.json-nft                |   4 +-
 .../sets/dumps/0001named_interval_0.json-nft  |  16 ++-
 .../0002named_interval_automerging_0.json-nft |   4 +-
 .../0004named_interval_shadow_0.json-nft      |   4 +-
 .../0005named_interval_shadow_0.json-nft      |   4 +-
 .../dumps/0008comments_interval_0.json-nft    |   4 +-
 .../dumps/0009comments_timeout_0.json-nft     |   4 +-
 .../sets/dumps/0015rulesetflush_0.json-nft    |   4 +-
 .../dumps/0022type_selective_flush_0.json-nft |   4 +-
 .../sets/dumps/0024synproxy_0.json-nft        |   4 +-
 .../sets/dumps/0027ipv6_maps_ipv4_0.json-nft  |   4 +-
 .../sets/dumps/0028autoselect_0.json-nft      |  12 +-
 .../sets/dumps/0028delete_handle_0.json-nft   |   4 +-
 .../dumps/0032restore_set_simple_0.json-nft   |   8 +-
 .../dumps/0033add_set_simple_flat_0.json-nft  |   8 +-
 .../sets/dumps/0034get_element_0.json-nft     |  12 +-
 .../0035add_set_elements_flat_0.json-nft      |   4 +-
 .../sets/dumps/0038meter_list_0.json-nft      |   4 +-
 .../sets/dumps/0039delete_interval_0.json-nft |   4 +-
 .../0040get_host_endian_elements_0.json-nft   |   4 +-
 .../sets/dumps/0041interval_0.json-nft        |   4 +-
 .../sets/dumps/0042update_set_0.json-nft      |   4 +-
 .../dumps/0043concatenated_ranges_1.json-nft  |   8 +-
 .../dumps/0044interval_overlap_1.json-nft     |   4 +-
 .../sets/dumps/0046netmap_0.json-nft          |  16 ++-
 .../sets/dumps/0049set_define_0.json-nft      |   4 +-
 .../dumps/0051set_interval_counter_0.json-nft |   4 +-
 .../sets/dumps/0052overlap_0.json-nft         |   4 +-
 .../sets/dumps/0054comments_set_0.json-nft    |   8 +-
 .../sets/dumps/0055tcpflags_0.json-nft        |   4 +-
 .../sets/dumps/0060set_multistmt_1.json-nft   |   4 +-
 .../sets/dumps/0062set_connlimit_0.json-nft   |   8 +-
 .../sets/dumps/0063set_catchall_0.json-nft    |   4 +-
 .../sets/dumps/0064map_catchall_0.json-nft    |   4 +-
 .../sets/dumps/0069interval_merge_0.json-nft  |   4 +-
 .../0071unclosed_prefix_interval_0.json-nft   |   8 +-
 .../sets/dumps/0073flat_interval_set.json-nft |   4 +-
 .../dumps/0074nested_interval_set.json-nft    |   4 +-
 .../sets/dumps/concat_interval_0.json-nft     |   8 +-
 .../sets/dumps/concat_nlmsg_overrun.json-nft  |   4 +-
 .../sets/dumps/dynset_missing.json-nft        |   4 +-
 .../sets/dumps/exact_overlap_0.json-nft       |   4 +-
 .../testcases/sets/dumps/inner_0.json-nft     |   4 +-
 .../sets/dumps/interval_size.json-nft         |   8 +-
 .../sets/dumps/meter_set_reuse.json-nft       |   4 +-
 .../dumps/range_with_same_start_end.json-nft  |   4 +-
 .../set_element_timeout_updates.json-nft      |   4 +-
 .../testcases/sets/dumps/set_eval_0.json-nft  |   4 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |  12 +-
 .../sets/dumps/typeof_sets_concat.json-nft    |   4 +-
 .../transactions/dumps/0002table_0.json-nft   |   4 +-
 .../transactions/dumps/0037set_0.json-nft     |   4 +-
 .../transactions/dumps/0038set_0.json-nft     |   4 +-
 .../transactions/dumps/0039set_0.json-nft     |   4 +-
 .../transactions/dumps/0047set_0.json-nft     |   4 +-
 .../transactions/dumps/doubled-set.json-nft   |   4 +-
 .../transactions/dumps/table_onoff.json-nft   |   4 +-
 100 files changed, 908 insertions(+), 165 deletions(-)
 create mode 100644 tests/py/inet/snat.t.json.output

diff --git a/src/json.c b/src/json.c
index 977f55667fc20..4c8b4f347627b 100644
--- a/src/json.c
+++ b/src/json.c
@@ -62,14 +62,10 @@ static int json_array_extend_new(json_t *array, json_t *other_array)
 
 static void json_add_array_new(json_t *obj, const char *name, json_t *array)
 {
-	if (json_array_size(array) > 1) {
+	if (json_array_size(array))
 		json_object_set_new(obj, name, array);
-	} else {
-		if (json_array_size(array))
-			json_object_set(obj, name,
-					json_array_get(array, 0));
+	else
 		json_decref(array);
-	}
 }
 
 static json_t *expr_print_json(const struct expr *expr, struct output_ctx *octx)
diff --git a/tests/py/any/log.t.json.output b/tests/py/any/log.t.json.output
index 051c448b6fc75..bec70a3507b80 100644
--- a/tests/py/any/log.t.json.output
+++ b/tests/py/any/log.t.json.output
@@ -9,7 +9,20 @@
 [
     {
         "log": {
-            "flags": "all"
+            "flags": [
+                "all"
+            ]
+        }
+    }
+]
+
+# log flags all
+[
+    {
+        "log": {
+            "flags": [
+                "all"
+            ]
         }
     }
 ]
diff --git a/tests/py/any/queue.t.json.output b/tests/py/any/queue.t.json.output
index 1104d7602ba95..ea3722383f113 100644
--- a/tests/py/any/queue.t.json.output
+++ b/tests/py/any/queue.t.json.output
@@ -7,3 +7,120 @@
     }
 ]
 
+# queue num 4-5 fanout
+[
+    {
+        "queue": {
+            "flags": [
+                "fanout"
+            ],
+            "num": {
+                "range": [
+                    4,
+                    5
+                ]
+            }
+        }
+    }
+]
+
+# queue num 4-5 bypass
+[
+    {
+        "queue": {
+            "flags": [
+                "bypass"
+            ],
+            "num": {
+                "range": [
+                    4,
+                    5
+                ]
+            }
+        }
+    }
+]
+
+# queue flags bypass to numgen inc mod 65536
+[
+    {
+        "queue": {
+            "flags": [
+                "bypass"
+            ],
+            "num": {
+                "numgen": {
+                    "mod": 65536,
+                    "mode": "inc",
+                    "offset": 0
+                }
+            }
+        }
+    }
+]
+
+# queue flags bypass to 65535
+[
+    {
+        "queue": {
+            "flags": [
+                "bypass"
+            ],
+            "num": 65535
+        }
+    }
+]
+
+# queue flags bypass to 1-65535
+[
+    {
+        "queue": {
+            "flags": [
+                "bypass"
+            ],
+            "num": {
+                "range": [
+                    1,
+                    65535
+                ]
+            }
+        }
+    }
+]
+
+# queue flags bypass to oifname map { "eth0" : 0, "ppp0" : 2, "eth1" : 2 }
+[
+    {
+        "queue": {
+            "flags": [
+                "bypass"
+            ],
+            "num": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "eth0",
+                                0
+                            ],
+                            [
+                                "ppp0",
+                                2
+                            ],
+                            [
+                                "eth1",
+                                2
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "meta": {
+                            "key": "oifname"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/fib.t.json b/tests/py/inet/fib.t.json
index 14a6249ad9b2a..2bfe4f70b8392 100644
--- a/tests/py/inet/fib.t.json
+++ b/tests/py/inet/fib.t.json
@@ -100,9 +100,7 @@
         "match": {
             "left": {
                 "fib": {
-                    "flags": [
-                        "daddr"
-                    ],
+                    "flags": "daddr",
                     "result": "check"
                 }
             },
@@ -118,9 +116,7 @@
         "match": {
             "left": {
                 "fib": {
-                    "flags": [
-                        "daddr"
-                    ],
+                    "flags": "daddr",
                     "result": "check"
                 }
             },
diff --git a/tests/py/inet/fib.t.json.output b/tests/py/inet/fib.t.json.output
index e8d016698b93a..d3396dd26daf3 100644
--- a/tests/py/inet/fib.t.json.output
+++ b/tests/py/inet/fib.t.json.output
@@ -43,7 +43,9 @@
         "match": {
             "left": {
                 "fib": {
-                    "flags": "daddr",
+                    "flags": [
+                        "daddr"
+                    ],
                     "result": "check"
                 }
             },
@@ -59,7 +61,9 @@
         "match": {
             "left": {
                 "fib": {
-                    "flags": "daddr",
+                    "flags": [
+                        "daddr"
+                    ],
                     "result": "check"
                 }
             },
@@ -69,3 +73,82 @@
     }
 ]
 
+# fib daddr check vmap { missing : drop, exists : accept }
+[
+    {
+        "vmap": {
+            "data": {
+                "set": [
+                    [
+                        false,
+                        {
+                            "drop": null
+                        }
+                    ],
+                    [
+                        true,
+                        {
+                            "accept": null
+                        }
+                    ]
+                ]
+            },
+            "key": {
+                "fib": {
+                    "flags": [
+                        "daddr"
+                    ],
+                    "result": "check"
+                }
+            }
+        }
+    }
+]
+
+# meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x00000001 }
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        true,
+                                        0
+                                    ]
+                                },
+                                1
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "fib": {
+                                    "flags": [
+                                        "daddr"
+                                    ],
+                                    "result": "check"
+                                }
+                            },
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            }
+                        ]
+                    }
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/snat.t.json.output b/tests/py/inet/snat.t.json.output
new file mode 100644
index 0000000000000..5b9588606c5c3
--- /dev/null
+++ b/tests/py/inet/snat.t.json.output
@@ -0,0 +1,22 @@
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
+            "flags": [
+                "random"
+            ]
+        }
+    }
+]
+
diff --git a/tests/py/inet/synproxy.t.json b/tests/py/inet/synproxy.t.json
index 1dd85a6144db6..b3cec09496d81 100644
--- a/tests/py/inet/synproxy.t.json
+++ b/tests/py/inet/synproxy.t.json
@@ -19,9 +19,7 @@
 [
     {
         "synproxy": {
-            "flags": [
-                "timestamp"
-            ]
+            "flags": "timestamp"
         }
     }
 ]
@@ -56,9 +54,7 @@
 [
     {
         "synproxy": {
-            "flags": [
-                "sack-perm"
-            ]
+            "flags": "sack-perm"
         }
     }
 ]
diff --git a/tests/py/inet/synproxy.t.json.output b/tests/py/inet/synproxy.t.json.output
index e32cdfb885e1b..a1d81bfec92e3 100644
--- a/tests/py/inet/synproxy.t.json.output
+++ b/tests/py/inet/synproxy.t.json.output
@@ -2,7 +2,9 @@
 [
     {
         "synproxy": {
-            "flags": "timestamp"
+            "flags": [
+                "timestamp"
+            ]
         }
     }
 ]
@@ -11,7 +13,9 @@
 [
     {
         "synproxy": {
-            "flags": "sack-perm"
+            "flags": [
+                "sack-perm"
+            ]
         }
     }
 ]
diff --git a/tests/py/ip/masquerade.t.json.output b/tests/py/ip/masquerade.t.json.output
index 58e7e290a1e79..8ca5a426d200a 100644
--- a/tests/py/ip/masquerade.t.json.output
+++ b/tests/py/ip/masquerade.t.json.output
@@ -121,3 +121,49 @@
     }
 ]
 
+# udp dport 53 masquerade random
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
+            "right": 53
+        }
+    },
+    {
+        "masquerade": {
+            "flags": [
+                "random"
+            ]
+        }
+    }
+]
+
+# udp dport 53 masquerade persistent
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
+            "right": 53
+        }
+    },
+    {
+        "masquerade": {
+            "flags": [
+                "persistent"
+            ]
+        }
+    }
+]
+
diff --git a/tests/py/ip/redirect.t.json.output b/tests/py/ip/redirect.t.json.output
index 4646c60a81d89..09f1e48d26c55 100644
--- a/tests/py/ip/redirect.t.json.output
+++ b/tests/py/ip/redirect.t.json.output
@@ -1,3 +1,49 @@
+# udp dport 53 redirect random
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
+            "right": 53
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "random"
+            ]
+        }
+    }
+]
+
+# udp dport 53 redirect persistent
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
+            "right": 53
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "persistent"
+            ]
+        }
+    }
+]
+
 # udp dport 53 redirect random,persistent,fully-random
 [
     {
@@ -144,3 +190,75 @@
     }
 ]
 
+# tcp dport 9128 redirect to :993 random
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 9128
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "random"
+            ],
+            "port": 993
+        }
+    }
+]
+
+# tcp dport 9128 redirect to :993 fully-random
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 9128
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "fully-random"
+            ],
+            "port": 993
+        }
+    }
+]
+
+# tcp dport 9128 redirect to :123 persistent
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 9128
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "persistent"
+            ],
+            "port": 123
+        }
+    }
+]
+
diff --git a/tests/py/ip/snat.t.json.output b/tests/py/ip/snat.t.json.output
index 2a99780131d96..19eba25652015 100644
--- a/tests/py/ip/snat.t.json.output
+++ b/tests/py/ip/snat.t.json.output
@@ -241,8 +241,12 @@
                 }
             },
             "family": "ip",
-            "flags": "netmap",
-            "type_flags": "prefix"
+            "flags": [
+                "netmap"
+            ],
+            "type_flags": [
+                "prefix"
+            ]
         }
     }
 ]
diff --git a/tests/py/ip6/masquerade.t.json.output b/tests/py/ip6/masquerade.t.json.output
index 31d0cd9a7e4b5..21ed4f63d1dbd 100644
--- a/tests/py/ip6/masquerade.t.json.output
+++ b/tests/py/ip6/masquerade.t.json.output
@@ -96,3 +96,49 @@
     }
 ]
 
+# udp dport 53 masquerade random
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
+            "right": 53
+        }
+    },
+    {
+        "masquerade": {
+            "flags": [
+                "random"
+            ]
+        }
+    }
+]
+
+# udp dport 53 masquerade persistent
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
+            "right": 53
+        }
+    },
+    {
+        "masquerade": {
+            "flags": [
+                "persistent"
+            ]
+        }
+    }
+]
+
diff --git a/tests/py/ip6/redirect.t.json.output b/tests/py/ip6/redirect.t.json.output
index 0174cc7d7b916..69c7b03d6c051 100644
--- a/tests/py/ip6/redirect.t.json.output
+++ b/tests/py/ip6/redirect.t.json.output
@@ -144,3 +144,73 @@
     }
 ]
 
+# udp dport 53 redirect random
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
+            "right": 53
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "random"
+            ]
+        }
+    }
+]
+
+# udp dport 53 redirect persistent
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
+            "right": 53
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "persistent"
+            ]
+        }
+    }
+]
+
+# tcp dport 9128 redirect to :993 random
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": 9128
+        }
+    },
+    {
+        "redirect": {
+            "flags": [
+                "random"
+            ],
+            "port": 993
+        }
+    }
+]
+
diff --git a/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft b/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft
index 5e2b9b420b6db..fa15d658dcd5c 100644
--- a/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft
+++ b/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft b/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft
index 9151d42f17d91..7f1c76c965954 100644
--- a/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft
+++ b/tests/shell/testcases/chains/dumps/netdev_chain_dormant_autoremove.json-nft
@@ -12,7 +12,9 @@
         "family": "netdev",
         "name": "test",
         "handle": 0,
-        "flags": "dormant"
+        "flags": [
+          "dormant"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft b/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
index ecc7eade91a60..91db43e29ea9f 100644
--- a/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
+++ b/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
@@ -34,7 +34,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcases/json/single_flag
index f0a608ad84120..1d70f249a5716 100755
--- a/tests/shell/testcases/json/single_flag
+++ b/tests/shell/testcases/json/single_flag
@@ -47,10 +47,10 @@ JSON_TABLE_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0,
 JSON_TABLE_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_TABLE_1")
 
 STD_TABLE_2=$(sed 's/\(flags dormant\)/\1,persist/' <<< "$STD_TABLE_1")
-JSON_TABLE_2=$(sed 's/\("flags":\) \("dormant"\)/\1 [\2, "persist"]/' <<< "$JSON_TABLE_1")
+JSON_TABLE_2=$(sed 's/\("dormant"\)/\1, "persist"/' <<< "$JSON_TABLE_1_EQUIV")
 
-back_n_forth "$STD_TABLE_1" "$JSON_TABLE_1"
-json_equiv "$JSON_TABLE_1_EQUIV" "$JSON_TABLE_1"
+back_n_forth "$STD_TABLE_1" "$JSON_TABLE_1_EQUIV"
+json_equiv "$JSON_TABLE_1" "$JSON_TABLE_1_EQUIV"
 back_n_forth "$STD_TABLE_2" "$JSON_TABLE_2"
 
 #
@@ -67,10 +67,10 @@ JSON_SET_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}},
 JSON_SET_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SET_1")
 
 STD_SET_2=$(sed 's/\(flags interval\)/\1,timeout/' <<< "$STD_SET_1")
-JSON_SET_2=$(sed 's/\("flags":\) \("interval"\)/\1 [\2, "timeout"]/' <<< "$JSON_SET_1")
+JSON_SET_2=$(sed 's/\("interval"\)/\1, "timeout"/' <<< "$JSON_SET_1_EQUIV")
 
-back_n_forth "$STD_SET_1" "$JSON_SET_1"
-json_equiv "$JSON_SET_1_EQUIV" "$JSON_SET_1"
+back_n_forth "$STD_SET_1" "$JSON_SET_1_EQUIV"
+json_equiv "$JSON_SET_1" "$JSON_SET_1_EQUIV"
 back_n_forth "$STD_SET_2" "$JSON_SET_2"
 
 #
@@ -86,10 +86,10 @@ JSON_FIB_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}},
 JSON_FIB_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_FIB_1")
 
 STD_FIB_2=$(sed 's/\(fib saddr\)/\1 . iif/' <<< "$STD_FIB_1")
-JSON_FIB_2=$(sed 's/\("flags":\) \("saddr"\)/\1 [\2, "iif"]/' <<< "$JSON_FIB_1")
+JSON_FIB_2=$(sed 's/\("saddr"\)/\1, "iif"/' <<< "$JSON_FIB_1_EQUIV")
 
-back_n_forth "$STD_FIB_1" "$JSON_FIB_1"
-json_equiv "$JSON_FIB_1_EQUIV" "$JSON_FIB_1"
+back_n_forth "$STD_FIB_1" "$JSON_FIB_1_EQUIV"
+json_equiv "$JSON_FIB_1" "$JSON_FIB_1_EQUIV"
 back_n_forth "$STD_FIB_2" "$JSON_FIB_2"
 
 #
@@ -105,10 +105,10 @@ JSON_NAT_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}},
 JSON_NAT_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_NAT_1")
 
 STD_NAT_2=$(sed 's/\(persistent\)/random,\1/' <<< "$STD_NAT_1")
-JSON_NAT_2=$(sed 's/\("flags":\) \("persistent"\)/\1 ["random", \2]/' <<< "$JSON_NAT_1")
+JSON_NAT_2=$(sed 's/\("persistent"\)/"random", \1/' <<< "$JSON_NAT_1_EQUIV")
 
-back_n_forth "$STD_NAT_1" "$JSON_NAT_1"
-json_equiv "$JSON_NAT_1_EQUIV" "$JSON_NAT_1"
+back_n_forth "$STD_NAT_1" "$JSON_NAT_1_EQUIV"
+json_equiv "$JSON_NAT_1" "$JSON_NAT_1_EQUIV"
 back_n_forth "$STD_NAT_2" "$JSON_NAT_2"
 
 #
@@ -124,10 +124,10 @@ JSON_LOG_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}},
 JSON_LOG_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_LOG_1")
 
 STD_LOG_2=$(sed 's/\(tcp sequence\)/\1,options/' <<< "$STD_LOG_1")
-JSON_LOG_2=$(sed 's/\("flags":\) \("tcp sequence"\)/\1 [\2, "tcp options"]/' <<< "$JSON_LOG_1")
+JSON_LOG_2=$(sed 's/\("tcp sequence"\)/\1, "tcp options"/' <<< "$JSON_LOG_1_EQUIV")
 
-back_n_forth "$STD_LOG_1" "$JSON_LOG_1"
-json_equiv "$JSON_LOG_1_EQUIV" "$JSON_LOG_1"
+back_n_forth "$STD_LOG_1" "$JSON_LOG_1_EQUIV"
+json_equiv "$JSON_LOG_1" "$JSON_LOG_1_EQUIV"
 back_n_forth "$STD_LOG_2" "$JSON_LOG_2"
 
 #
@@ -143,10 +143,10 @@ JSON_SYNPROXY_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle":
 JSON_SYNPROXY_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SYNPROXY_1")
 
 STD_SYNPROXY_2=$(sed 's/\(sack-perm\)/timestamp \1/' <<< "$STD_SYNPROXY_1")
-JSON_SYNPROXY_2=$(sed 's/\("flags":\) \("sack-perm"\)/\1 ["timestamp", \2]/' <<< "$JSON_SYNPROXY_1")
+JSON_SYNPROXY_2=$(sed 's/\("sack-perm"\)/"timestamp", \1/' <<< "$JSON_SYNPROXY_1_EQUIV")
 
-back_n_forth "$STD_SYNPROXY_1" "$JSON_SYNPROXY_1"
-json_equiv "$JSON_SYNPROXY_1_EQUIV" "$JSON_SYNPROXY_1"
+back_n_forth "$STD_SYNPROXY_1" "$JSON_SYNPROXY_1_EQUIV"
+json_equiv "$JSON_SYNPROXY_1" "$JSON_SYNPROXY_1_EQUIV"
 back_n_forth "$STD_SYNPROXY_2" "$JSON_SYNPROXY_2"
 
 #
@@ -164,10 +164,10 @@ JSON_SYNPROXY_OBJ_1='{"nftables": [{"table": {"family": "ip", "name": "t", "hand
 JSON_SYNPROXY_OBJ_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SYNPROXY_OBJ_1")
 
 STD_SYNPROXY_OBJ_2=$(sed 's/ \(sack-perm\)/timestamp \1/' <<< "$STD_SYNPROXY_OBJ_1")
-JSON_SYNPROXY_OBJ_2=$(sed 's/\("flags":\) \("sack-perm"\)/\1 ["timestamp", \2]/' <<< "$JSON_SYNPROXY_OBJ_1")
+JSON_SYNPROXY_OBJ_2=$(sed 's/\("sack-perm"\)/"timestamp", \1/' <<< "$JSON_SYNPROXY_OBJ_1_EQUIV")
 
-back_n_forth "$STD_SYNPROXY_OBJ_1" "$JSON_SYNPROXY_OBJ_1"
-json_equiv "$JSON_SYNPROXY_OBJ_1_EQUIV" "$JSON_SYNPROXY_OBJ_1"
+back_n_forth "$STD_SYNPROXY_OBJ_1" "$JSON_SYNPROXY_OBJ_1_EQUIV"
+json_equiv "$JSON_SYNPROXY_OBJ_1" "$JSON_SYNPROXY_OBJ_1_EQUIV"
 back_n_forth "$STD_SYNPROXY_OBJ_2" "$JSON_SYNPROXY_OBJ_2"
 
 #
@@ -183,8 +183,8 @@ JSON_QUEUE_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}
 JSON_QUEUE_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_QUEUE_1")
 
 STD_QUEUE_2=$(sed 's/\(bypass\)/\1,fanout/' <<< "$STD_QUEUE_1")
-JSON_QUEUE_2=$(sed 's/\("flags":\) \("bypass"\)/\1 [\2, "fanout"]/' <<< "$JSON_QUEUE_1")
+JSON_QUEUE_2=$(sed 's/\("bypass"\)/\1, "fanout"/' <<< "$JSON_QUEUE_1_EQUIV")
 
-back_n_forth "$STD_QUEUE_1" "$JSON_QUEUE_1"
-json_equiv "$JSON_QUEUE_1_EQUIV" "$JSON_QUEUE_1"
+back_n_forth "$STD_QUEUE_1" "$JSON_QUEUE_1_EQUIV"
+json_equiv "$JSON_QUEUE_1" "$JSON_QUEUE_1_EQUIV"
 back_n_forth "$STD_QUEUE_2" "$JSON_QUEUE_2"
diff --git a/tests/shell/testcases/listing/dumps/0010sets_0.json-nft b/tests/shell/testcases/listing/dumps/0010sets_0.json-nft
index 6aa99b4e16d24..efca892e3667b 100644
--- a/tests/shell/testcases/listing/dumps/0010sets_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0010sets_0.json-nft
@@ -62,7 +62,9 @@
         "table": "test_arp",
         "type": "inet_service",
         "handle": 0,
-        "flags": "constant"
+        "flags": [
+          "constant"
+        ]
       }
     },
     {
@@ -104,7 +106,9 @@
         "table": "filter",
         "type": "inet_service",
         "handle": 0,
-        "flags": "constant"
+        "flags": [
+          "constant"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/listing/dumps/0012sets_0.json-nft b/tests/shell/testcases/listing/dumps/0012sets_0.json-nft
index 6aa99b4e16d24..efca892e3667b 100644
--- a/tests/shell/testcases/listing/dumps/0012sets_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0012sets_0.json-nft
@@ -62,7 +62,9 @@
         "table": "test_arp",
         "type": "inet_service",
         "handle": 0,
-        "flags": "constant"
+        "flags": [
+          "constant"
+        ]
       }
     },
     {
@@ -104,7 +106,9 @@
         "table": "filter",
         "type": "inet_service",
         "handle": 0,
-        "flags": "constant"
+        "flags": [
+          "constant"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/listing/dumps/0022terse_0.json-nft b/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
index 1a33d6888033b..bd6383dac5e37 100644
--- a/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
@@ -33,7 +33,9 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           "10.10.10.10",
           "10.10.11.11"
diff --git a/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft b/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft
index f9ac5bce9315b..d1a4629500533 100644
--- a/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft
@@ -22,7 +22,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft b/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft
index d6b32d0f8204c..1e983219ae0d4 100644
--- a/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft
@@ -22,7 +22,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft b/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
index 09cb6c8578ffb..bd3c6cc7ebf55 100644
--- a/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
@@ -34,7 +34,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "mark",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             "127.0.0.2",
diff --git a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
index 85384c5329614..88bf4984dbde7 100644
--- a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
@@ -50,7 +50,9 @@
         },
         "handle": 0,
         "map": "verdict",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/0013map_0.json-nft b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
index 2c8d21b43f20e..e91a269d8e6e6 100644
--- a/tests/shell/testcases/maps/dumps/0013map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
@@ -38,7 +38,9 @@
         ],
         "handle": 0,
         "map": "verdict",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/delete_element.json-nft b/tests/shell/testcases/maps/dumps/delete_element.json-nft
index 69a0d3a25b7c9..3b7c5f240e245 100644
--- a/tests/shell/testcases/maps/dumps/delete_element.json-nft
+++ b/tests/shell/testcases/maps/dumps/delete_element.json-nft
@@ -40,7 +40,9 @@
         },
         "handle": 0,
         "map": "classid",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/delete_element_catchall.json-nft b/tests/shell/testcases/maps/dumps/delete_element_catchall.json-nft
index 65053f2c50136..48b183f172025 100644
--- a/tests/shell/testcases/maps/dumps/delete_element_catchall.json-nft
+++ b/tests/shell/testcases/maps/dumps/delete_element_catchall.json-nft
@@ -40,7 +40,9 @@
         },
         "handle": 0,
         "map": "classid",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             "*",
diff --git a/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft b/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft
index 94ec5f751ba57..97b7e94e59fa4 100644
--- a/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft
@@ -22,7 +22,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": "timeout"
+        "flags": [
+          "timeout"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
index 5258d87cf6f5f..c0f270e372b24 100644
--- a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
@@ -111,7 +111,9 @@
         },
         "handle": 0,
         "map": "ct expectation",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
@@ -140,7 +142,9 @@
         },
         "handle": 0,
         "map": "ct helper",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/named_limits.json-nft b/tests/shell/testcases/maps/dumps/named_limits.json-nft
index 07e2892915392..3c6845ac43b42 100644
--- a/tests/shell/testcases/maps/dumps/named_limits.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_limits.json-nft
@@ -144,7 +144,9 @@
         },
         "handle": 0,
         "map": "limit",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
@@ -284,7 +286,9 @@
         },
         "handle": 0,
         "map": "limit",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft b/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
index dc793a65f16dd..ef8c3930f8153 100644
--- a/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
+++ b/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
@@ -33,7 +33,9 @@
         ],
         "handle": 0,
         "map": "verdict",
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft b/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft
index 8dea5c170a847..1df729b40a74f 100644
--- a/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft
@@ -48,7 +48,9 @@
         },
         "handle": 0,
         "map": "verdict",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
index 8b18a78d6982f..effe02dcf8364 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
@@ -50,7 +50,9 @@
         "handle": 0,
         "map": "mark",
         "size": 64,
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "timeout": 300,
         "stmt": [
           {
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
index b79237d0838db..731514663b1aa 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
@@ -39,7 +39,9 @@
         "handle": 0,
         "map": "mark",
         "size": 65535,
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "timeout": 360
       }
     },
@@ -59,7 +61,9 @@
         "handle": 0,
         "map": "mark",
         "size": 65535,
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "timeout": 60
       }
     },
diff --git a/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
index 2d7d8cc2306cd..71e9a9ee9f21b 100644
--- a/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
+++ b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
@@ -66,7 +66,9 @@
         "type": "inet_service",
         "handle": 0,
         "map": "verdict",
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "gc-interval": 10,
         "elem": [
           [
@@ -105,7 +107,9 @@
         },
         "handle": 0,
         "map": "verdict",
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "gc-interval": 10,
         "elem": [
           [
diff --git a/tests/shell/testcases/maps/dumps/vmap_unary.json-nft b/tests/shell/testcases/maps/dumps/vmap_unary.json-nft
index 08583f9bc3032..df0a07d9773bf 100644
--- a/tests/shell/testcases/maps/dumps/vmap_unary.json-nft
+++ b/tests/shell/testcases/maps/dumps/vmap_unary.json-nft
@@ -51,7 +51,9 @@
         },
         "handle": 0,
         "map": "verdict",
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
index 1b2e342047f4b..0e7ea228501b4 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
@@ -529,7 +529,9 @@
           {
             "queue": {
               "num": 0,
-              "flags": "bypass"
+              "flags": [
+                "bypass"
+              ]
             }
           }
         ]
@@ -768,7 +770,9 @@
                   }
                 }
               },
-              "flags": "bypass"
+              "flags": [
+                "bypass"
+              ]
             }
           }
         ]
diff --git a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
index 63d6764172ff6..0cde23b00000a 100644
--- a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
@@ -27,7 +27,9 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": "dynamic",
+        "flags": [
+          "dynamic"
+        ],
         "elem": [
           {
             "elem": {
@@ -62,7 +64,9 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
@@ -78,7 +82,9 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": "dynamic",
+        "flags": [
+          "dynamic"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/nft-i/dumps/set_0.json-nft b/tests/shell/testcases/nft-i/dumps/set_0.json-nft
index 61e4b99e40775..da3456eff1871 100644
--- a/tests/shell/testcases/nft-i/dumps/set_0.json-nft
+++ b/tests/shell/testcases/nft-i/dumps/set_0.json-nft
@@ -21,7 +21,9 @@
         "table": "foo",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           "10.1.1.1",
           "10.1.1.2"
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
index f058d6f1db069..e87f1c4c082eb 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
@@ -46,7 +46,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft b/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
index bf5a8cec53630..d6347b1eeed6e 100644
--- a/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
@@ -29,7 +29,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
index 23f4b17fc53c3..bcf6914e95cb9 100644
--- a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
+++ b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
@@ -36,7 +36,9 @@
           "iface_index"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "concat": [
@@ -111,7 +113,9 @@
         "table": "t",
         "type": "iface_index",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           "lo"
         ]
diff --git a/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft b/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
index 811cb73804f5d..767e80f14ff26 100644
--- a/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
+++ b/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
@@ -38,7 +38,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
index e57dee799b4f3..bc242467e22a7 100644
--- a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
+++ b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
@@ -38,7 +38,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic",
+        "flags": [
+          "dynamic"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
index 9200154a6ed85..b9c66a21aa084 100644
--- a/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
@@ -29,7 +29,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "range": [
@@ -53,7 +55,9 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
@@ -77,7 +81,9 @@
         "table": "t",
         "type": "inet_proto",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "range": [
@@ -101,7 +107,9 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "range": [
diff --git a/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft b/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft
index b083ecb52bb52..4c0be67000a02 100644
--- a/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft b/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft
index c79d9ba8518af..c55858fa9c9b9 100644
--- a/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft b/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft
index 464661e62ae14..a75681f36cb8e 100644
--- a/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft
index e7152413d4bb9..c6f5aa68837ce 100644
--- a/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft b/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft
index a67a06707106d..2418b39a76a06 100644
--- a/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft b/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft
index 86d7eb6a4b6b1..6268e216aa03c 100644
--- a/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft
@@ -36,7 +36,9 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
index dcb62eb739d56..c617139235c23 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
@@ -49,7 +49,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 1024,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft b/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
index dd71bb394442d..0af613333592d 100644
--- a/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
@@ -58,7 +58,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "synproxy",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft b/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft
index 75d8b46d86a10..b9251ffa58900 100644
--- a/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft b/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
index 05fc072c3ca7f..5968b2e0c11f0 100644
--- a/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
@@ -34,7 +34,9 @@
         "type": "inet_proto",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
@@ -45,7 +47,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
@@ -56,7 +60,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 1024,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft b/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft
index 9e5f708df3a74..96314141bc084 100644
--- a/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft
@@ -30,7 +30,9 @@
         "table": "test-ip",
         "type": "inet_service",
         "handle": 0,
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "timeout": 10845
       }
     },
diff --git a/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft b/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft
index 7a723150c1a35..4d194bff1b164 100644
--- a/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft
@@ -25,7 +25,9 @@
           "ipv4_addr"
         ],
         "handle": 0,
-        "flags": "timeout"
+        "flags": [
+          "timeout"
+        ]
       }
     },
     {
@@ -38,7 +40,9 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": "timeout"
+        "flags": [
+          "timeout"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft b/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft
index 5697652859078..16684438c37f2 100644
--- a/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft
@@ -25,7 +25,9 @@
           "ipv4_addr"
         ],
         "handle": 0,
-        "flags": "timeout"
+        "flags": [
+          "timeout"
+        ]
       }
     },
     {
@@ -38,7 +40,9 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": "timeout"
+        "flags": [
+          "timeout"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft b/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
index 4f5ba0aaac578..bfc0e4a0f5886 100644
--- a/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           10,
           {
@@ -47,7 +49,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           "10.0.0.1",
           {
@@ -87,7 +91,9 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "concat": [
diff --git a/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft b/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft
index f9fe4e6f113ea..e4c77147b88f6 100644
--- a/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft
@@ -21,7 +21,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
index 6f6555d224371..5b13f59a72615 100644
--- a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
@@ -44,7 +44,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 128,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft
index afa819584e5b3..d6e46aad20a50 100644
--- a/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "range": [
diff --git a/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft b/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft
index 486ca453281e4..4b6cf03c45961 100644
--- a/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "mark",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "range": [
diff --git a/tests/shell/testcases/sets/dumps/0041interval_0.json-nft b/tests/shell/testcases/sets/dumps/0041interval_0.json-nft
index c59a65ae29fd8..14a393305a3f3 100644
--- a/tests/shell/testcases/sets/dumps/0041interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0041interval_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           "192.168.2.196"
         ]
diff --git a/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft b/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
index 3f98e120d19bd..bc1d4cc2284d8 100644
--- a/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
@@ -39,7 +39,9 @@
         "type": "ether_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft
index 5ce063d7e4304..92b59c861de10 100644
--- a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft
@@ -24,7 +24,9 @@
           "ipv6_addr"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "concat": [
@@ -1582,7 +1584,9 @@
           "ipv4_addr"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "concat": [
diff --git a/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft b/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
index 8f82990af70d6..f4aae383524ff 100644
--- a/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           25,
           30,
diff --git a/tests/shell/testcases/sets/dumps/0046netmap_0.json-nft b/tests/shell/testcases/sets/dumps/0046netmap_0.json-nft
index 55f1a2ad28c76..2b67252d6ec40 100644
--- a/tests/shell/testcases/sets/dumps/0046netmap_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0046netmap_0.json-nft
@@ -92,8 +92,12 @@
                   }
                 }
               },
-              "flags": "netmap",
-              "type_flags": "prefix"
+              "flags": [
+                "netmap"
+              ],
+              "type_flags": [
+                "prefix"
+              ]
             }
           }
         ]
@@ -156,8 +160,12 @@
                   }
                 }
               },
-              "flags": "netmap",
-              "type_flags": "prefix"
+              "flags": [
+                "netmap"
+              ],
+              "type_flags": [
+                "prefix"
+              ]
             }
           }
         ]
diff --git a/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft b/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
index 98ccafd463cc4..f8495bab8b0f3 100644
--- a/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
@@ -33,7 +33,9 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "auto-merge": true,
         "elem": [
           "1.1.1.1"
diff --git a/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
index 96cb397f0c584..b468b5f9044ca 100644
--- a/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
@@ -33,7 +33,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft b/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft
index 1ea8ede677aa3..96d5fbccd7d40 100644
--- a/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft
@@ -21,7 +21,9 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "auto-merge": true,
         "elem": [
           "10.10.10.10",
diff --git a/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft b/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft
index a729392270c01..3fd6d37e18103 100644
--- a/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft
@@ -22,7 +22,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "comment": "test",
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     },
     {
@@ -34,7 +36,9 @@
         "handle": 0,
         "comment": "another test",
         "map": "ipv4_addr",
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
index 0232ad6f28e3b..e37139f334466 100644
--- a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
@@ -21,7 +21,9 @@
         "table": "test",
         "type": "tcp_flag",
         "handle": 0,
-        "flags": "constant",
+        "flags": [
+          "constant"
+        ],
         "elem": [
           {
             "|": [
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
index 99805e553da0e..6098dc563141f 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
@@ -34,7 +34,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic",
+        "flags": [
+          "dynamic"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft b/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
index 7a948b1da0cff..c5e60e36c89ea 100644
--- a/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
@@ -22,7 +22,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
@@ -33,7 +35,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic",
+        "flags": [
+          "dynamic"
+        ],
         "stmt": [
           {
             "ct count": {
diff --git a/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft b/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft
index fcfe9830f3600..3006f75a8fcc6 100644
--- a/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft
@@ -55,7 +55,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft b/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
index b7496ac853f10..64dd26670528b 100644
--- a/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
@@ -50,7 +50,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft b/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft
index 7868cb3359160..d7b32f8cc0e24 100644
--- a/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft
@@ -21,7 +21,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "auto-merge": true,
         "elem": [
           {
diff --git a/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
index 588c2b1b6689c..6b579a2e09fff 100644
--- a/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
@@ -29,7 +29,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
@@ -53,7 +55,9 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft b/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft
index e4649a7d0c22e..e2fb6214238fa 100644
--- a/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft
+++ b/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft
@@ -32,7 +32,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "counter",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft b/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft
index e4649a7d0c22e..e2fb6214238fa 100644
--- a/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft
+++ b/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft
@@ -32,7 +32,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "counter",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft b/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft
index 3283f26958f71..d65065e4f0947 100644
--- a/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft
@@ -25,7 +25,9 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "stmt": [
           {
             "counter": null
@@ -43,7 +45,9 @@
           "mark"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "concat": [
diff --git a/tests/shell/testcases/sets/dumps/concat_nlmsg_overrun.json-nft b/tests/shell/testcases/sets/dumps/concat_nlmsg_overrun.json-nft
index 2a8d233e81d26..db9f547b45c87 100644
--- a/tests/shell/testcases/sets/dumps/concat_nlmsg_overrun.json-nft
+++ b/tests/shell/testcases/sets/dumps/concat_nlmsg_overrun.json-nft
@@ -25,7 +25,9 @@
           "ipv4_addr"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/dynset_missing.json-nft b/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
index 9de5b821f79e7..ad8a7cc0564a8 100644
--- a/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
+++ b/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
@@ -34,7 +34,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft b/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft
index 7bba69d54556a..958d1e5cf6caf 100644
--- a/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/inner_0.json-nft b/tests/shell/testcases/sets/dumps/inner_0.json-nft
index 581d534012e44..e5dc198f436be 100644
--- a/tests/shell/testcases/sets/dumps/inner_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/inner_0.json-nft
@@ -74,7 +74,9 @@
         },
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/interval_size.json-nft b/tests/shell/testcases/sets/dumps/interval_size.json-nft
index 96fc54fc811c6..3ae54e0815378 100644
--- a/tests/shell/testcases/sets/dumps/interval_size.json-nft
+++ b/tests/shell/testcases/sets/dumps/interval_size.json-nft
@@ -29,7 +29,9 @@
         },
         "handle": 0,
         "size": 1,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "auto-merge": true,
         "elem": [
           {
@@ -56,7 +58,9 @@
         },
         "handle": 0,
         "size": 1,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           "0.0.0.0"
         ]
diff --git a/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft b/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
index 9210c90b158d4..ab4ac06184d03 100644
--- a/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
+++ b/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
@@ -33,7 +33,9 @@
         ],
         "handle": 0,
         "size": 65535,
-        "flags": "dynamic"
+        "flags": [
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
index e1daa8f86529f..c4682475917e5 100644
--- a/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
+++ b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
@@ -21,7 +21,9 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           10,
           30,
diff --git a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
index acb2f1f4944ac..d92d8d7a54940 100644
--- a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
+++ b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
@@ -40,7 +40,9 @@
           }
         },
         "handle": 0,
-        "flags": "timeout",
+        "flags": [
+          "timeout"
+        ],
         "timeout": 60
       }
     }
diff --git a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
index 6f4f4c61600b2..6f692381b6f7c 100644
--- a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
@@ -33,7 +33,9 @@
         "table": "nat",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
index 77ca50868f26f..ac4284293c32a 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
@@ -71,7 +71,9 @@
         "table": "testifsets",
         "type": "ifname",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           "abcdef*",
           "othername",
@@ -115,7 +117,9 @@
           "ifname"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "concat": [
@@ -162,7 +166,9 @@
         "type": "ifname",
         "handle": 0,
         "map": "verdict",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             "abcdef*",
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_concat.json-nft b/tests/shell/testcases/sets/dumps/typeof_sets_concat.json-nft
index ffb97f77288f4..144cd743ac7c9 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_concat.json-nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_concat.json-nft
@@ -199,7 +199,9 @@
         },
         "handle": 0,
         "size": 16,
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/transactions/dumps/0002table_0.json-nft b/tests/shell/testcases/transactions/dumps/0002table_0.json-nft
index b1fefc31e1f0a..70960a94204a3 100644
--- a/tests/shell/testcases/transactions/dumps/0002table_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0002table_0.json-nft
@@ -12,7 +12,9 @@
         "family": "ip",
         "name": "x",
         "handle": 0,
-        "flags": "dormant"
+        "flags": [
+          "dormant"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/transactions/dumps/0037set_0.json-nft b/tests/shell/testcases/transactions/dumps/0037set_0.json-nft
index f9fe4e6f113ea..e4c77147b88f6 100644
--- a/tests/shell/testcases/transactions/dumps/0037set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0037set_0.json-nft
@@ -21,7 +21,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval"
+        "flags": [
+          "interval"
+        ]
       }
     }
   ]
diff --git a/tests/shell/testcases/transactions/dumps/0038set_0.json-nft b/tests/shell/testcases/transactions/dumps/0038set_0.json-nft
index 5f97d09e82c6c..0a36f4a809a0d 100644
--- a/tests/shell/testcases/transactions/dumps/0038set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0038set_0.json-nft
@@ -21,7 +21,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/transactions/dumps/0039set_0.json-nft b/tests/shell/testcases/transactions/dumps/0039set_0.json-nft
index 5f97d09e82c6c..0a36f4a809a0d 100644
--- a/tests/shell/testcases/transactions/dumps/0039set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0039set_0.json-nft
@@ -21,7 +21,9 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/transactions/dumps/0047set_0.json-nft b/tests/shell/testcases/transactions/dumps/0047set_0.json-nft
index fb6348f229b57..a7e677b2e702c 100644
--- a/tests/shell/testcases/transactions/dumps/0047set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0047set_0.json-nft
@@ -22,7 +22,9 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "classid",
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           [
             "10.1.26.2",
diff --git a/tests/shell/testcases/transactions/dumps/doubled-set.json-nft b/tests/shell/testcases/transactions/dumps/doubled-set.json-nft
index 1b9af211945ec..2dced1240528f 100644
--- a/tests/shell/testcases/transactions/dumps/doubled-set.json-nft
+++ b/tests/shell/testcases/transactions/dumps/doubled-set.json-nft
@@ -24,7 +24,9 @@
           "ifname"
         ],
         "handle": 0,
-        "flags": "interval",
+        "flags": [
+          "interval"
+        ],
         "elem": [
           {
             "concat": [
diff --git a/tests/shell/testcases/transactions/dumps/table_onoff.json-nft b/tests/shell/testcases/transactions/dumps/table_onoff.json-nft
index a7583e8c4efc4..9b48ca4744a65 100644
--- a/tests/shell/testcases/transactions/dumps/table_onoff.json-nft
+++ b/tests/shell/testcases/transactions/dumps/table_onoff.json-nft
@@ -12,7 +12,9 @@
         "family": "ip",
         "name": "t",
         "handle": 0,
-        "flags": "dormant"
+        "flags": [
+          "dormant"
+        ]
       }
     },
     {
-- 
2.49.0

