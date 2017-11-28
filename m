From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 1/3] netfilter: nf_conntrack: add 64-bit
 conntrack ID extension
Date: Tue, 28 Nov 2017 21:44:48 +0100
Message-ID: <20171128204448.GC16528@breakpoint.cc>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128121652.GH23412@breakpoint.cc>
 <20171128155722.GA4719@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        richard@nod.at
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52202 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753123AbdK1Up6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 15:45:58 -0500
Content-Disposition: inline
In-Reply-To: <20171128155722.GA4719@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > index 21f887c5058c..274f9370c56a 100644
> > > --- a/include/net/netfilter/nf_conntrack_extend.h
> > > +++ b/include/net/netfilter/nf_conntrack_extend.h
> > > @@ -28,6 +28,7 @@ enum nf_ct_ext_id {
> > >  #if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
> > >  	NF_CT_EXT_SYNPROXY,
> > >  #endif
> > > +	NF_CT_EXT_ID,
> > 
> > I think, if we decide that this new id is needed,
> > we might as well place this directly in the extension
> > struct itself rather than an id.
> > 
> > AFAIU this id is always active/set so we never have a
> > conntrack without this.
> 
> I understand your goal would be to make this run faster for the first
> packet that is part of the connection. This would fit into the 128 bytes
> that we preallocate, so you're just trying to remove one level of
> indirection, right?

Yes, and save the space in the len/data array for the new extension id.

There is nothing else to it.
We currently do not have an "always on" extension, this would be the
first.
