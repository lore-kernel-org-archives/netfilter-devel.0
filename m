Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4311526F2B0
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235572; cv=none; b=mHtJckYzATwOEN/bWFOWhDNrw+BGPgDW/atY712TPX8zVzg+bMU5qjtudMyomFqhhGQaW0r7UogNwBN8L/yd9huNSTW8nBLDRKvYMxdUyGDxuAJ9KbyDJHj7lcynpvE7QMHKh4LsGHFAVKnUwt/wCodlemRE3PLsjz7uk/mLMUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235572; c=relaxed/simple;
	bh=65Ux0S2/eZ/xa/ynclKCVgKSWLMNBKExfQEkz8W+6PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQo3vqHwPY8NATCte3e2G1EjLJzS1xBPikZJkrH/veDVRx7rkAv+oxANY9C8j8kq2e7x/4/ZuYyllmT2Uo6Ja5HuD00z912SnF+g57aFoaPp+GKt82SLZnJbZRpnqfXc2Ab4OejqjPGAjEFp8mHsDR/FVIBRwuaG/4FHWx3qje4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jyP8ROLq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jyP8ROLq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XQAlbS97gDwUVzN2SvoKL+cx8BhyJ6ga4VWF2zib29U=; b=jyP8ROLqCx/883sIM7SNAPm5gb
	ZYYFW1s77JYkTG1qTElTKR+Uj1QVOmsPtmskkpIGv8hV3QlrvC7hA9mmADXdfB8m24ng2nCfTkSin
	t+P/eamfGksdq9p+HsMWzy2Cn5bmBmU5Zwv/1305qX3AaBC3+XaN8+RP/z2idezYH0XFbmVnbHNCv
	siDm2ul1LOxAP7Hok1mKPk4fi8ESwPzKSTWvXuwIHSLEn6hqD7kBbVEaPPHom+w6Z2iocGmZWDwrq
	0ImZVRfQ38b5KL6uA8noGiod4sFybEsGwnIiA5+Lvjo/AyObayGZyYmxJ2tUrvjiLw/dlRZdstaJi
	Uw/nTuuQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpD-000000007fR-1qbw;
	Thu, 23 Oct 2025 18:06:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 4/9] data_reg: Introduce struct nftnl_data_reg::byteorder field
Date: Thu, 23 Oct 2025 18:05:42 +0200
Message-ID: <20251023160547.10928-5-phil@nwl.cc>
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

Expression setters populate it from the passed 'byteorder' parameter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/data_reg.h   | 4 +++-
 src/expr/bitwise.c   | 6 +++---
 src/expr/cmp.c       | 2 +-
 src/expr/data_reg.c  | 4 +++-
 src/expr/immediate.c | 2 +-
 src/expr/range.c     | 6 ++++--
 src/set_elem.c       | 6 +++---
 7 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index 946354dc9881c..e22acd1b9a290 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -21,6 +21,7 @@ union nftnl_data_reg {
 	struct {
 		uint32_t	val[NFT_DATA_VALUE_MAXLEN / sizeof(uint32_t)];
 		uint32_t	len;
+		uint32_t	byteorder;
 	};
 	struct {
 		uint32_t	verdict;
@@ -35,6 +36,7 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 struct nlattr;
 
 int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type);
-int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src, uint32_t len);
+int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src,
+		   uint32_t len, uint32_t byteorder);
 
 #endif
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index da2b6d2ee57ec..a7752856cf957 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -51,11 +51,11 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->len, data, data_len);
 		break;
 	case NFTNL_EXPR_BITWISE_MASK:
-		return nftnl_data_cpy(&bitwise->mask, data, data_len);
+		return nftnl_data_cpy(&bitwise->mask, data, data_len, byteorder);
 	case NFTNL_EXPR_BITWISE_XOR:
-		return nftnl_data_cpy(&bitwise->xor, data, data_len);
+		return nftnl_data_cpy(&bitwise->xor, data, data_len, byteorder);
 	case NFTNL_EXPR_BITWISE_DATA:
-		return nftnl_data_cpy(&bitwise->data, data, data_len);
+		return nftnl_data_cpy(&bitwise->data, data, data_len, byteorder);
 	}
 	return 0;
 }
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 4bcf2e4bce83e..c88e06aee2356 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -38,7 +38,7 @@ nftnl_expr_cmp_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&cmp->op, data, data_len);
 		break;
 	case NFTNL_EXPR_CMP_DATA:
-		return nftnl_data_cpy(&cmp->data, data, data_len);
+		return nftnl_data_cpy(&cmp->data, data, data_len, byteorder);
 	}
 	return 0;
 }
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index bf4153c072fd0..45f2d94881c61 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -201,7 +201,8 @@ int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type)
 	return ret;
 }
 
-int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src, uint32_t len)
+int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src,
+		   uint32_t len, uint32_t byteorder)
 {
 	int ret = 0;
 
@@ -212,5 +213,6 @@ int nftnl_data_cpy(union nftnl_data_reg *dreg, const void *src, uint32_t len)
 
 	memcpy(dreg->val, src, len);
 	dreg->len = len;
+	dreg->byteorder = byteorder;
 	return ret;
 }
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 27ee6003d3f08..f27b6e6b08f57 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -32,7 +32,7 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&imm->dreg, data, data_len);
 		break;
 	case NFTNL_EXPR_IMM_DATA:
-		return nftnl_data_cpy(&imm->data, data, data_len);
+		return nftnl_data_cpy(&imm->data, data, data_len, byteorder);
 	case NFTNL_EXPR_IMM_VERDICT:
 		memcpy(&imm->data.verdict, data, data_len);
 		break;
diff --git a/src/expr/range.c b/src/expr/range.c
index cd6d6fbeb4ea2..4b3101ee88efa 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -37,9 +37,11 @@ nftnl_expr_range_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&range->op, data, data_len);
 		break;
 	case NFTNL_EXPR_RANGE_FROM_DATA:
-		return nftnl_data_cpy(&range->data_from, data, data_len);
+		return nftnl_data_cpy(&range->data_from, data,
+				      data_len, byteorder);
 	case NFTNL_EXPR_RANGE_TO_DATA:
-		return nftnl_data_cpy(&range->data_to, data, data_len);
+		return nftnl_data_cpy(&range->data_to, data,
+				      data_len, byteorder);
 	}
 	return 0;
 }
diff --git a/src/set_elem.c b/src/set_elem.c
index f567a28719d11..19fd14a1fa900 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -122,11 +122,11 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		memcpy(&s->set_elem_flags, data, sizeof(s->set_elem_flags));
 		break;
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
-		if (nftnl_data_cpy(&s->key, data, data_len) < 0)
+		if (nftnl_data_cpy(&s->key, data, data_len, 0) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_KEY_END:	/* NFTA_SET_ELEM_KEY_END */
-		if (nftnl_data_cpy(&s->key_end, data, data_len) < 0)
+		if (nftnl_data_cpy(&s->key_end, data, data_len, 0) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
@@ -141,7 +141,7 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
-		if (nftnl_data_cpy(&s->data, data, data_len) < 0)
+		if (nftnl_data_cpy(&s->data, data, data_len, 0) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
-- 
2.51.0

