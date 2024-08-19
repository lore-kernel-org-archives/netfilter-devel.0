Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E9E13698F
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 15:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724083070; cv=none; b=EaAtdpURf1tx36OfY4HNvmZE4+hIElxeD/tP5vqAtlctksIxKpbs6bpxLTuYkxGyjwk47JLil5IBb3HeWNLIzJTo2kf+R+QMJAJCWK71/jwRr7Dq7AOA1ALftrkacqK2RZUJm9EvCVGtWBl1t/+7khWCBtc7EQSi5AmnUHk/4hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724083070; c=relaxed/simple;
	bh=WGfVENe1oB8JxBdSvzx1IUe3enJLdDai2w2tirJmYb0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asSRIzAaL7V4lga15jNS58uPs0cMBJRN7nQgiHdquHO0treW3OXnAvWzYCuTilm0xyHg8VFhR5IhVIEXfCf1V9Hs6hpIO9P4JoX9TW//KKRLbRvaoPkjKos8D2P7q6iV/2Cmz8SmJD5PDg+L3KvafJoAP3LsL0HAEP0hw0OzLTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53736 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg4lL-005WwM-6a; Mon, 19 Aug 2024 17:57:45 +0200
Date: Mon, 19 Aug 2024 17:57:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Message-ID: <ZsNrdnt-BQqVVWA4@calendula>
References: <20240814115122.279041-1-pablo@netfilter.org>
 <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
 <ZrzWpcQehJBmss13@calendula>
 <Zr0E7BZu3fowGLBz@orbyte.nwl.cc>
 <Zr9FKFg8bnfQrqoZ@orbyte.nwl.cc>
 <ZsMipjpB5QylZ3tH@calendula>
 <ZsNiX0mRqHDCgm95@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZsNiX0mRqHDCgm95@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Mon, Aug 19, 2024 at 05:18:55PM +0200, Phil Sutter wrote:
> On Mon, Aug 19, 2024 at 12:47:02PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Fri, Aug 16, 2024 at 02:25:12PM +0200, Phil Sutter wrote:
> > > On Wed, Aug 14, 2024 at 09:26:36PM +0200, Phil Sutter wrote:
> > > [...]
> > > > Maybe one could introduce a start condition which allows strings, but
> > > > it might turn into a mess given the wide use of them. I'll give it a try
> > > > and let you know.
> > > 
> > > Looks like I hit a dead end there: For expressions like 'iif', we have
> > > to accept STRING on RHS and since I need a token to push SC_STRING, I
> > > can't just enable it for all relational expressions. The alternative is
> > > to enable it for the whole rule but I can't disable it selectively (as I
> > > had to enable it again afterwards without knowing what's next. :(
> > 
> > flex rules also tells what to find first (order implies priority)
> > maybe a combination of start conditions to carefully placing. I can
> > take my poor man fix by now so this can be revisited later :)
> 
> I have a working draft using an exclusive start condition (Florian
> pointed me to that). It passes the testsuite, might need more work
> though (the first token after the limit statement is still parsed in the
> exclusive condition, so all statement openers must potentially be valid
> in all conditions.
> 
> Anyway, it's not a simple fix from my side so please go ahead and we'll
> discuss my patches later as the "academic project" they are.

ok, pushed it out, thanks
