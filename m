Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB2A8F6B
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Jun 2024 21:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719263943; cv=none; b=MaroD84K08l8JLdVu1tnCzkHqtEAudnoIgwKogs7XcXSTjqxW4T61Ady38zPFgwQ8KkC2ggjkwU5fN39GsaZdrakTg9qlQOhtnT7qbuf+b5qVomyxNxxj1yswqv54GdFEjoalqZZia0K1ozFIlIVKM/RS1b8tGV0pipJQJs0kzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719263943; c=relaxed/simple;
	bh=wPu5lK5Smv2OZPaM9bGETgKARS/qthlO/nzRh/qeZAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXD0Qd/+gY48mqkB2O2In1ex7WhOVl7DtiXODs6mDivx29VJ4oIzR+gRUzXGWSsSlZISMBj2YEz6FRkSfBV5woMboDDydCcWZrTSlVJcxLJ1DbSfuDN30RFKclk85rHbd2gMy9hPfCSD77VAysY3hty3T5IIZVVs4WcgLsDLfIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sLr5Q-0003o1-O9; Mon, 24 Jun 2024 23:18:52 +0200
Date: Mon, 24 Jun 2024 23:18:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 02/11] netfilter: nf_tables: move bind list_head
 into relevant subtypes
Message-ID: <20240624211852.GA14597@breakpoint.cc>
References: <20240513130057.11014-1-fw@strlen.de>
 <20240513130057.11014-3-fw@strlen.de>
 <ZnnGFCF_BTe4YN-V@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnnGFCF_BTe4YN-V@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, May 13, 2024 at 03:00:42PM +0200, Florian Westphal wrote:
> [...]
> > @@ -1621,12 +1620,23 @@ static inline int nft_set_elem_is_dead(const struct nft_set_ext *ext)
> >   */
> >  struct nft_trans {
> >  	struct list_head		list;
> > -	struct list_head		binding_list;
> >  	int				msg_type;
> >  	bool				put_net;
> >  	struct nft_ctx			ctx;
> >  };
> >  
> > +/**
> > + * struct nft_trans_binding - nf_tables object with binding support in transaction
> > + * @nft_trans:    base structure, MUST be first member
> 
> This comment says nft_trans MUST be first.

Yes, thats because current code assumes that it can
cast any subtype to nft_trans.

Once everything is converted to container_of that would
not be necessary but I think it would still be better to do it
this way.

> I can add BUILD_BUG_ON for all nft_trans_* objects to check that
> nft_trans always comes first (ie. this comes at offset 0 in this
> structure).

Sounds good, thanks!
