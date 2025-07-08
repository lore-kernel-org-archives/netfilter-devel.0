Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F406E2D8DA8
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 14:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985529; cv=none; b=WYQ6/cfMeOtDqqufbFb0d9CxyseplnHZPNxtp+Y7QSsqxXF8mpm2z1sDLivvPwZA809Bx6p7YvsU16kt6A+U3ZS6RAYh5UZDmcz8de3jbZvZJHoXYXyGLHNNl3MUoC0+0uA4643RPFqGEw8tXGplhXSRMQl08XnL+Dun4pGZMGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985529; c=relaxed/simple;
	bh=eAe3OCW5Ho0NdojySo6KJtJZkxPvqBdJW4rg+ZfcugI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V45b/ytGiODw3fsz3fZlGyvYhbiZKa0vQ+HwUfVbidCGEiC6kM7W/zxHfSIrPWll5NVm50sTm4WdzVxp39Od3PVneNCp+uJhJUkf1AbsaKfavZ+9b9jeuxcXEXxVYFs5Qx4tU0bFR2He2WB7sbBIAOy0G9aV6aahArvFGLylY7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hj+PIpvS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hj+PIpvS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v09Huk9aVgFc+LzXBbiRO2WBus995oeoGVYHKE2V+3Q=; b=hj+PIpvShoO/jlo+yG/5Qlroak
	T2B5yh8ke2mi7CIYTTaF1QUIDO5bs03FRSlhcRUDwh6SxT/yHNJWYA9OP5LUQiE99BOnfwTteQw3x
	av83hbBdrBIrl+mFa58GluaRryEiombdQ9kQ6k+s3uln68XvZth9SvC9vcnUzR/BI+5b/FfhcpGdx
	WCDYDaOy1JUyinFw1dhX6+RVxvBt38bWIukJ+NBJsZnN6npmzLWMOSVX+HLgN6D//0RHkmwDvPUDc
	x6DIF8RS/V3Xnj7aZMqxYF3L7fCnwdP5BtHMlgsPHyL8QLfA0v87TxClNdum5h2SB42tHW4ZuwYZt
	tzpWDMNg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uZ9T2-0000000044P-2Wsw;
	Tue, 08 Jul 2025 16:38:44 +0200
Date: Tue, 8 Jul 2025 16:38:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aG0tdPnwKitQWYA6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
 <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
 <aGffdwjA23MaNgPQ@strlen.de>
 <aGwfPqpymU17BFHw@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGwfPqpymU17BFHw@calendula>

Hi Pablo,

On Mon, Jul 07, 2025 at 09:25:50PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 04, 2025 at 04:04:39PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Please keep in mind we already have 'nft list hooks' which provides
> > > hints in that direction. It does not show which flowtable/chain actually
> > > binds to a given device, though.
> > 
> > Its possible to extend it:
> > - add NF_HOOK_OP_NFT_FT to enum nf_hook_ops_type
> > - add
> > 
> > static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
> >                                    const struct nfnl_dump_hook_data *ctx,
> >                                    unsigned int seq,
> >                                    struct nf_flowtable *ft)
> > 
> > to nfnetlink_hook.c
> > 
> > it can use container_of to get to the nft_flowtable struct.
> > It might be possibe to share some code with nfnl_hook_put_nft_chain_info
> > and reuse some of the same netlink attributes.
> > 
> > - call it from nfnl_hook_dump_one.
> > 
> > I think it would use useful to have, independent of "eth*" support.
> 
> This is a good idea to place this in nfnetlink_hook, that
> infrastructure is for debugging purpose indeed.
> 
> If this update is made, I also think it makes sense to remove the
> netlink event notification code for devices, I don't have a use case
> for that code in the new device group other than debugging.
> 
> If Phil's intention is to make code savings, then extending
> nfnetlink_hook and removing the existing device notification group
> make sense to me.
> 
> User can simply resort to check via dump if a matching hook is
> registered for eth* in nfnetlink_hook.

What is the downside of having it? Are you concerned about the need to
maintain it or something else (as well)?

I had extended the monitor testsuite to assert correct behaviour wrt.
adding/removing devices. Implementing this is in a shell test is
trivial, but still work to be done. :)

Cheers, Phil
