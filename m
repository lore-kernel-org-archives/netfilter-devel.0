Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1922701B8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235571; cv=none; b=Khs0+Ap3xbz0QTn3FnGm/FgmdNqhfKAHQ+U4+g1lMivqvGXFb1OqvtyWVvDxqR8s3Vwtzfp6wbvGcOluVMw2DcLtjx53vg3yRErq2mmCRKcQHAzST4PFpImRGGp74cd0pvXFkzK1uzVJYwmdtYUpHJl9WlS44FxIg9Mj19zL1U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235571; c=relaxed/simple;
	bh=bv0/LOoxrpRYYSV2oSfLjYSHx2T78bYD60bLGUOoQus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4EU7qfQI0hpmGjEYNY7hDhZVY0bhsiN7fCr36T9qIvr69gC/AMMUm6K+Hrsaou4MOSKoSCMqoanYFdy51ZmjZG3PkfANpgKdpZNtlB3XE37mI9V+Fl5tfVF9vSu/h+oRsGqlEv/sE5O9cuek4KYhQTYBCAf3W0a1M+dN6NjAYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=cLQoBVWK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="cLQoBVWK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f5TT4/RaXQUbnTMLTA6hGkeMRwQlT+M2d98AQ3O6ucs=; b=cLQoBVWKJ+bqIz9X/pgw29RbkH
	FtBT6qADAUiWjow/t4MGhYF1IiYurTlvk+6UHrxa+M3cC+PFRMcTapNV+mj8G3tNR+V/YKswct1D6
	6l60ssvd7E76a9q31BmDHcZt1rHkasrt3z22x5labY5o4wKKVmZfc3hJFYXLZpibJkIKTbX4lECgJ
	NbjWgI5nPt+r0A5yxPopBts6U+IS0aBjEsTaZvXkHQQV/2JklcGzi/4t7GekFYROoeHbdzOxs+AxF
	1WPykCJLatP8t2K2bTuPYbSW9o72Ycykz83GE9+xhCy0JoGS2JAdLk3ek6+rVIpRKyBDe4uhe9I6f
	rD7Q/+ZA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpB-000000007fF-3KRp;
	Thu, 23 Oct 2025 18:06:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 6/9] Introduce nftnl_{expr,set_elem}_set_imm()
Date: Thu, 23 Oct 2025 18:05:44 +0200
Message-ID: <20251023160547.10928-7-phil@nwl.cc>
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

These are alternatives to nftnl_{expr,set_elem}_set() which accept
byteorder and concat component size information.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/expr.h |  1 +
 include/libnftnl/set.h  |  1 +
 src/expr.c              |  7 +++++++
 src/libnftnl.map        |  5 +++++
 src/set_elem.c          | 30 ++++++++++++++++++++++++------
 5 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 1c07b54139a57..41e9f301d7487 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -21,6 +21,7 @@ void nftnl_expr_free(const struct nftnl_expr *expr);
 
 bool nftnl_expr_is_set(const struct nftnl_expr *expr, uint16_t type);
 int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type, const void *data, uint32_t data_len);
+int nftnl_expr_set_imm(struct nftnl_expr *expr, uint16_t type, const void *data, uint32_t data_len, uint32_t byteorder);
 #define nftnl_expr_set_data nftnl_expr_set
 void nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t data);
 void nftnl_expr_set_u16(struct nftnl_expr *expr, uint16_t type, uint16_t data);
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index cad5e8e81c7ab..f2edca20f9e07 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -131,6 +131,7 @@ void nftnl_set_elem_add(struct nftnl_set *s, struct nftnl_set_elem *elem);
 
 void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr);
 int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const void *data, uint32_t data_len);
+int nftnl_set_elem_set_imm(struct nftnl_set_elem *s, uint16_t attr, const void *data, uint32_t data_len, uint32_t byteorder, uint8_t *sizes);
 void nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, uint32_t val);
 void nftnl_set_elem_set_u64(struct nftnl_set_elem *s, uint16_t attr, uint64_t val);
 int nftnl_set_elem_set_str(struct nftnl_set_elem *s, uint16_t attr, const char *str);
diff --git a/src/expr.c b/src/expr.c
index d07e7332efd78..0fec358e74806 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -91,6 +91,13 @@ int nftnl_expr_set(struct nftnl_expr *expr, uint16_t type,
 	return __nftnl_expr_set(expr, type, data, data_len, 0);
 }
 
+EXPORT_SYMBOL(nftnl_expr_set_imm);
+int nftnl_expr_set_imm(struct nftnl_expr *expr, uint16_t type,
+		       const void *data, uint32_t data_len, uint32_t byteorder)
+{
+	return __nftnl_expr_set(expr, type, data, data_len, byteorder);
+}
+
 EXPORT_SYMBOL(nftnl_expr_set_u8);
 void
 nftnl_expr_set_u8(struct nftnl_expr *expr, uint16_t type, uint8_t data)
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 10c0e7fcff4da..daca971338897 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -399,3 +399,8 @@ nftnl_obj_tunnel_opts_foreach;
 nftnl_tunnel_opts_add;
 nftnl_tunnel_opts_free;
 } LIBNFTNL_17;
+
+LIBNFTNL_19 {
+  nftnl_expr_set_imm;
+  nftnl_set_elem_set_imm;
+} LIBNFTNL_18;
diff --git a/src/set_elem.c b/src/set_elem.c
index 96dc4aafb606f..d22643c44dd71 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -108,9 +108,9 @@ static uint32_t nftnl_set_elem_validate[NFTNL_SET_ELEM_MAX + 1] = {
 	[NFTNL_SET_ELEM_EXPIRATION]	= sizeof(uint64_t),
 };
 
-EXPORT_SYMBOL(nftnl_set_elem_set);
-int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
-		       const void *data, uint32_t data_len)
+static int
+__nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const void *data,
+		     uint32_t data_len, uint32_t byteorder, uint8_t *sizes)
 {
 	struct nftnl_expr *expr, *tmp;
 
@@ -122,11 +122,13 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		memcpy(&s->set_elem_flags, data, sizeof(s->set_elem_flags));
 		break;
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
-		if (nftnl_data_cpy(&s->key, data, data_len, 0, NULL) < 0)
+		if (nftnl_data_cpy(&s->key, data,
+				   data_len, byteorder, sizes) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_KEY_END:	/* NFTA_SET_ELEM_KEY_END */
-		if (nftnl_data_cpy(&s->key_end, data, data_len, 0, NULL) < 0)
+		if (nftnl_data_cpy(&s->key_end, data,
+				   data_len, byteorder, sizes) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
@@ -141,7 +143,8 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
-		if (nftnl_data_cpy(&s->data, data, data_len, 0, NULL) < 0)
+		if (nftnl_data_cpy(&s->data, data,
+				   data_len, byteorder, sizes) < 0)
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
@@ -180,6 +183,21 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 	return 0;
 }
 
+EXPORT_SYMBOL(nftnl_set_elem_set);
+int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
+		       const void *data, uint32_t data_len)
+{
+	return __nftnl_set_elem_set(s, attr, data, data_len, 0, NULL);
+}
+
+EXPORT_SYMBOL(nftnl_set_elem_set_imm);
+int nftnl_set_elem_set_imm(struct nftnl_set_elem *s, uint16_t attr,
+			   const void *data, uint32_t data_len,
+			   uint32_t byteorder, uint8_t *sizes)
+{
+	return __nftnl_set_elem_set(s, attr, data, data_len, byteorder, sizes);
+}
+
 EXPORT_SYMBOL(nftnl_set_elem_set_u32);
 void nftnl_set_elem_set_u32(struct nftnl_set_elem *s, uint16_t attr, uint32_t val)
 {
-- 
2.51.0

