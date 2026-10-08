Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7AB374A18
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 07:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791443315; cv=none; b=I1g1fS/NGEZtqOMLcy+ePQ2HQ/E+xzQAQq9v/AZgjTT3aZviyx6EU0vw6v4JUWGHhOU2Q6wvFETzJV3roCaG3kp6WWP5mJ0pANxOKcNgiuyCn8va5O6nfjuHpqcwzh/O7n60/mukFssnrnm3ENtx5zUPorIQjaAIiCEhpTRw6xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791443315; c=relaxed/simple;
	bh=2DQtUVojBklWceYYZ7AkmbMmtb/k+4nBgF6tiNZfdrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNsgBnR9gCKxrBITTPMJXzsiZjKcQ3XnHm4TbzUCVa/XVeIuNMlSrBLtonahhsbE7SoXhFkl84StwILvpg7vsn9MOLTk295zSCHj7x9IlJGz9oR+K0KYOJEQjwzekFZNq/x7evjSGigLM29SJgLaRZkhyV3t4/zGoV4fz9iaZ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=hEU0oWp3; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="hEU0oWp3"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e7006bbf77so5677455ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 00:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791443314; x=1792048114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WPkff/c113yUwpV+D0vdz5i6exryYraT8pUF3MTk8XE=;
        b=hEU0oWp3R4f97MUg26lcXS5TofTD4z8/E8vcbm9xs80MKvT4NIvql9W25R9nlKagVj
         lHk5Mu/IsunZGo7flWP6f8JdqnfxtVk3Lk6NmhxieYWRTpDA+/EynUI4+EqLQNBjPtQk
         MqujD/QrI4j1id3XRi9lDnA+AEr8MmuIASWT//jUUHmQs5DcAgmH4Il9RvO8yJwZG+Y4
         t9bTDgWOpR2IGI7pxrC1Imtk63Gm5V46/wYG69jkIPbOIW082ennJ6cneTq4QHX01jwy
         4rB09UhzLZB9UMOtfF4/WqNXYhBqvVgt7k6uB2z9JKzTa7wVawj0ndRaHhdDmXoPGnPk
         8Q4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791443314; x=1792048114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WPkff/c113yUwpV+D0vdz5i6exryYraT8pUF3MTk8XE=;
        b=o5G2/1kC+qAzcs58nbjnqMW1nh0pWKek9tLM6RqMlQf22YyN2usV5f45BvOyZoj0Lm
         E/fWaI9rZpStSkoGODS2X5qjtd7S+Q4FLo0oA9Wt+GIfaS850kTUG79+0wj4K/3LDLs0
         qvcN9d6fcA07cPxTU5ubiTtugpce4aMNBjz8X5plQD7l3thPO+EIiuoFKiK4wZp5TpIN
         bk9tq7jquOgYaof2U5skcMTP+uXmu60iQgtFGHHsLHAVsNy9BwQCsB88GTaXHiVGElCs
         PrWNV/PZnvCilIcIyORjbWxOfzxV3tznYLQ8pN6UT0Phudcy1oVH1mXBJKzCtjLMIVmS
         MpKw==
X-Gm-Message-State: AFq9FYJs0Zzm9Dh3vAdP/ZQZN4xvgQN5EV7F1brC1FaEH1gK4VYd2miW
	m1NysVVCVlGnSPNqztfeldWyk2eCDwfO68Iuvxmv/vYVoheY7bTH+3AW/YdH9TT0rIePvAuR/00
	pCrwDQ7YF
X-Gm-Gg: AYBFou0FPthRnB389zMhzBKPoQ8qaA2Q/WeJScZbKvEr/dGnekOjlAHpxWSEfq1TYiK
	sbA6NxbimW0EkXu9rVpadSRs6Bmo5zyHugnNu4mp7pMt5x8E3+H/LEc+6VVQysidDqFENw7VWec
	Tc+PN1naiiFBymXAgVWp9OOdeHmG/kT1oKSD4Wtx0xcdZXMFGTFRfJmwtToE4vDNLy5i2Pcb0M7
	7rofJ3HWG/bmcXOD2EJBgNnI7CBIlMiTE/7lr4XhTviLavldFPIJi8hIhfVGoN09d7LYf/H3+S0
	/wqBMwik4Dj0XcFaua9NufljeVjtyieYP78Iy4tOrnNjifeDOfjxWRylyq4909L26UzXUTesX1w
	k+cvQXT96+UYmhYcAmQVTUMiaedwSuRfK8HlYMKqDqVnkDh+LvMXyyHopuny5ZZQhsX4o0Ssf5v
	VedDJ+9VtW38NQviJapJ+J0qx6EXFvXJEuyp1jsd/Sv2i1RaPx4Srt21kY/d2os6fQcgzLK7Oan
	5U3L4AJ90aBcDBWlGuOMDrgOrl4Lkw2iLix924a
X-Received: by 2002:a17:903:acc:b0:2e5:dd85:c77c with SMTP id d9443c01a7336-2e60054a36bmr38412645ad.50.1791443313584;
        Thu, 08 Oct 2026 00:08:33 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e6046fe0d9sm20771385ad.20.2026.10.08.00.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 00:08:32 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v6 1/1] netfilter: nf_dup: reject TEE and IPv4/IPv6/netdev nft dup in userns
Date: Thu,  8 Oct 2026 07:08:16 +0000
Message-ID: <82abaa776053bb3e716095a783722452d87fa039.1791429178.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791429178.git.zihanx@nebusec.ai>
References: <cover.1791429178.git.zihanx@nebusec.ai>
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
changes in v6:
  - reroll the unchanged four-file setup-time restriction on nf.git main at
    ab699d296e06
  - do not present v5 build or runtime results as v6 validation
  - v5 Link:
    https://lore.kernel.org/all/20260929125832.25316-1-zihanx@nebusec.ai/
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

