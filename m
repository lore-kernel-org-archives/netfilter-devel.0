Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E003F13B14A
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 21:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TATmSgiJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R83x2ct/NGzFXjnFc/97C4dVVdI/JJwgIPztIJFZPSY=; b=TATmSgiJaAMNnrCEsgbeSgJEpX
	MNldDQavO7piXMtS0v0r75OAmmxkHGxvJNOanvmTAwi8EHKoT2smmrriDOSE1/lYCD2ZRqLIt53eD
	9JZr1otwPjHdLJft/Pjd14Xi3wZVjguqRKXKxtXCemaYkpx+UeK8xTwuRPfN9hkhURX5Af/3WpnXg
	JHCSpQx38y2+3isoDIoefdyXENB8yPMDR6KL3hGlHWuqSM/f4o+3s2/uAQfW/YcOPDnV3SDC3+YQl
	Zt08o9rHUvUlKpj0FHkyqrq7+LfLUnZb7oL0omdLPR1sgxZI9ZNMhyZjhlhxNQ8tBJGJy8IRCwL0S
	D4M1LYMA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rEG81-0001ZJ-Ow; Fri, 15 Dec 2023 22:53:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [libnftnl PATCH 3/6] expr: Call expr_ops::set with legal types only
Date: Fri, 15 Dec 2023 22:53:47 +0100
Message-ID: <20231215215350.17691-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215215350.17691-1-phil@nwl.cc>
References: <20231215215350.17691-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Having the new expr_ops::nftnl_max_attr field in place, the valid range
of attribute type values is known now. Reject illegal ones upfront.

Consequently drop the default case from callbacks' switches which handle
all supported attributes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr.c              | 3 +++
 src/expr/bitwise.c      | 2 --
 src/expr/byteorder.c    | 2 --
 src/expr/cmp.c          | 2 --
 src/expr/connlimit.c    | 2 --
 src/expr/counter.c      | 2 --
 src/expr/ct.c           | 2 --
 src/expr/dup.c          | 2 --
 src/expr/exthdr.c       | 2 --
 src/expr/fib.c          | 2 --
 src/expr/flow_offload.c | 2 --
 src/expr/fwd.c          | 2 --
 src/expr/immediate.c    | 2 --
 src/expr/inner.c        | 2 --
 src/expr/last.c         | 2 --
 src/expr/limit.c        | 2 --
 src/expr/log.c          | 2 --
 src/expr/lookup.c       | 2 --
 src/expr/masq.c         | 2 --
 src/expr/match.c        | 2 --
 src/expr/meta.c         | 2 --
 src/expr/nat.c          | 2 --
 src/expr/objref.c       | 2 --
 src/expr/payload.c      | 2 --
 src/expr/queue.c        | 2 --
 src/expr/quota.c        | 2 --
 src/expr/range.c        | 2 --
 src/expr/redir.c        | 2 --
 src/expr/reject.c       | 2 --
 src/expr/rt.c           | 2 --
 src/expr/socket.c       | 2 --
 src/expr/target.c       | 2 --
 src/expr/tproxy.c       | 2 --
 src/expr/tunnel.c       | 2 --
 34 files changed, 3 insertions(+), 66 deletions(-)

diff --git a/src/expr.c b/src/expr.c
index b4581f1a79ff6..74d211bcaa123 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -71,6 +71,9 @@ int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 	case NFTNL_EXPR_NAME:	/* cannot be modified */
 		return 0;
 	default:
+		if (type < NFTNL_EXPR_BASE || type > expr->ops->nftnl_max_attr)
+			return -1;
+
 		if (expr->ops->set(expr, type, data, data_len) < 0)
 			return -1;
 	}
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 69efe1d7e868f..e219d49a5f440 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -56,8 +56,6 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		return nftnl_data_cpy(&bitwise->xor, data, data_len);
 	case NFTNL_EXPR_BITWISE_DATA:
 		return nftnl_data_cpy(&bitwise->data, data, data_len);
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index f05ae59b688eb..8c7661fcc45ce 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -51,8 +51,6 @@ nftnl_expr_byteorder_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BYTEORDER_SIZE:
 		memcpy(&byteorder->size, data, sizeof(byteorder->size));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 40431fad56f3e..fe6f5997a0f3a 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -43,8 +43,6 @@ nftnl_expr_cmp_set(struct nftnl_expr *e, uint16_t type,
 		break;
 	case NFTNL_EXPR_CMP_DATA:
 		return nftnl_data_cpy(&cmp->data, data, data_len);
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index 3b6c36c490636..90613f2241ded 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -38,8 +38,6 @@ nftnl_expr_connlimit_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_CONNLIMIT_FLAGS:
 		memcpy(&connlimit->flags, data, sizeof(connlimit->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 0595d505eb2fc..a003e24c6a68d 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -40,8 +40,6 @@ nftnl_expr_counter_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_CTR_PACKETS:
 		memcpy(&ctr->pkts, data, sizeof(ctr->pkts));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 36b61fdeaaf26..197454e547784 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -50,8 +50,6 @@ nftnl_expr_ct_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_CT_SREG:
 		memcpy(&ct->sreg, data, sizeof(ct->sreg));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 33731cc29b165..20100abf8b3c3 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -37,8 +37,6 @@ static int nftnl_expr_dup_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_DUP_SREG_DEV:
 		memcpy(&dup->sreg_dev, data, sizeof(dup->sreg_dev));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index a1227a6cb4509..77ff7dba37d83 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -66,8 +66,6 @@ nftnl_expr_exthdr_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_EXTHDR_SREG:
 		memcpy(&exthdr->sreg, data, sizeof(exthdr->sreg));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 36637bd74f056..5d2303f9ebe83 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -43,8 +43,6 @@ nftnl_expr_fib_set(struct nftnl_expr *e, uint16_t result,
 	case NFTNL_EXPR_FIB_FLAGS:
 		memcpy(&fib->flags, data, sizeof(fib->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index f60471240cc40..9ab068d29adaa 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -25,8 +25,6 @@ static int nftnl_expr_flow_set(struct nftnl_expr *e, uint16_t type,
 		if (!flow->table_name)
 			return -1;
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 3aaf328313cd9..bd1b1d81eb2ad 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -41,8 +41,6 @@ static int nftnl_expr_fwd_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_FWD_NFPROTO:
 		memcpy(&fwd->nfproto, data, sizeof(fwd->nfproto));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index d60ca32400f18..6ab84171b159d 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -51,8 +51,6 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_IMM_CHAIN_ID:
 		memcpy(&imm->data.chain_id, data, sizeof(uint32_t));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/inner.c b/src/expr/inner.c
index cb6f607138ce3..515f68d7b9d72 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -59,8 +59,6 @@ nftnl_expr_inner_set(struct nftnl_expr *e, uint16_t type,
 
 		inner->expr = (void *)data;
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/last.c b/src/expr/last.c
index 273aaa1e14a85..8aa772c615345 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -37,8 +37,6 @@ static int nftnl_expr_last_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LAST_SET:
 		memcpy(&last->set, data, sizeof(last->set));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/limit.c b/src/expr/limit.c
index a1f9eac390d91..355d46acca4e5 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -52,8 +52,6 @@ nftnl_expr_limit_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LIMIT_FLAGS:
 		memcpy(&limit->flags, data, sizeof(limit->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/log.c b/src/expr/log.c
index 6df030d83fcd2..868da61d95795 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -60,8 +60,6 @@ static int nftnl_expr_log_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LOG_FLAGS:
 		memcpy(&log->flags, data, sizeof(log->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 8b230818c1bed..ca58a38855734 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -53,8 +53,6 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_LOOKUP_FLAGS:
 		memcpy(&lookup->flags, data, sizeof(lookup->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/masq.c b/src/expr/masq.c
index a103cc33e23f7..fa2f4afe2c600 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -42,8 +42,6 @@ nftnl_expr_masq_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_MASQ_REG_PROTO_MAX:
 		memcpy(&masq->sreg_proto_max, data, sizeof(masq->sreg_proto_max));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/match.c b/src/expr/match.c
index eed85db4d40d1..16e73673df325 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -55,8 +55,6 @@ nftnl_expr_match_set(struct nftnl_expr *e, uint16_t type,
 		mt->data = data;
 		mt->data_len = data_len;
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/meta.c b/src/expr/meta.c
index f86fdffd3f14e..1db2c19e21342 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -47,8 +47,6 @@ nftnl_expr_meta_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_META_SREG:
 		memcpy(&meta->sreg, data, sizeof(meta->sreg));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 1d10bc1c5442d..724894a2097d4 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -62,8 +62,6 @@ nftnl_expr_nat_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_NAT_FLAGS:
 		memcpy(&nat->flags, data, sizeof(nat->flags));
 		break;
-	default:
-		return -1;
 	}
 
 	return 0;
diff --git a/src/expr/objref.c b/src/expr/objref.c
index e96bd6977e93a..28cd2cc025b40 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -57,8 +57,6 @@ static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_OBJREF_SET_ID:
 		memcpy(&objref->set.id, data, sizeof(objref->set.id));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/payload.c b/src/expr/payload.c
index f603662ac8da7..73cb188736839 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -66,8 +66,6 @@ nftnl_expr_payload_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_PAYLOAD_FLAGS:
 		memcpy(&payload->csum_flags, data, sizeof(payload->csum_flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/queue.c b/src/expr/queue.c
index fba65d1003b31..3343dd47665e4 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -45,8 +45,6 @@ static int nftnl_expr_queue_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_QUEUE_SREG_QNUM:
 		memcpy(&queue->sreg_qnum, data, sizeof(queue->sreg_qnum));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/quota.c b/src/expr/quota.c
index d3923f3197900..2a3a05a82d6a2 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -41,8 +41,6 @@ static int nftnl_expr_quota_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_QUOTA_FLAGS:
 		memcpy(&quota->flags, data, sizeof(quota->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/range.c b/src/expr/range.c
index cb3708c8a003d..d0c52b9a71938 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -43,8 +43,6 @@ static int nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
 		return nftnl_data_cpy(&range->data_from, data, data_len);
 	case NFTNL_EXPR_RANGE_TO_DATA:
 		return nftnl_data_cpy(&range->data_to, data, data_len);
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/redir.c b/src/expr/redir.c
index eca8bfe1abd4c..a5a5e7d5677f9 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -42,8 +42,6 @@ nftnl_expr_redir_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_REDIR_FLAGS:
 		memcpy(&redir->flags, data, sizeof(redir->flags));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 6b923adf5e569..8a0653d0f674c 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -38,8 +38,6 @@ static int nftnl_expr_reject_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_REJECT_CODE:
 		memcpy(&reject->icmp_code, data, sizeof(reject->icmp_code));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/rt.c b/src/expr/rt.c
index aaec43025011b..de2bd2f1f90a5 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -37,8 +37,6 @@ nftnl_expr_rt_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_RT_DREG:
 		memcpy(&rt->dreg, data, sizeof(rt->dreg));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/socket.c b/src/expr/socket.c
index ef299c456cdd1..9b6c3ea3ebb50 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -41,8 +41,6 @@ nftnl_expr_socket_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_SOCKET_LEVEL:
 		memcpy(&socket->level, data, sizeof(socket->level));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/target.c b/src/expr/target.c
index ebc48bafb06cc..cc0566c1d4b8f 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -55,8 +55,6 @@ nftnl_expr_target_set(struct nftnl_expr *e, uint16_t type,
 		tg->data = data;
 		tg->data_len = data_len;
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index ac5419b1f3405..c6ed888161918 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -42,8 +42,6 @@ nftnl_expr_tproxy_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_TPROXY_REG_PORT:
 		memcpy(&tproxy->sreg_port, data, sizeof(tproxy->sreg_port));
 		break;
-	default:
-		return -1;
 	}
 
 	return 0;
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index e381994707fe9..e59744b070f50 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -36,8 +36,6 @@ static int nftnl_expr_tunnel_set(struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_TUNNEL_DREG:
 		memcpy(&tunnel->dreg, data, sizeof(tunnel->dreg));
 		break;
-	default:
-		return -1;
 	}
 	return 0;
 }
-- 
2.43.0

