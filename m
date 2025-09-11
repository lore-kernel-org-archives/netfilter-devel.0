Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131E41957FC
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 14:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757600115; cv=none; b=ZPkJCMJjRHXYoDU3h2zG3yfuM3WvUKfZ/EjRvMcDT6Sk2+2FawwsIAZxK8fTsZnKkxI0HZeJnjth+JbAHlYjep7uMtUMX358Oa3OH+JPLeY4aYAqlWtBbLKZ1OFhIuc4LG3stXNDWYbgmVsiJvGhGXB676+v5mRUa5f8cuWD35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757600115; c=relaxed/simple;
	bh=m2uLYmpF6OmzElchEZqaTUVGsIyE9I9SXZ7ZLikGNt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VYbmwMiQRms9RvMEhm5VmuJA9egljM5ZLZVgH2ke1BvfeGgJaXnCE2BCn3cZ6nSwqs0PlNTRjgn4rFSwG8RU7u96YWHS2MmcHO3aQNEASqwFokFFG6KNds4vGBai41mggHERMTRn564PAAec3y0llYQVd7AzDm45eVJzbYraSk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=A+UIuluG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A+UIuluG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=28zyAuD/6cAkq4cLvB3w8VH+LgzD2o2eBL2cnj3C4Js=; b=A+UIuluG/JZb+GkXn/jzOKZDpL
	A+sjpF1mJTEqRFKnjyTtgcGPrLz3Q7y+Dk49BUh/3QOUzQuuABkAeEZK9yRrMVKtV+aa9k4UEULB+
	2SV+GU42BUn7TJQ593WQ97Fi4xkAovug1rPGR+wBYXRQGqIJyNXS8rX/OXmn0BL4IuyOpoF+eqGTx
	Mn8HZDw8kOe+iAp1b96kbk8iPemY6pge5WVW1vK4AjyZeYj79kl7RLwUzKA45281XDRqTrl/ji0YD
	r0b8oK0SsLP3Nr96sH9/u4jA2rBKueM/V3p0lL43GqbiNSXFCtSpKL3dZCqPROD2/Qy20bmAOO330
	EmmTqTGw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uwi4r-000000001XV-1Xcn;
	Thu, 11 Sep 2025 16:15:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [libnftnl RFC] data_reg: Improve data reg value printing
Date: Thu, 11 Sep 2025 16:11:45 +0200
Message-ID: <20250911141503.17828-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old code printing each field with data as u32 value is problematic
in two ways:

A) Field values are printed in host byte order which may not be correct
   and output for identical data will divert between machines of
   different Endianness.

B) The actual data length is not clearly readable from given output.

This patch won't entirely fix for (A) given that data may be in host
byte order but it solves for the common case of matching against packet
data.

Fixing for (B) is crucial to see what's happening beneath the bonnet.
The new output will show exactly what is used e.g. by a cmp expression.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This change will affect practically all stored payload dumps in nftables
test suite. I have an alternative version which prints "full" reg fields
as before and uses the byte-by-byte printing only for the remainder (if
any). This would largely reduce the churn in stored payload dumps, but
also make this less useful.
---
 src/expr/data_reg.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index fd5e0d6e749e1..d7531a76af68f 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -26,13 +26,22 @@ nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 				      uint32_t flags)
 {
 	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x";
-	int offset = 0, ret, i;
-
+	int num32 = reg->len / sizeof(uint32_t);
+	int rem32 = reg->len % sizeof(uint32_t);
+	int offset = 0, ret, i, j;
 
+	for (i = 0; i < num32 + !!rem32; i++) {
+		ret = snprintf(buf + offset, remain, "%s", pfx);
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		ret = snprintf(buf + offset, remain,
-			       "%s%.8x ", pfx, reg->val[i]);
+		for (j = 0; j < sizeof(uint32_t); j++) {
+			if (i == num32 && j == rem32)
+				break;
+			ret = snprintf(buf + offset, remain, "%.2x",
+				       ((unsigned char *)&reg->val[i])[j]);
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		}
+		ret = snprintf(buf + offset, remain, " ");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
-- 
2.51.0

