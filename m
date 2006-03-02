From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 6/5] [CTNETLINK] Fix expectation mask dumping
Date: Fri, 03 Mar 2006 02:13:15 +0900 (JST)
Message-ID: <200603021713.k22HDGn9004928@toshiba.co.jp>
References: <44025F8A.6070302@netfilter.org> <4405BC65.1030705@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <4405BC65.1030705@netfilter.org>
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

Sorry, I forgot to check the part of ip_conntrack_netlink.c in previous
patch.

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 01 Mar 2006 16:23:17 +0100

> Index: net-2.6.16.git/net/ipv4/netfilter/ip_conntrack_netlink.c
> ===================================================================

(snip)

>  static inline int
> +ctnetlink_exp_dump_mask(struct sk_buff *skb,
> +			const struct ip_conntrack_tuple *tuple,
> +			const struct ip_conntrack_tuple *mask)
> +{
> +	int ret;
> +	struct ip_conntrack_protocol *proto;
> +	struct nfattr *nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
> +
> +	ret = ctnetlink_dump_tuples_ip(skb, mask);
> +	if (unlikely(ret < 0))
> +		goto nfattr_failure;
> +
> +	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
> +	ret = ctnetlink_dump_tuples_proto(skb, mask, proto);
> +	if (unlikely(ret < 0))
> +		goto nfattr_failure;
> + 
> +	NFA_NEST_END(skb, nest_parms);
> +
> +	return 0;
> +
> +nfattr_failure:
> +	return -1;
> +}

ip_conntrack_proto_put() is missing here. Hope I don't miss catching
any more...

-- Yasuyuki Kozakai
