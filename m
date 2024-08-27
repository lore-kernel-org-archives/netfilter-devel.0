Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB622E62C;
	Tue, 27 Aug 2024 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724775335; cv=none; b=bw4pRVNkCxQ9WBbj1st4s1Qtk26ltcaJ1OSspNlx4NAaRGG7xa6Lp4bbq75zfVRlOd4SsFGefsHvoBOU9DKnY9cvirWJ37TspWbJ2HT0RbCjkYyaUO/sT69JtxggaajK9dqBWeOj1IdTSWjroORt53nzz7PmCKlodACOEH78fXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724775335; c=relaxed/simple;
	bh=96jM/fAZwQT9oJnOxuIrzX3FTJqJrZQY4N3yE1108zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuaPmA3EvntCIzzLs2SQUhC/3fXJ5Hxm25ZgXtY9GEn6FfCUovlBsugsC1i07re9UTjM1P8T3NS50Gy1azzwpwnZaUbg4+aAX7aBDUg1cMQZOSWFNxTaBSO/wmpCfxmgY3CsPozqDedll+yP2J2WNM/M8PYCqsmbM74cn8HhrOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=42560 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1siyqm-000FoT-EW; Tue, 27 Aug 2024 18:15:24 +0200
Date: Tue, 27 Aug 2024 18:15:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, jmaloy@redhat.com,
	ying.xue@windriver.com, kadlec@netfilter.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net/netfilter: make use of the helper macro
 LIST_HEAD()
Message-ID: <Zs37l04h3bsK8LIE@calendula>
References: <20240827100407.3914090-1-lihongbo22@huawei.com>
 <20240827100407.3914090-4-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240827100407.3914090-4-lihongbo22@huawei.com>
X-Spam-Score: -1.9 (-)

Hi,

On Tue, Aug 27, 2024 at 06:04:05PM +0800, Hongbo Li wrote:
> list_head can be initialized automatically with LIST_HEAD()
> instead of calling INIT_LIST_HEAD(). Here we can simplify
> the code.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  net/netfilter/core.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index b00fc285b334..93642fcd379c 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -655,10 +655,8 @@ void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
>  		       const struct nf_hook_entries *e)
>  {
>  	struct sk_buff *skb, *next;
> -	struct list_head sublist;
>  	int ret;
> -
> -	INIT_LIST_HEAD(&sublist);
> +	LIST_HEAD(sublist);

comestic:

  	struct sk_buff *skb, *next;
	LIST_HEAD(sublist);          <- here
  	int ret;

I think this should be included in the variable declaration area at
the beginning of this function.

>  	list_for_each_entry_safe(skb, next, head, list) {
>  		skb_list_del_init(skb);
> -- 
> 2.34.1
> 
> 
