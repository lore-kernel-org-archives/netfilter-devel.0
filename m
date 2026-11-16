Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789857;
	b=XS027jtN+VAOEZoOrn/U1X4hlNDzjWMCLRPmYP/4deRoca06KJVhU1dSufjm8abfa3wP
	 na5e5qX7HkhZLcKX/zmO4DW8w8bX74UPyrnkEYGMRATcsAWw5KJExX1fFDJhUrA2uCaRm
	 r8RhA5d9kKePHE1ajR97tmlE5PAY0uYKneSzGRIUnd/zBtjiOxplhPPWtCSnvkb//O1NS
	 RksYyHhIMkPKeq8KRnCgVlCSpgtkQvJkFywQUQDIi1e3TT3Mpa7Z7aPlzgqNDO/yZiO4o
	 UWB/8vc0yxXwYXn3fqVcpWyJayrL8LXiZZhMGDgA6Jqf+66oUuWDuW2e4txZ91pjFgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789857;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=DqYZNzAk0qOqQDAvzyRhmwlg8184xMVw/vNC+P20nIA=;
	b=LgBAxRGY0oynVTgpR207bF0K84lBRCW3Qt84E6KxtYSL37fJ0+kwSgoKOwNfK/qstkZ3
	 Dkm1wd2fPE/JyMERKDK/Df6j/U8833T28uPfro+S3w6q3vCdxArQqrwRF4Hxy57/i30VY
	 VJ5EqcAIZ8g6WXqVwiLsfaTtk62TIyjlMfb+p2QWuOaSAj+MQgipzwnzVPQfGmnr17isr
	 QZw2A9SebvbhB3KmfAEiya+hky3IhvK/tw7z+DQB4tXX0NjyS87vVbzpOLlIF9N1gY3LY
	 mgBpCR0BBuSXrlfg117GifzWJuhXhiDJcisYdh+HHY7ZyAFGijb9sBTTfw319r/gFZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WUWJHLUR;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9000A606A33A;
	Mon, 16 Nov 2026 00:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9000A606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WUWJHLUR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789854;
	bh=DqYZNzAk0qOqQDAvzyRhmwlg8184xMVw/vNC+P20nIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUWJHLURYNpRgRmxlVnFiow8o941my/t2JgLoVo9KPofa+FRDku+iVYXYKCWzIcsj
	 hst18/2KRB8WEOZLvBDjpAg0UJRd+saUcUzrg/VuNIVbOCzd7h4lWr+4nupjnauzpk
	 U9fXjRuVymQtNU5eI2Ct55Qt5fUJiczGz+y/449TKQ0VLOpa1z0KBMWiiU7ZqXXdlU
	 9kF764wE2kfjUUa2c7SmzkJWU3mvKnBh7HGGMJCqhBs6doVzJHPUNAH/DVjxYyiCbf
	 o8XX57pBaCPCSAXCJJTcHSoqBjq2/tqTo960TrBkcYeHzxwiuZPAZTGyCzVNTrFgwg
	 c/kzmIZXZM+sw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 02DBD6005F;
	Mon, 16 Nov 2026 01:44:13 +0100 (CET)
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
Subject: [PATCH net 02/11] ipvs: avoid stack overflow from recursive connection expiration
Date: Mon, 16 Nov 2026 01:43:55 +0100
Message-ID: <20261116004404.2821183-3-pablo@netfilter.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

When a controlled IPVS connection expires, its controller may be expired
synchronously if it has no remaining controlled connections. A chain of
controlled connections can then recurse through ip_vs_conn_expire() and
exhaust the kernel stack during namespace cleanup.

Continue expiration with the controller after the current connection has
been fully cleaned up instead of calling ip_vs_conn_del() recursively. Keep
the expiration walk under RCU, preserve the immediate-drop timeout for a
controller with its own controller, and switch to deletion mode before the
next iteration.

This keeps controlled-connection cleanup synchronous while using one stack
frame for the whole chain. The timer callback race during connection
deletion is handled by the preceding connection-deletion fix.

This patch depends on "ipvs: fix problems during connection deletion" to
protect the iterative controller cleanup from the timer callback race.

Fixes: f9200a52eedf ("ipvs: avoid expiring many connections from timer")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 40 ++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 86c5e6c7b5af..27db8d558a03 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1336,9 +1336,23 @@ static void ip_vs_conn_rcu_free(struct rcu_head *head)
 	kmem_cache_free(ip_vs_conn_cachep, cp);
 }
 
-/* Try to delete connection while not holding reference.
+/* Try to steal the reference from the pending timer.
  * It can be called concurrently and always under RCU lock
  * to protect from connection deletion from others.
+ */
+static bool ip_vs_conn_del_reference(struct ip_vs_conn *cp)
+{
+	/* Steal reference from the pending timer */
+	if (!timer_delete(&cp->timer))
+		return false;
+
+	/* Drop cp->control chain too */
+	if (cp->control)
+		cp->timeout = 0;
+	return true;
+}
+
+/* Try to delete connection while not holding reference.
  * Used when we need to remove the connection immediately
  * and without overloading the timer processing.
  * OTOH, we use ip_vs_conn_expire_now() when we prefer to
@@ -1347,13 +1361,8 @@ static void ip_vs_conn_rcu_free(struct rcu_head *head)
  */
 static void ip_vs_conn_del(struct ip_vs_conn *cp)
 {
-	/* Steal reference from the pending timer */
-	if (timer_delete(&cp->timer)) {
-		/* Drop cp->control chain too */
-		if (cp->control)
-			cp->timeout = 0;
+	if (ip_vs_conn_del_reference(cp))
 		ip_vs_conn_expire(&cp->timer);
-	}
 }
 
 /* Connection is removed in the following steps:
@@ -1366,6 +1375,9 @@ static void ip_vs_conn_expire(struct timer_list *t)
 	struct ip_vs_conn *cp = timer_container_of(cp, t, timer);
 	struct netns_ipvs *ipvs = cp->ipvs;
 
+	rcu_read_lock();
+
+repeat:
 	/*
 	 *	do I control anybody?
 	 */
@@ -1375,19 +1387,18 @@ static void ip_vs_conn_expire(struct timer_list *t)
 	/* Unlink conn if not referenced anymore */
 	if (likely(ip_vs_conn_unlink(cp))) {
 		struct ip_vs_conn *ct = cp->control;
+		bool next = false;
 
 		/* does anybody control me? */
 		if (ct) {
-			rcu_read_lock();
 			ip_vs_control_del(cp);
 			/* Drop CTL or non-assured TPL if not used anymore */
 			if (!cp->timeout && !atomic_read(&ct->n_control) &&
 			    (!(ct->flags & IP_VS_CONN_F_TEMPLATE) ||
 			     !(ct->state & IP_VS_CTPL_S_ASSURED))) {
 				IP_VS_DBG(4, "drop controlling connection\n");
-				ip_vs_conn_del(ct);
+				next = ip_vs_conn_del_reference(ct);
 			}
-			rcu_read_unlock();
 		}
 
 		if ((cp->flags & IP_VS_CONN_F_NFCT) &&
@@ -1414,7 +1425,11 @@ static void ip_vs_conn_expire(struct timer_list *t)
 		else
 			call_rcu(&cp->rcu_head, ip_vs_conn_rcu_free);
 		atomic_dec(&ipvs->conn_count);
-		return;
+		if (next) {
+			cp = ct;
+			goto repeat;
+		}
+		goto out;
 	}
 
   expire_later:
@@ -1429,6 +1444,9 @@ static void ip_vs_conn_expire(struct timer_list *t)
 		ip_vs_sync_conn(ipvs, cp, sysctl_sync_threshold(ipvs));
 
 	__ip_vs_conn_put_timer(cp);
+
+out:
+	rcu_read_unlock();
 }
 
 /* Modify timer, so that it expires as soon as possible.
-- 
2.47.3

