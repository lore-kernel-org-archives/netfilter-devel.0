Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F814286
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2025 00:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738025844; cv=none; b=Ue1fKOTintR+q+HjHuKkeJs7Cqf0EKQCqTqVDUke1W/QKSYU2aXLOhIMtT99PuF+JCJvM58XkdK3XmUSk2lrsg5EK+8IPed4MX7NChg4j1HFpyuz3oTV+v9CWVEQp4Mxw4jvWyD/bbOrjlpVHhz/jW1a34v++LbXN/NiwYjLvOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738025844; c=relaxed/simple;
	bh=wghLW2vizcs0ePS4hJMMXOQr/25DFdzLwSig5/+5Pu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lk7jLo0oBQiDMS3bNNORutlGYswJ/RfRuXOOZqa8ADg1mGrQKCIhi5MZ3xkOXCkEXDv6gEjdLl7+/2IQts6hzMqo1RtKTir1JXLDFmcKB7Hf6e50hqngrQDNr4kJcigxgMyjgJuQ3SRW9Ce7XQdJUfzVlOQSL2mMFzKBBM4ys1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=djyo/1Dq; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tC1jbvEB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="djyo/1Dq";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tC1jbvEB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 605B460289; Tue, 28 Jan 2025 01:57:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738025839;
	bh=2sEBgNJj4INJz19htjjnofnbONU+0mJWveSMmNFzWjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=djyo/1DqSxrc8W+qfz5sAsGmnjcBmFDxAb+T1yA8oGB4aKwkaLrb+IhFBEPWbAtLR
	 OqZIY13ht/gGiiHzIB6bm9ZlARQzgiaoJn41tk4Gwm8yhO7G/0KSoU5rR8joDHnPWO
	 rbWwqeO/G8b7Lu//rtUQvLI8H4TVlTgST9TTuea/tqwjX6VCftppIfX9a56IxfXqbv
	 poYRKAc77wnhJ5pCfypTs7KFqdueMxvaMbVy0lhRQ3MacvJvcuQPmYdRbv59Jbd5KT
	 nUPqtQKFYl8BWLwwEuaBuhHOSYAO/QkeScG3h7hFJi+rpYpyQDwS7ySo1xRXokDVMz
	 wujA2uPf162HQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AEA4360289;
	Tue, 28 Jan 2025 01:57:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738025838;
	bh=2sEBgNJj4INJz19htjjnofnbONU+0mJWveSMmNFzWjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tC1jbvEBy1L408NXIwc6sY/hmZ5NGKpnm8vToY4CmqPks04NksXXxR+A+uHZlPNlI
	 WWOBJRFYeJpP9PyIon5iVaDNof6sWSTID2WlBgN072I44QbY58DnIZ+RYRLIpVP7VB
	 ewvW1IeFMCVdBq18ApuQj4g/LlPXtK1cQODtkirSf1EPd9zVIajzOpENck6jKEXDbF
	 fLhs/KKV5vzih5b4uuNQJFIeR53V6iGaHz27cBHiYJ16Xqt32XSnRMzJqiVbKrYfd2
	 sYwKNcfaWh9wosBtAJYyNsrD/s7Gt+z3ZaMLeiKeZKM7/Uc0UBeEIgwPh0pPjSdQiM
	 3tjnEqhlJxFMw==
Date: Tue, 28 Jan 2025 01:57:16 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: reject mismatched sum of
 field_len with key length
Message-ID: <Z5grbJ3psaGWWH-0@calendula>
References: <20250127234904.407398-1-pablo@netfilter.org>
 <20250128003012.GA29891@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250128003012.GA29891@breakpoint.cc>

On Tue, Jan 28, 2025 at 01:30:12AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The field length description provides the length of each separated key
> > fields in the concatenation. The set key length provides the total size
> > of the key aligned to 32-bits for the pipapo set backend. Reject with
> > EINVAL if the field length description and set key length provided by
> > userspace are inconsistent.
> > 
> > Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nft_set_pipapo.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> > index 7be342b495f5..3b1a53e68989 100644
> > --- a/net/netfilter/nft_set_pipapo.c
> > +++ b/net/netfilter/nft_set_pipapo.c
> > @@ -2235,6 +2235,7 @@ static int nft_pipapo_init(const struct nft_set *set,
> >  	struct nft_pipapo_match *m;
> >  	struct nft_pipapo_field *f;
> >  	int err, i, field_count;
> > +	unsigned int len = 0;
> >  
> >  	BUILD_BUG_ON(offsetof(struct nft_pipapo_elem, priv) != 0);
> >  
> > @@ -2246,6 +2247,12 @@ static int nft_pipapo_init(const struct nft_set *set,
> >  	if (field_count > NFT_PIPAPO_MAX_FIELDS)
> >  		return -EINVAL;
> >  
> > +	for (i = 0; i < field_count; i++)
> > +		len += round_up(desc->field_len[i], sizeof(u32));
> > +
> > +	if (len != set->klen)
> > +		return -EINVAL;
> > +
> 
> I fail to grasp why nft_set_desc_concat() doesn't catch it:
> 
>         for (i = 0; i < desc->field_count; i++)
>                 num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
> 
>         key_num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
>         if (key_num_regs != num_regs);	----> here....
>                 return -EINVAL;

This check is loose, I will post a v2 fixing up nft_set_desc_concat().

Thanks.
