Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9B91B3F0D;
	Thu, 29 Aug 2024 15:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724946485; cv=none; b=J6Z+CiXvdUYCChjdl1N9hv7yxMYDgz2JK+SEhAdbIfLcKXjyDbWv/XzvfFNtY/7GHiQ0asBbzYk06aorDz25isywBbtq7llRd6jGgiwxMuc4XcYvLdX8YZhf1Fu9WpDK2J+EBq0BJ7/Qfj9vouiQXmrC5B8buW3bKIRJEH1QDWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724946485; c=relaxed/simple;
	bh=ZdTFyHhOH/KgvRxfGlDREL10X0eEz/rPixae8p3OoBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAiKYng4+ma00FZzJfTE9ROwQjVkGdrep3EG72CAeHNQT4QAQVUTw1NcHWazk9aMe7GZXLANffxEimj+I/dNO8u8Hv7TF6JsukTh4qQVnwDWy/5sdzFiYAFNn9KG9lc7YXP9PWC6+vNUhj4exk8bmxC3Gz7j5vnlVwn0XEAoSDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AlzwR1JW; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AlzwR1JW"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a868b8bb0feso106930366b.0;
        Thu, 29 Aug 2024 08:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724946480; x=1725551280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xAx32F/TqiCZPJe3l7MuMeLUWvJtELLjmkRTSYa1sjc=;
        b=AlzwR1JWibigyRPKOtdjCJUXP+k6jFBQgV58myOV85l3oaB3DtWglK20tVmHvK2Aqh
         LBfs59yq04A51yekHnljzNA8p53CicqgxRS8avkfaM3nbwBOxZAqxCtEwNyUL38jtxJr
         uC8hgVWujPtqZXw6OAudd0im5K2Ar842qnifTwtxKgTVBhVz06Zl895xoV4g9Svix6H+
         uz2Pr3jsBKltoojYVAMf/ZscULuYUsPcYQ+9UrNaeOuxActidiUiVx/fc+FII1aSV7vp
         i38LeF2ESLxIXrC+HmTPPXbtXms5SyI4Y74dnvVKMYxzH2n+Mq+PY75XZs7i0HN9CV2K
         ni8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724946480; x=1725551280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xAx32F/TqiCZPJe3l7MuMeLUWvJtELLjmkRTSYa1sjc=;
        b=bTDJ7X5kN1w64sLlIgFQapehDmZhQgEi+HfZUu7FpovvkbiQ3j94Qk6Scx6Wet7YwD
         Hel4L3QryvA7U7qT88c1m31KUlhUfpAjo4nq1uHG17aoF1fivaheme4yJdI/P3L3tbjq
         YnO8vBva7qQ260EehJVEWqBjyGKtEYQNGRKva84VEc6+/hMHGINhr8oY/qS6bjrekD0B
         YIKbHe0SADdn0VBU6fb7NhfAEXl3wvyNbuzzQOrJLnrPngsFzZn79lXRKfS0iFcIbTkT
         elf8445/iZwYyfiZQjlCDR0y5kSjaULjCqL5xeldS7V/03E9GP/2TSFLVN1+Gl/Cc84s
         OTLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJgksNWRgY6RrCQuCEjKkgiV6+ehm6RnfSYeebZwCIy/OYW+i85l8uHqrtbnGJhH0mhvMmuXAQ@vger.kernel.org, AJvYcCXqN9XflNGp4OsUpmTEI71O9cTzKWSgiAgiVZtk8UK8MVyj2QD9RDFGJy/B+cmn9z66S8RFU66CnIQsZX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNeTXO7BYZPDhyBDbxrFfvlfqnHuddB6UmnNtYpH6aksg51fUK
	EZNj8bHtQcnd6ke8Pye/58EekId+epRioD+3qODN9fxpNNR/ZXOy+uM/VQ==
X-Google-Smtp-Source: AGHT+IFkbg1eGxyJbeBncyAP4B/tWHtxy5THWiiSaonWl5d5SEsPzMI0wadD4BQGLT91EF2QqwdmcA==
X-Received: by 2002:a17:907:97cf:b0:a86:c9f5:68df with SMTP id a640c23a62f3a-a897fa74e79mr197368866b.44.1724946479571;
        Thu, 29 Aug 2024 08:47:59 -0700 (PDT)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898900f29csm93489466b.64.2024.08.29.08.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 08:47:59 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 2/2] netfilter: nf_tables: Fix percpu address space issues in nf_tables_api.c
Date: Thu, 29 Aug 2024 17:29:32 +0200
Message-ID: <20240829154739.16691-3-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240829154739.16691-1-ubizjak@gmail.com>
References: <20240829154739.16691-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Compiling nf_tables_api.c results in several sparse warnings:

nf_tables_api.c:2077:31: warning: incorrect type in return expression (different address spaces)
nf_tables_api.c:2080:31: warning: incorrect type in return expression (different address spaces)
nf_tables_api.c:2084:31: warning: incorrect type in return expression (different address spaces)

nf_tables_api.c:2740:23: warning: incorrect type in assignment (different address spaces)
nf_tables_api.c:2752:38: warning: incorrect type in assignment (different address spaces)
nf_tables_api.c:2798:21: warning: incorrect type in argument 1 (different address spaces)

Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generic
and percpu address spaces and add __percpu annotation to *stats pointer
to fix these warnings.

Found by GCC's named address space checks.

There were no changes in the resulting object files.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
v2: Also use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros.
---
 net/netfilter/nf_tables_api.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0a2f79346958..46f362d4859d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2074,14 +2074,14 @@ static struct nft_stats __percpu *nft_stats_alloc(const struct nlattr *attr)
 	err = nla_parse_nested_deprecated(tb, NFTA_COUNTER_MAX, attr,
 					  nft_counter_policy, NULL);
 	if (err < 0)
-		return ERR_PTR(err);
+		return ERR_PTR_PCPU(err);
 
 	if (!tb[NFTA_COUNTER_BYTES] || !tb[NFTA_COUNTER_PACKETS])
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR_PCPU(-EINVAL);
 
 	newstats = netdev_alloc_pcpu_stats(struct nft_stats);
 	if (newstats == NULL)
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR_PCPU(-ENOMEM);
 
 	/* Restore old counters on this cpu, no problem. Per-cpu statistics
 	 * are not exposed to userspace.
@@ -2525,10 +2525,10 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 		if (nla[NFTA_CHAIN_COUNTERS]) {
 			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-			if (IS_ERR(stats)) {
+			if (IS_ERR_PCPU(stats)) {
 				nft_chain_release_hook(&hook);
 				kfree(basechain);
-				return PTR_ERR(stats);
+				return PTR_ERR_PCPU(stats);
 			}
 			rcu_assign_pointer(basechain->stats, stats);
 		}
@@ -2642,7 +2642,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_table *table = ctx->table;
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
-	struct nft_stats *stats = NULL;
+	struct nft_stats __percpu *stats = NULL;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -2738,8 +2738,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		}
 
 		stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
-		if (IS_ERR(stats)) {
-			err = PTR_ERR(stats);
+		if (IS_ERR_PCPU(stats)) {
+			err = PTR_ERR_PCPU(stats);
 			goto err_hooks;
 		}
 	}
-- 
2.42.0

