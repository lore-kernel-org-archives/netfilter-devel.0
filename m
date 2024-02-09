Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63F5328B1
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Feb 2024 12:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707481227; cv=none; b=ElzSshWu+XR3KyxY76hOCet/bbQETfP8SAPxTsaG8hjV+FWJDh0h2ODqyq+mBlIj3GSysGYpTFXOQex06LKD8q8qgadzChfB1qFjzxLKSYWKa4LVVYKItWTX8g92kfrx6u53NXMVRZrIsYxj6uN4quwU3RpBACKI/Qs7O6V8ivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707481227; c=relaxed/simple;
	bh=ugsmRK8M2ATIo3GRsyV3VpByiqWCGXjuqY9/ljTwEHs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VWil49WD6Lj0bGvLZNOpwnNU5Nr4PFbt8EyJX+YZLumJzsy5dCoF5KTUBqLv0oTCutn+Y1I0TYBF7cFukcBGULkmMdCTPY7RSY3fYIYnOeEIwBMFJujfBlS2tsKKCnt/7BwSL7jd3Fm1cLwtDxgZS1JTa60Xefh8wYLKbnbon9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=SGoMrtIB; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="SGoMrtIB"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-51168addef1so1640883e87.1
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Feb 2024 04:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1707481224; x=1708086024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IiAfhVaN2/v2cn7kXecDpPewUhI3Z4vsMDV5J3mOy4Y=;
        b=SGoMrtIBeXvohAlHo94jnzpwPPQvuaJ/iw7Y7OURQY3fUmgxSgkWnRbnC4tfGp3T9n
         FrfTpnH3J9KXCG5mx8qk+MjVaPQjJLfyZMi4RYU+0DdN1JoRQnli+XImfaI12UWs3uyd
         c9h5XJBtlJFeN3+KjIsRAm4XyqEQhqxcW23jV6XfHuVyVBj/NSUY1dkuHAzcPIoPMmhy
         e/tI66NNwexUGmXT4dLcQe8fNh/pMBS37JxoKuq6/PXH1382UUiEDb37RfQK1FuaL2ay
         UYyfqz0NAt+vD8+61HWBASJRe9UQ/qoGvETILnuTEN/uLriS2hXuXlDQnPrI2/d8Xmuq
         MT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707481224; x=1708086024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IiAfhVaN2/v2cn7kXecDpPewUhI3Z4vsMDV5J3mOy4Y=;
        b=m0YM0Ruzq7frMkhWMh1bRhxW4DhcF/j3axBnISBE16g2KEpTSbmFWUGehpqczZgvdp
         +EndtTotXjr97I4w1c1XPyqz2ttbCu7bxx2gqWhRWHQy0xv+TwW9UrHcmnBJuWtiUkrH
         7EbI4ZQK7a8RnJkQ3MWxyePAkKhYQgXM7npbI4HVh8Mm4TU4bwZnpjS3jbLxeH/XIq/Q
         4E961DHFg35VUzPTwZQY9jVLreqZbmKDSKRqVHSekbLbAlyxkEbY72/E7MrcsAQed0x7
         ETQ6FDi5pOve3ENmCn4glGtLsvlfGes7FXmgEw75NX7JtA/1UfSlK4SUpdvxBFMrBxwt
         T+Tw==
X-Gm-Message-State: AOJu0Yz79jnTkvxKKBJlNCJbmH9YTJbjee4fPxtMrbXaLw/iQ8ICIZPx
	fZG5T+NluPjDUSO3x93+xCowzasRuo4Z8cV6rkKwe1BOZXpPS0cGvBFoIzOkI50=
X-Google-Smtp-Source: AGHT+IFDrXjWfpNyiWzlRNHblNoL0TNFCz+STL2XSqeDQbWFrx9tkX8cdDV6us4MXvKOhh+Wk+uX2A==
X-Received: by 2002:a05:6512:68:b0:511:3ed0:f0e with SMTP id i8-20020a056512006800b005113ed00f0emr1061407lfo.13.1707481223738;
        Fri, 09 Feb 2024 04:20:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXdbU0S1wSNJoBxccDHmvK2OH7uRQF7ZkFrcuB9wjMCwlf5KW1UwCLBy9HU9zF1NOz4RltXXrG4doj9LK/GTZID0YExCJ7BatqBcZe/Yi5Vf4rMdu7oqnz1jw78Yk9PbiRZOsrOvtXakmC7YoV0ky75G7ZlHJ0YfpW1W2B6U/M247cmhSIzUOpWFsroOYDJ1CsFmD1Tat0dSgfc5KJVIVA1oMvO46caueFqV8fiRfqjP843CPcdb70cfw==
Received: from localhost.localdomain ([104.28.159.160])
        by smtp.gmail.com with ESMTPSA id r4-20020a05600c298400b0040fdc7f4fcdsm481334wmd.4.2024.02.09.04.20.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 09 Feb 2024 04:20:23 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Cc: kernel-team@cloudflare.com,
	jgriege@cloudflare.com,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
Date: Fri,  9 Feb 2024 12:19:54 +0000
Message-Id: <20240209121954.81223-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 67ee37360d41 ("netfilter: nf_tables: validate NFPROTO_* family") added
some validation of NFPROTO_* families in nftables, but it broke our use case for
xt_bpf module:

  * assuming we have a simple bpf program:

    #include <linux/bpf.h>
    #include <bpf/bpf_helpers.h>

    char _license[] SEC("license") = "GPL";

    SEC("socket")
    int prog(struct __sk_buff *skb) { return BPF_OK; }

  * we can compile it and pin into bpf FS:
    bpftool prog load bpf.o /sys/fs/bpf/test

  * now we want to create a following table

    table inet firewall {
        chain input {
                type filter hook prerouting priority filter; policy accept;
                bpf pinned "/sys/fs/bpf/test" drop
        }
    }

All above used to work, but now we get EOPNOTSUPP, when creating the table.

Fix this by allowing NFPROTO_INET for nft_(match/target)_validate()

Fixes: 67ee37360d41 ("netfilter: nf_tables: validate NFPROTO_* family")
Reported-by: Jordan Griege <jgriege@cloudflare.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 net/netfilter/nft_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 1f9474fefe84..beea8c447e7a 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -359,6 +359,7 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
@@ -610,6 +611,7 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
-- 
2.39.2

