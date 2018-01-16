From: Florian Westphal <fw@strlen.de>
Subject: Re: conntrack enhancement
Date: Tue, 16 Jan 2018 15:17:12 +0100
Message-ID: <20180116141712.GC15198@breakpoint.cc>
References: <89a1d74339b14c6e813ccbea864c24e0@svr-chch-ex1.atlnz.lc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jack Ma <Jack.Ma@alliedtelesis.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46880 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750890AbeAPOTn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 09:19:43 -0500
Content-Disposition: inline
In-Reply-To: <89a1d74339b14c6e813ccbea864c24e0@svr-chch-ex1.atlnz.lc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jack Ma <Jack.Ma@alliedtelesis.co.nz> wrote:
> Hi there,
> 
> I am planing to add new user option to allow connmark to be shifted to enable more advanced routing options.
> 
> Currently, it might be something like:
> 
> Conntrack parameters and options:
>  
> -sl, --shift-left bits                      shift mark by n bit to the left
> -sr, --shift-right bits                    shift mark by n bit to the right.
> 
> We run out of nfmark (skb->mark) in our systems due to increasing number of routes we are supporting.

I suspect this is for -j CONNMARK  --restore-mark / --save-mark ?

What would this do?

Something like

skb->mark = ct->mark >> $lshift; ?
ct->mark = skb->mark >> $lshift; ?

I don't really understand how this is supposed to work.
Could you elaborate a bit?

Thanks.
