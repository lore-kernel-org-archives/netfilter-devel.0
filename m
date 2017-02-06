From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nftables 5/9] src: add host byte order integer type
Date: Mon, 6 Feb 2017 23:33:01 +0100
Message-ID: <20170206223301.GA28402@breakpoint.cc>
References: <20170203123556.17357-1-fw@strlen.de>
 <20170203123556.17357-6-fw@strlen.de>
 <20170206173110.GA18703@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53592 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751395AbdBFWdv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 17:33:51 -0500
Content-Disposition: inline
In-Reply-To: <20170206173110.GA18703@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Feb 03, 2017 at 01:35:52PM +0100, Florian Westphal wrote:
> > diff --git a/include/datatype.h b/include/datatype.h
> > index 9f127f2954e3..8c1c827253be 100644
> > --- a/include/datatype.h
> > +++ b/include/datatype.h
> > @@ -82,6 +82,7 @@ enum datatypes {
> >  	TYPE_DSCP,
> >  	TYPE_ECN,
> >  	TYPE_FIB_ADDR,
> > +	TYPE_U32,
> >  	__TYPE_MAX
> >  };
> >  #define TYPE_MAX		(__TYPE_MAX - 1)
> 
> Right, this is a real problem with host byteorder integer, the
> bytecode that we generate is not correct.
> 
> I have a patch to avoid this, it's still incomplete. I'm attaching it.
> 
> Note this is still incomplete, since this doesn't solve the netlink
> delinearize path. We can use the NFT_SET_USERDATA area and the tlv
> infrastructure that Carlos made in summer to store this
> metainformation that is only useful to
> 
> This shouldn't be a showstopper to get kernel patches in, we have a
> bit of time ahead to solve this userspace issue.

I don't understand why all this fuss is required.

The type always enocodes/decides the endianess, so I fail to see why we
need to store endianess also in the templates (f.e. meta_templates[],
it just seems 100% redundant ...)

Thats why it I added this host endian thing here, we could then replace

[NFT_META_CPU]  = META_TEMPLATE("cpu", &integer_type, 4 * BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
with
[NFT_META_CPU]  = META_TEMPLATE("cpu", &integer_u32, 4 * BITS_PER_BYTE),

and don't need this 'endianess override' in the templates anymore.
We might even be able to get rid of the endianess storage in the eval
context this way.

What am I missing?
