From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_fwd_netdev: allow to forward
 packets via neighbour layer
Date: Fri, 10 Nov 2017 09:11:37 +0100
Message-ID: <20171110081137.GG5512@breakpoint.cc>
References: <20171110071046.6221-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38072 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751243AbdKJIMR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 03:12:17 -0500
Content-Disposition: inline
In-Reply-To: <20171110071046.6221-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This allows us to forward packets from the netdev family via neighbour
> layer, so you don't need an explicit link-layer destination when using
> this expression from rules.

Should this decrement ttl?
Or should we add extra expression for that?
