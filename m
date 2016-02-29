From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] datatype, meta: add new ifname_type for
 iifname/oifname
Date: Mon, 29 Feb 2016 14:19:23 +0100
Message-ID: <20160229131923.GB7277@breakpoint.cc>
References: <1456514374-28827-1-git-send-email-fw@strlen.de>
 <20160229131202.GA16476@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46344 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbcB2NTZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 08:19:25 -0500
Content-Disposition: inline
In-Reply-To: <20160229131202.GA16476@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Fri, Feb 26, 2016 at 08:19:34PM +0100, Florian Westphal wrote:
> > String is an unqualified type and we do not have a data element to
> > derive the element size from at set creation time.
> > 
> > Add a new string subtype -- iface_name -- and switch
> > meta iifname/oifname to use it instead of string.
> > 
> > One can then define a named set for interface names with
> > 
> > nft add set filter ifnames '{type iface_name; }'
> 
> The problem is that unqualified types cannot be currently used because
> the have no specific length.

Yes.
>
> Carlos has been submitting patches for a while (he's on Cc) that it
> would be great to see in the tree at some point this week. Basically,
> he's introducing a TLV infrastructure to store metainformation in the
> USERDATA area.
> 
> The idea is to use these new TLVs to include the length of this
> datatype. This allows us to interpret the data when dumping it from
> the kernel and transform it to object via set_delinearize().

Ok, but how do you plan to handle the key length?

Currently the kernel will -EINVAL in nf_tables_newset() because the
key length is 0 for unqualified types.

Since nft has no information on the element keys (yet) I don't see
how the TLV infrastructure helps in this case.

I'll wait for your patches.
