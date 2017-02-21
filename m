From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Tue, 21 Feb 2017 16:54:35 +0100
Message-ID: <20170221155435.GA5392@salvia>
References: <20170208221429.3555-1-fw@strlen.de>
 <20170221140909.GA3286@salvia>
 <20170221144019.GD9708@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57464 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbdBUPyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2017 10:54:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D95D1A7DC1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 16:54:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9324DA847
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 16:54:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1E12DA84B
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 16:54:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170221144019.GD9708@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 21, 2017 at 03:40:19PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Feb 08, 2017 at 11:14:29PM +0100, Florian Westphal wrote:
> > > The comment is incorrect, this function does see fragments when
> > > IP_NODEFRAG is used.  Remove the wrong assertion.
> > > 
> > > As conntrack doesn't track fragments skb->nfct will be null
> > > and no nat is performed.
> > 
> > With IP_NODEFRAG, ipv4_conntrack_defrag() will just accept the packet.
> > 
> > So the first fragment will get into nf_conntrack_in(), and I think, if
> > enough information is there in place, it will get a ct object.
> 
> ipv4_get_l4proto():
>        if (iph->frag_off & htons(IP_OFFSET))
>               return -NF_ACCEPT;
> 
> so yes, you are right, first packet will be tracked in this case.

With NAT in place, this also means the first packet of a flow gets
mangled, while follow up don't.

Probably change that spot above to use ip_is_fragment()?

> > up fragments with offset != 0 which doesn't contain headers will
> > definitely not get a ct object.
> > 
> > Shouldn't handle case this by attaching a template conntrack?
> > Currently this IP_NODEFRAG case is going through as invalid traffic.
> > 
> > My impression is that we're handling this case in a sloppy way, am I
> > missing anything?
> 
> What would you do instead?
> 
> We currently have a suboptimal handling of such cases, but I don't see
> how we can change it without (possibly) breaking existing setups.

AFAIK, only IP_NODEFRAG locally generated packets would get affected.
I wonder how this option is used (network testing?). I cannot come up
with any reasonable stateful ruleset that may work with this. With a
stateful ruleset in place, the first packet will go through and follow
up would be INVALID. There are tons of rulesets outthere simply
logging and dropping invalid ones.

Look, the first packet create an entry in SYN_SENT state, that just
expires later on.

> I also don't see how alternative handling is 'better'.

We could just handle all the packets in a flow in the same way, so
they all go through INVALID.
