From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] optimise iptables interface matching
Date: Thu, 24 May 2007 19:43:12 +0200
Message-ID: <4655CEB0.4060306@trash.net>
References: <465528CB.4020108@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <465528CB.4020108@snapgear.com>
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

Philip Craig wrote:
> Optimise iptables for rules that specify 0 or 1 interface matches,
> which is the more common case (at least for my rulesets).
> 
> Below are the oprofile cpu cycle percentages from a 30 second
> period of an iperf throughput test on a 667MHz IXP465 with
> Realtek 8169 network interfaces.
> 
> rules	iface	% cpu before	% cpu after	saving (adjusted)
> 0		 7.7662		 4.9191		 2.8471
> 10 	0	15.9798		 9.8453		 3.2874
> 20 	0	23.6914		14.2051		 6.6392
> 10	1	14.6068		11.7332		 0.0265
> 20	1	21.1646		17.1905		 1.1270
> 10	2	14.6497		13.0306		-1.2280
> 20	2	21.1647		20.3536		-2.0360
> 
> - saving with 0 rules is due to policies
> - adjusted saving means with the 0 rules saving subtracted
> - iface 0 means "iptables -I FORWARD"
> - iface 1 means "iptables -I FORWARD -i eth0"
> - iface 2 means "iptables -I FORWARD -i eth0 -o eth1"
> 
> If you think this is an acceptable approach then I can update
> the patch for IPv6.  Any suggestions for other parts of
> netfilter/iptables to look at optimising are also welcome.


I don't like the kernel-internal fiddling with the flags too
much, but I don't see a way around it. But even if there is
no other way,

> @@ -884,6 +897,15 @@ copy_entries_to_user(unsigned int total_
>  			goto free_counters;
>  		}
>  
> +		flags = e->ip.flags & IPT_F_MASK;
> +		if (copy_to_user(userptr + off
> +				 + offsetof(struct ipt_entry, ip.flags),
> +				 &flags,
> +				 sizeof(flags)) != 0) {
> +			ret = -EFAULT;
> +			goto free_counters;
> +		}
> +


userspace should just ignore unknown flags.
