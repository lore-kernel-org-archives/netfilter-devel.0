From: "dravya" <dravya@magma.ca>
Subject: MASQUERADE fix for 2.4.20-8?
Date: Wed, 8 Sep 2004 11:52:14 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409081552.i88FqEx3003750@webmail1.magma.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi all,

I have been following the discussion on the MASQUERADE problem very closely since I am
experiencing the same problems being addressed (With 2 ppp links (dynamic ips), packets
with src addr of iface1 going over iface2 and thus causing a change of ip address (from
isp) of the ppp link and thus breaking any ongoing connections). I am also getting the
"Rusty's brain broke" error messages.

Rusty posted a patch, however I believe it is for linux kernel 2.6.9 whereas I am running
2.4.20-8. What changes are required in this version??? Following is an excerpt:

---------------------------------------------------------------------------------
static unsigned int
masquerade_target(struct sk_buff **pskb,
		  unsigned int hooknum,
		  const struct net_device *in,
		  const struct net_device *out,
		  const void *targinfo,
		  void *userinfo)
{
	struct ip_conntrack *ct;
	enum ip_conntrack_info ctinfo;
	const struct ip_nat_multi_range *mr;
	struct ip_nat_multi_range newrange;
	u_int32_t newsrc;
	struct rtable *rt;
	struct rt_key key;

	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);

	/* FIXME: For the moment, don't do local packets, breaks
	   testsuite for 2.3.49 --RR */
	if ((*pskb)->sk)
		return NF_ACCEPT;

	ct = ip_conntrack_get(*pskb, &ctinfo);
	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW
				  || ctinfo == IP_CT_RELATED));

	mr = targinfo;

	key.dst = (*pskb)->nh.iph->daddr;
	key.src = 0; /* Unknown: that's what we're trying to establish */
	key.tos = RT_TOS((*pskb)->nh.iph->tos)|RTO_CONN;
	key.oif = out->ifindex;
#ifdef CONFIG_IP_ROUTE_FWMARK
	key.fwmark = (*pskb)->nfmark;
#endif
	if (ip_route_output_key(&rt, &key) != 0) {
		/* Shouldn't happen */
		printk("MASQUERADE: No route: Rusty's brain broke!\n");
		return NF_DROP;
	}

	newsrc = rt->rt_src;
	DEBUGP("newsrc = %u.%u.%u.%u\n", NIPQUAD(newsrc));
	ip_rt_put(rt);

	WRITE_LOCK(&masq_lock);
	ct->nat.masq_index = out->ifindex;
	WRITE_UNLOCK(&masq_lock);

	/* Transfer from original range. */
	newrange = ((struct ip_nat_multi_range)
		{ 1, { { mr->range[0].flags | IP_NAT_RANGE_MAP_IPS,
			 newsrc, newsrc,
			 mr->range[0].min, mr->range[0].max } } });

	/* Hand modified range to generic setup. */
	return ip_nat_setup_info(ct, &newrange, hooknum);
}
---------------------------------------------------------------------------------

I have been having this problem for the past few months now, but not till recently did I
suspect the MASQUERADING code. (I had alot of faith in the developers I guess :) ) 

Any tips or suggestions are much appreciated. Do tell me if you would like some test
results or anything to make a patch for this.

thanks a million

Dravya
