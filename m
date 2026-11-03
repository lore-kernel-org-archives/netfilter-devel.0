Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714601;
	b=5MFNzT+1n/km/w5sSxL7Pp4OveL4YZE6FN/fnzSTxybbL0yVyLTc4ItEW6reuHPTz4J2
	 SgCHp45H2L+Rmx9nEz1XDAEUxFlT8NKuZK7oPY7h6Jou9sI2tq1aDZ5wktcWUNRwSKoRk
	 xfzVTM8+1QaqWykFPflMR2rQjFcrrqKBC6MEzXdGuWHyjsq0UyYo4TrRd8Zivm7nVbsCU
	 wLyO1Q2WtvngHJENadH43kbIzuxW7M5maTc6hAKuSf3C1WzQUaiIdC3GUBYPswdL8zBJq
	 kL0/vUSwbGn3qOsfI3p0aD+jB8Lbli5ZQ5pwiwEkUaxTC3vEyZyIy9mICwTyADG7S5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714601;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Cl2AY7m+a6wt7oi+NbEe27ga14xwjHMo8dbTwxJ3rkE=;
	b=11MXZRLwJtzgDzbMtT5XaAyTRP7yKL+ywdtBHoVr0YxrS1wOZsk7hTluAdi/b0Eq8e0A
	 5qy85RsIuasFLeHsLVacF033YZHykrQ05X0UXZiDyvvE1tg0uvMLRZ3AiA712kOdn2j0w
	 rj/1zXKj5CYpXBoSMGXMk9KQ+FrhIV3ODUKvMwKEi/b69zMoowFUOHfWJYfQ4O4EahQfI
	 T7U5UtzI0V2a9Bxb6LPEu13u+wfQ+9vF8fecx+2aP5SwTJS5I0zczupa68yKBDnqDSRYG
	 +MHtk6s43ZNZtTuxwjUeNngPUucJ66Wroyh/it4l4GbEhBatCqQbR5JIBWMk/abRwMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Im4eIT8h;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989D96082BD1;
	Tue,  3 Nov 2026 14:03:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 989D96082BD1
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Im4eIT8h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714598;
	bh=Cl2AY7m+a6wt7oi+NbEe27ga14xwjHMo8dbTwxJ3rkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Im4eIT8hae/jOGplA68UqIpUOaWbze1J1iSsxuT5CwmP1GqBUqNJYxYw53vMYqqi2
	 HEdG8n8gnV10lE/Ia77NyijnZHACQwtPCJQ6Hh2izK7HCkA8eslbopgcZDRcKe41z+
	 8WB612M9kWmC1EA7B+L/YPAdHImOPp2TgKEnwHoFcmtyoIR4OLlUEAOPjPwQUGAMUq
	 NqdVc3QF2dmLtWepF3DBPGpDI0pUAHoKUIWFPXFq9pNgbz3NS0hf4JELpWlhBxorjC
	 mLMRdvGjbeiLWlCnt3F0u7rBJRU7iIJMMKx81dVL5gFMLUNkvsaXbAi7BwFdYYNo7d
	 74/HHxka5FkGw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AF24960085;
	Tue,  3 Nov 2026 15:03:17 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 02/15] ipvs: wait grace period while reusing dest from trash
Date: Tue,  3 Nov 2026 15:02:55 +0100
Message-ID: <20261103140308.591690-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Darong Lu <zzyy19904204639@163.com>

Darong Lu and the VEGA team report a problem with the TWOS scheduler
that manifests as a loop while traversing the list of destinations. The
problem occurs if destinations are removed and re-added through the
destination trash before an RCU grace period has elapsed. As destinations
are re-added to a new service, CPUs traversing the old destination list
may never reach the old list head and fail to terminate.

As the problem is not specific to the TWOS scheduler, use a general
solution. Jiayuan Chen provided an initial solution based on
get_state_synchronize_rcu() and cond_synchronize_rcu(), where the grace
period cookie is saved after a destination is unlinked and moved into the
destination trash. cond_synchronize_rcu() then ensures the grace period
before the destination is reused.

Use a temporary list for destinations removed together from a service or
during a flush. A single get_state_synchronize_rcu() call records the
cookie for all destinations before the temporary list is spliced into the
public destination trash. This also limits destination-trash locking to
one acquisition for bulk removal.

Destination edits that remove and re-add an entry to the real-server hash
table use the same grace-period mechanism. Destinations returned to the
trash after an estimator failure are put back without recording a new
cookie.

Fixes: ceec4c381681 ("ipvs: convert services to rcu")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Reported-by: Darong Lu <zzyy19904204639@163.com>
Link: https://patch.msgid.link/cover.1789117690.git.zzyy19904204639@163.com/
Co-developed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Darong Lu <zzyy19904204639@163.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h            |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c | 109 ++++++++++++++++++++++++++-------
 2 files changed, 90 insertions(+), 23 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 9a83bff32569..50a2999beb01 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1021,7 +1021,9 @@ struct ip_vs_dest {
 
 	struct rcu_head		rcu_head;
 	struct list_head	t_list;		/* in dest_trash */
-	unsigned int		in_rs_table:1;	/* we are in rs_table */
+	unsigned long		rcu_state;	/* GP cookie when trashed */
+	unsigned int		in_rs_table:1,	/* we are in rs_table */
+				need_gp:1;	/* Need GP on rehash */
 };
 
 /* The scheduler object */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ce9fe20d6106..7f10cf5b48c7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -64,7 +64,8 @@ int ip_vs_get_debug_level(void)
 
 
 /*  Protos */
-static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup);
+static void __ip_vs_del_service(struct ip_vs_service *svc,
+				struct list_head *dest_trash, bool cleanup);
 
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -918,6 +919,11 @@ static void ip_vs_rs_hash(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
 	 */
 	hash = ip_vs_rs_hashkey(dest->af, &dest->addr, port);
 
+	/* Need RCU grace period when rehashing */
+	if (dest->need_gp) {
+		cond_synchronize_rcu(dest->rcu_state);
+		dest->need_gp = 0;
+	}
 	hlist_add_head_rcu(&dest->d_list, &ipvs->rs_table[hash]);
 	dest->in_rs_table = 1;
 }
@@ -1111,6 +1117,8 @@ ip_vs_trash_get_dest(struct ip_vs_service *svc, int dest_af,
 	struct ip_vs_dest *dest;
 	struct netns_ipvs *ipvs = svc->ipvs;
 
+	lockdep_assert_held(&ipvs->service_mutex);
+
 	/*
 	 * Find the destination in trash
 	 */
@@ -1144,24 +1152,57 @@ ip_vs_trash_get_dest(struct ip_vs_service *svc, int dest_af,
 	return dest;
 }
 
-/* Put destination in trash */
-static void ip_vs_trash_put_dest(struct netns_ipvs *ipvs,
+/* Add destination in temp list for trash */
+static void ip_vs_trash_add_dest(struct netns_ipvs *ipvs,
 				 struct ip_vs_dest *dest, unsigned long istart,
-				 bool cleanup)
+				 struct list_head *dest_trash)
 {
-	spin_lock_bh(&ipvs->dest_trash_lock);
 	IP_VS_DBG_BUF(3, "Moving dest %s:%u into trash, dest->refcnt=%d\n",
 		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port),
 		      refcount_read(&dest->refcnt));
+	/* dest lives in trash with reference */
+	list_add(&dest->t_list, dest_trash);
+	dest->idle_start = istart;
+}
+
+/* Put destinations in trash */
+static void ip_vs_trash_put_dests(struct netns_ipvs *ipvs,
+				  struct list_head *dest_trash, bool cleanup)
+{
+	spin_lock_bh(&ipvs->dest_trash_lock);
 	if (list_empty(&ipvs->dest_trash) && !cleanup)
 		mod_timer(&ipvs->dest_trash_timer,
 			  jiffies + (IP_VS_DEST_TRASH_PERIOD >> 1));
-	/* dest lives in trash with reference */
-	list_add(&dest->t_list, &ipvs->dest_trash);
-	dest->idle_start = istart;
+	list_splice(dest_trash, &ipvs->dest_trash);
 	spin_unlock_bh(&ipvs->dest_trash_lock);
 }
 
+/* Put destination back in trash */
+static void ip_vs_trash_put_back(struct netns_ipvs *ipvs,
+				 struct ip_vs_dest *dest)
+{
+	LIST_HEAD(dest_trash);
+
+	ip_vs_trash_add_dest(ipvs, dest, dest->idle_start, &dest_trash);
+	ip_vs_trash_put_dests(ipvs, &dest_trash, false);
+}
+
+/* Put destinations in trash and save the RCU state */
+static void ip_vs_trash_save_dests(struct netns_ipvs *ipvs,
+				   struct list_head *dest_trash, bool cleanup)
+{
+	struct ip_vs_dest *dest;
+	unsigned long rcu_state;
+
+	if (!list_empty(dest_trash)) {
+		/* Remember when dests were removed and added to dest_trash */
+		rcu_state = get_state_synchronize_rcu();
+		list_for_each_entry(dest, dest_trash, t_list)
+			dest->rcu_state = rcu_state;
+		ip_vs_trash_put_dests(ipvs, dest_trash, cleanup);
+	}
+}
+
 static void ip_vs_dest_rcu_free(struct rcu_head *head)
 {
 	struct ip_vs_dest *dest;
@@ -1369,8 +1410,16 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	if ((udest->conn_flags & IP_VS_CONN_F_FWD_MASK) !=
 	    IP_VS_DFWD_METHOD(dest) ||
 	    udest->tun_type != dest->tun_type ||
-	    udest->tun_port != dest->tun_port)
+	    udest->tun_port != dest->tun_port) {
+		bool unlinked = dest->in_rs_table;
+
 		ip_vs_rs_unhash(dest);
+		if (unlinked) {
+			dest->rcu_state = get_state_synchronize_rcu();
+			/* Need grace period in this or next dest update */
+			dest->need_gp = 1;
+		}
+	}
 
 	/* set the tunnel info */
 	dest->tun_type = udest->tun_type;
@@ -1566,11 +1615,18 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 
 		ret = ip_vs_start_estimator(svc->ipvs, &dest->stats);
 		/* On error put back dest into the trash */
-		if (ret < 0)
-			ip_vs_trash_put_dest(svc->ipvs, dest, dest->idle_start,
-					     false);
-		else
+		if (ret < 0) {
+			ip_vs_trash_put_back(svc->ipvs, dest);
+		} else {
+			/* Readers may still follow the n_list/d_list of the
+			 * unlinked dest, wait before linking it again.
+			 */
+			cond_synchronize_rcu(dest->rcu_state);
+			/* need_gp matters only on dest edit, reinit it */
+			dest->need_gp = 0;
+
 			__ip_vs_update_dest(svc, dest, udest, 1);
+		}
 	} else {
 		/*
 		 * Allocate and initialize the dest structure
@@ -1634,7 +1690,7 @@ ip_vs_edit_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
  *	Delete a destination (must be already unlinked from the service)
  */
 static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
-			     bool cleanup)
+			     struct list_head *dest_trash, bool cleanup)
 {
 	ip_vs_stop_estimator(ipvs, &dest->stats);
 
@@ -1643,7 +1699,7 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
 	 */
 	ip_vs_rs_unhash(dest);
 
-	ip_vs_trash_put_dest(ipvs, dest, 0, cleanup);
+	ip_vs_trash_add_dest(ipvs, dest, 0, dest_trash);
 
 	/* Queue up delayed work to expire all no destination connections.
 	 * No-op when CONFIG_SYSCTL is disabled.
@@ -1693,6 +1749,7 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 {
 	struct ip_vs_dest *dest;
 	__be16 dport = udest->port;
+	LIST_HEAD(dest_trash);
 
 	/* We use function that requires RCU lock */
 	rcu_read_lock();
@@ -1712,7 +1769,9 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 	/*
 	 *	Delete the destination
 	 */
-	__ip_vs_del_dest(svc->ipvs, dest, false);
+	__ip_vs_del_dest(svc->ipvs, dest, &dest_trash, false);
+
+	ip_vs_trash_save_dests(svc->ipvs, &dest_trash, false);
 
 	return 0;
 }
@@ -2057,7 +2116,8 @@ ip_vs_edit_service(struct ip_vs_service *svc, struct ip_vs_service_user_kern *u)
  *	- The service must be unlinked, unlocked and not referenced!
  *	- We are called under _bh lock
  */
-static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
+static void __ip_vs_del_service(struct ip_vs_service *svc,
+				struct list_head *dest_trash, bool cleanup)
 {
 	struct ip_vs_dest *dest, *nxt;
 	struct ip_vs_scheduler *old_sched;
@@ -2091,7 +2151,7 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 	 */
 	list_for_each_entry_safe(dest, nxt, &svc->destinations, n_list) {
 		__ip_vs_unlink_dest(svc, dest, 0);
-		__ip_vs_del_dest(svc->ipvs, dest, cleanup);
+		__ip_vs_del_dest(svc->ipvs, dest, dest_trash, cleanup);
 	}
 
 	/*
@@ -2114,7 +2174,8 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 /*
  * Unlink a service from list and try to delete it if its refcnt reached 0
  */
-static void ip_vs_unlink_service(struct ip_vs_service *svc, bool cleanup)
+static void ip_vs_unlink_service(struct ip_vs_service *svc,
+				 struct list_head *dest_trash, bool cleanup)
 {
 	ip_vs_unregister_conntrack(svc);
 	/* Hold svc to avoid double release from dest_trash */
@@ -2124,7 +2185,7 @@ static void ip_vs_unlink_service(struct ip_vs_service *svc, bool cleanup)
 	 */
 	ip_vs_svc_unhash(svc);
 
-	__ip_vs_del_service(svc, cleanup);
+	__ip_vs_del_service(svc, dest_trash, cleanup);
 }
 
 /*
@@ -2134,12 +2195,14 @@ static int ip_vs_del_service(struct ip_vs_service *svc)
 {
 	struct netns_ipvs *ipvs;
 	struct ip_vs_rht *t, *p;
+	LIST_HEAD(dest_trash);
 	int ns;
 
 	if (svc == NULL)
 		return -EEXIST;
 	ipvs = svc->ipvs;
-	ip_vs_unlink_service(svc, false);
+	ip_vs_unlink_service(svc, &dest_trash, false);
+	ip_vs_trash_save_dests(ipvs, &dest_trash, false);
 
 	/* Drop the table if no more services */
 	ns = ip_vs_get_num_services(ipvs);
@@ -2190,6 +2253,7 @@ static int ip_vs_flush(struct netns_ipvs *ipvs, bool cleanup)
 	struct hlist_bl_node *ne;
 	struct hlist_bl_node *e;
 	struct ip_vs_rht *t, *p;
+	LIST_HEAD(dest_trash);
 
 	/* Stop the resizer and drop the tables */
 	if (!test_and_set_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
@@ -2199,8 +2263,9 @@ static int ip_vs_flush(struct netns_ipvs *ipvs, bool cleanup)
 	if (ip_vs_get_num_services(ipvs)) {
 		ip_vs_rht_walk_buckets(ipvs->svc_table, head) {
 			hlist_bl_for_each_entry_safe(svc, e, ne, head, s_list)
-				ip_vs_unlink_service(svc, cleanup);
+				ip_vs_unlink_service(svc, &dest_trash, cleanup);
 		}
+		ip_vs_trash_save_dests(ipvs, &dest_trash, cleanup);
 	}
 
 	/* Unregister the hash table and release it after RCU grace period */
-- 
2.47.3

