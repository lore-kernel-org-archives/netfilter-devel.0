From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC] [PATCH] Fix expectation mask dumping
Date: Thu, 02 Feb 2006 19:30:02 +0900 (JST)
Message-ID: <200602021030.k12AU31P010526@toshiba.co.jp>
References: <43E095A2.1040908@trash.net>
	<200602011335.k11DZHwj018072@toshiba.co.jp>
	<43E15615.2070508@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <43E15615.2070508@netfilter.org>
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


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 02 Feb 2006 01:45:09 +0100

> Hi,
> 
> This patch introduces the function ctnetlink_exp_dump_mask, that
> correctly dumps the expectation mask. Such function uses the l3num value
> from the expectation tuple that is a valid layer 3 protocol number.
> 
> Besides, this modification introduces the attribute CTA_IP_L3NUM.
> Although the layer 3 protocol information is sent in the nfnetlink
> header, if the message contains information about an expectation, it
> will contain information about the master conntrack (just one of the
> tuples), the expectation tuple and the expectation mask. In this case,
> the value of l3num in the expectation mask is not the same that is set
> in the nfnetlink message. That is why we need another field that contain
> the value of l3num.
> 
> Now libnetfilter_conntrack can use the CTA_IP_L3NUM attribute, but if
> this attribute is not present in the message, it can use the information
> available in the nfnetlink header message.
> 
> comments?

sounds good idea.

>  static inline int
> -ctnetlink_dump_tuples(struct sk_buff *skb, 
> -		      const struct nf_conntrack_tuple *tuple)
> +ctnetlink_dump_tuples_ip(struct sk_buff *skb,
> +			 const struct nf_conntrack_tuple *tuple,
> +			 struct nf_conntrack_l3proto *l3proto)
>  {
> -	struct nfattr *nest_parms;
> -	struct nf_conntrack_l3proto *l3proto;
>  	int ret = 0;
> -	
> -	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
> -	
> -	nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
> +	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
> +
> +	NFA_PUT(skb, CTA_IP_L3NUM, sizeof(u_int16_t), &tuple->src.l3num);

Well, I think that 8bits are enough. It seems that it's time to change
'l3num' field in tuple to 8bits to avoid confusing.

If everyone has no objection, please just change this to 8bits, then I'll
write a patch to do that on top of your patch.

-- Yasuyuki Kozakai
