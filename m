From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] SIP conntrack handler and TCP fragmentation
Date: Wed, 12 Oct 2016 09:52:12 +0200
Message-ID: <20161012075212.GA26177@breakpoint.cc>
References: <c92b64f3-9f69-eb7c-402c-3e489f73a527@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Ulrich Weber <ulrich.weber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34958 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753141AbcJLIRJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 04:17:09 -0400
Content-Disposition: inline
In-Reply-To: <c92b64f3-9f69-eb7c-402c-3e489f73a527@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ulrich Weber <ulrich.weber@gmail.com> wrote:
> we had a customer with a Cisco Phone using SIP over TCP
> which subscribed to 15 Phone numbers.
> 
> Since 15 subscribe calls dont fit in one packet, these
> requests were fragmented in multiple TCP packets.
> 
> One of these fragments gets rejected then by nf_conntrack_sip with:
> nf_ct_sip: dropping packet: cannot parse cseq
> 
> The Cisco phone will send retransmits, which got dropped too,
> times out after some time, reconnects and same games
> starts again...
> 
> I know the proper solution would be TCP defragmentation
> in the nf_conntrack_sip kernel module. However I'm not
> sure if this is worth the effort.

I think an even better solution would be a SIP proxy that can
inject expectations to keep datapath in kernel and only deals with
the signalling traffic.

> What about just accepting unparsable TCP SIP packets?

I wonder why this patch did not fix your problem:

3a7b21eaf4fb3c971bdb47a98f570550ddfe4471
Author: Patrick McHardy <kaber@trash.net>
netfilter: nf_ct_sip: don't drop packets with offsets pointing outside the packet

It specifically deals with this problem (l7 size larger than packet
size).

