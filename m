From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] doc: payload and conntrack statement
Date: Fri, 9 Sep 2016 01:49:44 +0200
Message-ID: <20160908234944.GC26062@breakpoint.cc>
References: <1473373016-24078-1-git-send-email-fw@strlen.de>
 <1473373016-24078-2-git-send-email-fw@strlen.de>
 <20160908223015.GB29687@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        nevola@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46758 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750714AbcIHXts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 19:49:48 -0400
Content-Disposition: inline
In-Reply-To: <20160908223015.GB29687@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 09, 2016 at 12:16:56AM +0200, Florian Westphal wrote:
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> BTW, related to payload mangling, Laura sent me this report:
> 
> When adding this rule:
> 
>   # nft add rule netdev filter ingress \
>         ip daddr 192.168.0.92 tcp dport 80 \
>         ether daddr set 00:03:2d:2b:74:ec fwd to enp3s0
> 
> The listing shows:
> 
>   # nft list ruleset
>   table netdev filter {
>       chain ingress {
>          type filter hook ingress device enp0s25 priority 0; policy accept;
>          ip daddr 192.168.0.92 tcp dport http ether daddr set ec:74:2b:2d:03:00 fwd to "enp3s0"
>                                                               ^^^^^^^^^^^^^^^^^
> 
> Note that the MAC address is reversed, probably something wrong in the
> delinearize path. In case you have some spare cycle, I didn't look at
> this yet.

Too late for now, but it looks like the postprocessing
for payload statements does not set byteorder of the immediate value
(its 0/undefined).

For ip addresses this doesn't matter as 0 is treated like BIG_ENDIAN.
But ether_addr is set as HOST_ENDIAN.

The normal payload expression path contains conversion calls for this
case:

if (tmp->byteorder == BYTEORDER_HOST_ENDIAN)
           mpz_switch_byteorder(tmp->value, tmp->len / BITS_PER_BYTE);

Will check more later today.
