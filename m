From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf_tables] suggestion: system-wide sets
Date: Tue, 4 Mar 2014 09:20:13 +0000
Message-ID: <20140304092013.GA5568@macbook.localnet>
References: <CAOkSjBjSzf3tmdBPtXtrrcPe1xXh5S4pp4znE2ek1dEr4LzKCQ@mail.gmail.com>
 <20140227140230.GA18385@macbook.localnet>
 <4515053.884CkpCZ1T@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38301 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbaCDJUR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:20:17 -0500
Content-Disposition: inline
In-Reply-To: <4515053.884CkpCZ1T@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 03, 2014 at 11:32:14AM +0100, Patrick Schaaf wrote:
> On Thursday 27 February 2014 14:02:30 Patrick McHardy wrote:
> 
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
> First of all I'd like to note that this needs-separate-saving, is exactly the 
> situation we have right now with ipset, so it is not something totally 
> unknown. Recreating a table that references nonexisting global sets, would 
> fail, just like loading / restoring iptables rules that reference nonexisting 
> ipsets, fails right now.

Right, but it makes atomic replacements of the ruleset either asymetrical
to saving them or simply impossible. Sets are considered a part of the rulset.

> Alternatively - but I'm not sure how good an idea that would be - couldn't 
> such nonexisting set references somehow create "forward declarations" to 
> permit loading in any order, and threat as-yet-undefined sets as empty?

That would mean any typo in set names would create an empty set instead of
an error. I don't think this is a good idea.

> An additional issue that I imagine we'd have, is set names clashing between 
> global and per-table sets. To this end, maybe it would be useful to have a 
> syntactic means to differentiate the two cases when referencing sets. Maybe 
> append a second '@' to reference global sets?
> 
> nfd add rule ip input ip saddr @sharedset@

The alternative would be scoping, we need to look up in multiple scopes
anyways. AF-specific overrides global.

> Rule listing could be a bit flexibly when just a plain set name is given, 
> showing per table or global sets as they exist.

Yeah, that definitely makes sense, we don't want to dump all global sets
if they're not even used within a table. Actually even easier would be
to not show them at all outside of the AF_UNSPEC family and require the
user to restore in the correct order when using global sets. We do support
file inclusions etc. that make this easy to handle. A full dump (all AFs)
would simply begin with AF_UNSPEC and be restorable without any manual
intervention.

> Just some thoughts I have on the issue, looking from the outside. Use as you 
> see fit :)

Thanks.
