Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED81A5B84
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Feb 2026 20:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769977582; cv=none; b=BE55WI1Neg4sHE1YHOAwjzhDiVafyc5rvEwdvltukzq9VSvn6Pd0/P0QD5hRAKu7iurvHE3jJ8SfjOTwx29WMYO/XHtzyjUJwHvLMEOwjV598z396B/uLqPj/8Wz4K2oQCaLO7V/G+trlLt0OEfS6TpCuL5cyweIZ1jFOim0K18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769977582; c=relaxed/simple;
	bh=HqP9tuWqQvOZvnqbH0hI6UZAzjZiqICQC5hFCpN4E1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TKNhGag6IJKeojp5sBipf65HpplU4bdMtZCY5tTsP1plzGHEaBjmdayTh42gyc8GZ+hbLgygGk2ABlRWqhtVHwxuI0LPr0CA/VUjTUKBIfpvmnVsxTZhw9X6ctmG7DZKExQOrQhtJ3VFBmcNkh8pjW6JpW54uyLqR8etjmBERps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DAB33605C3; Sun, 01 Feb 2026 21:26:17 +0100 (CET)
Date: Sun, 1 Feb 2026 21:26:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Subject: Re: [PATCH v3 2/2] netfilter: nf_tables: use spinlock for reset
 serialization
Message-ID: <aX-25IhjRWUAeOc4@strlen.de>
References: <20260201195255.532559-1-brianwitte@mailfence.com>
 <20260201195255.532559-3-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260201195255.532559-3-brianwitte@mailfence.com>

Brian Witte <brianwitte@mailfence.com> wrote:
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 5b6c7acf5781..11765fc3ac67 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3860,6 +3860,9 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>  	nft_net = nft_pernet(net);
>  	cb->seq = nft_base_seq(net);
>  
> +	if (ctx->reset)
> +		spin_lock(&nft_net->reset_lock);
> +

Iteration can take some time, its not ideal to hold a spinlock
for so long.

I was thinking of pushing it down, e.g.:

static inline struct nftables_pernet *nft_pernet_from_nlskb(const struct sk_buff *skb)
{
	return nft_pernet(sock_net(skb->sk));
}

in nftables.h and then:

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -106,13 +106,15 @@ static void nft_counter_obj_destroy(const struct nft_ctx *ctx,
        nft_counter_do_destroy(priv);
 }
 
-static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
+static void nft_counter_reset(struct nftables_pernet *pernet,
+                             struct nft_counter_percpu_priv *priv,
                              struct nft_counter_tot *total)
 {
        struct u64_stats_sync *nft_sync;
        struct nft_counter *this_cpu;
 
        local_bh_disable();
+       spin_lock(&nft_net->reset_lock);
        this_cpu = this_cpu_ptr(priv->counter);
        nft_sync = this_cpu_ptr(&nft_counter_sync);
 
@@ -120,7 +122,7 @@ static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
        u64_stats_add(&this_cpu->packets, -total->packets);
        u64_stats_add(&this_cpu->bytes, -total->bytes);
        u64_stats_update_end(nft_sync);
-
+       spin_unlock(&nft_net->reset_lock);
        local_bh_enable();
 }
 
@@ -163,7 +165,8 @@ static int nft_counter_do_dump(struct sk_buff *skb,
                goto nla_put_failure;
 
        if (reset)
-               nft_counter_reset(priv, &total);
+               nft_counter_reset(nft_pernet_from_nlskb(skb),
+                                priv, &total);
 
        return 0;
 

... and so on.

Not even compile tested.  Patch 1/2 looks correct to me.
