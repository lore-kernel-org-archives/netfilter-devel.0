Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499067DA7F
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730826477; cv=none; b=Y3CukRD/fLSm4MDYIt5TpStBj4raoEOAOtf2TuuJ08uQYnzd2ddFx1DCRS+s5zlekZvvWTRMOJ9KVSDSkI2wZ3X4DNsU7EDo1IM2wklvpnU9ucH9yn8uknRkHO1vvx+PcMs8p4Ti0gdRoQpsQthHxMvRsaZit1809iJbvKAhWNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730826477; c=relaxed/simple;
	bh=FKeSrYAmWlcu8mM/zQC6UNbk/zYtUlanm0Zpa0cCv7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pIHELEgjSuXxVj2Mm06LTO8LpN6Le869r//dPSGsCUPRbzRdVmjDDovT1Optzna1Pku9Ha0Xi7ip/yCWQAgr+bQxRbtrl11mEuZEk4QaEYXRLvHpiQPyuGBeqOTsxOjm9sDZq/hwFeCQjaJ3zHXBigDTViDDhlL8WAErXVy0EDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bePA04iX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bePA04iX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Aw6U6MTTTawmg1M5xLA+BbiSFK8GHAW1txbmBf2HSb0=; b=bePA04iXigaP6u6oqPQdzBoYf3
	JmRw1xflla38Kl+CnW8AciEGn22zi55GhdASfCpI8sSCYkfHHTZY7akEoJw3QyAIpuo5meheGWhJh
	eyOY21XffpArhVWIqJuMt5l6n4Vb7vHJUHJcL9NYekmf4RM/mTUY9YcQ71WbSDUnjS/gN4KEPusOu
	iWPiafGjo7qg+z2fDnIRMKdkoIRaJyg9XJKv4SxY/uADfiAwqIRiXEwuE03y162Lp26zsJHATR+5F
	b6BPB9SuTxalwAUNJPLhsA+2P0C4UXNJMOv/nq7HdcsdsPho6Lq33gzgaZoRRPvXXssg61+7kGGeK
	ixdb6c8g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8N1y-0000000080r-2u2C;
	Tue, 05 Nov 2024 18:07:50 +0100
Date: Tue, 5 Nov 2024 18:07:50 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, eric@garver.life
Subject: Re: [PATCH nft] json: collapse set element commands from parser
Message-ID: <ZypQ5iMZmoPdOzlX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, eric@garver.life
References: <20241031220411.165942-1-pablo@netfilter.org>
 <ZyofFLveeueZuJPH@orbyte.nwl.cc>
 <ZypNF7HzKrjl0w9s@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZypNF7HzKrjl0w9s@calendula>

On Tue, Nov 05, 2024 at 05:51:35PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Tue, Nov 05, 2024 at 02:35:16PM +0100, Phil Sutter wrote:
> > On Thu, Oct 31, 2024 at 11:04:11PM +0100, Pablo Neira Ayuso wrote:
> > > Update json parser to collapse {add,create} element commands to reduce
> > > memory consumption in the case of large sets defined by one element per
> > > command:
> > > 
> > > {"nftables": [{"add": {"element": {"family": "ip", "table": "x", "name":
> > > "y", "elem": [{"set": ["1.1.0.0"]}]}}},...]}
> > 
> > Thanks for the fix!
> > 
> > > Add CTX_F_COLLAPSED flag to report that command has been collapsed.
> > 
> > I had come up with a similar solution (but did not find time to submit
> > it last week). My solution to the "what to return" problem was to
> > introduce a 'static struct cmd cmd_nop' and return its address. Your
> > flag way is fine, too from my PoV.
> 
> OK, I'm going to push it out then.
> 
> > > This patch reduces memory consumption by ~32% this case.
> > > 
> > > Fixes: 20f1c60ac8c8 ("src: collapse set element commands from parser")
> > > Reported-by: Eric Garver <eric@garver.life>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > Side note: While profiling, I can still see lots json objects, this
> > > results in memory consumption that is 5 times than native
> > > representation. Error reporting is also lagging behind, it should be
> > > possible to add a json_t pointer to struct location to relate
> > > expressions and json objects.
> > 
> > I can have a look at mem use if I find spare time (TM).
> 
> I understand, that is always the issue.

It's on my TODO at least, let's hope for the best.

> > We already record links between struct cmd and json_t objects for echo
> > mode (and only then). The problem with error reporting in my opinion is
> > the lack of location data in json_t. You might remember, I tried to
> > extend libjansson to our needs but my MR[1] is being ignored for more
> > than a year now. Should we just ship an extended copy in nftables?
> 
> Do you still have the link with your proposal around? I don't find it
> in my notes anymore.

Ah, prolly forgot to resolve that [1] above:

https://github.com/akheron/jansson/pull/662

> IIRC the rejection came from concerns about increasing memory usage
> for our specific usecase, that was an extra pointer to store location,
> correct?

That and lack of interest in the feature in general. See the linked !461
for some feedback. The uncommented implementation in !662 hides
everything behind a decoder flag and avoids any memory overhead if not
enabled. The only remaining concern I can't address is: "we don't see
this as an important feature that should be included in Jansson."

Cheers, Phil
