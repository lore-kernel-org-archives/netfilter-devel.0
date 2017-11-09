From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] net/icmp: restore source address if packet is NATed
Date: Thu, 9 Nov 2017 01:01:34 +0100
Message-ID: <20171109000134.GC5512@breakpoint.cc>
References: <CAHmME9rapx6z1T76ik2vhF0bBotVy+GFkTTDY810aNso7ViV5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59308 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752644AbdKIACN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2017 19:02:13 -0500
Content-Disposition: inline
In-Reply-To: <CAHmME9rapx6z1T76ik2vhF0bBotVy+GFkTTDY810aNso7ViV5w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> When I sent this to netdev back in June, Dave pointed out how horrible
> this is, since it breaks all sorts of layering. The result of that
> discussion was that something like this -- the backwards
> transformation and the correct rate limiting -- belongs inside
> netfilter and not polluting the icmp code directly. He ended by
> telling me, "I highly encourage you to continue pursuing the netfilter
> based approach, and to also discuss it on netfilter-devel which will
> hit more capable minds than just here on netdev." So, a few months
> late, I'm forwarding this email here, in case anybody is interested.

If I understand this correctly this cannot be fixed inside netfilter.

> Most of the time, the icmp_send and icmpv6_send routines can just reach
> down into the skb's IP header to determine the saddr. However, if
> icmp_send or icmpv6_send is being called from a network device driver --

There you have it.
Why TF do network drivers send icmp error messages from
ndo_start_xmit()?!

> there are a few in the tree -- then it's possible that by the time
> icmp_send or icmpv6_send looks at the packet, the packet's source
> address has already been transformed by SNAT or MASQUERADE or some other
> transformation that CONNTRACK knows about. In this case, the packet's
> source address is most certainly the *wrong* source address to be used
> for the purpose of ICMP replies.

Right.  But then, *iff* you want to send packets in response to packets
fed to ndo_start_xmit then you only have 2.5 choices:

1. accept that you will send it to wrong destination if snat was applied
2. something like your patch
3. add a icmp_ndo_xmit helper (variant of 2) to keep the nfct query out
of normal stacsks icmp_send function.

I think correct solution is to never allow drivers to do something like
this.  What is the use case here? Normal IP stack should send
imcp/pkttobig errors, and that will work fine since it occurs pre-snat.

