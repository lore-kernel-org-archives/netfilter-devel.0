From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Fix expectation mask dumping, take #2
Date: Wed, 08 Feb 2006 13:25:02 +0100
Message-ID: <43E9E31E.3060207@netfilter.org>
References: <200602011335.k11DZHwj018072@toshiba.co.jp>	<43E15615.2070508@netfilter.org>	<43E6904E.9020306@netfilter.org>
	<200602081126.k18BQWLj029476@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602081126.k18BQWLj029476@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Thanks for changing size of CTA_IP_L3NUM field. But it seems to have endian
> problem. This patch can save your time ?
> 
> ------------------------------------------------------------------------
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index ee814e1..150174f 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -81,8 +81,9 @@ ctnetlink_dump_tuples_ip(struct sk_buff 
>  {
>  	int ret = 0;
>  	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
> +	u_int8_t l3num = (u_int8_t)tuple->src.l3num;
>  
> -	NFA_PUT(skb, CTA_IP_L3NUM, sizeof(u_int8_t), &tuple->src.l3num);
> +	NFA_PUT(skb, CTA_IP_L3NUM, sizeof(u_int8_t), &l3num);
>  
>  	if (likely(l3proto->tuple_to_nfattr))
>  		ret = l3proto->tuple_to_nfattr(skb, tuple);

Oops, I understood in your previous email that you were going to send a
patch that changes the type of l3num from u_int16_t to u_int8_t. In that
case I'll resend a patch with this change. Thanks

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
