From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Fri, 09 Dec 2005 11:41:32 +0900 (JST)
Message-ID: <200512090241.jB92fXut018767@toshiba.co.jp>
References: <439419A7.7040100@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <439419A7.7040100@eurodev.net>
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

From: Pablo Neira Ayuso <pablo@eurodev.net>
Date: Mon, 05 Dec 2005 11:42:47 +0100

> Attached the 3rd incarnation of the ctnetlink port to nf_conntrack, it
> includes all recent Patrick's bugfixes and Yasuyuki's comments.
> 
> nf_conntrack_netlink.c is available at:
> http://people.netfilter.org/pablo/nf_conntrack_netlink.c

Great work.

I have 2 more comments as follows. I'll send patches for them and
adding support for ICMPv6 in other mails.

> +static int icmp_nfattr_to_tuple(struct nfattr *tb[],
> +				struct nf_conntrack_tuple *tuple)
> +{
> +	if (!tb[CTA_PROTO_ICMP_TYPE-1]
> +	    || !tb[CTA_PROTO_ICMP_CODE-1]
> +	    || !tb[CTA_PROTO_ICMP_ID-1])
> +		return -EINVAL;
> +
> +	if (nfattr_bad_size(tb, CTA_PROTO_MAX, cta_min_proto))
> +		return -EINVAL;
> +
> +	tuple->dst.u.icmp.type = 
> +			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_TYPE-1]);
> +	tuple->dst.u.icmp.code =
> +			*(u_int8_t *)NFA_DATA(tb[CTA_PROTO_ICMP_CODE-1]);
> +	tuple->src.u.icmp.id =
> +			*(u_int16_t *)NFA_DATA(tb[CTA_PROTO_ICMP_ID-1]);
> +
> +	if (tuple->dst.u.icmp.type >= sizeof(valid_new)
> +	    || !valid_new[tuple->dst.u.icmp.type])
> +		return -EINVAL;
> +
> +	return 0;
> +}

This rejects tuples for replying like Echo reply. How about invmap instead of
valid_new ?

This can be said about the resent patch for "ip_conntrack"_netlink
from you. I'll also send patch for it.

> +EXPORT_SYMBOL(nf_conntrack_hash_insert);
> +EXPORT_SYMBOL(__nf_conntrack_expect_find);
> +EXPORT_SYMBOL(nf_conntrack_expect_find);
> +EXPORT_SYMBOL(nf_conntrack_expect_list);
> +EXPORT_SYMBOL(nf_ct_port_tuple_to_nfattr);
> +EXPORT_SYMBOL(nf_ct_port_nfattr_to_tuple);

nf_ct_port_{tuple_to_nfattr,nfattr_to_tuple} should be surrouned with
CONFIG_NF_CT_NETLINK.

Regards,

-- Yasuyuki Kozakai
