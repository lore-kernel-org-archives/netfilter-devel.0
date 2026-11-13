Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532504;
	b=MLniwntZdc/M5/+0fpdg1+AwSbwx77E23ivCXyO5DBmaJDsmlXZoyqfEiFoGlU+obwm0
	 QSjxSqPIU6awYW6aWhtxUfoS2bJ9qsaJUSi3EGln1hm4AQ13o11/TunqhANC/775wGYPg
	 Arsa4rI+PpJ/tTLZMEz8/jfaskviJrCAY31jwCpocxKGH8bIsPstNlz0hXzARL6oQZQUw
	 LNcqsQxVav2YcbuFY2mtEwtBAim86jRdjFdvh2qY54SfSPzaIsplHEJ3HcZUUVdYc4oE8
	 eyKdbk3JZobdYg5zDsrRikAA0XsY6zLxbaiqrj9mSSgDDLSOp/K2Vw/SLWpz6MlDkOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532504;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=DqYZNzAk0qOqQDAvzyRhmwlg8184xMVw/vNC+P20nIA=;
	b=E1pmWyLQeOGvh1q+I7Ret6Z1fk+jepnZeQtAyHs4W189KeK64Hpp7Bzunl+Qwb2M/CT4
	 RIUa9xPVhsEvJCTVTHagjH8g0XJgf1pkySkSXqJLiDV8KwjQ7K31NwHVrqS5a5CGdzSfw
	 0BstDjeiL2Y128f4hky3Xt5o93Z5l9jBF5+WjEJqcPDvwozW68XW0YH3KCA3QABFo78NL
	 oxH6TfbU8pTs/pG+LbbeduzmT5RtGm2umSET79XRSRckfXk1aW1bPkKbJZbWFyO63eAKt
	 3C6h9vpIt7zJEYH08FoOtAXN523wJDXOG9+VJHAOuD/nKOkjDjJ4wGYnN54eTKUWyVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k2LMK0XA;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEECC606A88E;
	Fri, 13 Nov 2026 01:15:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEECC606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=k2LMK0XA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532502;
	bh=DqYZNzAk0qOqQDAvzyRhmwlg8184xMVw/vNC+P20nIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2LMK0XAAoZDcDRs2i2TylYA3RxKFJ/h5fZM6zKAfRvHiXzBMgiHn3zd/Mk9MJXTI
	 vtXSM8xAIOf9Wp5VJlRVTNX0DbDKTFlHwX23rLy7yJaknjPKFwVf0KaQ0zwBHTV/Vw
	 NmcYFBmGF92Bm8wgv9BYUqL/IejQ9mp+wLuycm6oDNjYwGCH0kdUffOh+HjnHi/Tew
	 2lrxGBCdT65kiOxC/89JyqwHB6JBOaiZYKZVkchxNAnSjQQfe4sMK9y0xWF4AZxy4d
	 RqaoAf/Ez2vGu3KwfbxAux2dxAKT2kxqyIbSeHXjVrgI3JTdsvSfVMVlmj99xu6jFV
	 skiRuXwRsMBag==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 76E556005F;
	Fri, 13 Nov 2026 02:15:01 +0100 (CET)
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
Subject: [PATCH net 04/15] ipvs: avoid stack overflow from recursive connection expiration
Date: Fri, 13 Nov 2026 02:14:36 +0100
Message-ID: <20261113011447.2357709-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
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

