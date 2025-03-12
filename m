Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34B51EF099
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 23:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821594; cv=none; b=dGHZePsa3gUfeEbt5+e2ueWYc4+YU5mqKF+4zweC2rFDynmK7jtEsDv5d1Arv1iB6lUJLwvoyWvw2DNr2AgJBUSgYOXh7e1cwExVv9Z9CRjfURjOQ5XFQHLIykxz3bPtQmUO4j+yJjmXQGBK2sYryIwcz3Uq+uKzaMKDo7eXy5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821594; c=relaxed/simple;
	bh=ZVRRS7pvnl4zcOFzsZNgu64gefZJJ9AHuru218Ysz04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JM2xZppvhPjYSyW/6iOL/F4kOqY7OliVlMvswQssMxba8PY0M331/90sOZaYZGtUHuThncgo1X7jBY+yTCpgyepeVMZ+oX6L7FADauohNLOi4eq5Vo9C1aAmY0xwpbE8CqnN4jyIyKj1j7wxAR5D3jkw5Fv3kPAd4sK41TDKJOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HLTgg1EN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g01JnSOX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HLTgg1EN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g01JnSOX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1C5C1602AC; Thu, 13 Mar 2025 00:19:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821591;
	bh=66+CPdJy5JUWnR2JPKYZuClUhOGh5J3OtYfoPsFHAsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HLTgg1ENSwkE+FynyNO5SsRlPYTrBepqif5wontjQvxxIiCVzH+SlP1K4z5D7ejwF
	 AH8+4QjIEFtQCB/ely6oECs8zlpilXSWuOvasXdjDk4BydMzhWco4Jnl/dHzCwC96C
	 agBFaAQM/5EliTlO24dD9HrOc++YG87AaUwxoAcDQxoi5w4hQLm/R0A2ZuKy3pT0zt
	 D/LzrqvzU43O5Km6N4U+lpVFXr0nFypljjl1GFG9ruBYh5KEm02Ldn90FIFX2K+Ws+
	 rMqvPQPRV/nEi6BNjd3wwIKEH/VGuaeahlCC2J3GSmEJ1fUyhImFEsqKinJ79vMLnR
	 ux+V/mPyEBOEQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 86159602AA;
	Thu, 13 Mar 2025 00:19:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821590;
	bh=66+CPdJy5JUWnR2JPKYZuClUhOGh5J3OtYfoPsFHAsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g01JnSOXZzQ10yPUwVXUTGbY0ScWskCPS6JGzfcTPCCkg5znPtyxseDV1PJ1sSrMZ
	 t9QcHhJbau2xnC9UgZBGtesg3ocSOTNuVvEgYskjjuiHtw639vvxduh1oygotTZ9IV
	 nVp1IM2vXIFXgtktDto8+nmMdFiwefuWah2uSN/JkKPdMfVN4lVd6fSEcrNXjlsumA
	 QtjGSAvTJPEijNBU0TA0Fk8KREApyCQL8iTNhoTJQ186TknlKPVcvQpnKmYIBPlDrw
	 OHcgdYp0KjV3aioy0k9hO6/FvHAAbemEE8VurxJ7iLL9uf2ragEXQEw8s0fm8k/zYS
	 V6Sb08Ct3z1zw==
Date: Thu, 13 Mar 2025 00:19:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: fib: avoid lookup if socket is
 available
Message-ID: <Z9IWlD2TO8qRRySD@calendula>
References: <20250220130703.2043-1-fw@strlen.de>
 <Z9HdO_7XgQBbxcg1@calendula>
 <20250312213831.GB4233@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250312213831.GB4233@breakpoint.cc>

On Wed, Mar 12, 2025 at 10:38:31PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +	switch (nft_hook(pkt)) {
> > > +	case NF_INET_PRE_ROUTING:
> > > +	case NF_INET_INGRESS:
> > 
> > Not an issue in your patch itself, it seems nft_fib_validate() was
> > never updated to support NF_INET_INGRESS.
> 
> Yes, probably better to do that in a different patch.
> 
> > > +	if (nft_fib_can_skip(pkt)) {
> > > +		nft_fib_store_result(dest, priv, nft_in(pkt));
> > > +		return;
> > > +	}
> > 
> > Silly question: Does this optimization work for all cases?
> > NFTA_FIB_F_MARK and NFTA_FIB_F_DADDR.
> 
> Its the socket that the skb will be delivered to, so I don't see
> an issue.  Theoretically you could set a different mark in input,
> but what is it good for? Its too late to change routing result.

I see, makes no sense to trigger another lookup with the different
mark after the stack already provides a route (no use-case for this).

> As this sits in input hook, route lookup done by stack (not by fib
> expr) already picked nft_in as the 'right' interface for this daddr.

thanks for explaining.
