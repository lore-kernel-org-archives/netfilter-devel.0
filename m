Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC01E20E6E3;
	Thu, 22 May 2025 19:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747941902; cv=none; b=pgMD0JBrzeRP5dTXhbnXyZ8ZZEyADumljgyJJpUFBxeomuQnX5XV831gWZbhhR/hDBqWIL7Q7fruy6jw8EII+j3fObroXBawTQXXI58MqqQJjkZVNYXcTVx4HuoybOiQkvUIM+18BHHTMWFzlPuHwK6MndTfzHj973pgESifZng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747941902; c=relaxed/simple;
	bh=KG1Jja0n0UrMwxefm4bdFF3JgNAo8tKJq9EJ7r6+Ud4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxqYtd19OTGwc6q+fZ72ygk9cWvE1Q1TzNXNhQbcl4AoDPpGSOnySnMzyECi1rz7RydVtRUGcf+DXZwIGKOxM27o4+pbB9hforAgmi5WyBv+cxchA3zzBd/UTvebkGm7Elhgxkrtoytm7fIYFj9oPfJxnQIyIW0NODiSu04la1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H/XNdmFs; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aI9QrZzi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H/XNdmFs";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aI9QrZzi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1B49460702; Thu, 22 May 2025 21:24:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747941897;
	bh=01VDqd0ZfEmw/7MqDTZbhRjwp4vzisbjEHiab4aspTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H/XNdmFskWdbg4SxQy/CDwuJiL/bY85MMKUXyrVU1JSa1WGYRL+AzwpEM59qCuj6H
	 9gz1KxY53YM34VU7a0rPcRVYbGD8O5H3sRFKG4MC+z9H4YxaWUCXruEY6tIXKZZZUz
	 OoGibhu4S7iPt9rhQYKSW259eoH5wKX/VRmsszdRPGHndep7WctZUuK/C+94qGCbp6
	 ABzzKPzZKMfmz/P6TLpq/qbDCaZ6CEqG3JhS4hmS4r2VzHl9/Ydw5IeaqUdY2DNxxe
	 cDVYUN3xltk/jRgTn72wBAyIIM4XzaDIhlvA+NHYeafm8RYkgYehZ2xAGy+GDutLdG
	 5v31m5FxV6tKw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 12B7D606F6;
	Thu, 22 May 2025 21:24:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747941891;
	bh=01VDqd0ZfEmw/7MqDTZbhRjwp4vzisbjEHiab4aspTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aI9QrZziZzKaA30a3EQPXTUb1kznOrr7LybujBzXjIJaxToT8I1QlfglZA9w9I2LS
	 s83LmjSktsxVBPf8Yh3QPY7OdxSXg/Ixu6P6EYPLVcsaDvr9gA3i+d/Gqo9BR0NJcE
	 NZirVKSZhxZxdRZ/+WDxDCtwC1oMPRAnTsyLGIlrPBUVD+zJwRaz0iM1t9tp7KoUSV
	 ledHeVCHE0L9jfXX9a16bhLCWARgidVqBQnAf3c5UrUz4GULDdEtZQLPyqu0htKjFt
	 0YTpfVsD49UW1aScTk82fA9LRV8UNN5Lbzv39QatMUkbZ/FI/i3v3zovHyPDeCDJY/
	 DuwT5Qnuy6CpQ==
Date: Thu, 22 May 2025 21:24:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: lvxiafei <xiafei_xupt@163.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, lvxiafei@sensetime.com,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <aC96AHaQX9WVtln5@calendula>
References: <20250407095052.49526-1-xiafei_xupt@163.com>
 <20250415090834.24882-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250415090834.24882-1-xiafei_xupt@163.com>

On Tue, Apr 15, 2025 at 05:08:34PM +0800, lvxiafei wrote:
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index 238b66d0e059..6e7f17f5959a 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -93,12 +93,29 @@ nf_conntrack_log_invalid - INTEGER
>  	Log invalid packets of a type specified by value.
>  
>  nf_conntrack_max - INTEGER
> -        Maximum number of allowed connection tracking entries. This value is set
> -        to nf_conntrack_buckets by default.
> -        Note that connection tracking entries are added to the table twice -- once
> -        for the original direction and once for the reply direction (i.e., with
> -        the reversed address). This means that with default settings a maxed-out
> -        table will have a average hash chain length of 2, not 1.
> +    - 0 - disabled (unlimited)

unlimited is too much, and the number of buckets is also global, how
does this work?

Is your goal to allow a netns to have larger table than netns? There
should be a cap for this.

> +    - not 0 - enabled
> +
> +    Maximum number of allowed connection tracking entries per netns. This value
> +    is set to nf_conntrack_buckets by default.
> +
> +    Note that connection tracking entries are added to the table twice -- once
> +    for the original direction and once for the reply direction (i.e., with
> +    the reversed address). This means that with default settings a maxed-out
> +    table will have a average hash chain length of 2, not 1.
> +
> +    The limit of other netns cannot be greater than init_net netns.
> +    +----------------+-------------+----------------+
> +    | init_net netns | other netns | limit behavior |
> +    +----------------+-------------+----------------+
> +    | 0              | 0           | unlimited      |
> +    +----------------+-------------+----------------+
> +    | 0              | not 0       | other          |
> +    +----------------+-------------+----------------+
> +    | not 0          | 0           | init_net       |
> +    +----------------+-------------+----------------+
> +    | not 0          | not 0       | min            |
> +    +----------------+-------------+----------------+
>  
>  nf_conntrack_tcp_be_liberal - BOOLEAN
>  	- 0 - disabled (default)
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 3f02a45773e8..594439b2f5a1 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -320,7 +320,6 @@ int nf_conntrack_hash_resize(unsigned int hashsize);
>  extern struct hlist_nulls_head *nf_conntrack_hash;
>  extern unsigned int nf_conntrack_htable_size;
>  extern seqcount_spinlock_t nf_conntrack_generation;
> -extern unsigned int nf_conntrack_max;
>  
>  /* must be called with rcu read lock held */
>  static inline void
> @@ -360,6 +359,17 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
>  	return net_generic(net, nf_conntrack_net_id);
>  }
>  
> +static inline unsigned int nf_conntrack_max(const struct net *net)
> +{
> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +	return likely(init_net.ct.sysctl_max && net->ct.sysctl_max) ?
> +	    min(init_net.ct.sysctl_max, net->ct.sysctl_max) :
> +	    max(init_net.ct.sysctl_max, net->ct.sysctl_max);
> +#else
> +	return 0;
> +#endif
> +}
> +
>  int nf_ct_skb_network_trim(struct sk_buff *skb, int family);
>  int nf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
>  			   u16 zone, u8 family, u8 *proto, u16 *mru);
> diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
> index bae914815aa3..d3fcd0b92b2d 100644
> --- a/include/net/netns/conntrack.h
> +++ b/include/net/netns/conntrack.h
> @@ -102,6 +102,7 @@ struct netns_ct {
>  	u8			sysctl_acct;
>  	u8			sysctl_tstamp;
>  	u8			sysctl_checksum;
> +	unsigned int		sysctl_max;
>  
>  	struct ip_conntrack_stat __percpu *stat;
>  	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 7f8b245e287a..a738564923ec 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -202,8 +202,6 @@ static void nf_conntrack_all_unlock(void)
>  unsigned int nf_conntrack_htable_size __read_mostly;
>  EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
>  
> -unsigned int nf_conntrack_max __read_mostly;
> -EXPORT_SYMBOL_GPL(nf_conntrack_max);
>  seqcount_spinlock_t nf_conntrack_generation __read_mostly;
>  static siphash_aligned_key_t nf_conntrack_hash_rnd;
>  
> @@ -1498,7 +1496,7 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
>  
>  static void gc_worker(struct work_struct *work)
>  {
> -	unsigned int i, hashsz, nf_conntrack_max95 = 0;
> +	unsigned int i, hashsz;
>  	u32 end_time, start_time = nfct_time_stamp;
>  	struct conntrack_gc_work *gc_work;
>  	unsigned int expired_count = 0;
> @@ -1509,8 +1507,6 @@ static void gc_worker(struct work_struct *work)
>  	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
>  
>  	i = gc_work->next_bucket;
> -	if (gc_work->early_drop)
> -		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
>  
>  	if (i == 0) {
>  		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
> @@ -1538,6 +1534,7 @@ static void gc_worker(struct work_struct *work)
>  		}
>  
>  		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
> +			unsigned int nf_conntrack_max95 = 0;
>  			struct nf_conntrack_net *cnet;
>  			struct net *net;
>  			long expires;
> @@ -1567,11 +1564,14 @@ static void gc_worker(struct work_struct *work)
>  			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
>  			expires = (expires - (long)next_run) / ++count;
>  			next_run += expires;
> +			net = nf_ct_net(tmp);
> +
> +			if (gc_work->early_drop)
> +				nf_conntrack_max95 = nf_conntrack_max(net) / 100u * 95u;
>  
>  			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
>  				continue;
>  
> -			net = nf_ct_net(tmp);
>  			cnet = nf_ct_pernet(net);
>  			if (atomic_read(&cnet->count) < nf_conntrack_max95)
>  				continue;
> @@ -1648,13 +1648,14 @@ __nf_conntrack_alloc(struct net *net,
>  		     gfp_t gfp, u32 hash)
>  {
>  	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
> -	unsigned int ct_count;
> +	unsigned int ct_max, ct_count;
>  	struct nf_conn *ct;
>  
>  	/* We don't want any race condition at early drop stage */
>  	ct_count = atomic_inc_return(&cnet->count);
> +	ct_max = nf_conntrack_max(net);
>  
> -	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
> +	if (ct_max && unlikely(ct_count > ct_max)) {
>  		if (!early_drop(net, hash)) {
>  			if (!conntrack_gc_work.early_drop)
>  				conntrack_gc_work.early_drop = true;
> @@ -2650,7 +2651,7 @@ int nf_conntrack_init_start(void)
>  	if (!nf_conntrack_hash)
>  		return -ENOMEM;
>  
> -	nf_conntrack_max = max_factor * nf_conntrack_htable_size;
> +	init_net.ct.sysctl_max = max_factor * nf_conntrack_htable_size;
>  
>  	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
>  						sizeof(struct nf_conn),
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 2cc0fde23344..73e6bb1e939b 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2608,7 +2608,7 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  	if (nla_put_be32(skb, CTA_STATS_GLOBAL_ENTRIES, htonl(nr_conntracks)))
>  		goto nla_put_failure;
>  
> -	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max)))
> +	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max(net))))
>  		goto nla_put_failure;
>  
>  	nlmsg_end(skb, nlh);
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 2f666751c7e7..5db6df0e4eb3 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -615,7 +615,7 @@ enum nf_ct_sysctl_index {
>  static struct ctl_table nf_ct_sysctl_table[] = {
>  	[NF_SYSCTL_CT_MAX] = {
>  		.procname	= "nf_conntrack_max",
> -		.data		= &nf_conntrack_max,
> +		.data		= &init_net.ct.sysctl_max,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
> @@ -948,7 +948,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  static struct ctl_table nf_ct_netfilter_table[] = {
>  	{
>  		.procname	= "nf_conntrack_max",
> -		.data		= &nf_conntrack_max,
> +		.data		= &init_net.ct.sysctl_max,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
> @@ -1063,6 +1063,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>  
>  	table[NF_SYSCTL_CT_COUNT].data = &cnet->count;
>  	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
> +	table[NF_SYSCTL_CT_MAX].data = &net->ct.sysctl_max;
>  	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
>  	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
>  #ifdef CONFIG_NF_CONNTRACK_EVENTS
> @@ -1087,7 +1088,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
>  
>  	/* Don't allow non-init_net ns to alter global sysctls */
>  	if (!net_eq(&init_net, net)) {
> -		table[NF_SYSCTL_CT_MAX].mode = 0444;
>  		table[NF_SYSCTL_CT_EXPECT_MAX].mode = 0444;
>  		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
>  	}
> @@ -1139,6 +1139,7 @@ static int nf_conntrack_pernet_init(struct net *net)
>  	int ret;
>  
>  	net->ct.sysctl_checksum = 1;
> +	net->ct.sysctl_max = init_net.ct.sysctl_max;
>  
>  	ret = nf_conntrack_standalone_init_sysctl(net);
>  	if (ret < 0)
> -- 
> 2.40.1
> 
