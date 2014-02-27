From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables] suggestion: system-wide sets
Date: Thu, 27 Feb 2014 14:02:30 +0000
Message-ID: <20140227140230.GA18385@macbook.localnet>
References: <CAOkSjBjSzf3tmdBPtXtrrcPe1xXh5S4pp4znE2ek1dEr4LzKCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57826 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaB0OCf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:02:35 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjSzf3tmdBPtXtrrcPe1xXh5S4pp4znE2ek1dEr4LzKCQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 27, 2014 at 01:15:36PM +0100, Arturo Borrero Gonzalez wrote:
> Hi there!
> 
> I can't remember this subject being discussed in the near past.
> 
> Why not using system-wide sets? Or at least, family-wide sets?
> 
> >From the user point of view, I think is very interesting to define
> sets that can be used in rules all across the ruleset, same set in
> different tables and families.

Yeah, I agree. I think family wide sets and global (AF_UNSPEC) sets should
bet quite easy to add. However there's the question how to expose them
in the nft list table output. The idea is to be able to recreate the
current ruleset, including sets and elements, by parsing the output of
nft list table. If we don't include sets, the user will have to seperately
save and restore them. OTOH if we simply include global and AF-specific
sets, they will be restored once for each table and this will fail on
the second table.

Any other ideas?

> Being family-wide is what ipset does, and I'm sure is what most people
> will expect.
> 
> On the other hand, I understand this would be a major change at this point.

Should be fine. I'm thinking of keeping the table specific sets and also
having per AF and AF_UNSPEC sets. For maps we should restrict this feature
to data maps since verdicts may need a table context.
