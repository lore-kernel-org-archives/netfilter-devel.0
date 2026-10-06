Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F8F4EB866
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 23:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791329393; cv=none; b=RcneeWPflBLcCjErm+WM44BeXin24zn/7qG5hdswOwRXUMNMwOzWeQpyplEFbV6ScYiRo2NKGkdtoReHAVv6c2uXf2vro7OapWnombX5Ghl5HJgoFzMmbuVv98bxkwwXNrehx6pkknFmcNxcSHtdDBXBMwWFoDYHj+CkvsdVSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791329393; c=relaxed/simple;
	bh=ocn2LG+3XqWHAzzxWhIw1Vu+5Kvlr0F7F8bwgplAFng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbA8YteoKmPpfTgjFS9OhESAsCO/lUKy0hCoGa2lfHkqam/0VwntIxEk52ju1n7xazpWbYcTA/okT+499+JDgUOhT5c9IAI54SYFwv9sVCGn8vb4SSBiHf4ftf465JmPUN0VV+kaxbNC5pb1zsBg7YP6yt0xw091W5ApQB77TKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=R56yklVy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="R56yklVy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791329374;
	bh=wN22jH42qzsOB2M3zzyFxVAGe5YcVbsbfEaORf5jlqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R56yklVy3XK+HwPY/8XljDW2YGgilfgFVpQvBFgIRM9wOHi9U4NeKzqPjPWU0O9+o
	 jiMrQQYbp4Uncci++rYEL1j89ROJugFb4jmP//MiEXjqxOqLalkjMLxiScSdj4KWos
	 hRLcN3JethX0UThYlHQ6g3rzWsh1R5eaPYNpbdlXugcePbAO+IJkC1nODXSZRaQVds
	 mBXyTcW9VEXp5AL1iDq/aTkkBLS4gcZSHNg5THLZtVXzIIBBWuXj3Z2twXyFIz6X0p
	 JQlsGrcn2gPDUuBGwLCmXaQewDI5HGbJiTT4/LAntqf+UJ+dQ3mkOYVtSG1dFoELbn
	 thX/bka5Osp2g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D95CA60090;
	Wed,  7 Oct 2026 01:29:33 +0200 (CEST)
Date: Wed, 7 Oct 2026 01:29:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <asWEWpVJLk0so8zM@chamomile>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
 <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
 <aruMPHNdZq7U9eV9@chamomile>
 <4da35a94-af13-47de-adef-35b5671100b7@kernel.org>
 <arupFwGHewREJJ74@chamomile>
 <6365150c-09d0-4a2c-84e3-ffe6e292e317@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6365150c-09d0-4a2c-84e3-ffe6e292e317@kernel.org>

Hi Matthieu,

On Wed, Sep 30, 2026 at 08:33:36PM +0200, Matthieu Baerts wrote:
> Hi Pablo,
> 
> Thank you for your reply!
> 
> On 29/09/2026 14:03, Pablo Neira Ayuso wrote:
> > On Tue, Sep 29, 2026 at 12:40:47PM +0200, Matthieu Baerts wrote:
> >> On 29/09/2026 12:00, Pablo Neira Ayuso wrote:
> >>> On Tue, Sep 29, 2026 at 11:21:15AM +0200, Matthieu Baerts wrote:
> >>>> Hi Pablo,
> >>>>
> >>>> Thank you for your reply!
> >>>>
> >>>> On 28/09/2026 23:52, Pablo Neira Ayuso wrote:
> >>>>> Hi Mattieu,
> >>>>>
> >>>>> On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
> >>>>>> Hello Netfilter devs,
> >>>>>>
> >>>>>> First, thank you for maintaining Netfilter in the kernel and the
> >>>>>> userspace tools.
> >>>>>>
> >>>>>> The MPTCP selftests are switching from IPTables to NFTables, and
> >>>>>> Clashiko reported that this part of a rule wouldn't match anything:
> >>>>>>
> >>>>>>   tcp option mptcp subtype remove-addr drop
> >>>>>>
> >>>>>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> >>>>>> added to the TCP options, it is added after an MPTCP DSS option (type
> >>>>>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> >>>>>> (type 30) options in the TCP options. It looks like Netfilter doesn't
> >>>>>> handle that, because it stops processing other TCP options when the
> >>>>>> expected type is found:
> >>>>>>
> >>>>>> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
> >>>>>>     ...
> >>>>>> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
> >>>>>> 		optl = optlen(opt, i);
> >>>>>>
> >>>>>> 		if (priv->type != opt[i])
> >>>>>> 			continue;
> >>>>>> 		...
> >>>>>> 		return;  // <== it will look at the first MPTCP option
> >>>>>> 	}
> >>>>>>     ...
> >>>>>> }
> >>>>>>
> >>>>>> It looks like it shouldn't stop if the wrong subtype is found, but the
> >>>>>> subtype is not compared there if I'm not mistaken. Should there be a fix
> >>>>>> to support this case?
> >>>>>
> >>>>> Would it work for you if you can specify what TCP option you want to
> >>>>> match? ie.
> >>>>>  
> >>>>>     tcp option[2] mptcp subtype remove-addr drop
> >>>>>                ^
> >>>>>                |
> >>>>>                |
> >>>>>        allow to specify a match at a given tcp option
> >>>>
> >>>> In my specific use-case, yes it would work. Some MPTCP sub-options will
> >>>> always be after another one... when the Linux stack is used.
> >>>
> >>> This would require a smaller patch.
> >>
> >> I understand. But I guess that still means adding a new option.
> >>
> >> In my case, it would work, but this might be confusing for people who
> >> want to use this filter: they need to know if a suboption can be used
> >> with another one. I guess they could have multiple rules to check the
> >> presence of a suboption in the first matched type, and in a second one,
> >> but that seems confusing. Or maybe not?
> > 
> > You mean, the might want to validate the entire list of suboptions in
> > a particular order, correct? ie. first suboption A then suboption B.
> 
> Yes, that's one possibility. But initially, I was thinking about having
> two rules (or a set?) to match "the MPTCP subtype is either in the first
> MPTCP option, or the second one (if any)". (Or nft could always say with
> MPTCP by default, check also for a second MPTCP option, if any)
>
> >>>>> Or would this be too strict for your use-case and you would prefer
> >>>>> that you can match it anywhere?
> >>>>
> >>>> I think it would make more sense to match it anywhere. For example, an
> >>>> MP_RESET can be used alone, or after an MP_FASTCLOSE. Plus some stacks
> >>>> could reorder the options as there is no imposed order.
> >>>
> >>> I think this would require a MPTCP subtype parser, ie. make kernel
> >>> aware of MPTCP subtypes.
> >>
> >> In nft_exthdr_tcp_eval(), why can the comparison not be done there
> >> instead of copying the data in a register, and compare later on? If the
> >> comparison is done directly for a given type and is different, the code
> >> could continue and check for the same type. (Or store in multiple
> >> registers.)
> > 
> > In nftables, the fetch then cmp instructions are splitted, ie. you
> > first retrieve then you compare (or make a set lookup with it).
> > Builtin comparison should be possible, but it defeats the integration
> > with the set infrastructure.
> 
> OK, I see.
> 
> If someone gives ...
> 
>   tcp option mptcp subtype { mp-capable, mp-join, remove-addr } drop
> 
> ... a bitmap could be used, but then that's specific to MPTCP I suppose.

I think this makes sense from user perspective.

The nft_exthdr expression needs iterate over the whole list of tcp
options, then if type is 30, make a set lookup to check if the subtype
value is in the set.

Something like:

 - loop
 |  r1 <- exthdr     [ if no more tcp options, break loop ]
 |  r2 <- lookup(r1) [ if found, break loop ]

but exthdr need to be taugh to resume from the last visited tcp
option. A new loop expression would wrap these two exthdr and lookup
expression (similar to nft_inner) and store the iteration context (ie.
last visited tcp option to continue from there).

exthdr tcp option support needs advertise a new NFT_EXPR_LOOP flag, so
it can be used with within this new nft_loop expression.

Another question: Would you still like to validate that DSS comes
before REMOVE_ADDR?

> >> I don't know if you need something specific to MPTCP, maybe just a way
> >> to check all options with the same type.
> > 
> > Going back to this:
> > 
> > "When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> > added to the TCP options, it is added after an MPTCP DSS option (type
> > 0x30, len >= 8, subtype 0x2)"
> > 
> > Would you like to check for this particular sequence, right? Then
> 
> In my case, no particularly -- I just want to count/drop REMOVE_ADDR to
> catch kernel regressions in the selftests -- but I can.
> 
> > position-based solution would work, because this would allow to match
> > strictly:
> > 
> > pos = 0, suboption DSS
> > pos = 1, suboption REMOVE_ADDR
> > 
> > This ruleset might break the protocol if there is ever a suboption
> > before DSS.
> 
> Indeed. Technically, with MPTCP, we could send the REMOVE_ADDR alone
> (without DSS), or before the DSS, or with another one in between if
> there is room.

Position matching is too strict.

You can still make it with the raw expression, but I think the native
matching representation should be more flexible too as you describe.

> > Loose mode is more protocol designer friendly as it does not constrain
> > future updates in the protocol:
> > 
> > "please find MP-TCP suboption REMOVE_ADDR for me"
> > 
> > but security folks might probably say this is ... loose, because it
> > does not validate DSS before and REMOVE_ADDR might come anywhere.
> > Protocol designer would say that this is good for them because this
> > firewall does not constrain future enhancements of the protocol (still
> > raw expressions are possible, then this last statement does not hold
> > anymore).
> > 
> > Which one would you pick? :-)
> 
> I would first prefer if people don't drop packets with MPTCP options :-D
> 
> Honestly, I'm not sure what people would be interested in doing in
> production, but I guess it would be more: "please match packet with
> MPTCP suboption X, no matter the order".

Yes, as discussed, this is more protocol friendly too in terms of
extensibility.

> If people are interested in a specific packet where MPTCP suboptions
> are in a specific order, with a specific length, I *think* they can
> use a raw payload expression instead, no?
> 
> In my case, I just wanted to drop packets with a specific MPTCP
> suboption. It happens that I know exactly which packet I want to block,
> and I can use a raw payload expression, but a simpler rule would be
> welcome :)

Makes sense.

This would need an extension in the kernel as Florian has anticipated.
