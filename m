From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH v2 -next] netfilter: ctnetlink: attach expectations to
 unconfirmed conntracks
Date: Wed, 07 Aug 2013 18:27:19 +0800
Message-ID: <52022107.30206@cn.fujitsu.com>
References: <1375795183-10820-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16374 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab3HGKZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:25:59 -0400
In-Reply-To: <1375795183-10820-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/06/2013 09:19 PM, Pablo Neira Ayuso wrote:
> This patch adds the capability to attach expectations to unconfirmed
> conntrack entries. This patch is required by conntrack helpers that
> trigger expectations based on the first packet seen like the TFTP and
> the DHCPv6 user-space helpers.
> 
> There is no need to bump the conntrack refcount since unconfirmed
> conntracks are not yet in the hashes, thus, they are just referenced
> by one single packet. There is no trouble either in the get_next_corpse
> path, as unconfirmed conntracks only get their dying bit set to
> be discarded later on by nf_conntrack_confirm.
> 

The use after free problem still may happen.

the unconfirmed conntrack is created when we receive the first packet,
then this conntrack is linked in the per net global unconfirmed list.

And this conntrack may be destroyed when the return value of l4proto->packet
low than 0 in nf_conntrack_in.

I haven't check it carefully. maybe I am incorrect.


Thanks
Gao

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack.h               |    4 ++++
>  include/uapi/linux/netfilter/nfnetlink_conntrack.h |    1 +
>  net/netfilter/nf_conntrack_core.c                  |   20 ++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c               |   17 ++++++++++++++---
>  4 files changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index e5eb8b6..73e36b5 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -180,6 +180,10 @@ extern struct nf_conntrack_tuple_hash *
>  __nf_conntrack_find(struct net *net, u16 zone,
>  		    const struct nf_conntrack_tuple *tuple);
>  
> +struct nf_conntrack_tuple_hash *
> +nf_ct_unconfirmed_find(struct net *net, u16 zone,
> +		       const struct nf_conntrack_tuple *tuple);
> +
>  extern int nf_conntrack_hash_check_insert(struct nf_conn *ct);
>  bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
>  
> diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
> index 08fabc6..8f7c2fe 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
> @@ -187,6 +187,7 @@ enum ctattr_expect {
>  	CTA_EXPECT_CLASS,
>  	CTA_EXPECT_NAT,
>  	CTA_EXPECT_FN,
> +	CTA_EXPECT_MASTER_STATUS,
>  	__CTA_EXPECT_MAX
>  };
>  #define CTA_EXPECT_MAX (__CTA_EXPECT_MAX - 1)
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0934611..9e5e5b3 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -406,6 +406,26 @@ nf_conntrack_find_get(struct net *net, u16 zone,
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
>  
> +struct nf_conntrack_tuple_hash *
> +nf_ct_unconfirmed_find(struct net *net, u16 zone,
> +		       const struct nf_conntrack_tuple *tuple)
> +{
> +	struct nf_conntrack_tuple_hash *h, *ret = NULL;
> +	struct hlist_nulls_node *n;
> +
> +	rcu_read_lock();
> +	hlist_nulls_for_each_entry_rcu(h, n, &net->ct.unconfirmed, hnnode) {
> +		if (nf_ct_tuple_equal(tuple, &h->tuple) &&
> +		    nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)) == zone) {
> +			ret = h;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(nf_ct_unconfirmed_find);
> +
>  static void __nf_conntrack_hash_insert(struct nf_conn *ct,
>  				       unsigned int hash,
>  				       unsigned int repl_hash)
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index e842c0d..7e50790 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2747,7 +2747,7 @@ ctnetlink_create_expect(struct net *net, u16 zone,
>  	struct nf_conn *ct;
>  	struct nf_conn_help *help;
>  	struct nf_conntrack_helper *helper = NULL;
> -	u_int32_t class = 0;
> +	u_int32_t class = 0, master_status;
>  	int err = 0;
>  
>  	/* caller guarantees that those three CTA_EXPECT_* exist */
> @@ -2761,8 +2761,18 @@ ctnetlink_create_expect(struct net *net, u16 zone,
>  	if (err < 0)
>  		return err;
>  
> +	if (cda[CTA_EXPECT_MASTER_STATUS]) {
> +		master_status =
> +			ntohl(nla_get_be32(cda[CTA_EXPECT_MASTER_STATUS]));
> +	} else
> +		master_status = IPS_CONFIRMED;
> +
>  	/* Look for master conntrack of this expectation */
> -	h = nf_conntrack_find_get(net, zone, &master_tuple);
> +	if (master_status & IPS_CONFIRMED)
> +		h = nf_conntrack_find_get(net, zone, &master_tuple);
> +	else
> +		h = nf_ct_unconfirmed_find(net, zone, &master_tuple);
> +
>  	if (!h)
>  		return -ENOENT;
>  	ct = nf_ct_tuplehash_to_ctrack(h);
> @@ -2856,7 +2866,8 @@ ctnetlink_create_expect(struct net *net, u16 zone,
>  err_out:
>  	nf_ct_expect_put(exp);
>  out:
> -	nf_ct_put(nf_ct_tuplehash_to_ctrack(h));
> +	if (nf_ct_is_confirmed(ct))
> +		nf_ct_put(ct);
>  	return err;
>  }
>  
> 

