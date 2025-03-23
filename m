Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598FF202961;
	Sun, 23 Mar 2025 10:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724579; cv=none; b=iKK92aYLH4a0IO3zEpH1rKavdBH0eltCgIi9Nsz5pDTVHWUHPvD5Cogny7zMIGNF+Pdz8c2FEZPoA9KdsMFFegn5q0dPhKih/7y9qNvtxbbQJV7QNpH5wKaHet4AA27+QL7GZirhGuybFql3Mx2msCN2Om+RZtS5FPa6Yeq6NuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724579; c=relaxed/simple;
	bh=rOqpHGHNwl9/pY8Ur0kiio4YM2OwQsSbVjYJlGfDptk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oq9YreCt5Pz0s+369WWitNVTtThrFoWhzmf9DV0FGLm2HfjhCOOtuC73m4evwtaUnQHJvaDK7WR/In02cyVdi5Blk3MioFTv2tCCaLBE1S/hDxe6L9Jgd5x+W8zwB8GihJmEnQZ+ZMYguCM9/YqPDsMLNSFG7OFoCb+dYPQaKRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ucWFTi5w; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KS9Ai1yC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ucWFTi5w";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KS9Ai1yC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1350560388; Sun, 23 Mar 2025 11:09:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724577;
	bh=XVSnIVyEAuZW6XuwUEPtfkpY//fKTddknSRx2uKsKwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucWFTi5weOr6g+a1+88wYYS4iNae0GgiQXANw+82bUOBgfOBfOGll2uVQBlEmkHRD
	 bLkI8Tfm0O1shq32012Yqkd/Apc5FPEUpeHNvfOnj9IKmDhcYxMjmlQ2lJPe10rAwM
	 ElvKnOW2VAUzcza/IOx/FSi1oSiPODVmStK4OvN2axP7Dge5o4L+JOPgfdj6TrIO6G
	 J2xC78wQrMyo2cLM7ZuolhhFo2hjn9JhWtOuDhlEuJU+Hu2yJWGkmdGQpz0NmzRgNC
	 8JzbhV7i4J00fEJp2MqIk1r5huTrnLtTZrBaHxwx8I2zNYmDzUskBajCAsk6hDOUWu
	 8B2W5qJ88pmRw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 409CE60392;
	Sun, 23 Mar 2025 11:09:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724570;
	bh=XVSnIVyEAuZW6XuwUEPtfkpY//fKTddknSRx2uKsKwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KS9Ai1yCqpwwOTa+vgMj0kHbCQJuspyUi/7VU/1b1JYskrE0ar28CUMhYer+3t90L
	 Z4RBRNeOGVBBpsxBQE/UQJNbDFhopWTHfBeuEqUAY5hsOUZFK+FQNU79jsAQId0tDv
	 7wgU9EUXCKsu9aXrGw6+tfgtLmay8YW8YiXuZq4OJaL1puS//M0iP9C+xZlAV4q3FE
	 FAAUoAYJTSEYAOfsCIaWKEPeV/vrzJkd5/51/v8bKJsYgwkw4ZPz9/+rCeFkvlHkRv
	 jeXQMgb+8gJYL947mo2Zn3xLI+f2xZpiWtnTY9KTozCEIMGLuETNYl/NoNNoOj0xd7
	 wjbTjkQnnFt3w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 5/7] netfilter: xtables: Use strscpy() instead of strscpy_pad()
Date: Sun, 23 Mar 2025 11:09:20 +0100
Message-Id: <20250323100922.59983-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250323100922.59983-1-pablo@netfilter.org>
References: <20250323100922.59983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thorsten Blum <thorsten.blum@linux.dev>

kzalloc() already zero-initializes the destination buffer, making
strscpy() sufficient for safely copying the name. The additional NUL-
padding performed by strscpy_pad() is unnecessary.

The size parameter is optional, and strscpy() automatically determines
the size of the destination buffer using sizeof() if the argument is
omitted. This makes the explicit sizeof() call unnecessary; remove it.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_repldata.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 5d1fb7018dba..600060ca940a 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -29,7 +29,7 @@
 	if (tbl == NULL) \
 		return NULL; \
 	term = (struct type##_error *)&(((char *)tbl)[term_offset]); \
-	strscpy_pad(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
+	strscpy(tbl->repl.name, info->name); \
 	*term = (struct type##_error)typ2##_ERROR_INIT;  \
 	tbl->repl.valid_hooks = hook_mask; \
 	tbl->repl.num_entries = nhooks + 1; \
-- 
2.30.2

