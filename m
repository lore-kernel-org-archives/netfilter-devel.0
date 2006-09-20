From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [NETFILTER 05/39]: ipt_TCPMSS: remove impossible condition
Date: Wed, 20 Sep 2006 13:07:51 +0200
Message-ID: <45112107.4020905@drugphish.ch>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
	<20060920082449.14636.26271.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net, w@1wt.eu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <20060920082449.14636.26271.sendpatchset@localhost.localdomain>
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

> [NETFILTER]: ipt_TCPMSS: remove impossible condition
> 
> Every skb must have a dst_entry at this point.

[...]

> diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
> index bfc8d9c..b2d3c4f 100644
> --- a/net/ipv4/netfilter/ipt_TCPMSS.c
> +++ b/net/ipv4/netfilter/ipt_TCPMSS.c
> @@ -73,13 +73,6 @@ ipt_tcpmss_target(struct sk_buff **pskb,
>  	}
>  
>  	if (tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) {
> -		if (!(*pskb)->dst) {
> -			if (net_ratelimit())
> -				printk(KERN_ERR "ipt_tcpmss_target: "
> -				       "no dst?! can't determine path-MTU\n");
> -			return NF_DROP; /* or IPT_CONTINUE ?? */
> -		}
> -
>  		if (dst_mtu((*pskb)->dst) <= sizeof(struct iphdr) +
>  					     sizeof(struct tcphdr)) {
>  			if (net_ratelimit())
> 

Could be a candidate for 2.4 kernels as well. Although, it's not a 
strict bugfix, only a performance improvement, at best.

Regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
