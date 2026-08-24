Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D0D391E64
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787606963; cv=none; b=hCloa37+iUDWtjhNVe3gidMVhcupAnvku5pCst3Cha2tDwAtK811K7nWUhaTNbK7Lm9SoXwTBokJqT0kiSrYK2RPUmmNkZhhPJOvrrm8IvWLSg/Fsn6d++lzFswdujib6fHyDd5Oqj+oLHvFFjAIM7AjMR/am4KppGfB027EhsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787606963; c=relaxed/simple;
	bh=QVmf+q8I/0LbND6ThmKqWSmDr5NWj6qHplu9uWcFao8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWfbe+1cKgg/BZKvMIsQbcrEgHP9EcvBczze4OpOLdg8Qzy+va7DUA+hGm8d2sav76m/D10prPKXoolPzHtGI6QPdudZ88/PUC/mST7zYQ5JJwN62OdW+eGD6o1lAZxrn+UVnVtReZI+U2bCBQrCaTQiTq5PzM4pKoE06jKH+eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t5VZBWMV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t5VZBWMV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787606958;
	bh=gVCUMWGk7BwEDR85kBz0tzvs9qmcMQXcGakAnxdZ/NY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=t5VZBWMVUsdLMoX3t7rLhGdmRIjxSQUp6M0y64Fd+oEupfT7ZlQX+iixXrrDCkBQJ
	 /hlfqbHkHE6PkltuS/v2Q81LUZOcu20zYad5ikLydkUTHTDbdsGjksyUeh+abuMuek
	 NRKHJVkJslLanRPtaejCDydAFxmVWci6Ma7yr2Npw2E/LOkM6GS3Hvp6xwFpVZ393g
	 q+/8rdZEaeSQ3HQRUyItkj6zcMOwD1Qg8P/ozit9Nq+I/2+yCzc0ApeaiFX5M+rAkp
	 XgUw3cY5V1Ez5UjdBZR5fqZfOInCFqGHvKW01/kt9VH4qd4tJPLNy9H5j9HZqdpLAC
	 lU3FZ+dToDHMg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6BBF36008A
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 23:29:18 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] segtree: postpone bitmask to symbol conversion for interval sets
Date: Mon, 24 Aug 2026 23:29:09 +0200
Message-ID: <20260824212909.68597-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824212909.68597-1-pablo@netfilter.org>
References: <20260824212909.68597-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netlink_delinearize_setelem() calls bitmask_expr_to_binops() to turn a
bitmask into symbols, ie.

	tcp flags { 0x2, 0x12 }

into
	tcp flags { syn, syn | ack }

However, this call comes too early for interval set with one single key.
The interval_map_decompose() postprocessing can only deal with value
expressions, otherwise it hits an assertion.

Move this conversion at a later stage of interval_map_decompose() for
interval sets.

Ranges and prefix do not call bitmask_expr_to_binops(), we do not use
symbolic representations for such expressions, instead values are used.

The conversion is still perform for non-interval sets, since there is no
specific function to perform postprocessing for this type of sets.

Add and extend existing tests/shell cases.

Fixes: def2cca8e713 ("set_elem: convert flag value to inclusive-OR binops during delinearize")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c                                 |   6 +-
 src/segtree.c                                 |  15 +
 .../dumps/vmap_concat_range_binary.json-nft   | 154 +++++++++++
 .../maps/dumps/vmap_concat_range_binary.nft   |  10 +
 .../maps/dumps/vmap_range_binary.json-nft     | 257 ++++++++++++++++++
 .../maps/dumps/vmap_range_binary.nft          |  23 ++
 .../testcases/maps/vmap_concat_range_binary   |  10 +
 tests/shell/testcases/maps/vmap_range_binary  |  35 +++
 8 files changed, 508 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_range_binary.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/vmap_range_binary.nft
 create mode 100755 tests/shell/testcases/maps/vmap_range_binary

diff --git a/src/netlink.c b/src/netlink.c
index c305e5619640..8916370604c0 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1440,7 +1440,8 @@ static struct expr *concat_elem_expr(const struct set *set, struct expr *key,
 	     expr->byteorder == BYTEORDER_HOST_ENDIAN))
 		mpz_switch_byteorder(expr->value, expr->len / BITS_PER_BYTE);
 
-	if (expr->dtype->basetype != NULL &&
+	if (!(set->flags & NFT_SET_INTERVAL) &&
+	    expr->dtype->basetype != NULL &&
 	    expr->dtype->basetype->type == TYPE_BITMASK)
 		expr = bitmask_expr_to_binops(expr);
 
@@ -1591,7 +1592,8 @@ key_end:
 		    key->byteorder == BYTEORDER_HOST_ENDIAN)
 			mpz_switch_byteorder(key->value, key->len / BITS_PER_BYTE);
 
-		if (key->dtype->basetype != NULL &&
+		if (!(set->flags & NFT_SET_INTERVAL) &&
+		    key->dtype->basetype != NULL &&
 		    key->dtype->basetype->type == TYPE_BITMASK)
 			key = bitmask_expr_to_binops(key);
 	} else if (flags & NFT_SET_ELEM_CATCHALL) {
diff --git a/src/segtree.c b/src/segtree.c
index 5e178fa3c48d..1dc94688aee1 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -411,6 +411,13 @@ void concat_range_aggregate(struct expr *set)
 			assert(r1->etype == EXPR_VALUE && r1->etype == EXPR_VALUE);
 
 			if (!mpz_cmp(r1->value, r2->value)) {
+				if (r2->dtype->basetype != NULL &&
+				    r2->dtype->basetype->type == TYPE_BITMASK) {
+					expr_get(r2);
+					tmp = bitmask_expr_to_binops(r2);
+					list_replace(&r2->list, &tmp->list);
+					expr_free(r2);
+				}
 				free_r1 = 1;
 				goto next;
 			}
@@ -590,6 +597,14 @@ add_interval(struct expr *set, struct expr *low, struct expr *i, bool closed)
 		if (expr_basetype(low)->type == TYPE_STRING)
 			mpz_switch_byteorder(key->value,
 					     key->len / BITS_PER_BYTE);
+
+		if (key->dtype->basetype != NULL &&
+		    key->dtype->basetype->type == TYPE_BITMASK) {
+			if (low->key->etype == EXPR_MAPPING)
+				low->key->left = bitmask_expr_to_binops(low->key->left);
+			else
+				low->key = bitmask_expr_to_binops(low->key);
+		}
 		low->key->flags |= EXPR_F_KERNEL;
 		expr = expr_get(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
diff --git a/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft
index 8868f2eb180e..de285354d86a 100644
--- a/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft
+++ b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.json-nft
@@ -97,6 +97,65 @@
         ]
       }
     },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "x",
+        "type": {
+          "typeof": {
+            "concat": [
+              {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "flags"
+                }
+              },
+              {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              }
+            ]
+          }
+        },
+        "handle": 0,
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          {
+            "concat": [
+              {
+                "|": [
+                  "syn",
+                  "ack"
+                ]
+              },
+              80
+            ]
+          },
+          {
+            "concat": [
+              "ack",
+              90
+            ]
+          },
+          {
+            "concat": [
+              "rst",
+              {
+                "range": [
+                  100,
+                  110
+                ]
+              }
+            ]
+          }
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
@@ -204,6 +263,101 @@
           }
         ]
       }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "flags"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "dport"
+                    }
+                  }
+                ]
+              },
+              "right": "@s"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "concat": [
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "flags"
+                    }
+                  },
+                  {
+                    "payload": {
+                      "protocol": "tcp",
+                      "field": "dport"
+                    }
+                  }
+                ]
+              },
+              "right": {
+                "set": [
+                  {
+                    "concat": [
+                      {
+                        "|": [
+                          "syn",
+                          "ack"
+                        ]
+                      },
+                      80
+                    ]
+                  },
+                  {
+                    "concat": [
+                      "ack",
+                      90
+                    ]
+                  },
+                  {
+                    "concat": [
+                      "rst",
+                      {
+                        "range": [
+                          100,
+                          110
+                        ]
+                      }
+                    ]
+                  }
+                ]
+              }
+            }
+          }
+        ]
+      }
     }
   ]
 }
diff --git a/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft
index bc74535b852f..b5d6de32a838 100644
--- a/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft
+++ b/tests/shell/testcases/maps/dumps/vmap_concat_range_binary.nft
@@ -7,8 +7,18 @@ table ip x {
 			     rst . 100-110 : drop }
 	}
 
+	set s {
+		typeof tcp flags . tcp dport
+		flags interval
+		elements = { syn | ack . 80,
+			     ack . 90,
+			     rst . 100-110 }
+	}
+
 	chain z {
 		tcp flags . tcp dport vmap @y
 		tcp flags . tcp dport vmap { syn | ack . 80 : accept, ack . 90 : drop, rst . 100-110 : drop }
+		tcp flags . tcp dport @s
+		tcp flags . tcp dport { syn | ack . 80, ack . 90, rst . 100-110 }
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/vmap_range_binary.json-nft b/tests/shell/testcases/maps/dumps/vmap_range_binary.json-nft
new file mode 100644
index 000000000000..eba4afb013d8
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_range_binary.json-nft
@@ -0,0 +1,257 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "x",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "z",
+        "handle": 0
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "y",
+        "table": "x",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "tcp",
+              "field": "flags"
+            }
+          }
+        },
+        "handle": 0,
+        "map": "verdict",
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          [
+            "rst",
+            {
+              "drop": null
+            }
+          ],
+          [
+            "ack",
+            {
+              "drop": null
+            }
+          ],
+          [
+            {
+              "|": [
+                "syn",
+                "ack"
+              ]
+            },
+            {
+              "accept": null
+            }
+          ],
+          [
+            {
+              "range": [
+                "urg",
+                255
+              ]
+            },
+            {
+              "drop": null
+            }
+          ]
+        ]
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "x",
+        "type": {
+          "typeof": {
+            "payload": {
+              "protocol": "tcp",
+              "field": "flags"
+            }
+          }
+        },
+        "handle": 0,
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          "rst",
+          "ack",
+          {
+            "|": [
+              "syn",
+              "ack"
+            ]
+          },
+          {
+            "range": [
+              "urg",
+              255
+            ]
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "flags"
+                }
+              },
+              "data": "@y"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "flags"
+                }
+              },
+              "data": {
+                "set": [
+                  [
+                    "rst",
+                    {
+                      "drop": null
+                    }
+                  ],
+                  [
+                    "ack",
+                    {
+                      "drop": null
+                    }
+                  ],
+                  [
+                    {
+                      "|": [
+                        "syn",
+                        "ack"
+                      ]
+                    },
+                    {
+                      "accept": null
+                    }
+                  ],
+                  [
+                    {
+                      "range": [
+                        "urg",
+                        255
+                      ]
+                    },
+                    {
+                      "drop": null
+                    }
+                  ]
+                ]
+              }
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "flags"
+                }
+              },
+              "right": "@s"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "x",
+        "chain": "z",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "flags"
+                }
+              },
+              "right": {
+                "set": [
+                  "rst",
+                  "ack",
+                  {
+                    "|": [
+                      "syn",
+                      "ack"
+                    ]
+                  },
+                  {
+                    "range": [
+                      "urg",
+                      255
+                    ]
+                  }
+                ]
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/vmap_range_binary.nft b/tests/shell/testcases/maps/dumps/vmap_range_binary.nft
new file mode 100644
index 000000000000..fbf599c07ff1
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/vmap_range_binary.nft
@@ -0,0 +1,23 @@
+table ip x {
+	map y {
+		typeof tcp flags : verdict
+		flags interval
+		elements = { rst : drop,
+			     ack : drop,
+			     syn | ack : accept,
+			     0x20-0xff : drop }
+	}
+
+	set s {
+		typeof tcp flags
+		flags interval
+		elements = { rst, ack, syn | ack, 0x20-0xff }
+	}
+
+	chain z {
+		tcp flags vmap @y
+		tcp flags vmap { rst : drop, ack : drop, syn | ack : accept, 0x20-0xff : drop }
+		tcp flags @s
+		tcp flags { rst, ack, syn | ack, 0x20-0xff }
+	}
+}
diff --git a/tests/shell/testcases/maps/vmap_concat_range_binary b/tests/shell/testcases/maps/vmap_concat_range_binary
index ad5ef4a9177e..bd0e5ed8d500 100755
--- a/tests/shell/testcases/maps/vmap_concat_range_binary
+++ b/tests/shell/testcases/maps/vmap_concat_range_binary
@@ -13,9 +13,19 @@ RULESET="table ip x {
 			     rst . 100-110 : drop }
         }
 
+        set s {
+                typeof tcp flags . tcp dport
+                flags interval
+                elements = { syn | ack . 80,
+                             ack . 90,
+                             rst . 100-110 }
+	}
+
         chain z {
                 tcp flags . tcp dport vmap @y
                 tcp flags . tcp dport vmap { syn | ack . 80 : accept, ack . 90 : drop, rst . 100-110 : drop }
+                tcp flags . tcp dport @s
+                tcp flags . tcp dport { syn | ack . 80, ack . 90, rst . 100-110 }
         }
 }"
 
diff --git a/tests/shell/testcases/maps/vmap_range_binary b/tests/shell/testcases/maps/vmap_range_binary
new file mode 100755
index 000000000000..428cec646aca
--- /dev/null
+++ b/tests/shell/testcases/maps/vmap_range_binary
@@ -0,0 +1,35 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+        map y {
+                typeof tcp flags : verdict
+                flags interval
+                elements = { syn | ack : accept,
+                             ack : drop,
+                             rst : drop,
+                             0x20-0xff : drop,
+		}
+        }
+
+        set s {
+                typeof tcp flags
+                flags interval
+                elements = { syn | ack,
+                             ack,
+			     rst,
+			     0x20-0xff,
+		}
+        }
+
+
+        chain z {
+                tcp flags vmap @y
+                tcp flags vmap { syn | ack : accept, ack : drop, rst : drop, 0x20-0xff : drop }
+                tcp flags @s
+                tcp flags { syn | ack, ack, rst, 0x20-0xff }
+        }
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.47.3

