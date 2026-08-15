Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0993955FC;
	Sat, 15 Aug 2026 20:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786827537; cv=none; b=O6ERPQM+FcTsUh9krC5AK0HVCzZ6uhazPq5aBBzLGg5nGkRPgq3wsmQgQ6sRulkFbM203pP0Qk9z1Lh8wM+ge6RKAovFhTkQ2pCzprev87/HIUmjwIcgx8kOMxYteE+lz6Bi82Je8KwJZrPeIsfrHlbh86ou2ISPAkjjkJobhsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786827537; c=relaxed/simple;
	bh=sDy2xxxUKeTH/KVTJQGSDOxgQWZz4evu7pBOGLdIkDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b50/oM/NeGIorI/KdypK/khwmBh37V037GdgcqlyaFUckvYWQANPdijVASLYuj7y+8ILGqXb2cNoZLia+D8ZRSEylqCaLP+3xyFJXw3KBzbt05GyYrFbIh7Xmy/BRKAuZepk+B39CaYZXV0QC2IwVBa84N79Lr0PlCdng/1rf20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vp5QXjN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vp5QXjN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EC61F00A3D;
	Sat, 15 Aug 2026 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786827536;
	bh=MfTGJZLmd6D32z+SzOilmhIPRG29fcdYhDG96KG74Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vp5QXjN80jMRxJMI+Ue2SO3fyaKSJiMf2Q1cZPiyJSLJmvHbYr6ySJh7y/E2egq7z
	 O1uYUE84KgCQC0Y0GOzmzNkxJIc4MRmxtB0r993BfE/PfVpuyvoHGYxx0O5MpPbDTe
	 BA5vfzXuerJLYvC93UN3t3VKrayt8Uf5kX9qNnUhEnPA2tnSQ+ChLAlQmlYR5tPmhC
	 3IMApT//3K+6eBGv2HNe1OOBrvjGgJ9sTwNZiPD8AMr5lT2zAf+sb7MVOHIewEbfRC
	 gDmU4qZ8d6UqqDWyXiSi2ftrlLxTqupOhCvrakqN9gzWXFbJqefXVuZrj4DM/PWoqO
	 S9tYyby+G5qBA==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Taehee Yoo <ap420073@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 5/6] crypto: x86/aria - add missing vzeroupper in AVX-512 code
Date: Sat, 15 Aug 2026 13:57:49 -0700
Message-ID: <20260815205750.169336-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815205750.169336-1-ebiggers@kernel.org>
References: <20260815205750.169336-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the AVX-512 optimized ARIA code uses ZMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: c970d42001f2 ("crypto: x86/aria - implement aria-avx512")
Cc: stable@vger.kernel.org
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/crypto/aria-gfni-avx512-asm_64.S b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
index 860887e5d02e..ca83eb126e06 100644
--- a/arch/x86/crypto/aria-gfni-avx512-asm_64.S
+++ b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
@@ -800,6 +800,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_encrypt_64way)
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_encrypt_64way)
@@ -825,6 +826,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_decrypt_64way)
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_decrypt_64way)
@@ -966,6 +968,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_ctr_crypt_64way)
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_ctr_crypt_64way)
-- 
2.55.0

