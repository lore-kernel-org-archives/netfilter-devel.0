Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7311BE849
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 19:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723663601; cv=none; b=HhJ2E9Gigmc0foraZtQ4HPhuxc+yzFt6YiMGqDZZdzvhojRIxlm547Tvj8FSfVQrOCCd5pcRKJiMm2pK+qVaDUWOOakjPrWpC2WzQKA5z7WLldU5wVVEUwrs1ng9Uj+IXAl6RpRvG347s1rqLldQsLiHmSAG8DrkgBDuL6uOXV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723663601; c=relaxed/simple;
	bh=GNZn93xwLbICkG4v7YCXOINzqau3fkONWjHByXTIJx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDAkRf+CjuUdeV1DE3GHHlJrzLC0GzfG3aWgCG14pUwVG5fPilMI7G+haz4MQ7frBHtobI+nSCK37iiQGxpffmWaLdgtBwAE/9ga+e4fFE623ULLzdwc9pf5m22QdNT+/qTZ4mSwmixrcoee8UC6BCTcOWNrnTxRPDD8BtYlTfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XWwRusFV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XWwRusFV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3aAtTODazpg0udZgU1qYTfwzCP3oQLlYzcNus9jS9kc=; b=XWwRusFVxim1dcyQ0uMP06HK4h
	gelDm7y/Kc8OLTWhBWy7CUtLMFL1BEnGSkYM8YVgr+Xfex0yvoXXiZtrloyhVccey0kshImnFKlkv
	pj/vkFOUL5vMSv2H+HKsRzyeDXHrAEX0eFFFGgJtRk9j1PNm9j6hp2hNf/54Cx/xZQW38Y+8g+Vtd
	kFE6mlSgz26ezhVZ0rZaBABZGcLHbnCLFME3trw/V5vXyAZIn+d/LTu7wb0c/dpbkvrwveBZ/M4Au
	z2Tj2kPcY6R+AVCvrd560oNKqJvRfcc+wOtZXtFLvUmYUHfzjqiNn86RsVXGSHa4urnfY5dVUYwQL
	xUBU3/yg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1seJdk-000000006Oi-3kAh;
	Wed, 14 Aug 2024 21:26:36 +0200
Date: Wed, 14 Aug 2024 21:26:36 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Message-ID: <Zr0E7BZu3fowGLBz@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240814115122.279041-1-pablo@netfilter.org>
 <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
 <ZrzWpcQehJBmss13@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrzWpcQehJBmss13@calendula>

On Wed, Aug 14, 2024 at 06:09:09PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 14, 2024 at 06:00:55PM +0200, Phil Sutter wrote:
> > On Wed, Aug 14, 2024 at 01:51:21PM +0200, Pablo Neira Ayuso wrote:
> > > Bail out if rate are used:
> > > 
> > >  ruleset.nft:5:77-106: Error: Wrong rate format, expecting bytes or kbytes or mbytes
> > >  add rule netdev firewall PROTECTED_IPS update @quota_temp_before { ip daddr quota over 45000 mbytes/second } add @quota_trigger { ip daddr }
> > >                                                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > 
> > > improve error reporting while at this.
> > > 
> > > Fixes: 6615676d825e ("src: add per-bytes limit")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > v2: - change patch subject
> > >     - use strndup() to fetch units in rate_parse() so limit rate does not break.
> > > 
> > >  src/datatype.c | 20 +++++++++++++-------
> > >  1 file changed, 13 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/src/datatype.c b/src/datatype.c
> > > index d398a9c8c618..297c5d0409d5 100644
> > > --- a/src/datatype.c
> > > +++ b/src/datatype.c
> > > @@ -1485,14 +1485,14 @@ static struct error_record *time_unit_parse(const struct location *loc,
> > >  struct error_record *data_unit_parse(const struct location *loc,
> > >  				     const char *str, uint64_t *rate)
> > >  {
> > > -	if (strncmp(str, "bytes", strlen("bytes")) == 0)
> > > +	if (strcmp(str, "bytes") == 0)
> > >  		*rate = 1ULL;
> > > -	else if (strncmp(str, "kbytes", strlen("kbytes")) == 0)
> > > +	else if (strcmp(str, "kbytes") == 0)
> > >  		*rate = 1024;
> > > -	else if (strncmp(str, "mbytes", strlen("mbytes")) == 0)
> > > +	else if (strcmp(str, "mbytes") == 0)
> > >  		*rate = 1024 * 1024;
> > >  	else
> > > -		return error(loc, "Wrong rate format");
> > > +		return error(loc, "Wrong unit format, expecting bytes, kbytes or mbytes");
> > >  
> > >  	return NULL;
> > >  }
> > 
> > I have local commits which introduce KBYTES and MBYTES keywords and
> > thereby kill the need for quota_unit and limit_bytes cases in
> > parser_bison.y. It still needs testing and is surely not solving all
> > issues there are, but I find it nicer than the partially redundant code
> > we have right now.
> 
> Is this allowing for compact representation? ie. kbytes/second,
> because I remember this was the issue to follow this poor man
> approach.

You're right, I just checked and noticed my changes actually make things
worse, because the parser falls into the string case more often than
not. I wish there was a way to exclude string tokens via start
conditions.

For testing, I just removed the '{string}' case from scanner.l and
updated 'identifier' in parser_bison.y to accept QUOTED_STRING as well.
With that in place, all these parse correctly:

| nft add rule \"t\" \"c\" limit rate 1 kbytes/second
| nft add rule \"t\" \"c\" limit rate 1 kbytes/ second
| nft add rule \"t\" \"c\" limit rate 1 kbytes / second
| nft add rule \"t\" \"c\" limit rate 1 kbytes /second
| nft add rule \"t\" \"c\" limit rate 1kbytes/second
| nft add rule \"t\" \"c\" limit rate 1kbytes /second
| nft add rule \"t\" \"c\" limit rate 1kbytes/ second

> > My motivation for this was to maybe improve parser's ability to handle
> > lack of spaces in input. I still see the scanner fall into the generic
> > "string" token case which requires manual dissection in the parser.
> > 
> > What is your motivation for the above changes?
> 
> A user that accidentally used:
> 
>         quota over 10mbytes/second
> 
> which is currently accepted, the /second part is misleading, as the
> commit described, this is now rejected after this patch.

I see. Similar, but distinct bug. :)

> > Maybe we could collect parser limitations around these units and see
> > what helps "the most"?
> 
> I am fine with handling this from the parser instead, there is now
> flex start conditions that can help to enable these tokens on demand.

Maybe one could introduce a start condition which allows strings, but
it might turn into a mess given the wide use of them. I'll give it a try
and let you know.

Thanks, Phil
