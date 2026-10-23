Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763904;
	b=hxGEYVdxJCOdZAVMw9W71mKygyRpRTO4/VnbtfZTd8nCZfw/xTu/8wTawDp/8WTpmBM8
	 4T1bC/H5+bfwSgk4f+KD/VELbBqhp84wp4Q7htWJGNm3vN+DJjekS/k+/SgG6cYZGB/3A
	 i6ojHD4q7NE/DnrQP3ArHiD6DgRwLHpwG+4y9Lm2/8odf8SV8VyUtEG4hvTwjhp1RIfdA
	 LzNhP55GBonp0c3x7ZbCYQ5ReySs0/fkynA/DdlTnT0zd8m87+T3NhfhBz+YF78PsUyX1
	 fQPxiX69Feh0GTNwvc7AgkLDCxvl1fkzZZipyfEdlL51bdF1g2KLKB/5l0NrAVXX7Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763904;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2spa/5huhp70hu9T5gXShnsfJnzVib4v9RnXnDIp/VU=;
	b=ax/bwpIo/YmzUIoej+Xnu6gK8fm+QYsaBwzCRXJMN9v7U5fOufbG0LHG0/v6CCrceaKx
	 QllolTp6bvx5hJNhX/w5jnWkueVymo6dEMyWZgiyDDGkghSK4QE/LvnyUoy3mCRM+ytMu
	 Rzc/7Ry+Zn0zwB/LEyKq/sLO8VYk8/2tfAkeDOPZcp3YzCQD6PosL27v+gRSRh1UkxCye
	 VKJ7DkBG5Bzbv4owguD0YjWyQw3zZJLchg4XEwt3WFeHnEnVT8xPZO+7NYLbAadJQVbpu
	 Baaqmvw/KOq1Cpckdmtg2eO6YfReE4tQ5A2ukfXYP7pfWKq2agxWGoHEm6EbY/iWHEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98408606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98408606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4900C60796; Fri, 23 Oct 2026 15:58:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 1/7] include: str_array.h: avoid oob read
Date: Fri, 23 Oct 2026 15:58:00 +0200
Message-ID: <20261023135806.7259-2-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023135806.7259-1-fw@strlen.de>
References: <20261023135806.7259-1-fw@strlen.de>
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

LLM says:
The increment expression unconditionally dereferences `array[len]` *before*
the loop condition can stop it. This is UB on every call regardless of `len > 0`.
If `array == NULL` and `len == 0`, the *init* expression also segfaults.

Add extra guards.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/str_array.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/str_array.h b/include/str_array.h
index 98c9b4f3e6d1..cef71cf2ca63 100644
--- a/include/str_array.h
+++ b/include/str_array.h
@@ -14,9 +14,9 @@ void nftnl_str_array_clear(struct nftnl_str_array *sa);
 int nftnl_str_array_set(struct nftnl_str_array *sa, const char * const *array);
 int nftnl_parse_devs(struct nftnl_str_array *sa, const struct nlattr *nest);
 
-#define nftnl_str_array_foreach(ptr, sa, idx)	\
-	for (idx = 0, ptr = (sa)->array[idx];	\
-	     idx < (sa)->len;			\
-	     ptr = (sa)->array[++idx])
+#define nftnl_str_array_foreach(ptr, sa, idx)			\
+	for (idx = 0, ptr = (sa)->len ? (sa)->array[0] : NULL;	\
+	     idx < (sa)->len; idx++,				\
+	     ptr = (idx < (sa)->len) ? (sa)->array[idx] : NULL)
 
 #endif /* LIBNFTNL_STR_ARRAY_H */
-- 
2.55.0

