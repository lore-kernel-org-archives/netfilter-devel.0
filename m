Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9747630B529;
	Sat, 15 Aug 2026 20:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786827535; cv=none; b=XyXJ0cf09PPPSww6K3aoR+PWyRy1yaM8Pq1OJ7P8A4n5SKVBdwYkQLUWWBgd9mxm3/kxTplyK8ayRF7IFMyDgGZhjx4Of6WMDx7+ofLB5gY/VFEw1D802W7qfDUysafaPavygIJvfedSjP40oM/0U0BAdNBwi8Um4jQIpziUucg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786827535; c=relaxed/simple;
	bh=qpE0SJBd/BU2HephsAzlP5g74fPECM3Mk5F0nbBZYgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIf1fMFdYuSmllpw/m9fwhjX/D8XsJvBRZMgxans7UKHxAI/l7WoReKnvSplj+/eczLcemuLnNjYCPyoNDmH0ktVRwDv8ZIEvLdowV8LZfyuWrHr0qNgV9+GoDbY9feGBtosVrZHg4jQ8V/dLTnEJlavbpi5uBLLSZDQnzdC4RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Culfq8xO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Culfq8xO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050B91F00A3F;
	Sat, 15 Aug 2026 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786827534;
	bh=G6Tmug8/NbG6q5O/f3xJp199ph8j+UrYbX3xYD3RUzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Culfq8xOoK2pwMt/1SYnVBsOSSpWx1gAu02eFHt78VXxFbmX8zd2okqGN+YEUAbrE
	 kiiFe1WbixwJ1TVDYmVuB4JbnoJ7lbUEs+347MUJY083IeoppCsyZtyxu+FhmS/+R1
	 l2ob47keBcDWt+qTxrcqVZNhX4neHR6kxEXYdPrVuAAPjt/e+MoCo1yxNFo6s8xR+Q
	 IoCGX343o+gXUo2eRH2WOQgWLL3Omq5/PQs3LPzbNowZZFezlH3w9X4Ip0ApUX/TAw
	 wMT6r6yc50EOl8q9RUeIpOAXqPvO8bzLP9IbMG2kBUua6RqRv76yTgcMjZm1ovNTbw
	 gp1l8az9gJkaA==
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
Subject: [PATCH 1/6] xor: add missing vzeroupper to AVX code
Date: Sat, 15 Aug 2026 13:57:45 -0700
Message-ID: <20260815205750.169336-2-ebiggers@kernel.org>
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

Since the AVX optimized XOR code uses YMM registers, execute vzeroupper
before returning from it.  This is needed to avoid degrading the
performance of any later SSE code that may happen to be executed.

Fixes: ea4d26ae24e5 ("raid5: add AVX optimized RAID5 checksumming")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/xor/x86/xor-avx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/raid/xor/x86/xor-avx.c b/lib/raid/xor/x86/xor-avx.c
index f7777d7aa269..95b21e7225e8 100644
--- a/lib/raid/xor/x86/xor-avx.c
+++ b/lib/raid/xor/x86/xor-avx.c
@@ -147,6 +147,7 @@ static void xor_gen_avx(void *dest, void **srcs, unsigned int src_cnt,
 {
 	kernel_fpu_begin();
 	xor_gen_avx_inner(dest, srcs, src_cnt, bytes);
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.55.0

