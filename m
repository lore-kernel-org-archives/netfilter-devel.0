Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A368C391505
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 22:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787610272; cv=none; b=QMkD9ENhQn5IjtFOZhHkCaWAfe1Ord1zvE5ULUGezogYHAZlQJisrymDCIOkBFJuLEN305QI1O/k5vz/mN3n7mFi3BL/9wXL4WQ+wInFocZRQF/sASZ5iouMcrCXAYX3fMy0j5YwsoQlUAxzy5gxZGK4xTSGgeD2WYBIVgWaCR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787610272; c=relaxed/simple;
	bh=sW/9jDj/302eERLFWGFOSnDYGpgOag2byoUr9RKJbMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKXS4d3l0oi5hyLZRKSEygs3IxtU40DRcC6FuxuOomDjtdhC+eXjfdX/oSzqs7eSvem2YJBbquEfZb4U6+h0zCnfSGDoC/GhDxKRmZc1IIG+VSWRrTP4NthRaw0/dJWzlF1iClXpbygzBmQqMmblAutYz5KAMsj5+C/7pBNo/e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NLDeJh9S; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NLDeJh9S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787610268;
	bh=y5/NsOHHiyvlWiNmVwRM4pVYcmqVIlRe53HmyIV+3cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NLDeJh9SqA7QKWeOBFeYYb/iNRV6BMzTeDiICUyXnj5mAbqrP1PA/CwnWo06WWHqx
	 F5vmk0O4VC2dt9GZDNgvSRnwx1p35uQ2Iam2YKM6TtNbmBQv9m08BQra28F7vSDmOC
	 taqj8ZKKffOwyOCY0XvxkUdSSh1sRpJNDCTuehxc442oe6lDdv7iSim/zWCuAN9Gyh
	 5zau7AWpQtfdAoN8E/g7Mj6pFDU0Hfj1XaTaUThB7fxBKeOY/EWamXt23g29Qt34CZ
	 mcRRN32+W1MGD6M5xrHQLX4gvcTlEcTFDukuhE5AalaAWH1OlwlBkBQxpE/vN1lTTi
	 t2fWLCxDYS2fQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BE7E86008E;
	Tue, 25 Aug 2026 00:24:28 +0200 (CEST)
Date: Tue, 25 Aug 2026 00:24:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Zhiling Zou <zhilinz@nebusec.ai>
Subject: Re: [PATCH nf-next] netfilter: x_tables: reject missing '-p' flag
 and check for INV flag
Message-ID: <aozEmqr_sRZgJS9Z@chamomile>
References: <20260821134136.18191-1-fw@strlen.de>
 <aohabszy_Ac23p7x@chamomile>
 <aolaWzC1PI7zeYRN@strlen.de>
 <aoy8kFZkXMNOHUcR@chamomile>
 <aoy977yxzSEsViun@strlen.de>
 <aozDJO7EMyfuupGq@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aozDJO7EMyfuupGq@strlen.de>

On Tue, Aug 25, 2026 at 12:18:12AM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > > Userspace always provides a zeroed e->ipv6.proto when unused, correct?
> > 
> > Yes, ip6tables raises it when it parses '-p' option.
> > 
> > > If so, LGTM.
> > 
> > Alright, I will respin tomorrow, thanks.
> > 
> > Do you want me to include the TPROXY fix too?
> 
> Actually nft_compat.c already does:
> 
>  if (proto)
>    entry->e6.ipv6.flags |= IP6T_F_PROTO;

So it is only x_tables legacy that has this issue.

> so the only other necessary fix is the check for 'INV' in xt_l2tp.c.

Agreed.

Thanks!
