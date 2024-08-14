Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0251AED24
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723651758; cv=none; b=pGohntWc6HZ1mriIz7lKVVYVRxaJ3g54lKRqte83zK63zMlfVUSji8OzRIC7Kyz8mj5xOAfDvyu9VhUBfwRy+z/d6FC2jnuMIO71nFpXsi36d4vuFc8QcoBtAJtLuM6AvPcNZZrNTbPjZMBV5vXanBQ27oNO3IYpCBYorMLgTCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723651758; c=relaxed/simple;
	bh=D8KyhMDnVkun7HNcxkaJPpMzK4KSIiSR5mYzjYawx9c=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqlRyQWgQ65eSn8Byb45sk3UAQyYPYpj+uzFUFDGW6vUaviXp393FXU4k+W5D5w+KowE7ijopTMfXgSUdP03Tyz+z6wnnOARm3D8tpTjZSe/759/dBFr4YHRyQ/QmxwswdbHgUdxlHMO1WikLRwSAsBKu/0o/ynpir4cd8Dg6V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43544 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seGYg-00FpJ6-CE; Wed, 14 Aug 2024 18:09:12 +0200
Date: Wed, 14 Aug 2024 18:09:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Message-ID: <ZrzWpcQehJBmss13@calendula>
References: <20240814115122.279041-1-pablo@netfilter.org>
 <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Aug 14, 2024 at 06:00:55PM +0200, Phil Sutter wrote:
> On Wed, Aug 14, 2024 at 01:51:21PM +0200, Pablo Neira Ayuso wrote:
> > Bail out if rate are used:
> > 
> >  ruleset.nft:5:77-106: Error: Wrong rate format, expecting bytes or kbytes or mbytes
> >  add rule netdev firewall PROTECTED_IPS update @quota_temp_before { ip daddr quota over 45000 mbytes/second } add @quota_trigger { ip daddr }
> >                                                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > improve error reporting while at this.
> > 
> > Fixes: 6615676d825e ("src: add per-bytes limit")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: - change patch subject
> >     - use strndup() to fetch units in rate_parse() so limit rate does not break.
> > 
> >  src/datatype.c | 20 +++++++++++++-------
> >  1 file changed, 13 insertions(+), 7 deletions(-)
> > 
> > diff --git a/src/datatype.c b/src/datatype.c
> > index d398a9c8c618..297c5d0409d5 100644
> > --- a/src/datatype.c
> > +++ b/src/datatype.c
> > @@ -1485,14 +1485,14 @@ static struct error_record *time_unit_parse(const struct location *loc,
> >  struct error_record *data_unit_parse(const struct location *loc,
> >  				     const char *str, uint64_t *rate)
> >  {
> > -	if (strncmp(str, "bytes", strlen("bytes")) == 0)
> > +	if (strcmp(str, "bytes") == 0)
> >  		*rate = 1ULL;
> > -	else if (strncmp(str, "kbytes", strlen("kbytes")) == 0)
> > +	else if (strcmp(str, "kbytes") == 0)
> >  		*rate = 1024;
> > -	else if (strncmp(str, "mbytes", strlen("mbytes")) == 0)
> > +	else if (strcmp(str, "mbytes") == 0)
> >  		*rate = 1024 * 1024;
> >  	else
> > -		return error(loc, "Wrong rate format");
> > +		return error(loc, "Wrong unit format, expecting bytes, kbytes or mbytes");
> >  
> >  	return NULL;
> >  }
> 
> I have local commits which introduce KBYTES and MBYTES keywords and
> thereby kill the need for quota_unit and limit_bytes cases in
> parser_bison.y. It still needs testing and is surely not solving all
> issues there are, but I find it nicer than the partially redundant code
> we have right now.

Is this allowing for compact representation? ie. kbytes/second,
because I remember this was the issue to follow this poor man
approach.

> My motivation for this was to maybe improve parser's ability to handle
> lack of spaces in input. I still see the scanner fall into the generic
> "string" token case which requires manual dissection in the parser.
> 
> What is your motivation for the above changes?

A user that accidentally used:

        quota over 10mbytes/second

which is currently accepted, the /second part is misleading, as the
commit described, this is now rejected after this patch.

> Maybe we could collect parser limitations around these units and see
> what helps "the most"?

I am fine with handling this from the parser instead, there is now
flex start conditions that can help to enable these tokens on demand.
