Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3144C378832
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 03:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789185432; cv=none; b=reKh632NPJhnI88sO+pn2KzYJeaAtNWRiB057o1Y7bO7Ag6qh4VEa+nUb/K/2d5q2ahIkrLIQzqU0NxrOZBTo3SQwxLtlnSSKphlggMiA9eg8dHuHQQ5FQlxM0HaA3rCPPR3QsYJmrfDUacx1/v9/yYe5yBnzwzzP3SElT+QzxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789185432; c=relaxed/simple;
	bh=nEYVPwCFDnBCF24sANEBFZ55tkqiF4LKtVf0rB2hQ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfP2LVTEJ/BXo6yyhRb9cZYvsUUL9t9B4+WA0hN81u1gpzxU2jgWSEttFc5xS2dDrB0MhaQB/HDQmzCLFYHfbHm7sTuOC7yAnwNvcrr/vEmNhIhk9GJBZLLp3YO/51kJIy1yUtEEonyw895XBwvmmOUWNdKePO5gmB7oCQwQM00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=fJz+kNp+; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="fJz+kNp+"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso16281295ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 20:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789185430; x=1789790230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFsPOOs+5rcBWfV3FhiHZ78dDluV27U/FXNygCAg6wI=;
        b=fJz+kNp+PQHDjlOwmmBpg5hdejlfojifH1hARbglIneEihYwuIPaVaUtOj2uRd/U4/
         mscD1dKSHaVZWCHHLeh8RBToTvbNo7qdvB1j9zZ+nGmmuyhy3xQuOk62F4c2SDJDVXRj
         fTxOdUlgap2qJAou2q1exUyb/0meghRURtYGyDr+zMAqo44cy7XuUPQCiaaKH3nXbYUP
         lQq/uSoE7iSrwpbx0cyOcq33CboIFqAVjsSPXTsGiAV0l0jZaGBqzXXXtYCYJ0tjkKsr
         CJMmQhvhYCUruOyfRTJPFV887LpPKsMYW2tC3Ic23M4E7n+xi5res8H+UbZLYHzULeCL
         DUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789185430; x=1789790230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gFsPOOs+5rcBWfV3FhiHZ78dDluV27U/FXNygCAg6wI=;
        b=Agi2GMc2dJF0m6AgTRe8I4FWKSdtmXyfzj4OFvokP1tgB6paEdpQLIIvhrfNFKPZVC
         DKz4BWP84zh97QeSiKUxoH8tVbzDCf6tQZ8QvYVWghDZ812EQYYzoYdBKPCN0tw2kD9/
         BLdNcIDyY1xuBqvQ0NmlAnttIj3rd8lmP/6M7dC+IltL0COsMSuZUhxeIzIshBXH0nQp
         diCfS0Ns0CaMKbNOSC9SoU/C1tukHZJB3f4YHwquDGQDqVOi4CEnjyaTY4W29AR+lGUK
         y87vFHwxllzGF9LlO+7uSUg3mU1345hPRk9A3SrkHQ2/wI32PsbRcUZGYgdLnuUBV70/
         VbUw==
X-Forwarded-Encrypted: i=1; AKwUvBwwP/iIZKdCZCyO+li7PubqDnHIKCIJfIU40SO9EYPfiOoh1z0Hw6uM78e7JlZirFrAZooOXcQ0SKIG+bBbpmY=@vger.kernel.org
X-Gm-Message-State: AFuF++kHW48SEcDLN7JW8fBrcgxAVSfa1nharyng+uUgKVsw/TaRcc18
	fU0jMe2fgOqyNlG1XPTyWTcgZyPrZTcRit6tygPeTRMM/8ts0A+pJDHQ6GOLhcrQnWp4
X-Gm-Gg: AYBFou0ICTgX5LvRffJOjY81IxomninkJK37722BgKNBTQH/DHq9OiB6mPAB+eNMUHn
	WjH0wCLb4YOElHFHjYQclaURJq720YAb04fHAkGT0yxWsRJlypHok7NEmETioTqH94XbuHqTa4n
	Xadcpbt8zd7axY6we/tPj/c24q0ifIhUW3OdUWsxlzsCM/QQ5tdbHsfZxnVQfV7WyzDsim8OPWf
	r0BZG1SPOlrwtyL47cjoJ4IrCwsOX5KExtdIlOqYeV1B4Xr+v0BM7DkEuhGvS7rg2jEgIUa42MZ
	KzH/h2vmJWpwrI3IkoB2M+YCMLXTzEbLPmE1q8otGicwRPNcOACNNuXqYgqODrj7sG6KTpExFal
	WDc59VPhxOBTnQ1bEkzL8FrpIxW//m4Owv92S3Q3FZYUtrLjG0GuYJgtAykht3NTDnX7c6T04jv
	qZZLeQbl296lz4BtWQBtKBlcGzVhHoRcNIpwy5qRjf2JcE6zICcgS5iZnn8CxknspdX9J6QG4YS
	8YPCdDVnHPBS8/QhEXd1WNlRi6FHA==
X-Received: by 2002:a17:90b:2b50:b0:380:21b7:e727 with SMTP id 98e67ed59e1d1-39d9c1c199dmr12405499a91.14.1789185430385;
        Fri, 11 Sep 2026 20:57:10 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d95864b4fsm8454407a91.15.2026.09.11.20.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 20:57:09 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: zihanx@nebusec.ai,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH nf 1/1] ipvs: avoid stack overflow from recursive connection expiration
Date: Sat, 12 Sep 2026 03:56:51 +0000
Message-ID: <a127d72fa8bf59646fcd6f856cf63834f7a7c888.1789110326.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789110326.git.zihanx@nebusec.ai>
References: <cover.1789110326.git.zihanx@nebusec.ai>
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

Defer controller expiration to its timer instead of expiring it
synchronously. Set its timeout to zero, expedite its pending timer with
ip_vs_conn_expire_now(), and drop the temporary reference. This preserves
the existing cleanup semantics while limiting cleanup to one controller per
timer callback.

Fixes: f9200a52eedf ("ipvs: avoid expiring many connections from timer")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
 net/netfilter/ipvs/ip_vs_conn.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6fa3e1dc534c3..023c01707d862 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1330,20 +1330,6 @@ static void ip_vs_conn_del(struct ip_vs_conn *cp)
 	}
 }
 
-/* Try to delete connection while holding reference */
-static void ip_vs_conn_del_put(struct ip_vs_conn *cp)
-{
-	if (timer_delete(&cp->timer)) {
-		/* Drop cp->control chain too */
-		if (cp->control)
-			cp->timeout = 0;
-		__ip_vs_conn_put(cp);
-		ip_vs_conn_expire(&cp->timer);
-	} else {
-		__ip_vs_conn_put(cp);
-	}
-}
-
 static void ip_vs_conn_expire(struct timer_list *t)
 {
 	struct ip_vs_conn *cp = timer_container_of(cp, t, timer);
@@ -1372,7 +1358,9 @@ static void ip_vs_conn_expire(struct timer_list *t)
 			    (!(ct->flags & IP_VS_CONN_F_TEMPLATE) ||
 			     !(ct->state & IP_VS_CTPL_S_ASSURED))) {
 				IP_VS_DBG(4, "drop controlling connection\n");
-				ip_vs_conn_del_put(ct);
+				ct->timeout = 0;
+				ip_vs_conn_expire_now(ct);
+				__ip_vs_conn_put(ct);
 			} else if (has_ref) {
 				__ip_vs_conn_put(ct);
 			}
-- 
2.43.0

