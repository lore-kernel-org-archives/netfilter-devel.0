From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Thu, 16 Feb 2006 10:36:20 +0100
Message-ID: <43F44794.1080203@trash.net>
References: <43EFF176.3070505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <43EFF176.3070505@netfilter.org>
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

Pablo Neira Ayuso wrote:
> [CTNETLINK] Fix expectaction mask dumping
> 
> The expectation mask has some particularities that make handle in a
> different way. The protocol number fields can be set to non-valid
> protocols, ie. l3num is set to 0xFFFF. Since that protocol does not
> exist, the mask tuple will not be dumped. Moreover, this results in a
> kernel panic when nf_conntrack accesses the array of protocol handlers,
> that is PF_MAX (0x1F) long.
> 
> This patch introduces the function ctnetlink_exp_dump_mask, that
> correctly dumps the expectation mask. Such function uses the l3num value
> from the expectation tuple that is a valid layer 3 protocol number.

This part looks fine to me, apart from one minor nitpick :)

> Besides, this modification introduces the attribute CTA_IP_L3NUM.
> Although the layer 3 protocol information is sent in the nfnetlink
> header, if the message contains information about an expectation, it
> will contain information about the master conntrack (just one of the
> tuples), the expectation tuple and the expectation mask. In this case,
> the value of l3num in the expectation mask is not the same that is set
> in the nfnetlink message. That is why we need another field that contain
> the value of l3num.

I'm not sure I understand. The new attribute still contains the same
value as the netlink header, doesn't it? So userspace should currently
have at least two possibilities to get the correct value:

- use the value from the netlink header
- use the value from the tuple that comes with the mask, as the first
  part of your patch does. This seems most logically to me since the
  mask and the tuple belong together.

> @@ -77,33 +75,47 @@ nfattr_failure:
>  }
>  
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
> +	u_int8_t l3num = (u_int8_t)tuple->src.l3num;

The cast is unnecessary.
