From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC] [PATCH] nf_conntrack_netlink port take#2
Date: Sun, 27 Nov 2005 16:08:54 +0900 (JST)
Message-ID: <200511270708.jAR78snC018182@toshiba.co.jp>
References: <43836FFE.3020504@eurodev.net>
	<200511250500.jAP50YL2008800@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <200511250500.jAP50YL2008800@toshiba.co.jp>
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


[Sorry for long message]

Hi, Pablo,

I've succeeded to run 'conntrack -L' with your patch and I could see
informations about IPv4 connections!

And I have some comments for fix or cleanup. Some of them can be said about
ip_conntrack_netlink, too. Then I marked [nfct] or [both] on all comments.

[nfct] means 'comment on only nf_conntrack_netlink'.
[both] means 'comment on both of {ip,nf}_conntrack_netlink'.

>  extern struct nf_conntrack_protocol *
> -nf_ct_find_proto(u_int16_t l3proto, u_int8_t protocol);
> +__nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol);

[nfct] Thanks for these cleanup :)

> +static int icmp_tuple_to_nfattr(struct sk_buff *skb,
> +				const struct nf_conntrack_tuple *t)
> +{
> +	NFA_PUT(skb, CTA_PROTO_ICMP_ID, sizeof(u_int16_t),
> +		&t->src.u.icmp.id);
> +	NFA_PUT(skb, CTA_PROTO_ICMP_TYPE, sizeof(u_int8_t),
> +		&t->dst.u.icmp.type);
> +	NFA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
> +		&t->dst.u.icmp.code);
> +
> +	if (t->dst.u.icmp.type >= sizeof(valid_new) 
> +	    || !valid_new[t->dst.u.icmp.type])
> +		return -EINVAL;

[both] Why this check isn't done before putting attributes ?

> +static int icmp_nfattr_to_tuple(struct nfattr *tb[],
> +				struct nf_conntrack_tuple *tuple)
> +{
> +	if (!tb[CTA_PROTO_ICMP_TYPE-1]
> +	    || !tb[CTA_PROTO_ICMP_CODE-1]
> +	    || !tb[CTA_PROTO_ICMP_ID-1])
> +		return -1;
> +
> +	tuple->dst.u.icmp.type = 
> +			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
> +	tuple->dst.u.icmp.code =
> +			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
> +	tuple->src.u.icmp.id =
> +			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
> +
> +	return 0;
> +}

[both] I think that it's necessary to check with valid_new[], to avoid to
create the connection which nf_conntrack cannot track.

> +static int ipv6_nfattr_to_tuple(struct nfattr *tb[],
> +				struct nf_conntrack_tuple *t)
> +{
> +	if (!tb[CTA_IP_V6_SRC-1] || !tb[CTA_IP_V6_DST-1])
> +		return -EINVAL;
> +
> +	memcpy(t->src.u3.ip6, NFA_DATA(tb[CTA_IP_V6_SRC-1]), 
> +	       sizeof(u_int32_t) * 4);
> +	memcpy(t->dst.u3.ip6, NFA_DATA(tb[CTA_IP_V6_DST-1]),
> +	       sizeof(u_int32_t) * 4);

[nfct] cosmetic: Here you use t->src.u3.ip6, but you use &t->src.u3.ip6
in ipv6_tuple_to_nfattr().

> +struct nf_conntrack_helper *
> +nf_ct_helper_find_get( const struct nf_conntrack_tuple *tuple)
> +{
> +	struct nf_conntrack_helper *helper;
> +
> +	/* need ip_conntrack_lock to assure that helper exists until
> +	 * try_module_get() is called */

[nfct] cosmetic: Please sed s/ip_conntrack_lock/nf_conntrack_lock/.

> -void nf_conntrack_cleanup(void)
> +void nf_conntrack_flush()
>  {
> -	int i;
> -
>  	/* This makes sure all current packets have passed through
>  	   netfilter framework.  Roll on, two-stage module
>  	   delete... */
> @@ -1383,6 +1550,18 @@ void nf_conntrack_cleanup(void)
>  		schedule();
>  		goto i_see_dead_people;
>  	}
> +	/* wait until all references to ip_conntrack_untracked are dropped */
> +	while (atomic_read(&nf_conntrack_untracked.ct_general.use) > 1)
> +		schedule();
> +}

[nfct] nice catch! I think this would better to be applied to mainline ASAP.
Could you re-send this in other patch ?


OK, next is nf_conntrack_netlink.c

> static inline int
> ctnetlink_dump_tuples(struct sk_buff *skb, 
> 		      const struct nf_conntrack_tuple *tuple)
> {
> 	struct nfattr *nest_parms;
> 	struct nf_conntrack_l3proto *l3proto;
> 	int ret = 0;
> 	
> 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
> 	
> 	nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
> 	if (likely(l3proto->tuple_to_nfattr))
> 		ret = l3proto->tuple_to_nfattr(skb, tuple);

[nfct] if this function failed, can this stop dumping and return -1 ?

> 	NFA_NEST_END(skb, nest_parms);
> 
> 	nf_ct_l3proto_put(l3proto);
> 
> 	nest_parms = NFA_NEST(skb, CTA_TUPLE_PROTO);
> 	ctnetlink_dump_tuples_proto(skb, tuple);

[both] Is there any reason that return value has to be ignored ?

> static inline int
> ctnetlink_dump_helpinfo(struct sk_buff *skb, const struct nf_conn *ct)
> {
> 	struct nfattr *nest_helper;
> 
> 	if (!ct->helper)
> 		return 0;
> 		
> 	nest_helper = NFA_NEST(skb, CTA_HELP);
> 	NFA_PUT(skb, CTA_HELP_NAME, CTA_HELP_MAXNAMESIZE, &ct->helper->name);

[both] Oh, &ct->helper->name doesn't point intended area. Because
ct->helper->name isn't declared as array.

[both] And its size may be less than CTA_HELP_MAXNAMESIZE.

> static inline int
> ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
> {
> 	unsigned int use = htonl(atomic_read(&ct->ct_general.use));

[both] cosmetic(?): Why 'unsigned int' is used here ? other functions
seems to use 'u_int32_t'.

> static int ctnetlink_conntrack_event(struct notifier_block *this,
>                                      unsigned long events, void *ptr)
> {

<snip>

> 	if (events & IPCT_DESTROY) {
> 		type = IPCTNL_MSG_CT_DELETE;
> 		group = NFNLGRP_CONNTRACK_DESTROY;
> 		goto alloc_skb;
> 	}
> 	if (events & (IPCT_NEW | IPCT_RELATED)) {
> 		type = IPCTNL_MSG_CT_NEW;
> 		flags = NLM_F_CREATE|NLM_F_EXCL;
> 		/* dump everything */
> 		events = ~0UL;
> 		group = NFNLGRP_CONNTRACK_NEW;
> 		goto alloc_skb;
> 	}
> 	if (events & (IPCT_STATUS |
> 		      IPCT_PROTOINFO |
> 		      IPCT_HELPER |
> 		      IPCT_HELPINFO |
> 		      IPCT_NATINFO)) {
> 		type = IPCTNL_MSG_CT_NEW;
> 		group = NFNLGRP_CONNTRACK_UPDATE;
> 		goto alloc_skb;
> 	} 
> 	
> 	return NOTIFY_DONE;
> 
> alloc_skb:

[both] cleanup: Why don't we use 'else if ... else' instead of 'goto' ?

> static const size_t cta_min_ip[CTA_IP_MAX] = {
> 	[CTA_IP_V4_SRC-1]	= sizeof(u_int32_t),
> 	[CTA_IP_V4_DST-1]	= sizeof(u_int32_t),
> };

[nfct] Can CTA_IP_V6_{SRC/DST} join them ? :)

[both] cleanup: Or, it might be better that this size check goes to
l3proto->nfattr_to_tuple(), to generalize more.

> static inline int
> ctnetlink_parse_tuple_proto(struct nfattr *attr, 
> 			    struct nf_conntrack_tuple *tuple)
> {
> 	struct nfattr *tb[CTA_PROTO_MAX];
> 	struct nf_conntrack_protocol *proto;
> 	int ret = 0;
> 
> 	DEBUGP("entered %s\n", __FUNCTION__);
> 
> 	nfattr_parse_nested(tb, CTA_PROTO_MAX, attr);
> 
> 	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
> 		return -EINVAL;

[both] cleanup: again, it might be better that this goes to
proto->nfattr_to_tuple().

> static int ctnetlink_parse_nat_proto(struct nfattr *attr,
> 				     const struct nf_conn *ct,
> 				     struct ip_nat_range *range)
> {
> 	struct nfattr *tb[CTA_PROTONAT_MAX];
> 	struct ip_nat_protocol *npt;
> 
> 	DEBUGP("entered %s\n", __FUNCTION__);
> 
> 	nfattr_parse_nested(tb, CTA_PROTONAT_MAX, attr);
> 
> 	if (nfattr_bad_size(tb, CTA_PROTONAT_MAX, cta_min_protonat))
> 		return -EINVAL;

[both] cleanup: I think this can go to ip_nat_port_nfattr_to_range(), too.

> static int
> ctnetlink_create_conntrack(struct nfattr *cda[], 
> 			   struct nf_conntrack_tuple *otuple,
> 			   struct nf_conntrack_tuple *rtuple)
> {

<snip>

> 	ct->helper = nf_ct_helper_find_get(rtuple);
> 
> 	add_timer(&ct->timeout);
> 	nf_conntrack_hash_insert(ct);
> 
> 	if (ct->helper)
> 		nf_ct_helper_put(ct->helper);
> 
> #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
> 	if (cda[CTA_MARK-1])
> 		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
> #endif

[both] this should go before nf_conntrack_hash_insert(). Here is not protected
with nf_conntrack_lock.

> static int
> ctnetlink_exp_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
> 		    int event, 
> 		    int nowait, 
> 		    const struct nf_conntrack_expect *exp)
> {

<snip>

> 	nlh    = NLMSG_PUT(skb, pid, seq, event, sizeof(struct nfgenmsg));
> 	nfmsg  = NLMSG_DATA(nlh);
> 
> 	nlh->nlmsg_flags    = (nowait && pid) ? NLM_F_MULTI : 0;
> 	nfmsg->nfgen_family = AF_INET;

[nfct] exp->tuple.src.l3num ?

> static int ctnetlink_expect_event(struct notifier_block *this,
> 				  unsigned long events, void *ptr)
> {

<snip>

> 	type |= NFNL_SUBSYS_CTNETLINK << 8;
> 	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
> 	nfmsg = NLMSG_DATA(nlh);
> 
> 	nlh->nlmsg_flags    = flags;
> 	nfmsg->nfgen_family = AF_INET;

[nfct] again, exp->tuple.src.l3num ?

> 	nfmsg->version	    = NFNETLINK_V0;
> 	nfmsg->res_id	    = 0;
> 
> 	if (ctnetlink_exp_dump_expect(skb, exp) < 0)
> 		goto nfattr_failure;
> 
> 	nlh->nlmsg_len = skb->tail - b;
> 	proto = exp->tuple.dst.protonum;

[both] cleanup: proto is set only here, but it isn't used.

-- Yasuyuki Kozakai
