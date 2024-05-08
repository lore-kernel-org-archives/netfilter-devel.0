Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA878C72
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715177401; cv=none; b=gYGcIYaawZeFf0Q5u3p6ikaG7guCLEZRO21AmsCbsjLjx1lGTZqUBaeGG9vI412iSNiDrKH9rDbiZFxaWi5lR55tfLRsNQNPfK6oSx7pzkPxVw9HZWkAleOWvmytB7aMICaSGYoNufMy25JXblN8b5RC4ufxfr4EIEytnV5Tey0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715177401; c=relaxed/simple;
	bh=YehuPTqC3xiIOpvCO+QgYtsxPrdg+difXTiSrlsoo1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhEBHXaJiD3oPKkSOyTTfgl/Kn8Q3F7/V2BrwbPvxnt0VJWgcZj2smOLkWzys4JxUexM65C9jElLD3V1ppdmI0ZtTS0BpOMaG7EL66O/lfByRNIed8J3Up0dxGGUFmNAeFmSkdwO+fPe+Vdz0RIch+AnfBN24uW/FUc4h6pIldY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s4hzZ-00058R-Tx; Wed, 08 May 2024 16:09:57 +0200
Date: Wed, 8 May 2024 16:09:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
Message-ID: <20240508140957.GC28190@breakpoint.cc>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
 <20240508121526.GA28190@breakpoint.cc>
 <bogi4anaqeh5o7haif57udzf5k3bj73rcsqfpqpna4426y7cyo@lfsyzkb4m2xi>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bogi4anaqeh5o7haif57udzf5k3bj73rcsqfpqpna4426y7cyo@lfsyzkb4m2xi>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> On Wed, May 08, 2024 at 02:15:26PM +0200, Florian Westphal wrote:
> > Sven Auhagen <sven.auhagen@voleatech.de> wrote:
> > > I am using nftables with geoip sets.
> > > When I have larger sets in my ruleset and I want to atomically update the entire ruleset, I start with
> > > destroy table inet filter and then continue with my new ruleset.
> > > 
> > > When the sets are larger I now always get an error:
> > > ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
> > > destroy table inet filter
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > > along with the kernel message
> > > percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
> > 
> > Are you using 'counter' extension on the set definition?
> 
> Yes I do and I just tested it, when I remove the counter it works without issues.
> 
> > 
> > Could yo usahre a minimal reproducer? You can omit the actual
> > elements, its easy to autogen that.
> 
> I just saw your patch, do you still want me to send a reproducer?

In that case I guess the patch will help as the pcpu area
should grow.

But I think it might still make sense, could probably extend on of
the test cases we have with a huge-set+counter+flush op.
