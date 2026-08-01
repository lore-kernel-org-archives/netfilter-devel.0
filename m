Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C81D2E1F06
	for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2026 12:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785586225; cv=none; b=i98r6/+U6Vzcr7CoR695YpumBvrPDy8OoBrlLr2A0pBa0yBFrA2tyJ+1Imqqu1buf00DpeXewFvZ9QsIjJ7df1AjqN5MjvU9KNi+kw+cESSD0fgyVJd8Sh/hGU0vDIfLTpUhzury6MHD8CSfA9LyEujGYAeN8v6N+yHOj0GMmVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785586225; c=relaxed/simple;
	bh=0a/DfPW/J2eWS7Zjbpr4bCkkZmoeuxFertNvWeQC7mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBAvMiLE7wLdMYqRqwCkThvUCsda/k5R7RvNNmPd9cbZjEqg1VBOEcIlImZjAev2p9M9RTyFcQ6trWuBdxURizWKDsLvu9u3G+AKrYMbvT6bewjGiPWhdhNeQwb7yAMTd97Q4esSx5D+cBg4CWrFT00xJUI6F0zW+vaF5mimlXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=MbsK0abv; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="MbsK0abv"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8486672f03cso2242623b3a.0
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Aug 2026 05:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785586223; x=1786191023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vJnhj6aPy3l3k5O+WJ6a/1glwK3p1ECA3qtJY2n81/s=;
        b=MbsK0abvf1vh5ohX+oVszaUndUiUx/ZFHzxgt1YeUn/LirnQtxCfbyZirXQQbQFn51
         niGs//ShvSduq9b7GmUjOajdxdHBiKx+2EYDw6h0BhPGbuTaPPeTCWCXzxOmkGV7CZTL
         q+kKVVYjTgExAxS1+IJFRJwdQ1G4H2vUjnLizE3yFEXUjkH3HjqJolTMT83xsKwrxIym
         SnWY15L/DXIMyx4JDyuCdb4d4YpyQw0+B+OXV/40pw8fK5r6VwOWf1PrHAMCsTfaGovC
         GrwiGDSD3WQRWZCHm/pbi+hqZw6ff+HvnMUdVdffTPENdQsiwzEmbKGKiQ2LDSnz7V23
         eZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785586223; x=1786191023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vJnhj6aPy3l3k5O+WJ6a/1glwK3p1ECA3qtJY2n81/s=;
        b=RycTqrKZjd+X6p894wAF67ANutDVPSk6J8y0BIcnA6ANUZlL8yqLme6bknnDFx50hp
         uZOY4dL0r3t5730jZYf09Z+DJeYGNgzRppJfGyqYoWRY0TSG1Ccx2tLSct0pzW33cAbY
         /Db1r+KK9Xv01Xm10wh5lbeIN6F8yyoOkebCzt/xIprccduUFiUFTQxP1NOY416cFN31
         bdWGb4h/uePDbcyuHESrptwhX9FQe0O0mnmovg4DPrW+QojqThyIdjcbD16SkzaLtqp3
         c6SmKcpfomnnrqwY35pBratGUktFT4C0qoXmhCZYR3Z4OSgwrRggTlXnwR6ivxcQSMO2
         8ASA==
X-Gm-Message-State: AOJu0Yzu4/9ZjYQpAvEoItw2VhEhSkunePEeZgToRMDN3jodh3Qsh+zN
	shf2+ORPC51kF1ObUv647Kf8v9WVT2aSXASfORSdoMNhTtifw78qZFtW7H80VhMaiR82EivBQs0
	XJRvTJ5FowUJgaw==
X-Gm-Gg: AR+sD10lsKD4P55FZRXxi4CHyPHEOaCOso720zRGtMIWdKumW35Ye8ekZ51g/jWhzwN
	w5JBbkeAHtg3TpoIVp2B3vOhV/Y/5YQ5PdR5M7duT5t+QVSSn3/rpjzFh9D0g5hq7XzlKXHV95S
	gn8kcGeJseiX0tfSRKnk0UpLe08hZjHF78rOQQbEh1VUbJAK0QM5ZeZdWWzn4Mm7XKsrRUsHU+O
	rUZDzkhzVbEj+Ben/9q8Ivo+xvRe96NYnJA+avDEKMvEgsXm+UPIjJfl/YrJv/2e9yJvadikblg
	q4D2HYsNgU2v+VTVjYfddGFmeAu2lkILWXW7kwujYzJiVVJYpwErrQ+Wu3xauprnycdomw+Tys4
	BsNKqCKXW0IEvswz6hdz0+cMZgqdLQXu6+UL+RAqvvfmw2R+dpdtioAAoWW63ie2ZmaFuELLGac
	Gl5/JQnFsBHJwQCjP2MFM9QWviMsdp4bnU0QoC0Q2H5jewdWWsB1gtBfPSAN4wEP3BUDd06IcSn
	A==
X-Received: by 2002:a05:6a00:f07:b0:848:2f7a:2e5b with SMTP id d2e1a72fcca58-84ee4998d54mr2831093b3a.74.1785586223409;
        Sat, 01 Aug 2026 05:10:23 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d45e5sm1580587b3a.42.2026.08.01.05.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 05:10:21 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	kadlec@netfilter.org,
	den@openvz.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	xmei5@asu.edu,
	kees@kernel.org,
	sbrivio@redhat.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: ipset: serialize kernel-side put-byindex with swap
Date: Sat,  1 Aug 2026 20:10:02 +0800
Message-ID: <df40376603e2a53a311d5ceea63240bedc11bdfc.1785583673.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785583673.git.zhilinz@nebusec.ai>
References: <cover.1785583673.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

list:set garbage collection drops member set references through
ip_set_put_byindex(), which resolves inst->ip_set_list[index] before
__ip_set_put() takes ip_set_ref_lock. ip_set_swap() swaps both the set
pointers and the corresponding refcounts while holding that same lock.

If garbage collection looks up the old set pointer for an index and then
loses the lock race to ip_set_swap(), it decrements the old object after
its refcount has already been swapped away. This can trigger BUG_ON(ref
== 0) when the other set had no references, or otherwise under-reference
a set that is still reachable through the swapped index.

Fix this by holding ip_set_ref_lock across the kernel-side lookup and
refcount decrement. This keeps ip_set_put_byindex() paired with the same
set/ref state that ip_set_swap() publishes, without changing normal
list:set deletion or swap behaviour.

Fixes: 439cd39ea136 ("netfilter: ipset: list:set: Decrease refcount synchronously on deletion and replace")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/netfilter/ipset/ip_set_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6cfad152d7d1b..2d3c8586e6445 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -855,9 +855,16 @@ __ip_set_put_byindex(struct ip_set_net *inst, ip_set_id_t index)
 	struct ip_set *set;
 
 	rcu_read_lock();
+	/* Serialize the list lookup with ip_set_swap(), which swaps both
+	 * ip_set_list[] entries and set->ref under ip_set_ref_lock.
+	 */
+	write_lock_bh(&ip_set_ref_lock);
 	set = rcu_dereference(inst->ip_set_list)[index];
-	if (set)
-		__ip_set_put(set);
+	if (set) {
+		BUG_ON(set->ref == 0);
+		set->ref--;
+	}
+	write_unlock_bh(&ip_set_ref_lock);
 	rcu_read_unlock();
 }
 
-- 
2.43.0

