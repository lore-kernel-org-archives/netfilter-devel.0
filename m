Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB18E189F5B
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726665638; cv=none; b=EGeH7zNRZ5sLv09URmA86QTGHfV9FSaE86HShYQBV9G7f2FLwm4Ym5Vw/a8GAFbsSb0/3WKvTAD9pKNANJveCf6s6n4+9HSdvYUPH78FL0Iz7hXA/fX/4fR4t8ib44K0T3kLnnvj75rhyt19eoefxrDq6zOysNlyr5vs9IHAlnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726665638; c=relaxed/simple;
	bh=Je5rpE3RsHiEO2jBY2cmXjkETpwED72LOiCd0X1w/SA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dhi4e5AS2bSaWI+VMk5FkDPZ/E8xQtogaFUKv4hUy8LHZnlX+VxG4dHS3z8aML2DTerBDCJHqB6cvrl0VnYksERYjdwMKBntkXN7uTYy27EIQ8+Vl9WRaTLOo/uYh139rypMP7RKxNX5e25ur0Rp3Tf+qqnzviuhyek8C2wdPp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sqube-0004Pp-6r; Wed, 18 Sep 2024 15:20:30 +0200
Date: Wed, 18 Sep 2024 15:20:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, vasily.averin@linux.dev
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: missing objects with no
 memcg accounting
Message-ID: <20240918132030.GC16721@breakpoint.cc>
References: <20240918121945.15702-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918121945.15702-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> v2: a more complete version.

Thanks Pablo, LGTM.  One nit below.
> diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
> index 5defe6e4fd98..e35588137995 100644
> --- a/net/netfilter/nft_log.c
> +++ b/net/netfilter/nft_log.c
> @@ -163,7 +163,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
>  
>  	nla = tb[NFTA_LOG_PREFIX];
>  	if (nla != NULL) {
> -		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL);
> +		priv->prefix = kmalloc(nla_len(nla) + 1, GFP_KERNEL_ACCOUNT);
>  		if (priv->prefix == NULL)
>  			return -ENOMEM;
>  		nla_strscpy(priv->prefix, nla, nla_len(nla) + 1);

You could update this to use nla_strdup instead of kmalloc+strscpy.

No need to send a v3 for this I think.

