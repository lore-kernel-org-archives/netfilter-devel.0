Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D779513569
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686729; cv=none; b=aZQcrVdB1mY75wAfNVMFE7bHLtGnQroH4R1e7py68pGQOJHvIwqihxywS9B+rneS6JK6TToqD56ZxkgmP2fZanwAQ9m2CP2Lgl1JcDfRobtlLK++WHw0I6uwephSUkBnIRKgnMSIWl4PMZL1IIJdepY0zjMBWGxhK0TJTlYcm/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686729; c=relaxed/simple;
	bh=QsvX/9Uae7qLGQUIHlgGcdg1HE+YLgZ1QWvZCXAA3xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTF+2fcyGTEg4tNOrELm3PHlT8koAB9j2Eh+NmyOAGCfj4HwSo1vkVvG+UcGVEa+nnjfsc/QX9d7Yk9KXkN+XJRfY52JnXRZce8sqnUHoYjHpnIWf+a0LoywEoa/Hk3r4SA5Rrrnezlo0q/3DlcScwxQLliMsB4vJEuyl4h9uoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=I4wtw50e; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="I4wtw50e"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so2811797a91.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 05:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790686726; x=1791291526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pUh4O99671nsimpfC56hDaVgU0hoG+9KFPLpUAeDtPs=;
        b=I4wtw50eAHN+y1rm28WnUAWP3BE2UX+AZ+O+xO5H+A7R2l1eK77+Sui+6Vzz70KMuu
         Is9z3ClDCurWNzMUeS1Gcts4tWG1yAZsgAyZgLtORTueAxKQoFh4NoOU+wNFPPAaCg+e
         A5uZXBu+r9GJunmHrl9EkWQFeodIh75KALGHTiWBXoSkZweKz5jpp6L+zpbarDFtd1Ys
         8H4i9qjGiQnsyuLpMb6cyllvpdVKtZrfCEiUjtURLEdxK3iurb3EY3uNWBxd1xa66IUG
         GrcX62IOWQJLgiQgJrVFyDEbT+I4voed3a0/rgrICUc7+8V8PM1cjITL9lmz5eNP+sdx
         QVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790686726; x=1791291526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pUh4O99671nsimpfC56hDaVgU0hoG+9KFPLpUAeDtPs=;
        b=iX0ZGrjBKQu3qWktOzQXzLgmAI26iz/j2ASu0ANI2aJaSAB+IEZuHk3KGWzXN5kltK
         OduGCvLtDdiMdLXoaZj1nocrDEjIthWVAmF8G6F03x6quN5/rwO/bQTjQ9vO2vfbvmQI
         b4zkqQPLqfrXXe7irWWeoPl/6yq8Y2l4JZRrnM9ndErCubSiuvdwxeTDtn65F1mhOA6M
         y2tvYZ9W8JCiRCuYayTpbKBTCm54LWzAVEoEs6NwS/NxVRzPb1tdKDaU9LyefgfqaEEg
         hGB//u/5pkvcE4MPRCZ69y9mzTZRadkY9bvSltqj4fQugv5AIwa+ghlGaQ9545PgN0xR
         A31g==
X-Gm-Message-State: AFq9FYJiRUJ8byaQpylEOo0d0rh6ZFAAtHP+uWi7/VZpUc6VCdGeeYRU
	5tHdOFR2UwGcbXaWK+GqL4S+GZMwZdTEXtkvTVFFaMmXAkAZEOgvpt5tgYd7E3gMzpfoogrW8+F
	5aRWQ1t7U
X-Gm-Gg: AYBFou0wKqt5aoQ7/D4rD05SKcEqGHnBenkT/OSMDWfsgFMsBk79/dkpe3zVMpvlO6A
	esrjrInF7Nlf1HXWVziPA4ukvmAI/586optWvOCyFgexyOt8cF+ebOKYo3pMJmH0hkdtbe4dbNI
	26f7Hgg/s6s3D9lchgLggGXzA6e2h2ZAqUnV5zEjbnHly1HaUX8QQUPvchhYj3qQg6MfV/Dm3FP
	KWnIlKi3IHLd+2DdoxRPvUac0wMgEXAHLZbwwHur38LptBUwG3dnBbkhFrTBAieS6AYH2ybq47A
	w/+BapaG8iQUgffaafOaL6HSAox+f05Rs2HaAOeIahgK9udU/eMvqauE9s/lyRxlTdqheVvNwNs
	mNh1be+bky3b1IU1MXIWb2vwaA6eKsgd9HdBaryjyyjmp3je7pNkbixXvy69t9h5GJe2mzv8N0F
	X6JkYcFNwWtjbg9Kk9OarCbhI3veh1Nk5CA0A0fVorkFbtKUwS1dQawLheI50xNREvfH3YhoEZR
	6bRGrA+RmhmuTwvV5jZUViyWhp2iWKYvNdQvI9I
X-Received: by 2002:a17:90a:ec8e:b0:3a0:345a:3620 with SMTP id 98e67ed59e1d1-3a098df852amr12874873a91.45.1790686725852;
        Tue, 29 Sep 2026 05:58:45 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78794aa7fsm6180113a12.24.2026.09.29.05.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 05:58:45 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	zihanx@nebusec.ai,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH nf v5 1/1] netfilter: nf_dup: reject TEE and IPv4/IPv6/netdev nft dup in userns
Date: Tue, 29 Sep 2026 12:58:32 +0000
Message-ID: <20260929125832.25316-2-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929125832.25316-1-zihanx@nebusec.ai>
References: <20260929125832.25316-1-zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The packet-duplication frontends can permit repeated packet duplication and
resource consumption when configured in a network namespace owned by a
non-initial user namespace. Users with CAP_NET_ADMIN in that namespace can
configure the affected rules.

No use case for TEE or nft dup in such namespaces has been identified.
Reject TEE and IPv4/IPv6/netdev nft dup rule or expression setup with
-EPERM there, without adding checks to packet-processing fast paths.

This is a namespace policy restriction, not a general fix for asynchronous
duplication behavior. Rules remain installable in init_user_ns-owned
network namespaces, and their existing packet-processing behavior is
unchanged.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Fixes: 502061f81d3e ("netfilter: nf_tables: add packet duplication to the netdev family")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v5:
  - describe the patch as a non-initial-userns setup restriction, not a
    general recursion fix; state that init_user_ns behavior is unchanged
  - remove path-specific trigger details and run-specific metrics from the
    public commit and cover prose
  - drop d877f07112f1 from Fixes: because it added a later frontend, not the
    shared duplication behavior addressed by this restriction
  - record the v5 build and setup-time validation, distinguishing them from
    earlier unpatched-baseline and root-OOM runs
  - v4 Link:
    https://lore.kernel.org/all/cover.1790408011.git.zihanx@nebusec.ai/
changes in v4:
  - add Fixes tags for TEE, IPv4/IPv6 nft dup, and netdev nft dup
    frontends
  - clarify that fcd53c51d037 only added a synchronous guard
  - clarify that this restricts non-initial user namespaces and does not
    fix asynchronous recursion in init_user_ns-owned network namespaces
  - state explicitly that the netdev loop was not runtime-reproduced
  - v3 Link:
    https://lore.kernel.org/all/cover.1790042930.git.zihanx@nebusec.ai/
changes in v3:
  - reroll the fix against the latest nf.git main after no follow-up on v2
  - add the Co-developed-by trailer and matching Signed-off-by
  - v2 Link:
    https://lore.kernel.org/all/cover.1788425393.git.zihanx@nebusec.ai/
changes in v2:
  - drop the persistent struct sk_buff::nf_duplicated field and nf_copy()
    change from v1
  - disable IPv4/IPv6 duplication in non-initial user namespaces
  - v1 Link:
    https://lore.kernel.org/all/cover.1787903722.git.zihanx@nebusec.ai/
---
 net/ipv4/netfilter/nft_dup_ipv4.c | 4 ++++
 net/ipv6/netfilter/nft_dup_ipv6.c | 4 ++++
 net/netfilter/nft_dup_netdev.c    | 4 ++++
 net/netfilter/xt_TEE.c            | 4 ++++
 4 files changed, 16 insertions(+)

diff --git a/net/ipv4/netfilter/nft_dup_ipv4.c b/net/ipv4/netfilter/nft_dup_ipv4.c
index d53a65ddbd7b..db62e30456e4 100644
--- a/net/ipv4/netfilter/nft_dup_ipv4.c
+++ b/net/ipv4/netfilter/nft_dup_ipv4.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
+#include <linux/user_namespace.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
@@ -37,6 +38,9 @@ static int nft_dup_ipv4_init(const struct nft_ctx *ctx,
 	struct nft_dup_ipv4 *priv = nft_expr_priv(expr);
 	int err;
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
 		return -EINVAL;
 
diff --git a/net/ipv6/netfilter/nft_dup_ipv6.c b/net/ipv6/netfilter/nft_dup_ipv6.c
index 95ec27b3971c..6219ef57633e 100644
--- a/net/ipv6/netfilter/nft_dup_ipv6.c
+++ b/net/ipv6/netfilter/nft_dup_ipv6.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
+#include <linux/user_namespace.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
@@ -35,6 +36,9 @@ static int nft_dup_ipv6_init(const struct nft_ctx *ctx,
 	struct nft_dup_ipv6 *priv = nft_expr_priv(expr);
 	int err;
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (tb[NFTA_DUP_SREG_ADDR] == NULL)
 		return -EINVAL;
 
diff --git a/net/netfilter/nft_dup_netdev.c b/net/netfilter/nft_dup_netdev.c
index 06866799e946..8d9dfd18475c 100644
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
+#include <linux/user_namespace.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
@@ -37,6 +38,9 @@ static int nft_dup_netdev_init(const struct nft_ctx *ctx,
 {
 	struct nft_dup_netdev *priv = nft_expr_priv(expr);
 
+	if (ctx->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	if (tb[NFTA_DUP_SREG_DEV] == NULL)
 		return -EINVAL;
 
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 5d34ceb893ed..51c643987526 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/route.h>
+#include <linux/user_namespace.h>
 #include <linux/netfilter/x_tables.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
@@ -95,6 +96,9 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 	struct xt_tee_tginfo *info = par->targinfo;
 	struct xt_tee_priv *priv;
 
+	if (par->net->user_ns != &init_user_ns)
+		return -EPERM;
+
 	/* 0.0.0.0 and :: not allowed */
 	if (memcmp(&info->gw, &tee_zero_address,
 		   sizeof(tee_zero_address)) == 0)
-- 
2.43.0

