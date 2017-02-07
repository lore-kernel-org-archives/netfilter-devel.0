From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 5/9] src: add host byte order integer type
Date: Tue, 7 Feb 2017 12:58:56 +0100
Message-ID: <20170207115856.GB1231@salvia>
References: <20170203123556.17357-1-fw@strlen.de>
 <20170203123556.17357-6-fw@strlen.de>
 <20170206173110.GA18703@salvia>
 <20170206223301.GA28402@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753345AbdBGL7G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2017 06:59:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C1B8BBA6F1
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2017 12:59:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B133CDA80B
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2017 12:59:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 690C8DA851
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Feb 2017 12:59:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170206223301.GA28402@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 06, 2017 at 11:33:01PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Feb 03, 2017 at 01:35:52PM +0100, Florian Westphal wrote:
> > > diff --git a/include/datatype.h b/include/datatype.h
> > > index 9f127f2954e3..8c1c827253be 100644
> > > --- a/include/datatype.h
> > > +++ b/include/datatype.h
> > > @@ -82,6 +82,7 @@ enum datatypes {
> > >  	TYPE_DSCP,
> > >  	TYPE_ECN,
> > >  	TYPE_FIB_ADDR,
> > > +	TYPE_U32,
> > >  	__TYPE_MAX
> > >  };
> > >  #define TYPE_MAX		(__TYPE_MAX - 1)
> > 
> > Right, this is a real problem with host byteorder integer, the
> > bytecode that we generate is not correct.
> > 
> > I have a patch to avoid this, it's still incomplete. I'm attaching it.
> > 
> > Note this is still incomplete, since this doesn't solve the netlink
> > delinearize path. We can use the NFT_SET_USERDATA area and the tlv
> > infrastructure that Carlos made in summer to store this
> > metainformation that is only useful to
> > 
> > This shouldn't be a showstopper to get kernel patches in, we have a
> > bit of time ahead to solve this userspace issue.
> 
> I don't understand why all this fuss is required.
> 
> The type always enocodes/decides the endianess, so I fail to see why we
> need to store endianess also in the templates (f.e. meta_templates[],
> it just seems 100% redundant ...)
> 
> Thats why it I added this host endian thing here, we could then replace
> 
> [NFT_META_CPU]  = META_TEMPLATE("cpu", &integer_type, 4 * BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
> with
> [NFT_META_CPU]  = META_TEMPLATE("cpu", &integer_u32, 4 * BITS_PER_BYTE),
>
> and don't need this 'endianess override' in the templates anymore.
> We might even be able to get rid of the endianess storage in the eval
> context this way.
> 
> What am I missing?

This approach will not work for more stuff coming ahead, eg.
concatenation support for integer datatypes. This currently doesn't
work since nft complains on concatenation with datatypes with not
fixed datatypes.

In that case, we will end up having integers of different sizes and
byteorder. We would need one hardcoded type for each variant.

Note that these TYPE_XYZ are ABI too, so we should avoid changes once
we push them into nftables.git. We also have a limited number of them,
6 bits since concatenations places up to 5 datatypes there using bit
shifts.

I understand the override is not nice, that's one of the reasons why I
did not push this yet. Probably we can allocate datatype instances
dynamically, so we don't need this new field.
