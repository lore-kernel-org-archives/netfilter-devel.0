From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 23:42:23 +0000
Message-ID: <20151125234223.GG20093@macbook.localdomain>
References: <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
 <20151125150640.GE18449@macbook.localdomain>
 <20151125162424.GJ23215@breakpoint.cc>
 <20151125164629.GB30712@macbook.localdomain>
 <20151125173240.GG30712@macbook.localdomain>
 <20151125222710.GK23215@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:62674 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972AbbKYXm2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:42:28 -0500
Content-Disposition: inline
In-Reply-To: <20151125222710.GK23215@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > Actually thinking more about this, we might want to send a new "packet"
> > message whenever we enter nft_do_chain(). At that point the packet has been
> > processed by other parts of the network stack since the last "packet"
> > message and it might be helpful to know in which ways it has changed.
> 
> True, good point.  In that case I would propose to get rid of "packet"
> message type completely.
> 
> Instead we'd include all the info that we currently have in "packet"
> (i.e. vlanid, headers) on the first message type fired on each nft_do_chain()
> invocation.

One more comment since I'm just in the VLAN area: I think we need to include
the full vlan_tci and vlan_proto. Basically we want to be able to display
a dummy VLAN header I'd say instead of treating it like something special.

Even nicer would be to include the dummy VLAN header in the payload itself
and hide the offloading details, but that we can also do in userspace of
course.
