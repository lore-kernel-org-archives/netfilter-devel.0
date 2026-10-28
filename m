Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199433;
	b=bnh8lgKs1gCvtbH1zfYy12xlcVmbIaQ8K86oph+URJx2rbqYkMXQeWBQ47WH38AwCW9h
	 wr+NX5bmzZ1dCwT4LXiAEu7eLZ/+k5TIm/Gf5SHyvb+FsJF4VuIl00V8JdR1oAFtfX4n2
	 nQQEdcbc3HoK+HpYRHjomQwoLlYQ6FulRTEzTmFZiRVY3T0UR1y1bN3FvBNycEaKFVwox
	 5uCfNksTAxNkshfKpZ/n5o0/f5qlDhA/Rmhc2WVT6NaXs4tFgNt1KCeDW74dhEuLJEWmF
	 KWUtsUiPqoo1BJiO57IbR7kNk0wh2DQ4RWcAnm1jUm1ZCct+4XuEu39+psiFFImEaIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199433;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/lfyPyx9D3Kpzw9tA1kAERDYpNAJv6w91TsaqxoFu1E=;
	b=IbhS4HUnbnuTAZVrqe/xkgd9/iAxWW6NrEqgKcxUVhcAn5WYDiEQbsYEwOgzZKEaHaRq
	 HPoRPYVQMrKFd0wluogF/gxvaYYLsboV/JPZaSpBOm3zDmLaD3TPq/m3aCRzdT9pTN/OL
	 q1CaM+7oBF1Pgo+cf8HkMO4gmKu3EGJfQncpKeXHWTl7429S3zVftbffAUqfNIh3GEk+2
	 WA/V1x7ywtBfTDNcwkW00TSM04shzVWcyxMM+Fyup9FaZsXkavnpBf6MrUcnKEOLsbnpc
	 a3MzSuvY+lWnmZtOlXphyDi00EXRjG85Otnv9WVyog+mo1DcNyg2lmhuO7Gyd6Ophow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1957B606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1957B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 48A3F609D0; Wed, 28 Oct 2026 15:57:11 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 06/12] include: drop semicolon at end of xfree macro
Date: Wed, 28 Oct 2026 15:56:26 +0100
Message-ID: <20261028145632.7089-7-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>
References: <20261028145632.7089-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... not required, callers do 'xfree(x);' already.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/utils.h b/include/utils.h
index f1bf3f6ddd41..6b87c5edac24 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -19,7 +19,7 @@
 
 #define __noreturn	__attribute__((__noreturn__))
 
-#define xfree(ptr)	free((void *)ptr);
+#define xfree(ptr)	free((void *)ptr)
 
 #define div_round_up(n, d)	(((n) + (d) - 1) / (d))
 
-- 
2.55.0

