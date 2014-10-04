From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf next 0/3] bridge: netfilter: fix handling of ipv4 packets w. options
Date: Sat,  4 Oct 2014 03:04:27 +0200
Message-ID: <1412384670-17794-1-git-send-email-fw@strlen.de>
Cc: bsd@redhat.com, stephen@networkplumber.org, netdev@cger.kernel.org,
	herbert@gondor.apana.org.au, eric.dumazet@gmail.com,
	davidn@davidnewall.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43347 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756304AbaJDBFJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 21:05:09 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Newall reported that bridge causes bad checksums:
http://thread.gmane.org/gmane.linux.network/315705/focus=1706769

The proposal was to revert
462fb2af9788a82a5 (bridge : Sanitize skb before it enters the IP stack).

However, this has some other adverse effects since bridge netfilter
and ip stack both use skb->cb (and we thus memset skb->cb whenever
we hand skb off to the ip stack).

So, this series attemps to resolve this a bit differently.

First, lets add the inet_param padding that Eric suggested previously.
This means that any earlier setup of IPCB will be preserved inside the
bridge layer.

This is also useful for netfilter since it will preserve
IPCB(skb)->frag_max_size set up by ip defrag.

Second, this gets rid of the option parsing/memset calls in
to forward and output cases.

Third, the pre-routing path is changed to not mangle the packets
but to only validate the ip options.

This patch series is vs. next instead of net/nf tree.

This has been broken for so long that I don't think we need
to rush this.

