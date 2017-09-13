From: Florian Westphal <fw@strlen.de>
Subject: Re: does nftables support string match?
Date: Wed, 13 Sep 2017 14:54:20 +0200
Message-ID: <20170913125420.GA2453@breakpoint.cc>
References: <CAMXhvOCwO49YmLAnEthGGifMZbdSgw2+vR6Pdp3o4cW-XaVjAQ@mail.gmail.com>
 <20170913124745.GA2943@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Chi <chibo.michael@gmail.com>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60036 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751120AbdIMM53 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2017 08:57:29 -0400
Content-Disposition: inline
In-Reply-To: <20170913124745.GA2943@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Cc'ing Florian,
> 
> On Wed, Sep 13, 2017 at 08:13:38PM +0800, Michael Chi wrote:
> > Hi experts,
> > 
> > We are using nftables instead of iptables, but after I have search all
> > the nftables documents I found, I don't find a corresponding match
> > that can match string in packet, like following in iptables:
> > iptables -A INPUT -m string --string 'badstring' -j DROP
> > 
> > Is such function supported by nftables?
> 
> I remember he's got a patch to add support for this, still to be
> upstreamed.

The decision at nfws was to not upstream this, iirc, due to the fact
that this mandates linear evaluation.  Instead we talked about adding
application offset.

> Moreover, I started on a patchset to add a new application layer
> offset that we discussed during NFWS:
> 
> https://workshop.netfilter.org/2017/wiki/images/8/8c/Nft-l7.pdf
> 
> So we can solve the existing limitation in iptables, since we start
> matching after IP header offset.

Right.  IIRC you also planned to add some way to describe the userspace
headers including ability to skip variable-sized content or search for
a start-marker so one could e.g. move to a particular offset and then
extract content.

This would allow to combine it with set lookups, and just have a set of
strings to do a lookup in.

Michael, what are you trying to match? dns lookups? tls sni hostname?
