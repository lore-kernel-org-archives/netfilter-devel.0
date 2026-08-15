Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908C0391E59;
	Sat, 15 Aug 2026 20:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786827536; cv=none; b=r7rSE4RIVvOtiUJTn6EYaneVLW1HFv21FbOpQFD20dJNs9SuHRL/ZBsT/VsYxd9tj/Um/zgLrR/uxitkGDqP5hXb9X3pynpzOJ8MZGhE1xcgfTjbWTfLekK7yt80el62AjRbhL9zceF7dnMNdr0i1kgDGil54kD3hrtJ+82KUYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786827536; c=relaxed/simple;
	bh=ljt8f4deHjWMit+6Ii+uv5Z/qUGaSw8AyqGIKX10yqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKn4RilKBWcvjSQuCoR/EjgEX2lkSvH/u9ZeSimJJnp9q/6DeESZN6EZwTbS/rCG8cxsTS5FptBLcg2dMi1/SKy4TjvmDYyj7AxhFwDyD+D6bA3oulbYLLCqzLf2VjawVpKNOd5xZ8Rb6iZkha5Dgtk/oZw9O1SlG+GKhDI2KyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMalAsAi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMalAsAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160D71F000E9;
	Sat, 15 Aug 2026 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786827535;
	bh=diYr8gjmYYuc2ZRtM8EL+2DHiYb4p3SsFY0RRdUlGQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMalAsAiFq8PRQUUdBTVEqBbqDbFz+bqVWRTuzA3D8jJ3Og08aSPya2MvP9PtTayR
	 9Km1CQverFNO9TMs2vjfwqTUbnIvOf8oFVb6ml1X/maPM+Noa0ye/k890IhqmC5tU9
	 R53fqcDOjP+pVzee+FhVjMJ2RK+dxwD5X1ShG2HdYIUwzHbAPU/czXTtT6N3aQnOC/
	 H3P+mq7eVuvA5CzNlyGfuaLOZCUtJi3bCgBK9uCgsNBKngxS0pMKaX0iNKlSM30CR5
	 WZPIVZDUxWX+zfthKTVeWmw3hXWwN3Lpn1LTNKp5sfpguj9Ef0JDVgSN/1jecMf8d+
	 9OCt0e5pV2jGQ==
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
Subject: [PATCH 3/6] raid6: add missing vzeroupper to AVX-512 code
Date: Sat, 15 Aug 2026 13:57:47 -0700
Message-ID: <20260815205750.169336-4-ebiggers@kernel.org>
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

Since the AVX-512 optimized RAID6 code uses ZMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: e0a491c12968 ("lib/raid6: Add AVX512 optimized gen_syndrome functions")
Fixes: 13c520b2993c ("lib/raid6: Add AVX512 optimized recovery functions")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/raid/raid6/x86/avx512.c       | 6 ++++++
 lib/raid/raid6/x86/recov_avx512.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/lib/raid/raid6/x86/avx512.c b/lib/raid/raid6/x86/avx512.c
index e671eb5bde63..772bfc4af6df 100644
--- a/lib/raid/raid6/x86/avx512.c
+++ b/lib/raid/raid6/x86/avx512.c
@@ -78,6 +78,7 @@ static void raid6_avx5121_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -137,6 +138,7 @@ static void raid6_avx5121_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -208,6 +210,7 @@ static void raid6_avx5122_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -292,6 +295,7 @@ static void raid6_avx5122_xor_syndrome(int disks, int start, int stop,
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -396,6 +400,7 @@ static void raid6_avx5124_gen_syndrome(int disks, size_t bytes, void **ptrs)
 	}
 
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -529,6 +534,7 @@ static void raid6_avx5124_xor_syndrome(int disks, int start, int stop,
 			       "m" (q[d+128]), "m" (q[d+192]));
 	}
 	asm volatile("sfence" : : : "memory");
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 const struct raid6_calls raid6_avx512x4 = {
diff --git a/lib/raid/raid6/x86/recov_avx512.c b/lib/raid/raid6/x86/recov_avx512.c
index ec72d5a30c01..299a3f044d61 100644
--- a/lib/raid/raid6/x86/recov_avx512.c
+++ b/lib/raid/raid6/x86/recov_avx512.c
@@ -211,6 +211,7 @@ static void raid6_2data_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
@@ -353,6 +354,7 @@ static void raid6_datap_recov_avx512(int disks, size_t bytes, int faila,
 #endif
 	}
 
+	asm volatile("vzeroupper");
 	kernel_fpu_end();
 }
 
-- 
2.55.0

