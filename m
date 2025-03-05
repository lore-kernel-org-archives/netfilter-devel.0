Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9922E3373
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 22:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741212527; cv=none; b=P2Wq6U0PJw3Ipbj+lNER8O13o2WvsLzR69h1pW3NSEhMkCiA7zqMyff8xx5nZ+0p3FFl51O2pbsoO/GEdN3ux9D7mWLuZ9Pcj/vs1YRynfjozynGo9FFrkYMFl91nlBkg/umGLfPJRgNBOjEPoZPUs4N7HHW4it6LyBRJgOji4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741212527; c=relaxed/simple;
	bh=YjYsxYkncRbWFFi0uD61Odr4vunHAa4NywCUO31BlUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odmrTs9AQshLXFqixXAPvCY3aUg3IWikft807k99AcDDgV6pAY6bhuXv2bBX1jbZxGC63urxk1U7Vfxhc8p9FDYJwja7cG8xzB6pqm7ZyPPagFr5F1hP6PQLCGxLHht3ORJbmSQ+Eb/n6DIBoTRt4V9kk0RcwXcJgMHZFbTjxjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nbBPhmTQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QZRqSasw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nbBPhmTQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QZRqSasw"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BEE3A6028B; Wed,  5 Mar 2025 23:08:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741212522;
	bh=zC3I9WSYvNYvTkta53ad6cupHkvlc1MQQGTTVlzXeBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nbBPhmTQdPlKZIatZO+sy8V46a0p4qQ9x3pB3zt4YI2X/YWWzWiWaRtAvpnGF9mD+
	 9ukWyMSZPSxy9rwLACdPB1Vbc463O2rFH+lNVqpHQp7CDYfyhOzYPXoQWA0yHKjr0e
	 2u1Vds/vWpvND37GfGOyegSV5bgyPQ8bO65tno2501nqly5ax1Cnrt2JDB5ziAYTfk
	 g8v2V1dFmcXlvjOXTmgXbyrbMPZPJEUVypidi+ohCXxpBzTmD95rza4R7BTauw/2Fm
	 VIHxWQ/g0duJbxT45sppVmxQLpVz2G2RRISULSC9j9PWY1585nKfvJ8QESP1PqXrZ1
	 arZkYxqB1Luvw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AC42560277;
	Wed,  5 Mar 2025 23:08:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741212520;
	bh=zC3I9WSYvNYvTkta53ad6cupHkvlc1MQQGTTVlzXeBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QZRqSasw/6m4vEX5KO6NiAIQv889HfkFx84Vcn7YjgOLWeiRHVWDn6FoCYRhDDsUx
	 kkCcC9exx8khV6T/oDn/D7yoPeI4Qx3VSEEPs7ct2ZzvVqyqf+qrHaYQC15AA8/wJm
	 9svYyOz+7VELxaBt7z5RORFjN50OdjxU8BOKLGP23WyqDDGtFvK6A7XDdtMpGM/Z1y
	 SibUIHaX3MPNMoY/XHr1oU1kUkAeW7NbY74ZNc1s+f+LAYzxQwlXBAKxWTOqv3s58R
	 rG0r1NBeRzGJmY4wyawmCgomUK8KuH95QxHLY/s/oYj7K0X3r5gO+SsudXcD1JdWEI
	 B7z1iYc7rVrow==
Date: Wed, 5 Mar 2025 23:08:38 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: make destruction work queue
 pernet
Message-ID: <Z8jLZv6asBnqrniC@calendula>
References: <20250304115706.2566960-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250304115706.2566960-1-fw@strlen.de>

Hi Florian,

On Tue, Mar 04, 2025 at 12:55:53PM +0100, Florian Westphal wrote:
> The call to flush_work before tearing down a table from the netlink
> notifier was supposed to make sure that all earlier updates (e.g. rule
> add) that might reference that table have been processed.
> 
> Unfortunately, flush_work() waits for the last queued instance.
> This could be an instance that is different from the one that we must
> wait for.
> 
> This is because transactions are protected with a pernet mutex, but the
> work item is global, so holding the transaction mutex doesn't prevent
> another netns from queueing more work.
> 
> Make the work item pernet so that flush_work() will wait for all
> transactions queued from this netns.
> 
> A welcome side effect is that we no longer need to wait for transaction
> objects from other network namespaces.
> 
> The gc work queue is still global.  This seems to be ok because nft_set
> structures are reference counted and each container structure owns a
> reference on the net namespace.
> 
> The destroy_list is still protected by a global spinlock rather than
> pernet one but the hold time is very short anyway.

A few questions below.

> Fixes: 9f6958ba2e90 ("netfilter: nf_tables: unconditionally flush pending work before notifier")
> Reported-by: syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5d8c5789c8cb076b2c25
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_tables.h |  4 +++-
>  net/netfilter/nf_tables_api.c     | 25 +++++++++++++++----------
>  net/netfilter/nft_compat.c        |  8 ++++----
>  3 files changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 60d5dcdb289c..803d5f1601f9 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -1891,7 +1891,7 @@ void nft_chain_filter_fini(void);
>  void __init nft_chain_route_init(void);
>  void nft_chain_route_fini(void);
>  
> -void nf_tables_trans_destroy_flush_work(void);
> +void nf_tables_trans_destroy_flush_work(struct net *net);
>  
>  int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
>  __be64 nf_jiffies64_to_msecs(u64 input);
> @@ -1905,6 +1905,7 @@ static inline int nft_request_module(struct net *net, const char *fmt, ...) { re
>  struct nftables_pernet {
>  	struct list_head	tables;
>  	struct list_head	commit_list;
> +	struct list_head	destroy_list;
>  	struct list_head	commit_set_list;
>  	struct list_head	binding_list;
>  	struct list_head	module_list;
> @@ -1915,6 +1916,7 @@ struct nftables_pernet {
>  	unsigned int		base_seq;
>  	unsigned int		gc_seq;
>  	u8			validate_state;
> +	struct work_struct	destroy_work;
>  };
>  
>  extern unsigned int nf_tables_net_id;
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a34de9c17cf1..adf8b2b37fc3 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -34,7 +34,6 @@ unsigned int nf_tables_net_id __read_mostly;
>  static LIST_HEAD(nf_tables_expressions);
>  static LIST_HEAD(nf_tables_objects);
>  static LIST_HEAD(nf_tables_flowtables);
> -static LIST_HEAD(nf_tables_destroy_list);
>  static LIST_HEAD(nf_tables_gc_list);
>  static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
>  static DEFINE_SPINLOCK(nf_tables_gc_list_lock);
> @@ -125,7 +124,6 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
>  	table->validate_state = new_validate_state;
>  }
>  static void nf_tables_trans_destroy_work(struct work_struct *w);
> -static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
>  
>  static void nft_trans_gc_work(struct work_struct *work);
>  static DECLARE_WORK(trans_gc_work, nft_trans_gc_work);
> @@ -10006,11 +10004,12 @@ static void nft_commit_release(struct nft_trans *trans)
>  
>  static void nf_tables_trans_destroy_work(struct work_struct *w)
>  {
> +	struct nftables_pernet *nft_net = container_of(w, struct nftables_pernet, destroy_work);
>  	struct nft_trans *trans, *next;
>  	LIST_HEAD(head);
>  
>  	spin_lock(&nf_tables_destroy_list_lock);
> -	list_splice_init(&nf_tables_destroy_list, &head);
> +	list_splice_init(&nft_net->destroy_list, &head);
>  	spin_unlock(&nf_tables_destroy_list_lock);
>  
>  	if (list_empty(&head))
> @@ -10024,9 +10023,11 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
>  	}
>  }
>  
> -void nf_tables_trans_destroy_flush_work(void)
> +void nf_tables_trans_destroy_flush_work(struct net *net)
>  {
> -	flush_work(&trans_destroy_work);
> +	struct nftables_pernet *nft_net = nft_pernet(net);
> +
> +	flush_work(&nft_net->destroy_work);
>  }
>  EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
>  
> @@ -10484,11 +10485,11 @@ static void nf_tables_commit_release(struct net *net)
>  
>  	trans->put_net = true;
>  	spin_lock(&nf_tables_destroy_list_lock);
> -	list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
> +	list_splice_tail_init(&nft_net->commit_list, &nft_net->destroy_list);
>  	spin_unlock(&nf_tables_destroy_list_lock);
>  
>  	nf_tables_module_autoload_cleanup(net);
> -	schedule_work(&trans_destroy_work);
> +	schedule_work(&nft_net->destroy_work);
>  
>  	mutex_unlock(&nft_net->commit_mutex);
>  }
> @@ -11853,7 +11854,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
>  
>  	gc_seq = nft_gc_seq_begin(nft_net);
>  
> -	nf_tables_trans_destroy_flush_work();
> +	nf_tables_trans_destroy_flush_work(net);
>  again:
>  	list_for_each_entry(table, &nft_net->tables, list) {
>  		if (nft_table_has_owner(table) &&
> @@ -11895,6 +11896,7 @@ static int __net_init nf_tables_init_net(struct net *net)
>  
>  	INIT_LIST_HEAD(&nft_net->tables);
>  	INIT_LIST_HEAD(&nft_net->commit_list);
> +	INIT_LIST_HEAD(&nft_net->destroy_list);
>  	INIT_LIST_HEAD(&nft_net->commit_set_list);
>  	INIT_LIST_HEAD(&nft_net->binding_list);
>  	INIT_LIST_HEAD(&nft_net->module_list);
> @@ -11903,6 +11905,7 @@ static int __net_init nf_tables_init_net(struct net *net)
>  	nft_net->base_seq = 1;
>  	nft_net->gc_seq = 0;
>  	nft_net->validate_state = NFT_VALIDATE_SKIP;
> +	INIT_WORK(&nft_net->destroy_work, nf_tables_trans_destroy_work);
>  
>  	return 0;
>  }
> @@ -11936,9 +11939,13 @@ static void __net_exit nf_tables_exit_net(struct net *net)
>  	nft_gc_seq_end(nft_net, gc_seq);
>  
>  	mutex_unlock(&nft_net->commit_mutex);
> +
> +	cancel_work_sync(&nft_net->destroy_work);

__nft_release_tables() is called in this nf_tables_exit_net()
function, cancel_work_sync() needs to be called before it?

> +
>  	WARN_ON_ONCE(!list_empty(&nft_net->tables));
>  	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
>  	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
> +	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
>  }
>  
>  static void nf_tables_exit_batch(struct list_head *net_exit_list)
> @@ -12029,10 +12036,8 @@ static void __exit nf_tables_module_exit(void)
>  	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
>  	nft_chain_filter_fini();
>  	nft_chain_route_fini();
> -	nf_tables_trans_destroy_flush_work();

My understanding is that this is not required anymore because of the
new cancel_work_sync() in the exit_net() path?

>  	unregister_pernet_subsys(&nf_tables_net_ops);
>  	cancel_work_sync(&trans_gc_work);
> -	cancel_work_sync(&trans_destroy_work);
>  	rcu_barrier();
>  	rhltable_destroy(&nft_objname_ht);
>  	nf_tables_core_module_exit();
> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 7ca4f0d21fe2..72711d62fddf 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -228,7 +228,7 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
>  	return 0;
>  }
>  
> -static void nft_compat_wait_for_destructors(void)
> +static void nft_compat_wait_for_destructors(struct net *net)
>  {
>  	/* xtables matches or targets can have side effects, e.g.
>  	 * creation/destruction of /proc files.
> @@ -236,7 +236,7 @@ static void nft_compat_wait_for_destructors(void)
>  	 * work queue.  If we have pending invocations we thus
>  	 * need to wait for those to finish.
>  	 */
> -	nf_tables_trans_destroy_flush_work();
> +	nf_tables_trans_destroy_flush_work(net);
>  }
>  
>  static int
> @@ -262,7 +262,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  
>  	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
>  
> -	nft_compat_wait_for_destructors();
> +	nft_compat_wait_for_destructors(ctx->net);
>  
>  	ret = xt_check_target(&par, size, proto, inv);
>  	if (ret < 0) {
> @@ -515,7 +515,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
>  
>  	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
>  
> -	nft_compat_wait_for_destructors();
> +	nft_compat_wait_for_destructors(ctx->net);
>  
>  	return xt_check_match(&par, size, proto, inv);
>  }
> -- 
> 2.48.1
> 
> 
