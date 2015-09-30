From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: nfnetlink_log: allow to attach
 conntrack
Date: Thu, 1 Oct 2015 00:10:03 +0200
Message-ID: <20150930221003.GB14844@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031037.GD7380@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42622 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbbI3WDN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2015 18:03:13 -0400
Content-Disposition: inline
In-Reply-To: <20150911031037.GD7380@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 11, 2015 at 12:10:37PM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch enables to include the conntrack information together
> with the packet that is sent to user-space via NFLOG, then a
> user-space program can acquire NATed information by this NFULA_CT
> attribute.
> 
> Including the conntrack information is optional, you can set it
> via NFULNL_CFG_F_CONNTRACK flag with the NFULA_CFG_FLAGS attribute
> like NFQUEUE.
> 
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  include/uapi/linux/netfilter/nfnetlink_log.h |    3 ++
>  net/netfilter/Kconfig                        |    8 +++++
>  net/netfilter/nf_conntrack_netlink.c         |    8 ++---
>  net/netfilter/nfnetlink_log.c                |   42 ++++++++++++++++++++++----
>  4 files changed, 51 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
> index 90c2c95..081e7f9 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_log.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_log.h
> @@ -51,6 +51,8 @@ enum nfulnl_attr_type {
>  	NFULA_HWTYPE,			/* hardware type */
>  	NFULA_HWHEADER,			/* hardware header */
>  	NFULA_HWLEN,			/* hardware header length */
> +	NFULA_CT,			/* nf_conntrack_netlink.h */
> +	NFULA_CT_INFO,			/* enum ip_conntrack_info */
>  
>  	__NFULA_MAX
>  };
> @@ -93,5 +95,6 @@ enum nfulnl_attr_config {
>  
>  #define NFULNL_CFG_F_SEQ	0x0001
>  #define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
> +#define NFULNL_CFG_F_CONNTRACK	0x0004
>  
>  #endif /* _NFNETLINK_LOG_H */
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 3e1b4ab..a8853c8 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -370,6 +370,14 @@ config NETFILTER_NETLINK_QUEUE_CT
>  	  If this option is enabled, NFQUEUE can include Connection Tracking
>  	  information together with the packet is the enqueued via NFNETLINK.
>  
> +config NETFILTER_NETLINK_LOG_CT
> +        bool "NLOG integration with Connection Tracking"
   ^^^^^^^^
Use tabs to indent.

> +        default n
   ^^^^^^^^
Same here.

> +        depends on NETFILTER_NETLINK_LOG
> +	help
> +	  If this option is enabled, NFLOG can include Connection Tracking
> +	  information.
> +
>  config NF_NAT
>  	tristate
>  
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 155b2d0..ccdce3a 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2138,7 +2138,7 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
>  		       struct nf_conntrack_tuple *tuple,
>  		       struct nf_conntrack_tuple *mask);
>  
> -#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
> +#if defined(CONFIG_NETFILTER_NETLINK_QUEUE_CT) || defined(NETFILTER_NETLINK_LOG_CT)
>  static struct nf_conn *ctnetlink_glue_get_ct(const struct sk_buff *skb,
>  					     enum ip_conntrack_info *ctinfo)
>  {
> @@ -2382,7 +2382,7 @@ static struct nfnl_ct_hook ctnetlink_glue_hook = {
>  	.attach_expect	= ctnetlink_glue_attach_expect,
>  	.seq_adjust	= ctnetlink_glue_seqadj,
>  };
> -#endif /* CONFIG_NETFILTER_NETLINK_QUEUE_CT */
> +#endif /* CONFIG_NETFILTER_NETLINK_QUEUE_CT || NETFILTER_NETLINK_LOG_CT */
>  
>  /***********************************************************************
>   * EXPECT
> @@ -3366,7 +3366,7 @@ static int __init ctnetlink_init(void)
>  		pr_err("ctnetlink_init: cannot register pernet operations\n");
>  		goto err_unreg_exp_subsys;
>  	}
> -#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
> +#if defined(CONFIG_NETFILTER_NETLINK_QUEUE_CT) || defined(NETFILTER_NETLINK_LOG_CT)
>  	/* setup interaction between nf_queue and nf_conntrack_netlink. */
>  	RCU_INIT_POINTER(nfnl_ct_hook, &ctnetlink_glue_hook);
>  #endif
> @@ -3387,7 +3387,7 @@ static void __exit ctnetlink_exit(void)
>  	unregister_pernet_subsys(&ctnetlink_net_ops);
>  	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
>  	nfnetlink_subsys_unregister(&ctnl_subsys);
> -#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
> +#if defined(CONFIG_NETFILTER_NETLINK_QUEUE_CT) || defined(NETFILTER_NETLINK_LOG_CT)
>  	RCU_INIT_POINTER(nfnl_ct_hook, NULL);
>  #endif
>  }
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 4670821..9d04c21 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -27,6 +27,7 @@
>  #include <net/netlink.h>
>  #include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nfnetlink_log.h>
> +#include <linux/netfilter/nf_conntrack_common.h>
>  #include <linux/spinlock.h>
>  #include <linux/sysctl.h>
>  #include <linux/proc_fs.h>
> @@ -401,7 +402,9 @@ __build_packet_message(struct nfnl_log_net *log,
>  			unsigned int hooknum,
>  			const struct net_device *indev,
>  			const struct net_device *outdev,
> -			const char *prefix, unsigned int plen)
> +			const char *prefix, unsigned int plen,
> +			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
> +
>  {
>  	struct nfulnl_msg_packet_hdr pmsg;
>  	struct nlmsghdr *nlh;
> @@ -409,6 +412,7 @@ __build_packet_message(struct nfnl_log_net *log,
>  	sk_buff_data_t old_tail = inst->skb->tail;
>  	struct sock *sk;
>  	const unsigned char *hwhdrp;
> +	struct nfnl_ct_hook *nflog_ct;
>  
>  	nlh = nlmsg_put(inst->skb, 0, 0,
>  			NFNL_SUBSYS_ULOG << 8 | NFULNL_MSG_PACKET,
> @@ -575,6 +579,14 @@ __build_packet_message(struct nfnl_log_net *log,
>  			 htonl(atomic_inc_return(&log->global_seq))))
>  		goto nla_put_failure;
>  
> +	/* conntrack */

Please remove this comment.

> +	if (ct) {
> +		nflog_ct = rcu_dereference(nfnl_ct_hook);
> +		if (nflog_ct->build(inst->skb, ct, ctinfo,
> +				    NFULA_CT, NFULA_CT_INFO) < 0)
> +			goto nla_put_failure;
> +	}
> +
>  	if (data_len) {
>  		struct nlattr *nla;
>  		int size = nla_attr_size(data_len);
> @@ -620,12 +632,16 @@ nfulnl_log_packet(struct net *net,
>  		  const struct nf_loginfo *li_user,
>  		  const char *prefix)
>  {
> -	unsigned int size, data_len;
> +	size_t size;
> +	unsigned int data_len;
>  	struct nfulnl_instance *inst;
>  	const struct nf_loginfo *li;
>  	unsigned int qthreshold;
>  	unsigned int plen;
>  	struct nfnl_log_net *log = nfnl_log_pernet(net);
> +	struct nfnl_ct_hook *nflog_ct;
> +	struct nf_conn *ct = NULL;
> +	enum ip_conntrack_info uninitialized_var(ctinfo);
>  
>  	if (li_user && li_user->type == NF_LOG_TYPE_ULOG)
>  		li = li_user;
> @@ -671,7 +687,14 @@ nfulnl_log_packet(struct net *net,
>  		size += nla_total_size(sizeof(u_int32_t));
>  	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
>  		size += nla_total_size(sizeof(u_int32_t));
> -
> +	if (inst->flags & NFULNL_CFG_F_CONNTRACK) {
> +		nflog_ct = rcu_dereference(nfnl_ct_hook);
> +		if (nflog_ct != NULL) {
> +			ct = nflog_ct->get_ct(skb, &ctinfo);
> +			if (ct != NULL)
> +				size += nflog_ct->build_size(ct);
> +		}
> +	}
>  	qthreshold = inst->qthreshold;
>  	/* per-rule qthreshold overrides per-instance */
>  	if (li->u.ulog.qthreshold)
> @@ -715,7 +738,7 @@ nfulnl_log_packet(struct net *net,
>  	inst->qlen++;
>  
>  	__build_packet_message(log, inst, skb, data_len, pf,
> -				hooknum, in, out, prefix, plen);
> +				hooknum, in, out, prefix, plen, ct, ctinfo);
>  
>  	if (inst->qlen >= qthreshold)
>  		__nfulnl_flush(inst);
> @@ -899,13 +922,20 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
>  	}
>  
>  	if (nfula[NFULA_CFG_FLAGS]) {
> -		__be16 flags = nla_get_be16(nfula[NFULA_CFG_FLAGS]);
> +		__be16 flags = ntohs(nla_get_be16(nfula[NFULA_CFG_FLAGS]));

You have to use u16 instead, otherwise 'sparse' checks via make C=2
will complain.

>  		if (!inst) {
>  			ret = -ENODEV;
>  			goto out;
>  		}
> -		nfulnl_set_flags(inst, ntohs(flags));
> +
> +		if (flags & NFULNL_CFG_F_CONNTRACK &&
> +		    rcu_dereference(nfnl_ct_hook) == NULL) {
> +			ret = -EOPNOTSUPP;
> +			goto out_put;
> +		}
> +
> +		nfulnl_set_flags(inst, flags);
>  	}
>  
>  out_put:
> -- 
> 1.7.10.4
> 
