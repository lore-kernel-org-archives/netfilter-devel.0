Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B282356D9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236095; cv=none; b=mo8cOB2zgiIUnmcw6KuiyIeF/Grp0Va+SqCNbIczko7Gk3jiMi3dKb8Bsm6b63gffoqgb2xfrgVZ51v04L1Pd7JTG0vGr/6Mupo3+q4pFx6wi10aJGLiF74AKCaLF+UPizmUMF08+Ke0uqOXcVszATS7bx65cPZ39pSoO9jtaAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236095; c=relaxed/simple;
	bh=9ehzOEtWq3v+kXUQh/kDKR9BYjRL7e62JonlQi5inzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhreo2sFZRDom/rxUwyoLHYGOWsvESblCrTJ9kn/4h2MKTFOVTyprTfhwr5siHmu3tzbszCJIa0nLMfw2cWEUTG7REd9azWdFC/FgUcWW/sSrC6WhvYFE6RIv5/X46JylwQp2h6hmSKPmrTsZ2dclFtXp81SP7crQX/u2QyLgjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=M6mUM/gT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="M6mUM/gT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=InEFhrcVDrirdmmpfJTbeXgMEB5xdmABW3c4ZrQHLe4=; b=M6mUM/gTyl7WA18WLYWF+2iMIf
	A3y70+wzztm5wdw00yg19hCVA7p+8hS7559+yqpZX4YkW0mpPtB06j3GS9MgSoiTxQrtlICrtQP0R
	LCq8+7TJ7YiPiPfwbEVxZ1kvAfDp5DQaQlfLHXlfGSuf3xKAPHh5rXhQV+IshHGrxEju54vuyM0MU
	d7QefZBOW+26Bou6qBA+pM8daFgLdZRlzPBihmUTX1DXMkL4nib1PCia1oC6DY+lQCrmdYQLPWDMC
	Wf9Mp2g3jOthbn9eTY1rybVqaKoXOdeEqmfoignIkrWjNkY8Xroo1t9VFET6YwNLEbNFb5o47Q1qZ
	n2uC3xhA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxj-0000000007e-0jQW;
	Thu, 23 Oct 2025 18:14:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 28/28] Drop no longer needed newline in BUG() messages
Date: Thu, 23 Oct 2025 18:14:17 +0200
Message-ID: <20251023161417.13228-29-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since BUG() now appends a newline itself, drop it from calls where
present.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/datatype.c            |  2 +-
 src/erec.c                |  2 +-
 src/evaluate.c            | 46 +++++++++++++++++++--------------------
 src/expression.c          |  6 ++---
 src/fib.c                 |  2 +-
 src/intervals.c           |  8 +++----
 src/json.c                |  4 ++--
 src/mergesort.c           |  2 +-
 src/mnl.c                 |  8 +++----
 src/netlink.c             | 11 +++++-----
 src/netlink_delinearize.c | 11 +++++-----
 src/netlink_linearize.c   | 28 ++++++++++++------------
 src/optimize.c            |  2 +-
 src/rule.c                | 20 ++++++++---------
 src/segtree.c             |  2 +-
 src/statement.c           |  2 +-
 16 files changed, 79 insertions(+), 77 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 2ee7e7d5e9cf6..eee9ab9d19296 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -119,7 +119,7 @@ void datatype_print(const struct expr *expr, struct output_ctx *octx)
 						       false, octx);
 	} while ((dtype = dtype->basetype));
 
-	BUG("datatype %s has no print method or symbol table\n",
+	BUG("datatype %s has no print method or symbol table",
 	    expr->dtype->name);
 }
 
diff --git a/src/erec.c b/src/erec.c
index fe66abbe3ac29..8f480a80a0d0c 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -156,7 +156,7 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 	case INDESC_NETLINK:
 		break;
 	default:
-		BUG("invalid input descriptor type %u\n", indesc->type);
+		BUG("invalid input descriptor type %u", indesc->type);
 	}
 
 	f = octx->error_fp;
diff --git a/src/evaluate.c b/src/evaluate.c
index cee500312bc6d..7dc59a00097a8 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -172,7 +172,7 @@ static enum ops byteorder_conversion_op(struct expr *expr,
 	default:
 		break;
 	}
-	BUG("invalid byte order conversion %u => %u\n",
+	BUG("invalid byte order conversion %u => %u",
 	    expr->byteorder, byteorder);
 }
 
@@ -587,7 +587,7 @@ static int expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 					  &extra_len);
 		break;
 	default:
-		BUG("Unknown expression %s\n", expr_name(expr));
+		BUG("Unknown expression %s", expr_name(expr));
 	}
 
 	masklen = len + shift;
@@ -1366,7 +1366,7 @@ static int expr_evaluate_unary(struct eval_ctx *ctx, struct expr **expr)
 		byteorder = BYTEORDER_HOST_ENDIAN;
 		break;
 	default:
-		BUG("invalid unary operation %u\n", unary->op);
+		BUG("invalid unary operation %u", unary->op);
 	}
 
 	__datatype_set(unary, datatype_clone(arg->dtype));
@@ -1417,7 +1417,7 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
 		mpz_rshift_ui(val, mpz_get_uint32(right->value));
 		break;
 	default:
-		BUG("invalid binary operation %u\n", op->op);
+		BUG("invalid binary operation %u", op->op);
 	}
 
 	new = constant_expr_alloc(&op->location, op->dtype, op->byteorder,
@@ -1606,7 +1606,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 		ret = expr_evaluate_bitwise(ctx, expr);
 		break;
 	default:
-		BUG("invalid binary operation %u\n", op->op);
+		BUG("invalid binary operation %u", op->op);
 	}
 
 
@@ -2044,7 +2044,7 @@ static int interval_set_eval(struct eval_ctx *ctx, struct set *set,
 	case CMD_RESET:
 		break;
 	default:
-		BUG("unhandled op %d\n", ctx->cmd->op);
+		BUG("unhandled op %d", ctx->cmd->op);
 		break;
 	}
 
@@ -2269,7 +2269,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 			return -1;
 
 		if (ectx.len && mappings->set->data->len != ectx.len)
-			BUG("%d vs %d\n", mappings->set->data->len, ectx.len);
+			BUG("%d vs %d", mappings->set->data->len, ectx.len);
 
 		map->mappings = mappings;
 
@@ -2634,7 +2634,7 @@ static int binop_transfer_one(struct eval_ctx *ctx,
 					    *right, expr_get(left->right));
 		break;
 	default:
-		BUG("invalid binary operation %u\n", left->op);
+		BUG("invalid binary operation %u", left->op);
 	}
 
 	return expr_evaluate(ctx, right);
@@ -2956,7 +2956,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 						 "Use concatenations with sets and maps, not singleton values");
 			break;
 		default:
-			BUG("invalid expression type %s\n", expr_name(right));
+			BUG("invalid expression type %s", expr_name(right));
 		}
 		break;
 	case OP_LT:
@@ -2987,7 +2987,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			return -1;
 		break;
 	default:
-		BUG("invalid relational operation %u\n", rel->op);
+		BUG("invalid relational operation %u", rel->op);
 	}
 
 	if (binop_transfer(ctx, expr) < 0)
@@ -3223,7 +3223,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_RANGE_SYMBOL:
 		return expr_evaluate_symbol_range(ctx, expr);
 	default:
-		BUG("unknown expression type %s\n", expr_name(*expr));
+		BUG("unknown expression type %s", expr_name(*expr));
 	}
 }
 
@@ -3384,7 +3384,7 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
 	case EXPR_MAP:
 		break;
 	default:
-		BUG("invalid verdict expression %s\n", expr_name(stmt->expr));
+		BUG("invalid verdict expression %s", expr_name(stmt->expr));
 	}
 	return 0;
 }
@@ -5085,7 +5085,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_OPTSTRIP:
 		return stmt_evaluate_optstrip(ctx, stmt);
 	default:
-		BUG("unknown statement type %d\n", stmt->type);
+		BUG("unknown statement type %d", stmt->type);
 	}
 }
 
@@ -5476,7 +5476,7 @@ static struct expr *expr_set_to_list(struct eval_ctx *ctx, struct expr *dev_expr
 			expr = key;
 			break;
 		default:
-			BUG("invalid expression type %s\n", expr_name(expr));
+			BUG("invalid expression type %s", expr_name(expr));
 			break;
 		}
 
@@ -5528,7 +5528,7 @@ static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
 		case EXPR_VALUE:
 			break;
 		default:
-			BUG("invalid expression type %s\n", expr_name(expr));
+			BUG("invalid expression type %s", expr_name(expr));
 			break;
 		}
 
@@ -5968,7 +5968,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		handle_merge(&cmd->object->handle, &cmd->handle);
 		return obj_evaluate(ctx, cmd->object);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 }
 
@@ -6139,7 +6139,7 @@ static int cmd_evaluate_delete(struct eval_ctx *ctx, struct cmd *cmd)
 		obj_del_cache(ctx, cmd, NFT_OBJECT_TUNNEL);
 		return 0;
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 }
 
@@ -6149,7 +6149,7 @@ static int cmd_evaluate_get(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_ELEMENTS:
 		return setelem_evaluate(ctx, cmd);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 }
 
@@ -6304,7 +6304,7 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		}
 		return 0;
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 }
 
@@ -6333,7 +6333,7 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_MAP:
 		return cmd_evaluate_list(ctx, cmd);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 }
 
@@ -6413,7 +6413,7 @@ static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 
 		return 0;
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 	return 0;
 }
@@ -6435,7 +6435,7 @@ static int cmd_evaluate_rename(struct eval_ctx *ctx, struct cmd *cmd)
 
 		break;
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 	return 0;
 }
@@ -6625,5 +6625,5 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		break;
 	};
 
-	BUG("invalid command operation %u\n", cmd->op);
+	BUG("invalid command operation %u", cmd->op);
 }
diff --git a/src/expression.c b/src/expression.c
index de63196b60a6a..0dc59ab04b16c 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1770,7 +1770,7 @@ void range_expr_value_low(mpz_t rop, const struct expr *expr)
 	case EXPR_SET_ELEM:
 		return range_expr_value_low(rop, expr->key);
 	default:
-		BUG("invalid range expression type %s\n", expr_name(expr));
+		BUG("invalid range expression type %s", expr_name(expr));
 	}
 }
 
@@ -1797,7 +1797,7 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
 	case EXPR_SET_ELEM:
 		return range_expr_value_high(rop, expr->key);
 	default:
-		BUG("invalid range expression type %s\n", expr_name(expr));
+		BUG("invalid range expression type %s", expr_name(expr));
 	}
 }
 
@@ -1848,7 +1848,7 @@ const struct expr_ops *expr_ops(const struct expr *e)
 
 	ops = __expr_ops_by_type(e->etype);
 	if (!ops)
-		BUG("Unknown expression type %d\n", e->etype);
+		BUG("Unknown expression type %d", e->etype);
 
 	return ops;
 }
diff --git a/src/fib.c b/src/fib.c
index 571277ddf434a..c8ac8a8357e5d 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -197,7 +197,7 @@ struct expr *fib_expr_alloc(const struct location *loc,
 		type = &fib_addr_type;
 		break;
 	default:
-		BUG("Unknown result %d\n", result);
+		BUG("Unknown result %d", result);
 	}
 
 	if (flags & NFTA_FIB_F_PRESENT) {
diff --git a/src/intervals.c b/src/intervals.c
index 6a917b7b79c3f..7f3d2252fcadc 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -65,7 +65,7 @@ static void setelem_expr_to_range(struct expr *expr)
 		expr->key = key;
 		break;
 	default:
-		BUG("unhandled key type %s\n", expr_name(expr->key));
+		BUG("unhandled key type %s", expr_name(expr->key));
 	}
 }
 
@@ -221,7 +221,7 @@ static struct expr *interval_expr_key(struct expr *i)
 		elem = i;
 		break;
 	default:
-		BUG("unhandled expression type %d\n", i->etype);
+		BUG("unhandled expression type %d", i->etype);
 		return NULL;
 	}
 
@@ -751,7 +751,7 @@ static struct expr *setelem_key(struct expr *expr)
 		key = expr->key;
 		break;
 	default:
-		BUG("unhandled expression type %d\n", expr->etype);
+		BUG("unhandled expression type %d", expr->etype);
 		return NULL;
 	}
 
@@ -775,7 +775,7 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	}
 
 	if (key->etype != EXPR_RANGE_VALUE)
-		BUG("key must be RANGE_VALUE, not %s\n", expr_name(key));
+		BUG("key must be RANGE_VALUE, not %s", expr_name(key));
 
 	assert(!next_key || next_key->etype == EXPR_RANGE_VALUE);
 
diff --git a/src/json.c b/src/json.c
index 46d8a73333374..e3688249f806a 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1117,7 +1117,7 @@ static json_t *datatype_json(const struct expr *expr, struct output_ctx *octx)
 		}
 	} while ((dtype = dtype->basetype));
 
-	BUG("datatype %s has no print method or symbol table\n",
+	BUG("datatype %s has no print method or symbol table",
 	    expr->dtype->name);
 }
 
@@ -2149,7 +2149,7 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		errno = EOPNOTSUPP;
 		return -1;
 	case CMD_OBJ_INVALID:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 		break;
 	}
 
diff --git a/src/mergesort.c b/src/mergesort.c
index 95037e5be8608..9984e272df580 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -48,7 +48,7 @@ static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
 		mpz_bitmask(value, expr->len);
 		break;
 	default:
-		BUG("Unknown expression %s\n", expr_name(expr));
+		BUG("Unknown expression %s", expr_name(expr));
 	}
 	return value;
 }
diff --git a/src/mnl.c b/src/mnl.c
index 6e32fc3467ce9..a2e555d4a8bf4 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -740,18 +740,18 @@ static void nft_dev_add(struct nft_dev *dev_array, const struct expr *expr, int
 	char ifname[IFNAMSIZ];
 
 	if (expr->etype != EXPR_VALUE)
-		BUG("Must be a value, not %s\n", expr_name(expr));
+		BUG("Must be a value, not %s", expr_name(expr));
 
 	ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
 	memset(ifname, 0, sizeof(ifname));
 
 	if (ifname_len > sizeof(ifname))
-		BUG("Interface length %u exceeds limit\n", ifname_len);
+		BUG("Interface length %u exceeds limit", ifname_len);
 
 	mpz_export_data(ifname, expr->value, BYTEORDER_BIG_ENDIAN, ifname_len);
 
 	if (strnlen(ifname, IFNAMSIZ) >= IFNAMSIZ)
-		BUG("Interface length %zu exceeds limit, no NUL byte\n", strnlen(ifname, IFNAMSIZ));
+		BUG("Interface length %zu exceeds limit, no NUL byte", strnlen(ifname, IFNAMSIZ));
 
 	dev_array[i].ifname = xstrdup(ifname);
 	dev_array[i].location = &expr->location;
@@ -1734,7 +1734,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		obj_tunnel_add_opts(nlo, &obj->tunnel);
 		break;
 	default:
-		BUG("Unknown type %d\n", obj->type);
+		BUG("Unknown type %d", obj->type);
 		break;
 	}
 	netlink_dump_obj(nlo, ctx);
diff --git a/src/netlink.c b/src/netlink.c
index 68228bdc5c99a..5be7feb17d84a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -125,7 +125,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 		elem = expr;
 	}
 	if (elem->etype != EXPR_SET_ELEM)
-		BUG("Unexpected expression type: got %d\n", elem->etype);
+		BUG("Unexpected expression type: got %d", elem->etype);
 
 	key = elem->key;
 
@@ -227,7 +227,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 					       nld.byteorder, nld.sizes);
 			break;
 		default:
-			BUG("unexpected set element expression\n");
+			BUG("unexpected set element expression");
 			break;
 		}
 	}
@@ -347,7 +347,8 @@ static void nft_data_memcpy(struct nft_data_linearize *nld,
 			    const void *src, unsigned int len)
 {
 	if (len > sizeof(nld->value))
-		BUG("nld buffer overflow: want to copy %u, max %u\n", len, (unsigned int)sizeof(nld->value));
+		BUG("nld buffer overflow: want to copy %u, max %u",
+		    len, (unsigned int)sizeof(nld->value));
 
 	memcpy(nld->value, src, len);
 	nld->len = len;
@@ -606,7 +607,7 @@ static void netlink_gen_key(const struct expr *expr,
 	case EXPR_PREFIX:
 		return netlink_gen_prefix(expr, data);
 	default:
-		BUG("invalid data expression type %s\n", expr_name(expr));
+		BUG("invalid data expression type %s", expr_name(expr));
 	}
 }
 
@@ -629,7 +630,7 @@ static void __netlink_gen_data(const struct expr *expr,
 	case EXPR_PREFIX:
 		return netlink_gen_prefix(expr, data);
 	default:
-		BUG("invalid data expression type %s\n", expr_name(expr));
+		BUG("invalid data expression type %s", expr_name(expr));
 	}
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 54be0682b0899..3f79463c25f76 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2474,7 +2474,7 @@ static void binop_adjust_one(const struct expr *binop, struct expr *value,
 		value->len = left->len;
 		break;
 	default:
-		BUG("unknown expression type %s\n", expr_name(left));
+		BUG("unknown expression type %s", expr_name(left));
 		break;
 	}
 }
@@ -2505,7 +2505,8 @@ static void binop_adjust(const struct expr *binop, struct expr *right,
 				binop_adjust(binop, i->key->key, shift);
 				break;
 			default:
-				BUG("unknown expression type %s\n", expr_name(i->key));
+				BUG("unknown expression type %s",
+				    expr_name(i->key));
 			}
 		}
 		break;
@@ -2514,7 +2515,7 @@ static void binop_adjust(const struct expr *binop, struct expr *right,
 		binop_adjust_one(binop, right->right, shift);
 		break;
 	default:
-		BUG("unknown expression type %s\n", expr_name(right));
+		BUG("unknown expression type %s", expr_name(right));
 		break;
 	}
 }
@@ -2645,7 +2646,7 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
 			expr->op = OP_NEG;
 			break;
 		default:
-			BUG("unknown operation type %d\n", expr->op);
+			BUG("unknown operation type %d", expr->op);
 		}
 		expr_free(binop);
 	} else if (datatype_prefix_notation(binop->left->dtype) &&
@@ -3051,7 +3052,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 		ct_expr_update_type(&dl->pctx, expr);
 		break;
 	default:
-		BUG("unknown expression type %s\n", expr_name(expr));
+		BUG("unknown expression type %s", expr_name(expr));
 	}
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 36a539bf96283..ac0eaff9a23ca 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -76,7 +76,7 @@ static enum nft_registers __get_register(struct netlink_linearize_ctx *ctx,
 
 	n = netlink_register_space(size);
 	if (ctx->reg_low + n > NFT_REG_1 + NFT_REG32_15 - NFT_REG32_00 + 1)
-		BUG("register reg_low %u invalid\n", ctx->reg_low);
+		BUG("register reg_low %u invalid", ctx->reg_low);
 
 	reg = ctx->reg_low;
 	ctx->reg_low += n;
@@ -90,7 +90,7 @@ static void __release_register(struct netlink_linearize_ctx *ctx,
 
 	n = netlink_register_space(size);
 	if (ctx->reg_low < NFT_REG_1 + n)
-		BUG("register reg_low %u invalid\n", ctx->reg_low);
+		BUG("register reg_low %u invalid", ctx->reg_low);
 
 	ctx->reg_low -= n;
 }
@@ -457,7 +457,7 @@ static enum nft_cmp_ops netlink_gen_cmp_op(enum ops op)
 	case OP_GTE:
 		return NFT_CMP_GTE;
 	default:
-		BUG("invalid comparison operation %u\n", op);
+		BUG("invalid comparison operation %u", op);
 	}
 }
 
@@ -521,7 +521,7 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 		nft_rule_add_expr(ctx, nle, &expr->location);
 		break;
 	default:
-		BUG("invalid range operation %u\n", expr->op);
+		BUG("invalid range operation %u", expr->op);
 
 	}
 
@@ -606,7 +606,7 @@ static void netlink_gen_relational(struct netlink_linearize_ctx *ctx,
 	case OP_NEG:
 		break;
 	default:
-		BUG("invalid relational operation %u\n", expr->op);
+		BUG("invalid relational operation %u", expr->op);
 	}
 
 	switch (expr->right->etype) {
@@ -741,7 +741,7 @@ static void netlink_gen_bitwise_mask_xor(struct netlink_linearize_ctx *ctx,
 			combine_binop(mask, xor, tmp, val);
 			break;
 		default:
-			BUG("invalid binary operation %u\n", i->op);
+			BUG("invalid binary operation %u", i->op);
 		}
 	}
 
@@ -789,7 +789,7 @@ static void netlink_gen_bitwise_bool(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_OR);
 		break;
 	default:
-		BUG("invalid binary operation %u\n", expr->op);
+		BUG("invalid binary operation %u", expr->op);
 	}
 
 	netlink_gen_expr(ctx, expr->left, dreg);
@@ -833,7 +833,7 @@ static enum nft_byteorder_ops netlink_gen_unary_op(enum ops op)
 	case OP_NTOH:
 		return NFT_BYTEORDER_NTOH;
 	default:
-		BUG("invalid unary operation %u\n", op);
+		BUG("invalid unary operation %u", op);
 	}
 }
 
@@ -961,7 +961,7 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 	case EXPR_XFRM:
 		return netlink_gen_xfrm(ctx, expr, dreg);
 	default:
-		BUG("unknown expression type %s\n", expr_name(expr));
+		BUG("unknown expression type %s", expr_name(expr));
 	}
 }
 
@@ -994,7 +994,7 @@ static void netlink_gen_objref_stmt(struct netlink_linearize_ctx *ctx,
 				   stmt->objref.type);
 		break;
 	default:
-		BUG("unsupported expression %u\n", expr->etype);
+		BUG("unsupported expression %u", expr->etype);
 	}
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
@@ -1082,7 +1082,7 @@ struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
 	case STMT_LAST:
 		return netlink_gen_last_stmt(stmt);
 	default:
-		BUG("unknown stateful statement type %d\n", stmt->type);
+		BUG("unknown stateful statement type %d", stmt->type);
 	}
 }
 
@@ -1241,7 +1241,7 @@ static unsigned int nat_addrlen(uint8_t family)
 	case NFPROTO_IPV6: return 128;
 	}
 
-	BUG("invalid nat family %u\n", family);
+	BUG("invalid nat family %u", family);
 	return 0;
 }
 
@@ -1284,7 +1284,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_reg_pmax = NFTNL_EXPR_REDIR_REG_PROTO_MAX;
 		break;
 	default:
-		BUG("unknown nat type %d\n", stmt->nat.type);
+		BUG("unknown nat type %d", stmt->nat.type);
 		break;
 	}
 
@@ -1772,7 +1772,7 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 	case STMT_OPTSTRIP:
 		return netlink_gen_optstrip_stmt(ctx, stmt);
 	default:
-		BUG("unknown statement type %d\n", stmt->type);
+		BUG("unknown statement type %d", stmt->type);
 	}
 }
 
diff --git a/src/optimize.c b/src/optimize.c
index ffc06480d4ee5..17084a84d4655 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -1181,7 +1181,7 @@ static void rule_optimize_print(struct output_ctx *octx,
 	case INDESC_NETLINK:
 		break;
 	default:
-		BUG("invalid input descriptor type %u\n", indesc->type);
+		BUG("invalid input descriptor type %u", indesc->type);
 	}
 
 	print_location(octx->error_fp, indesc, loc);
diff --git a/src/rule.c b/src/rule.c
index d0a62a3ee002d..14184a70675b7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1450,7 +1450,7 @@ void cmd_free(struct cmd *cmd)
 			flowtable_free(cmd->flowtable);
 			break;
 		default:
-			BUG("invalid command object type %u\n", cmd->obj);
+			BUG("invalid command object type %u", cmd->obj);
 		}
 	}
 	free(cmd->attr);
@@ -1549,7 +1549,7 @@ static int do_command_add(struct netlink_ctx *ctx, struct cmd *cmd, bool excl)
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_add(ctx, cmd, flags);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 	return 0;
 }
@@ -1560,7 +1560,7 @@ static int do_command_replace(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_RULE:
 		return mnl_nft_rule_replace(ctx, cmd);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 	return 0;
 }
@@ -1576,7 +1576,7 @@ static int do_command_insert(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_RULE:
 		return mnl_nft_rule_add(ctx, cmd, flags);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 	return 0;
 }
@@ -1630,7 +1630,7 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_FLOWTABLE:
 		return mnl_nft_flowtable_del(ctx, cmd);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 }
 
@@ -2654,7 +2654,7 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 		break;
 	}
 
-	BUG("invalid command object type %u\n", cmd->obj);
+	BUG("invalid command object type %u", cmd->obj);
 	return 0;
 }
 
@@ -2694,7 +2694,7 @@ static int do_command_get(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_ELEMENTS:
 		return do_get_setelems(ctx, cmd, false);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 
 	return 0;
@@ -2725,7 +2725,7 @@ static int do_command_flush(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_RULESET:
 		return mnl_nft_table_del(ctx, cmd);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 	return 0;
 }
@@ -2743,7 +2743,7 @@ static int do_command_rename(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		return mnl_nft_chain_rename(ctx, cmd, chain);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 	return 0;
 }
@@ -2830,7 +2830,7 @@ int do_command(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_DESCRIBE:
 		return do_command_describe(ctx, cmd, &ctx->nft->output);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
+		BUG("invalid command object type %u", cmd->obj);
 	}
 }
 
diff --git a/src/segtree.c b/src/segtree.c
index 7d4c50f499ef7..3758193efe3fc 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -120,7 +120,7 @@ static struct expr *expr_value(struct expr *expr)
 	case EXPR_VALUE:
 		return expr;
 	default:
-		BUG("invalid expression type %s\n", expr_name(expr));
+		BUG("invalid expression type %s", expr_name(expr));
 	}
 }
 
diff --git a/src/statement.c b/src/statement.c
index 20241f6867a31..d0993ddeac3b3 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -1138,7 +1138,7 @@ const struct stmt_ops *stmt_ops(const struct stmt *stmt)
 
 	ops = __stmt_ops_by_type(stmt->type);
 	if (!ops)
-		BUG("Unknown statement type %d\n", stmt->type);
+		BUG("Unknown statement type %d", stmt->type);
 
 	return ops;
 }
-- 
2.51.0

