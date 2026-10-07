Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA046A60B
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370090; cv=none; b=U8NGw+Rm9PzHzUc2dk7frL55AfQiCAGf17L9gr5OrrFV2X/t7muKNG7TkwCaemxMeuV+Yw7HSyXO/ZQuITM3XD1xXQM2TckwHoVerEp9k7mLvlZlo7z0gk8yNx3e+G8DaCCVFSzzbuEo6E3opKbNmP1RE0JYYYsvZu3QOqyd77M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370090; c=relaxed/simple;
	bh=VuQOT7W0TJEoixlC23DXXs7LuZySBnwJ6uQBmABGWxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hg37QMMOlstcfzC4w1PSAYn8ZZWPlNmB0KJKdZE90y271ZN22x9ixicUIYPhE1/303vNv4146dud8sDs/ebiaRaWdAgQSMAw4jsaKZRNs6czQe0FvGmMkEJW8s9Ht1YIezfKM0P3p5vbmomaJseDWGCqXJeJxhUX6KgNWLvrf+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Y7vQ5RhC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Y7vQ5RhC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791370027;
	bh=fVBmF26hdUxc0n9jz3jlnjXu6wnF1T1z/JWV+aUw5Co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y7vQ5RhCXM0pykOptTzTQ8h0hMD+OZ+EPhjl7M7Lcw4/r+ujHrLl/GRFDwo4MwY0n
	 G3ZwlG1P2T0gjPOYReotvv7mfmfhBSK61S4JmPQui9Eggw65Cduv9YKcrgSmB38H8a
	 d5qEYOQ24wHS3xWOCaNtYmAjnZZL6TDyYFitKKSpzPKgcg3caMDWOLmLSYq0HXAnf6
	 VBbf5a9Fn/b/oHlHTJuxMOpfwCJWJ4rDP+0NoGE31VI9NjYBKn0Ge3yHXI5LnHAJD+
	 JJ6GCTq5GYaHQRla9VlF15nj11wh0bWj5RelQd6vPWFpTJ6IgMff+FZUdTtnXlw83T
	 s3SGg3DJsHdnw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id F24F66005E;
	Wed,  7 Oct 2026 12:47:06 +0200 (CEST)
Date: Wed, 7 Oct 2026 12:47:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Matthieu Baerts <matttbe@kernel.org>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <asYjJ2-q5_fPJ5Ch@chamomile>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
 <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
 <aruMPHNdZq7U9eV9@chamomile>
 <4da35a94-af13-47de-adef-35b5671100b7@kernel.org>
 <arupFwGHewREJJ74@chamomile>
 <6365150c-09d0-4a2c-84e3-ffe6e292e317@kernel.org>
 <asWEWpVJLk0so8zM@chamomile>
 <4b8e49eb-9a14-4dae-aed9-3bcf35308efc@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4b8e49eb-9a14-4dae-aed9-3bcf35308efc@suse.de>

Hi Fernando,

On Wed, Oct 07, 2026 at 10:01:51AM +0200, Fernando Fernandez Mancera wrote:
> 
> 
> On 10/7/26 1:29 AM, Pablo Neira Ayuso wrote:
> > Hi Matthieu,
> > 
> > On Wed, Sep 30, 2026 at 08:33:36PM +0200, Matthieu Baerts wrote:
> > > Hi Pablo,
> > > 
> > > Thank you for your reply!
> > > 
> > > On 29/09/2026 14:03, Pablo Neira Ayuso wrote:
> > > > On Tue, Sep 29, 2026 at 12:40:47PM +0200, Matthieu Baerts wrote:
> > > > > On 29/09/2026 12:00, Pablo Neira Ayuso wrote:
> > > > > > On Tue, Sep 29, 2026 at 11:21:15AM +0200, Matthieu Baerts wrote:
> > > > > > > Hi Pablo,
> > > > > > > 
> > > > > > > Thank you for your reply!
> > > > > > > 
> > > > > > > On 28/09/2026 23:52, Pablo Neira Ayuso wrote:
> > > > > > > > Hi Mattieu,
> > > > > > > > 
> > > > > > > > On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
> > > > > > > > > Hello Netfilter devs,
> > > > > > > > > 
> > > > > > > > > First, thank you for maintaining Netfilter in the kernel and the
> > > > > > > > > userspace tools.
> > > > > > > > > 
> > > > > > > > > The MPTCP selftests are switching from IPTables to NFTables, and
> > > > > > > > > Clashiko reported that this part of a rule wouldn't match anything:
> > > > > > > > > 
> > > > > > > > >    tcp option mptcp subtype remove-addr drop
> > > > > > > > > 
> > > > > > > > > When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> > > > > > > > > added to the TCP options, it is added after an MPTCP DSS option (type
> > > > > > > > > 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> > > > > > > > > (type 30) options in the TCP options. It looks like Netfilter doesn't
> > > > > > > > > handle that, because it stops processing other TCP options when the
> > > > > > > > > expected type is found:
> > > > > > > > > 
> > > > > > > > > net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
> > > > > > > > >      ...
> > > > > > > > > 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
> > > > > > > > > 		optl = optlen(opt, i);
> > > > > > > > > 
> > > > > > > > > 		if (priv->type != opt[i])
> > > > > > > > > 			continue;
> > > > > > > > > 		...
> > > > > > > > > 		return;  // <== it will look at the first MPTCP option
> > > > > > > > > 	}
> > > > > > > > >      ...
> > > > > > > > > }
> > > > > > > > > 
> > > > > > > > > It looks like it shouldn't stop if the wrong subtype is found, but the
> > > > > > > > > subtype is not compared there if I'm not mistaken. Should there be a fix
> > > > > > > > > to support this case?
> > > > > > > > 
> > > > > > > > Would it work for you if you can specify what TCP option you want to
> > > > > > > > match? ie.
> > > > > > > >      tcp option[2] mptcp subtype remove-addr drop
> > > > > > > >                 ^
> > > > > > > >                 |
> > > > > > > >                 |
> > > > > > > >         allow to specify a match at a given tcp option
> > > > > > > 
> > > > > > > In my specific use-case, yes it would work. Some MPTCP sub-options will
> > > > > > > always be after another one... when the Linux stack is used.
> > > > > > 
> > > > > > This would require a smaller patch.
> > > > > 
> > > > > I understand. But I guess that still means adding a new option.
> > > > > 
> > > > > In my case, it would work, but this might be confusing for people who
> > > > > want to use this filter: they need to know if a suboption can be used
> > > > > with another one. I guess they could have multiple rules to check the
> > > > > presence of a suboption in the first matched type, and in a second one,
> > > > > but that seems confusing. Or maybe not?
> > > > 
> > > > You mean, the might want to validate the entire list of suboptions in
> > > > a particular order, correct? ie. first suboption A then suboption B.
> > > 
> > > Yes, that's one possibility. But initially, I was thinking about having
> > > two rules (or a set?) to match "the MPTCP subtype is either in the first
> > > MPTCP option, or the second one (if any)". (Or nft could always say with
> > > MPTCP by default, check also for a second MPTCP option, if any)
> > > 
> > > > > > > > Or would this be too strict for your use-case and you would prefer
> > > > > > > > that you can match it anywhere?
> > > > > > > 
> > > > > > > I think it would make more sense to match it anywhere. For example, an
> > > > > > > MP_RESET can be used alone, or after an MP_FASTCLOSE. Plus some stacks
> > > > > > > could reorder the options as there is no imposed order.
> > > > > > 
> > > > > > I think this would require a MPTCP subtype parser, ie. make kernel
> > > > > > aware of MPTCP subtypes.
> > > > > 
> > > > > In nft_exthdr_tcp_eval(), why can the comparison not be done there
> > > > > instead of copying the data in a register, and compare later on? If the
> > > > > comparison is done directly for a given type and is different, the code
> > > > > could continue and check for the same type. (Or store in multiple
> > > > > registers.)
> > > > 
> > > > In nftables, the fetch then cmp instructions are splitted, ie. you
> > > > first retrieve then you compare (or make a set lookup with it).
> > > > Builtin comparison should be possible, but it defeats the integration
> > > > with the set infrastructure.
> > > 
> > > OK, I see.
> > > 
> > > If someone gives ...
> > > 
> > >    tcp option mptcp subtype { mp-capable, mp-join, remove-addr } drop
> > > 
> > > ... a bitmap could be used, but then that's specific to MPTCP I suppose.
> > 
> > I think this makes sense from user perspective.
> > 
> > The nft_exthdr expression needs iterate over the whole list of tcp
> > options, then if type is 30, make a set lookup to check if the subtype
> > value is in the set.
> > 
> > Something like:
> > 
> >   - loop
> >   |  r1 <- exthdr     [ if no more tcp options, break loop ]
> >   |  r2 <- lookup(r1) [ if found, break loop ]
> > 
> > but exthdr need to be taugh to resume from the last visited tcp
> > option. A new loop expression would wrap these two exthdr and lookup
> > expression (similar to nft_inner) and store the iteration context (ie.
> > last visited tcp option to continue from there).
> > 
> > exthdr tcp option support needs advertise a new NFT_EXPR_LOOP flag, so
> > it can be used with within this new nft_loop expression.
> > 
> 
> Wouldn't this be too complex? I was thinking in something a bit more generic
> and simpler. E.g a new NFTA_EXTHDR_INNER_TYPE which will work with PRESENT
> flag.

That's fine, this is needed for matching the subtype.

> That way one can match MPTCP options exactly the same way TCP options are
> matched. The implementation would look first for the TCP option 30 and then
> check the subtype, if it matches return 1 otherwise continue.
> 
> This is chained with a CMP_EQ expression.

I think it would be great if we support this too:

    tcp option mptcp subtype { mp-capable, mp-join, remove-addr } drop

and even combine this new feature with maps.

IIUC, TCP option 30 might come several times, one for each subtype,
that is why I suggested the loop thing, because we need to have
control on the iteration over the list of options. But if you design
copes with the requirements that we have discussed or it can be
extended later on, that's fine.

> I have a working patch, let me polish the code and will send it as RFC today
> so we can discuss it. I like this idea because it could be extended to match
> similar situations in IPv6 headers or SCTP.

Yes, this should work with other extensions too.
