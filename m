Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F27D13E898
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 10:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724064438; cv=none; b=Barq/jJs1yebTmyp094haJXnefhPGMpwd0Tz69Ecnz6sg1iwKUfmr7U1fRtrr1QIlTEb9/RWtpSQGoluIy62JWagir1PaIPB5U0J9BPa/vOYoss6oEkLi/ndjwCE3VJT9nJl6TPCZ6GXc8QGUQHuC3YshyMkdml0p1hAqPuC52A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724064438; c=relaxed/simple;
	bh=v0tgHrZJ4h0O/weAPJmHJEHiZgQtv7O5m+YJ8zl/tD4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sywo4HvFxLu4e1//kiVAU+3F7fxtu+YINp8QNzNVm4wc8RMPRuV7QqOqXioozeis2eBDXw4IngZHitkR8SSgllqHNzgnx2yHqGGOGT8dJfTjs2+y0mTACqIGbEpfF1rIIxAl0lHmZ4QPaWi0EorwiKowZJ1fl52//KNGQ2UDoXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=38396 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sfzuh-005Cn6-4E; Mon, 19 Aug 2024 12:47:05 +0200
Date: Mon, 19 Aug 2024 12:47:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 1/2] datatype: reject rate in quota statement
Message-ID: <ZsMipjpB5QylZ3tH@calendula>
References: <20240814115122.279041-1-pablo@netfilter.org>
 <ZrzUt-8mZoqdY0ai@orbyte.nwl.cc>
 <ZrzWpcQehJBmss13@calendula>
 <Zr0E7BZu3fowGLBz@orbyte.nwl.cc>
 <Zr9FKFg8bnfQrqoZ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zr9FKFg8bnfQrqoZ@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Fri, Aug 16, 2024 at 02:25:12PM +0200, Phil Sutter wrote:
> On Wed, Aug 14, 2024 at 09:26:36PM +0200, Phil Sutter wrote:
> [...]
> > Maybe one could introduce a start condition which allows strings, but
> > it might turn into a mess given the wide use of them. I'll give it a try
> > and let you know.
> 
> Looks like I hit a dead end there: For expressions like 'iif', we have
> to accept STRING on RHS and since I need a token to push SC_STRING, I
> can't just enable it for all relational expressions. The alternative is
> to enable it for the whole rule but I can't disable it selectively (as I
> had to enable it again afterwards without knowing what's next. :(

flex rules also tells what to find first (order implies priority)
maybe a combination of start conditions to carefully placing. I can
take my poor man fix by now so this can be revisited later :)
