From: Patrick Schaaf <netdev@bof.de>
Subject: Re: [nf_tables] suggestion: system-wide sets
Date: Mon, 03 Mar 2014 11:32:14 +0100
Message-ID: <4515053.884CkpCZ1T@rofl>
References: <CAOkSjBjSzf3tmdBPtXtrrcPe1xXh5S4pp4znE2ek1dEr4LzKCQ@mail.gmail.com> <20140227140230.GA18385@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:54200 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaCCKcU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Mar 2014 05:32:20 -0500
In-Reply-To: <20140227140230.GA18385@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 27 February 2014 14:02:30 Patrick McHardy wrote:

> Yeah, I agree. I think family wide sets and global (AF_UNSPEC) sets should
> bet quite easy to add. However there's the question how to expose them
> in the nft list table output. The idea is to be able to recreate the
> current ruleset, including sets and elements, by parsing the output of
> nft list table. If we don't include sets, the user will have to seperately
> save and restore them. OTOH if we simply include global and AF-specific
> sets, they will be restored once for each table and this will fail on
> the second table.
> 
> Any other ideas?

First of all I'd like to note that this needs-separate-saving, is exactly the 
situation we have right now with ipset, so it is not something totally 
unknown. Recreating a table that references nonexisting global sets, would 
fail, just like loading / restoring iptables rules that reference nonexisting 
ipsets, fails right now.

Alternatively - but I'm not sure how good an idea that would be - couldn't 
such nonexisting set references somehow create "forward declarations" to 
permit loading in any order, and threat as-yet-undefined sets as empty?

An additional issue that I imagine we'd have, is set names clashing between 
global and per-table sets. To this end, maybe it would be useful to have a 
syntactic means to differentiate the two cases when referencing sets. Maybe 
append a second '@' to reference global sets?

nfd add rule ip input ip saddr @sharedset@

Rule listing could be a bit flexibly when just a plain set name is given, 
showing per table or global sets as they exist.

Just some thoughts I have on the issue, looking from the outside. Use as you 
see fit :)

best regards
  Patrick
