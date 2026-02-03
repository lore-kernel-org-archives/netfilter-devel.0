Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21FA34677D
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 13:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770126556; cv=none; b=MfJaOA6tz8wr1A8eN5ZZcEyEWwwJtqGZ6JTNWOdWXF9A/OtWeUdNo0e/jJCbqb+0+8pUsyncRLOrQbTDI0qcsZQiJhTy7PN0QJ4zTgu0EHoFN3cOWp0/7QjW0IRWeCDgCwTrDW9KRDVaPsklE28qk3xsMqdH/6SFzsuEUaF5xCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770126556; c=relaxed/simple;
	bh=WcPvYQZ4hPvcxXauhmbhj2zr2Rf9jOKMLrdUrT7AWY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EVrZV1nfoEqewBn3KClwX9t5wTkPFuSRXN26Gf7fLNH34ggkR24OzGB7d+HVU2VIpcibb3sF7zgVeo/wTPM30bV4iffBXgT3Qg8FuVbGfU1JkLfM2Z0Z+TEhNkPF4lXiJIl5JFuhDEEvv6/G/RnEb06nSFjQDUGkGisNc1Nv4Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KkfPysch; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkfPysch"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8707005183so863481866b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Feb 2026 05:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770126551; x=1770731351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O95u82WFtOCqmhhnrx4s8maU221mJSOHdUAd47NdUN0=;
        b=KkfPysch5AJuvwrcCH//IzQNGwqMGpKhymSQ614R6XX1q4m0H3IhHSIRsdzWd7qExo
         I8VUFnumqz+VTOtzLSOJVhm2nXI1dXN6hN2p3kZrJs3QA1HVNByvvnMw72UCTxH/70CE
         gU1FxmgmTjNsNxtGYqtmTLkI5ZJAxbiXeoJTCOsf7LOXaEN/EX08O/lg+K1lzAObeUEZ
         8V/7B6mOMGySU2wU1ieA9EtYpUR/jfnPCwN9+OzxCWBK4QpztmKMXJKzCBpQcENdCAQ3
         Wt3oAKGIeEbIidDdAh2tWb9rqI8Bw3kZq6RiC2i/9Ln/P1Ktvxha4ULKPzhGaYsEjLWk
         GE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770126551; x=1770731351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O95u82WFtOCqmhhnrx4s8maU221mJSOHdUAd47NdUN0=;
        b=Jscv/TdnIos0wsT5Ajf8yhcR3gJxj4CO5Lw/xcii2IBADnLubp5WXoVK4heZGq9d2a
         S8V4cEo/Q6btx3bo2YpkCqGJZIfew3cAmx/YeCovUFDsbfpuxV4OZuRRc1BZ8UZbIaSc
         /s8oTSVs3kx6nmMWM4fyM2nmXWXOCPk5iMqF6zZvOwnypwFaY55e1XfVeLEJ436/yRBd
         ZCZ1g+9AcCkbP9y1Fng36cS9TlRQWS1U53rWVNidnAOcjShnLXhq6bZJvMbmeAGrEIB4
         R5xQ7KwNMPck6OdghfKUoRNaFrGv2WxayL9vMD6i6eprR6Zl0jSxS39XlyUiGlDCLFSw
         kpgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZI1k0fi6b1FmnrGnYVt/svy1ngUM0eFszLXf9QhP7l+6vNIIVehQGVAaomzjyx71+CSAN2Od+OQZ4l8qTAVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgBUfbPx/sjaFPdHWFDgv9tjOlyKOOIrH/OwHD78l9PccbgPGp
	iML1dSL51bA3duPaX/l7/qBcgYKntN/66ZiXTsgZEAJKJuA04+vg4HLo
X-Gm-Gg: AZuq6aLemLT189nFpCf+a7VOgKrVFy+wklRl698xY7XCOJxRhf2s1oxh0b3Tb/RcIJq
	Kd5fdHkE1N3uVIN8qnoRRONQ0quFT6eXaj4fB1UA6bnb4V/g3Jg/2AD2wpE+/CJJpRZcYYNcX9G
	jXczfUqOSmRPbEah7vSE8w38sqK0WdVX2t09oO6eegf8g9Pqz8KgL4s3gJ6SIwmVAYu0Unjnqo5
	f5H0Rki+srKGYUZoaxBfUrvmvYhf8h69NddHVuM6/VKIWgflBN1HEuw+ocz2HKLzQFaWvJAQQl/
	nWqzmLj1I3xN/I1CLOzYiNNboNLOji/2xT1dDu2Q+LQN1IyCGZxN8pgTICYviOo5nRM2v0wiFsw
	xltR0Ge7rq19segiduZtyBKyGgmRWJf+rO5vawEuGEn2cZ5Pr1DMd9jnWNwOcon/QZeoF68m9oN
	NGhiugZdSzWAmHvg==
X-Received: by 2002:a17:907:3c93:b0:b7d:3728:7d11 with SMTP id a640c23a62f3a-b8dff6be325mr961499866b.50.1770126551130;
        Tue, 03 Feb 2026 05:49:11 -0800 (PST)
Received: from t14.. ([165.85.67.147])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf184e5dsm1058051366b.43.2026.02.03.05.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 05:49:10 -0800 (PST)
From: anders.grahn@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Anders Grahn <anders.grahn@gmail.com>,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH v3] netfilter: nft_counter: Fix reset of counters on 32bit archs
Date: Tue,  3 Feb 2026 14:48:30 +0100
Message-ID: <20260203134831.1205444-1-anders.grahn@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Anders Grahn <anders.grahn@gmail.com>

nft_counter_reset() calls u64_stats_add() with a negative value to reset
the counter. This will work on 64bit archs, hence the negative value
added will wrap as a 64bit value which then can wrap the stat counter as
well.

On 32bit archs, the added negative value will wrap as a 32bit value and
_not_ wrapping the stat counter properly. In most cases, this would just
lead to a very large 32bit value being added to the stat counter.

Fix by introducing u64_stats_sub().

Fixes: 4a1d3acd6ea8 ("netfilter: nft_counter: Use u64_stats_t for statistic.")
Signed-off-by: Anders Grahn <anders.grahn@gmail.com>
---
 include/linux/u64_stats_sync.h | 10 ++++++++++
 net/netfilter/nft_counter.c    |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
index 457879938fc1..3366090a86bd 100644
--- a/include/linux/u64_stats_sync.h
+++ b/include/linux/u64_stats_sync.h
@@ -89,6 +89,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	local64_add(val, &p->v);
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	local64_sub(val, &p->v);
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	local64_inc(&p->v);
@@ -130,6 +135,11 @@ static inline void u64_stats_add(u64_stats_t *p, unsigned long val)
 	p->v += val;
 }
 
+static inline void u64_stats_sub(u64_stats_t *p, s64 val)
+{
+	p->v -= val;
+}
+
 static inline void u64_stats_inc(u64_stats_t *p)
 {
 	p->v++;
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index cc7325329496..0d70325280cc 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -117,8 +117,8 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
 	nft_sync = this_cpu_ptr(&nft_counter_sync);
 
 	u64_stats_update_begin(nft_sync);
-	u64_stats_add(&this_cpu->packets, -total->packets);
-	u64_stats_add(&this_cpu->bytes, -total->bytes);
+	u64_stats_sub(&this_cpu->packets, total->packets);
+	u64_stats_sub(&this_cpu->bytes, total->bytes);
 	u64_stats_update_end(nft_sync);
 
 	local_bh_enable();
-- 
2.43.0

