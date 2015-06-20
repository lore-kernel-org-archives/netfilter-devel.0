From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 3/3] rule: fix use of intervals in set declarations
Date: Sat, 20 Jun 2015 13:41:34 +0200
Message-ID: <20150620114133.GB6915@acer.localdomain>
References: <1434719718-10371-1-git-send-email-pablo@netfilter.org>
 <1434719718-10371-3-git-send-email-pablo@netfilter.org>
 <20150619131336.GH22946@acer.localdomain>
 <20150619134816.GA19433@salvia>
 <20150619134444.GL22946@acer.localdomain>
 <20150619135958.GA19487@salvia>
 <20150619135948.GM22946@acer.localdomain>
 <20150619174046.GA4741@salvia>
 <28C126EF-7F7A-438A-9882-BA84FB960517@trash.net>
 <20150620110643.GA4159@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, admin@rollinix.net,
	niels@kristensen.io, tom@compton.nu
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35299 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbbFTLlg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2015 07:41:36 -0400
Content-Disposition: inline
In-Reply-To: <20150620110643.GA4159@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.06, Pablo Neira Ayuso wrote:
> On Fri, Jun 19, 2015 at 08:15:01PM +0200, Patrick McHardy wrote:
> [...]
> > >OK, so that transformation would look like:
> > >
> > >1) Fetch the existing elements in the set via netlink.
> > >2) Handle merges with the elements that the user has passed through
> > >   command line.
> > >3) Build the segtree.
> > >4) Push it into the kernel. We need to mark all existing elements for
> > >   the deletion plus add the new elements, all that in one single
> > >   transaction.
> > >
> > >Is this your idea? So it looks like we need a bit more userspace code.
> > >
> > >With the existing approach, the kernel rejects overlapping segments
> > >with -EEXIST, so if the user is careful to avoid them there should be
> > >no problem. It's more restrictive than what the logic above, but set
> > >declarations with intervals will work until that code lands in the
> > >tree.
> > 
> > Sorry, missed this part. Are you sure about that? I'm pretty sure we
> > only reject exact duplicates. Otherwise I'd agree, that would be
> > fine for now.
> 
> Yes, overlapping segments are rejected:
> 
> # nft add element test myset { 1.2.3.0/24 }
> # nft add element test myset { 1.2.3.1 }
> <cmdline>:1:1-34: Error: Could not process rule: File exists
> add element test myset { 1.2.3.1 }
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> # nft add element test myset { 1.2.3.0 }
> <cmdline>:1:1-34: Error: Could not process rule: File exists
> add element test myset { 1.2.3.0 }
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> # nft add element test myset { 1.2.3.255 }
> <cmdline>:1:1-36: Error: Could not process rule: File exists
> add element test myset { 1.2.3.255 }
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> # nft add element test myset { 1.2.3.30-1.2.4.30 }
> <cmdline>:1:1-44: Error: Could not process rule: File exists
> add element test myset { 1.2.3.30-1.2.4.30 }
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I think this is basically by accident. Does it also reject if the
second segment starts *before* the first one? IOW, 192.168.1.0/24
and 192.168.0.0/16?

> I'll send a v2 of this patch to replace the netlink_get_set() call so
> this also works for set declarations in one single transaction.

That is a good change in any case.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
