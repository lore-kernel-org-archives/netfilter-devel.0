Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CED15ECCC
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235569; cv=none; b=oBOG+5lvCkh4nAIukbhLCnSTCfg5KzYhjNQeAFzpMF+yoJhhktCmWaXajKv2webeToiIyNWtk1NraZsU5BpLqqOcGh8afaxM6COgMUT+xks6soZKbW+VajLDC7WfxdbOQe0CstuYJ93zqPRmFVLptaEjwYtHJWa84gH+/5XxP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235569; c=relaxed/simple;
	bh=sKweWDl72gTL0RCcN0F7j80CL3676TKruTcArRMp+bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3RKM9wVP+l1Alih/jT1vTZJapCj36l9lFMlq4AUS8HM1gu9/Sj5K1u52HAc25qmj5XIffHnN9i9cICyyUZb4fuEIVLL8sKtvupgUKuJ0HbxkU6VpSDORr9HURN7rxtePPREPNq0VVZtGOkvdKU1QaJZbXZj7cgxIevIBuRIF6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ao+RFL/y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ao+RFL/y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zqCnX/USs7Le6t64UIZtbXlxBjlaYz//1lT0Ez8d6Vc=; b=Ao+RFL/ysFcjXNCY/M62VMpJfh
	SEF47msPp9HmEzIWdu1CaCOt5fA663WkE59XyimbwhP8nxEtmn8u/1JuClz5oaOZ5jWvla2yOYVNl
	xBmY8GoJUImW2WfB0+Vf1cwi8GwkUAPpo5pCWQRmk0f4CendWNcCe7+lVq65eI2dRPeW+p6fqMt3z
	NRIvFdlHGVKb2I2a0eCnpEBcnIW6x9N69uOOIumI9VaR5QvoU3ICo6RTjUYWtMPu9xCvf2fvA7dI8
	3WLdQjvZHtHKINDmv4B5X4Fqs5slbsbm5ML2S77Fc0nB+RTtgBClZ+8csHSq5eTAfhHDx60Qasv/4
	xXMfpK6w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxpE-000000007fW-1pHa;
	Thu, 23 Oct 2025 18:06:04 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 7/9] data_reg: Respect data byteorder when printing
Date: Thu, 23 Oct 2025 18:05:45 +0200
Message-ID: <20251023160547.10928-8-phil@nwl.cc>
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

Print data from most significant byte to least significant one. Also
print only reg->len bytes of data, not every non-empty u32. Still
separate four byte blocks by whitespace, though.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/data_reg.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d1aadcc257f3f..de5d23501c92d 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -20,19 +20,36 @@
 #include <libnftnl/rule.h>
 #include "internal.h"
 
+static bool big_endian_host(void)
+{
+	uint16_t v = 1;
+
+	return v == htons(v);
+}
+
 static int
 nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 				      const union nftnl_data_reg *reg,
 				      uint32_t flags)
 {
 	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x", *sep = "";
-	int offset = 0, ret, i;
-
-	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf + offset, remain,
-			       "%s%s%.8x", sep, pfx, reg->val[i]);
+	bool reverse = reg->byteorder && !big_endian_host();
+	int offset = 0, ret, i, idx;
+
+	for (i = 0; i < reg->len; i++) {
+		if ((i % 4) == 0) {
+			ret = snprintf(buf + offset, remain, "%s%s", sep, pfx);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+			sep = " ";
+		}
+		if (reverse)
+			idx = reg->len - i - 1;
+		else
+			idx = i;
+
+		ret = snprintf(buf + offset, remain, "%.2x",
+			       ((uint8_t *)reg->val)[idx]);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
-		sep = " ";
 	}
 
 	return offset;
-- 
2.51.0

