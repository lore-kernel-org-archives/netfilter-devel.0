Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1776221276
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842724; cv=none; b=nsFGLL8eKkOU3AgFWYOYOi7AY5KY7+yAe+4dSIaElHk2DvvMVjPmkN+/BzKgSmvjGHM4jJds0bYZtcTNtUXDsznPobRi7W6r6W282CgTvESGMoNhVtTs9p0yEVRf/tiCzUCq3XKi8RdK8gs6724usUXnUFJd+xEa8sF2h3Km9nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842724; c=relaxed/simple;
	bh=dYXahMvqhRT8KgMErBd9z+IfElzyVLe80j2Gk3ZKuMw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NeoNRA9N7MFOLvEOA/DlCllm34Lw+0Q/tgfXZMweqq1iAa2YBTzP1fgiYRyAHFOfZP4OSsW1Ns9E4xOkbHb9VSMNi8BeYzmG3cAI9TVEf/eNm0VqqW+wXIG5AzxqnAwI2dBk1uQYHc45hcZDLp6R6MjAov2IvHq3tvKpWQUfevI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=n0pJzJpp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dukEvo+A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="n0pJzJpp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dukEvo+A"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3D21E6072A; Wed, 21 May 2025 17:51:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747842714;
	bh=pvhtQEHAMistL68VbDyNAXyHegYKjbGbclnF/z19FTQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=n0pJzJppZpoUEzJDO7TPY+ldExE2vlxVGx+jiTOtJWH3RINHXS9LPkg58/zykZ8jN
	 dMs5f4N2ExxqoejDwxLEQqFQHF4X2zhwZ3eeazuRFtVyg2lbtywNwp3PfHFV35gUgm
	 3Nitar0Hy5a2BzZ5AXPQuHwIRCpkyqTSb1c+6XtMlr0Ul7Wly/EV0gMZtwTfQh9HXv
	 04rA6rXPMZqC2nVejqjUdDFBOCSQRdF4kFMNwhtqd9272Q+HrKAvLJllEDXcFxAgzZ
	 yaSp0KfgKi5CtEilLDNZHXzJtZNPPZ18hz6Z610kMlkiuAXi06dN5HXSfcGWX8At3O
	 I7qs5lL2lVuYw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 14BA260722;
	Wed, 21 May 2025 17:51:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747842713;
	bh=pvhtQEHAMistL68VbDyNAXyHegYKjbGbclnF/z19FTQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=dukEvo+AjFhDWQ2W0QrJzROyJlOC73u0C1rQ+xRXBL9K3YCs5nH9G0TIcG+cVtUoM
	 2JB4KHidUlb7TK8Tnk8AMybYm+gLZEp9Vw75Qo1FT0z1S24dt1PYUFJg1a0OCqB+v+
	 GG4EPfX9KpAHG/OLQ9YJP9L51Fxa9ro2LIaD5h6Qs6dLGpRcnL1z2uYOE36eUOEfbQ
	 OlsGCx9sXsXySKfozZfBZWV7lXucjdxv85ua+xxSgCnUSCBjawcleg+6Zs0OsIdlN2
	 eGd1VCaKPf8BUNghncettmOKfbYWzk/mlzSzXr/pXY75mUIMeeuMZ8PGs5kfEzT1jV
	 CJyI68QSQ3rBg==
Date: Wed, 21 May 2025 17:51:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aC32llhNc-j5j49-@calendula>
References: <20250415154440.22371-1-phil@nwl.cc>
 <aC0B8ZSp8qNzbPqR@calendula>
 <aC3yKSl3u4_zNc4b@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC3yKSl3u4_zNc4b@orbyte.nwl.cc>

Hi Phil,

On Wed, May 21, 2025 at 05:32:57PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, May 21, 2025 at 12:28:01AM +0200, Pablo Neira Ayuso wrote:
[...]
> > 2) I wonder if nft_hook_find_ops()  will need a hashtable sooner or
> >    later. With the wildcard, the number of devices could be significantly
> >    large in this list lookup.
> 
> Maybe, yes. Is it useful to have a single flowtable for all virtual
> functions (e.g.) on a hypervisor? Or would one rather have distinct
> flowtables for each VM/container?
[...]
> Callers are:
> 
> - nft_{flowtable,netdev}_event(): Interface is added or removed
> - nft_flow_offload_eval(): New flow being offloaded
> - nft_offload_netdev_event(): Interface is removed
> 
> All these are "slow path" at least. I could try building a test case to
> see how performance scales, but since we hit the function just once for
> each new connection, I guess it's hard to get significant data out of
> it.

This can be added later, not a deal breaker.

This is event path which might slow down adding new entries via
rtnetlink maybe, but I would need to have a closer look.

[...]
> > == netfilter: nf_tables: Add "notications" <-- typo: "notifications"
> > 
> > I suggest you add a new NFNLGRP_NFT_DEV group for these notifications,
> > so NFNLGRP_NFTABLES is only used for control plane updates via
> > nfnetlink API. In this case, these events are triggered by rtnetlink
> > when a new device is registered and it matches the existing an
> > existing device if I understood the rationale.
> 
> Yes, MSG_NEWDEV and MSG_DELDEV are triggered if a new device matches a
> hook or if a hooked device is removed (or renamed, so the hook won't
> match anymore).
> 
> Having a distinct NFNLGRP for them requires a new 'nft monitor' mode,
> right? So we can't have a single monitor process for ruleset changes and
> these device events. Should not be a problem, though.

Having a different group allows to filter out events you might not
care about, it is a simple netlink event filtering facility.

I think this feature is for debugging purpose only, correct? So a
separated group should be fine. IIUC, this event does not modify the
ruleset, it only tells us a hook for a matching device is being
registered.

Thanks.
