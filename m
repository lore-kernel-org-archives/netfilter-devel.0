Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6965343802A;
	Mon, 10 Aug 2026 19:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388801; cv=none; b=LaoiNgFnygUlLrGk0uv/lHL9uPzoWxmuVDwhBqd0jJAE2xiRlaUFGiOx3hof4Bp/gK9GE+rflu8GDBjRMe5K0h1BrnLtgHNags3UZ0w6Dj4iC02uqRPz4a+I2CBevLS7N3ezQsp60kdtVPIzZo4nF8IHxwH5dbV4nXpcmgk9Ww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388801; c=relaxed/simple;
	bh=Op0vNfpgM/Wz0JW4dXx8N/Vh+xdkT7YOsf2iTs1KWYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rasqFbgORp388PHIMaBOUdCwPYfLFJGlzA1F73wRKWSUkqKMna0KtrjfQS6unac4GpwHjpE8GDh9S7oFDl6DeK60RdXbb/V6+0xZds1orWQJzALKZCezQdM7x8y/pD4e2ISfstbHGkMylJgK/Q1aHLYXuXLBEKjv9HY3hUdq2T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tAGLMUbw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tAGLMUbw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9E8F06028D;
	Mon, 10 Aug 2026 21:06:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388797;
	bh=J1cIVvSNqe3ui55kbY9eOengPCBlJJpyjO5mGQJ2Rk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAGLMUbwe7CyHOfjCXhKj+Y8BtIBuIJ+UlSy9G0QccidIT31B3weskr5TfVCezypH
	 v+Pk4RXsv88KgoupGsY8JkG4/Dy3hw8XPeSnxrOmfbvoC8d6WeUN0cIcDAbyokWr4q
	 4QObWcPWPIsfjS4eaIijeyfTYgiZk4LRK0+aIFXYP2KIvnquEIEKnozMpoRH1nTvGX
	 d5GQ/f7xZ3hGiIC7Duh4VIPKrLvcWrx5+UcZNcBaNw3fm6BpdAwc7xZVMTxIAeQRoc
	 RXbVS2rWvozxQbcD4OZp/CGGhfshsMykXyrNUdMXdfB988Bmn30mQUIdT0ddwbsOgN
	 qwz3gr1ajv4Sg==
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
Subject: [PATCH net 03/13] ipvs: add totalconns for dest
Date: Mon, 10 Aug 2026 21:06:11 +0200
Message-ID: <20260810190621.894119-4-pablo@netfilter.org>
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

From: Julian Anastasov <ja@ssi.bg>

Replace the inactconns dest counter with totalconns, now
inactconns can be obtained from totalconns - activeconns.
This reduces the atomic inc/dec ops for TCP/SCTP from
6 to 4 if the connection is established and then closed.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h                   | 17 ++++++++++++-----
 net/netfilter/ipvs/ip_vs_conn.c       | 24 +++++++-----------------
 net/netfilter/ipvs/ip_vs_ctl.c        | 10 +++++-----
 net/netfilter/ipvs/ip_vs_lc.c         |  4 ++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  2 --
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |  2 --
 net/netfilter/ipvs/ip_vs_sync.c       |  7 ++-----
 7 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index d2813eb795be..11f430646db8 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -987,7 +987,7 @@ struct ip_vs_dest {
 
 	/* connection counters and thresholds */
 	atomic_t		activeconns;	/* active connections */
-	atomic_t		inactconns;	/* inactive connections */
+	atomic_t		totalconns;	/* total connections */
 	atomic_t		persistconns;	/* persistent connections */
 	__u32			u_threshold;	/* upper threshold */
 	__u32			l_threshold;	/* lower threshold */
@@ -2220,14 +2220,21 @@ void ip_vs_unregister_hooks(struct netns_ipvs *ipvs, unsigned int af);
 static inline int
 ip_vs_dest_conn_overhead(struct ip_vs_dest *dest)
 {
-	/* We think the overhead of processing active connections is 256
+	/* We think the overhead of processing active connections is 257
 	 * times higher than that of inactive connections in average. (This
-	 * 256 times might not be accurate, we will change it later) We
+	 * 257 times might not be accurate, we will change it later) We
 	 * use the following formula to estimate the overhead now:
-	 *		  dest->activeconns*256 + dest->inactconns
+	 *		  dest->activeconns*256 + dest->totalconns
 	 */
 	return (atomic_read(&dest->activeconns) << 8) +
-		atomic_read(&dest->inactconns);
+		atomic_read(&dest->totalconns);
+}
+
+static inline int
+ip_vs_dest_inactconns(const struct ip_vs_dest *dest)
+{
+	return max(atomic_read(&dest->totalconns) -
+		   atomic_read(&dest->activeconns), 0);
 }
 
 #ifdef CONFIG_IP_VS_PROTO_TCP
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 36c5cba03f5b..4d0a6f718ced 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1081,12 +1081,6 @@ static inline void ip_vs_bind_xmit_v6(struct ip_vs_conn *cp)
 #endif
 
 
-static inline int ip_vs_dest_totalconns(struct ip_vs_dest *dest)
-{
-	return atomic_read(&dest->activeconns)
-		+ atomic_read(&dest->inactconns);
-}
-
 /*
  *	Bind a connection entry with a virtual service destination
  *	Called just after a new connection entry is created.
@@ -1153,8 +1147,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 		 */
 		if (!(flags & IP_VS_CONN_F_INACTIVE))
 			atomic_inc(&dest->activeconns);
-		else
-			atomic_inc(&dest->inactconns);
+		atomic_inc(&dest->totalconns);
 	} else {
 		/* It is a persistent connection/template, so increase
 		   the persistent connection counter */
@@ -1162,7 +1155,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	}
 
 	if (dest->u_threshold != 0 &&
-	    ip_vs_dest_totalconns(dest) >= dest->u_threshold)
+	    atomic_read(&dest->totalconns) >= dest->u_threshold)
 		dest->flags |= IP_VS_DEST_F_OVERLOAD;
 }
 
@@ -1244,13 +1237,10 @@ static inline void ip_vs_unbind_dest(struct ip_vs_conn *cp)
 
 	/* Update the connection counters */
 	if (!(cp->flags & IP_VS_CONN_F_TEMPLATE)) {
-		/* It is a normal connection, so decrease the inactconns
-		   or activeconns counter */
-		if (cp->flags & IP_VS_CONN_F_INACTIVE) {
-			atomic_dec(&dest->inactconns);
-		} else {
+		/* It is a normal connection, so decrease the counters */
+		if (!(cp->flags & IP_VS_CONN_F_INACTIVE))
 			atomic_dec(&dest->activeconns);
-		}
+		atomic_dec(&dest->totalconns);
 	} else {
 		/* It is a persistent connection/template, so decrease
 		   the persistent connection counter */
@@ -1258,10 +1248,10 @@ static inline void ip_vs_unbind_dest(struct ip_vs_conn *cp)
 	}
 
 	if (dest->l_threshold != 0) {
-		if (ip_vs_dest_totalconns(dest) < dest->l_threshold)
+		if (atomic_read(&dest->totalconns) < dest->l_threshold)
 			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
 	} else if (dest->u_threshold != 0) {
-		if (ip_vs_dest_totalconns(dest) * 4 < dest->u_threshold * 3)
+		if (atomic_read(&dest->totalconns) * 4 < dest->u_threshold * 3)
 			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
 	} else {
 		if (dest->flags & IP_VS_DEST_F_OVERLOAD)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index bcf40b8c41cf..45f534427d23 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1445,7 +1445,7 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 	dest->port = udest->port;
 
 	atomic_set(&dest->activeconns, 0);
-	atomic_set(&dest->inactconns, 0);
+	atomic_set(&dest->totalconns, 0);
 	atomic_set(&dest->persistconns, 0);
 	refcount_set(&dest->refcnt, 1);
 
@@ -3031,7 +3031,7 @@ static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
 					   ip_vs_fwd_name(atomic_read(&dest->conn_flags)),
 					   atomic_read(&dest->weight),
 					   atomic_read(&dest->activeconns),
-					   atomic_read(&dest->inactconns));
+					   ip_vs_dest_inactconns(dest));
 			else
 #endif
 				seq_printf(seq,
@@ -3042,7 +3042,7 @@ static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
 					   ip_vs_fwd_name(atomic_read(&dest->conn_flags)),
 					   atomic_read(&dest->weight),
 					   atomic_read(&dest->activeconns),
-					   atomic_read(&dest->inactconns));
+					   ip_vs_dest_inactconns(dest));
 
 		}
 	}
@@ -3670,7 +3670,7 @@ __ip_vs_get_dest_entries(struct netns_ipvs *ipvs, const struct ip_vs_get_dests *
 			entry.u_threshold = dest->u_threshold;
 			entry.l_threshold = dest->l_threshold;
 			entry.activeconns = atomic_read(&dest->activeconns);
-			entry.inactconns = atomic_read(&dest->inactconns);
+			entry.inactconns = ip_vs_dest_inactconns(dest);
 			entry.persistconns = atomic_read(&dest->persistconns);
 			ip_vs_copy_stats(&kstats, &dest->stats);
 			ip_vs_export_stats_user(&entry.stats, &kstats);
@@ -4282,7 +4282,7 @@ static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
 	    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
 			atomic_read(&dest->activeconns)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_INACT_CONNS,
-			atomic_read(&dest->inactconns)) ||
+			ip_vs_dest_inactconns(dest)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_PERSIST_CONNS,
 			atomic_read(&dest->persistconns)) ||
 	    nla_put_u16(skb, IPVS_DEST_ATTR_ADDR_FAMILY, dest->af))
diff --git a/net/netfilter/ipvs/ip_vs_lc.c b/net/netfilter/ipvs/ip_vs_lc.c
index 38cc38c5d8bb..18b976a7c4d2 100644
--- a/net/netfilter/ipvs/ip_vs_lc.c
+++ b/net/netfilter/ipvs/ip_vs_lc.c
@@ -30,7 +30,7 @@ ip_vs_lc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 	/*
 	 * Simply select the server with the least number of
-	 *        (activeconns<<5) + inactconns
+	 *        (activeconns*256) + totalconns
 	 * Except whose weight is equal to zero.
 	 * If the weight is equal to zero, it means that the server is
 	 * quiesced, the existing connections to the server still get
@@ -56,7 +56,7 @@ ip_vs_lc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 			      IP_VS_DBG_ADDR(least->af, &least->addr),
 			      ntohs(least->port),
 			      atomic_read(&least->activeconns),
-			      atomic_read(&least->inactconns));
+			      ip_vs_dest_inactconns(least));
 
 	return least;
 }
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index c80567c73469..fb8af6b15a39 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -446,12 +446,10 @@ set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				(next_state != IP_VS_SCTP_S_ESTABLISHED)) {
 				atomic_dec(&dest->activeconns);
-				atomic_inc(&dest->inactconns);
 				cp->flags |= IP_VS_CONN_F_INACTIVE;
 			} else if ((cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				   (next_state == IP_VS_SCTP_S_ESTABLISHED)) {
 				atomic_inc(&dest->activeconns);
-				atomic_dec(&dest->inactconns);
 				cp->flags &= ~IP_VS_CONN_F_INACTIVE;
 			}
 		}
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 99a286fdc90c..fec0e8b47b71 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -526,12 +526,10 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
 			    !tcp_state_active(new_state)) {
 				atomic_dec(&dest->activeconns);
-				atomic_inc(&dest->inactconns);
 				cp->flags |= IP_VS_CONN_F_INACTIVE;
 			} else if ((cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				   tcp_state_active(new_state)) {
 				atomic_inc(&dest->activeconns);
-				atomic_dec(&dest->inactconns);
 				cp->flags &= ~IP_VS_CONN_F_INACTIVE;
 			}
 		}
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 93038abbf5e0..ea5fdd4f4ce7 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -878,13 +878,10 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 		spin_lock_bh(&cp->lock);
 		if ((cp->flags ^ flags) & IP_VS_CONN_F_INACTIVE &&
 		    !(flags & IP_VS_CONN_F_TEMPLATE) && dest) {
-			if (flags & IP_VS_CONN_F_INACTIVE) {
+			if (flags & IP_VS_CONN_F_INACTIVE)
 				atomic_dec(&dest->activeconns);
-				atomic_inc(&dest->inactconns);
-			} else {
+			else
 				atomic_inc(&dest->activeconns);
-				atomic_dec(&dest->inactconns);
-			}
 		}
 		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
 		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;
-- 
2.47.3

