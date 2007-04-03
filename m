From: Amin Azez <azez@ufomechanic.net>
Subject: rcu_read_unlock missing? dumb question
Date: Tue, 03 Apr 2007 14:43:52 +0100
Message-ID: <eutlm7$dem$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

In ipv4/route.c

It looks like we return on cache hit without calling rcu_read_unlock.
Does this matter?


int ip_route_input(struct sk_buff *skb, u32 daddr, u32 saddr,
                   u8 tos, struct net_device *dev)
{
        struct rtable * rth;
        unsigned        hash;
        int iif = dev->ifindex;

        tos &= IPTOS_RT_MASK;
        hash = rt_hash_code(daddr, saddr ^ (iif << 5));

        rcu_read_lock();
        for (rth = rcu_dereference(rt_hash_table[hash].chain); rth;
             rth = rcu_dereference(rth->u.rt_next)) {
                if (rth->fl.fl4_dst == daddr &&
                    rth->fl.fl4_src == saddr &&
                    rth->fl.iif == iif &&
                    rth->fl.oif == 0 &&
#ifdef CONFIG_IP_ROUTE_FWMARK
                    rth->fl.fl4_fwmark == skb->nfmark &&
#endif
                    rth->fl.fl4_tos == tos) {
                        rth->u.dst.lastuse = jiffies;
                        dst_hold(&rth->u.dst);
                        rth->u.dst.__use++;
                        RT_CACHE_STAT_INC(in_hit);
                        rcu_read_unlock();
                        skb->dst = (struct dst_entry*)rth;
                        return 0;
                }
                RT_CACHE_STAT_INC(in_hlist_search);
        }
        rcu_read_unlock();

...

Also, I note:
skb->dst = (struct dst_entry*)rth;

It is a shame that an rtable* is being cast as a dst_entry* as it loses
the routed gateway ip address, something which really needs to be known
for SNAT matches if we are to avoid repeating much of the routing table
in the SNAT match, because generally the SNAT match is a function of the
original source address, the router being used and the return routes in
the upstream routers. -i.e. we generally SNAT because otherwise the
upstream router won't be able to route back to us.

It's enough that the SNAT match has to encapsulate knowledge of the
upstream routers routing tables, but quite unnecessary for it to have to
 encapsulate knowledge of it's own routing tables; it ought to be able
to check which device/gateway it has been routed to.

So as you might guess I'm working on a way to convey the routed entry as
an iptables match. I'm also wondering if the route ought to be attached
to the conntrack (2 routes, one for each flow) - how would that be for
cached routes? It would help load balancing to work better too, as once
a route is chosen it will remain for that flow but a balanced gateway
can easily be chosen for the next connection. I'm I talking rubbish? (It
only makes sense for network edge routers of course when you will really
really lose a flow when the route changes)

Sam
