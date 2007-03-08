From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] chaostables
Date: Thu, 08 Mar 2007 13:59:52 +0100
Message-ID: <45F008C8.2040907@trash.net>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:

> Index: linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
> @@ -0,0 +1,184 @@
> +
> +static unsigned int xt_chaos_target(struct sk_buff **pskb,
> +    const struct net_device *in, const struct net_device *out,
> +    unsigned int hooknum, const struct xt_target *target, const void *targinfo)
> +{
> +	/* Equivalent to:
> +	 * -A chaos -m statistic --mode random --probability \
> +	 *         $reject_percentage -j REJECT --reject-with host-unreach;
> +	 * -A chaos -m statistic --mode random --probability \
> +	 *         $delude_percentage -j DELUDE;
> +	 * -A chaos -j DROP;
> +	 */

What does this do that can't be done by simply adding those individual
rules?

> +	const struct xt_chaos_info *info = targinfo;
> +
> +	if((unsigned int)net_random() <= reject_percentage)
> +		return xt_reject->target(pskb, in, out, hooknum, target,
> +		       &reject_params);
> +
> +	/* TARPIT/DELUDE may not be called from the OUTPUT chain */
> +	if((*pskb)->nh.iph->protocol == IPPROTO_TCP &&
> +	  info->variant != XTCHAOS_NORMAL && hooknum != NF_IP_LOCAL_OUT)
> +		xt_chaos_total(info, pskb, in, out, hooknum);
> +
> +	return NF_DROP;
> +}


> Index: linux-2.6.21-rc3/net/netfilter/xt_DELUDE.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc3/net/netfilter/xt_DELUDE.c

Looks like a copy of the REJECT target. What does it do,
why can't you use REJECT?

> Index: linux-2.6.21-rc3/net/netfilter/xt_portscan.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc3/net/netfilter/xt_portscan.c

We already have the psd match for years, but decided against merging
it.
