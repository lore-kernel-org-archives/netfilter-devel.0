From: Florian Westphal <fw@strlen.de>
Subject: Re: shift by n bits while performing '--restore-mark'
Date: Wed, 7 Feb 2018 00:53:57 +0100
Message-ID: <20180206235357.GB14261@breakpoint.cc>
References: <89a1d74339b14c6e813ccbea864c24e0@svr-chch-ex1.atlnz.lc>
 <20180116141712.GC15198@breakpoint.cc>
 <1516847646457.65736@alliedtelesis.co.nz>
 <20180125062211.GE14192@breakpoint.cc>
 <1517960766867.47573@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jack Ma <Jack.Ma@alliedtelesis.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36924 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754095AbeBFX5C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 18:57:02 -0500
Content-Disposition: inline
In-Reply-To: <1517960766867.47573@alliedtelesis.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jack Ma <Jack.Ma@alliedtelesis.co.nz> wrote:
> Our current condition is:
> 
> 1) only 0xfff00000 (three F available in skb->mark), but 0xfffff000 (five F available in ct->mark)
> 
> We wish to copy either 0xfff00000 or 0x00fff000 from ct->mark into skb->mark,
> 
> 
> What about '-j CONNMARK  --restore-mark --mask 0xfffff000 << 8 ( left shift 2 F)'
> 
> This will result in skb->mark = ct->mark << 8
> 
> if ct->mark = 0xabcde000, now skb->mark is changed to:  skb->mark = 0xcde00000.
> 
> Does this make sense :) ?

Yes it does.

AFAICS with nftables you could already do this but I can understand if
you need to use iptables for this.

So feel free to send a patch from xt_connmark.

Thanks for explaining this.
