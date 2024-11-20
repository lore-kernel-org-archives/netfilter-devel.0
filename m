Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5234D13BAF1
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2024 23:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145901; cv=none; b=jD71q8JLSG2qV4YaMLMTiRUelxdIsfqgO6yaLQUtENC59v+KTfylPOGDZWKri8dhQNHP/jfcqXU7ghTIeLTm5orwZnhVwMGNPQB9+RDl/q5mKlWaRcU7juBgnE99oZGZXirjN0EtC/Lfk+uaN5Kg4xoSZ4CTseq5oQY7gOtEYUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145901; c=relaxed/simple;
	bh=7B+w7x/FakDn8IE3SxKuoeWG//KOf92zrv5tofWUCsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1tnGsBfob+y/3r8Eg4KsDUjc8XknAA4+36hamB08Kbi7NLoRl1w8toYI1cLrPEkQU+Tkj1rxR7YotkPZMJiM4BoBDyW52e5a3I5O7ptibh5t63SUkqKBX8aiYu+ATH2fHZvwLbmUMtsfySaQEmKMCsMQvXl52Nm4r/+4FNJzhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tDuGv-0000MO-0M; Thu, 21 Nov 2024 00:38:09 +0100
Date: Thu, 21 Nov 2024 00:38:08 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: export set count and
 backend name to userspace
Message-ID: <20241120233808.GA31921@breakpoint.cc>
References: <20241120095236.10532-1-fw@strlen.de>
 <Zz5x-ImnAOh-9trs@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz5x-ImnAOh-9trs@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +/* no error checking: non-essential debug info */
> > +static void nf_tables_fill_set_info(struct sk_buff *skb,
> > +				    const struct nft_set *set)
> > +{
> > +	unsigned int nelems = atomic_read(&set->nelems);
> > +	const char *str = kasprintf(GFP_ATOMIC, "%ps", set->ops);
> > +
> > +	nla_put_be32(skb, NFTA_SET_NELEMS, htonl(nelems));
> > +
> > +	if (str)
> > +		nla_put_string(skb, NFTA_SET_OPSNAME, str);
> > +
> > +	kfree(str);
> 
> Can you think of a case where this cannot fit in the skbuff either in
> netlink dump or event path? I would check for errors here.

I'll change it, no problem.

> If you like my syntax proposal in userspace:
> 
>         size 128        # count 56
> 
> maybe rename _NELEMS to _COUNT.
> 
> As for NFTA_SET_OPSNAME, I suggest NFTA_SET_TYPE.

OK.
