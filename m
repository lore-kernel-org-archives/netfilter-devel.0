Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D48432BF5;
	Mon, 10 Aug 2026 19:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388804; cv=none; b=hDjl5bQO8Vq1rdJxdvT1X2Oqz2t7NKUnL2HCpVPlVX59VVwHICUMYn+LBCizPBNDU0TGqPYhp/206O/QH6UVFNRiuvUebUmYvOvzORipDCea9r6K8v5xyny2556Z4/V2DbPXXFshyaZqKqt6Ea5c1IJzgXtMbjWotqlfjL2vjMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388804; c=relaxed/simple;
	bh=+vp93RZ8aL+qm2U04TYVjpLJhJ+PipANpIsNTvQaE+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXfDhrcTyLZUFKqOVPxEnXlgVqbXN6Czu7GylAKIkzJ9NeMrdOCLrVgPHUI4Ror3MiFv5hn/dLQnBPi7ioTqciQpmNEA6qHQtAIMaVy1Xq3jH/C8bhxRqr88j1YuphLLpE2DCDLb0MlyanTgui7B7Qs8WROVPrUbE4WDwjOvf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jVynIXG7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jVynIXG7"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0BF7860290;
	Mon, 10 Aug 2026 21:06:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388800;
	bh=nqG+veuL4lq9eidpOU4H6nVTXCyqSwI83lCHi/GMcRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVynIXG7R1EeXXri+9gzg69cef1PQsFKSK6XBK5FIUTkq8krz0nOx968/alyht3IW
	 ApfmFWFecxPCrhoRktBrvQfUK6mip53crqPLVWi2c8HZIYZz9Gflb3HPPVhx2d3cah
	 8/YtXk5Yikx6pm8QFoe80ZMzxqm8P3GIYnixSZ2smlCb+0Gv5YU8laEOfHQ6UXscnF
	 QGM/wp/EEFOji5CCPQPBqFAv/jshv3uTuFRpfcZ11NAu/exc044AbDVcxxv6IXfige
	 9j7SMenmGp/U0czybmtOUrSClm+Zw2NFMaj0AqGri3GKyle6SPBTNVfrP2ZmR0MuzG
	 5Bua8xK4JsMlg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 05/13] ipvs: separate destination availability state
Date: Mon, 10 Aug 2026 21:06:13 +0200
Message-ID: <20260810190621.894119-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810190621.894119-1-pablo@netfilter.org>
References: <20260810190621.894119-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

IPVS configuration paths update destination availability while connection
accounting updates destination overload state. The two independent states
share dest->flags, so their read-modify-write updates can race and lose one
another.

Keep OVERLOAD in flags, where the preceding patch serializes its updates
with dst_lock, and move AVAILABLE to cflags. This keeps configuration-
controlled availability out of the scheduler hot cacheline until a
scheduler needs to check it. It also prevents availability updates from
clobbering overload state.

The destination status bits are not exposed through the IPVS sockopt or
netlink interfaces, so keep their definitions in the internal IPVS header.

Readers can still observe stale destination state; this does not provide a
cross-field snapshot.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Link: https://lore.kernel.org/all/8913381c-1e02-35c7-0ec4-61de5a12fd35@ssi.bg/
Assisted-by: Claude-Code:GLM-5.2
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h              | 7 +++++++
 include/uapi/linux/ip_vs.h       | 6 ------
 net/netfilter/ipvs/ip_vs_conn.c  | 4 ++--
 net/netfilter/ipvs/ip_vs_core.c  | 6 +++---
 net/netfilter/ipvs/ip_vs_ctl.c   | 4 ++--
 net/netfilter/ipvs/ip_vs_dh.c    | 4 ++--
 net/netfilter/ipvs/ip_vs_lblc.c  | 2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c | 8 ++++----
 net/netfilter/ipvs/ip_vs_xmit.c  | 4 ++--
 9 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index e99382930617..fc2ef5ef31a6 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -36,6 +36,12 @@
 #define IP_VS_HDR_INVERSE	1
 #define IP_VS_HDR_ICMP		2
 
+/* Destination Server Flags */
+#define IP_VS_DEST_F_OVERLOAD	0x0002		/* server is overloaded */
+
+/* Destination Server Config Flags */
+#define IP_VS_DEST_CF_AVAILABLE	0x0001		/* server is available */
+
 /* conn_tab limits (as per Kconfig) */
 #define IP_VS_CONN_TAB_MIN_BITS	8
 #if BITS_PER_LONG > 32
@@ -976,6 +982,7 @@ struct ip_vs_dest {
 	volatile unsigned int	flags;		/* dest status flags */
 	atomic_t		conn_flags;	/* flags to copy to conn */
 	atomic_t		weight;		/* server weight */
+	unsigned long		cflags;		/* config flags */
 	atomic_t		last_weight;	/* server latest weight */
 	__u16			tun_type;	/* tunnel type */
 	__be16			tun_port;	/* tunnel port */
diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 1ed234e7f251..2c37c6ac7525 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -28,12 +28,6 @@
 #define IP_VS_SVC_F_SCHED_SH_FALLBACK	IP_VS_SVC_F_SCHED1 /* SH fallback */
 #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
 
-/*
- *      Destination Server Flags
- */
-#define IP_VS_DEST_F_AVAILABLE	0x0001		/* server is available */
-#define IP_VS_DEST_F_OVERLOAD	0x0002		/* server is overloaded */
-
 /*
  *      IPVS sync daemon states
  */
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index abf52a226fee..6fa3e1dc534c 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1279,7 +1279,7 @@ int ip_vs_check_template(struct ip_vs_conn *ct, struct ip_vs_dest *cdest)
 	 * Checking the dest server status.
 	 */
 	if ((dest == NULL) ||
-	    !(dest->flags & IP_VS_DEST_F_AVAILABLE) ||
+	    !(dest->cflags & IP_VS_DEST_CF_AVAILABLE) ||
 	    expire_quiescent_template(ipvs, dest) ||
 	    (cdest && (dest != cdest))) {
 		IP_VS_DBG_BUF(9, "check_template: dest not available for "
@@ -2020,7 +2020,7 @@ void ip_vs_expire_nodest_conn_flush(struct netns_ipvs *ipvs)
 			cp = ip_vs_hn0_to_conn(hn);
 			resched_score++;
 			dest = cp->dest;
-			if (!dest || (dest->flags & IP_VS_DEST_F_AVAILABLE))
+			if (!dest || (dest->cflags & IP_VS_DEST_CF_AVAILABLE))
 				continue;
 
 			if (atomic_read(&cp->n_control))
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 0bdaeb4ed61e..95af77b68851 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -302,7 +302,7 @@ ip_vs_in_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 	struct ip_vs_dest *dest = cp->dest;
 	struct netns_ipvs *ipvs = cp->ipvs;
 
-	if (dest && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (dest && (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		struct ip_vs_cpu_stats *s;
 		struct ip_vs_service *svc;
 
@@ -338,7 +338,7 @@ ip_vs_out_stats(struct ip_vs_conn *cp, struct sk_buff *skb)
 	struct ip_vs_dest *dest = cp->dest;
 	struct netns_ipvs *ipvs = cp->ipvs;
 
-	if (dest && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (dest && (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		struct ip_vs_cpu_stats *s;
 		struct ip_vs_service *svc;
 
@@ -2210,7 +2210,7 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 	}
 
 	/* Check the server status */
-	if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (cp && cp->dest && !(cp->dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 		/* the destination server is not available */
 		if (sysctl_expire_nodest_conn(ipvs)) {
 			bool old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 974773642af8..8f9a8e491ad6 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1402,7 +1402,7 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	}
 
 	/* set the dest status flags */
-	dest->flags |= IP_VS_DEST_F_AVAILABLE;
+	dest->cflags |= IP_VS_DEST_CF_AVAILABLE;
 
 	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
 	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
@@ -1662,7 +1662,7 @@ static void __ip_vs_unlink_dest(struct ip_vs_service *svc,
 				struct ip_vs_dest *dest,
 				int svcupd)
 {
-	dest->flags &= ~IP_VS_DEST_F_AVAILABLE;
+	dest->cflags &= ~IP_VS_DEST_CF_AVAILABLE;
 
 	spin_lock_bh(&dest->dst_lock);
 	__ip_vs_dst_cache_reset(dest);
diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
index e1f62f6b25e2..43abed7a26a6 100644
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -219,8 +219,8 @@ ip_vs_dh_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 	s = (struct ip_vs_dh_state *) svc->sched_data;
 	dest = ip_vs_dh_get(svc->af, s, &iph->daddr);
-	if (!dest
-	    || !(dest->flags & IP_VS_DEST_F_AVAILABLE)
+	if (!dest ||
+	    !(dest->cflags & IP_VS_DEST_CF_AVAILABLE)
 	    || atomic_read(&dest->weight) <= 0
 	    || is_overloaded(dest)) {
 		ip_vs_scheduler_err(svc, "no destination available");
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 15ccb2b2fa1f..693bcc82ccb7 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -502,7 +502,7 @@ ip_vs_lblc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		 */
 
 		dest = en->dest;
-		if ((dest->flags & IP_VS_DEST_F_AVAILABLE) &&
+		if ((dest->cflags & IP_VS_DEST_CF_AVAILABLE) &&
 		    atomic_read(&dest->weight) > 0 && !is_overloaded(dest, svc))
 			goto out;
 	}
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index c90ea897c3f7..f53f05ceea36 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -169,8 +169,8 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 		if (least->flags & IP_VS_DEST_F_OVERLOAD)
 			continue;
 
-		if ((atomic_read(&least->weight) > 0)
-		    && (least->flags & IP_VS_DEST_F_AVAILABLE)) {
+		if ((atomic_read(&least->weight) > 0) &&
+		    (least->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 			loh = ip_vs_dest_conn_overhead(least);
 			goto nextstage;
 		}
@@ -186,8 +186,8 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 
 		doh = ip_vs_dest_conn_overhead(dest);
 		if (((__s64)loh * atomic_read(&dest->weight) >
-		     (__s64)doh * atomic_read(&least->weight))
-		    && (dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+		     (__s64)doh * atomic_read(&least->weight)) &&
+		    (dest->cflags & IP_VS_DEST_CF_AVAILABLE)) {
 			least = dest;
 			loh = doh;
 		}
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index c4508f3f43dd..fc7403186394 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -351,7 +351,7 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			 * stored in dest_trash.
 			 */
 			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
-			    dest->flags & IP_VS_DEST_F_AVAILABLE)
+			    dest->cflags & IP_VS_DEST_CF_AVAILABLE)
 				__ip_vs_dst_set(dest, dest_dst, &rt->dst, 0);
 			else
 				noref = 0;
@@ -530,7 +530,7 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 			 * stored in dest_trash.
 			 */
 			if (!rt_dev_is_down(dst_dev_rcu(&rt->dst)) &&
-			    dest->flags & IP_VS_DEST_F_AVAILABLE)
+			    dest->cflags & IP_VS_DEST_CF_AVAILABLE)
 				__ip_vs_dst_set(dest, dest_dst, &rt->dst, cookie);
 			else
 				noref = 0;
-- 
2.47.3

