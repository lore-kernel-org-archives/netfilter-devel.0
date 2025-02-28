Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F01D6DAD
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 21:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740776999; cv=none; b=ezufDnphzGwP+va35t7LEt2TU+OmVY/5Cb3HP6rmuxeursMQdvK+ltUdv0sKADS8V9WtAFmpye+4vmGvHWu3etgxDZzKDuNKozsaZ5FsvEcrKLWQE3zvIPW8G6trT7fLybCQ83scyCdittANsieC13uyR7V24Ld1iSR1e6AZJgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740776999; c=relaxed/simple;
	bh=/6VVTfS/izVgU3CpflzCdztan98V4YspPWWKB/GX/wY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q1QZwBXQCLT6dE8J/cGQ8A3anG4/WIdTWmBhQD5+du1LzKtGM3DPE1h6COzzEyLHDqjW2c8cSa/RDpapPEnbA4RhS5xNHp2YEg/hsdJdcDeWR+zbKFs2oHsPQIVnNbKhpwCETHkLZZYs0+Km9sUF4B7bKHjU1xx2+5KChaCCD4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jzKV3V0q; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tDoFsGDP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jzKV3V0q";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tDoFsGDP"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A566260317; Fri, 28 Feb 2025 22:09:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776987;
	bh=+tmyul/HOKCr/LQ6iYGFtFO8KXGewX2K/poqI8GSYm8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jzKV3V0q2xhoGybzpGVth46BiUd2+9yt+X/PuPSb8cqlqaUKJp837pimDJXUx1Zhs
	 OVjgzV+nEseGVruqBI2gnl5TxI//ZYzMrl40hrdbMwBRhMtotvNLVatGeHWFKRClvY
	 HH4FCYo25mk+azOqs+b+bLLfyITGK+qh8P682tmq7FXcG2gdeMUK6Ro+827HWiOFM0
	 SrH7ZefRc7wlsFmFW74SyLDNXazoo4qt0qhLwwMN8LwfnFU8o5YfMC72Oo02iG9Vxb
	 pJc7e+LM81pjI3mywZ1iBAAEImdJuLLe3EZR/MSy0VR8pfZN15MIIAbri9Z2Tgj9/a
	 AQqi8L/OBbWKQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 810656030D
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 22:09:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776985;
	bh=+tmyul/HOKCr/LQ6iYGFtFO8KXGewX2K/poqI8GSYm8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tDoFsGDPqvP5z/AqVE+Ex058swDbSjlzA1MGRgD97uYqM1Tp0UnaoTH72LAQS46JS
	 wefPdPWyC8cJpU+SmT4F/1PRQa+jsCC6RfW+1HEEQCyaNH08KD/ITMDmFq2VvKtx1P
	 nCcEwofWuzCDH72+u+FJQlunxiYemsQ3MWubwRtVUPr7w7tbWtCC4TyfTIszlDjPos
	 W8d5lNK7Pewgz8LNXhlEOjsjKt4fd6cEkaBEjAmnxExbxIwS8UY75yM6LwoIsczS90
	 hNV/uxPPkjDNJN6dpA7Uae4u+MKEZvwvCxYODtCSYARMJjgkkdBFWet6su1tiOJuBv
	 1Vyp6kEX4AjFw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] netlink_delinearize: support for bitfield payload statement with binary operation
Date: Fri, 28 Feb 2025 22:09:39 +0100
Message-Id: <20250228210939.3319333-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250228210939.3319333-1-pablo@netfilter.org>
References: <20250228210939.3319333-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new function to deal with payload statement delinearization with
binop expression.

Infer the payload offset from the mask, then walk the template list to
determine if estimated offset falls within a matching header field. If
so, then validate that this is not a raw expression but an actual
bitfield matching. Finally, trim the payload expression length
accordingly and adjust the payload offset.

instead of:

	@nh,8,5 set 0x0

it displays:

	ip dscp and 0x1

Update tests/py to cover for this enhancement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/payload.h               |   2 +
 src/netlink_delinearize.c       |  15 +-
 src/payload.c                   | 168 +++++++++++++++
 tests/py/ip/ip.t                |  17 ++
 tests/py/ip/ip.t.json           | 336 +++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload        |  82 +++++++
 tests/py/ip/ip.t.payload.bridge | 365 ++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 280 ++++++++++++++++++++++++
 tests/py/ip/ip.t.payload.netdev |  88 ++++++++
 9 files changed, 1351 insertions(+), 2 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index 6685dad6f9f7..4c01465457a9 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -64,6 +64,8 @@ bool payload_expr_trim(struct expr *expr, struct expr *mask,
 		       const struct proto_ctx *ctx, unsigned int *shift);
 bool payload_expr_trim_force(struct expr *expr, struct expr *mask,
 			     unsigned int *shift);
+bool stmt_payload_expr_trim(struct stmt *stmt, struct expr *expr,
+			    const struct proto_ctx *ctx);
 extern void payload_expr_expand(struct list_head *list, struct expr *expr,
 				const struct proto_ctx *ctx);
 extern void payload_expr_complete(struct expr *expr,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 2ac835b4ffd3..c245137a5f12 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -3183,7 +3183,8 @@ static void stmt_payload_binop_pp(struct rule_pp_ctx *ctx, struct expr *binop)
  * decoding changed '(payload & mask) ^ bits_to_set' into
  * 'payload | bits_to_set', discarding the redundant "& 0xfff...".
  */
-static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
+static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx,
+					   const struct proto_ctx *pctx)
 {
 	struct expr *expr, *binop, *payload, *value, *mask;
 	struct stmt *stmt = ctx->stmt;
@@ -3264,6 +3265,9 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 			unsigned int shift_unused;
 			mpz_t tmp;
 
+			if (stmt_payload_expr_trim(stmt, expr, pctx))
+				return;
+
 			mpz_init(tmp);
 			mpz_set(tmp, mask->value);
 
@@ -3293,9 +3297,16 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 		}
 		case OP_OR:  /* IIb */
 			stmt_payload_binop_pp(ctx, expr);
+			if (stmt_payload_expr_trim(stmt, expr, pctx))
+				return;
 			if (!payload_is_known(expr->left))
 				return;
 			break;
+		case OP_XOR:
+			if (stmt_payload_expr_trim(stmt, expr, pctx))
+				return;
+
+			return;
 		default: /* No idea what to do */
 			return;
 		}
@@ -3317,7 +3328,7 @@ static void stmt_payload_postprocess(struct rule_pp_ctx *ctx)
 
 	payload_expr_complete(stmt->payload.expr, &dl->pctx);
 	if (!payload_is_known(stmt->payload.expr))
-		stmt_payload_binop_postprocess(ctx);
+		stmt_payload_binop_postprocess(ctx, &dl->pctx);
 
 	expr_postprocess(ctx, &stmt->payload.expr);
 
diff --git a/src/payload.c b/src/payload.c
index ee6b39a34cb4..26f0286c4540 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -1161,6 +1161,174 @@ bool payload_expr_trim_force(struct expr *expr, struct expr *mask, unsigned int
 	return true;
 }
 
+/**
+ * stmt_payload_expr_trim - adjust payload len/offset according to mask
+ *
+ * @stmt:	the payload statement
+ * @pctx:	protocol context
+ *
+ * Infer offset to header field from mask, walk the template list to determine
+ * if offset falls within a matching header field.
+ *
+ * Trim the payload expression length accordingly, adjust the payload offset
+ * and return true if payload statement expressions has been updated.
+ *
+ * @return: true if @stmt was adjusted.
+ */
+bool stmt_payload_expr_trim(struct stmt *stmt, struct expr *expr,
+			    const struct proto_ctx *pctx)
+{
+	struct expr *payload = expr->left, *mask = expr->right;
+	const struct proto_hdr_template *tmpl;
+	const struct proto_desc *desc;
+	uint32_t offset, i, shift;
+	unsigned int mask_offset;
+	mpz_t bitmask, tmp, tmp2;
+	unsigned long n;
+
+	assert(stmt->ops->type == STMT_PAYLOAD);
+	assert(expr->etype == EXPR_BINOP);
+
+	if (payload->etype != EXPR_PAYLOAD ||
+	    mask->etype != EXPR_VALUE)
+		return false;
+
+	if (payload_is_known(payload) ||
+	    !pctx->protocol[payload->payload.base].desc ||
+	    payload->len % (2 * BITS_PER_BYTE) != 0)
+		return false;
+
+	switch (expr->op) {
+	case OP_AND:
+		/* infer offset from first 0 in mask */
+		n = mpz_scan0(mask->value, 0);
+		if (n == ULONG_MAX)
+			return false;
+
+		mask_offset = payload->len - n;
+		break;
+	case OP_OR:
+	case OP_XOR:
+		/* infer offset from first 1 in mask */
+		n = mpz_scan1(mask->value, 0);
+		if (n == ULONG_MAX)
+			return false;
+
+		mask_offset = payload->len - n;
+		break;
+	default:
+		return false;
+	}
+
+	offset = payload->payload.offset + mask_offset;
+
+	desc = pctx->protocol[payload->payload.base].desc;
+	for (i = 1; i < array_size(desc->templates); i++) {
+		tmpl = &desc->templates[i];
+
+		if (tmpl->len == 0)
+			return false;
+
+		/* Is this inferred offset within this header field? */
+		if (tmpl->offset + tmpl->len >= offset) {
+			/* Infer shift to reach this header field. */
+			if ((tmpl->offset % (2 * BITS_PER_BYTE)) < 8) {
+				shift = BITS_PER_BYTE - (tmpl->offset % BITS_PER_BYTE + tmpl->len);
+				shift += BITS_PER_BYTE;
+			} else {
+				shift = (2 * BITS_PER_BYTE) - (tmpl->offset % (2 * BITS_PER_BYTE) + tmpl->len);
+			}
+
+			/* Build bitmask to fetch this header field. */
+			mpz_init2(bitmask, payload->len);
+			mpz_bitmask(bitmask, tmpl->len);
+			if (shift)
+				mpz_lshift_ui(bitmask, shift);
+
+			/* Check if mask expression falls within this header
+			 * bitfield, if the mask expression is over this header
+			 * field, then skip this delinearization, this could be
+			 * a raw expression.
+			 */
+			switch (expr->op) {
+			case OP_AND:
+				/* Inverted bitmask to fetch untouched bits. */
+				mpz_init_bitmask(tmp, payload->len);
+				mpz_xor(tmp, bitmask, tmp);
+
+				/* Get untouched bits out of the header field. */
+				mpz_init2(tmp2, payload->len);
+				mpz_and(tmp2, mask->value, tmp);
+
+				/* Modified any bits out of the header field? */
+				if (mpz_cmp(tmp, tmp2) != 0) {
+					mpz_clear(tmp);
+					mpz_clear(tmp2);
+					mpz_clear(bitmask);
+					return false;
+				}
+				mpz_clear(tmp2);
+				break;
+			case OP_OR:
+			case OP_XOR:
+				mpz_init2(tmp, payload->len);
+
+				/* Get modified bits in header field. */
+				mpz_and(tmp, mask->value, bitmask);
+
+				/* Modified any bits out of the header field? */
+				if (mpz_cmp(tmp, mask->value) != 0) {
+					mpz_clear(tmp);
+					mpz_clear(bitmask);
+					return false;
+				}
+				break;
+			default:
+				assert(0);
+				break;
+			}
+			mpz_clear(tmp);
+
+			/* Clear unrelated bits for this header field. Shrink
+			 * to "real size". Shift bits when needed.
+			 */
+			mpz_and(mask->value, bitmask, mask->value);
+			mpz_clear(bitmask);
+
+			mask->len -= (tmpl->offset - payload->payload.offset);
+			if (shift) {
+				mask->len -= shift;
+				mpz_rshift_ui(mask->value, shift);
+			}
+			payload->payload.offset = tmpl->offset;
+			payload->len = tmpl->len;
+
+			expr_free(stmt->payload.expr);
+			stmt->payload.expr = expr_get(payload);
+
+			if (expr->op == OP_AND) {
+				/* Reduce 'expr AND 0x0', otherwise listing
+				 * shows:
+				 *
+				 *	ip dscp set ip dscp & 0x0
+				 *
+				 * instead of the more compact:
+				 *
+				 *	ip dscp set 0x0
+				 */
+				if (mpz_cmp_ui(mask->value, 0) == 0) {
+					expr = stmt->payload.val;
+					stmt->payload.val = expr_get(mask);
+					expr_free(expr);
+				}
+			}
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /**
  * payload_expr_expand - expand raw merged adjacent payload expressions into its
  * 			 original components
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index e6999c29478b..47262d9a4361 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -135,3 +135,20 @@ ip saddr 1.2.3.4 ip daddr 3.4.5.6;ok
 ip saddr 1.2.3.4 counter ip daddr 3.4.5.6;ok
 
 ip dscp 1/6;ok;ip dscp & 0x3f == lephb
+
+ip ecn set ip ecn | ect0;ok
+ip ecn set ip ecn | ect1;ok
+ip ecn set ip ecn & ect0;ok
+ip ecn set ip ecn & ect1;ok
+tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg);ok
+tcp flags set tcp flags | ecn | cwr;ok
+ip dscp set ip dscp | lephb;ok
+ip dscp set ip dscp & lephb;ok
+ip dscp set ip dscp & 0x1f;ok
+ip dscp set ip dscp & 0x4f;fail
+ip version set ip version | 1;ok
+ip version set ip version & 1;ok
+ip version set ip version | 0x1f;fail
+ip hdrlength set ip hdrlength | 1;ok
+ip hdrlength set ip hdrlength & 1;ok
+ip hdrlength set ip hdrlength | 0x1f;fail
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index a170e5c15965..3c3a12d7117c 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -1830,3 +1830,339 @@
         }
     }
 ]
+
+# ip ecn set ip ecn | ect0
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "ecn",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "ecn",
+                            "protocol": "ip"
+                        }
+                    },
+                    "ect0"
+                ]
+            }
+        }
+    }
+]
+
+# ip ecn set ip ecn | ect1
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "ecn",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "ecn",
+                            "protocol": "ip"
+                        }
+                    },
+                    "ect1"
+                ]
+            }
+        }
+    }
+]
+
+# ip ecn set ip ecn & ect0
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "ecn",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "ecn",
+                            "protocol": "ip"
+                        }
+                    },
+                    "ect0"
+                ]
+            }
+        }
+    }
+]
+
+# ip ecn set ip ecn & ect1
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "ecn",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "ecn",
+                            "protocol": "ip"
+                        }
+                    },
+                    "ect1"
+                ]
+            }
+        }
+    }
+]
+
+# tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    {
+                        "|": [
+                            "fin",
+                            "syn",
+                            "rst",
+                            "psh",
+                            "ack",
+                            "urg"
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# tcp flags set tcp flags | ecn | cwr
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    "ecn",
+                    "cwr"
+                ]
+            }
+        }
+    }
+]
+
+# ip dscp set ip dscp | lephb
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    "lephb"
+                ]
+            }
+        }
+    }
+]
+
+# ip dscp set ip dscp & lephb
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    "lephb"
+                ]
+            }
+        }
+    }
+]
+
+# ip dscp set ip dscp & 0x1f
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    31
+                ]
+            }
+        }
+    }
+]
+
+# ip version set ip version | 1
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "version",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "version",
+                            "protocol": "ip"
+                        }
+                    },
+                    1
+                ]
+            }
+        }
+    }
+]
+
+# ip version set ip version & 1
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "version",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "version",
+                            "protocol": "ip"
+                        }
+                    },
+                    1
+                ]
+            }
+        }
+    }
+]
+
+# ip hdrlength set ip hdrlength | 1
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "hdrlength",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "payload": {
+                            "field": "hdrlength",
+                            "protocol": "ip"
+                        }
+                    },
+                    1
+                ]
+            }
+        }
+    }
+]
+
+# ip hdrlength set ip hdrlength & 1
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "hdrlength",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "hdrlength",
+                            "protocol": "ip"
+                        }
+                    },
+                    1
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index b0e9efa5f8e4..0e9936278008 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -553,3 +553,85 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
+
+# ip ecn set ip ecn | ect0
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp flags set tcp flags | ecn | cwr
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x0000c000 ]
+  [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & lephb
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+ip test-ip4 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 9400fd0fb004..94da3e9092d3 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -725,3 +725,368 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
+
+# ip ecn set ip ecn | ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
+bridge test-bridge input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp flags set tcp flags | ecn | cwr
+bridge test-bridge input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x0000c000 ]
+  [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+# ip dscp set ip dscp & lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+# ip dscp set ip dscp & lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+# ip dscp set ip dscp & lephb
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 16df241f5a41..2004a3ebd1c0 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -725,3 +725,283 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
+
+# ip ecn set ip ecn | ect0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# tcp flags set tcp flags & (fin | syn | rst | psh | ack | urg)
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp flags set tcp flags | ecn | cwr
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 12 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003fff ) ^ 0x0000c000 ]
+  [ payload write reg 1 => 2b @ transport header + 12 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & lephb
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & lephb
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & lephb
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 0a80af343803..bd3495324b91 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -725,3 +725,91 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
   [ cmp eq reg 1 0x00000001 ]
+
+# ip ecn set ip ecn | ect0
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000200 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn | ect1
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000100 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect0
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000feff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip ecn set ip ecn & ect1
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fdff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp | lephb
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fbff ) ^ 0x00000400 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & lephb
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000007ff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip dscp set ip dscp & 0x1f
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00007fff ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version | 1
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ffef ) ^ 0x00000010 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip version set ip version & 1
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff1f ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength | 1
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fffe ) ^ 0x00000001 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# ip hdrlength set ip hdrlength & 1
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000fff1 ) ^ 0x00000000 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-- 
2.30.2

