From: Leen Besselink <leen@wirehub.nl>
Subject: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Sun, 13 Apr 2003 20:53:43 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.21.0304132035370.31823-100000@debian.besselink>
Reply-To: leen@wirehub.nl
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi netfilter-hackers,

OK, first the situation...

I use policy routing to decide (based on the from-address) on what
out-interface to send a packet (and thus a different sender IP-address and
gateway).

But... when I use reject-with tcp-reset, for a port on a host on the
network behind my firewall, the tcp-reset-packet goes over the wrong
interface.

I looked at the code and it looks like a bug to me, but there is a
comment, maybe there is a good reason not to:

        /* Routing: if not headed for us, route won't like source */
        if (ip_route_output(&rt, nskb->nh.iph->daddr,
                            local ? nskb->nh.iph->saddr : 0,
                            RT_TOS(nskb->nh.iph->tos) | RTO_CONN,
                            0) != 0)
                goto free_nskb;

If it's not a local destinated-packet it sends the sender-address to 0
when making the routing decision (probably 0.0.0.0 ?).

The calling code for send_reset sets local:

        case IPT_TCP_RESET:
                send_reset(*pskb, hooknum == NF_IP_LOCAL_IN);

When I use the send_unreach (for example with: icmp_host_unreachable),
this is not done and thus the source-based routing rules have effect:

        if (ip_route_output(&rt, iph->saddr, saddr, RT_TOS(tos), 0))
                return;

So, I think the 'local ? nskb->nh.iph->saddr : 0' can actually be
removed, am I right ?

But if there is a good reason, then I don't understand why it's not doing
the same thing for an unreachable, maybe that needs fixing instead then.

Any help would be greatly appreciated and tia,
	Leen.
_____________________________________
New things are always on the horizon.
