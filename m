Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5EF43B4B3;
	Mon, 10 Aug 2026 19:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786388803; cv=none; b=jdK+S8AuIO0xpQ2z059bBB5577ie/Fxcacdw0KbO2eBgqMjclBn5j8uhVgEbFUGFLzopIsZVrPG/+4JaVkKW1cqAQ+URy9pqbfJGY8dGvUf+v5+n8L3RpQ9/CgMv7BUpOJsHyTQDRFUCl5BDgbaqCiHj3v5Nvp9vgnjAp8ESR3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786388803; c=relaxed/simple;
	bh=AACnIXax3fDGBPnqWpLacestezF3kBB08pa/SuWzWVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBsPpW6/t4e+y13N3EqjmUrP1r9ENOtr84yZgw9ZHcvUsmTW3KjFCdXEmtTQ+qz9DoB1XzoFonG9X3vXkWUaF6ubgfRxR7I0/F5Wvc7DyVC7883Um74zYxOVJg6plLN2N0BgW/ljc2dIa+M/TcEFP/DLOy8qOFGEF4rwhp99Qm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C1Oq30zX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C1Oq30zX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 897606028E;
	Mon, 10 Aug 2026 21:06:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786388799;
	bh=RapDeowCfsFdfGorRVjwASMw9nzxQb9kj4Y6bRbgoqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1Oq30zXBG344laZfs6lT7soatTg7GVphyitduSBbX61vT/3KKgulaTGKaueE4obz
	 YDY2GkNA8t34vzuniAdEgr8d6ZALNN2p+L57ZvMRD9LXHoZVX5DxgYGxduZP4J6+Zn
	 KmpQfwAbYb3q1RkK9N8MqgyxeyLmIj79hYypAUmtWtaLsjKBO47Hb/Rp+noZqVGgn/
	 qFP275NmfP59JaopzCDHKl8BtHg1+38FQDl5MAc8kCd58Grht70gFrcZLmEZPv1LGS
	 GX06j8OGfKdQ8z1xHCTte+qXpEE4lL9Y8FOE8374Y+pTxpBzSJlHOuUAiVw7wZXHPq
	 qbxpjanbTTVmg==
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
Subject: [PATCH net 04/13] ipvs: properly update the overload flag on dest edit
Date: Mon, 10 Aug 2026 21:06:12 +0200
Message-ID: <20260810190621.894119-5-pablo@netfilter.org>
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

The upper/lower connection thresholds for dest can be changed,
so use ip_vs_dest_update_overload() to properly update the
dest overload flag.

The thresholds were not limited, fit them in the 0 .. INT_MAX
range as already done in ipvsadm.

As the thresholds are also read when connections are created
and expired, use WRITE_ONCE/READ_ONCE to access them.

As the lower threshold is optional, use (u - (u >> 2)) to
calculate the 75% default value based on the upper threshold
by preserving the integer rounding, as suggested by Yizhou Zhao.

Trigger flag update when totalconns reaches one of the
thresholds and use dst_lock to serialize the updating.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |  3 ++
 net/netfilter/ipvs/ip_vs_conn.c | 27 +++++--------
 net/netfilter/ipvs/ip_vs_ctl.c  | 67 +++++++++++++++++++++++++++++----
 3 files changed, 72 insertions(+), 25 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 11f430646db8..e99382930617 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -991,6 +991,7 @@ struct ip_vs_dest {
 	atomic_t		persistconns;	/* persistent connections */
 	__u32			u_threshold;	/* upper threshold */
 	__u32			l_threshold;	/* lower threshold */
+	__u32			l_threshold_val;/* used lower threshold */
 
 	/* for destination cache */
 	spinlock_t		dst_lock;	/* lock of dst_cache */
@@ -1907,6 +1908,8 @@ static inline void ip_vs_dest_put_and_free(struct ip_vs_dest *dest)
 		kfree(dest);
 }
 
+void ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode);
+
 /* IPVS sync daemon data and function prototypes
  * (from ip_vs_sync.c)
  */
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 4d0a6f718ced..abf52a226fee 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1141,22 +1141,22 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 
 	/* Update the connection counters */
 	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
+		int tc;
+
 		/* It is a normal connection, so modify the counters
 		 * according to the flags, later the protocol can
 		 * update them on state change
 		 */
 		if (!(flags & IP_VS_CONN_F_INACTIVE))
 			atomic_inc(&dest->activeconns);
-		atomic_inc(&dest->totalconns);
+		tc = atomic_inc_return(&dest->totalconns);
+		if (tc == READ_ONCE(dest->u_threshold))
+			ip_vs_dest_update_overload(dest, 1);
 	} else {
 		/* It is a persistent connection/template, so increase
 		   the persistent connection counter */
 		atomic_inc(&dest->persistconns);
 	}
-
-	if (dest->u_threshold != 0 &&
-	    atomic_read(&dest->totalconns) >= dest->u_threshold)
-		dest->flags |= IP_VS_DEST_F_OVERLOAD;
 }
 
 
@@ -1237,27 +1237,20 @@ static inline void ip_vs_unbind_dest(struct ip_vs_conn *cp)
 
 	/* Update the connection counters */
 	if (!(cp->flags & IP_VS_CONN_F_TEMPLATE)) {
+		int tc;
+
 		/* It is a normal connection, so decrease the counters */
 		if (!(cp->flags & IP_VS_CONN_F_INACTIVE))
 			atomic_dec(&dest->activeconns);
-		atomic_dec(&dest->totalconns);
+		tc = atomic_fetch_dec(&dest->totalconns);
+		if (tc == READ_ONCE(dest->l_threshold_val))
+			ip_vs_dest_update_overload(dest, -1);
 	} else {
 		/* It is a persistent connection/template, so decrease
 		   the persistent connection counter */
 		atomic_dec(&dest->persistconns);
 	}
 
-	if (dest->l_threshold != 0) {
-		if (atomic_read(&dest->totalconns) < dest->l_threshold)
-			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	} else if (dest->u_threshold != 0) {
-		if (atomic_read(&dest->totalconns) * 4 < dest->u_threshold * 3)
-			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	} else {
-		if (dest->flags & IP_VS_DEST_F_OVERLOAD)
-			dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	}
-
 	ip_vs_dest_put(dest);
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 45f534427d23..974773642af8 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1304,6 +1304,40 @@ void ip_vs_stats_free(struct ip_vs_stats *stats)
 	}
 }
 
+/* Update overload flag based on number of dest conns and lower/upper
+ * connection thresholds:
+ * - conns reach u_threshold and exceed it: set the flag
+ * - conns go below l_threshold (or 75% of u_threshold): clear the flag
+ */
+static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode)
+{
+	int conns;
+	u32 l, u;
+
+	lockdep_assert_held(&dest->dst_lock);
+	u = READ_ONCE(dest->u_threshold);
+	if (!u)
+		goto unset;
+	l = READ_ONCE(dest->l_threshold_val);
+	conns = atomic_read(&dest->totalconns);
+	if (conns >= (mode > 0 ? l : u)) {
+		dest->flags |= IP_VS_DEST_F_OVERLOAD;
+		return;
+	}
+	if (conns >= (mode < 0 ? u : l))
+		return;
+
+unset:
+	dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
+}
+
+void ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode)
+{
+	spin_lock_bh(&dest->dst_lock);
+	__ip_vs_dest_update_overload(dest, mode);
+	spin_unlock_bh(&dest->dst_lock);
+}
+
 /*
  *	Update a destination in the given service
  */
@@ -1370,10 +1404,19 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 	/* set the dest status flags */
 	dest->flags |= IP_VS_DEST_F_AVAILABLE;
 
-	if (udest->u_threshold == 0 || udest->u_threshold > dest->u_threshold)
-		dest->flags &= ~IP_VS_DEST_F_OVERLOAD;
-	dest->u_threshold = udest->u_threshold;
-	dest->l_threshold = udest->l_threshold;
+	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
+	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
+		spin_lock_bh(&dest->dst_lock);
+		WRITE_ONCE(dest->u_threshold, udest->u_threshold);
+		WRITE_ONCE(dest->l_threshold, udest->l_threshold);
+		/* Low threshold defaults to 75% of upper threshold */
+		WRITE_ONCE(dest->l_threshold_val,
+			   udest->l_threshold ? :
+			   (udest->u_threshold -
+			    (udest->u_threshold >> 2)));
+		__ip_vs_dest_update_overload(dest, 0);
+		spin_unlock_bh(&dest->dst_lock);
+	}
 
 	dest->af = udest->af;
 
@@ -1486,6 +1529,9 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 		return -ERANGE;
 	}
 
+	if (udest->u_threshold > INT_MAX)
+		return -EINVAL;
+
 	if (udest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		if (udest->tun_port == 0) {
 			pr_err("%s(): tunnel port is zero\n", __func__);
@@ -1559,6 +1605,9 @@ ip_vs_edit_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 		return -ERANGE;
 	}
 
+	if (udest->u_threshold > INT_MAX)
+		return -EINVAL;
+
 	if (udest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		if (udest->tun_port == 0) {
 			pr_err("%s(): tunnel port is zero\n", __func__);
@@ -3667,8 +3716,8 @@ __ip_vs_get_dest_entries(struct netns_ipvs *ipvs, const struct ip_vs_get_dests *
 			entry.port = dest->port;
 			entry.conn_flags = atomic_read(&dest->conn_flags);
 			entry.weight = atomic_read(&dest->weight);
-			entry.u_threshold = dest->u_threshold;
-			entry.l_threshold = dest->l_threshold;
+			entry.u_threshold = READ_ONCE(dest->u_threshold);
+			entry.l_threshold = READ_ONCE(dest->l_threshold);
 			entry.activeconns = atomic_read(&dest->activeconns);
 			entry.inactconns = ip_vs_dest_inactconns(dest);
 			entry.persistconns = atomic_read(&dest->persistconns);
@@ -4277,8 +4326,10 @@ static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
 			 dest->tun_port) ||
 	    nla_put_u16(skb, IPVS_DEST_ATTR_TUN_FLAGS,
 			dest->tun_flags) ||
-	    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH, dest->u_threshold) ||
-	    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH, dest->l_threshold) ||
+	    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH,
+			READ_ONCE(dest->u_threshold)) ||
+	    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH,
+			READ_ONCE(dest->l_threshold)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
 			atomic_read(&dest->activeconns)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_INACT_CONNS,
-- 
2.47.3

