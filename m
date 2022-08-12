Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA716C00140
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Aug 2022 10:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiHLKfE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Aug 2022 06:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbiHLKfD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Aug 2022 06:35:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77714AB4F2
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2022 03:35:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 15EB01FA92;
        Fri, 12 Aug 2022 10:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660300500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=+c8c1OO1q9iTpZqVv6IaaLMFSt1jS7ePyQjpPqtF0aY=;
        b=bHaIsF5QyREheRbndibzzbBxPxgV/fQBe/tep9KGSxdAjw0qIpRZHe27Nl/I2XMRlMeVBa
        mxyvRBnUstrueaNrrqFSXjtlfpVtz/YaLvW246wYxWDCE7tPAAMwnqUbMbmK94pXZYb/Fb
        PLf6wiiKqdxlq83fuv/J2GbbItjlU3w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660300500;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=+c8c1OO1q9iTpZqVv6IaaLMFSt1jS7ePyQjpPqtF0aY=;
        b=4Ou1E6OICzNuk67QRFOHw7U59IdlnzSUuHZsK6h59rwcv0w5RHbfxAmPXCZgJBUxcZlrbC
        oqpl4RBHvSTxYhAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0159813305;
        Fri, 12 Aug 2022 10:35:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xh9PANQs9mKKXgAAMHmgww
        (envelope-from <jwiesner@suse.de>); Fri, 12 Aug 2022 10:35:00 +0000
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 95FAEB26E; Fri, 12 Aug 2022 12:34:59 +0200 (CEST)
Date:   Fri, 12 Aug 2022 12:34:59 +0200
From:   Jiri Wiesner <jwiesner@suse.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [RFC PATCH nf-next] netfilter: ipvs: Divide estimators into groups
Message-ID: <20220812103459.GA7521@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The calculation of rate estimates for IPVS services and destinations will
cause an increase in scheduling latency to hundreds of milliseconds when
the number of estimators reaches tens of thousands or more. This issue has
been reported upstream [1]. Design changes to the algorithm to compute the
estimates were proposed in the same email thread.

By implementing some of the proposed design changes, this patch seeks to
address the latency issue by dividing the estimators into groups for which
estimates are calculated in a 2-second interval (same as before). Each of
the groups is processed once in each 2-second interval. Instead of
allocating an array of lists, groups are identified by their group_id,
which has the advantage that estimators can stay in the same list to which
they have been added by ip_vs_start_estimator(). The implementation of
estimator grouping is able to scale up with an increasing number of
estimators as well as scale down when estimators are being removed.
The changes to group size can be monitored with dynamic debugging:
echo 'file net/netfilter/ipvs/ip_vs_est.c +pfl' >> /sys/kernel/debug/dynamic_debug/control

Rebalacing of estimator groups is implemented and can be triggered only
after all the calculations for a 2-second interval have finished. After a
limit is exceeded, adding or removing estimators will triger rebalacing,
which will cause estimates to be inaccurate in the next 2-second interval.
For example, removing estimators that results in the removal of an entire
group will shorten the time interval used for computing rates, which will
lead to the rates being underestimated in the next 2-second interval.

Testing was carried out on a 2-socket machine with Intel Xeon Gold 6326
CPUs (64 logical CPUs). Tests with up to 600,000 estimators were
successfully completed. The expectation is that, given the current default
limits, the implementation can handle 150,000 estimators on most machines
in use today. In a test with 100,000 estimators, the default group size of
1024 estimators resulted in the processing time for one group to be circa
2.3 milliseconds and a timer period of 5 jiffies. Despite estimators being
added or removed throughout most of the test, the overhead of
ip_vs_estimator_rebalance() was less than 10% of the overhead of
 estimation_timer():
     7.66%        124093  swapper          [kernel.kallsyms]         [k] intel_idle
     2.86%         14296  ipvsadm          [kernel.kallsyms]         [k] native_queued_spin_lock_slowpath
     2.64%         16827  ipvsadm          [kernel.kallsyms]         [k] ip_vs_genl_parse_service
     2.15%         18457  ipvsadm          libc-2.31.so              [.] _dl_addr
     2.08%          4562  ipvsadm          [kernel.kallsyms]         [k] ip_vs_genl_dump_services
     2.06%         18326  ipvsadm          ld-2.31.so                [.] do_lookup_x
     1.78%         17251  swapper          [kernel.kallsyms]         [k] estimation_timer
...
     0.14%           855  swapper          [kernel.kallsyms]         [k] ip_vs_estimator_rebalance

The intention is to develop this RFC patch into a short series addressing
the design changes proposed in [1]. Also, after moving the rate estimation
out of softirq context, the whole estimator list could be processed
concurrently - more than one work item would be used.

[1] https://lore.kernel.org/netdev/D25792C1-1B89-45DE-9F10-EC350DC04ADC@gmail.com

Signed-off-by: Jiri Wiesner <jwiesner@suse.de>
---
 include/net/ip_vs.h            |  15 ++++
 net/netfilter/ipvs/ip_vs_est.c | 132 +++++++++++++++++++++++++++++++--
 2 files changed, 140 insertions(+), 7 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index ff1804a0c469..386d3cca1fc4 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -349,6 +349,14 @@ struct ip_vs_seq {
 						 * before last resized pkt */
 };
 
+#define	IP_VS_EST_GROUP_SIZE		1024u
+#define	IP_VS_EST_MIN_GROUP_SIZE	64u
+#define	IP_VS_EST_TIME_INTERVAL		(2 * HZ)
+/* This limit comes from MAX_SOFTIRQ_TIME - it should not be longer */
+#define	IP_VS_EST_MAX_TIME		msecs_to_jiffies(2)
+#define	IP_VS_EST_MIN_PERIOD		(IP_VS_EST_MAX_TIME + 1)
+#define	IP_VS_EST_NORM_PERIOD		(4 * IP_VS_EST_MIN_PERIOD)
+
 /* counters per cpu */
 struct ip_vs_counters {
 	__u64		conns;		/* connections scheduled */
@@ -366,6 +374,7 @@ struct ip_vs_cpu_stats {
 /* IPVS statistics objects */
 struct ip_vs_estimator {
 	struct list_head	list;
+	int			group_id;
 
 	u64			last_inbytes;
 	u64			last_outbytes;
@@ -943,6 +952,12 @@ struct netns_ipvs {
 	struct ctl_table	*lblcr_ctl_table;
 	/* ip_vs_est */
 	struct list_head	est_list;	/* estimator list */
+	struct list_head	*est_next;
+	unsigned		est_group_size;
+	unsigned		est_min_grp_size;
+	unsigned		est_period;
+	unsigned		est_last_period;
+	unsigned		est_num_changed;
 	spinlock_t		est_lock;
 	struct timer_list	est_timer;	/* Estimation timer */
 	/* ip_vs_sync */
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index 9a1a7af6a186..41bd729e9dc7 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -92,19 +92,89 @@ static void ip_vs_read_cpu_stats(struct ip_vs_kstats *sum,
 	}
 }
 
+static inline bool ip_vs_estimator_done(struct netns_ipvs *ipvs)
+{
+	return list_is_head(ipvs->est_next, &ipvs->est_list);
+}
+
+static inline bool ip_vs_est_rebalance_needed(struct netns_ipvs *ipvs)
+{
+	return ipvs->est_num_changed > ipvs->est_group_size >> 1;
+}
+
+static void ip_vs_estimator_rebalance(struct netns_ipvs *ipvs)
+{
+	struct ip_vs_estimator *e;
+	unsigned i, num_groups;
+	int gid;
+
+again:
+	i = gid = 0;
+	list_for_each_entry(e, &ipvs->est_list, list) {
+		if (i++ >= ipvs->est_group_size) {
+			++gid;
+			i = 1;
+		}
+		e->group_id = gid;
+	}
+
+	num_groups = gid + 1;
+	ipvs->est_period = IP_VS_EST_TIME_INTERVAL;
+	ipvs->est_last_period = do_div(ipvs->est_period, num_groups);
+	ipvs->est_last_period += ipvs->est_period;
+
+	if (ipvs->est_period < IP_VS_EST_MIN_PERIOD) {
+		ipvs->est_group_size <<= 1;
+		ipvs->est_min_grp_size = ipvs->est_group_size;
+		pr_debug("increasing min group size %u\n",
+			 ipvs->est_min_grp_size);
+		goto again;
+
+	} else if (ipvs->est_period > IP_VS_EST_NORM_PERIOD &&
+		   ipvs->est_min_grp_size > IP_VS_EST_MIN_GROUP_SIZE) {
+		ipvs->est_min_grp_size = IP_VS_EST_MIN_GROUP_SIZE;
+		pr_debug("resetting min group size %u\n",
+			 ipvs->est_min_grp_size);
+	}
+
+	ipvs->est_num_changed = 0;
+
+	pr_debug("group size %u last group size %u num groups %u period %u last period %u\n",
+		 ipvs->est_group_size, i, num_groups,
+		 ipvs->est_period, ipvs->est_last_period);
+}
 
 static void estimation_timer(struct timer_list *t)
 {
+	unsigned long next_timeout, run_time, start_time = jiffies;
+	struct netns_ipvs *ipvs = from_timer(ipvs, t, est_timer);
 	struct ip_vs_estimator *e;
 	struct ip_vs_stats *s;
+	unsigned new_group_size;
 	u64 rate;
-	struct netns_ipvs *ipvs = from_timer(ipvs, t, est_timer);
+	int gid;
 
-	if (!sysctl_run_estimation(ipvs))
+	if (!sysctl_run_estimation(ipvs)) {
+		next_timeout = start_time + IP_VS_EST_TIME_INTERVAL;
 		goto skip;
+	}
 
 	spin_lock(&ipvs->est_lock);
-	list_for_each_entry(e, &ipvs->est_list, list) {
+	/* The lock can be acquired by ip_vs_(start|stop)_estimator.
+	 * Measure the duration of just this critical section.
+	 */
+	run_time = jiffies;
+	if (ip_vs_estimator_done(ipvs))
+		e = list_first_entry(ipvs->est_next, struct ip_vs_estimator,
+				     list);
+	else
+		e = list_entry(ipvs->est_next, struct ip_vs_estimator, list);
+	if (!list_entry_is_head(e, &ipvs->est_list, list))
+		gid = e->group_id;
+
+	list_for_each_entry_from(e, &ipvs->est_list, list) {
+		if (gid != e->group_id)
+			break;
 		s = container_of(e, struct ip_vs_stats, est);
 
 		spin_lock(&s->lock);
@@ -133,20 +203,58 @@ static void estimation_timer(struct timer_list *t)
 		e->outbps += ((s64)rate - (s64)e->outbps) >> 2;
 		spin_unlock(&s->lock);
 	}
+	ipvs->est_next = &e->list;
+
+	run_time = jiffies - run_time;
+	if (run_time > IP_VS_EST_MAX_TIME &&
+	    ipvs->est_group_size > ipvs->est_min_grp_size &&
+	    !ip_vs_est_rebalance_needed(ipvs)) {
+		new_group_size = ipvs->est_group_size >> 1;
+		pr_debug("group id %d run time %lu limit %lu group size %u new group size %u\n",
+			 gid, run_time, IP_VS_EST_MAX_TIME,
+			 ipvs->est_group_size, new_group_size);
+		ipvs->est_group_size = new_group_size;
+		/* Force a rebalance */
+		ipvs->est_num_changed = new_group_size;
+	}
+
+	if (ip_vs_estimator_done(ipvs) && ip_vs_est_rebalance_needed(ipvs))
+		ip_vs_estimator_rebalance(ipvs);
 	spin_unlock(&ipvs->est_lock);
 
+	run_time = jiffies - start_time;
+	if (run_time >= ipvs->est_period)
+		next_timeout = jiffies + 1;
+	else if (ip_vs_estimator_done(ipvs))
+		next_timeout = start_time + ipvs->est_last_period;
+	else
+		next_timeout = start_time + ipvs->est_period;
+
 skip:
-	mod_timer(&ipvs->est_timer, jiffies + 2*HZ);
+	mod_timer(&ipvs->est_timer, next_timeout);
 }
 
 void ip_vs_start_estimator(struct netns_ipvs *ipvs, struct ip_vs_stats *stats)
 {
-	struct ip_vs_estimator *est = &stats->est;
+	struct ip_vs_estimator *tail, *est = &stats->est;
 
 	INIT_LIST_HEAD(&est->list);
 
 	spin_lock_bh(&ipvs->est_lock);
-	list_add(&est->list, &ipvs->est_list);
+	if (!list_empty(&ipvs->est_list)) {
+		tail = list_last_entry(&ipvs->est_list, struct ip_vs_estimator,
+				       list);
+		est->group_id = tail->group_id;
+	}
+	/* New estimators are added to the tail of the list because
+	 * the last group may have extra processing time available,
+	 * ipvs->est_last_period, and may fewer that ipvs->est_group_size
+	 * estimators.
+	 */
+	list_add_tail(&est->list, &ipvs->est_list);
+	++ipvs->est_num_changed;
+	if (ip_vs_estimator_done(ipvs) && ip_vs_est_rebalance_needed(ipvs))
+		ip_vs_estimator_rebalance(ipvs);
 	spin_unlock_bh(&ipvs->est_lock);
 }
 
@@ -155,7 +263,12 @@ void ip_vs_stop_estimator(struct netns_ipvs *ipvs, struct ip_vs_stats *stats)
 	struct ip_vs_estimator *est = &stats->est;
 
 	spin_lock_bh(&ipvs->est_lock);
+	if (ipvs->est_next == &est->list)
+		ipvs->est_next = est->list.next;
 	list_del(&est->list);
+	++ipvs->est_num_changed;
+	if (ip_vs_estimator_done(ipvs) && ip_vs_est_rebalance_needed(ipvs))
+		ip_vs_estimator_rebalance(ipvs);
 	spin_unlock_bh(&ipvs->est_lock);
 }
 
@@ -192,9 +305,14 @@ void ip_vs_read_estimator(struct ip_vs_kstats *dst, struct ip_vs_stats *stats)
 int __net_init ip_vs_estimator_net_init(struct netns_ipvs *ipvs)
 {
 	INIT_LIST_HEAD(&ipvs->est_list);
+	ipvs->est_next = &ipvs->est_list;
+	ipvs->est_group_size = IP_VS_EST_GROUP_SIZE;
+	ipvs->est_min_grp_size = IP_VS_EST_MIN_GROUP_SIZE;
+	ipvs->est_period = IP_VS_EST_TIME_INTERVAL;
+	ipvs->est_last_period = IP_VS_EST_TIME_INTERVAL;
 	spin_lock_init(&ipvs->est_lock);
 	timer_setup(&ipvs->est_timer, estimation_timer, 0);
-	mod_timer(&ipvs->est_timer, jiffies + 2 * HZ);
+	mod_timer(&ipvs->est_timer, jiffies + ipvs->est_period);
 	return 0;
 }
 
-- 
2.35.3

