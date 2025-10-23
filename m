Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1E926F2A6
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235576; cv=none; b=MaySoOf1Sc0tsbd5b+3kKh154X4V4Pt/VbWhBegkDb0xVUsz29b+TcY9Z5m20aBZxSS7COSzBEFeHPzfL7DFFFMVinPjQQwL8HCATjazgoGvTzrFakE2ju6zfX7bnu7nfpVPyVQ27UdA9SnZ4nk5E2Q6yeUalBRgDE413hUnIp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235576; c=relaxed/simple;
	bh=tzwmZoJmBCpf0Q++QX0Nq8z7tkO0bOib0FvjbqE0pzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCfV5Qf6iCOfIX+tvtcBYbZpcaGQA28+SEN6RbAewLcvgbf9FwpLvqr+XEEw3eP7qxIEggvsHruMHrno6OV5tnstUrrNysMIIwsznxpKgbDvaiVhW0i7SxWuIePxecg6/DjrpFIf82hMyfPZVk5Di80aOvGCUdmZUh2//PkETFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=H94O5TQE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="H94O5TQE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oLV15NoYmIyBDuBCZVisVi95BaHkpJ7HIhp7eFtkhXw=; b=H94O5TQEVAb1gDHqn3s3OCvbMh
	OhfO+IcEyS4LUocZ4FRnDGVJEupNeb5e1yNGOf9MOFlzEVfgwH1SYo81G+EYr8e5UzuAtHMMjnsys
	2RahzjHxJ0Nvf6xhm2xnx333504Lj2JP6CfBOdIYhuSYZwmOhDRHmYMrYwMEbYCTYDuox+2LsXPFP
	eop2lw/6luZuLM/zjxWDqReV3NKq7OnwceyjJWfDwwAQVBoTZWOE4eQJutzirg7WbS/txkPKuLZyA
	ACAWSiR7EU9RSe0ibQGUBMGZH/HsvuARmRhZdGUbiBJ/tDCy9pQ6KN7HEn1NT9XeuEBVZDndpVfQM
	VQjRJ3Vw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpF-000000007fb-1dnT;
	Thu, 23 Oct 2025 18:06:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 5/9] data_reg: Introduce struct nftnl_data_reg::sizes array
Date: Thu, 23 Oct 2025 18:05:43 +0200
Message-ID: <20251023160547.10928-6-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023160547.10928-1-phil@nwl.cc>
References: <20251023160547.10928-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will hold the actual size of each component in concatenated data.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/data_reg.h   | 3 ++-
 src/expr/bitwise.c   | 9 ++++++---
 src/expr/cmp.c       | 3 ++-
 src/expr/data_reg.c  | 6 +++++-
 src/expr/immediate.c | 3 ++-
 src/expr/range.c     | 4 ++--
 src/set_elem.c       | 6 +++---
 7 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index e22acd1b9a290..5cdeba07cb1e6 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -22,6 +22,7 @@ union nftnl_data_reg {
 		uint32_t	val[NFT_DATA_VALUE_MAXLEN / sizeof(uint32_t)];
 		uint32_t	len;
 		uint32_t	byteorder;
+		uint8_t		sizes[NFT_REG32_COUNT];
 	};
 	struct {
 		uint32_t	verdict;
@@ -37,6 +38,6 @@ struct nlattr;
 
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
 int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src,
-		   uint32_t len, uint32_t byteorder);
+		   uint32_t len, uint32_t byteorder, uint8_t *sizes);
 
 #endif
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index a7752856cf957..a838e6cc1abf2 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -51,11 +51,14 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->len, data, data_len);
 		break;
 	case NFTNL_EXPR_BITWISE_MASK:
-		return nftnl_data_cpy(&bitwise->mask, data, data_len, byteorder);
+		return nftnl_data_cpy(&bitwise->mask, data,
+				      data_len, byteorder, NULL);
 	case NFTNL_EXPR_BITWISE_XOR:
-		return nftnl_data_cpy(&bitwise->xor, data, data_len, byteorder);
+		return nftnl_data_cpy(&bitwise->xor, data,
+				      data_len, byteorder, NULL);
 	case NFTNL_EXPR_BITWISE_DATA:
-		return nftnl_data_cpy(&bitwise->data, data, data_len, byteorder);
+		return nftnl_data_cpy(&bitwise->data, data,
+				      data_len, byteorder, NULL);
 	}
 	return 0;
 }
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index c88e06aee2356..ec5dd62efdab3 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -38,7 +38,8 @@ nftnl_expr_cmp_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&cmp->op, data, data_len);
 		break;
 	case NFTNL_EXPR_CMP_DATA:
-		return nftnl_data_cpy(&cmp->data, data, data_len, byteorder);
+		return nftnl_data_cpy(&cmp->data, data,
+				      data_len, byteorder, NULL);
 	}
 	return 0;
 }
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 45f2d94881c61..d1aadcc257f3f 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -202,7 +202,7 @@ int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type)
 }
 
 int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src,
-		   uint32_t len, uint32_t byteorder)
+		   uint32_t len, uint32_t byteorder, uint8_t *sizes)
 {
 	int ret = 0;
 
@@ -214,5 +214,9 @@ int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src,
 	memcpy(dreg->val, src, len);
 	dreg->len = len;
 	dreg->byteorder = byteorder;
+	if (sizes)
+		memcpy(dreg->sizes, sizes, sizeof(dreg->sizes));
+	else
+		memset(dreg->sizes, 0, sizeof(dreg->sizes));
 	return ret;
 }
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index f27b6e6b08f57..94531984bafc9 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -32,7 +32,8 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&imm->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_IMM_DATA:
-		return nftnl_data_cpy(&imm->data, data, data_len, byteorder);
+		return nftnl_data_cpy(&imm->data, data,
+				      data_len, byteorder, NULL);
 	case NFTNL_EXPR_IMM_VERDICT:
 		memcpy(&imm->data.verdict, data, data_len);
 		break;
diff --git a/src/expr/range.c b/src/expr/range.c
index 4b3101ee88efa..12c91e9e2f1fc 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -38,10 +38,10 @@ nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
 		break;
 	case NFTNL_EXPR_RANGE_FROM_DATA:
 		return nftnl_data_cpy(&range->data_from, data,
-				      data_len, byteorder);
+				      data_len, byteorder, NULL);
 	case NFTNL_EXPR_RANGE_TO_DATA:
 		return nftnl_data_cpy(&range->data_to, data,
-				      data_len, byteorder);
+				      data_len, byteorder, NULL);
 	}
 	return 0;
 }
diff --git a/src/set_elem.c b/src/set_elem.c
index 19fd14a1fa900..96dc4aafb606f 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -122,11 +122,11 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		memcpy(&s->set_elem_flags, data, sizeof(s->set_elem_flags));
 		break;
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
-		if (nftnl_data_cpy(&s->key, data, data_len, 0) < 0)
+		if (nftnl_data_cpy(&s->key, data, data_len, 0, NULL) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_KEY_END:	/* NFTA_SET_ELEM_KEY_END */
-		if (nftnl_data_cpy(&s->key_end, data, data_len, 0) < 0)
+		if (nftnl_data_cpy(&s->key_end, data, data_len, 0, NULL) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
@@ -141,7 +141,7 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
-		if (nftnl_data_cpy(&s->data, data, data_len, 0) < 0)
+		if (nftnl_data_cpy(&s->data, data, data_len, 0, NULL) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
-- 
2.51.0

