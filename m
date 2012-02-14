From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/7] netfilter: xtables2: chain creation and deletion
Date: Tue, 14 Feb 2012 12:07:12 +0100
Message-ID: <20120214110712.GA27221@1984>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
 <1326990381-14534-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48889 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab2BNLHT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:07:19 -0500
Content-Disposition: inline
In-Reply-To: <1326990381-14534-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 19, 2012 at 05:26:17PM +0100, Jan Engelhardt wrote:
[...]
> diff --git a/net/netfilter/xt2_nfnetlink.c b/net/netfilter/xt2_nfnetlink.c
> index 3dc241f..b50e468d 100644
> --- a/net/netfilter/xt2_nfnetlink.c
> +++ b/net/netfilter/xt2_nfnetlink.c
> @@ -17,6 +17,7 @@
>  #include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nfnetlink_xtables.h>
>  #include <net/netlink.h>
> +#include <net/sock.h>
>  #include <net/netfilter/x_tables2.h>
>  
>  MODULE_DESCRIPTION("Xtables2 nfnetlink interface");
> @@ -69,6 +70,66 @@ xtnetlink_fill(struct sk_buff *skb, const struct xtnetlink_pktref *old,
>  }
>  
>  /**
> + * @ref:	skb/nl pointers that will be filled in (secondary return values)
> + * @old:	pointers to the original incoming skb/nl headers
> + *
> + * xtnetlink_fill can be used when the outgoing skb already exists (e.g. in
> + * case of a dump operation), but for non-dump responses, we have to create it
> + * ourselves.
> + */
> +static int
> +xtnetlink_new_fill(struct xtnetlink_pktref *ref,
> +		   const struct xtnetlink_pktref *old)
> +{
> +	ref->skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (ref->skb == NULL)
> +		return -ENOMEM;
> +	ref->msg = xtnetlink_fill(ref->skb, old, 0);
> +	if (IS_ERR(ref->msg)) {
> +		kfree_skb(ref->skb);
> +		return PTR_ERR(ref->msg);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * @xtnl:	socket to send the error packet out on
> + * @old:	pointers to the original incoming skb/nl headers
> + * @errcode:	last error code
> + *
> + * Create and send out an NFXT error packet. If @errcode is < 0, it indicates
> + * a system-level error (such as %-ENOMEM), reported back using %NFXTA_ERRNO.
> + * If @errcode is >= 0, it indicates an NFXT-specific error codes (%NFXTE_*),
> + * which is more fine grained than the dreaded %EINVAL, and which is reported
> + * back using %NFXTA_XTERRNO.
> + */
> +static int
> +xtnetlink_error(struct sock *xtnl, const struct xtnetlink_pktref *old,
> +		int errcode)
> +{
> +	struct xtnetlink_pktref ref;
> +	int ret;
> +
> +	ret = xtnetlink_new_fill(&ref, old);
> +	if (ret < 0)
> +		return ret;
> +	if (errcode < 0)
> +		/* Prefer positive numbers on the wire */
> +		NLA_PUT_U32(ref.skb, NFXTA_ERRNO, -errcode);
> +	else
> +		NLA_PUT_U32(ref.skb, NFXTA_XTERRNO, errcode);
> +	nlmsg_end(ref.skb, ref.msg);
> +	ret = netlink_unicast(xtnl, ref.skb, NETLINK_CB(old->skb).pid,
> +			      MSG_DONTWAIT);
> +	if (ret < 0)
> +		return ret;
> +	/* ret is skb->len, but values >0 mean error to the caller -.- */
> +	return 0;
> + nla_put_failure:
> +	return -ENOBUFS;
> +}

You seem to be using some similar approach that ipset uses for error
handling. I like the idea of having fine grain error handling indeed,
but I think we can extend the Netlink framework to integrate as part
of NLMSG_ERR message types.

My idea is to attach the specific error at the end of the NLMSG_ERR,
IIRC we need to allow passing one callback to netlink_ack to add the
specific error message after the generic netlink error message.

I think this will be also backward compatible with existing netlink
library since they will ignore the trailing part of the error message
that they don't know how to interpret.

> +static int
> +xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
> +		    const struct nlmsghdr *imsg, const struct nlattr *const *ad)
> +{
> +	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
> +	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
> +	const struct nlattr *attr;
> +	struct xt2_table *table;
> +	struct xt2_chain *chain;
> +	const char *name;
> +	int ret = 0;
> +
> +	attr = nlmsg_find_attr(imsg, sizeof(struct nfgenmsg), NFXTA_NAME);
> +	if (attr == NULL)
> +		return xtnetlink_error(xtnl, &ref, NFXTE_ATTRSET_INCOMPLETE);
> +	name = nla_data(attr);
> +	if (*name == '\0')

I think you may better identify this special chains with some flags?
You end up defining flags for objects sooner or later instead of using
this special name.

> +		/* Anonymous chains are internal. */
> +		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_INVALID_NAME);
> +	/*
> +	 * The table needs to stay, but note that rcu_read_lock cannot be used,
> +	 * since we might sleep.
> +	 */
> +	mutex_lock(&pnet->master_lock);
> +	table = pnet->master;
> +	mutex_lock(&table->lock);
> +	if (xt2_chain_lookup(table, name) != NULL) {
> +		ret = xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_EXISTS);
> +	} else {
> +		chain = xt2_chain_new(table, name);
> +		if (IS_ERR(chain))
> +			ret = PTR_ERR(chain);
> +		/* Use NFXTE error codes whenever possible. */
> +		if (ret == -ENAMETOOLONG)
> +			ret = NFXTE_CHAIN_NAMETOOLONG;
> +		ret = xtnetlink_error(xtnl, &ref, ret);
> +	}
> +	mutex_unlock(&table->lock);
> +	mutex_unlock(&pnet->master_lock);
> +	return ret;
> +}
> +
> +/**
> + * Act on a %NFXTM_CHAIN_DEL message.
> + */
> +static int
> +xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
> +		    const struct nlmsghdr *imsg,
> +		    const struct nlattr *const *ad)
> +{
> +	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
> +	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
> +	const struct nlattr *name_attr;
> +	struct xt2_table *table;
> +	struct xt2_chain *chain;
> +	const char *name;
> +	int ret = 0;
> +
> +	name_attr = nlmsg_find_attr(imsg, sizeof(struct nfgenmsg), NFXTA_NAME);
> +	if (name_attr == NULL)
> +		return xtnetlink_error(xtnl, &ref, NFXTE_ATTRSET_INCOMPLETE);
> +	name = nla_data(name_attr);
> +	if (*name == '\0')
> +		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_NOENT);
> +
> +	mutex_lock(&pnet->master_lock);
> +	table = pnet->master;
> +	mutex_lock(&table->lock);
> +	chain = xt2_chain_lookup(table, name);
> +	if (chain != NULL)
> +		xt2_chain_free(chain);
> +	else
> +		ret = NFXTE_CHAIN_NOENT;
> +	ret = xtnetlink_error(xtnl, &ref, ret);
> +	mutex_unlock(&table->lock);
> +	mutex_unlock(&pnet->master_lock);
> +	return ret;
> +}
> +
>  static const struct nla_policy xtnetlink_policy[] = {
>  	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
> +	[NFXTA_ERRNO] = {.type = NLA_U32},
> +	[NFXTA_XTERRNO] = {.type = NLA_U32},
>  };
>  
>  /*
>   * Use the same policy for all messages. I do not want to see EINVAL anytime
>   * soon again just because I forgot sending an attribute from userspace.
> - * (If such occurs, it will be dealt with %NFXTE_ATTRSET_INCOMPLETE, tbd.)
> + * (If such occurs, it will be dealt with %NFXTE_ATTRSET_INCOMPLETE.)
>   */
>  #define pol \
>  	.policy = xtnetlink_policy, \
> @@ -128,6 +270,8 @@ static const struct nla_policy xtnetlink_policy[] = {
>  static const struct nfnl_callback xtnetlink_callback[] = {
>  	[0] = {.call = xtnetlink_ignore},
>  	[NFXTM_IDENTIFY] = {.call = xtnetlink_identify, pol},
> +	[NFXTM_CHAIN_NEW] = {.call = xtnetlink_chain_new, pol},
> +	[NFXTM_CHAIN_DEL] = {.call = xtnetlink_chain_del, pol},
>  };
>  #undef pol
>  
> -- 
> 1.7.7
> 
