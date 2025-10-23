Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0C526F2BC
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235569; cv=none; b=jH6B7sPpF7MfNYf0vjgJ9pInbrKko/BK6Ew+gQUe0HCMiSH3O1FXP42MJf+wvebz7cIjM2dJKZ0/4iyuEKocXVkaZPYvPQvxeompbnicqV6RDudSZYtKWPy46I/IL2llQLRzDEtDKI3L4TGZsdVwUBGl2KaZwrSs0GopNWGFwbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235569; c=relaxed/simple;
	bh=Lu8sOaNrOIKrc0gENcUdpHPc1JlWkEVtfNpTPsckRwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YufS99ww+w554NiW5mD5pYffNf+cEqV1S4uOxM0rd9mni1p4wx5t6lS1KEkuPKZ7ffYyG+P3XwyAhSyXS7JFOOR6/ZNb3nTQjWawevTpK77re3GUQkFWM7RDIIo01jw3oZYMjkvntLJWqjOlWpCLY9iZCi8JHyhSBOueHJCxjK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EsV3nkH2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EsV3nkH2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=quwr7oTmpOPg2hkA+Mcr704hT+wcF9NWzyoTswXVHBQ=; b=EsV3nkH2e9zYLum1kfuj/zB+A3
	DnbuJyBrZJTJ1muJYzl4jNxo4UPlafD2bhQ0eSTFpkc903BvS7WylT0zOMN06TjcrLD/QteIo2R9w
	dyeFbF6dYtlvN4nKf52s2Pob1Jnu/XEbgeMNUiyF+Ho+Dy+74dIQCi5sTdkiRgWMoPplqkKl/ccx/
	lIZLj/05ZVxajoNhbm1AoOxeQB1+Rfv32Ecf/M3jkZNZUq0CAHyqTIJDS0CNOnGVYVNnFQVm4NFwI
	C/vrikDn/beM8R978FjI5E36EQJ1ZkngKLo0cxhQvYL/BZQq2g4BC2NXEO1ResIvQSUzV5JHecIFf
	KNg/fM/A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxp9-000000007ca-1pUA;
	Thu, 23 Oct 2025 18:06:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 8/9] data_reg: Support concatenated data
Date: Thu, 23 Oct 2025 18:05:46 +0200
Message-ID: <20251023160547.10928-9-phil@nwl.cc>
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

If sizes array has non-zero field values, interpret byteorder field as
bitfield indicating each compontent's byteorder and print the components
separated by a dot.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/data_reg.c | 48 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index de5d23501c92d..d01e0f7d9969e 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -27,34 +27,62 @@ static bool big_endian_host(void)
 	return v == htons(v);
 }
 
-static int
-nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
-				      const union nftnl_data_reg *reg,
-				      uint32_t flags)
+static int __reg_value_snprintf(char *buf, size_t remain,
+				uint8_t *data, size_t datalen,
+				bool reverse, const char *pfx)
 {
-	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x", *sep = "";
-	bool reverse = reg->byteorder && !big_endian_host();
 	int offset = 0, ret, i, idx;
+	const char *sep = "";
 
-	for (i = 0; i < reg->len; i++) {
+	for (i = 0; i < datalen; i++) {
 		if ((i % 4) == 0) {
 			ret = snprintf(buf + offset, remain, "%s%s", sep, pfx);
 			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 			sep = " ";
 		}
 		if (reverse)
-			idx = reg->len - i - 1;
+			idx = datalen - i - 1;
 		else
 			idx = i;
 
-		ret = snprintf(buf + offset, remain, "%.2x",
-			       ((uint8_t *)reg->val)[idx]);
+		ret = snprintf(buf + offset, remain, "%.2x", data[idx]);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
 	return offset;
 }
 
+static int
+nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
+				      const union nftnl_data_reg *reg,
+				      uint32_t flags)
+{
+	uint32_t byteorder = big_endian_host() ? 0 : reg->byteorder;
+	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x";
+	int offset = 0, ret, i, pos = 0;
+
+	for (i = 0; i < array_size(reg->sizes); i++) {
+		int curlen = reg->sizes[i] ?: reg->len;
+		bool reverse = byteorder & (1 << i);
+
+		if (i > 0) {
+			ret = snprintf(buf + offset, remain, " . ");
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		}
+
+		ret = __reg_value_snprintf(buf + offset, remain,
+					   (void *)&reg->val[pos],
+					   curlen, reverse, pfx);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+
+		pos += div_round_up(curlen, sizeof(uint32_t));
+		if (pos >= reg->len / sizeof(uint32_t))
+			break;
+	}
+
+	return offset;
+}
+
 static int
 nftnl_data_reg_verdict_snprintf_def(char *buf, size_t size,
 				    const union nftnl_data_reg *reg,
-- 
2.51.0

