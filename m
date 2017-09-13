From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: does nftables support string match?
Date: Wed, 13 Sep 2017 14:47:45 +0200
Message-ID: <20170913124745.GA2943@salvia>
References: <CAMXhvOCwO49YmLAnEthGGifMZbdSgw2+vR6Pdp3o4cW-XaVjAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Michael Chi <chibo.michael@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:49301 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdIMMsJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2017 08:48:09 -0400
Content-Disposition: inline
In-Reply-To: <CAMXhvOCwO49YmLAnEthGGifMZbdSgw2+vR6Pdp3o4cW-XaVjAQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cc'ing Florian,

On Wed, Sep 13, 2017 at 08:13:38PM +0800, Michael Chi wrote:
> Hi experts,
> 
> We are using nftables instead of iptables, but after I have search all
> the nftables documents I found, I don't find a corresponding match
> that can match string in packet, like following in iptables:
> iptables -A INPUT -m string --string 'badstring' -j DROP
> 
> Is such function supported by nftables?

I remember he's got a patch to add support for this, still to be
upstreamed.

Moreover, I started on a patchset to add a new application layer
offset that we discussed during NFWS:

https://workshop.netfilter.org/2017/wiki/images/8/8c/Nft-l7.pdf

So we can solve the existing limitation in iptables, since we start
matching after IP header offset.
