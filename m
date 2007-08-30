From: Patrick Schaaf <bof@bof.de>
Subject: Re: new target: -j TEE
Date: Thu, 30 Aug 2007 09:00:04 +0200
Message-ID: <20070830070004.GF8438@oknodo.bof.de>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>
	<Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
	<1188237343.4548.4.camel@calypso> <46D5C304.9040102@trash.net>
	<Pine.LNX.4.64.0708292130520.24730@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Sebastian Cla?en <Sebastian.Classen@freenet.ag>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708292130520.24730@fbirervta.pbzchgretzou.qr>
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

>  * RETURN: -1 if an error occured
>  *          1 if the packet was succesfully routed to the 
>  *            destination desired
>  *          0 if the kernel routing table could not route the packet
>  *            according to the keys specified
>  */
> static int route(struct sk_buff *skb,
>                  const struct xt_TEE_info *info)
...
> 	/* Trying to route the packet using the standard routing table. */
> 	if ((err = ip_route_output_key(&rt, &fl)) != 0) {
> 		if (net_ratelimit()) 
> 			pr_debug(KBUILD_MODNAME
> 			         "could not route pkt (err: %d)", err);
> 		return -1;
> 	}

Comment does not match behaviour. Suggest to change comment, and make
function return 0/1 only.

> static inline void route_gw(const struct xt_TEE_info *info, struct sk_buff *skb) 
> {
> 	if (route(skb, info) != 1)
> 		return;
> 	ip_direct_send(skb);
> }

Too small, and only called once, to warrant being a function.

> 	/*
> 	 * If we are at PREROUTING or INPUT hook,
> 	 * the TTL is not decreased by the IP stack
> 	 */
> 	if (hooknum == NF_IP_PRE_ROUTING || hooknum == NF_IP_LOCAL_IN) {
...
> 		if (iph->ttl <= 1) {
...

I believe this case (the whole synthesizing an ICMP_TIME_EXCEEDED) is not
neccessary for TEE.

The code is working on the original skb. With ROUTE, the logic was that
the skb would be dropped soon due to exceeding TTL, and if we reroute
and send directly now, that wouldn't happen.

With TEE (as well as the previous ROUTE --tee option), the original
packet is not rerouted, and ICMP_TIME_EXCEEDED should be generated
for it as usual. Right?

That would leave two questions:

Should we skb_copy+route for the above quoted conditions, i.e. hook
PRE_ROUTING/LOCAL_IN and skb->ttl <= 1, although the tee'd packet will
be dropped soon?

And if we decide to tee the packet regardless of the ttl condition,
should the ttl be decremented after skb_copy on the teed packet,
or not?

My gut feeling is to remove all ttl handling, and let the next hop of
the teed packet handle ttl as if it were the original recipient,
instead of our tee pot.

best regards
  Patrick
