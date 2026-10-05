Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7812379EC8
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 13:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205645; cv=none; b=H2sSryz9D/VGxpgFmDcnGtIsN1sch7gcFCTYrs1lmKK2wqpePf4p7szRNyP82Ezszyqb82MfAt7Y7GMap1/jcY7tYIaZfQSjYVJ6WzJvsCguSU+VKaqtdO5U90b5qr84tnosnkYz9VlUvPIyvWIEb8U1AKvHVucvCtEnnDFUoY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205645; c=relaxed/simple;
	bh=NOmCfmWZ5OYjyeJt33xeBqQsa/xlb1PiagSWT7wD7Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJoT2PbiWmO+8KJQdLN2LVTLWxZTgIBPDHfR1B4WYbyC5QGzxkwGA2o3QfY5XwC2dd0rlJTSZtQGkPuJgafhvC0ovn19zsv00vCd24YHgCOTfaDQc9BYduXzc51Zhn6JqSUVWjHeFDPgRrVw6i4vP1mhNwWVwnAUNpHQNOGicnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=YPW0vMV4; arc=none smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="YPW0vMV4"
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-887d4b0e846so324708b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 06:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791205643; x=1791810443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Po7hEeJ6c5N6N8lVIIUjkLh+Mo7McigzXlftFVQL6Mo=;
        b=YPW0vMV4ae7yaxukflmZK6HoUafjAENNy6Ie1C6a7wBK/td2Mec1uI4tJIURhO6Fbf
         vRZztcCkHJ1pBpfWJKr2cBvkyQ3ewMdGVvcgajgVcgFU24VsgcGjeL4er0q0x/N7BI15
         a9id5cZfu/ZLsawL6ryoNgXlMCdogpiAZmNiPtYSVI2p7V8p9HxqNWY8xumJTDA9tmmv
         XNuEANA5GhEOXqH3qycrW+aexQ9CBCRm/aIpV5uL8ANd3B83s0I7b7WTADSx6L9RrO7m
         WvoDZiBjdY4GWuQwpP85jvcOZ+GhXAYexz8FoS/xp7pldyq+j/GkLaX50+D6Vy+zYXHb
         0MGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791205643; x=1791810443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Po7hEeJ6c5N6N8lVIIUjkLh+Mo7McigzXlftFVQL6Mo=;
        b=1CyN6/LCvvt1gWKRYVeyIKa6AiNt5a15CJeiom/KUC1/tJRDE7YGRNhcydD7UD9PMR
         6OQ5bOe3Y3gUvp3WuqLjfTZ/zTovpSqZ9XH0nsGOXGQlCfAmWLUI/76On0nwxagWWPzR
         x6emXvNRltZmeeUGat6bNrZG7TvEt/XsZd7bMAah9h5pDt1E/YRy8sGaCP2ly5zWuA4V
         +LFz+G1MTRFG+MjLjqTfwSIqyYMqfsS6vPLXaTG8muQifrATc4sib9pdVroVrb4QQkRT
         Kt00KsGKDiOnaCqYLtvXkbOMbxmG31XAOPBu3pXQzmJd0rMuSXap9vxIkxBI3a/cgAXp
         N+WA==
X-Forwarded-Encrypted: i=1; AKwUvBywqrnY22uxWnxZGRCoEavNiCYTWZL58+9PH1QuxerYPmuOVlGzSPo0nwliFbjBjDDX22wgfMYTFYZmYvqjYiU=@vger.kernel.org
X-Gm-Message-State: AFuF++kCkij9ZVRv/xnJ7NMLZ14rJLvc9msGnKmd/eSedDvcZRlT7f9n
	0VGp20SsR7Z4pUsCDKe78CR8mIIaptJV6kYWqI/zgHntKWp9URzIQTW7KqRgIj56mPlcbv/U5j2
	JiKbtCZwesuI=
X-Gm-Gg: AYBFou3n9XZl/8uodf//Xvf2DIC77i4bDsQNX1/qauw8uHX1r3eFeaSQF4yK0q/7SIa
	aeb0/sVZ1UnKCJRfQUbIEbbi2jSJk4ChDLgqEmfYU10vr0mKkshsnAAJx8Rr1QuHCbiTpaNVOhN
	CZdWq5D8AinglBD/YfdbTqJp0Iv2FOvn2WXqLnkwyqOJKtJMf3+98ifJ+bWT1UpDxyVBb8Vegbs
	XDLDsu3qTbbznXOcS8/SRlUKBVhHci9m2jdnFqeQgyHgk88su/hGU/PSwyxmJMZ8FzLq4uO0ddq
	6t9esGV6Di+cQnoTVjYP3eetXa/1SrWYrA7JlXimLyykwJVqn47RYJByskhjPJ/qsLkBsNHiR5c
	Q9aduKPveNKKgetZH42ARpn1s26ruwHbjl/iO5KEKAvAk/scv934pqk/8+IqSWNNnxQ2Jy91GKU
	TYOnREBuqtzQaZSDEpLGbwcfHWi3Sn0CFihqQHEYoCePwkYrOuGO83kSWRKLYlOvbGqjTR81HCR
	4jxMqDMY60gQIDqp946H0uqMBoF7g==
X-Received: by 2002:a05:6a20:e18a:b0:3dd:a196:ffcf with SMTP id adf61e73a8af0-3e0bd4099abmr6153367637.31.1791205603927;
        Mon, 05 Oct 2026 06:06:43 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6d334dd6sm785236a12.9.2026.10.05.06.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 06:06:42 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: dsahern@kernel.org,
	idosch@nvidia.com,
	horms@verge.net.au,
	ja@ssi.bg,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v6 2/3] ipvs: avoid stack overflow from recursive connection expiration
Date: Mon,  5 Oct 2026 13:06:18 +0000
Message-ID: <766c069e460660b20d405a87444399decceae9c0.1791194172.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791194172.git.zihanx@nebusec.ai>
References: <cover.1791194172.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v6:
  - Rebase the iterative cleanup on ip_vs_conn_del_reference() from
    Julian Anastasov's latest connection-deletion fix.
  - v5 Link: https://lore.kernel.org/all/cover.1790266803.git.zihanx@nebusec.ai/
changes in v5:
  - Rebase the iterative cleanup on Julian Anastasov's v3 fix.
  - v4 Link: https://lore.kernel.org/all/cover.1790146910.git.zihanx@nebusec.ai/
changes in v4:
  - Rebase controller cleanup on the timer-callback deletion fix.
  - v3 Link: https://lore.kernel.org/all/cover.1789877273.git.zihanx@nebusec.ai/
changes in v3:
  - Keep controller cleanup iterative and synchronous.
  - v2 Link: https://lore.kernel.org/all/cover.1789435989.git.zihanx@nebusec.ai/
changes in v2:
  - Replace recursive controller expiration with an iterative path.
  - v1 Link: https://lore.kernel.org/all/cover.1789110326.git.zihanx@nebusec.ai/
 net/netfilter/ipvs/ip_vs_conn.c | 40 ++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 862731c94bce..72fe609bf4ac 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1333,9 +1333,23 @@ static void ip_vs_conn_rcu_free(struct rcu_head *head)
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
@@ -1344,13 +1358,8 @@ static void ip_vs_conn_rcu_free(struct rcu_head *head)
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
@@ -1363,6 +1372,9 @@ static void ip_vs_conn_expire(struct timer_list *t)
 	struct ip_vs_conn *cp = timer_container_of(cp, t, timer);
 	struct netns_ipvs *ipvs = cp->ipvs;
 
+	rcu_read_lock();
+
+repeat:
 	/*
 	 *	do I control anybody?
 	 */
@@ -1372,19 +1384,18 @@ static void ip_vs_conn_expire(struct timer_list *t)
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
@@ -1411,7 +1422,11 @@ static void ip_vs_conn_expire(struct timer_list *t)
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
@@ -1426,6 +1441,9 @@ static void ip_vs_conn_expire(struct timer_list *t)
 		ip_vs_sync_conn(ipvs, cp, sysctl_sync_threshold(ipvs));
 
 	__ip_vs_conn_put_timer(cp);
+
+out:
+	rcu_read_unlock();
 }
 
 /* Modify timer, so that it expires as soon as possible.
-- 
2.43.0

