Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D6B3314B6;
	Thu, 27 Nov 2025 12:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246847; cv=none; b=n7ZkAo/5jRfJ1Y4+AneQ5L3qTkF7sEkvNl39zDSnJ4ntTdFylqBpqHHdD9SqI7hQ1r6aCG4y06vXYZCi1xwoBROklH3+PLiWpjcSJFllarsyZu2b8sZ/TVBDs+mnPFT1uPfbEAZW4GCvKebkqB4RSr4PiPe+oUGRcwfKl6B/R6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246847; c=relaxed/simple;
	bh=Nnm6DeQrrkwyFyIvItI5t5wi9Mce5M8Pw/63wO3B+dM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bxhFMU0DXd9q3+RE6hT7pPyLp6uh/CkpmDTv8HL+jK0v8dAHIFFy3dEqvN4BCrgMVjRH/jw+eqxGVyjC/6zNEfjvvtrskhkK+z0+YbYFs3N8x2kBC+FLyXkkJCGXf+fU0/T5rbZWy3D/aNsP3GY0Liua6NvhwnH2jQbIJq5lMp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMpWD75r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMpWD75r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBE0C4CEF8;
	Thu, 27 Nov 2025 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764246847;
	bh=Nnm6DeQrrkwyFyIvItI5t5wi9Mce5M8Pw/63wO3B+dM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=MMpWD75rLughcoP9VCeq9OxNTx5GxSG+WU0pCy/GBp8JbKZhQHPNwc4svHFpA20IW
	 vY6KGWFN8EtSiOg0J9PcfFFGuYEoqIpWcdXd6KaiXYxIjbSKfy53elZQ9IyDJvGwWt
	 OD6L9fOgFLT3iTnIhr24MAuTWEA2CFH/mvKHpCODFPmMbanPQTWjyFAulqxjGytcg8
	 nofSiVxbaoxG1yneDnRfINg+h+MXIUpRPScY6PP+Qt9sO8vrRUVY+84ESK6atSIn3I
	 tTYxxCT7dvw+E6MiCSsxaXI/NqI9PSoGyGmErC7XJrU3ZsqyG5NQz/eNOlRNvoqDgb
	 zchNXfGr06pKQ==
Subject: [PATCH nf-next RFC 2/3] xt_statistic: do nth-mode accounting per CPU
From: Jesper Dangaard Brouer <hawk@kernel.org>
To: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
 phil@nwl.cc, Eric Dumazet <eric.dumazet@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com,
 mfleming@cloudflare.com, matt@readmodwrite.com
Date: Thu, 27 Nov 2025 13:34:02 +0100
Message-ID: <176424684236.194326.12739516403715190883.stgit@firesoul>
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

The atomic cmpxchg operations for the nth-mode matching is a scaling
concern, on our production servers with 192 CPUs. The iptables rules that
does sampling of every 10000 packets exists on INPUT and OUTPUT chains.
Thus, these nth-counter rules are hit for every packets on the system with
high concurrency.

Our use-case is statistical sampling, where we don't need an accurate packet
across all CPUs in the system. Thus, we implement per-CPU counters for the
nth-mode match.

This replaces the XT_STATISTIC_MODE_NTH, to avoid having to change userspace
tooling. We keep and move atomic variant under XT_STATISTIC_MODE_NTH_ATOMIC
mode, which userspace can easily be extended to leverage if this is
necessary.

Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
---
 include/uapi/linux/netfilter/xt_statistic.h |    1 +
 net/netfilter/xt_statistic.c                |   37 ++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/xt_statistic.h b/include/uapi/linux/netfilter/xt_statistic.h
index bbce6fcb26e3..f399dd27ff61 100644
--- a/include/uapi/linux/netfilter/xt_statistic.h
+++ b/include/uapi/linux/netfilter/xt_statistic.h
@@ -7,6 +7,7 @@
 enum xt_statistic_mode {
 	XT_STATISTIC_MODE_RANDOM,
 	XT_STATISTIC_MODE_NTH,
+	XT_STATISTIC_MODE_NTH_ATOMIC,
 	__XT_STATISTIC_MODE_MAX
 };
 #define XT_STATISTIC_MODE_MAX (__XT_STATISTIC_MODE_MAX - 1)
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index d352c171f24d..165bff0a76e5 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -17,6 +17,7 @@
 
 struct xt_statistic_priv {
 	atomic_t count;
+	u32 __percpu *cnt_pcpu;
 } ____cacheline_aligned_in_smp;
 
 MODULE_LICENSE("GPL");
@@ -63,6 +64,21 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			ret = !ret;
 		break;
 	case XT_STATISTIC_MODE_NTH:
+		pkt_cnt = gso_pkt_cnt(skb);
+		do {
+			match = false;
+			oval = this_cpu_read(*priv->cnt_pcpu);
+			nval = oval + pkt_cnt;
+			if (nval > info->u.nth.every) {
+				match = true;
+				nval = nval - info->u.nth.every - 1;
+				nval = min(nval, info->u.nth.every);
+			}
+		} while (this_cpu_cmpxchg(*priv->cnt_pcpu, oval, nval) != oval);
+		if (match)
+			ret = !ret;
+		break;
+	case XT_STATISTIC_MODE_NTH_ATOMIC:
 		pkt_cnt = gso_pkt_cnt(skb);
 		do {
 			match = false;
@@ -85,6 +101,10 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 static int statistic_mt_check(const struct xt_mtchk_param *par)
 {
 	struct xt_statistic_info *info = par->matchinfo;
+	struct xt_statistic_priv *priv;
+	u32 *this_cpu;
+	u32 nth_count;
+	int cpu;
 
 	if (info->mode > XT_STATISTIC_MODE_MAX ||
 	    info->flags & ~XT_STATISTIC_MASK)
@@ -93,7 +113,21 @@ static int statistic_mt_check(const struct xt_mtchk_param *par)
 	info->master = kzalloc(sizeof(*info->master), GFP_KERNEL);
 	if (info->master == NULL)
 		return -ENOMEM;
-	atomic_set(&info->master->count, info->u.nth.count);
+	priv = info->master;
+
+	priv->cnt_pcpu = alloc_percpu(u32);
+	if (!priv->cnt_pcpu) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
+	/* Userspace specifies start nth.count value */
+	nth_count = info->u.nth.count;
+	for_each_possible_cpu(cpu) {
+		this_cpu = per_cpu_ptr(priv->cnt_pcpu, cpu);
+		(*this_cpu) = nth_count;
+	}
+	atomic_set(&priv->count, nth_count);
 
 	return 0;
 }
@@ -102,6 +136,7 @@ static void statistic_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	const struct xt_statistic_info *info = par->matchinfo;
 
+	free_percpu(info->master->cnt_pcpu);
 	kfree(info->master);
 }
 


