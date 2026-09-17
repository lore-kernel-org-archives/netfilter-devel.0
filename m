Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC3390224
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 03:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789614191; cv=none; b=mn+i6vZs1KYmdZsJCS/fzZBwdA9PLQc39EmZQ0f9KzZn91dDxo+V5t48xCH5na+2lbVCh2RkDAJaNqJm6uMOOOgHPl45b1sQ78g2VH00vrFgM+6TCK6dbgd2DXOoB/lOgR5Lg7kNwIW0TiYvvGotBntb8jnf9nJfyDTYWURl8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789614191; c=relaxed/simple;
	bh=m8LxNkR3JjYdnLQmQUxBOKzt4ZAa5DQI7wyelbxomQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDCB5/LNj1p7Qw+3xKC1Q8ZO/7zLIjqKwPES1prlx6bzVhKrKS99RuAtpjxyF5xCBWGfODYiZi6+ox0jUeaszGjaWyT0gvtxIiJW0kr9xt7Si3J/GuIKXSNlbjERe6hC9HfiTAefGWtVQKjB+5sIWJ0GWb1DXIVI/dMHhmCIG5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=BviUxLKQ; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="BviUxLKQ"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f0b25dso3755145ad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 20:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789614186; x=1790218986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=86BxvtSGF7VvPfVtVAdcLjZ1htilmwcxvCG0+eDxXR4=;
        b=BviUxLKQ0vfBR9QOw/teSbzE4olf2QsV8zCK/tPkpZSIUdzl5O9Jjp9i8TyfDSiKn4
         8djg2U3dXX/m9jLfEMrc90lzgYQy4cgI6ZK0PaZJRGhEG9LaDYpHZo7nBAnw7ZZaJyYB
         CgxIJdvPF1yZtdvDu7PdlLRtbVExK9wBq2DtOPBPLT2HazlmslWo7r4Pu21S8Sg2OHPY
         z7uOMV0aiDvNZizORjRzNNB8CdLQJULsCURtWeKRkcA5vjUpaKO4J7GYb+XYXq/h0ItR
         Q7TVi2+E15ja3MFxpXMD4OqpUWqUFJmqkHyNH/pM3IqNW08ZSrtMEUo60bIB/DMx7CXP
         O4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789614186; x=1790218986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=86BxvtSGF7VvPfVtVAdcLjZ1htilmwcxvCG0+eDxXR4=;
        b=mh++xxlo/lQ3Rso7YdxF/1DmMNBE8PVMvl2uZGsZVp/bdHRsYR14M+RSZRdMCiwAM8
         UuM0++gVQM3yaBb7THI7kLRCobfEi0+Bm0AUcgjUUMB7ZlBaJFohAbk9LIHwphTVSuv6
         LHboNTKW0CDd6vVM2Qo8iUpiJ8SUpACZYlBD9mSFNUMNUTFm0/0PgppaMZLQPkyTOmjh
         IvUk4mLCFkWV+NXC/vDT6+gng3lMefg9Bnxb+6jC80fx9Ly8Ob4Kns+QZlTDHQ4TYUMm
         XAM1dsnefW9W6FD5OxJbP+qtNT7PNCrrYJC0d3J5tF8B/fZN7h+3H4h3D0zNpxqUKtYX
         m6RA==
X-Forwarded-Encrypted: i=1; AKwUvBzoqx7N/eAhMSQ9mXnTGWZIQfzDJ/Hs9xbqNmOoMGRHbx7ViA2rgSGD5Jf+GmIqK8AP4LEZqsM+8/Sayk/B5eQ=@vger.kernel.org
X-Gm-Message-State: AFuF++lKk47LykfPjSBzmKEK3ZHTw+j18iaglXmow1ZN32QG2A7pCWmA
	30ZnQEGhvLJahHa3IbRfPi6VrTOdjZb3Yls46Ms5ujX6Y9prWT4f3vy2osghjEitg/ga
X-Gm-Gg: AYBFou06VvOGgGBog5cvBP5KdCPH+mgdoEaBBhQFVSi1ezU0sAlF+DFY0znR/o1SQ51
	xtrZHJ0zEo5AsH5EA3/iHKgorbER4hNtjVh4e195hn4TGibDYTKPu3NURIQ50pFqR0h3mAAUP2H
	nG03Ui+gZMt9B5fsNOlvHiRGOFT5wm1O8MggJZhHmYOj0FmplV+6tzHc5tgjMvFC/IxaIvI/SLI
	qRR7+tpLUS/d2ncDyBJ3wQY4phyZYGRHn3fd/oI83fDDjXpwt8NlAr7n92+N/LOBlXG+TRL2HUn
	86oUFxCNkDaOoFo5TKzaWYF24l9ZyPHak1iub+ezRN0FEjmu7jPd4kMSr1OJFrgiTCam1aSDUEe
	qbp4VBw7PNKwaDsK7vkggXrvl+F5IMAOGaP1m0uTf3IDZbcS1Ie1Lle+sHAZqDzha8FhVp8lxgU
	1WvQNmnMLTnt4yIkM8uPO7n2A3t99/po1JHhFTVp/Xan4K7wxcCrmA9YmDHJf/+CbNqZxiddOEO
	n4iq8PFt1kOkwWTqCX9Rp0yaNhf/w6eHvfB7NtA
X-Received: by 2002:a17:903:19cc:b0:2bf:dd0:c8b1 with SMTP id d9443c01a7336-2dd8cc71b12mr120167965ad.0.1789614186089;
        Wed, 16 Sep 2026 20:03:06 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f1b862sm19167845ad.71.2026.09.16.20.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:03:04 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Zihan Xi <zihanx@nebusec.ai>
Subject: [PATCH net v2 1/2] ipvs: avoid stack overflow from recursive connection expiration
Date: Thu, 17 Sep 2026 03:02:51 +0000
Message-ID: <20260917030301.5502-1-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789435989.git.zihanx@nebusec.ai>
References: <cover.1789435989.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a controlled IPVS connection expires, its controller may be expired
synchronously if it has no remaining controlled connections. A chain of
controlled connections can then cause recursive calls to
ip_vs_conn_expire() and exhaust the kernel stack during namespace cleanup.

Make ip_vs_conn_del_put() report whether it deleted the controller timer.
When it succeeds, continue expiration with the controller instead of
calling ip_vs_conn_expire() recursively. This keeps chain cleanup
synchronous while using one stack frame for the whole chain.

Fixes: f9200a52eedf ("ipvs: avoid expiring many connections from timer")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Use a repeat path for controller cleanup so expiration stays
    synchronous without recursive calls or extra timer ticks.
  - v1 Link:
    https://lore.kernel.org/all/cover.1789110326.git.zihanx@nebusec.ai/

 net/netfilter/ipvs/ip_vs_conn.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6fa3e1dc534c3..c7b88ce1765dc 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1331,17 +1331,18 @@ static void ip_vs_conn_del(struct ip_vs_conn *cp)
 }
 
 /* Try to delete connection while holding reference */
-static void ip_vs_conn_del_put(struct ip_vs_conn *cp)
+static bool ip_vs_conn_del_put(struct ip_vs_conn *cp)
 {
 	if (timer_delete(&cp->timer)) {
 		/* Drop cp->control chain too */
 		if (cp->control)
 			cp->timeout = 0;
 		__ip_vs_conn_put(cp);
-		ip_vs_conn_expire(&cp->timer);
-	} else {
-		__ip_vs_conn_put(cp);
+		return true;
 	}
+
+	__ip_vs_conn_put(cp);
+	return false;
 }
 
 static void ip_vs_conn_expire(struct timer_list *t)
@@ -1349,6 +1350,7 @@ static void ip_vs_conn_expire(struct timer_list *t)
 	struct ip_vs_conn *cp = timer_container_of(cp, t, timer);
 	struct netns_ipvs *ipvs = cp->ipvs;
 
+repeat:
 	/*
 	 *	do I control anybody?
 	 */
@@ -1358,6 +1360,7 @@ static void ip_vs_conn_expire(struct timer_list *t)
 	/* Unlink conn if not referenced anymore */
 	if (likely(ip_vs_conn_unlink(cp))) {
 		struct ip_vs_conn *ct = cp->control;
+		bool next = false;
 
 		/* delete the timer if it is activated by other users */
 		timer_delete(&cp->timer);
@@ -1372,7 +1375,7 @@ static void ip_vs_conn_expire(struct timer_list *t)
 			    (!(ct->flags & IP_VS_CONN_F_TEMPLATE) ||
 			     !(ct->state & IP_VS_CTPL_S_ASSURED))) {
 				IP_VS_DBG(4, "drop controlling connection\n");
-				ip_vs_conn_del_put(ct);
+				next = ip_vs_conn_del_put(ct);
 			} else if (has_ref) {
 				__ip_vs_conn_put(ct);
 			}
@@ -1402,6 +1405,10 @@ static void ip_vs_conn_expire(struct timer_list *t)
 		else
 			call_rcu(&cp->rcu_head, ip_vs_conn_rcu_free);
 		atomic_dec(&ipvs->conn_count);
+		if (next) {
+			cp = ct;
+			goto repeat;
+		}
 		return;
 	}
 
-- 
2.43.0

