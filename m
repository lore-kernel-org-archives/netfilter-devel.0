Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789864;
	b=I4NT1wFZIahvmRO6N6Sdc+0tT+bP39w5zJpAoe1Vy8WJxbjhFs+UA8by9GRkO1cxSMzY
	 wHE5W+DSzaXdlO3/LdQ0xpV6f/v25+pdSLLOm4MimHugbPr8ouBs5fmmQ8uGsQvJO0px7
	 ccCFHItA9V1y6n3d7zSH77FhbFCkdsVY7VgGFBzbd9nz5gK1M7OufsWDostnXnTLoDFq9
	 T+NrT3wYQl1Lr8P3tqpAoVy5q7AQ52GmjZvyq1kDpv0JcHKvkAN3P+zjQjuQfq6ZS0KtU
	 KOl/jtVbC4hGZB+MUdWyhopVoFCP5dTB7NX7XscUdv4uDThhUsQkdV5ttaGciRo+MiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789864;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=EdJ6pkVAgWuaOtMLrDLTHn1mVevcHg+vBOBTVC8qtPs=;
	b=20QVlyclmowjP+hmUmLvGMezzv/kllf2mgF73IwVWqChV7IiHna8AGE9uhGute3YOCfF
	 24VswcxlpFs8ATdhoG9Iqi124Uat4Up9lO7kKF90eY0gfeO8CiLR4S2GebsWXtJRLufeR
	 enU9C6QW/w98gnksplFi0BQLAVzgin5/agMygH5KQSYJYEiMN2YrGSguCccStzeYbBtzh
	 2qQzHdyQEqNcieKFj508V12fhw3C3hUVCxBPCG9H/ZogP/6UpFHKOutFnhapKFUs0y/yv
	 PTr5UXyada9Xpt/O68e7ZVcy+va4PDBL9v2zS9T3wq+uIJJqnEDvtzuyl9fA3GTiFlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="sTS2a/CA";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463B7606A88F;
	Mon, 16 Nov 2026 00:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 463B7606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=sTS2a/CA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789862;
	bh=EdJ6pkVAgWuaOtMLrDLTHn1mVevcHg+vBOBTVC8qtPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTS2a/CAP0igKPHWKdquzS+vRVJ0UfxZCKozLTpgj9W63Mn0atd0AaTlMH2bGj7ty
	 Tn0+NmtKNGdN+28alrDxH2wtnf7yYbuue9RxG9LAicTDGzls5vXSKbgECB74nH2wUQ
	 0moPZSPEyUUt+v2MBOr6N1mVnbAhXiENRRcTeGXeLtbEcdXYpd6C8KE4sj/MoKiNR9
	 Vqi41RLWuQJgsHjQNkHuzV0jiWanP/vpWvABWaYjNyahFZO5B3+ZkB24TCz9URWcjQ
	 5knUGtUfUF17zlKT+JTuuRGcpYE28pgkIAU982vky30a5KeWWGsDthbaM9I5mSUL7d
	 lBclAp0ZFyNFg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 976D66005C;
	Mon, 16 Nov 2026 01:44:21 +0100 (CET)
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
Subject: [PATCH net 07/11] ipvs: honor the overload state and do not enter it forever
Date: Mon, 16 Nov 2026 01:44:00 +0100
Message-ID: <20261116004404.2821183-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116004404.2821183-1-pablo@netfilter.org>
References: <20261116004404.2821183-1-pablo@netfilter.org>
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

From: Julian Anastasov <ja@ssi.bg>

Sashiko warns that we may enter the dest overload state forever
if setting the u_threshold to 1 races with the ip_vs_unbind_dest()
call for the last connection for dest. The problem is that we
prefer ip_vs_unbind_dest() to avoid using locks while reading the
threshold.

To avoid the race, add a smp_mb() in __ip_vs_dest_update_overload()
that is paired with the atomic_fetch_dec() in ip_vs_unbind_dest()
which allows to re-read the totalconns and to leave the overload
state if we are below l_threshold_val.

Also, remove the overload parameter from ip_vs_dest_update_overload()
because we just need to know the current state while deciding
which threshold ranges to use. This ip_vs_dest_is_overloaded() check
can be in __ip_vs_dest_update_overload() instead.

To avoid ip_vs_bind_dest() to enter lock just to initialize
u_threshold_val to INT_MAX, do it in ip_vs_new_dest().

The LBLC and LBLCR schedulers do not honor the global overload state
for cached dests, so add a ip_vs_dest_is_overloaded() check for
the situations where we may fallback from overloaded dest (LBLC and
LBLCR) or when we hit a cached dest (LBLC).

Also, move the ip_vs_dest_set_min() call in LBLCR after the
ip_vs_dest_set_erase() call that removes the most-loaded
server because due to races we may work with dest that is
in process of removing, i.e. ip_vs_dest_set_min() and
ip_vs_dest_set_max() may return same dest.

Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
Fixes: 3ba20137287f ("ipvs: fix more races around the overload flag")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h              |  2 +-
 net/netfilter/ipvs/ip_vs_conn.c  |  4 ++--
 net/netfilter/ipvs/ip_vs_ctl.c   | 30 ++++++++++++++++++------------
 net/netfilter/ipvs/ip_vs_lblc.c  |  8 +++++---
 net/netfilter/ipvs/ip_vs_lblcr.c | 13 +++++++------
 5 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 97097d60d1c4..c1f7a3f144f1 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1922,7 +1922,7 @@ static inline void ip_vs_dest_put_and_free(struct ip_vs_dest *dest)
 		kfree(dest);
 }
 
-void ip_vs_dest_update_overload(struct ip_vs_dest *dest, bool overload);
+void ip_vs_dest_update_overload(struct ip_vs_dest *dest);
 
 /* Check if dest is in overloaded state */
 static inline bool ip_vs_dest_is_overloaded(const struct ip_vs_dest *dest)
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 27db8d558a03..66fcdc00ef37 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1168,7 +1168,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 			atomic_inc(&dest->activeconns);
 		tc = atomic_inc_return(&dest->totalconns);
 		if (tc >= READ_ONCE(dest->u_threshold_val))
-			ip_vs_dest_update_overload(dest, true);
+			ip_vs_dest_update_overload(dest);
 	} else {
 		/* It is a persistent connection/template, so increase
 		   the persistent connection counter */
@@ -1261,7 +1261,7 @@ static inline void ip_vs_unbind_dest(struct ip_vs_conn *cp)
 			atomic_dec(&dest->activeconns);
 		tc = atomic_fetch_dec(&dest->totalconns);
 		if (tc <= READ_ONCE(dest->l_threshold_val))
-			ip_vs_dest_update_overload(dest, false);
+			ip_vs_dest_update_overload(dest);
 	} else {
 		/* It is a persistent connection/template, so decrease
 		   the persistent connection counter */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index ce9fe20d6106..5868adda6ed6 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1304,12 +1304,12 @@ void ip_vs_stats_free(struct ip_vs_stats *stats)
 	}
 }
 
-/* Update overload flag based on number of dest conns and lower/upper
+/* Update overload state based on number of dest conns and lower/upper
  * connection thresholds:
- * - conns reach u_threshold and exceed it: set the flag
- * - conns go below l_threshold (or 75% of u_threshold): clear the flag
+ * - conns reach u_threshold and exceed it: set the overload state
+ * - conns go below l_threshold (or 75% of u_threshold): clear the state
  */
-static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, bool overload)
+static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest)
 {
 	int conns;
 	u32 l, u;
@@ -1320,10 +1320,18 @@ static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, bool overload)
 		/* Low threshold defaults to 75% of upper threshold */
 		l = READ_ONCE(dest->l_threshold) ? : (u - (u >> 2));
 		conns = atomic_read(&dest->totalconns);
-		if (conns >= (overload ? l : u)) {
+		if (conns >= (ip_vs_dest_is_overloaded(dest) ? l : u)) {
 			WRITE_ONCE(dest->u_threshold_val, INT_MAX);
 			WRITE_ONCE(dest->l_threshold_val, l);
-			return;
+			/* Commit thresholds before repeating the check,
+			 * it is paired with atomic_fetch_dec() in
+			 * ip_vs_unbind_dest() to avoid entering the
+			 * overload state forever.
+			 */
+			smp_mb();
+			conns = atomic_read(&dest->totalconns);
+			if (conns >= l)
+				return;
 		}
 	}
 
@@ -1331,10 +1339,10 @@ static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, bool overload)
 	WRITE_ONCE(dest->l_threshold_val, 0);
 }
 
-void ip_vs_dest_update_overload(struct ip_vs_dest *dest, bool overload)
+void ip_vs_dest_update_overload(struct ip_vs_dest *dest)
 {
 	spin_lock_bh(&dest->dst_lock);
-	__ip_vs_dest_update_overload(dest, overload);
+	__ip_vs_dest_update_overload(dest);
 	spin_unlock_bh(&dest->dst_lock);
 }
 
@@ -1406,13 +1414,10 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 
 	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
 	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
-		bool overload;
-
 		spin_lock_bh(&dest->dst_lock);
 		WRITE_ONCE(dest->u_threshold, udest->u_threshold);
 		WRITE_ONCE(dest->l_threshold, udest->l_threshold);
-		overload = ip_vs_dest_is_overloaded(dest);
-		__ip_vs_dest_update_overload(dest, overload);
+		__ip_vs_dest_update_overload(dest);
 		spin_unlock_bh(&dest->dst_lock);
 	}
 
@@ -1477,6 +1482,7 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 	if (ret < 0)
 		goto err_stats;
 
+	dest->u_threshold_val = INT_MAX;
 	dest->af = udest->af;
 	dest->protocol = svc->protocol;
 	dest->vaddr = svc->addr;
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index e1111c3b2721..f5ce1f2afb86 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -467,10 +467,11 @@ is_overloaded(struct ip_vs_dest *dest, struct ip_vs_service *svc)
 		struct ip_vs_dest *d;
 
 		list_for_each_entry_rcu(d, &svc->destinations, n_list) {
-			if (atomic_read(&d->activeconns)*2
-			    < atomic_read(&d->weight)) {
+			if (ip_vs_dest_is_overloaded(d))
+				continue;
+			if (atomic_read(&d->activeconns) * 2 <
+			    atomic_read(&d->weight))
 				return 1;
-			}
 		}
 	}
 	return 0;
@@ -507,6 +508,7 @@ ip_vs_lblc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 		dest = en->dest;
 		if ((dest->cflags & IP_VS_DEST_CF_AVAILABLE) &&
+		    !ip_vs_dest_is_overloaded(dest) &&
 		    atomic_read(&dest->weight) > 0 && !is_overloaded(dest, svc))
 			goto out;
 	}
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index dfb5bf83750d..4046608922e7 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -630,10 +630,11 @@ is_overloaded(struct ip_vs_dest *dest, struct ip_vs_service *svc)
 		struct ip_vs_dest *d;
 
 		list_for_each_entry_rcu(d, &svc->destinations, n_list) {
-			if (atomic_read(&d->activeconns)*2
-			    < atomic_read(&d->weight)) {
+			if (ip_vs_dest_is_overloaded(d))
+				continue;
+			if (atomic_read(&d->activeconns) * 2 <
+			    atomic_read(&d->weight))
 				return 1;
-			}
 		}
 	}
 	return 0;
@@ -658,9 +659,6 @@ ip_vs_lblcr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 	if (en) {
 		en->lastuse = jiffies;
 
-		/* Get the least loaded destination */
-		dest = ip_vs_dest_set_min(&en->set);
-
 		/* More than one destination + enough time passed by, cleanup */
 		if (atomic_read(&en->set.size) > 1 &&
 		    time_after(jiffies, en->set.lastmod +
@@ -676,6 +674,9 @@ ip_vs_lblcr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 			spin_unlock_bh(&svc->sched_lock);
 		}
 
+		/* Get the least loaded destination */
+		dest = ip_vs_dest_set_min(&en->set);
+
 		/* If the destination is not overloaded, use it */
 		if (dest && !is_overloaded(dest, svc))
 			goto out;
-- 
2.47.3

