Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271832;
	b=njkAkC+GyPch71XllaWVLHLpvKt2izKJLpSj3isks0Ofr1QyW//LOhdY/T8tmEkLHfUC
	 MXiQoRsRiLiy+4RKTrzV8F+oSCG9iYYXx5u1nSS79w8S2E+HS//yGU8LpzhIbTEErQVta
	 QIIYff3vXricUhwUO6Q6Zv0pLAqA1G9vGxEpukZ1d04qvWfQL672kAnChXAk9w0/WP/3D
	 mMhqcRgrXt71l2MgNN59OaaiMAgKzR8bPGwoAkSUZe78D0OdAdNpmKZDm8cT57Zt+YVdJ
	 15PSGo8PsYffZVJH80lZs4Zjt0TpITM/U/EO0DIkxqsaGUFdlzqlB3KVG6AW0GhuQCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271832;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=F9qSyn3S9D7/qS4kiEuuUWRJEUxjpjZGEXQBvqhMx3I=;
	b=QZ3A3y+1KrjXc1lmcUDNgzCE6C/xvhHyYDr45m+0tJhCJPRy/50J8SRhBWdA+S29so9V
	 IBPmkH56iV2Z06zB+aDGJaJZIKEEdBSad0okqnBp66WppCKYkhAkgg90nbG4mIQhj9TD0
	 a48QUrhRGhT05W/uP4Qq1qMFARuzlig3EmAhE+DzKusQ2AFJGs5DWgyZlIULW8Ci2l0MY
	 ChmSlCRyEXWH0rt2gDyYs50jSgYMNbTcrZXfhK5oLAC6jL14OqNOUyn5iIKecYisrj89X
	 ziQWtxJ6/6ORFt0BcOW485mFM8GCkHhrUY4fZqjBofeYIVn9wugoLpHeUxyJb4HpJFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=iY9Yaepe;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6C1BF606A331;
	Tue, 10 Nov 2026 00:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C1BF606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=iY9Yaepe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794271828;
	bh=F9qSyn3S9D7/qS4kiEuuUWRJEUxjpjZGEXQBvqhMx3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iY9YaepeD/mIWWNXtz+Ou28+E44059RzxLWtUr912mXqTwRRUjf/YIerbc2jg+Ytz
	 9j6lKyDiEFU2uMkHqGtMWat/vyTsxa3j6uY78M/h8lplury4wMf+WON40wfQnXiPKx
	 ot2CVcoy/wcCz270JqVxE48eAznmmxWcT5ZjFrGV+F0QPz6CnyvnkQcEk0toFdZLOC
	 H/zOCL85fbj6Wfh0kbr6vw2k6MW2QSjJc71nABTgERbmxjqvfIkRbCMF3Rb/3WI4u1
	 wETAeFik0p56wZGmHLteGEc/bSEl6OhzjE3zADylmVqnScMnMPesiHGBes4RJFOn+1
	 xdEZOOjptpG7w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C2E666007C;
	Tue, 10 Nov 2026 01:50:28 +0100 (CET)
Date: Tue, 10 Nov 2026 01:50:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Qihang <q.h.hack.winter@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, vladbu@nvidia.com, ozsh@nvidia.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table: defer pernet stats release
 to last flowtable teardown
Message-ID: <avJqUf4_aBq_zkRo@chamomile>
References: <20261105065509.94627-1-q.h.hack.winter@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261105065509.94627-1-q.h.hack.winter@gmail.com>

On Thu, Nov 05, 2026 at 02:55:09PM +0800, Qihang wrote:
> The pernet flowtable statistics (net->ft.stat) are released when the
> netns exits, but the flowtables attached to a dying netns are torn down
> asynchronously afterwards: the tc conntrack action frees its flowtable
> from an RCU-delayed workqueue item (tcf_ct_flow_table_cleanup_work()),
> and nf_tables releases flowtables from the transaction release work.
> 
> nf_flow_table_free() ends with a garbage-collection pass that queues
> offload works; flow_offload_queue_work() increments the pernet counters
> when scheduling them and the handlers decrement the counters again once
> they complete.  The flushes in nf_flow_table_free() only drain those
> workqueues when hardware offload is in use, so after free_percpu() the
> stray workers still this_cpu_inc()/this_cpu_dec() into freed percpu
> memory.
> 
> Account flowtables at init time and defer the release of the statistics
> to the last nf_flow_table_free() of a dismantled netns, after draining
> the offload workqueues.  A netns without flowtables keeps the
> synchronous release.

Looks like a duplicate of:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261029230657.302417-1-pablo@netfilter.org/

> Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload workqueue tasks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
> ---
>  include/net/netfilter/nf_flow_table.h |  1 +
>  include/net/netns/flow_table.h        | 11 +++++++
>  net/netfilter/nf_flow_table_core.c    | 44 ++++++++++++++++++++++++++-
>  net/netfilter/nf_flow_table_offload.c |  7 +++++
>  4 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 5b22d31cb1407..91ffa3072a0cc 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -376,6 +376,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
>  
>  void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
>  void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
> +void nf_flow_table_offload_drain(void);
>  
>  int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
>  				struct net_device *dev,
> diff --git a/include/net/netns/flow_table.h b/include/net/netns/flow_table.h
> index 1c5fc657e2675..6d2dc0d1f06c7 100644
> --- a/include/net/netns/flow_table.h
> +++ b/include/net/netns/flow_table.h
> @@ -2,6 +2,9 @@
>  #ifndef __NETNS_FLOW_TABLE_H
>  #define __NETNS_FLOW_TABLE_H
>  
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +
>  struct nf_flow_table_stat {
>  	unsigned int count_wq_add;
>  	unsigned int count_wq_del;
> @@ -9,6 +12,14 @@ struct nf_flow_table_stat {
>  };
>  
>  struct netns_ft {
> +	/* Protects nr_ft and exiting. */
> +	spinlock_t		lock;
> +	/* Number of flowtables attached to this netns. */
> +	int			nr_ft;
> +	/* Set at netns exit; the statistics are then released by the
> +	 * last flowtable teardown.
> +	 */
> +	bool			exiting;
>  	struct nf_flow_table_stat __percpu *stat;
>  };
>  #endif
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 0d72dc8ae47a1..de0a9f0e4f7b9 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -715,6 +715,7 @@ EXPORT_SYMBOL_GPL(nf_flow_dnat_port);
>  
>  int nf_flow_table_init(struct nf_flowtable *flowtable)
>  {
> +	struct net *net;
>  	int err;
>  
>  	INIT_DELAYED_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
> @@ -733,6 +734,13 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
>  	list_add(&flowtable->list, &flowtables);
>  	mutex_unlock(&flowtable_lock);
>  
> +	net = read_pnet(&flowtable->net);
> +	if (net) {
> +		spin_lock(&net->ft.lock);
> +		net->ft.nr_ft++;
> +		spin_unlock(&net->ft.lock);
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_init);
> @@ -771,6 +779,8 @@ EXPORT_SYMBOL_GPL(nf_flow_table_cleanup);
>  
>  void nf_flow_table_free(struct nf_flowtable *flow_table)
>  {
> +	struct net *net;
> +
>  	mutex_lock(&flowtable_lock);
>  	list_del(&flow_table->list);
>  	mutex_unlock(&flowtable_lock);
> @@ -781,19 +791,51 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
>  	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>  	nf_flow_table_gc_run(flow_table);
>  	nf_flow_table_offload_flush_cleanup(flow_table);
> +
> +	/* The gc pass above can still queue offload works whose handlers
> +	 * decrement the pernet statistics.  Drain them all.
> +	 */
> +	nf_flow_table_offload_drain();
>  	rhashtable_destroy(&flow_table->rhashtable);
> +
> +	net = read_pnet(&flow_table->net);
> +	if (net) {
> +		bool release;
> +
> +		spin_lock(&net->ft.lock);
> +		release = net->ft.exiting && !--net->ft.nr_ft;
> +		spin_unlock(&net->ft.lock);
> +
> +		/* Released by the last flowtable teardown, see
> +		 * nf_flow_table_fini_net().
> +		 */
> +		if (release)
> +			free_percpu(net->ft.stat);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(nf_flow_table_free);
>  
>  static int nf_flow_table_init_net(struct net *net)
>  {
> +	spin_lock_init(&net->ft.lock);
>  	net->ft.stat = alloc_percpu(struct nf_flow_table_stat);
>  	return net->ft.stat ? 0 : -ENOMEM;
>  }
>  
>  static void nf_flow_table_fini_net(struct net *net)
>  {
> -	free_percpu(net->ft.stat);
> +	bool release;
> +
> +	spin_lock(&net->ft.lock);
> +	net->ft.exiting = true;
> +	release = !net->ft.nr_ft;
> +	spin_unlock(&net->ft.lock);
> +
> +	/* Pending flowtables still update the statistics from workqueue
> +	 * context; the last one releases them, see nf_flow_table_free().
> +	 */
> +	if (release)
> +		free_percpu(net->ft.stat);
>  }
>  
>  static int nf_flow_table_pernet_init(struct net *net)
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4365859220e6a..6ac28802ef632 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1180,6 +1180,13 @@ void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
>  	}
>  }
>  
> +void nf_flow_table_offload_drain(void)
> +{
> +	flush_workqueue(nf_flow_offload_add_wq);
> +	flush_workqueue(nf_flow_offload_del_wq);
> +	flush_workqueue(nf_flow_offload_stats_wq);
> +}
> +
>  static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
>  				     struct flow_block_offload *bo,
>  				     enum flow_block_command cmd)
> -- 
> 2.54.0 (Apple Git-157)
> 
