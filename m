From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] x_table: align per cpu xt_counter
Date: Wed, 17 Jun 2015 19:08:15 +0200
Message-ID: <20150617170815.GF31987@breakpoint.cc>
References: <1434417013.27504.161.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434417013.27504.161.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Let's force a 16 bytes alignment on xt_counter percpu allocations,
> so that bytes and packets sit in same cache line.
> 
> xt_counter being exported to user space, we cannot add __align(16) on
> the structure itself.

Sorry, I was away.  Looks great.

Acked-by: Florian Westphal <fw@strlen.de>
