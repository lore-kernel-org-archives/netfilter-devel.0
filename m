Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091853C13F5
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 10:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783421217; cv=none; b=LcMFwHLKC3sJq/qR2qEkq7Qdd4Y46qHR+854oNnGoLVKNYRKLFHkEMO1WdAPneH5+Vw54dQaQG2zE37sMTZUbcSrxDis15xsfoX2DIokH0/4ry8jwKLb5XZ3yG72R+tWAhDRA0OmfH6gEn0Itk9l+JGrF39opmIND4tyz9jrJVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783421217; c=relaxed/simple;
	bh=aJ3/zI/Ipe0tDI7hs5GjITZYuJblgVMtVaQl6YroG5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4hRqXzJ/gDfsECuiPfEAJeq0FB5PXd6H7b2gLWFPdcZIKh7Nx4eWedVvfYnKs6mmHrBkwJdC40nZSW4x3m8TugWmEzYDrozk1f0Zwj1fr4EBCEW9Q9w9TTH/97HlDcOulmPMdqhzonInbB0gYirQSo9Txc+O+eweKYZSqeyA0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lWRncKkA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lWRncKkA"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 214BE60578;
	Tue,  7 Jul 2026 12:46:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783421205;
	bh=BlkcZ+Tgvd52QZqm9e0nRwyOR0Hs96z9PEAFP302U6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lWRncKkA/BdtaCIEBwyGufqn2TdZUuWyNKwUm4k5mxSRrH1bDnwmgIDcWnchVdfMY
	 QU+reBhV2+F1TyyvdN3227Q29cnIMrhz1hyeY5At9r1+JmUHZzdrCh2o48LhX8dJnS
	 tzLdTamsUTgekPZn9nLbBK3tjecI+EoEwQPaDBC+REyI6tPV53tbYhKbmzc/KnV6Ma
	 5Qk7byW0vOFjAx6m1UnevB87vrlP9vC/jxTAomdCLdtv8O96mUJmq9RXKaHDMlbq6y
	 43ok+QJ8stLPEJFto2M5l0eaDf+B69uySFOI09z0xkUkhghYf5n6er3diyrIMo9ox8
	 tJSnvw+O1kNyQ==
Date: Tue, 7 Jul 2026 12:46:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org,
	chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf,v2 2/3] netfilter: flowtable: IPIP tunnel hardware
 offload is not yet support
Message-ID: <akzZEhCyHWq95gGB@chamomile>
References: <20260630094056.97038-1-pablo@netfilter.org>
 <20260630094056.97038-2-pablo@netfilter.org>
 <akzVhnsxasPRga8H@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akzVhnsxasPRga8H@strlen.de>

On Tue, Jul 07, 2026 at 12:31:34PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > No driver supports for IPIP tunnels yet, give up early on setting up the
> > hardware offload for this scenario.
> 
> This series triggers many drive-by findings.
> 
> No big deal, should be addressed later.
> 
> > +	__set_bit(NF_FLOW_HW, &flow->flags);
> 
> Would you mind if I mangle this to use set_bit() ?

Go ahead.

> Its a low-hanging fruit, the other findings need
> more attention.

Yes.

> Otherwise I can also apply this as-is, its an improvement
> in either case.

I will follow with other comments, they are pointing to relevant
issues.
