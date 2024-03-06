Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28151353E8
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709741530; cv=none; b=YmEM+GxBPOXKQTMVRUNpRQQiGeVZvxKwAVyPLipoObSDcagT6lOQe2QIyRBYB/Hs08sJrYE86WCNqFdJ03++SxA2N/ccSRmuVTeXBMwZjnJj4WgaxnoXAKiErxLOix4tapu+ILpp8LCIwWCk2m6Q6HcNOiRLZppp7d54qFZeNNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709741530; c=relaxed/simple;
	bh=aIFe/JuBoxqCu33T3fy+GF7rilPEpcA64Pe7Wt0oYps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHPuNzjyK21w4TDq+QqlnI/4TWAdrLcDWfWx2c27s+jvdMeinzXAsGC9yl+g8LWKopyXc/eKKg+LEApQqxHKYV0JMU6zHQPZaESLg/vOsvfH2eRTo6PXtJrOqob+oRdBLwKsYd39Ici92WH6KQ9nyxo87n7TNvKlp7zrcSVSo5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DkWdbAIC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DkWdbAIC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lOxcPmdzwJ/IS5Ik3UIvXGiGY9FN650zHDFbo+OOTA0=; b=DkWdbAICNMw96HMpD1A0zNqoBp
	LCOsq298wEZQ4a1gvUvpZRuELN48a6Nu6ytcht6hJGH8ETckhZ+0aj9mTrdCLcnbMLX9k7Qp2lmv9
	fKzy68W0h4SK/o9Yqn2qala/tOgHrcX2QeUMvxhxk2eOjAO26zT+4BcCmfPP5zHdZN0O0UfhhzyG2
	g5R03o16O6Xc0UfpRJ8mwVLx4cbDcSasV5qCWql1oN/Gdi0+HLV6p1H6h3sDSSQBF7otCUvDCPcir
	a7oTcsRVFv8NUwygS6ihHWuQ0As6uJd4Zr+nRXI6y8RPmiHnxSojALvhP/3UUXYgH5cxGxK/iwVYI
	RqljwtoA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rhtsD-000000007PK-3zSi;
	Wed, 06 Mar 2024 17:12:05 +0100
Date: Wed, 6 Mar 2024 17:12:05 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-nft v2] extensions: xt_socket: add txlate support
 for socket match
Message-ID: <ZeiV1RaT7Ld-KxXh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20240306101132.55075-1-fw@strlen.de>
 <ZeiDKkam7FXpCbiU@orbyte.nwl.cc>
 <20240306154207.GD4420@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240306154207.GD4420@breakpoint.cc>

On Wed, Mar 06, 2024 at 04:42:07PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Wed, Mar 06, 2024 at 11:11:25AM +0100, Florian Westphal wrote:
> > > +static int socket_mt_xlate(struct xt_xlate *xl, const struct xt_xlate_mt_params *params)
> > > +{
> > > +	const struct xt_socket_mtinfo3 *info = (const void *)params->match->data;
> > > +	const char *space = "";
> > 
> > The whole "leading space or not" handling is not necessary, I made
> > xt_xlate_add() insert leading space automatically if the first
> > character is alpha-numeric or a brace.
> 
> Perfect, I'll push this out after removing the extra handling.

Acked-by: Phil Sutter <phil@nwl.cc>
