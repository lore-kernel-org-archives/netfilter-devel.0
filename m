Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35012882B4
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761670741; cv=none; b=llm39ayzCB7KEyQCJlZ0+YHN7sHFcBcxR1JWYhiLV0Mn+ody3NO/H1GFAGIm3jbyU1AVHxub/4sBAYVyW4gwpmSwT6JkaXl5VATHza/Bmr9ke4TzCilb4eLObnTFWRQHkFiib6reH2QAObJUtDkt20G3o7/Q8cezlZ1T78SZYNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761670741; c=relaxed/simple;
	bh=tGchocrKT9H2Q8psYQanYMhhyqkOGeSgrBOYOx9JgXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkuWH2weNaPRH4hsSKBxeHUmFChbAtmCz9BXorOrX39xapJLEjTYSJR3jQGRI4ritPCaw2Lvg3h6v3RGvbCycR0PB045MP264f30iQXeUtUuisc/ti0kerlAHI/t7oU5qNCKh2gGx7cjb7FOAmzXA+lk6wBChY7cOBPht5Lu8u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GSJ/LKQM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GSJ/LKQM"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9677360281;
	Tue, 28 Oct 2025 17:58:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761670730;
	bh=NDoIOC+vHwUTWFq5pW7JrAoW3UL+pF1yRUw8sToYDaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GSJ/LKQMAPPt7fNIg4xBJFsfb0Thdck8f6mQHHsD5/xEWyuEkskEHT84FyzHa0elM
	 mlCMq50yQyeC0IwCK1hOVDInSDoBkuENsPRpIp0LipZ9rHrSxd5QmNl247DXFDkHIr
	 EsNkWIpJnanxvrszdo4qxz1fPUw06e+DM879jpEKrL47h5BWLcZbxIbA/MCTpDvxFw
	 OhQAr26xoalBia2q7iK31MgUyOoG5aHC4yvICJK5YblENycQFSUz9Xi0cA70IYa3If
	 Z2OBYtNOeg64uljeopcIFQQUK/+v27HKYoYIQs0SF34DMbWgvPkyuGTy9UvHiL3BoP
	 6F4DqQaVzUftA==
Date: Tue, 28 Oct 2025 17:58:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of
 a connection
Message-ID: <aQD2R1fQSJtMmTJc@calendula>
References: <20251027125730.3864-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251027125730.3864-1-fmancera@suse.de>

On Mon, Oct 27, 2025 at 01:57:30PM +0100, Fernando Fernandez Mancera wrote:

> diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
> index fc35a11cdca2..19c8b5377e35 100644
> --- a/net/netfilter/nft_connlimit.c
> +++ b/net/netfilter/nft_connlimit.c
> @@ -43,9 +43,15 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
>  		return;
>  	}
>  
> -	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> -		regs->verdict.code = NF_DROP;
> -		return;
> +	if (ctinfo == IP_CT_NEW) {

Quick question: Is this good enough to deal with retransmitted packets
while in NEW state?

> +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> +			regs->verdict.code = NF_DROP;
> +			return;
> +		}
> +	} else {
> +		local_bh_disable();
> +		nf_conncount_gc_list(nft_net(pkt), priv->list);
> +		local_bh_enable();
>  	}
>  
>  	count = READ_ONCE(priv->list->count);
> -- 
> 2.51.0
> 
> 
