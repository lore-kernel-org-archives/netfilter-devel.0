Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CECE2C21F4
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786367064; cv=none; b=l1dW7rnX80ZVKvMgFrppx/VIzihRHjrv5PSegajjdcg5t/9jKOEmSumitAJ+aviRU0DbOShJxmnLP6tsl4J50xdHTK9bjNrkRvnrxFY9ru592KnPa0lDWMv66m5fiGJo6TQNagz5YmZFwO+H5zsU4HY7KvVKzTpqIAQxwW864dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786367064; c=relaxed/simple;
	bh=l75s9+vQ0iAUXoZb5LktxSV6GEijvQnyzcrarvMVlgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+jZPRUqq0suXcm+aZQBWowG7+4Z6RZhfKGTvatKyruS7l9uX3Rg2SsoElZIrHzonB2ZAtXPqH6XY/5Xjj25xLMNijiRKmc7AeggqhrvnaiArn8rf9qaxbi/LP+naI2T/JWqgZBkX+4GimzuzqP7VbbXlQpWMXMc9oNlQhtyj5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fp4ByUta; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fp4ByUta"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 04E0660265;
	Mon, 10 Aug 2026 15:04:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786367060;
	bh=fxYmMgjDXEV+6Y8dwy2f4K2xQhdCKyAaKuht1DDQXDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fp4ByUtaSUB3/trGhrIbvtEqEb9VDaj4PUZ9LjkLlxQXmI/3YfyA0vOTolaqT78Kl
	 marjxgl3vhXhiPJ11nCl5F2rUpqwtOLyIKdHZ/2vsTkpALlwMMhHVwyhLSH+KUdmpi
	 d65dYJBiJ1XF77Ny1c2sghu83j5ON7fIrL075x0YWR+i/gH8tMAN6UdADoFWhq3b/p
	 xqFv6eRgZggz7NtaTAdAWFlqmzWWJo/O5B0SnISatGRwVoMw2L5yJbv9x/v8A6RrEa
	 28nBW2hFuJ9eQruj0CRq2qD9kPrvbnPMXNyUVCmHMH2fJyU5/mLJBnPIe1cIvUtYAe
	 fiAm+SrrEaS9g==
Date: Mon, 10 Aug 2026 15:04:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: fix list type element drift bug
Message-ID: <annMUJ7jQoPBh2HT@chamomile>
References: <20260806135341.8896-1-fw@strlen.de>
 <6082ea3a-15d3-650a-98a0-403b1bab7b5d@netfilter.org>
 <aniLwNENxpoK-qK2@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aniLwNENxpoK-qK2@strlen.de>

On Sun, Aug 09, 2026 at 04:16:32PM +0200, Florian Westphal wrote:
> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> 
> Thanks for reviewing!
> 
> > > +	if (n) {
> > >  		list_set_replace(set, e, n);
> > > +		return 0;
> > > +	}
> > > +
> > >  	else if (next)
> > >  		list_add_tail_rcu(&e->list, &next->list);
> 
> While it makes no difference from correctness, the
> above looks very weird, so I propose to turn the else if into plain if (next).
> 
> (Did not spot it before sending...).

For the record: I mangled the patch to remove this else when applying
this. No need to resend.
