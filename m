From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: rcu_read_unlock missing? dumb question
Date: Tue, 3 Apr 2007 16:41:23 +0200
Message-ID: <20070403164123.f6190e5a.dada1@cosmosbay.com>
References: <eutlm7$dem$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <eutlm7$dem$1@sea.gmane.org>
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

On Tue, 03 Apr 2007 14:43:52 +0100
Amin Azez <azez@ufomechanic.net> wrote:

> In ipv4/route.c
> 
> It looks like we return on cache hit without calling rcu_read_unlock.
> Does this matter?

The call to rcu_read_unlock() is there, maybe you read too fast...

> 
> 
> int ip_route_input(struct sk_buff *skb, u32 daddr, u32 saddr,
>                    u8 tos, struct net_device *dev)
> {
>         struct rtable * rth;
>         unsigned        hash;
>         int iif = dev->ifindex;
> 
>         tos &= IPTOS_RT_MASK;
>         hash = rt_hash_code(daddr, saddr ^ (iif << 5));
> 
>         rcu_read_lock();
>         for (rth = rcu_dereference(rt_hash_table[hash].chain); rth;
>              rth = rcu_dereference(rth->u.rt_next)) {
>                 if (rth->fl.fl4_dst == daddr &&
>                     rth->fl.fl4_src == saddr &&
>                     rth->fl.iif == iif &&
>                     rth->fl.oif == 0 &&
> #ifdef CONFIG_IP_ROUTE_FWMARK
>                     rth->fl.fl4_fwmark == skb->nfmark &&
> #endif
>                     rth->fl.fl4_tos == tos) {
>                         rth->u.dst.lastuse = jiffies;
>                         dst_hold(&rth->u.dst);
>                         rth->u.dst.__use++;
>                         RT_CACHE_STAT_INC(in_hit);

// HERE  :)
>                         rcu_read_unlock();
>                         skb->dst = (struct dst_entry*)rth;
>                         return 0;
>                 }
>                 RT_CACHE_STAT_INC(in_hlist_search);
>         }
>         rcu_read_unlock();
> 
> ...
