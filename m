From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnfct 2/2] conntrack: revert getobjopt_is_nat condition
Date: Tue, 28 Feb 2017 12:48:09 +0100
Message-ID: <20170228114809.GA19880@salvia>
References: <20170228045359.GA21582@gmail.com>
 <20170228050041.GC21582@gmail.com>
 <20170228104725.GB1517@salvia>
 <20170228114453.GA22524@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
        <netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34970 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751660AbdB1LsX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 06:48:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4DCA62471D
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:48:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EBAADA807
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:48:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0835BDA7E0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:48:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170228114453.GA22524@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 28, 2017 at 08:44:53PM +0900, Ken-ichirou MATSUZAWA wrote:
>  Hi, Pablo
> 
> On Tue, Feb 28, 2017 at 11:47:25AM +0100, Pablo Neira Ayuso wrote:
> > > diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
> > > index fb43d6c..1581480 100644
> > > --- a/src/conntrack/objopt.c
> > > +++ b/src/conntrack/objopt.c
> > > @@ -144,10 +144,8 @@ int __setobjopt(struct nf_conntrack *ct, unsigned int option)
> > >  
> > >  static int getobjopt_is_snat(const struct nf_conntrack *ct)
> > >  {
> > > -	if (!(test_bit(ATTR_STATUS, ct->head.set)))
> > > -		return 0;
> > > -
> > > -	if (!(ct->status & IPS_SRC_NAT_DONE))
> > > +	if (test_bit(ATTR_STATUS, ct->head.set) &&
> > > +	    !(ct->status & IPS_SRC_NAT_DONE))
> > 
> > However, if ATTR_STATUS is not set, we keep checking ahead. What are
> > you trying to fix?
> 
> It was:
> 
> -       return ((test_bit(ATTR_STATUS, ct->head.set) ?
> -               ct->status & IPS_SRC_NAT_DONE : 1) &&
> -               ct->repl.dst.v4 !=
> -               ct->head.orig.src.v4);
> 
> I thought it keeps checking even ATTR_STATUS is not set.
> But it's ok not to apply, returning false in case of
> ATTR_STATUS is not set.

Ah, I see.

static int getobjopt_is_snat(const struct nf_conntrack *ct)
{
        if (!(test_bit(ATTR_STATUS, ct->head.set)))
                return 0;

        if (!(ct->status & IPS_SRC_NAT_DONE))
                return 0;

        switch (ct->head.orig.l3protonum) {
        case AF_INET:
                return ct->repl.dst.v4 != ct->head.orig.src.v4;
        case AF_INET6:
                if (memcmp(&ct->repl.dst.v6, &ct->head.orig.src.v6,
                           sizeof(struct in6_addr)) != 0)
                        return 1;
                else
                        return 0;
        default:
                return 0;
        }
}

So you want to check if the addresses mismatch, so we infer from there
if there is NAT or not when status bits are not available.

Are you trying to catch up some case in netlink event specifically?

Thanks for explaining.
