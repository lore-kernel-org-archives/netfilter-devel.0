From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v1] netfilter: provide input interface for route
 lookup for rpfilter
Date: Wed, 23 May 2018 09:26:34 +0200
Message-ID: <20180523072634.ir37ska2f7eswznz@salvia>
References: <20180520110338.9376-1-vincent@bernat.im>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Vincent Bernat <vincent@bernat.im>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180520110338.9376-1-vincent@bernat.im>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, May 20, 2018 at 01:03:38PM +0200, Vincent Bernat wrote:
> In commit 47b7e7f82802, this bit was removed at the same time the
> RT6_LOOKUP_F_IFACE flag was removed. However, it is needed when
> link-local addresses are used, which is a very common case: when
> packets are routed, neighbor solicitations are done using link-local
> addresses. For example, the following neighbor solicitation is not
> matched by "-m rpfilter":
> 
>     IP6 fe80::5254:33ff:fe00:1 > ff02::1:ff00:3: ICMP6, neighbor
>     solicitation, who has 2001:db8::5254:33ff:fe00:3, length 32
> 
> Commit 47b7e7f82802 doesn't quite explain why we shouldn't use
> RT6_LOOKUP_F_IFACE in the rpfilter case. I suppose the interface check
> later in the function would make it redundant. However, the remaining
> of the routing code is using RT6_LOOKUP_F_IFACE when there is no
> source address (which matches rpfilter's case with a non-unicast
> destination, like with neighbor solicitation).

Applied, thanks Vincent.
