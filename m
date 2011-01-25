From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/13] bitmap:ip set type support
Date: Tue, 25 Jan 2011 16:05:26 +0100
Message-ID: <4D3EE6B6.8090008@trash.net>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55729 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AYPFg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:05:36 -0500
In-Reply-To: <1295618527-9583-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.01.2011 15:01, Jozsef Kadlecsik wrote:
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> new file mode 100644
> index 0000000..4fbb360
> --- /dev/null
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c

> +static const struct nla_policy bitmap_ip_adt_policy[IPSET_ATTR_ADT_MAX+1] = {
> +	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
> +	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
> +	[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
> +	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
> +	[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
> +};
> +
> +static int
> +bitmap_ip_uadt(struct ip_set *set, struct nlattr *head, int len,
> +	       enum ipset_adt adt, u32 *lineno, u32 flags)
> +{
> +	struct bitmap_ip *map = set->data;
> +	struct nlattr *tb[IPSET_ATTR_ADT_MAX+1];
> +	u32 ip, ip_to, id;
> +	int ret = 0;
> +
> +	if (nla_parse(tb, IPSET_ATTR_ADT_MAX, head, len,
> +		      bitmap_ip_adt_policy))

You can simply pass the container attribute instead of the
contents and length from ip_set_core.c and use nla_parse_nested().

This could even be done centrally in ip_set_core.c and you
just hand a set of parsed and validated attributes to this
function. Basically what you would do is:

- add nla_policy member to the ip_set_type_variant structure
- add type/variant specific max_attribute member to the
  ip_set_type_variant structure

initialize both appropriately for each set type variant.

In ip_set_core.c, do:

	struct nlattr *nla[set->variant->maxattr + 1];

	err = nla_parse_nested(nla, set->variant->maxattr,
			       attr[IPSET_ATTR_DATA],
			       set->variant->policy);
	if (err < 0)
		return err;

	set->variant->uadt(..., nla, ...)

That way you avoid duplicating the parsing in every set type.

> +		return -IPSET_ERR_PROTOCOL;
> +
> +	if (unlikely(!tb[IPSET_ATTR_IP]))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	if (tb[IPSET_ATTR_LINENO])
> +		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
> +
> +	ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP], &ip);
> +	if (ret)
> +		return ret;
> +
> +	if (ip < map->first_ip || ip > map->last_ip)
> +		return -IPSET_ERR_BITMAP_RANGE;
> +
> +	/* Set was defined without timeout support:
> +	 * don't ignore the attribute silently */
> +	if (tb[IPSET_ATTR_TIMEOUT])
> +		return -IPSET_ERR_TIMEOUT;
> +
> +	if (adt == IPSET_TEST)
> +		return bitmap_ip_test(map, ip_to_id(map, ip));
> +
> +	if (tb[IPSET_ATTR_IP_TO]) {
> +		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
> +		if (ret)
> +			return ret;
> +		if (ip > ip_to) {
> +			swap(ip, ip_to);
> +			if (ip < map->first_ip)
> +				return -IPSET_ERR_BITMAP_RANGE;
> +		}
> +	} else if (tb[IPSET_ATTR_CIDR]) {
> +		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
> +
> +		if (cidr > 32)
> +			return -IPSET_ERR_INVALID_CIDR;
> +		ip &= ip_set_hostmask(cidr);
> +		ip_to = ip | ~ip_set_hostmask(cidr);
> +	} else
> +		ip_to = ip;
> +
> +	if (ip_to > map->last_ip)
> +		return -IPSET_ERR_BITMAP_RANGE;
> +
> +	for (; !before(ip_to, ip); ip += map->hosts) {
> +		id = ip_to_id(map, ip);
> +		ret = adt == IPSET_ADD ? bitmap_ip_add(map, id)
> +				       : bitmap_ip_del(map, id);
> +
> +		if (ret && !ip_set_eexist(ret, flags))
> +			return ret;
> +		else
> +			ret = 0;
> +	}
> +	return ret;
> +}
> +
> +static void
> +bitmap_ip_destroy(struct ip_set *set)
> +{
> +	struct bitmap_ip *map = set->data;
> +
> +	ip_set_free(map->members);
> +	kfree(map);
> +
> +	set->data = NULL;
> +}
> +
> +static void
> +bitmap_ip_flush(struct ip_set *set)
> +{
> +	struct bitmap_ip *map = set->data;
> +
> +	memset(map->members, 0, map->memsize);
> +}
> +
> +static int
> +bitmap_ip_head(struct ip_set *set, struct sk_buff *skb)
> +{
> +	const struct bitmap_ip *map = set->data;
> +	struct nlattr *nested;
> +
> +	nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
> +	if (!nested)
> +		goto nla_put_failure;
> +	NLA_PUT_IPADDR4(skb, IPSET_ATTR_IP, htonl(map->first_ip));
> +	NLA_PUT_IPADDR4(skb, IPSET_ATTR_IP_TO, htonl(map->last_ip));
> +	if (map->netmask != 32)
> +		NLA_PUT_U8(skb, IPSET_ATTR_NETMASK, map->netmask);
> +	NLA_PUT_NET32(skb, IPSET_ATTR_REFERENCES,
> +		      htonl(atomic_read(&set->ref) - 1));
> +	NLA_PUT_NET32(skb, IPSET_ATTR_MEMSIZE,
> +		      htonl(sizeof(*map) + map->memsize));
> +	ipset_nest_end(skb, nested);
> +
> +	return 0;
> +nla_put_failure:
> +	return -EFAULT;

Same as in ip_set_core, this should be EMSGSIZE (probably applies
to all set types).

> +}
> +
> +static int
> +bitmap_ip_list(const struct ip_set *set,
> +	       struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	const struct bitmap_ip *map = set->data;
> +	struct nlattr *atd, *nested;
> +	u32 id, first = cb->args[2];
> +
> +	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
> +	if (!atd)
> +		return -EFAULT;

Same here.

> +	for (; cb->args[2] < map->elements; cb->args[2]++) {
> +		id = cb->args[2];
> +		if (!bitmap_ip_test(map, id))
> +			continue;
> +		nested = ipset_nest_start(skb, IPSET_ATTR_DATA);
> +		if (!nested) {
> +			if (id == first) {
> +				nla_nest_cancel(skb, atd);
> +				return -EFAULT;

And here.

> +			} else
> +				goto nla_put_failure;
> +		}
> +		NLA_PUT_IPADDR4(skb, IPSET_ATTR_IP,
> +				htonl(map->first_ip + id * map->hosts));
> +		ipset_nest_end(skb, nested);
> +	}
> +	ipset_nest_end(skb, atd);
> +	/* Set listing finished */
> +	cb->args[2] = 0;
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, nested);
> +	ipset_nest_end(skb, atd);
> +	return 0;

Doesn't this need to return an errno value to indicate that the
dump is incomplete?

> +/* Timeout variant */
> +
> +struct bitmap_ip_timeout {
> +	unsigned long *members;	/* the set members */
> +	u32 first_ip;		/* host byte order, included in range */
> +	u32 last_ip;		/* host byte order, included in range */
> +	u32 elements;		/* number of max elements in the set */
> +	u32 hosts;		/* number of hosts in a subnet */
> +	size_t memsize;		/* members size */
> +	u8 netmask;		/* subnet netmask */
> +
> +	u32 timeout;		/* timeout parameter */
> +	struct timer_list gc;	/* garbage collection */

There's a lot of duplicated code just because the structures are
different. It seems this could be avoided if the common members
were in a common structure and just the timeout and timer_list
members were specific to the timeout variant.
