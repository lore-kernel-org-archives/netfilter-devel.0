From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables] suggestion: system-wide sets
Date: Thu, 27 Feb 2014 14:58:55 +0000
Message-ID: <20140227145854.GA27782@macbook.localnet>
References: <CAOkSjBjSzf3tmdBPtXtrrcPe1xXh5S4pp4znE2ek1dEr4LzKCQ@mail.gmail.com>
 <20140227140230.GA18385@macbook.localnet>
 <CAOkSjBgUNb_4ruqd4m7sdv2aQXDAtds+dgogLXvzSNEeHdCyQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58257 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0O65 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:58:57 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgUNb_4ruqd4m7sdv2aQXDAtds+dgogLXvzSNEeHdCyQw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 03:46:12PM +0100, Arturo Borrero Gonzalez wrote:
> On 27 February 2014 15:02, Patrick McHardy <kaber@trash.net> wrote:
> > On Thu, Feb 27, 2014 at 01:15:36PM +0100, Arturo Borrero Gonzalez wrote:
> >> Hi there!
> >>
> >> I can't remember this subject being discussed in the near past.
> >>
> >> Why not using system-wide sets? Or at least, family-wide sets?
> >>
> >> >From the user point of view, I think is very interesting to define
> >> sets that can be used in rules all across the ruleset, same set in
> >> different tables and families.
> >
> > Yeah, I agree. I think family wide sets and global (AF_UNSPEC) sets should
> > bet quite easy to add. However there's the question how to expose them
> > in the nft list table output. The idea is to be able to recreate the
> > current ruleset, including sets and elements, by parsing the output of
> > nft list table. If we don't include sets, the user will have to seperately
> > save and restore them. OTOH if we simply include global and AF-specific
> > sets, they will be restored once for each table and this will fail on
> > the second table.
> >
> > Any other ideas?
> 
> idea 1:
> 
> print global sets when listing every time a table is listed.
> 
> To backup the ruleset, the user must iterate over the list of
> tables/AF (nft list table $AF $TABLE), so the global sets get printed
> several times.
> 
> when restoring, try to add the global set to the kernel.
> If the set already exist, return EEXIST from the kernel, and let nft
> ignore that if operating with 'nft -f'.

Yeah, that might work. However, how do we know that this it contains the
correct elements?

> idea 2:
> 
> add `nft list ruleset', which prints all tables in all AF, including
> global sets.
> Global sets are only printed in this 'ruleset' view.
> 
> Still, the ignore EEXIST errors from the kernel for globals sets.

Also something worth considering. I'm not sure about this yet, let me
think about this a bit.

> >> Being family-wide is what ipset does, and I'm sure is what most people
> >> will expect.
> >>
> >> On the other hand, I understand this would be a major change at this point.
> >
> > Should be fine. I'm thinking of keeping the table specific sets and also
> > having per AF and AF_UNSPEC sets. For maps we should restrict this feature
> > to data maps since verdicts may need a table context.
> 
> I agree.
