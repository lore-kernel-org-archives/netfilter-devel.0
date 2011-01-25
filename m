From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Tue, 25 Jan 2011 15:47:19 +0100
Message-ID: <4D3EE277.9070804@trash.net>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu> <alpine.DEB.2.00.1101212232290.10581@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1AYOr1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:47:27 -0500
In-Reply-To: <alpine.DEB.2.00.1101212232290.10581@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Please see below for a few more comments on the netlink protocol.

On 21.01.2011 22:39, Jozsef Kadlecsik wrote:
> +static int
> +dump_init(struct netlink_callback *cb)
> +{
> +	struct nlmsghdr *nlh = nlmsg_hdr(cb->skb);
> +	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
> +	struct nlattr *cda[IPSET_ATTR_CMD_MAX+1];
> +	struct nlattr *attr = (void *)nlh + min_len;
> +	ip_set_id_t index;
> +
> +	/* Second pass, so parser can't fail */
> +	nla_parse(cda, IPSET_ATTR_CMD_MAX,
> +		  attr, nlh->nlmsg_len - min_len, ip_set_setname_policy);
> +
> +	/* cb->args[0] : dump single set/all sets
> +	 *         [1] : set index
> +	 *         [..]: type specific
> +	 */
> +
> +	if (!cda[IPSET_ATTR_SETNAME]) {
> +		cb->args[0] = DUMP_ALL;
> +		return 0;
> +	}
> +
> +	index = find_set_id(nla_data(cda[IPSET_ATTR_SETNAME]));
> +	if (index == IPSET_INVALID_ID)
> +		return -EEXIST;

This error code doesn't seem right, EEXIST indicates that
something already exists on creation, not that something
doesn't exist. EINVAL for invalid values and ENOENT for
non-existant sets seems more appropriate.

> +
> +	cb->args[0] = DUMP_ONE;
> +	cb->args[1] = index;
> +	return 0;
> +}
> +
> +static int
> +ip_set_dump_start(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	ip_set_id_t index = IPSET_INVALID_ID, max;
> +	struct ip_set *set = NULL;
> +	struct nlmsghdr *nlh = NULL;
> +	unsigned int flags = NETLINK_CB(cb->skb).pid ? NLM_F_MULTI : 0;
> +	int ret = 0;
> +
> +	if (cb->args[0] == DUMP_INIT) {
> +		ret = dump_init(cb);
> +		if (ret < 0) {
> +			/* We have to create and send the error message
> +			 * manually :-( */
> +			netlink_ack(cb->skb, nlmsg_hdr(cb->skb), ret);

This should probably only be done if the NLM_F_ACK flag was set
on the request.

> +			return ret;
> +		}
> +	}
> +
> +	if (cb->args[1] >= ip_set_max)
> +		goto out;
> +
> +	pr_debug("args[0]: %ld args[1]: %ld\n", cb->args[0], cb->args[1]);
> +	max = cb->args[0] == DUMP_ONE ? cb->args[1] + 1 : ip_set_max;
> +	for (; cb->args[1] < max; cb->args[1]++) {
> +		index = (ip_set_id_t) cb->args[1];
> +		set = ip_set_list[index];
> +		if (set == NULL) {
> +			if (cb->args[0] == DUMP_ONE) {
> +				ret = -EEXIST;

Same as above.

> +				goto out;
> +			}
> +			continue;
> +		}
> +		/* When dumping all sets, we must dump "sorted"
> +		 * so that lists (unions of sets) are dumped last.
> +		 */
> +		if (cb->args[0] != DUMP_ONE &&
> +		    !((cb->args[0] == DUMP_ALL) ^
> +		      (set->type->features & IPSET_DUMP_LAST)))
> +			continue;
> +		pr_debug("List set: %s\n", set->name);
> +		if (!cb->args[2]) {
> +			/* Start listing: make sure set won't be destroyed */
> +			pr_debug("reference set\n");
> +			__ip_set_get(index);
> +		}
> +		nlh = start_msg(skb, NETLINK_CB(cb->skb).pid,
> +				cb->nlh->nlmsg_seq, flags,
> +				IPSET_CMD_LIST);
> +		if (!nlh) {
> +			ret = -EFAULT;

That also doesn't look right, -EMSGSIZE would be more appropriate
since that's the only failure condition in start_msg().

> +			goto release_refcount;
> +		}
> +		NLA_PUT_U8(skb, IPSET_ATTR_PROTOCOL, IPSET_PROTOCOL);
> +		NLA_PUT_STRING(skb, IPSET_ATTR_SETNAME, set->name);
> +		switch (cb->args[2]) {
> +		case 0:
> +			/* Core header data */
> +			NLA_PUT_STRING(skb, IPSET_ATTR_TYPENAME,
> +				       set->type->name);
> +			NLA_PUT_U8(skb, IPSET_ATTR_FAMILY,
> +				   set->family);
> +			NLA_PUT_U8(skb, IPSET_ATTR_REVISION,
> +				   set->type->revision);
> +			ret = set->variant->head(set, skb);
> +			if (ret < 0)
> +				goto release_refcount;
> +			/* Fall through and add elements */
> +		default:
> +			read_lock_bh(&set->lock);
> +			ret = set->variant->list(set, skb, cb);
> +			read_unlock_bh(&set->lock);
> +			if (!cb->args[2]) {
> +				/* Set is done, proceed with next one */
> +				if (cb->args[0] == DUMP_ONE)
> +					cb->args[1] = IPSET_INVALID_ID;
> +				else
> +					cb->args[1]++;
> +			}
> +			goto release_refcount;
> +		}
> +	}
> +	goto out;
> +
> +nla_put_failure:
> +	ret = -EFAULT;

Also should be -EMSGSIZE.

> +release_refcount:
> +	/* If there was an error or set is done, release set */
> +	if (ret || !cb->args[2]) {
> +		pr_debug("release set %s\n", ip_set_list[index]->name);
> +		__ip_set_put(index);
> +	}
> +
> +	/* If we dump all sets, continue with dumping last ones */
> +	if (cb->args[0] == DUMP_ALL && cb->args[1] >= max && !cb->args[2])
> +		cb->args[0] = DUMP_LAST;
> +
> +out:
> +	if (nlh) {
> +		nlmsg_end(skb, nlh);
> +		pr_debug("nlmsg_len: %u\n", nlh->nlmsg_len);
> +		dump_attrs(nlh);
> +	}
> +
> +	return ret < 0 ? ret : skb->len;
> +}

> +/* Add, del and test */
> +
> +static const struct nla_policy ip_set_adt_policy[IPSET_ATTR_CMD_MAX + 1] = {
> +	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
> +	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
> +				    .len = IPSET_MAXNAMELEN - 1 },
> +	[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
> +	[IPSET_ATTR_DATA]	= { .type = NLA_NESTED },
> +	[IPSET_ATTR_ADT]	= { .type = NLA_NESTED },
> +};
> +
> +static int
> +call_ad(struct sk_buff *skb, const struct nlattr *const attr[],
> +	struct ip_set *set, const struct nlattr *nla,
> +	enum ipset_adt adt, u32 flags)
> +{
> +	struct nlattr *head = nla_data(nla);
> +	int ret, len = nla_len(nla), retried = 0;
> +	u32 lineno = 0;
> +	bool eexist = flags & IPSET_FLAG_EXIST;
> +
> +	do {
> +		write_lock_bh(&set->lock);
> +		ret = set->variant->uadt(set, head, len, adt,
> +					 &lineno, flags);
> +		write_unlock_bh(&set->lock);
> +	} while (ret == -EAGAIN &&
> +		 set->variant->resize &&
> +		 (ret = set->variant->resize(set, retried++)) == 0);
> +
> +	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
> +		return 0;
> +	if (lineno && attr[IPSET_ATTR_LINENO]) {
> +		/* Error in restore/batch mode: send back lineno */
> +		u32 *errline = nla_data(attr[IPSET_ATTR_LINENO]);
> +
> +		*errline = lineno;

This appears to be modifying the (const) attributes received
from userspace.

> +	}
> +
> +	return ret;
> +}
> +
> +static int
> +ip_set_uadd(struct sock *ctnl, struct sk_buff *skb,
> +	    const struct nlmsghdr *nlh,
> +	    const struct nlattr * const attr[])
> +{
> +	struct ip_set *set;
> +	const struct nlattr *nla;
> +	u32 flags = flag_exist(nlh);
> +	int ret = 0;
> +
> +	if (unlikely(protocol_failed(attr) ||
> +		     attr[IPSET_ATTR_SETNAME] == NULL ||
> +		     !((attr[IPSET_ATTR_DATA] != NULL) ^
> +		       (attr[IPSET_ATTR_ADT] != NULL)) ||
> +		     (attr[IPSET_ATTR_DATA] != NULL &&
> +		      !flag_nested(attr[IPSET_ATTR_DATA])) ||
> +		     (attr[IPSET_ATTR_ADT] != NULL &&
> +		      (!flag_nested(attr[IPSET_ATTR_ADT]) ||
> +		       attr[IPSET_ATTR_LINENO] == NULL))))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	set = find_set(nla_data(attr[IPSET_ATTR_SETNAME]));
> +	if (set == NULL)
> +		return -EEXIST;

Same comment as other EEXISTs.

> +
> +	if (attr[IPSET_ATTR_DATA]) {
> +		ret = call_ad(skb, attr,
> +			      set, attr[IPSET_ATTR_DATA], IPSET_ADD, flags);
> +	} else {
> +		int nla_rem;
> +
> +		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
> +			if (nla_type(nla) != IPSET_ATTR_DATA ||
> +			    !flag_nested(nla))
> +				return -IPSET_ERR_PROTOCOL;

Since addition can fail due to size problems anyways it not very
important, but we could perform validation before attempting to
add members so the operation either succeeds or fails entirely.

To really make sense that would require to test for existance of
members on deletion and for enough space (+ possibly pre-allocation)
on addition though, so for now we can ignore it I guess.

> +			ret = call_ad(skb, attr,
> +				       set, nla, IPSET_ADD, flags);
> +			if (ret < 0)
> +				return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static int
> +ip_set_udel(struct sock *ctnl, struct sk_buff *skb,
> +	    const struct nlmsghdr *nlh,
> +	    const struct nlattr * const attr[])
> +{
> +	struct ip_set *set;
> +	const struct nlattr *nla;
> +	u32 flags = flag_exist(nlh);
> +	int ret = 0;
> +
> +	if (unlikely(protocol_failed(attr) ||
> +		     attr[IPSET_ATTR_SETNAME] == NULL ||
> +		     !((attr[IPSET_ATTR_DATA] != NULL) ^
> +		       (attr[IPSET_ATTR_ADT] != NULL)) ||
> +		     (attr[IPSET_ATTR_DATA] != NULL &&
> +		      !flag_nested(attr[IPSET_ATTR_DATA])) ||
> +		     (attr[IPSET_ATTR_ADT] != NULL &&
> +		      (!flag_nested(attr[IPSET_ATTR_ADT]) ||
> +		       attr[IPSET_ATTR_LINENO] == NULL))))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	set = find_set(nla_data(attr[IPSET_ATTR_SETNAME]));
> +	if (set == NULL)
> +		return -EEXIST;

ENOENT.

> +
> +	if (attr[IPSET_ATTR_DATA]) {
> +		ret = call_ad(skb, attr,
> +			      set, attr[IPSET_ATTR_DATA], IPSET_DEL, flags);
> +	} else {
> +		int nla_rem;
> +
> +		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
> +			if (nla_type(nla) != IPSET_ATTR_DATA ||
> +			    !flag_nested(nla))
> +				return -IPSET_ERR_PROTOCOL;
> +			ret = call_ad(skb, attr,
> +				       set, nla, IPSET_DEL, flags);
> +			if (ret < 0)
> +				return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static int
> +ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
> +	     const struct nlmsghdr *nlh,
> +	     const struct nlattr * const attr[])
> +{
> +	struct ip_set *set;
> +	int ret = 0;
> +
> +	if (unlikely(protocol_failed(attr) ||
> +		     attr[IPSET_ATTR_SETNAME] == NULL ||
> +		     attr[IPSET_ATTR_DATA] == NULL ||
> +		     !flag_nested(attr[IPSET_ATTR_DATA])))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	set = find_set(nla_data(attr[IPSET_ATTR_SETNAME]));
> +	if (set == NULL)
> +		return -EEXIST;

ENOENT

> +
> +	read_lock_bh(&set->lock);
> +	ret = set->variant->uadt(set,
> +				 nla_data(attr[IPSET_ATTR_DATA]),
> +				 nla_len(attr[IPSET_ATTR_DATA]),
> +				 IPSET_TEST, NULL, 0);
> +	read_unlock_bh(&set->lock);
> +	/* Userspace can't trigger element to be re-added */
> +	if (ret == -EAGAIN)
> +		ret = 1;

This value is returned to userspace, what does '1' mean?

> +
> +	return ret < 0 ? ret : ret > 0 ? 0 : -IPSET_ERR_EXIST;
> +}
> +
> +/* Get headed data of a set */
> +
> +static int
> +ip_set_header(struct sock *ctnl, struct sk_buff *skb,
> +	      const struct nlmsghdr *nlh,
> +	      const struct nlattr * const attr[])
> +{
> +	const struct ip_set *set;
> +	struct sk_buff *skb2;
> +	struct nlmsghdr *nlh2;
> +	ip_set_id_t index;
> +	int ret = 0;
> +
> +	if (unlikely(protocol_failed(attr) ||
> +		     attr[IPSET_ATTR_SETNAME] == NULL))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	index = find_set_id(nla_data(attr[IPSET_ATTR_SETNAME]));
> +	if (index == IPSET_INVALID_ID)
> +		return -EEXIST;

EINVAL/ENOENT?

> +	set = ip_set_list[index];
> +
> +	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (skb2 == NULL)
> +		return -ENOMEM;
> +
> +	nlh2 = start_msg(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 0,
> +			 IPSET_CMD_HEADER);
> +	if (!nlh2)
> +		goto nlmsg_failure;
> +	NLA_PUT_U8(skb2, IPSET_ATTR_PROTOCOL, IPSET_PROTOCOL);
> +	NLA_PUT_STRING(skb2, IPSET_ATTR_SETNAME, set->name);
> +	NLA_PUT_STRING(skb2, IPSET_ATTR_TYPENAME, set->type->name);
> +	NLA_PUT_U8(skb2, IPSET_ATTR_FAMILY, set->family);
> +	NLA_PUT_U8(skb2, IPSET_ATTR_REVISION, set->type->revision);
> +	nlmsg_end(skb2, nlh2);
> +
> +	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
> +	if (ret < 0)
> +		return -EFAULT;

Why not propagate the error?

> +
> +	return 0;
> +
> +nla_put_failure:
> +	nlmsg_cancel(skb2, nlh2);
> +nlmsg_failure:
> +	kfree_skb(skb2);
> +	return -EFAULT;

EMSGSIZE

> +}
> +
> +/* Get type data */
> +
> +static const struct nla_policy ip_set_type_policy[IPSET_ATTR_CMD_MAX + 1] = {
> +	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
> +	[IPSET_ATTR_TYPENAME]	= { .type = NLA_NUL_STRING,
> +				    .len = IPSET_MAXNAMELEN - 1 },
> +	[IPSET_ATTR_FAMILY]	= { .type = NLA_U8 },
> +};
> +
> +static int
> +ip_set_type(struct sock *ctnl, struct sk_buff *skb,
> +	    const struct nlmsghdr *nlh,
> +	    const struct nlattr * const attr[])
> +{
> +	struct sk_buff *skb2;
> +	struct nlmsghdr *nlh2;
> +	u8 family, min, max;
> +	const char *typename;
> +	int ret = 0;
> +
> +	if (unlikely(protocol_failed(attr) ||
> +		     attr[IPSET_ATTR_TYPENAME] == NULL ||
> +		     attr[IPSET_ATTR_FAMILY] == NULL))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	family = nla_get_u8(attr[IPSET_ATTR_FAMILY]);
> +	typename = nla_data(attr[IPSET_ATTR_TYPENAME]);
> +	ret = find_set_type_minmax(typename, family, &min, &max);
> +	if (ret)
> +		return ret;
> +
> +	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (skb2 == NULL)
> +		return -ENOMEM;
> +
> +	nlh2 = start_msg(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 0,
> +			 IPSET_CMD_TYPE);
> +	if (!nlh2)
> +		goto nlmsg_failure;
> +	NLA_PUT_U8(skb2, IPSET_ATTR_PROTOCOL, IPSET_PROTOCOL);
> +	NLA_PUT_STRING(skb2, IPSET_ATTR_TYPENAME, typename);
> +	NLA_PUT_U8(skb2, IPSET_ATTR_FAMILY, family);
> +	NLA_PUT_U8(skb2, IPSET_ATTR_REVISION, max);
> +	NLA_PUT_U8(skb2, IPSET_ATTR_REVISION_MIN, min);
> +	nlmsg_end(skb2, nlh2);
> +
> +	pr_debug("Send TYPE, nlmsg_len: %u\n", nlh2->nlmsg_len);
> +	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
> +	if (ret < 0)
> +		return -EFAULT;

Same here (propagate error).

> +
> +	return 0;
> +
> +nla_put_failure:
> +	nlmsg_cancel(skb2, nlh2);
> +nlmsg_failure:
> +	kfree_skb(skb2);
> +	return -EFAULT;

EMSGSIZE

> +}
> +
> +/* Get protocol version */
> +
> +static const struct nla_policy
> +ip_set_protocol_policy[IPSET_ATTR_CMD_MAX + 1] = {
> +	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
> +};
> +
> +static int
> +ip_set_protocol(struct sock *ctnl, struct sk_buff *skb,
> +		const struct nlmsghdr *nlh,
> +		const struct nlattr * const attr[])
> +{
> +	struct sk_buff *skb2;
> +	struct nlmsghdr *nlh2;
> +	int ret = 0;
> +
> +	if (unlikely(attr[IPSET_ATTR_PROTOCOL] == NULL))
> +		return -IPSET_ERR_PROTOCOL;
> +
> +	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (skb2 == NULL)
> +		return -ENOMEM;
> +
> +	nlh2 = start_msg(skb2, NETLINK_CB(skb).pid, nlh->nlmsg_seq, 0,
> +			 IPSET_CMD_PROTOCOL);
> +	if (!nlh2)
> +		goto nlmsg_failure;
> +	NLA_PUT_U8(skb2, IPSET_ATTR_PROTOCOL, IPSET_PROTOCOL);
> +	nlmsg_end(skb2, nlh2);
> +
> +	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).pid, MSG_DONTWAIT);
> +	if (ret < 0)
> +		return -EFAULT;

Same comments as above regarding this function.

> +
> +	return 0;
> +
> +nla_put_failure:
> +	nlmsg_cancel(skb2, nlh2);
> +nlmsg_failure:
> +	kfree_skb(skb2);
> +	return -EFAULT;
> +}
> +
> +static const struct nfnl_callback ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
> +	[IPSET_CMD_CREATE]	= {
> +		.call		= ip_set_create,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_create_policy,
> +	},
> +	[IPSET_CMD_DESTROY]	= {
> +		.call		= ip_set_destroy,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_setname_policy,
> +	},
> +	[IPSET_CMD_FLUSH]	= {
> +		.call		= ip_set_flush,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_setname_policy,
> +	},
> +	[IPSET_CMD_RENAME]	= {
> +		.call		= ip_set_rename,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_setname2_policy,
> +	},
> +	[IPSET_CMD_SWAP]	= {
> +		.call		= ip_set_swap,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_setname2_policy,
> +	},
> +	[IPSET_CMD_LIST]	= {
> +		.call		= ip_set_dump,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_setname_policy,
> +	},
> +	[IPSET_CMD_SAVE]	= {
> +		.call		= ip_set_dump,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_setname_policy,
> +	},
> +	[IPSET_CMD_ADD]	= {
> +		.call		= ip_set_uadd,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_adt_policy,
> +	},
> +	[IPSET_CMD_DEL]	= {
> +		.call		= ip_set_udel,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_adt_policy,
> +	},
> +	[IPSET_CMD_TEST]	= {
> +		.call		= ip_set_utest,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_adt_policy,
> +	},
> +	[IPSET_CMD_HEADER]	= {
> +		.call		= ip_set_header,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_setname_policy,
> +	},
> +	[IPSET_CMD_TYPE]	= {
> +		.call		= ip_set_type,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_type_policy,
> +	},
> +	[IPSET_CMD_PROTOCOL]	= {
> +		.call		= ip_set_protocol,
> +		.attr_count	= IPSET_ATTR_CMD_MAX,
> +		.policy		= ip_set_protocol_policy,
> +	},
> +};
> +
> +static struct nfnetlink_subsystem ip_set_netlink_subsys __read_mostly = {
> +	.name		= "ip_set",
> +	.subsys_id	= NFNL_SUBSYS_IPSET,
> +	.cb_count	= IPSET_MSG_MAX,
> +	.cb		= ip_set_netlink_subsys_cb,
> +};
> +

