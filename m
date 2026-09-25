Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27BD446C17
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 19:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790365032; cv=none; b=pywku0cJvMhpmEk4g5hGiHIXXEFspFMYQIbpl9ox0s9jiZnkOWo7JZm667eaPemTk60LfTAdcFS8h4rF136WxHLNID7kU4sdyZ7Ken97ahCH8ib8Pfr8ZZY4Bcn92Y0lkTfT0ckGRZhjAAKggdIoasR8LYGfRXny9zVdpiVOHd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790365032; c=relaxed/simple;
	bh=rwE8HvGW3Ylhv20HVWnLEXP8mXv68ATpcnx7RFAZsu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSjrv2SgSifzvw5mgxv1hgbbzt7GI1gN4Me70/jW+CUtCpEtaneavLDK94QCoZtEmAgFnDGfrxqRiXJJCfWSAHbxseVfJO3R/o8OSYG8R9QqRp79E2xxzKXksCenoX3zYextdeTmSuYjQ5imPwVPPnqqa0PFR+xBz5wk98Kmd2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=bXow/k4n; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="bXow/k4n"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b31b4281eso1006785a91.2
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 12:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790365030; x=1790969830; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EV+wqW4UmArHSyCyZvSdEQXXWxxUFGc3EQCLBdoiMLs=;
        b=bXow/k4nJJuqWkblA9rT0QEQThDnKxYwHQIgatk8ZJ/WUXRTHwZqcL/DakMFcqcNE+
         V1DJeO2n/nHpx/rDlxuGcqko+vCeFQ6y0e2nmNIigpxGkaVtrOwq6RopFfQjvn9N0pN1
         TUPjxV9aHKOinCZjzgyzUdfJ0WOi3hMP8q+/h34qJdnKdK5hPBBj1QaUX0AYoC1qm0GK
         OUz36LYS/nCC1blknzC/7E6hu9uy15T5d3sFO6FI6LcTmj46ONQHFqntcc9NxS8hfDCc
         J2mtBuQpoRtsACkVQXTXMybxAoBh83jr8G/tfmO4pc0vwPm0H3Ey6Uz0RRZkhd/Xn1Qw
         IqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790365030; x=1790969830;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EV+wqW4UmArHSyCyZvSdEQXXWxxUFGc3EQCLBdoiMLs=;
        b=2wfhrF/5r10ngk/cw7W10pN55Px0f6l10b6rRHyTJea0TIsiCoHboA/RCm/HfLyC0X
         q/wM6Of7fa8iPIG1Mvc21lNBZG7XplsQHRp/eIDMdX/32uoCkHOtnhU0g5u+Xrvk6phZ
         b5pCy91cFUCyTlVr5zpVhZj5d0gOoYAutCLbWMJddAtCdMoMW5XXbhL2akTRY/Z5T+/v
         RRBuOTzQd0P7949EEGBNF6wlIsfuzw65RwQw4aeiXPHLNAlNRqFBsEaVRUzj8Bj8zp5O
         OFv7tmgLDJ5KxcosbgYqW5athiGCYMTY5eWGV2pEWpQNMUWZFB8MDxbPUpEM2wH9+N+w
         ZQag==
X-Forwarded-Encrypted: i=1; AKwUvBwUKVbhSan7HUvN2TybjXog8x2zt0cT55GJ52Z+fp259R9mlBwabbCcWkeTaYSWNnEsGjcf9qtUwoyCzB00Xkw=@vger.kernel.org
X-Gm-Message-State: AFuF++luoV1/oVqgdPK2F3T0fE3g1foxKyCFbFbRbRm7LB6+OFyAIJNI
	ExhVlGTPvJrRmxcKIcRiCUljSY05v/6h9JsqbdJ7jhFUyreenJsfDHMrCeB7xq341L2Q
X-Gm-Gg: AYBFou1H05SMPdy1nNMxDxuYsItz88bsgsKUAisaC/hKNPi50Cr3jbY6hRbVUN2kU/a
	2OqPBfuShCuLuwdyKGR7D+LC7Dmv6XRsR24l9baf1/fsKlnVqrMdTXKAhVaMEYSfsFA95PTXWhd
	B+kk4Sjt8j++olBzd0YLmlZ1990Txnk6cDyQgGIinBqVjGQN5lbjOzjQJbjESK4J0J+JQyS95pZ
	Y+1rXeQnhZ3G5EyySupN1Mejk9Hc7ItOjQhxay9fB4tYGh/7jwqKm/1NEkILMc1CJNCR5OgPuhI
	jMOjoOyM4MKeqHo/2riCZkiNFUzk4J8YGexwuaiSlIlX+u1D7EmOMcoRHtjY64JhsEFOvKjOnDO
	N8vcVCb3is87Fk2PxzXXD5U23mTrZEf7sVFsumTV8Df6LdVFExK/KyiiKobfCR5kha7LQIsthjU
	eNOmF66yfmNJbW05ToD9BRBMtuAaIzK0xhE+E+h9x1CXJADtXch9jQ4onEGPkTC8cvKw+qnKu+C
	Qbg5MCPvsM=
X-Received: by 2002:a17:90b:2fc5:b0:3a0:b809:b9e8 with SMTP id 98e67ed59e1d1-3a0b809bbb5mr2675891a91.44.1790365029836;
        Fri, 25 Sep 2026 12:37:09 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([240e:37a:1253:e500:95a:bb1c:29d9:90fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b9892dbfsm6086657a91.11.2026.09.25.12.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 12:37:08 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Julian Anastasov <ja@ssi.bg>
Cc: dsahern@kernel.org,
	idosch@nvidia.com,
	horms@verge.net.au,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	zzyy19904204639@163.com,
	jiayuan.chen@linux.dev,
	weir@nebusec.ai
Subject: [PATCH nf v2 1/1] ipvs: wait grace period while reusing dest from trash
Date: Sat, 26 Sep 2026 03:36:55 +0800
Message-ID: <5bac9b2d5e34fcfb326761b948afdf64a3b1d7b9.1790244000.git.zzyy19904204639@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1789473164.git.zzyy19904204639@163.com>
References: <cover.1789473164.git.zzyy19904204639@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
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

Reported-by: Vega <vega@nebusec.ai>
Reported-by: Darong Lu <zzyy19904204639@163.com>
Fixes: ceec4c381681 ("ipvs: convert services to rcu")
Cc: stable@vger.kernel.org
Co-developed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Darong Lu <zzyy19904204639@163.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>

---
Changes since v1:

  - Replace the TWOS-only destination-walk bounds with a general fix for
    destination list-node reuse through dest_trash, as requested by Julian.
  - Use Jiayuan's get_state_synchronize_rcu()/cond_synchronize_rcu()
    scheme so bulk service replacement waits at most once.
  - Batch removed destinations on a temporary list and splice them into
    dest_trash under one lock acquisition.
  - Handle destination rehashes with a saved grace-period cookie and avoid
    assigning need_gp after ip_vs_rs_unhash() clears in_rs_table.
  - Drop the duplicate list_add() in the estimator-error return path.
  - Leave the reported TWOS total_weight and signed weight/overhead
    multiplication overflows unchanged. They are pre-existing correctness
    issues, unrelated to this RCU iterator invalidation, and outside this
    patch's scope. In addition, get_random_u32_below() takes a u32, so the
    report's description of a negative random bound is not applicable.
  - The report's characterization of RR as having the same unbounded walk
    does not apply to the current code: RR limits its traversal to two
    passes, so no RR-specific change is needed.

v1 Link: https://lore.kernel.org/all/cover.1789117690.git.zzyy19904204639@163.com/
---
 include/net/ip_vs.h            |   4 +-
 net/netfilter/ipvs/ip_vs_ctl.c | 109 ++++++++++++++++++++++++++++++++---------
 2 files changed, 90 insertions(+), 23 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 32fde731bceb..a07e1b6414ef 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1013,7 +1013,9 @@ struct ip_vs_dest {
 
 	struct rcu_head		rcu_head;
 	struct list_head	t_list;		/* in dest_trash */
-	unsigned int		in_rs_table:1;	/* we are in rs_table */
+	unsigned long		rcu_state;	/* GP cookie when trashed */
+	unsigned int		in_rs_table:1,	/* we are in rs_table */
+				need_gp:1;	/* Need GP on rehash */
 };
 
 /* The scheduler object */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 4c1c739446b7..74cf6d075abf 100644
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
@@ -1568,11 +1617,18 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 
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
@@ -1636,7 +1692,7 @@ ip_vs_edit_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
  *	Delete a destination (must be already unlinked from the service)
  */
 static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
-			     bool cleanup)
+			     struct list_head *dest_trash, bool cleanup)
 {
 	ip_vs_stop_estimator(ipvs, &dest->stats);
 
@@ -1645,7 +1701,7 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
 	 */
 	ip_vs_rs_unhash(dest);
 
-	ip_vs_trash_put_dest(ipvs, dest, 0, cleanup);
+	ip_vs_trash_add_dest(ipvs, dest, 0, dest_trash);
 
 	/* Queue up delayed work to expire all no destination connections.
 	 * No-op when CONFIG_SYSCTL is disabled.
@@ -1695,6 +1751,7 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 {
 	struct ip_vs_dest *dest;
 	__be16 dport = udest->port;
+	LIST_HEAD(dest_trash);
 
 	/* We use function that requires RCU lock */
 	rcu_read_lock();
@@ -1714,7 +1771,9 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 	/*
 	 *	Delete the destination
 	 */
-	__ip_vs_del_dest(svc->ipvs, dest, false);
+	__ip_vs_del_dest(svc->ipvs, dest, &dest_trash, false);
+
+	ip_vs_trash_save_dests(svc->ipvs, &dest_trash, false);
 
 	return 0;
 }
@@ -2059,7 +2118,8 @@ ip_vs_edit_service(struct ip_vs_service *svc, struct ip_vs_service_user_kern *u)
  *	- The service must be unlinked, unlocked and not referenced!
  *	- We are called under _bh lock
  */
-static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
+static void __ip_vs_del_service(struct ip_vs_service *svc,
+				struct list_head *dest_trash, bool cleanup)
 {
 	struct ip_vs_dest *dest, *nxt;
 	struct ip_vs_scheduler *old_sched;
@@ -2093,7 +2153,7 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 	 */
 	list_for_each_entry_safe(dest, nxt, &svc->destinations, n_list) {
 		__ip_vs_unlink_dest(svc, dest, 0);
-		__ip_vs_del_dest(svc->ipvs, dest, cleanup);
+		__ip_vs_del_dest(svc->ipvs, dest, dest_trash, cleanup);
 	}
 
 	/*
@@ -2116,7 +2176,8 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 /*
  * Unlink a service from list and try to delete it if its refcnt reached 0
  */
-static void ip_vs_unlink_service(struct ip_vs_service *svc, bool cleanup)
+static void ip_vs_unlink_service(struct ip_vs_service *svc,
+				 struct list_head *dest_trash, bool cleanup)
 {
 	ip_vs_unregister_conntrack(svc);
 	/* Hold svc to avoid double release from dest_trash */
@@ -2126,7 +2187,7 @@ static void ip_vs_unlink_service(struct ip_vs_service *svc, bool cleanup)
 	 */
 	ip_vs_svc_unhash(svc);
 
-	__ip_vs_del_service(svc, cleanup);
+	__ip_vs_del_service(svc, dest_trash, cleanup);
 }
 
 /*
@@ -2136,12 +2197,14 @@ static int ip_vs_del_service(struct ip_vs_service *svc)
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
@@ -2192,6 +2255,7 @@ static int ip_vs_flush(struct netns_ipvs *ipvs, bool cleanup)
 	struct hlist_bl_node *ne;
 	struct hlist_bl_node *e;
 	struct ip_vs_rht *t, *p;
+	LIST_HEAD(dest_trash);
 
 	/* Stop the resizer and drop the tables */
 	if (!test_and_set_bit(IP_VS_WORK_SVC_NORESIZE, &ipvs->work_flags))
@@ -2201,8 +2265,9 @@ static int ip_vs_flush(struct netns_ipvs *ipvs, bool cleanup)
 	if (ip_vs_get_num_services(ipvs)) {
 		ip_vs_rht_walk_buckets(ipvs->svc_table, head) {
 			hlist_bl_for_each_entry_safe(svc, e, ne, head, s_list)
-				ip_vs_unlink_service(svc, cleanup);
+				ip_vs_unlink_service(svc, &dest_trash, cleanup);
 		}
+		ip_vs_trash_save_dests(ipvs, &dest_trash, cleanup);
 	}
 
 	/* Unregister the hash table and release it after RCU grace period */
