Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBDC32E74E;
	Thu, 27 Nov 2025 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246854; cv=none; b=K8Vdd3AxY3nh0RW7P/dwhRNlWkrNAnTbHL40sJUFh34B0unYclDgVcJRpA7Esp6BlDDm7RIgF1oNdVbY0XJ0YCgpat0W+eRET6Z3YoRAI7Fcgtl8hEptbv6nNXhCq3vAOAHBgU8KdCgmEKDc+3UNbwqrPdg/uxuPxq5EWjGLGUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246854; c=relaxed/simple;
	bh=kPEeVjlsROszodXwHmrTdOPdnmIysr4IV/UbI9/crGE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s/m9xs2mNjCnKTDYZDI+7Z7TkAkjoR7TZd4EEdlZhsnchfwmlYI3QtA/r5QryPtHJ0a3tETF2wZ5s4ygVRcRw3e5xtAbIh0H27yhChs4PpypSKh6q0Y1qVMsug3/I67RPx/tKJ7fCSto5TFGW7TyQ4Opq5RGF9HRa8/jOABfoBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSYglpkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSYglpkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DA0C4CEF8;
	Thu, 27 Nov 2025 12:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764246853;
	bh=kPEeVjlsROszodXwHmrTdOPdnmIysr4IV/UbI9/crGE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=oSYglpkNdbnKr0j/kjD5YUQrG77ldRVzmACd2NgjL6lELOLgDGGp/ak9hvTiBRrnM
	 xWFBFbmFNdldMpf1IRpj//lre8Z9ZKS7T4LvQwbqb9yWMxwrD5F22UYm6TvlX8NSf0
	 +2xLx6GN9D56/8zn5REI61ak77oIPd5/IKkKURsjva7f77PgZkjZRnL865xrEohkiB
	 yG4m/frA0tAHuDSCV9u6uJxPeGzG6QK1B/f8S9wB+0gCH+kfeWJmmf07TqAzbruuIo
	 /NyY6aZskAKa0bU7MmgRcdeLSdZtdYA7W0orka2ES6i3FPCvhptTlQK0tj0ral7mVF
	 qo/TgWuF2u8AQ==
Subject: [PATCH nf-next RFC 3/3] xt_statistic: DEBUG patch
From: Jesper Dangaard Brouer <hawk@kernel.org>
To: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
 phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com,
 mfleming@cloudflare.com, matt@readmodwrite.com
Date: Thu, 27 Nov 2025 13:34:08 +0100
Message-ID: <176424684879.194326.4423360073954201534.stgit@firesoul>
In-Reply-To: <176424680115.194326.6611149743733067162.stgit@firesoul>
References: <176424680115.194326.6611149743733067162.stgit@firesoul>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

This is not for upstream comsumption.
Used this while developing the patch to valid the two cases was exercised.

Nacked-by: Jesper Dangaard Brouer <hawk@kernel.org>
---
 net/netfilter/xt_statistic.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 165bff0a76e5..016669a71f2a 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -4,6 +4,7 @@
  *
  * Based on ipt_random and ipt_nth by Fabrice MARIE <fabrice@netfilter.org>.
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
 #include <linux/spinlock.h>
@@ -26,7 +27,12 @@ MODULE_DESCRIPTION("Xtables: statistics-based matching (\"Nth\", random)");
 MODULE_ALIAS("ipt_statistic");
 MODULE_ALIAS("ip6t_statistic");
 
-static int gso_pkt_cnt(const struct sk_buff *skb)
+enum gso_type {
+	SKB_GSO_FRAGS_LIST,
+	SKB_GSO_FRAGS_ARRAY
+};
+
+static int gso_pkt_cnt(const struct sk_buff *skb, enum gso_type *type)
 {
 	int pkt_cnt = 1;
 
@@ -39,9 +45,11 @@ static int gso_pkt_cnt(const struct sk_buff *skb)
 	if (skb_has_frag_list(skb)) {
 		struct sk_buff *iter;
 
+		*type = SKB_GSO_FRAGS_LIST;
 		skb_walk_frags(skb, iter)
 			pkt_cnt++;
 	} else {
+		*type = SKB_GSO_FRAGS_ARRAY;
 		pkt_cnt += skb_shinfo(skb)->nr_frags;
 	}
 
@@ -54,9 +62,10 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct xt_statistic_info *info = par->matchinfo;
 	struct xt_statistic_priv *priv = info->master;
 	bool ret = info->flags & XT_STATISTIC_INVERT;
+	enum gso_type gso_type;
+	bool match = false;
 	u32 nval, oval;
 	int pkt_cnt;
-	bool match;
 
 	switch (info->mode) {
 	case XT_STATISTIC_MODE_RANDOM:
@@ -64,7 +73,7 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			ret = !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH:
-		pkt_cnt = gso_pkt_cnt(skb);
+		pkt_cnt = gso_pkt_cnt(skb, &gso_type);
 		do {
 			match = false;
 			oval = this_cpu_read(*priv->cnt_pcpu);
@@ -79,7 +88,7 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			ret = !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH_ATOMIC:
-		pkt_cnt = gso_pkt_cnt(skb);
+		pkt_cnt = gso_pkt_cnt(skb, &gso_type);
 		do {
 			match = false;
 			oval = atomic_read(&priv->count);
@@ -95,6 +104,10 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		break;
 	}
 
+	if (match)
+		pr_info("debug XXX: SKB is GRO type:%d contains %d packets\n",
+			gso_type, pkt_cnt);
+
 	return ret;
 }
 
@@ -154,11 +167,13 @@ static struct xt_match xt_statistic_mt_reg __read_mostly = {
 
 static int __init statistic_mt_init(void)
 {
+	pr_info("module init\n");
 	return xt_register_match(&xt_statistic_mt_reg);
 }
 
 static void __exit statistic_mt_exit(void)
 {
+	pr_info("module exit\n");
 	xt_unregister_match(&xt_statistic_mt_reg);
 }
 


