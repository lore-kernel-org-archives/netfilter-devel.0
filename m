Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D899F37F304;
	Mon, 31 Aug 2026 19:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788205723; cv=none; b=AS1eSfUWaWJARtr7jfb6p1A8Nvlei/Gn6sEot7+mj9WNy6Kz3HnlDNgF4hBK/bhqwMrw728dsHBgQQMtgBS5vhOYP/JD3uROxhWAWDD4FkeHTAOOXrY2wP4xu2iIc0t2c21C6z2bZGyMBejfsWRf4w4lg3sPHlUSCvdu6bjH9sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788205723; c=relaxed/simple;
	bh=g/X+xS9P2g+jQmZlDmRseACdO9upCcsw6hlOo1EJmIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TP55x3Y0tQx2RBqxktuX2jkyfNBGSNtP1Ou3DPiLH9qwcWCyaHAEozpoAVP74KT3Fidk64amMA2j3kZfIZ0s2zAC+OOB+qQLa0yelvzuucu58koeRfTDdXptTbOYVkEPoMtm6SoBslUAZGe9efe2EbEUwgy3xEM4ctQ32YS4d9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AlfiKo/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AlfiKo/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3369B1F000E9;
	Mon, 31 Aug 2026 19:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788205722;
	bh=iVP8bNwr+imQHOtFrR7Z6URtl5iJ7G1bULMQyCGmoT4=;
	h=From:To:Cc:Subject:Date;
	b=AlfiKo/W9IvL9KJSYL/SZSbEubr4W5iWep61Tj8ZIFDY+NQikVCrPlM7oySWWuGwX
	 i2gSupGmYq0w55ocX41WcjY3zI4cD0joB0CyfePuS4ySPCcUtL04vafTnvsluptYmb
	 V4pHy0zF1/Z8nWImOmVv665WwXQ+caEdFsuosvuD/6Oqe2Zu01H5akTUzB/RgichmJ
	 uuhry9SvVT9OOopllclM4x2YGYsO5YD/JIcxmR24aAG2QayG1dDXDFTNOKpMlruqDj
	 8hScOe8DnCZ/+W4XjIpeput7yT0UQn3zWVCoeGeRmKGLhzvRein4/RrmwxEwFlN/KX
	 kpxgQZKXHphfA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12,6.6,6.1,5.15,5.10] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
Date: Mon, 31 Aug 2026 12:48:29 -0700
Message-ID: <20260831194829.148442-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 55dd20f0f4b1be5c9c8a0275d8d763c86563eac2 upstream.

Since pipapo_get_avx2() uses YMM registers, execute vzeroupper before
returning from it.  This is needed to avoid degrading the performance of
any later SSE code that may happen to be executed.

Fixes: 7400b063969b ("nft_set_pipapo: Introduce AVX2-based lookup implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 9d5ada57aa6f..fd998af98922 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1262,6 +1262,7 @@ nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 out:
 	if (i % 2)
 		scratch->map_index = !map_index;
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 	local_bh_enable();
 

base-commit: f717995cb7dcd8998ab15516b8006aea09cfde0d
-- 
2.55.0

