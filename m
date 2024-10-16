Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25DE215F4B
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 20:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109115; cv=none; b=Jga1GSaG83Gbtqlkrl4EL7klvMkYWq+V74TjfcfWqH0KZs7u4DTjs7kF9+XdJrlBLam5P0uC906wuBhFTb3BmN8TWEMAEDX+fObUbph1uBUG0SOatOYV4WlV6OroGDcxC2QfJHECPcwTnFx4psUA7VsYrIz/CEAZ8ubH/JF8QfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109115; c=relaxed/simple;
	bh=zf/Ow7URyDM0lqM0qQp7Grqt+CbJBv8+sJmNFfAdQpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCbrT7dzhKITmJifgo0XvFWDxVNqq+V1aw4nsIPCkLG++eH/87QyGQWW8Yx20UInx4iOWBRUXF7L6vVvjJmudc5I5Raq4vSQxvVAvrQT+/s7ZwpKHGgzsWlCTQ2jyD5HppdIMGokqhOXLpbGrq8rJ76QrUyx6kZJENYENxV00AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=l0CKD2nq; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="l0CKD2nq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PpvO3akHpQIy58M17Xk4ja0HwX8ucHmViLG/CZIeSO4=; b=l0CKD2nqsiQAinzLEHhxKWxYLZ
	QQl3UdbzhalKGHGGX9ld8w7i3vZ/N8UH/7EyfBfR8SUM1meQtb0T6Rdk9vp/8XRwI8fqWcnNgGRzC
	KxmbRlVZ+dsStgeVMsA8/CZxM9ewDSWE0raLa01Tr1a146v8ZnnPLA/GI7MP69VkfEiZzcNZFJ90R
	rQAP3ldO+XLSJ7CRuOqpH1mnGkk7Qw+PSbjGspcJ9J61RjfDZ+I6ujnZHIzpIhnf7aktg+GnPqeOP
	VS2+or7GkwCy219MfrSuVRpO7hu3phSSTMp9CVaiHRC9cv7Q9lJ0yYW89AU0yEhQAkjJikme99PXy
	9aAkFWbA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t1AGc-000000000wr-2Eqv;
	Wed, 16 Oct 2024 22:05:10 +0200
Date: Wed, 16 Oct 2024 22:05:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <ej@inai.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC libnftnl/nft 0/5] nftables: indicate presence of
 unsupported netlink attributes
Message-ID: <ZxAcdux4eQXeMiXB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Jan Engelhardt <ej@inai.de>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20241007094943.7544-1-fw@strlen.de>
 <Zw_yzLizGDGzhFRg@orbyte.nwl.cc>
 <45r97p82-s222-1286-6636-25p3631qq10o@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45r97p82-s222-1286-6636-25p3631qq10o@vanv.qr>

On Wed, Oct 16, 2024 at 09:28:46PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2024-10-16 19:07, Phil Sutter wrote:
> >On Mon, Oct 07, 2024 at 11:49:33AM +0200, Florian Westphal wrote:
> >[...]
> >> Extend libnftnl to also make an annotation when a known expression has
> >> an unknown attribute included in the dump, then extend nftables to also
> >> display this to the user.
> >
> >We must be careful with this and LIBVERSION updates. I'm looking at
> >libnftnl-1.2.0 which gained support for NFTA_TABLE_OWNER,
> >NFTA_SOCKET_LEVEL, etc. but did not update LIBVERSION at all - OK,
> >that's probably a bug. But there is also libnftnl-1.1.9 with similar
> >additions (NFTA_{DYNSET,SET,SET_ELEM}_EXPRESSIONS) and a LIBVERSION
> >update in the compatible range (15:0:4 -> 16:0:5).
> 
> From 1.1.8 to 1.1.9, there were a bunch of function additions:
> 
> +void nftnl_expr_add_expr(struct nftnl_expr *expr, uint32_t type, struct nftnl_expr *e);
> +int nftnl_expr_expr_foreach(const struct nftnl_expr *e,
> +                           int (*cb)(struct nftnl_expr *e, void *data),
> +                           void *data);
> 
> No such modifications (of this kind, or any stronger kind) were made between
> 1.1.9 to 1.2.0, hence there was no LIBVERSION update.

Ah, you're right! No libnftnl.map update, so no newly exported symbols.
The ABI must be identical between the two and thus LIBVERSION remaining
the same is correct.

> Expanding the enum{} generally does not change the ABI unless the underlying
> type changes (which it did not in this instance).

I got confused by the added nftnl object attributes, but the data
structures are hidden for a reason and the getter/setter mechanism
allows for exactly these changes to happen under the surface.

Thanks for clarifying!
