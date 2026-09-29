Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806B251B182
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 12:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790683424; cv=none; b=OeS5ewTtVOwjHnFiUdTt37n0KOeuWyeuhEv9XoETVtf384Z+CRbIULSNcOMuKeX/CqRt2GWGoEFwsLrPb4dLxO9Mb/9EevbuhuztUM+RvVEUaEHfV5uRiqICLqSzBrB9TM3IzJyuAyL6dtfVctR4kimyaqiL+XX22K47XGloOpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790683424; c=relaxed/simple;
	bh=/dPN8ZdCuu4AUiWLqM0urkq8QRJpZ+wjgtuBE+3X5Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxf5wgEI1gttIYz4r2on8WkDcq8wf4RgA8iqtnVmfjvvNG3oYj0lJpIGv5faigAUIz5ZqvCtDqS6SkW8DGuZc1ljsS8v3VPL0sbo9h8JmLYBZf9L47pK58pLk4Qw6vHBMNx+HadJmRFMtL92psvR8LzHAyrub386qJMgvpvv1UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mftZFpby; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mftZFpby"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790683418;
	bh=G4mv30x8p0nUdTdaLy9UIe7zymOr8FXDJNEeZdhjkHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mftZFpbyr+eC+buxMBHg+0M/tTcUbjQHtCliM8Pr1obvYw2SGlex7y2y55c7hCTRE
	 ZNyZtduZz5CQJhabux9itrUJ7L1c+OWWB+RB80Rd7JKNA8BELZN7P7B/hjS1F2ljY9
	 5LYuYnoVBY5TKQOjWDXubGpUn2a8XINF7L/cZJ/QkuPk6eAfuUhrlY/EAuUad4YnHp
	 U83Z6uJYMYdKBRfZ99LeSKI2PFH7ViN2xDYr650cCClUHmxwTsqS18wB0iwtRHeiBm
	 dOS8Iid4lMlhJVhAFKCzuSg9Kd2CfIVYkhwDMphNXk0Wbs8hmy45DJezCLrmLiLHKz
	 EqeJe4KafAIiQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3D4FD602C5;
	Tue, 29 Sep 2026 14:03:38 +0200 (CEST)
Date: Tue, 29 Sep 2026 14:03:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <arupFwGHewREJJ74@chamomile>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
 <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
 <aruMPHNdZq7U9eV9@chamomile>
 <4da35a94-af13-47de-adef-35b5671100b7@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4da35a94-af13-47de-adef-35b5671100b7@kernel.org>

On Tue, Sep 29, 2026 at 12:40:47PM +0200, Matthieu Baerts wrote:
> On 29/09/2026 12:00, Pablo Neira Ayuso wrote:
> > On Tue, Sep 29, 2026 at 11:21:15AM +0200, Matthieu Baerts wrote:
> >> Hi Pablo,
> >>
> >> Thank you for your reply!
> >>
> >> On 28/09/2026 23:52, Pablo Neira Ayuso wrote:
> >>> Hi Mattieu,
> >>>
> >>> On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
> >>>> Hello Netfilter devs,
> >>>>
> >>>> First, thank you for maintaining Netfilter in the kernel and the
> >>>> userspace tools.
> >>>>
> >>>> The MPTCP selftests are switching from IPTables to NFTables, and
> >>>> Clashiko reported that this part of a rule wouldn't match anything:
> >>>>
> >>>>   tcp option mptcp subtype remove-addr drop
> >>>>
> >>>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> >>>> added to the TCP options, it is added after an MPTCP DSS option (type
> >>>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> >>>> (type 30) options in the TCP options. It looks like Netfilter doesn't
> >>>> handle that, because it stops processing other TCP options when the
> >>>> expected type is found:
> >>>>
> >>>> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
> >>>>     ...
> >>>> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
> >>>> 		optl = optlen(opt, i);
> >>>>
> >>>> 		if (priv->type != opt[i])
> >>>> 			continue;
> >>>> 		...
> >>>> 		return;  // <== it will look at the first MPTCP option
> >>>> 	}
> >>>>     ...
> >>>> }
> >>>>
> >>>> It looks like it shouldn't stop if the wrong subtype is found, but the
> >>>> subtype is not compared there if I'm not mistaken. Should there be a fix
> >>>> to support this case?
> >>>
> >>> Would it work for you if you can specify what TCP option you want to
> >>> match? ie.
> >>>  
> >>>     tcp option[2] mptcp subtype remove-addr drop
> >>>                ^
> >>>                |
> >>>                |
> >>>        allow to specify a match at a given tcp option
> >>
> >> In my specific use-case, yes it would work. Some MPTCP sub-options will
> >> always be after another one... when the Linux stack is used.
> > 
> > This would require a smaller patch.
> 
> I understand. But I guess that still means adding a new option.
> 
> In my case, it would work, but this might be confusing for people who
> want to use this filter: they need to know if a suboption can be used
> with another one. I guess they could have multiple rules to check the
> presence of a suboption in the first matched type, and in a second one,
> but that seems confusing. Or maybe not?

You mean, the might want to validate the entire list of suboptions in
a particular order, correct? ie. first suboption A then suboption B.

> >>> Or would this be too strict for your use-case and you would prefer
> >>> that you can match it anywhere?
> >>
> >> I think it would make more sense to match it anywhere. For example, an
> >> MP_RESET can be used alone, or after an MP_FASTCLOSE. Plus some stacks
> >> could reorder the options as there is no imposed order.
> > 
> > I think this would require a MPTCP subtype parser, ie. make kernel
> > aware of MPTCP subtypes.
> 
> In nft_exthdr_tcp_eval(), why can the comparison not be done there
> instead of copying the data in a register, and compare later on? If the
> comparison is done directly for a given type and is different, the code
> could continue and check for the same type. (Or store in multiple
> registers.)

In nftables, the fetch then cmp instructions are splitted, ie. you
first retrieve then you compare (or make a set lookup with it).
Builtin comparison should be possible, but it defeats the integration
with the set infrastructure.

> I don't know if you need something specific to MPTCP, maybe just a way
> to check all options with the same type.

Going back to this:

"When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
added to the TCP options, it is added after an MPTCP DSS option (type
0x30, len >= 8, subtype 0x2)"

Would you like to check for this particular sequence, right? Then
position-based solution would work, because this would allow to match
strictly:

pos = 0, suboption DSS
pos = 1, suboption REMOVE_ADDR

This ruleset might break the protocol if there is ever a suboption
before DSS.

Loose mode is more protocol designer friendly as it does not constrain
future updates in the protocol:

"please find MP-TCP suboption REMOVE_ADDR for me"

but security folks might probably say this is ... loose, because it
does not validate DSS before and REMOVE_ADDR might come anywhere.
Protocol designer would say that this is good for them because this
firewall does not constrain future enhancements of the protocol (still
raw expressions are possible, then this last statement does not hold
anymore).

Which one would you pick? :-)

> > I would support both of them eventually? Starting by the one above
> > that allows to match at a given position which looks simpler to
> > support to me. Then, look into adding a MPTCP subtype parser later?
> 
> If the second one can be implemented in a simple way, perhaps the first
> one is not needed? If not, yes, good idea to start with the first one,
> which might be enough for most people.

Both solutions are feasible IMO, the second needs a bit more work,
that's all.
