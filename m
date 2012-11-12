From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Mon, 12 Nov 2012 07:50:01 +0100
Message-ID: <20121112065001.GB11330@1984>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35808 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2KLGuK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 01:50:10 -0500
Content-Disposition: inline
In-Reply-To: <1351860231-5434-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Nov 02, 2012 at 01:43:51PM +0100, Florian Westphal wrote:
> similar to connmarks, except labels are bit-based; i.e.
> all labels may be attached to a flow at the same time.
> 
> Up to 1024 labels are supported.
> Mapping of bit-identifier to label name is done in userspace.
> 
> The extension is enabled at run-time once "-m connlabel" netfilter
> rules are added.
> 
> If connlabel rules have been added, sizeof(void*) bytes are allocated
> per conntrack.  This allows to store up to BITS_PER_LONG - 1
> (i.e. 31 or 63) labels without allocating additional memory.
> 
> When this space no longer suffices, additional memory is allocated on
> demand.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Still sending this as an RFC as the ctnetlink glue is
>  still missing.  I plan to work on ctnetlink integration once
>  the extension is deemed to be ok.
> 
>  Changes since V1:
>   - label <-> bit mapping moved to userspace
>   - CONNLABEL target removed in favor of "-m connlabel --label foo --set"
> 
>  userspace patch is at
>  http://git.breakpoint.cc/cgit.cgi/fw/iptables.git/commit/?h=nfct_ext_clabel_02&id=e1ebe4798b206558541d7e50784ec8214c1d7f75
> 
> Current operation:
> - extension is enabled at run-time when -m connlabel rules are added
>   (uses a per-ns refcnt to decide if extension needs to be allocated).
> 
> - instead of allocating the entire possible bit-store area (128 bytes)
>   in the extension, only a pointer is allocated. label-bits are encoded into
>   the pointer.  Once that size is exceeded (i.e., we're asked to set a
>   bit >= BITS_PER_LONG - 1), we kmalloc a larger storage area.
> 
>   Lowest bit of pointer determines if the area is kmalloc'd or not.
>   I've decided to do this because I think most users of this extension
>   won't be using more than, say, 10 labels.
> 
> - testing if a label is set is guarded by rcu; setting a label is guarded
>   by ct->lock.
> 
> Further plans:
>  - extend ctnetlink to send a label bit-vector to userspace, or
>    remove/attach labels from/to connections.
> 
>  This would also require extending libnetfilter_conntrack to provide
>  some meaningful abstraction; I'll send a separate email with an API
>  proposal before working on this, though.
> 
> Deferred/shelved for now:
>  Support for "enumerated labels" (ie. labels that cannot overlap)
>  is missing, but this could easily be added later on.
> 
>  For instance, we could change the pointer-encoding to support
>  2^7 (i.e. 127 non-overlapping enumerated labels) plus
>  24 (or 56 on 64 bit systems) overlapping labels.
> 
>  When more are requested, we can fallback to kmalloc() as we do now,
>  there is enough room in struct __nf_conn_labels_rcu_ptr to
>  add a "u16 enumerated_label".
> 
>  include/net/netfilter/nf_conntrack_extend.h |    4 +
>  include/net/netfilter/nf_conntrack_labels.h |   65 ++++++++++++
>  include/net/netns/conntrack.h               |    3 +
>  include/uapi/linux/netfilter/xt_connlabel.h |   13 +++
>  net/netfilter/Kconfig                       |   16 +++
>  net/netfilter/Makefile                      |    2 +
>  net/netfilter/nf_conntrack_core.c           |   11 ++
>  net/netfilter/nf_conntrack_labels.c         |  143 +++++++++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c        |    3 +
>  net/netfilter/xt_connlabel.c                |   77 ++++++++++++++
>  10 files changed, 337 insertions(+), 0 deletions(-)
>  create mode 100644 include/net/netfilter/nf_conntrack_labels.h
>  create mode 100644 include/uapi/linux/netfilter/xt_connlabel.h
>  create mode 100644 net/netfilter/nf_conntrack_labels.c
>  create mode 100644 net/netfilter/xt_connlabel.c
> 
> diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
> index 8b4d1fc2..977bc8a 100644
> --- a/include/net/netfilter/nf_conntrack_extend.h
> +++ b/include/net/netfilter/nf_conntrack_extend.h
> @@ -23,6 +23,9 @@ enum nf_ct_ext_id {
>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
>  	NF_CT_EXT_TIMEOUT,
>  #endif
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	NF_CT_EXT_LABELS,
> +#endif
>  	NF_CT_EXT_NUM,
>  };
>  
> @@ -33,6 +36,7 @@ enum nf_ct_ext_id {
>  #define NF_CT_EXT_ZONE_TYPE struct nf_conntrack_zone
>  #define NF_CT_EXT_TSTAMP_TYPE struct nf_conn_tstamp
>  #define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
> +#define NF_CT_EXT_LABELS_TYPE struct nf_conn_labels
>  
>  /* Extensions: optional stuff which isn't permanently in struct. */
>  struct nf_ct_ext {
> diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
> new file mode 100644
> index 0000000..dfcad1c
> --- /dev/null
> +++ b/include/net/netfilter/nf_conntrack_labels.h
> @@ -0,0 +1,65 @@
> +#include <linux/types.h>
> +#include <net/net_namespace.h>
> +#include <linux/netfilter/nf_conntrack_common.h>
> +#include <linux/netfilter/nf_conntrack_tuple_common.h>
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_extend.h>
> +
> +#include <uapi/linux/netfilter/xt_connlabel.h>
> +
> +#define NF_CONNLABEL_NOT_ALLOCATED 1
> +
> +struct __nf_conn_labels_rcu_ptr {
> +	struct rcu_head rcu;
> +	u16 maxbit;
> +	unsigned long bits[];
> +};
> +
> +struct nf_conn_labels {
> +	struct __nf_conn_labels_rcu_ptr __rcu *label_bits;
> +};
> +
> +static inline bool __nf_ct_labels_allocated(struct __nf_conn_labels_rcu_ptr *p)
> +{
> +	return ((unsigned long) p & NF_CONNLABEL_NOT_ALLOCATED) == 0;
> +}
> +
> +static inline u16 __nf_ct_labels_get_maxbit(struct __nf_conn_labels_rcu_ptr *p)
> +{
> +	if (__nf_ct_labels_allocated(p))
> +		return p->maxbit;
> +	return BITS_PER_LONG - 1;
> +}
> +
> +static inline struct nf_conn_labels *nf_ct_labels_find(const struct nf_conn *ct)
> +{
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	return nf_ct_ext_find(ct, NF_CT_EXT_LABELS);
> +#endif
> +}
> +
> +static inline struct nf_conn_labels *nf_ct_labels_ext_add(struct nf_conn *ct)
> +{
> +#ifdef CONFIG_NF_CONNTRACK_LABELS
> +	struct nf_conn_labels *cl_ext;
> +	struct net *net = nf_ct_net(ct);
> +
> +	if (net->ct.labels_used == 0)
> +		return NULL;
> +
> +	cl_ext = nf_ct_ext_add(ct, NF_CT_EXT_LABELS, GFP_ATOMIC);
> +	if (cl_ext == NULL)
> +		return NULL;
> +
> +	RCU_INIT_POINTER(cl_ext->label_bits, (void *) NF_CONNLABEL_NOT_ALLOCATED);
> +	return cl_ext;
> +#else
> +	return NULL;
> +#endif
> +}
> +
> +void nf_conntrack_labels_fini(struct net *net);
> +int nf_conntrack_labels_init(struct net *net);
> +
> +bool nf_connlabel_match(const struct nf_conn *ct, u16 bit);
> +int nf_connlabel_set(struct nf_conn *ct, u16 bit);
> diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
> index a1d83cc..e1f0935 100644
> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -83,6 +83,9 @@ struct netns_ct {
>  	int			sysctl_auto_assign_helper;
>  	bool			auto_assign_helper_warned;
>  	struct nf_ip_net	nf_ct_proto;
> +#if defined(CONFIG_NF_CONNTRACK_LABELS)
> +	unsigned int labels_used;
> +#endif
>  #ifdef CONFIG_NF_NAT_NEEDED
>  	struct hlist_head	*nat_bysource;
>  	unsigned int		nat_htable_size;
> diff --git a/include/uapi/linux/netfilter/xt_connlabel.h b/include/uapi/linux/netfilter/xt_connlabel.h
> new file mode 100644
> index 0000000..768739b
> --- /dev/null
> +++ b/include/uapi/linux/netfilter/xt_connlabel.h
> @@ -0,0 +1,13 @@
> +#include <linux/types.h>
> +
> +#define XT_CONNLABEL_MAXBIT 1023
> +enum xt_connlabel_mtopts {
> +	XT_CONNLABEL_OP_INVERT = 1 << 0,
> +	XT_CONNLABEL_OP_SET    = 1 << 1,
> +};
> +
> +struct xt_connlabel_mtinfo {
> +	__u16 bit;
> +	__u16 options;
> +};
> +
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index fefa514..80a0fdd 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -124,6 +124,15 @@ config NF_CONNTRACK_TIMESTAMP
>  
>  	  If unsure, say `N'.
>  
> +config NF_CONNTRACK_LABELS
> +	bool  'Connection tracking labels'
> +	depends on NETFILTER_ADVANCED
> +	help
> +	  This option enables support for assigning user-defined text strings
> +	  to connection tracking entries.
> +
> +	  If unsure, say `N'.
> +
>  config NF_CT_PROTO_DCCP
>  	tristate 'DCCP protocol connection tracking support (EXPERIMENTAL)'
>  	depends on EXPERIMENTAL
> @@ -472,6 +481,13 @@ config NETFILTER_XT_SET
>  
>  	  To compile it as a module, choose M here.  If unsure, say N.
>  
> +config NETFILTER_XT_CONNLABELS
> +	tristate '"connlimit" target and match support"'
> +	depends on NF_CONNTRACK_LABELS
> +	---help---
> +	  This match allows you to match against connlabels assigned to the
> +	  connection.
> +
>  # alphabetically ordered list of targets
>  
>  comment "Xtables targets"
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 3259697..0e7139c 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -4,6 +4,7 @@ nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_exp
>  nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
>  nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
>  nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
> +nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) += nf_conntrack_labels.o
>  
>  obj-$(CONFIG_NETFILTER) = netfilter.o
>  
> @@ -70,6 +71,7 @@ obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
>  obj-$(CONFIG_NETFILTER_XT_MARK) += xt_mark.o
>  obj-$(CONFIG_NETFILTER_XT_CONNMARK) += xt_connmark.o
>  obj-$(CONFIG_NETFILTER_XT_SET) += xt_set.o
> +obj-$(CONFIG_NETFILTER_XT_CONNLABELS) += xt_connlabel.o
>  obj-$(CONFIG_NF_NAT) += xt_nat.o
>  
>  # targets
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0f241be..c19e25c 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -45,6 +45,7 @@
>  #include <net/netfilter/nf_conntrack_zones.h>
>  #include <net/netfilter/nf_conntrack_timestamp.h>
>  #include <net/netfilter/nf_conntrack_timeout.h>
> +#include <net/netfilter/nf_conntrack_labels.h>
>  #include <net/netfilter/nf_nat.h>
>  #include <net/netfilter/nf_nat_core.h>
>  
> @@ -770,6 +771,7 @@ void nf_conntrack_free(struct nf_conn *ct)
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_free);
>  
> +
>  /* Allocate a new conntrack: we return -ENOMEM if classification
>     failed due to stress.  Otherwise it really is unclassifiable. */
>  static struct nf_conntrack_tuple_hash *
> @@ -816,6 +818,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
>  
>  	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
>  	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
> +	nf_ct_labels_ext_add(ct);
>  
>  	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
>  	nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
> @@ -1585,7 +1588,15 @@ static int nf_conntrack_init_net(struct net *net)
>  	ret = nf_conntrack_helper_init(net);
>  	if (ret < 0)
>  		goto err_helper;
> +
> +	ret = nf_conntrack_labels_init(net);
> +	if (ret < 0)
> +		goto err_labels;
> +
>  	return 0;
> +
> +err_labels:
> +	nf_conntrack_helper_fini(net);
>  err_helper:
>  	nf_conntrack_timeout_fini(net);
>  err_timeout:
> diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
> new file mode 100644
> index 0000000..eab398b
> --- /dev/null
> +++ b/net/netfilter/nf_conntrack_labels.c
> @@ -0,0 +1,143 @@
> +#include <linux/ctype.h>
> +#include <linux/export.h>
> +#include <linux/jhash.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +
> +#include <net/netfilter/nf_conntrack_ecache.h>
> +#include <net/netfilter/nf_conntrack_labels.h>
> +
> +static int labels_set_realloc(struct nf_conn_labels *l,
> +			      struct __nf_conn_labels_rcu_ptr *oldptr, u16 bit)

I think we can simplify this code if we use the CT target to set the
number of labels that we'll use, so we skip allocations in runtime and
possible reallocation.

... -t raw -j CT --labels 32

> +{
> +	struct __nf_conn_labels_rcu_ptr *ptr;
> +	u32 word, i, size;
> +	u16 maxbit;
> +
> +	size = round_up(bit+1, BITS_PER_LONG) / BITS_PER_LONG;
> +	size *= sizeof(long);
> +
> +	ptr = kmalloc(sizeof(*ptr) + size, GFP_ATOMIC);
> +	if (!ptr)
> +		return -ENOMEM;
> +
> +	if (__nf_ct_labels_allocated(oldptr)) {
> +		word = BIT_WORD(oldptr->maxbit);
> +		for (i = 0; i <= word; i++)
> +			ptr->bits[i] = oldptr->bits[i];
> +		kfree_rcu(oldptr, rcu);
> +	} else {
> +		unsigned long tmp = (unsigned long) oldptr;
> +		ptr->bits[0] = tmp >> NF_CONNLABEL_NOT_ALLOCATED;
> +		i = 1;
> +	}
> +
> +	maxbit = (size * BITS_PER_BYTE) - 1;
> +	word = BIT_WORD(maxbit);
> +	for (;i <= word; i++)
> +		ptr->bits[i] = 0;
> +
> +	set_bit(bit, ptr->bits);
> +	ptr->maxbit = maxbit;
> +	rcu_assign_pointer(l->label_bits, ptr);
> +	return 0;
> +}
> +
> +static bool __nf_connlabel_match(struct nf_conn_labels *labels, u16 bit)
> +{
> +	struct __nf_conn_labels_rcu_ptr *ptr = rcu_dereference(labels->label_bits);
> +
> +	if (!__nf_ct_labels_allocated(ptr)) {
> +		unsigned long tmp = (unsigned long) ptr >> NF_CONNLABEL_NOT_ALLOCATED;
> +		return bit < BITS_PER_LONG && test_bit(bit, &tmp);
> +	}
> +
> +	return bit <= ptr->maxbit && test_bit(bit, ptr->bits);
> +}
> +
> +bool nf_connlabel_match(const struct nf_conn *ct, u16 bit)
> +{
> +	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
> +	bool ret;
> +
> +	if (!labels)
> +		return false;
> +
> +	rcu_read_lock();
> +	ret = __nf_connlabel_match(labels, bit);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(nf_connlabel_match);
> +
> +int nf_connlabel_set(struct nf_conn *ct, u16 bit)
> +{
> +	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
> +	struct __nf_conn_labels_rcu_ptr *ptr;
> +	int err;
> +
> +	if (!labels)
> +		return -ENOSPC;
> +
> +	rcu_read_lock();
> +	if (__nf_connlabel_match(labels, bit)) {
> +		rcu_read_unlock();
> +		return 0; /* fast path: already set */
> +	}
> +	rcu_read_unlock();
> +
> +	spin_lock(&ct->lock);
> +
> +	ptr = rcu_dereference_protected(labels->label_bits, 1);
> +	if (__nf_ct_labels_allocated(ptr)) {
> +		if (bit <= ptr->maxbit) {
> +			set_bit(bit, ptr->bits);
> +			err = 0;
> +		} else
> +			err = labels_set_realloc(labels, ptr, bit);
> +	} else if (bit < (BITS_PER_LONG - NF_CONNLABEL_NOT_ALLOCATED)) {
> +		unsigned long tmp = (unsigned long) ptr;
> +		bit = 1 << (bit + NF_CONNLABEL_NOT_ALLOCATED);
> +		rcu_assign_pointer(labels->label_bits, (void *) (tmp|bit));
> +		err = 0;
> +	} else {
> +		err = labels_set_realloc(labels, ptr, bit);
> +	}
> +
> +	spin_unlock(&ct->lock);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(nf_connlabel_set);
> +
> +static void nf_ct_ext_label_destroy(struct nf_conn *ct)
> +{
> +	struct nf_conn_labels *labels = nf_ct_labels_find(ct);
> +	if (labels) {
> +		struct __nf_conn_labels_rcu_ptr *p = rcu_dereference(labels->label_bits);
> +		if (__nf_ct_labels_allocated(p))
> +			kfree(p);
> +	}
> +}
> +
> +static struct nf_ct_ext_type labels_extend __read_mostly = {
> +	.len    = sizeof(struct nf_conn_labels),
> +	.align  = __alignof__(struct nf_conn_labels),
> +	.destroy = nf_ct_ext_label_destroy,
> +	.id     = NF_CT_EXT_LABELS,
> +};
> +
> +int nf_conntrack_labels_init(struct net *net)
> +{
> +	if (net_eq(net, &init_net))
> +		return nf_ct_extend_register(&labels_extend);
> +	return 0;
> +}
> +
> +void nf_conntrack_labels_fini(struct net *net)
> +{
> +	if (net_eq(net, &init_net))
> +		nf_ct_extend_unregister(&labels_extend);
> +}
> +
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 7bbfb3d..cf22362 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -43,6 +43,7 @@
>  #include <net/netfilter/nf_conntrack_acct.h>
>  #include <net/netfilter/nf_conntrack_zones.h>
>  #include <net/netfilter/nf_conntrack_timestamp.h>
> +#include <net/netfilter/nf_conntrack_labels.h>
>  #ifdef CONFIG_NF_NAT_NEEDED
>  #include <net/netfilter/nf_nat_core.h>
>  #include <net/netfilter/nf_nat_l4proto.h>
> @@ -1489,6 +1490,8 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>  	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
>  	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
>  	nf_ct_ecache_ext_add(ct, 0, 0, GFP_ATOMIC);
> +	nf_ct_labels_ext_add(ct);
> +
>  	/* we must add conntrack extensions before confirmation. */
>  	ct->status |= IPS_CONFIRMED;
>  
> diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
> new file mode 100644
> index 0000000..40c92f3
> --- /dev/null
> +++ b/net/netfilter/xt_connlabel.c
> @@ -0,0 +1,77 @@
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <net/netfilter/nf_conntrack.h>
> +#include <net/netfilter/nf_conntrack_labels.h>
> +#include <linux/netfilter/x_tables.h>
> +
> +static bool
> +connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
> +{
> +        const struct xt_connlabel_mtinfo *info = par->matchinfo;
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +	bool invert = info->options & XT_CONNLABEL_OP_INVERT;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct == NULL || nf_ct_is_untracked(ct))
> +		return invert;
> +
> +	if (info->options & XT_CONNLABEL_OP_SET)
> +		return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;
> +
> +	return nf_connlabel_match(ct, info->bit) ^ invert;
> +}
> +
> +static int connlabel_mt_check(const struct xt_mtchk_param *par)
> +{
> +	const int options = XT_CONNLABEL_OP_INVERT |
> +			    XT_CONNLABEL_OP_SET;
> +	struct xt_connlabel_mtinfo *info = par->matchinfo;
> +	int ret;
> +
> +	if (info->bit > XT_CONNLABEL_MAXBIT)
> +		return -ERANGE;
> +
> +	if (info->options & ~options) {
> +		pr_err("Unknown options in mask %x\n", info->options);
> +		return -EINVAL;
> +	}
> +
> +	ret = nf_ct_l3proto_try_module_get(par->family);
> +	if (ret < 0) {
> +		pr_info("cannot load conntrack support for proto=%u\n", par->family);
> +		return ret;
> +	}
> +
> +	par->net->ct.labels_used++;
> +	return ret;
> +}
> +
> +static void connlabel_mt_destroy(const struct xt_mtdtor_param *par)
> +{
> +	par->net->ct.labels_used--;
> +	nf_ct_l3proto_module_put(par->family);
> +}
> +
> +static struct xt_match connlabels_mt_reg __read_mostly = {
> +        .name           = "connlabel",
> +        .family         = NFPROTO_UNSPEC,
> +        .checkentry     = connlabel_mt_check,
> +        .match          = connlabel_mt,
> +        .matchsize      = sizeof(struct xt_connlabel_mtinfo),
> +        .destroy        = connlabel_mt_destroy,
> +        .me             = THIS_MODULE,
> +};
> +
> +static int __init connlabel_mt_init(void)
> +{
> +	return xt_register_match(&connlabels_mt_reg);
> +}
> +
> +static void __exit connlabel_mt_exit(void)
> +{
> +	xt_unregister_match(&connlabels_mt_reg);
> +}
> +
> +module_init(connlabel_mt_init);
> +module_exit(connlabel_mt_exit);
> -- 
> 1.7.8.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
