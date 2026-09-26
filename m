Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9672DC331
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 09:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790414387; cv=none; b=YQi0Rg7E+pES1BGHlx8zYTEVsHdSKsIDSR2xCh43zTpLigyKh5sxaIBvvtgvEJo7DZjdOoaA1j9LaWFawzaMxzkQdj5fWfuiQt74AYUM16k8wHpWGM+VzB+qYDm3HIXBraybZpYcestNrEVLg0TaRa8bK4JY7Wqpy1DXh4tBXGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790414387; c=relaxed/simple;
	bh=3oJrG+KK6unBTLoJtFXe07dihlxSNwyhwcS72hSP3kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAO3rLlkqxVMAAs/WXlFK/xphBf7GLSLYut4aUWfDMlGWBmwq8wBJDIl+Z/C450cteikvQ9kjjOOeepVcCXHakfUJ7zlVoYEwGHdVQIlzFhWrAMdEhROTwPWHW9HRI/xSzrKhEujBUByFw9o0VdfD8ZcH2+tgiZ27qIzOWh5Azo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=g63UKmdz; arc=none smtp.client-ip=74.125.227.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="g63UKmdz"
Received: by mail-pj2-f38.google.com with SMTP id d9443c01a7336-2d747ec6185so6646765ad.0
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 02:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790414384; x=1791019184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4+KNC5/TI/+Z5H9Ooz4zVdgMKXm2ndwqcVaNLf23zWI=;
        b=g63UKmdzvVet8J57BMxoV36Y/PZeRqNi68CoDtVycxKJQTwQbveO/IRO3ZvSRPBBtn
         ncDr1+SZeXfe4f6BM/kS0KVNgDqeXbsBICDaXHDmiVGX/vvRWvsvjlSaOgOGPwTyqHos
         Jo/6gmY8Hy6oVNtZJio7g1RKBVuYSZf2SBtEH9BGes7dyB+HpKgrvZ57BB93Gvr+w0y5
         F5zjJdsik1XoZNGDhw5Zh9UVxYgIZzuPfAl3NT/zELGli0WRH/rGBSEkkNzqVlY+Dt7a
         CxZbxA2Id15sRXwyqHXcqd4NPCZLeRPEUZSbZUZ7LITxoCMJJOwQa0ut0F1AlnHjHWMs
         BdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790414384; x=1791019184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4+KNC5/TI/+Z5H9Ooz4zVdgMKXm2ndwqcVaNLf23zWI=;
        b=cwra51aQ9t9vgZUtNWLB2cZGC3AVkFG9FwY7vtFHf2HPQw3AVn+IJeKarKm0rVK7zK
         35mXBZ1n+IBs6RKzbOvDfWwOR8NTlimXiw/AyS//LOW9mSWV/uWh9es42P/qW3QPwCcA
         AL5sE5DRTFQaOy4LTC5nGTU/SGAF7wI38tU87G2Qu7rSPHiHW6Aba+sxeuWpIWJ1Nef5
         9USO3NwWxro+IIIvp6l9xntadNXnlJ6Wl1I81lsDPT4syXXPOtAfkmp7G/j9Nw0Ugmqv
         vDr2ILes61M8MQiWVEwqPvu/kCC6bF/pNPC7EFo69IlHGmXKrf3Ii0UwjAbvtd4aK3oQ
         mL+A==
X-Gm-Message-State: AFq9FYKcf/mnCMrtQkN0KGxjCz4hvZWKHemrDvQo+2l0FBguSUveAb6T
	VECRdupK3tcc/0b/c4k7q6steb8zX+xHRx/VBv+kRxDdbIaDvtVyjBXcb2aK+WiPxPNQgqHkKA4
	KHeAeVa2r
X-Gm-Gg: AYBFou3aD8hR2mH9tGKSiLwWgDc3N6lHc90uu1GZwtz/7QVPYaRf5kNbVMhDHOD7Vqx
	Xzz9emtkzEAadxLliUsfNMJzs2UsgoTzPyBpi/7s45FgcqWMTxa/bIbYyGi0/UOzlwrtrk0tstp
	82hVzkggsKeI0auPSv9JCnbUaf1rGi8sokND+IT+9mindPfBIOrkZEHI3/p5d1UYpcSkYXBH/5N
	jttZcIAmMxYwhOoTaYmME/Ln0fONzvF9yvslOBWgqC7uThFAoY6Hi3kPufx+cP592pNsq3Eu9OO
	rLmOQjzQUVYv/yBJR3ryhxFuUXC4hl5ZeZymPMa/4RoyYIwBvZX1Yd4yK36sd/TJJjfXWhiowWE
	gRSNKdE9p3r2jLClXGeOGAeI9TYHxvlsFag3GCSAnBhc7P6PqOyUIia5R/+iVLxTZd5YxabFigz
	QrPQ5BD8zLl45P1sT3WxA6onIWE4SNL12G8lpWZ2WGllQqrlwarZiqU4T3OYs8oAOCQbNcK2evT
	Njb/1THDN+D/tcBSBXoLZ4im12B3Q==
X-Received: by 2002:a17:90b:3c86:b0:39e:6c69:f472 with SMTP id 98e67ed59e1d1-3a098cf4a4amr7044911a91.49.1790414384207;
        Sat, 26 Sep 2026 02:19:44 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b4f5f917sm3553567a91.1.2026.09.26.02.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 02:19:43 -0700 (PDT)
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
Subject: [PATCH nf v4 1/1] netfilter: nf_dup: reject TEE and IPv4/IPv6/netdev nft dup in userns
Date: Sat, 26 Sep 2026 09:19:27 +0000
Message-ID: <f802b45414041d7a722f98810142c691e3718cba.1790408011.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790408011.git.zihanx@nebusec.ai>
References: <cover.1790408011.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TEE and the IPv4, IPv6, and netdev nft dup expressions allow packet
duplication in network namespaces owned by non-initial user
namespaces. No use case for these features in such namespaces has
been identified.

Reject these targets and expressions with -EPERM during rule or
expression setup. Keep packet-processing fast paths unchanged.

This restricts duplication only in non-initial-userns-owned network
namespaces. It does not change the existing asynchronous recursion
behavior in init_user_ns-owned network namespaces.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Fixes: d877f07112f1 ("netfilter: nf_tables: add nft_dup expression")
Fixes: 502061f81d3e ("netfilter: nf_tables: add packet duplication to the netdev family")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v4:
  - correct Fixes attribution for the TEE, IPv4/IPv6 nft dup, and netdev
    nft dup frontends; fcd53c51d037 only added a synchronous guard
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

