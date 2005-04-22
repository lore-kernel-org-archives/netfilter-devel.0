From: Pawel Sikora <pluto@pld-linux.org>
Subject: Re: [PATCH] Warning: "nd_tbl" [net/ipv6/netfilter/ip6t_ROUTE.ko]
	undefined!
Date: Fri, 22 Apr 2005 17:00:33 +0200
Message-ID: <200504221700.33444.pluto@pld-linux.org>
References: <200504221331.27454.pluto@pld-linux.org>
	<20050422.205957.47968472.yoshfuji@linux-ipv6.org>
	<20050422.210704.52375730.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050422.210704.52375730.yoshfuji@linux-ipv6.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Friday 22 of April 2005 14:07, you wrote:

<yoshfuji@linux-ipv6.org> says:
> > I disagree. Please try not to use nd_tbl;
> > maybe, by making and exporting neigh_lookup().
>
> Oops, ndisc_lookup().

I dont see ndisc_lookup() in 2.6.11.7 sources.

ip6t_ROUTE uses ndisc_get_neigh from include/net/ndisc.h.

[ ip6t_ROUTE.c ]
rt->u.dst.neighbour = ndisc_get_neigh(rt->u.dst.dev, &rt->rt6i_dst.addr);


[ include/net/ndisc.h ]
static inline struct neighbour * ndisc_get_neigh(struct net_device *dev,
                                                 struct in6_addr *addr)
{
    if (dev)
        return __neigh_lookup(&nd_tbl, addr, dev, 1);
                               ^^^^^^ this symbol should be exported
                                      or this method should be reworked.

    return NULL;
}

--
/* Copyright (C) 2003, SCO, Inc. This is valuable Intellectual Property. */

                           #define say(x) lie(x)

-------------------------------------------------------

-- 
/* Copyright (C) 2003, SCO, Inc. This is valuable Intellectual Property. */

                           #define say(x) lie(x)
