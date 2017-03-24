From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] src: allow update of net base w. meta l4proto icmpv6
Date: Fri, 24 Mar 2017 13:21:12 +0100
Message-ID: <20170324122112.GG10418@breakpoint.cc>
References: <20170321185437.22959-1-fw@strlen.de>
 <20170322130902.GA21742@salvia>
 <20170322134412.GA8584@breakpoint.cc>
 <20170322152909.GA22809@salvia>
 <20170322153204.GA22898@salvia>
 <20170322154400.GB8584@breakpoint.cc>
 <20170322160726.GA23136@salvia>
 <20170322192252.GC8584@breakpoint.cc>
 <20170324115021.GA2515@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38380 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964908AbdCXMVx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 08:21:53 -0400
Content-Disposition: inline
In-Reply-To: <20170324115021.GA2515@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> We can just use NFT_META_L4PROTO all the time, so we use it from IPv4
> too, right?

Right, we can indeed do that and change ip as well.
