Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEDD1DFE3;
	Wed, 12 Jun 2024 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718198154; cv=none; b=SX/57ZGwiT6PZqcusOMB2WA7/z3FWanKON5AGnTkeP3ZTe19EuVDP4x97q3Z2BG9nQjt1blXwHgxA2hrspLh99kCkeN+8Od3bk+GWFh+ZcQhXFn3q4GfPJjT5FD81PGGhqeVogAVDNKobH+xfb6T8HTAxNd1rAGa12o+tIcvA3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718198154; c=relaxed/simple;
	bh=W4ACezUPO47ukssjODA/ZzcWfulgmEYa/NAuOUhOOXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdiFp9QidBiYy4KhJpgNpuzBrfEdZw6U6oqUxBKrWhVMhdkReLrZzSOZq1CgRiIOBgTHn2GN3kR88ybOxqLnbziV+c/R8fjhSuHCbHJhdnLk88dv5LHpfk7OaxuVnJ7NEWOmaZgOFsMKrpwKnQ8vkMmdFndcOA/ER2euKyBWd/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43820 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sHNpH-003v6v-6y; Wed, 12 Jun 2024 15:15:45 +0200
Date: Wed, 12 Jun 2024 15:15:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Kuntal Nayak <kuntal.nayak@broadcom.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org,
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com, kadlec@netfilter.org, fw@strlen.de,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6.1] netfilter: nf_tables: use timestamp to check for
 set element timeout
Message-ID: <ZmmffoZAlP2wRQJL@calendula>
References: <20240607230146.47222-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240607230146.47222-1-kuntal.nayak@broadcom.com>
X-Spam-Score: -1.9 (-)

Hi,

Thanks for your patch.

rbtree GC chunk is not correct though. In 6.1, GC runs via workqueue,
so the cached timestamp cannot be used in such case.

Another possibility is to pull in the patch dependency to run GC
synchronously.

I am preparing a batch of updates for -stable, let me pick up on your
patch.

Thanks.

On Fri, Jun 07, 2024 at 04:01:46PM -0700, Kuntal Nayak wrote:
> diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> index 5bf5572e9..c4c92192c 100644
> --- a/net/netfilter/nft_set_rbtree.c
> +++ b/net/netfilter/nft_set_rbtree.c
[...]
> @@ -622,12 +624,14 @@ static void nft_rbtree_gc(struct work_struct *work)
>  	struct nft_set *set;
>  	unsigned int gc_seq;
>  	struct net *net;
> +	u64 tstamp;
>  
>  	priv = container_of(work, struct nft_rbtree, gc_work.work);
>  	set  = nft_set_container_of(priv);
>  	net  = read_pnet(&set->net);
>  	nft_net = nft_pernet(net);
>  	gc_seq  = READ_ONCE(nft_net->gc_seq);
> +	tstamp = nft_net_tstamp(net);
>  
>  	if (nft_set_gc_is_pending(set))
>  		goto done;
> @@ -659,7 +663,7 @@ static void nft_rbtree_gc(struct work_struct *work)
>  			rbe_end = rbe;
>  			continue;
>  		}
> -		if (!nft_set_elem_expired(&rbe->ext))
> +		if (!__nft_set_elem_expired(&rbe->ext, tstamp))
>  			continue;
>  
>  		nft_set_elem_dead(&rbe->ext);
> -- 
> 2.39.3
> 
