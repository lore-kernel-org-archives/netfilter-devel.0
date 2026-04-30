Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6C91C695
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 06:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530742; cv=none; b=kgWvVCXed7Yd3HI5h8oNW4WJEg1DQ/0465/P3RGDnTnW0z07w/IM5GmHrn9hIRkSMnEEL757OLf2nPF9W9dykvAbe27W95JPXzI5PJl3erF66je3F6OAeHxULIBzmhnyVyJQCN4m9E7K6G+IUipH0r2z3WB4tqbEaQB81yGfaEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530742; c=relaxed/simple;
	bh=2QSiDgJGtbwy7LUElonYUWlC2yFKlHflcEfUnpk5YEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4h1O2Yast/WFnHzRbhi4xn0/JdI3rnUbNMGzbtzO3vWQZfIggW7p2qMyDuaE4KoXU6bBqfNP5kWYfy3b9mW/MSeW3iQrMyqLKsYQMYe0aaRVZSrz8Q5a58dRSVWnrtefmjsTWX1eZ4l4Ul4egyqqU7OUJQs5S6ap4Z12XBOUjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=s8e08tyf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="s8e08tyf"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AD53F6017D;
	Thu, 30 Apr 2026 08:32:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777530739;
	bh=cE014h18+6rATJCPfwqcERIO0Ct8AEl+uiqKmtQU9hE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s8e08tyfbKmh0cce84TsLnVCdW6waK+BfVZNs5Yrgem6VwmAMyfd2SQt6oYJ6Agwe
	 AtpwdkQ1pIep9NH0a7gZhSEWuBms2W447hqDeaC0Wbv/K9ui/kkaREM9ARww9AUmrr
	 LZAZPsptdngBUBRHGU0FZXbzv+t5utfmgilhMdEFaYXy+2btvVnQe0JGobaLukeqyK
	 WmoxDdZWMbvXA/lljIfrWQhnNwK++aHZy3jXaV/fA3SdSch0l79gYhnT3ox0O4E7qJ
	 6mHG/GKldhR8c8fhBIsI2Gg3T+3pMjQJS28uPhYNuffdkW3VEtvV+KEDY2ATcFVrvA
	 vEK5yBR7egSRg==
Date: Thu, 30 Apr 2026 08:32:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH nf v4] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <afL3cRQkTtol_Ckf@chamomile>
References: <20260427092117.4160-2-fmancera@suse.de>
 <afLye0knzKl5IdrY@chamomile>
 <afL2FYLNtqESyEPh@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <afL2FYLNtqESyEPh@chamomile>

On Thu, Apr 30, 2026 at 08:26:32AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2026 at 08:11:07AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Apr 27, 2026 at 11:21:18AM +0200, Fernando Fernandez Mancera wrote:
> > > For lshift and rshift, the shift operations are performed in a loop over
> > > 32-bit words. The loop calculates the shifted value and write it to dst,
> > > and then immediately reads from src to calculate the carry for the next
> > > iteration. Because src and dst could point to the same memory location,
> > > the carry is incorrectly calculated using the newly modified dst value
> > > instead of the original src value.
> > > 
> > > Adding a temporary local variable to cache the original value before
> > > writing to dst and using it for the carry calculation solves the
> > > problem. In addition, partial overlap is rejected from control plane for
> > > all kind of operations. This was tested with the following bytecode:
> > > 
> > > table test_table ip flags 0 use 1 handle 1
> > > ip test_table test_chain use 3 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
> > > ip test_table test_chain 2
> > >   [ immediate reg 1 0x44332211 0x88776655 ]
> > >   [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
> > >   [ cmp eq reg 1 0x66443322 0x00887766 ]
> > >   [ counter pkts 0 bytes 0 ]
> > > ip test_table test_chain 4 3
> > >   [ immediate reg 1 0x44332211 0x88776655 ]
> > >   [ bitwise reg 1 = ( reg 1 << 0x08000000 ) ]
> > >   [ cmp eq reg 1 0x55443322 0x00887766 ]
> > >   [ counter pkts 21794 bytes 1917798 ]
> > > 
> > > Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
> > > Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > > ---
> > > v2: handled partially register overlap
> > > v3: reject partially overlap from control plane
> > > v4: applied the partial overlap check to all operations
> > > ---
> > >  net/netfilter/nft_bitwise.c | 19 +++++++++++++++----
> > >  1 file changed, 15 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> > > index 13808e9cd999..76e7ae96429d 100644
> > > --- a/net/netfilter/nft_bitwise.c
> > > +++ b/net/netfilter/nft_bitwise.c
> [...]
> > > @@ -264,6 +269,12 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
> > >  	if (err < 0)
> > >  		return err;
> > >  
> > > +	n = DIV_ROUND_UP(priv->len, sizeof(u32));
> > > +	if (priv->sreg != priv->dreg &&
> > > +	    priv->dreg < priv->sreg + n &&
> > > +	    priv->sreg < priv->dreg + n)
> > > +		return -EINVAL;
> > 
> > In some cases, there is also sreg2 that probably needs to be handled
> > too.
> 
> And probably nft_byteorder needs something similar to check for
> partial overlaps too for sreg and dreg. Also nft_lookup.

I think it is only nft_byteorder needs this since iteration pattern is
similar.

> Maybe add this to a helper function and use it from there?
