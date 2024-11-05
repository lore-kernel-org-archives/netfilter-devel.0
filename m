Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A897717C7CE
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 16:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730825504; cv=none; b=uI+ZSOPNa9XLELGdeOFCt7/ZGnWbiovet1x/NBxilnaqkzEXp3OMXD9O1fhyKZ93JzekiwNZ3Mpv9Fr4oI1VzZsR5mdynLIpo/tlbOqBUzV9mGsCWUkJ6ORcYTamYuvAt1+sEwLMLFbq5RgryFyHT0gmXbgLfQ+uZj5U7J3PyZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730825504; c=relaxed/simple;
	bh=xZc794cAOIMv+e5pl+6wXqpYtv+lC5rt24ydLxS0OJo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0bgK6eEmfShIMyic6Ykb413mxjuJZi6KYkbr7crVuz88b21C3XImYYkJx51fQ8UiaytdNAv2ltNV6HO3kNorx1XqpA5CtpNcQLEYTPyVuap3fXg9yRea9FikdaxU3vpmocjDImKeTsS+nCNFw+6ztQJ+ReAmKP03qsrInps3wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=55372 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8MmG-005WgC-Se; Tue, 05 Nov 2024 17:51:40 +0100
Date: Tue, 5 Nov 2024 17:51:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	eric@garver.life
Subject: Re: [PATCH nft] json: collapse set element commands from parser
Message-ID: <ZypNF7HzKrjl0w9s@calendula>
References: <20241031220411.165942-1-pablo@netfilter.org>
 <ZyofFLveeueZuJPH@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyofFLveeueZuJPH@orbyte.nwl.cc>
X-Spam-Score: -1.7 (-)

Hi Phil,

On Tue, Nov 05, 2024 at 02:35:16PM +0100, Phil Sutter wrote:
> On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> > Update json parser to collapse {add,create} element commands to reduce
> > memory consumption in the case of large sets defined by one element per
> > command:
> > 
> > {"nftables": [{"add": {"element": {"family": "ip", "table": "x", "name":
> > "y", "elem": [{"set": ["1.1.0.0"]}]}}},...]}
> 
> Thanks for the fix!
> 
> > Add CTX_F_COLLAPSED flag to report that command has been collapsed.
> 
> I had come up with a similar solution (but did not find time to submit
> it last week). My solution to the "what to return" problem was to
> introduce a 'static struct cmd cmd_nop' and return its address. Your
> flag way is fine, too from my PoV.

OK, I'm going to push it out then.

> > This patch reduces memory consumption by ~32% this case.
> > 
> > Fixes: 20f1c60ac8c8 ("src: collapse set element commands from parser")
> > Reported-by: Eric Garver <eric@garver.life>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > Side note: While profiling, I can still see lots json objects, this
> > results in memory consumption that is 5 times than native
> > representation. Error reporting is also lagging behind, it should be
> > possible to add a json_t pointer to struct location to relate
> > expressions and json objects.
> 
> I can have a look at mem use if I find spare time (TM).

I understand, that is always the issue.

> We already record links between struct cmd and json_t objects for echo
> mode (and only then). The problem with error reporting in my opinion is
> the lack of location data in json_t. You might remember, I tried to
> extend libjansson to our needs but my MR[1] is being ignored for more
> than a year now. Should we just ship an extended copy in nftables?

Do you still have the link with your proposal around? I don't find it
in my notes anymore.

IIRC the rejection came from concerns about increasing memory usage
for our specific usecase, that was an extra pointer to store location,
correct?

Thanks.
