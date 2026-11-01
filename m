Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793521068;
	b=Srn9NIwjKc4uLYbjykpSbBI+gagBssV7WTj9DUBtdWLX3qByzIHJR1OOO64wncT0ZsV5
	 gCUDpmAUPUkeSrcd+x4THmPuXYgkBraqeITLkN9wUt9gS33mJWApVdxctRuuPy4Jf8Spq
	 VhZAx8DjHkWTxBqsWEfbOYhowUUjaTWypxYoxo9H9wtnYtymUgyb1yDB0bcCTold7pZFu
	 qantIzClTU3IDv9XjvJZwt3r2DvBzxdlQynwKdR+bbUBy8ebA3Kxd9bVzq5mRrEIJYWi6
	 y7Ib/K1d7xoRVipYHFVKw1FW5mWgGUj6DBDC9HP/FjF8ssXOynKK9G1SWxZ4hpUkTuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793521068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PquNKABWi0C6tGTol3B3b6YxtKfoZjVRBFpfFj8hv80=;
	b=sPGhv6cpK+ZrUtJJ8UQGdlRWTJRkCx7e/vgukjhRnRIwKc7FZ4vwx488DpzGAXOpZAvL
	 X2bO68vm6OOdx1k+EmTFQfVHmr6oZWIw/+/DUjxX0Ji59EbFHDAj411H77M8vnYg2Q7oM
	 Zrd/zCEeJmJhZGuLdyMvxl8pMU2240+AoiTr7MvzCPvjNFEax4ph3EJgsw1ASBGqGQJZY
	 JgWguvz7ssUP8NV15X8OIQr9uAJb+uHm5EXcH1U7Z2jDTYoaCaB4W7xqSi7+maDMRnBXi
	 k25ccuKLGts9H5zegq6YmmbTUNmTJsbXguDJ8MzmS1ZwlBrGUaRrCJjM1M5M3E5o4ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=guLijxjT;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C32D606A325
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2026 08:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C32D606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=guLijxjT
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae1b34e0d2so1616970a91.1
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2026 01:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793521067; x=1794125867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PquNKABWi0C6tGTol3B3b6YxtKfoZjVRBFpfFj8hv80=;
        b=guLijxjTMJ66lfe8n6JMhPGpbFDCjjgWc1gp+wR2hHlNR2BFETzJHyZvtojeB4V0ap
         Qgwr4Nvp8zeubBiwsErHaPxQ1dx7Kc7iHSxjfoPrKEWUZsMzEYzwxmPsEtixyD/TD4du
         bbF6dCwa5HSE96wTUvihfcqYutieQhyyGuWmo3VZLWpubLCrtbKsz0pk19k16Avhp6fN
         GIhlUnytDFwfQZ9K/HjeNscYCWHrrUx9rXrg/28tR/2dZ14Vc0ohkzEocbO5MD5IQvQ2
         9w2oIAkyHdT4HMU1jnxuj+bLqxrxjRCVVkkNINuzWr877xU+8FfrXRogVQuqZYziny95
         /+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793521067; x=1794125867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PquNKABWi0C6tGTol3B3b6YxtKfoZjVRBFpfFj8hv80=;
        b=jGPs+SQ85SpikTx9AhwZpWZKMImEs8M87ttFRljbxUKWMumIWgshGopQc5rPf6KOyZ
         fZd/FVTyhk2Y2ATGizucwj2aUCWNTFyxiskNrtVLsBG8c3iNPXUlo7uK552fvz3xOfoa
         lRehf6H2PrCGvB68K+m/gC07bQbOYgCz3rnVSBP7fxn3SjfQSC9Ruubwu8lz3Ql9vf9X
         wxpoWewXIIpz0r+owRcgshgBW93vS8HXvvfcyICPejENfsFsBUv3GqoWapWC/AdcuELD
         H1HPvYZal8Mm9h/mvl2bma+ffiDONiadoQncqRcDWuAAtH8Z+LmPDsSdczx9s7JLqBpf
         yvpA==
X-Forwarded-Encrypted: i=1; AKwUvBylq7IEqgVrHLm2wz/MC+iixNMWSgBMRN4vwYWjGJ9655EGDL994pZIeyvCOR2OQeJIwBIHegCb/abQfr/sHGI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+inS5gB9CRyFhKTtMSaFil+PgIV5kGeWiahvjDzFJpTnXOK70k
	FZmgUZMqNDO9T0XANO8smGutEW4UnyH9BTpK6JoyLE/2yiyiRKhsbM4k
X-Gm-Gg: AYBFou2ixiCHCS1jpjka1/VE+GVGw9lsl7DtAy0d5I/jf/vNHTbA0V8ArxLDRgzoreF
	TOGtz56/P9eDvhRVL7c9yFwruJzzGOfTQEO93W1rQ1Vl/Ak7TFVLzWJfhOk2+NgAPbJ4JEi1Ill
	HH5epiwexIsddP2G3AVWWjGdowU0wGbBsBw1eskpy4yWLJJpBbneuHGxIZjWpqe8hnzHdTRwSfK
	AnUR+GgOxbEl5aXBO3AEzqnu1ybp4E9ahiyAY6D+Pnpawpqpi1dLDh0QK/VTfe6nh00Qh7R1Slf
	ITTTQThCDVmeJs/R4YijFvENAgmA2jrCdwzpcCR6+SJfiLUNrMVBdKwGtAZd8HivON3+pGai1Qu
	CBjl2gyfNnaGW4xMYftGI2B1WAMCRd1cwpqW8ugdNqvZWbJOh/CW1aOt5OY0VVW/q7kDWIitrCL
	6FB9MS17MDZrOEI9cszpPIumRcQUSfrekmCQNEKNq7mTvbDs/FhC1Y7PiOqEtZhKg8vIOy800x5
	LOmiQg1KKvisfJIXxsmTnj1jRUY024/53nIo0DM66d5i5J5N1+hknfqTZ1XGNCf08gT9XixhX2P
	vYuDLKBTKJc/3TXqQJAlLQWN0k+nzz0XxDrpiBQqlCk1Ji5khIcrPfKMm3BO2Eqfv3f+XBM3xoF
	K2YlEQ5YS3NJqngMcnVQ84Uu4
X-Received: by 2002:a17:90b:53c7:b0:3aa:412f:b0a7 with SMTP id 98e67ed59e1d1-3ae89559e5emr3615666a91.5.1793521066862;
        Sun, 01 Nov 2026 01:17:46 -0700 (PDT)
Received: from LDYT9Q2G2M ([2a09:bac5:cad2:3228::4ff:28])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae84596e3bsm10011455a91.9.2026.11.01.01.17.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 01:17:46 -0700 (PDT)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Finke Lennart <lfinke@student.ethz.ch>,
	netfilter-devel@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] lib/ts_fsm: preserve token types when exporting patterns
Date: Sun,  1 Nov 2026 16:17:35 +0800
Message-ID: <20261101081736.51803-2-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261101081736.51803-1-zhiqizhangg@gmail.com>
References: <20261101081736.51803-1-zhiqizhangg@gmail.com>
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

Dumping and restoring a tc filter with an FSM text ematch can silently
change which packets it matches, or fail to restore it with EINVAL. This
happens when userspace reuses the pattern returned by RTM_GETTFILTER to
configure another filter. Dumping alone does not change the live filter.

fsm_init() replaces each public token type with an internal character-class
mask, and fsm_get_pattern() returns that converted array. For example,
TS_FSM_DIGIT (2) becomes the _D mask (4). Restoring the exported pattern
interprets 4 as TS_FSM_PRINT. With a DIGIT/MULTI pattern, a rule that
matched the UDP payload "7777" but rejected "AAAA" starts matching both
after restoration. Other exported masks exceed TS_FSM_TYPE_MAX and are
rejected with EINVAL.

Keep the public token types in the configuration and look up their masks
in match_token(). This preserves the exported representation without
adding another pattern allocation. Initialization still validates every
type before it can be used to index token_map. The extra lookup during
character-class matching avoids storing a second copy of the pattern.

I identified this issue. OpenAI Codex helped confirm it and drafted the
fix and changelog. I reviewed the fix, built it and verified that the
tests passed.

Fixes: 6408f79cce40 ("[LIB]: Naive finite state machine based textsearch")
Cc: stable@vger.kernel.org
Signed-off-by: Zhiqi Zhang <zhiqizhangg@gmail.com>
---
Changes in v2: describe the tc impact, split out the KUnit tests and add
stable. The production code change is unchanged from v1.

Validation: updated KUnit tests change from 2/15 to 15/15 passing on ARM64
GCC; ARM32 GCC and ARM64 Clang also pass. An isolated QEMU rtnetlink/UDP
test demonstrates altered packet matching and EINVAL restoration before
the fix, with both corrected afterwards. See the cover letter for details.

An ARM64 userspace microbenchmark of the extracted matcher measured median
paired slowdowns of about 1-5% for tested long character-class scans and
13% for a one-byte rejection case with appreciable variability. This is
not a measurement of in-kernel or packet throughput.

 lib/ts_fsm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/ts_fsm.c b/lib/ts_fsm.c
index 053615f4f..8725ea6f0 100644
--- a/lib/ts_fsm.c
+++ b/lib/ts_fsm.c
@@ -126,7 +126,7 @@ _W|_L,         _W|_L,        _W|_L,        _W|_L};		/* 252-255 */
 static inline int match_token(struct ts_fsm_token *t, u8 d)
 {
 	if (t->type)
-		return (token_lookup_tbl[d] & t->type) != 0;
+		return (token_lookup_tbl[d] & token_map[t->type]) != 0;
 	else
 		return t->value == d;
 }
@@ -288,11 +288,6 @@ static struct ts_config *fsm_init(const void *pattern, unsigned int len,
 	fsm->ntokens = ntokens;
 	memcpy(fsm->tokens, pattern, len);
 
-	for (i = 0; i < fsm->ntokens; i++) {
-		struct ts_fsm_token *t = &fsm->tokens[i];
-		t->type = token_map[t->type];
-	}
-
 	return conf;
 
 errout:
-- 
2.54.0 (Apple Git-157)

