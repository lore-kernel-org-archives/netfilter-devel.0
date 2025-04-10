Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23DA1519A1;
	Thu, 10 Apr 2025 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744294630; cv=none; b=K03kS0yBja1mi3DlYCl5iM3XBCM23nsz9Czj0hVOcoi3QBaLUMykkD42h13p/MZRbpRuah7uCLB3aGUsvBm2HXCxkJP3VcEE5qEzj/a2631tIUWouAZS4xQBrFRUjtFCS3FSpAjN2jwnpBtlLeVznqzalTgx7OVLfQHf8P2KmZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744294630; c=relaxed/simple;
	bh=J3pfcUF75sH/E2NsoPd/DbihyZAVE6hTt4Gbs5k9DEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe1c2Nie+HY6oSSTsqj/FvAgSFd9qQ42FQm+vqO/irVLOoUtglSZ3JBfYN85WytpHrJf3pD+WlPn6jOkX7HkIg9LhktUXoJlDtw2e/AXokfUg9MKjhxhZLqx7eBRTMptgiIKQ2dWjuN/s2Zb3ydJe0KcN/03OGR5xRyO5bA5R4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2si7-0005OJ-FL; Thu, 10 Apr 2025 16:16:55 +0200
Date: Thu, 10 Apr 2025 16:16:55 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: lvxiafei <xiafei_xupt@163.com>, coreteam@netfilter.org,
	davem@davemloft.net, edumazet@google.com, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org
Subject: Re: [PATCH V3] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250410141655.GA20644@breakpoint.cc>
References: <20250409094206.GB17911@breakpoint.cc>
 <20250410130531.17824-1-xiafei_xupt@163.com>
 <20250410131717.GA14051@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410131717.GA14051@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> lvxiafei <xiafei_xupt@163.com> wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > I suggest to remove nf_conntrack_max as a global variable,
> > > make net.nf_conntrack_max use init_net.nf_conntrack_max too internally,
> > > so in the init_net both sysctls remain the same.
> > 
> > The nf_conntrack_max global variable is a system calculated
> > value and should not be removed.
> > nf_conntrack_max = max_factor * nf_conntrack_htable_size;
> 
> Thats the default calculation for the initial sysctl value:
> 
> net/netfilter/nf_conntrack_standalone.c:                .data           = &nf_conntrack_max,
> net/netfilter/nf_conntrack_standalone.c:                .data           = &nf_conntrack_max,
> 
> You can make an initial patch that replaces all occurences of
> nf_conntrack_max with cnet->sysctl_conntrack_max

Something like this:

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -320,7 +320,6 @@ int nf_conntrack_hash_resize(unsigned int hashsize);
 extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
 extern seqcount_spinlock_t nf_conntrack_generation;
-extern unsigned int nf_conntrack_max;
 
 /* must be called with rcu read lock held */
 static inline void
@@ -360,6 +359,11 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
 	return net_generic(net, nf_conntrack_net_id);
 }
 
+static inline unsigned int nf_conntrack_max(const struct net *net)
+{
+	return net->ct.sysctl_conntrack_max;
+}
+
 int nf_ct_skb_network_trim(struct sk_buff *skb, int family);
 int nf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 			   u16 zone, u8 family, u8 *proto, u16 *mru);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -102,6 +102,7 @@ struct netns_ct {
 	u8			sysctl_acct;
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
+	unsigned int		sysctl_conntrack_max;
 
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7f8b245e287a..8ae9c22cfcb3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -202,8 +202,6 @@ static void nf_conntrack_all_unlock(void)
 unsigned int nf_conntrack_htable_size __read_mostly;
 EXPORT_SYMBOL_GPL(nf_conntrack_htable_size);
 
-unsigned int nf_conntrack_max __read_mostly;
-EXPORT_SYMBOL_GPL(nf_conntrack_max);
 seqcount_spinlock_t nf_conntrack_generation __read_mostly;
 static siphash_aligned_key_t nf_conntrack_hash_rnd;
 
@@ -1509,8 +1507,7 @@ static void gc_worker(struct work_struct *work)
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
-	if (gc_work->early_drop)
-		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
+		nf_conntrack_max95 = nf_conntrack_max(&init_net) / 100u * 95u;
 
 	if (i == 0) {
 		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
@@ -1648,13 +1645,14 @@ __nf_conntrack_alloc(struct net *net,
 		     gfp_t gfp, u32 hash)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-	unsigned int ct_count;
+	unsigned int ct_max, ct_count;
 	struct nf_conn *ct;
 
 	/* We don't want any race condition at early drop stage */
 	ct_count = atomic_inc_return(&cnet->count);
+	ct_max = nf_conntrack_max(&init_net);
 
-	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
+	if (ct_max && unlikely(ct_count > ct_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
@@ -2650,7 +2648,7 @@ int nf_conntrack_init_start(void)
 	if (!nf_conntrack_hash)
 		return -ENOMEM;
 
-	nf_conntrack_max = max_factor * nf_conntrack_htable_size;
+	init_net.ct.sysctl_conntrack_max = max_factor * nf_conntrack_htable_size;
 
 	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
 						sizeof(struct nf_conn),
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index db23876a6016..f1938204b827 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2608,7 +2608,7 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, CTA_STATS_GLOBAL_ENTRIES, htonl(nr_conntracks)))
 		goto nla_put_failure;
 
-	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max)))
+	if (nla_put_be32(skb, CTA_STATS_GLOBAL_MAX_ENTRIES, htonl(nf_conntrack_max(net))))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 502cf10aab41..8a185dfd3261 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -615,7 +615,7 @@ enum nf_ct_sysctl_index {
 static struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
-		.data		= &nf_conntrack_max,
+		.data		= &init_net.ct.sysctl_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
@@ -944,7 +944,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 static struct ctl_table nf_ct_netfilter_table[] = {
 	{
 		.procname	= "nf_conntrack_max",
-		.data		= &nf_conntrack_max,
+		.data		= &init_net.ct.sysctl_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
