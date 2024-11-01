Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A908713DDD3
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 07:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730446319; cv=none; b=s8zspIbY7X+xxAL86zlDGn5PVzghcP2YQU/+IIUVddk876ZhomlWfm8KJRUXaCvC5Rt8pNKrBiaUBEmD0yfcLaQBWWGN3PfrAVGObcdlQg6yZgu0VK/eyNP4ZH8Sk8Z2x+YQp6eC+i23D07GuWSXT/4ztFTnh/J5XJsFkxU9pXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730446319; c=relaxed/simple;
	bh=2qoz+0gMD0Xsm5XXWbHmy3VuJNKoJMuBrTvNuwC0B+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFGupOMKlOvVxakDcavGNmCpjE6YaLwx6KWsuG+dTJEishcRoFJchMjHhDA0WUKxBUzB519RjzsofVpTAM3KohHfnJV61s72HS9CyizOwTKxn2O42aiuE9CRzMa41oz6ciryVtov3kh1rPVupOxqKitA0viuFLUIGlQa8EJ6o64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=33704 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6m8K-001Pcp-Ny; Fri, 01 Nov 2024 08:31:51 +0100
Date: Fri, 1 Nov 2024 08:31:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <ZySD48GBsbxTqUnh@calendula>
Reply-To: g@calendula
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
 <ZyQHv5lxlCrciEiq@calendula>
 <20241031230214.GA6345@breakpoint.cc>
 <ZyQR-4X_hw6ZRpRI@calendula>
 <20241031233742.GA8050@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241031233742.GA8050@breakpoint.cc>
X-Spam-Score: -1.8 (-)

Hi Florian,

On Fri, Nov 01, 2024 at 12:37:42AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Nov 01, 2024 at 12:02:14AM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > # nft -f test.nft
> > > > test.nft:3:32-45: Error: Could not process rule: Operation not supported
> > > >                 udp dport 4789 vxlan ip saddr 1.2.3.4
> > > >                                ^^^^^^^^^^^^^^
> > > >g
> > > > Reverting "netfilter: nf_tables: must hold rcu read lock while iterating expression type list"
> > > > makes it work for me again.
> > > >g
> > > > Are you compiling nf_tables built-in there? I make as a module, the
> > > > type->owner is THIS_MODULE which refers to nf_tables.ko?
> > >g
> > > Indeed, this doesn't work.
> > >g
> > > But I cannot remove this test, this code looks broken to me in case
> > > inner type is its own module.
> > >g
> > > No idea yet how to fix this.
> >g
> > I'm missing why this check is required by now.
> >g
> > Only meta and payload provide inner_ops and they are always built-in.
> >g
> > I understand this is an issue if more expressions are supported in the
> > future.
>g
> Can you mangle the patch to remove the type->owner test and amend
> the comment to say that this restriction exists (inner_ops != NULL ->
> builtin?)
>g
> Else this might work:
>g
> +       if (!type->inner_ops || type->owner != THIS_MODULE) {
>g
> ... but that would also need a comment, I think :-/

IUC, your concern is future extensibility.

To support for extensions other than meta and payload, this code will
need to be updated anyway, because __nft_expr_type_get() is used and
that cannot autoload modules:

        type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
        if (!type)g
                return -ENOENT;

        if (!type->inner_ops)
                return -EOPNOTSUPP;

I think removing it by now is just fine.

If you prefer the defensive approach, the an explicit check for meta
and payload ops is perfectly fine, but I don't think that is needed.

There is another issue that is spotted by smack which needs to be
addressed in this series anyway, this needs a v3.

Thanks Florian.
