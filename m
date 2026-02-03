Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93833446B3
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770123111; cv=none; b=m6aTe6/vYZSGki9MhnHQK9yjW23I1GqNTDuk9JUO9oksN+G9tUngwcLgTsURtOku47Yg1F3az0EFO5zpW+3r6KaOknRRhUYTcqgF4+LlLJUau0Un5/Szgf4zIYfWNlSE5txNjM2DaF0GWpqyY3FAypQ9mME1Y/C9oc6GpQVaOFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770123111; c=relaxed/simple;
	bh=y2V2HMwTxheKgI+Qo9+r/lLsC5dY5MBo9fVnG8TzHDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRGBrx6nUDlOWU/2CMhjWtUz9MR+fuyTm0u1WbZVM7/gwmxYr7KpS2+HFhSOoJHnKMDejb5l14cLyIxmiLEfGt2z/6Nf1a8q+5ismqVfsTJiw6oDv1pKf7rf/jA/Q/Lf28iWvc9MCIW0WPvZoNdMEZhf5YkmGy9HrB7xqvDpepM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6E2676033F; Tue, 03 Feb 2026 13:51:46 +0100 (CET)
Date: Tue, 3 Feb 2026 13:51:46 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Subject: Re: [PATCH v4 nf-next 2/2] netfilter: nf_tables: serialize reset
 with spinlock and atomic
Message-ID: <aYHvYiDKHVdOoSeg@strlen.de>
References: <20260203050723.263515-1-brianwitte@mailfence.com>
 <20260203050723.263515-3-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203050723.263515-3-brianwitte@mailfence.com>

Brian Witte <brianwitte@mailfence.com> wrote:
> Add a dedicated spinlock to serialize counter reset operations,
> preventing concurrent dump-and-reset from underrunning values.
> 
> Store struct net in counter priv to access the per-net spinlock during
> reset. This avoids dereferencing skb->sk which is NULL in single-element
> GET paths such as nft_get_set_elem.

Ouch, sorry about making a wrong suggestion.  I did not consider that
this reset infra also works via plain netlink requests rather than just
for netlink dumps.

> For quota, use atomic64_xchg() to atomically read and zero the consumed
> value, which is simpler and doesn't require spinlock protection.

I think you should split this, one patch for quota and one nft_counter.

> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Brian Witte <brianwitte@mailfence.com>
> ---
>  include/net/netfilter/nf_tables.h |  1 +
>  net/netfilter/nf_tables_api.c     |  3 +--
>  net/netfilter/nft_counter.c       | 17 ++++++++++++-----
>  net/netfilter/nft_quota.c         | 12 +++++++-----
>  4 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 426534a711b0..c4b6b8cadf09 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1935,6 +1935,7 @@ struct nftables_pernet {
>  	struct list_head	module_list;
>  	struct list_head	notify_list;
>  	struct mutex		commit_mutex;
> +	spinlock_t		reset_lock;
>  	u64			table_handle;
>  	u64			tstamp;
>  	unsigned int		gc_seq;
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 9969d8488de4..146f29be834a 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3986,7 +3986,6 @@ nf_tables_getrule_single(u32 portid, const struct nfnl_info *info,
>  static int nf_tables_getrule(struct sk_buff *skb, const struct nfnl_info *info,
>  			     const struct nlattr * const nla[])
>  {
> -	struct nftables_pernet *nft_net = nft_pernet(info->net);

This is odd, shouldn't that be in patch 1?
I would expect compiler to warn here, when just compiling with
patch 1 applied.

>  	u32 portid = NETLINK_CB(skb).portid;
>  	struct net *net = info->net;
>  	struct sk_buff *skb2;
> @@ -8529,7 +8528,6 @@ nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
>  static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
>  			    const struct nlattr * const nla[])
>  {
> -	struct nftables_pernet *nft_net = nft_pernet(info->net);

Same.

> @@ -12050,6 +12048,7 @@ static int __net_init nf_tables_init_net(struct net *net)
>  	INIT_LIST_HEAD(&nft_net->module_list);
>  	INIT_LIST_HEAD(&nft_net->notify_list);
>  	mutex_init(&nft_net->commit_mutex);
> +	spin_lock_init(&nft_net->reset_lock);
>  	net->nft.base_seq = 1;
>  	nft_net->gc_seq = 0;
>  	nft_net->validate_state = NFT_VALIDATE_SKIP;
> diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
> index cc7325329496..54bcbf33e2b9 100644
> --- a/net/netfilter/nft_counter.c
> +++ b/net/netfilter/nft_counter.c
> @@ -28,6 +28,7 @@ struct nft_counter_tot {
>  
>  struct nft_counter_percpu_priv {
>  	struct nft_counter __percpu *counter;
> +	struct net *net;
>  };

Hmm, I think thats too high a price.

> -static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
> +static void nft_counter_reset(struct nftables_pernet *nft_net,
> +			      struct nft_counter_percpu_priv *priv,
>  			      struct nft_counter_tot *total)
>  {
>  	struct u64_stats_sync *nft_sync;
>  	struct nft_counter *this_cpu;
>  
>  	local_bh_disable();
> +	spin_lock(&nft_net->reset_lock);

This lock is too late, it has to be taken before fetching 'total',
else you get following in parallel reset case:

cpu0						cpu1
 fetch total counter, get 1000
 						fetch total counter, get 1000

 subtract 1000
 						subtract 1000 again

Maybe something like this?  I think the single-spinlock is fine, I
don't expect frequent resets, much less from concurrent netns.

If we get a complaint, we can always take the code-churn route to pass
'struct net' down to the dumper callback, or resort to array-of-locks
or similar at a later time.

+/* control plane only: sync fetch+reset */
+static DEFINE_SPINLOCK(nft_counter_lock);
+
 static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *priv,
                                       struct nft_regs *regs,
                                       const struct nft_pktinfo *pkt)
@@ -147,6 +151,14 @@ static void nft_counter_fetch(struct nft_counter_percpu_priv *priv,
                total->packets  += packets;
        }
 }
+static void nft_counter_fetch_and_reset(struct nft_counter_percpu_priv *priv,
+                                       struct nft_counter_tot *total)
+{
+       spin_lock(&nft_lock);
+       nft_counter_fetch(priv, total);
+       nft_counter_reset(priv, total);
+       spin_unlock(&nft_lock);
+}

 static int nft_counter_do_dump(struct sk_buff *skb,
                               struct nft_counter_percpu_priv *priv,
@@ -154,7 +166,10 @@ static int nft_counter_do_dump(struct sk_buff *skb,
 {
        struct nft_counter_tot total;

-       nft_counter_fetch(priv, &total);
+       if (unlikely(reset))
+               nft_counter_fetch_and_reset(priv, &total);
+       else
+               nft_counter_fetch(priv, &total);

        if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes),
                         NFTA_COUNTER_PAD) ||
@@ -162,9 +177,6 @@ static int nft_counter_do_dump(struct sk_buff *skb,
                         NFTA_COUNTER_PAD))
                goto nla_put_failure;

-       if (reset)
-               nft_counter_reset(priv, &total);
-
        return 0;

