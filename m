From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070707 kernel
Date: Mon, 09 Jul 2007 16:30:16 +0200
Message-ID: <46924678.9010909@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>	<46840B9F.7080803@trash.net>	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>	<468410A9.70309@trash.net>	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>	<4684ECB5.9070402@trash.net>	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>	<4688EF45.7020200@trash.net>	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>	<46891C50.1020904@trash.net>	<Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>	<468A2F91.3040002@trash.net>	<Pine.LNX.4.64.0707031319000.1536@fbirervta.pbzchgretzou.qr>	<468A3446.9050505@trash.net>	<Pine.LNX.4.64.0707041254530.1536@fbirervta.pbzchgretzou.qr>	<468BB421.3090801@trash.net>	<Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>	<468E3E06.3080305@trash.net>
	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
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
> On Jul 6 2007 15:05, Patrick McHardy wrote:
> 
>>>Ok so what should I put in for nhoff, dataoff, what_l3 and what_l4?
>>
>>
>>Check out nf_conntrack_in() and the IPv4/IPv6 prepare functions.
>>
> 
> 
> Does this look ok?


Yes, just two small things left:

> +	read_unlock_bh(&nf_conntrack_lock);
> +
> +	if (addit) {
> +		/* save the new connection in our list */
> +		conn = kzalloc(sizeof(*conn), GFP_ATOMIC);
> +		if (conn == NULL)
> +			return -ENOMEM;
> +
> +		INIT_LIST_HEAD(&conn->list);

No need to initialize member list_heads.

> +		conn->tuple = *tuple;
> +		list_add(&conn->list, hash);
> +		++matches;
> +	}
> +
> +	return matches;
> +}
> +
> +static bool connlimit_match(const struct sk_buff *skb,
> +			    const struct net_device *in,
> +			    const struct net_device *out,
> +			    const struct xt_match *match,
> +			    const void *matchinfo, int offset,
> +			    unsigned int protoff, bool *hotdrop)
> +{
> +	const struct xt_connlimit_info *info = matchinfo;
> +	const struct nf_conntrack_tuple *tuple_ptr;
> +	union nf_conntrack_address addr, mask;
> +	struct nf_conntrack_tuple tuple;
> +	enum ip_conntrack_info ctinfo;
> +	const struct nf_conn *ct;
> +	int connections;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct != NULL) {
> +		tuple_ptr = &ct->tuplehash[0].tuple;
> +	} else {
> +		struct nf_conntrack_l3proto *l3proto;
> +		struct nf_conntrack_l4proto *l4proto;
> +
> +		l3proto = nf_ct_l3proto_find_get(match->family);
> +		if (l3proto == NULL) {
> +			*hotdrop = true;
> +			return false;
> +		}
> +		l4proto = nf_ct_l4proto_find_get(match->family, match->proto);


The module reference taking functions should not be used in the
packet processing path. Please use __nf_ct_l3proto_find and
__nf_ct_l4proto_find. Since the l3proto is static for one
instance of the match you could also store it info->data and
only do the lookup once (for then you need to take the module
reference of course).

> +
> +	if (match->family == AF_INET6) {
> +		const struct ipv6hdr *iph = ipv6_hdr(skb);
> +		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
> +		memcpy(&mask.ip6, info->v6_mask, sizeof(info->v6_mask));
> +	} else {
> +		const struct iphdr *iph = ip_hdr(skb);
> +		addr.ip = iph->saddr;
> +		mask.ip = info->v4_mask;
> +	}
> +
> +	spin_lock_bh(&info->data->lock);
> +	connections = count_them(info->data, tuple_ptr, &addr, &mask, match);
> +	spin_unlock_bh(&info->data->lock);
> +
> +	if (connections < 0) {
> +		/* kmalloc failed, drop it entirely */
> +		*hotdrop = 1;


This should be "= true" I guess ..
