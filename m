Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06BD2E6139
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 13:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755090432; cv=none; b=YDDeUD3nZRm3QODKSLAfHejzY92qZoiM/+WI0VIFJxyyA/qAektXj3/qzwTFoqYiW3i6xrdppcNkAR6ZP3N92/ZGlljYKCaEtmBuyFl3wjX4CCN1PQpLqV10Jf0fERQonlDEbharKnLBTZeXQMnm39V124uxLvFK6P/QYE96UxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755090432; c=relaxed/simple;
	bh=fRHCKxUWujWQfv84rr5EVZpXZAbFYskqneR/zCI3Ak4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+IK71zB7gVOOpP/2XqF/2NuqNEFIGTwSbhsb3DscCgzurcXcHeN86DJDYNZfu/i66wARHYsNLO81ar4LhaRAKuVtScOBKJE6+rRjFI4hq9TjaeW44z+igvSKlnJKjf67VZZD2Pdyjd9jcowFueN3RmC3xQvbgAUguigv9/02p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j4XXfu/l; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DS0RY/ah; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j4XXfu/l";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DS0RY/ah"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3923E60763; Wed, 13 Aug 2025 15:07:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755090426;
	bh=TYHfVAl3TWlkgPvV9R3uciNZ5l/L5UBrLG2AvpkBmNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j4XXfu/lKsIpEUDdyB3vXua5EF+ghkCf1PfvYcjXoTn6cwhzJsCpqB7CulppsITaC
	 FuVCaUgryR1rCSbZ8q0SzqQWPNsb12lHJteCTEp0wc8+Y6hotRyDaFFKF5AVrgxWAS
	 mJN8DU8QMFJIWxYfblk168rRRJfKIwUD8kQMI2Fgsiid2Ym1HzMVqNBKlc/Ue6YB3C
	 IunRP5DMO12UyGfin7WSftSul3AxlijkfxgBDoCYDahhk1eyjHF93JeBXVkXmHzIKR
	 KefKjc2HbrLZDnQFbbq2b4eK7GiSTV1Pr5xijB4r+8IwpakdDzcWEXJcM4E0oKM4Tn
	 rIH1xoXuHKXFA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 87C6E60760;
	Wed, 13 Aug 2025 15:07:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755090425;
	bh=TYHfVAl3TWlkgPvV9R3uciNZ5l/L5UBrLG2AvpkBmNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DS0RY/ahYXq0ZQnPKtdceCe/n5jJwsBIyWxT/+scGajsAS4gQ2ehIWPc4WTmgc8tS
	 lTSU9zA1hpSWFMnVHSl+w7GKOtPCS0vc0BkbaYDzrAYV6oSrG/f+jcCDSXgXvZzFxt
	 OuHllRY99IgYcSKQFe8w5/z5ToLuIWXgIrpwqXKp1wySOjUktYLei0uHXeica3eO4s
	 vQH03ARbmfsgP+NGQ2FYA70M1Fw21IrpSyiyrH5J3HYyrosCTg1/bv1Uda6j/nlE3o
	 0mYy+sln3pEOdQF7SQB6+8YJZyUjXANyXHThAS3OrqLsK+aFOiX35z0PT2ZKV6Cxyi
	 M58fR/PoGpX5Q==
Date: Wed, 13 Aug 2025 15:07:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: reject duplicate device on
 updates
Message-ID: <aJyN5ubyRjZHR8UO@calendula>
References: <20250813003850.1360-1-pablo@netfilter.org>
 <aJwyV7P5fqiENxB-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aJwyV7P5fqiENxB-@strlen.de>

On Wed, Aug 13, 2025 at 08:36:07AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > A chain/flowtable update with duplicated devices in the same batch is
> > possible. Unfortunately, netdev event path only removes the first
> > device that is found, leaving unregistered the hook of the duplicated
> > device.
> >
> > Check if a duplicated device exists in the transaction batch, bail out
> > with EEXIST in such case.
> >
> > WARNING is hit when unregistering the hook:
> >
> >  [49042.221275] WARNING: CPU: 4 PID: 8425 at net/netfilter/core.c:340 nf_hook_entry_head+0xaa/0x150
> >  [49042.221375] CPU: 4 UID: 0 PID: 8425 Comm: nft Tainted: G S                  6.16.0+ #170 PREEMPT(full)
> >  [...]
> >  [49042.221382] RIP: 0010:nf_hook_entry_head+0xaa/0x150
>
> Thanks Pablo.
>
> Just to confirm: this doesn't result in anything other than
> the unreg splat, correct?
>
> Or does this leak memory too?

It seems I tested on a kernel without CONFIG_KASAN, with it, it
reports UaF.

[   97.140749] ==================================================================
[   97.140762] BUG: KASAN: slab-use-after-free in nf_hook_entry_head+0xd9/0x140
[   97.140774] Read of size 8 at addr ffff88814feba108 by task nft/1097

> FTR, i placed this in nf.git:testing.

Thanks.
