From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype, meta: add new ifname_type for
 iifname/oifname
Date: Tue, 1 Mar 2016 11:11:14 +0100
Message-ID: <20160301101114.GA2654@salvia>
References: <1456514374-28827-1-git-send-email-fw@strlen.de>
 <20160229131202.GA16476@salvia>
 <20160229131923.GB7277@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36447 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbcCAKLY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 05:11:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4BC5EC1085
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 11:11:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 330B1CE167
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 11:11:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D7C25EBAC4
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 11:11:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160229131923.GB7277@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 29, 2016 at 02:19:23PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The problem is that unqualified types cannot be currently used because
> > the have no specific length.
> 
> Yes.
>
> > Carlos has been submitting patches for a while (he's on Cc) that it
> > would be great to see in the tree at some point this week. Basically,
> > he's introducing a TLV infrastructure to store metainformation in the
> > USERDATA area.
> > 
> > The idea is to use these new TLVs to include the length of this
> > datatype. This allows us to interpret the data when dumping it from
> > the kernel and transform it to object via set_delinearize().
> 
> Ok, but how do you plan to handle the key length?

Right, in concatenations we can infer this from the lhs, but in set
definitions there is not way.

> Currently the kernel will -EINVAL in nf_tables_newset() because the
> key length is 0 for unqualified types.
> 
> Since nft has no information on the element keys (yet) I don't see
> how the TLV infrastructure helps in this case.

With the introduction of TLV infrastructure, the idea is to add a
length field to the TLV, so we have that type is "string" and the
corresponding length.

Similar thing for other meta matching such as cpu and any header field
that we should potentially support.

What I would suggest is to recover a patch that Patrick submitted that
introduces typeof(X) so we can use this from set definitions. We can
store in the TLV the original subtype X as a string. Thus, when
listing back to userspace we can use this information to display back
the typeof(X).

We have to potentially support every meta and packet selector,
including crazy ones as 48 bits fields, and last time we discussed
this, we agreed that adding one type per field size is not the way to
go.

I also like the typeof(X) so I don't have to remember myself all
available datatypes when using this.

Let me know your opinion on this, thanks!
