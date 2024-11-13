Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB311C8776
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Nov 2024 11:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731496089; cv=none; b=K4zWi0vGlrc4ytjygj3feGkfPKiHjP5kXHeOQUeNv74M8rhuEwV3C6kpvmWI4Lrr3k9bCQuloCTi42bfNQ7ayq2/hFWbJFtUz51hE9V2udxN1idR+l+afAqnTfzHvthI0oDE0ay8GMuIugXoF4az0pbuyKafKlG3sk1l0On1GHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731496089; c=relaxed/simple;
	bh=dVDRss0M5+mC0hg7Yiq1QjuP9YqF9Ap9TG61zbjakAc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BL71ZzYB0Hp5EW7wp8ufO5UW09fY9LBLMEQV2wkGH7nY8JRPfXwbtq23Ku82yioYlXQrcWJu21IeJKZCLIMwXaBCclvu8XBN7OXG6Mugl0Ha57eqevLWW1oWLgi6q2p3dCGRYIywbo2LtfuOvND3pHRT5EnKMVc1reyFbXcFVok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60088 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBBEA-00Dr1P-KT; Wed, 13 Nov 2024 12:08:05 +0100
Date: Wed, 13 Nov 2024 12:08:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	eric@garver.life
Subject: improving json error reporting [was Re: [PATCH nft] json: collapse
 set element commands from parser]
Message-ID: <ZzSIkcAuGeX_HoGp@calendula>
References: <20241031220411.165942-1-pablo@netfilter.org>
 <ZyofFLveeueZuJPH@orbyte.nwl.cc>
 <ZypNF7HzKrjl0w9s@calendula>
 <ZypQ5iMZmoPdOzlX@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZypQ5iMZmoPdOzlX@orbyte.nwl.cc>
X-Spam-Score: -1.7 (-)

Hi Phil,

On Tue, Nov 05, 2024 at 06:07:50PM +0100, Phil Sutter wrote:
> On Tue, Nov 05, 2024 at 05:51:35PM +0100, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Tue, Nov 05, 2024 at 02:35:16PM +0100, Phil Sutter wrote:
> > > On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> > > > Update json parser to collapse {add,create} element commands to reduce
> > > > memory consumption in the case of large sets defined by one element per
> > > > command:
> > > > 
> > > > {"nftables": [{"add": {"element": {"family": "ip", "table": "x", "name":
> > > > "y", "elem": [{"set": ["1.1.0.0"]}]}}},...]}
> > > 
> > > Thanks for the fix!
> > > 
> > > > Add CTX_F_COLLAPSED flag to report that command has been collapsed.
> > > 
> > > I had come up with a similar solution (but did not find time to submit
> > > it last week). My solution to the "what to return" problem was to
> > > introduce a 'static struct cmd cmd_nop' and return its address. Your
> > > flag way is fine, too from my PoV.
> > 
> > OK, I'm going to push it out then.
> > 
> > > > This patch reduces memory consumption by ~32% this case.
> > > > 
> > > > Fixes: 20f1c60ac8c8 ("src: collapse set element commands from parser")
> > > > Reported-by: Eric Garver <eric@garver.life>
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > > Side note: While profiling, I can still see lots json objects, this
> > > > results in memory consumption that is 5 times than native
> > > > representation. Error reporting is also lagging behind, it should be
> > > > possible to add a json_t pointer to struct location to relate
> > > > expressions and json objects.
> > > 
> > > I can have a look at mem use if I find spare time (TM).
> > 
> > I understand, that is always the issue.
> 
> It's on my TODO at least, let's hope for the best.

Thanks, we are already discussing this in a different thread.

> > > We already record links between struct cmd and json_t objects for echo
> > > mode (and only then). The problem with error reporting in my opinion is
> > > the lack of location data in json_t. You might remember, I tried to
> > > extend libjansson to our needs but my MR[1] is being ignored for more
> > > than a year now. Should we just ship an extended copy in nftables?
> > 
> > Do you still have the link with your proposal around? I don't find it
> > in my notes anymore.
> 
> Ah, prolly forgot to resolve that [1] above:
> 
> https://github.com/akheron/jansson/pull/662
> 
> > IIRC the rejection came from concerns about increasing memory usage
> > for our specific usecase, that was an extra pointer to store location,
> > correct?
> 
> That and lack of interest in the feature in general. See the linked !461
> for some feedback. The uncommented implementation in !662 hides
> everything behind a decoder flag and avoids any memory overhead if not
> enabled. The only remaining concern I can't address is: "we don't see
> this as an important feature that should be included in Jansson."

Your changeset for jansson look relative small, coding style look also
correct, and you have addressed the memory consumption issue.

It is a pity, I wonder what people do when json in this case? They
have to scavenge in the json soup to find for non-syntactic errors as
we have to do with it?

Having said this, I like jansson implementation, it is neat.

Caching a copy of libjansson in the nftables tree does not look like a
way to go IMO.

Is there a chance to poke them again / refresh your pull request?

Otherwise, we will have to search for alternative path to improve the
existing situation.

Thanks!
