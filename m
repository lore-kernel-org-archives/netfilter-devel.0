From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 17:32:40 +0000
Message-ID: <20151125173240.GG30712@macbook.localdomain>
References: <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:59178 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbbKYRco (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 12:32:44 -0500
Content-Disposition: inline
In-Reply-To: <20151125164629.GB30712@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Patrick McHardy wrote:
> On 25.11, Florian Westphal wrote:
> > Hmm, I think it actually increases readability, as all the other lines
> > you quoted above are a lot shorter the ip saddr part is a lot more
> > visible.
> 
> They are actually still missing some minor parts from the original output :)
> 
> But if we want to shorten them, I would suggest f.i. to not repeat the
> devices on every line. It seems to logically belong to the "packet" part,
> same as vlan id. I guess the only thing we actually need to repeat is the
> mark since that might change while we're within the ruleset.

Actually thinking more about this, we might want to send a new "packet"
message whenever we enter nft_do_chain(). At that point the packet has been
processed by other parts of the network stack since the last "packet"
message and it might be helpful to know in which ways it has changed.
