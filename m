From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables rules not matching after upgrading from 0.7 to 0.8
Date: Thu, 26 Oct 2017 01:44:49 +0200
Message-ID: <20171025234449.GA4084@salvia>
References: <1508949114.1154.14.camel@cohaesio.com>
 <20171025175725.GJ19457@breakpoint.cc>
 <1508955630.25035.13.camel@cohaesio.com>
 <1508970133.25035.24.camel@cohaesio.com>
 <20171025224536.GK19457@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbdJYXoy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 19:44:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C751CE0425
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2017 01:44:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B846DDA872
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2017 01:44:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171025224536.GK19457@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 26, 2017 at 12:45:36AM +0200, Florian Westphal wrote:
> Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
> > On ons, 2017-10-25 at 20:20 +0200, Anders K. Pedersen | Cohaesio wrote:
> > > On ons, 2017-10-25 at 19:57 +0200, Florian Westphal wrote:
> > > > Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
[...]
> > If I use 0.8 to dump the rule set that was loaded with 0.7, I get the
> > correct rule set except for a difference with regards to sets and maps
> > that use interfaces like:
> > 
> > --- nft-0.7-0.8 rule set loaded with 0.7 and dumped with 0.8
> > +++ nft-0.8     same rule set loaded and dumped with 0.8
> > @@ -9,12 +9,12 @@
> >         chain prerouting {
> >                 type filter hook prerouting priority -100; policy accept;
> >                 iif "lo" accept
> > -               ct mark set iif map { 33554432 : 0x00000001, 67108864 : 0x00000002 }
> > +               ct mark set iif map { "eth0" : 0x00000001, "eth2" : 0x00000002 }
> >                 iif "eth1" jump prerouting_internal
> > -               iif { 33554432, 67108864 } ip saddr { 0.0.0.0/8, 10.0.0.0/8, 127.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0-255.255.255.255 } counter packets 6 bytes 705 drop
> > +               iif { "eth0", "eth2" } ip saddr { 0.0.0.0/8, 10.0.0.0/8, 127.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 224.0.0.0-255.255.255.255 } counter packets 0 bytes 0 drop
> 
> I will look at this too.

This difference in the way things are dump is related to this:

commit b9b6092304aef17fea704c25b3d9d7dcdb3995a5
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Fri Feb 24 20:47:49 2017 +0100

    evaluate: store byteorder for set keys

To my understanding, byteorder was not OK in 0.7.

Are these maps not matching anymore or is just the dump theat is
different?

Thanks!
