From: Chris Wilson <chris@netservers.co.uk>
Subject: ROUTE and MASQUERADE don't work together
Date: Fri, 28 May 2004 17:41:25 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405281722570.26979@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: delaunois@info.ucl.ac.be
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I think I've discovered a problem when the ROUTE and MASQUERADE targets 
are used together. It prevents the re-ROUTEd packets from being 
masqueraded properly. They get masqueraded to the same address that they 
would have done if the packet had not been re-ROUTEd, not to the address 
of the new outbound interface.

The ROUTE target does a route lookup to find the appropriate new 
destination route, and updates skb->dst and skb->dev:

        struct rt_key key = {
                dst:iph->daddr,
                src:0,
                oif:ifindex,
                tos:RT_TOS(iph->tos)
        };
	...
        if ((err = ip_route_output_key(&rt, &key))) {
		... return -1;
	}
	...	
        /* Success if no oif specified or if the oif correspond to the
         * one desired */
        if (!ifindex || rt->u.dst.dev->ifindex == ifindex) {
                skb->dst = &rt->u.dst;
                skb->dev = skb->dst->dev;
                return 1;
        }

However, the MASQUERADE target does not use this new information. Instead 
it does another route lookup, and uses the returned source address as the 
address for masquerading:

        key.dst = (*pskb)->nh.iph->daddr;
        key.src = 0; /* Unknown: that's what we're trying to establish */
        key.tos = RT_TOS((*pskb)->nh.iph->tos)|RTO_CONN;
        key.oif = 0;
	...
        if (ip_route_output_key(&rt, &key) != 0) {
		... return NF_DROP;
        }
        if (rt->u.dst.dev != out) {
		... return NF_DROP;
	}
        newsrc = rt->rt_src;

Thus, the packet will leave the new interface, but with the old 
interface's IP address as its source.

While I can understand that this is part of the power of iptables :-), it 
nevertheless means that you can't easily use ROUTE to send your traffic 
out of a device with a dynamic address (say a dialup PPP connection or an 
ADSL interface).

I tried to fix it by adding a field to struct skbuff to cache the route
information looked up in ipt_ROUTE.c, and use that (if present) instead of
doing a route lookup in ipt_MASQUERADE.c. However, this caused a number of
other problems:

*   Locally generated traffic isn't masqueraded, so you can't ping 
    from the iptables box to test your ROUTE/MASQUERADE combination. 
    See ipt_MASQUERADE.c:

        /* FIXME: For the moment, don't do local packets, breaks
           testsuite for 2.3.49 --RR */
        if ((*pskb)->sk)
                return NF_ACCEPT;

    Does anyone know what test was being failed here?

*   I removed the above test, and sometimes locally generated traffic 
    comes out with a source of 0.0.0.0, I don't know why yet.

*   Also, the kernel randomly crashes with "Unable to handle kernel paging 
    request at virtual address 20000017" (the address changes, and this 
    may not be related, as I'm developing a new module at the same time).

Does anyone have any ideas for a better fix for this problem? If not, I 
can submit my patch, but I don't really trust it yet.

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
