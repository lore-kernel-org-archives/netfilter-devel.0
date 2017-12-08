From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/3] netfilter: core: only allow one nat hook per
 hook point
Date: Fri, 8 Dec 2017 22:33:31 +0100
Message-ID: <20171208213331.GA4518@salvia>
References: <20171208160155.968-1-fw@strlen.de>
 <20171208160155.968-3-fw@strlen.de>
 <20171208212828.GB4348@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35562 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750951AbdLHVdf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 16:33:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34EB01C4386
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:33:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28CB1DA804
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:33:34 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171208212828.GB4348@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 08, 2017 at 10:28:28PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 08, 2017 at 05:01:54PM +0100, Florian Westphal wrote:
[...]
> > diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
> > index a1a07b338ccf..0f7255cc65ee 100644
> > --- a/net/ipv4/netfilter/iptable_nat.c
> > +++ b/net/ipv4/netfilter/iptable_nat.c
> > @@ -72,6 +72,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
> >  	{
> >  		.hook		= iptable_nat_ipv4_in,
> >  		.pf		= NFPROTO_IPV4,
> > +		.nat_hook	= true,
> 
> Just a suggestion: This nat_hook basically means that we only allow
> this hook to be a singleton in this spot. So I would call it like
> this, ie. singleton, given we have no NAT semantics in the netfilter
> core.

Hm, never mind about names.
