From: Patrick McHardy <kaber@trash.net>
Subject: Re: Follow packets in rules
Date: Fri, 22 Jun 2007 16:20:00 +0200
Message-ID: <467BDA90.7090802@trash.net>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca> <467020F6.2050906@trash.net>
	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
	<46713EE8.6060906@trash.net>
	<Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>
	<46714F7D.4010309@trash.net>
	<Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Attached you can find the reworked TRACE target, which does not suffer
> from backward incompatibility. Unfortunately I had to steal one unused
> bit from skbuff to be able to mark the packets so that it surely does
> not clash with any rules using the standard "MARK" target. Logging
> level, flags and type are hardcoded. What do you think?

Could you send me a Signed-off-by: line so I can queue this for 2.6.23?

> +static inline void trace_packet(struct sk_buff *skb,
> +				unsigned int hook,
> +				const struct net_device *in,
> +				const struct net_device *out,
> +				char *tablename,
> +				struct xt_table_info *private,
> +				struct ipt_entry *e)


I'm going to remove the inline here ..

>  /* Returns one of the generic firewall policies, like NF_ACCEPT. */
>  unsigned int
>  ipt_do_table(struct sk_buff **pskb,
> @@ -267,6 +371,12 @@
>  
>  			t = ipt_get_target(e);
>  			IP_NF_ASSERT(t->u.kernel.target);
> +			
> +			/* The packet is traced: log it */
> +			if ((*pskb)->nf_trace)
> +				trace_packet(*pskb, hook, in, out,
> +					     table->name, private, e);
> +

and mark this unlikely so we don't bloat the main loop of ipt_do_table.
