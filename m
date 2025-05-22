Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B80944F
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747934253; cv=none; b=OH/3ImOkHrwnPrjJgiu071CF7Kb1aBKNdlhBBRnY7LuzcbWZCUAVPq34/8tBNsC61/RnLfusiYW5P9++WYjkqGX/FXf32MnWLeSAX+MJi7cpy+tpGRRs15PADyaA7hLjwh67WzphUXSckb3DAMpxLb1aZWwFdF0Z6qpGR1ZHbVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747934253; c=relaxed/simple;
	bh=CmMX4/iN2l8NTHASVyrHmfZ7+hBM2PQYCBQCaSvYNZg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGCw8pS9DpxRlFnF/S7OYdZIXTFYygC4Z3bqFlXmTPORdqniiGz7eZoR1hTcd3hsCC8AE1mk0nQjSDsqLlViK3justv9LViB9pKf1FMPwNaLrTTDToHBHzMg+VcvEFmN0X9J/rIhwgMVKbCLTm+mkTpnH7a/uNa+XHewg6AcLvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZBDjHnLe; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZBDjHnLe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZBDjHnLe";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZBDjHnLe"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CAA2D6028C; Thu, 22 May 2025 19:17:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747934250;
	bh=5IPV+a4U0ZPAbxfAWmfnRLtnSECcNaPTSEwmLBtxfJ4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ZBDjHnLev3pufcMzPqqbgfxVzU95FK47yu1XpoEeWRwuE+9n+/w30IVYO0KmjtZtG
	 qSiO9d6YrubhD98DNLDmo/BFa4hvcoPy48nUo5fikb7bdzSL3OGgwPawEFYfOi9UwV
	 7RXUWpNHCZnjeec0oo09ZIs89ngooyitQvvOS9H3ENtmxIWhgoCAt3aJo03Xxyo99a
	 F/jtiKwjCoauuqywP8+aZVVsi3kzm6lFIX7VHPLFh9snu4bMZ9QCedWAFHnVtz8GMG
	 /npWYU0uIEvpPyYp+XPV2U8Bvibm+1N1toDTjGA2Md7V7RCCyBPsjGJwHWCh/fhNdG
	 G6m59Ijpu9G0A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DD7146026C;
	Thu, 22 May 2025 19:17:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747934250;
	bh=5IPV+a4U0ZPAbxfAWmfnRLtnSECcNaPTSEwmLBtxfJ4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ZBDjHnLev3pufcMzPqqbgfxVzU95FK47yu1XpoEeWRwuE+9n+/w30IVYO0KmjtZtG
	 qSiO9d6YrubhD98DNLDmo/BFa4hvcoPy48nUo5fikb7bdzSL3OGgwPawEFYfOi9UwV
	 7RXUWpNHCZnjeec0oo09ZIs89ngooyitQvvOS9H3ENtmxIWhgoCAt3aJo03Xxyo99a
	 F/jtiKwjCoauuqywP8+aZVVsi3kzm6lFIX7VHPLFh9snu4bMZ9QCedWAFHnVtz8GMG
	 /npWYU0uIEvpPyYp+XPV2U8Bvibm+1N1toDTjGA2Md7V7RCCyBPsjGJwHWCh/fhNdG
	 G6m59Ijpu9G0A==
Date: Thu, 22 May 2025 19:17:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] netlink: Keep going after set element parsing
 failures
Message-ID: <aC9cJy6WS22dC18b@calendula>
References: <20250521131242.2330-1-phil@nwl.cc>
 <20250521131242.2330-4-phil@nwl.cc>
 <aC3gjbdJ_z8gewqd@calendula>
 <aC4LF_xAVp9WIMLe@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC4LF_xAVp9WIMLe@orbyte.nwl.cc>

On Wed, May 21, 2025 at 07:19:19PM +0200, Phil Sutter wrote:
> On Wed, May 21, 2025 at 04:17:49PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, May 21, 2025 at 03:12:41PM +0200, Phil Sutter wrote:
> > > Print an error message and try to deserialize the remaining elements
> > > instead of calling BUG().
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  src/netlink.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/src/netlink.c b/src/netlink.c
> > > index 1222919458bae..3221d9f8ffc93 100644
> > > --- a/src/netlink.c
> > > +++ b/src/netlink.c
> > > @@ -1475,7 +1475,9 @@ int netlink_delinearize_setelem(struct netlink_ctx *ctx,
> > >  		key->byteorder = set->key->byteorder;
> > >  		key->len = set->key->len;
> > >  	} else {
> > > -		BUG("Unexpected set element with no key\n");
> > > +		netlink_io_error(ctx, NULL,
> > > +			         "Unexpected set element with no key\n");
> > > +		return 0;
> > 
> > If set element has no key, then something is very wrong. There is
> > already one exception that is the catch-all element (which has no
> > key).
> 
> Yes, in these cases the ruleset parser fails and the output is very
> likely broken or at least incomplete. This series merely aligns error
> handling: Take netlink_parse_cmp() for instance: If NFTNL_EXPR_CMP_SREG
> attribute is missing or bogus, netlink_error() is called and the
> function returns (void). No error status propagation happens (which we
> could change easily), but most importantly the parser continues to
> deserialize as much as possible.
> 
> > This is enqueuing an error record, but 0 is returned, I am not sure if
> > this is ever going to be printed.
> 
> It does: Forcing the code to enter that third branch, listing a set with three
> elements looks like this:
> 
> % sudo ./src/nft list ruleset
> table ip t {
> 	set s {
> 		type inet_service
> 	}
> }
> netlink: Error: Unexpected set element with no key
> 
> netlink: Error: Unexpected set element with no key
> 
> netlink: Error: Unexpected set element with no key
> 
> > I am not sure this patch works.
> 
> Well, that extra newline is indeed a bug. :)

Go ahead push it out then.
