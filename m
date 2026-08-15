Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B2A396567;
	Sat, 15 Aug 2026 20:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786827538; cv=none; b=hxxpsC4Bc+e6HTRn7oTkeU/5svcDUltPik3uOg/uGciipIuw8mikMtnf0GDWISPBPF6QjcZLj50HNQ1tZCxyndDPWdvNPIF8VZfUQAKLmEljr7a2qThG16G5qdIpCULDajE5dUdj9Ew/uW2EqDTYuNkCrpe+Rb0fVeZGsiu4Kt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786827538; c=relaxed/simple;
	bh=Xg21G8QruOBVYSNsqWHlCp2IipPB/eMbg9nfvIbTqj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kz+1+wVf68vd1HZV2otlqpjbTDQMyDllUM/N2/8dx32ix6ZUofk5RkAdW8QjeV2e/T7PqwsJcA/Jd9vH66io6xVvjDqgWgngzjO3XN91SrkARQnbUgYa3LNQV2nKymRWGtnvM3UrTIZKIWiEVnr/TqlE0+qs/Lxq/uTJkl2edVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DjMOqZ6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DjMOqZ6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999B51F00A3A;
	Sat, 15 Aug 2026 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786827536;
	bh=XLAdi1TlBOtXW8xgnYx5FHT2dAljIrxrUwmqj950s9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjMOqZ6y4xraZj1WFVvM//1QGmseYfZBjzOqpq5VvLQE3k3BYMwPnv3k2qY5Yb7w6
	 2foHHdpQ7Wd7ogF7B9M+MRrDU6p2IrOl5dU+Cyddp7J99XkPPF8soi1q+WR6ha+JoX
	 sVVNvXTwHlSh0OWbeZSrk3syGBLwnKvvAAYT95BKDcewwJo4QMGyGp++ofwXmphBeV
	 wWVkwSf0UkM/kmMI72FK8BmmW0RS/VY4jwObIdohXVBMTKOmcJWP18Qi+NagE9Dgv2
	 4DuCPhnTsouqmZ24oeBjNUk1/wimBivtgwpgrNx2yXaC6TtzYvE08KMuAV9glbV4k3
	 RmYiH2ZBI87IQ==
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
Subject: [PATCH 4/6] crypto: x86/aria - add missing vzeroupper in AVX2 code
Date: Sat, 15 Aug 2026 13:57:48 -0700
Message-ID: <20260815205750.169336-5-ebiggers@kernel.org>
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

Since the AVX2 optimized ARIA code uses YMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: 37d8d3ae7a58 ("crypto: x86/aria - implement aria-avx2")
Cc: stable@vger.kernel.org
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aria-aesni-avx2-asm_64.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/crypto/aria-aesni-avx2-asm_64.S b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
index ed53d4f46bd7..fda8cb8a99a8 100644
--- a/arch/x86/crypto/aria-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
@@ -982,6 +982,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_encrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_encrypt_32way)
@@ -1007,6 +1008,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_decrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_decrypt_32way)
@@ -1209,6 +1211,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_ctr_crypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_ctr_crypt_32way)
@@ -1359,6 +1362,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_encrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_encrypt_32way)
@@ -1384,6 +1388,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_decrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_decrypt_32way)
@@ -1428,6 +1433,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_ctr_crypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_ctr_crypt_32way)
-- 
2.55.0

