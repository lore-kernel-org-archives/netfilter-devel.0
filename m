From: "Sarbeswar Mohapatra" <Sarbeswar.Mohapatra@nethawkgroup.com>
Subject: Packet forwarding using netfilter
Date: Wed, 30 May 2007 22:15:43 -0500
Message-ID: <003701c7a331$fa5b9760$9f0201c0@nethawk.fi>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,
Can anybody help me, how to forward the incoming packets to another machine
using PRE_ROUTING hook (case-1 through the same interface the packet came
in, case-2 through a different interface).
In case of case-2, I tried turning on the ip forwarding option in (echo 1 >
/proc/sys/net/ipv4/ip_forward), but no luck. Basically the packet probably
gets discarded in ip_receive_finish function, but not sure.

Here is the sample code, where after receiveing the packet in the hook, the
ip address is changed (skb->nh.ip->saddr = xxx, skb->nh.ip->daddr = yyyy)
and the route is updated,
     struct flowi fl;

     fl.nl_u.ip4_u.daddr = xxx;
     fl.nl_u.ip4_u.saddr = yyy;
     fl.nl_u.ip4_u.tos = 5;

    (*skb)->nfcache |= NFC_IP_SRC;
    (*skb)->nfcache |= NFC_IP_DST;
    (*skb)->nfcache |= NFC_ALTERED;

    if (ip_route_output_key(&rt, &fl) < 0)
    {
        printk("No output route ...\n");
        return -1;
    }
    else
    {
        if ((*skb)->dst)
            dst_release((*skb)->dst);
        (*skb)->dst = dst_clone(&rt->u.dst);
        (*skb)->dev = rt->u.dst.dev;
        ip_rt_put(rt);
    }

Regards,
Sarbeswar
