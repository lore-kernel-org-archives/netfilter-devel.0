From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nf-next] netfilter: ct: add helper assignment support
Date: Thu, 16 Feb 2017 14:24:14 +0100
Message-ID: <20170216132414.GA2141@salvia>
References: <20170215162536.982-1-fw@strlen.de>
 <20170215170558.GA22564@salvia>
 <20170215221903.GB32431@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753869AbdBPNYa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 08:24:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C168242948
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2017 14:24:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DDA3DA847
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2017 14:24:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E39FDA7F7
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Feb 2017 14:24:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170215221903.GB32431@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 15, 2017 at 11:19:03PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Note from myself, i dislike L3PROTO, it would be nicer to be able
> > > to handle this via the table family but I did not yet find a way
> > > to detect this from the obj->init() function.
> > 
> > We can pass nft_ctx to obj->init().
> 
> OK, I can make that change then, no problem.
> 
> > > Its needed for nf_conntrack_helper_try_module_get().
> > > 
> > > This also begs the question of how one would handle
> > > NFPROTO_INET, in that case we'd want both v4 and v6, but that
> > > would require stashing two struct nf_conntrack_helper in
> > > priv area.
> > 
> > Still, someone may want to only enable helper for IPv4 in the inet
> > chain, right? It's a bit of corner case but this attribute provides
> > slight more flexibility.
> 
> But assignment can be limited via nft ... meta nfproto ipv4, no?

Right, that's a possible solution to restrict this. Downside is that
we have some slight packet runtime cost, since we have to evaluate
this extra expression in the rule for each packet.

Another aspect is that we end up having part of the helper
configuration spread between the helper definition and the rule, given
that l4proto would restrict setting the helper to the transport
protocol and that is set from the helper definition itself.

>From a user perspective, we can just hide this detail by infering it
from context around if not specified, so:

table ip x {
        helper "ftp" {
                type "ftp"
                l4proto tcp
        }
}

So in this case:

table inet x {
        helper "ftp" {
                type "ftp"
                l4proto tcp
        }
}

We register it for both ip and ip6.

In this case, with explicit layer 3 protocol:

table bridge x {
        helper "ftp" {
                type "ftp"
                protocol ip
                l4proto tcp
        }
}

>From helper ->eval() we could just skip traffic that is neither IPv4
at layer 3 nor TCP at layer 4 without having to add this dependency.

If protocol specified in helper for bridge, then default to
NFPROTO_INET, ie. both enabled.

So yes, I'm still proposing to keep with that layer 3 attribute
around. What do you think?
