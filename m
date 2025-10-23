Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D9B246BDE
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235569; cv=none; b=fJhr2wUUy59c1Xc1vWqSyZpBFjbhy5jOOe7CT4P+tm5FSB/m+fQKeJdlBtLsCuvMN/tY8hWwCijsEuVKabd9df5RPb1yv6mDERuE3gdUhPOxWUEK/NXgp1xZKcXrlbT8Hzie3Eq65Il8VJ7XdX/HadmYQj5FbfUekFl+kDn+ARs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235569; c=relaxed/simple;
	bh=+pjaZNzWGsVAOEvfSZKVq5X8TomCylPMGLpbZsCbPX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE7VsOsimJAydUTIDPjoXh24h4HE9u9UZAfbGH2PjCPH6/dHoVdfxi7JFEA1x9DX8tpTCbIqZ5cOPdzxM4edUHGhGU7Ob+fms/5ZyTrmLKJOnyjJqNGmR+amAfmULzNVNzFqso2MGC2J42gYSrg5DZ/cC0ppBToKPRJH71dAqIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=H0m6V261; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="H0m6V261"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rKECV11uN5Um8uf9nSATHhN/xMkecRiY+Ozc9Al2KIY=; b=H0m6V261TWqVKN67DqEDhDDYWM
	eydNrIcVsFiqvjHLttzOZ+/zBrGZLKJNFkg40Lx8Wy3zcocV+AH4IsBycnV+K0awgm7ARyeDTOM5o
	fvlessunehPDV88Oqy0fnTilKs85qPKL2I4TG95kPpLegDNo3hu/6TXomV5TqNXj/eCnN2i4eOmgB
	0PD3H3KQYcEe2CZIYV0LxB8Pr+uP+YUgQFAWILsubceNrTwQXsz7wOMteJxTBdxGMu21u8eATpZS4
	o0gPS9P9EoLxgQN2ORJTyXThs0wPrM9pqMxrpw30S5kruffkq7UzYVRnUYXJYJ3WFakh1+cSkXF17
	ZiQ3snOg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxp7-000000007cU-2qqx;
	Thu, 23 Oct 2025 18:05:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 2/9] expr: data_reg: Avoid extra whitespace
Date: Thu, 23 Oct 2025 18:05:40 +0200
Message-ID: <20251023160547.10928-3-phil@nwl.cc>
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

Do not append a space to data regs, they may appear at end of line or
followed by a tab. Have callers print the space if needed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/bitwise.c   |  7 +++++--
 src/expr/cmp.c       |  3 +++
 src/expr/data_reg.c  | 11 +++++------
 src/expr/immediate.c |  3 +++
 src/expr/range.c     |  6 ++++++
 src/set_elem.c       |  4 ++--
 6 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index cac47a5500993..2da83b7ba0441 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -225,13 +225,16 @@ nftnl_expr_bitwise_snprintf_mask_xor(char *buf, size_t remain,
 				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf + offset, remain, ") ^ ");
+	ret = snprintf(buf + offset, remain, " ) ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
 				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	ret = snprintf(buf + offset, remain, " ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 	return offset;
 }
 
@@ -248,7 +251,7 @@ nftnl_expr_bitwise_snprintf_shift(char *buf, size_t remain, const char *op,
 				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = snprintf(buf + offset, remain, ") ");
+	ret = snprintf(buf + offset, remain, " ) ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 2908f56325b45..ec1dc31894771 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -163,6 +163,9 @@ nftnl_expr_cmp_snprintf(char *buf, size_t remain,
 				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	ret = snprintf(buf + offset, remain, " ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 	return offset;
 }
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index fd5e0d6e749e1..bf4153c072fd0 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -25,15 +25,14 @@ nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 				      const union nftnl_data_reg *reg,
 				      uint32_t flags)
 {
-	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x";
+	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x", *sep = "";
 	int offset = 0, ret, i;
 
-
-
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
 		ret = snprintf(buf + offset, remain,
-			       "%s%.8x ", pfx, reg->val[i]);
+			       "%s%s%.8x", sep, pfx, reg->val[i]);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		sep = " ";
 	}
 
 	return offset;
@@ -46,11 +45,11 @@ nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
 {
 	int remain = size, offset = 0, ret = 0;
 
-	ret = snprintf(buf, size, "%s ", nftnl_verdict2str(reg->verdict));
+	ret = snprintf(buf, size, "%s", nftnl_verdict2str(reg->verdict));
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (reg->chain != NULL) {
-		ret = snprintf(buf + offset, remain, "-> %s ", reg->chain);
+		ret = snprintf(buf + offset, remain, " -> %s", reg->chain);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index f0e0a78d6b794..6dffaf9ce4ad9 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -201,6 +201,9 @@ nftnl_expr_immediate_snprintf(char *buf, size_t remain,
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
+	ret = snprintf(buf + offset, remain, " ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 	return offset;
 }
 
diff --git a/src/expr/range.c b/src/expr/range.c
index 50a8ed092e38f..564d14f0edbbb 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -176,10 +176,16 @@ static int nftnl_expr_range_snprintf(char *buf, size_t remain,
 				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	ret = snprintf(buf + offset, remain, " ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &range->data_to,
 				      0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
+	ret = snprintf(buf + offset, remain, " ");
+	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
 	return offset;
 }
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 6c1be44ce5073..f567a28719d11 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -720,12 +720,12 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 					      DATA_F_NOPFX, dregtype);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	} else if (e->flags & (1 << NFTNL_SET_ELEM_OBJREF)) {
-		ret = snprintf(buf + offset, remain, " : %s ", e->objref);
+		ret = snprintf(buf + offset, remain, " : %s", e->objref);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	if (e->set_elem_flags) {
-		ret = snprintf(buf + offset, remain, "flags %u ", e->set_elem_flags);
+		ret = snprintf(buf + offset, remain, " flags %u", e->set_elem_flags);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-- 
2.51.0

