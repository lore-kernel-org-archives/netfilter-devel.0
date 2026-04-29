Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0A43B961D
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777485379; cv=none; b=SJQc3h1kQJ4/1fydCHUl4H2cfTAKJCJzUq9HipkKeurIjQ/dBAj5UY4OEaBHijiMIuqvb2DTkGCL0EWMBOA1t2PMwLkm1rLjGsULbLdD3JHnfzAoAxrO5PwkrkJhDYjlbNhqJmH7fOqk2/QmYCsRamXlQa9SPufJPbISAilboEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777485379; c=relaxed/simple;
	bh=eDBirYq4pCbL+nEUiEp7cl5+N06I9yeNRMJUvi0dUZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE31Z0K3UsqPV/DKu+zeukwFoMnQkqvzoB5u5pnIPO5eEtSPQp0FP4VtWzmjQS1psLHitm784z2GXVXbnKVdfGWmBFEsG4N5JvtYcB/R1BnID29Uoa5XdqT2DThZRA+0LhE+KSI7E2sTdi0rOpaXYT0/ceCvWQIwMLj1yiNPW5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jYQAlbJM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jYQAlbJM"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-483487335c2so308635e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 10:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777485376; x=1778090176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAVLe7MO2A1MyrDF6a2t4MvPRiDZqS4DmH+U/JOcnYM=;
        b=jYQAlbJMAUmgBX14wyxFlZBhXAKj3S+TKPLSDiohw7yy20edVzYsqczSigBf0J6CcC
         ktDQiI+MWNeYMkIasiq6Qa6I8khKvtNF5t2q33GMs9LFFsuSvZuUIy88OuGlTYUP4IkD
         WPkh/d+tsh2lw6msVv4Q+TiPhfofGlpslXAeSx/2MpTgu6SLSRqstfmuT/4zkVjdmJOL
         FOo889lSGnqyx97fziO/SI+wjyWY2ZOWYsmPwZ9UTjf4w/BYKexvsrhONblzXMIHeHEd
         FmQL/73zTpBwt2H6vWHOIHk9wYs0vqoo7ffG7R2+fu40Cx1svYsuGwplU06b9E4pzZCy
         uO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777485376; x=1778090176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZAVLe7MO2A1MyrDF6a2t4MvPRiDZqS4DmH+U/JOcnYM=;
        b=YzCd9kQ0iqkn0gv+G6kA5rRHPC5KPFkAyI8fXj89NBqlV4QpNLMKlxhmwEOobiZm9M
         uTgjz8W7d+6N/zrp0jOoXY0VB73dm9Bm11wuLeW12oXjMwCINpJ6oXSOBjNZijm0w0XD
         XPeLVkXoSxcOKxUow302BvCfDPWt90fvM+tVc0Eqgy7cTRT7WICSkZFI4rMYyfC4xKds
         2zvvNzhH3FhmJWfp8ks9xx5PaBbxLdg770b56N2qTkKv2v3vxuvmAdVum7bJ8S/r5/4p
         KaUOw/rjJJSg0DbuL1NNmyiZXFBt0Rp0JORIEFDHxlSuvs//CdB5SCaMfFo+VkiXXr+/
         0tyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8RmU5W7F8y1Tdl5jU6+N9imzDUXcrrZMkeYvUmpuX5RiiNHPhR4V2DEV+brbmEsqXNXyJVvVY16hsN9qiONyM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/TlCcQNgRS4f06Ul7s/zuqLOOGAjL1aeec8Bf4T3VEtZhHuQC
	EbiSBrq4kULkxyctpyKLpyuK3LjTJuekHku4gCqEV6BPmVKTQneZy/u1S8Nq
X-Gm-Gg: AeBDietFomk/62++6Imfm7hL7dYjp6TaQQDBvZwDv0YKzyU2P748jyaRRxAOBPSI3zv
	rsiztbu424q/lX+jziievEDI8HXvHHVaJu9kJeyIvu76aBkJ62KCp5N43OEIaq8isHw5MSR4qoL
	uUX/0Ga5fa7OVjJiqIcCg5si0+6L8TrMUcH6LfgXAyKDUVwwMdH2iUR53ZrO+hpyTIIC3yYVrl7
	5LkWRbq9i54tYrgvsMyrUj0w2pndhcTut6oE+OvxFT4yYBnF453ceNS5NoWdSyr2SnwzG1AdHpE
	ye1f8cgEigCnM3Xnsy0Fs3I/8uS+89iEf6NhvzYUGjC+IOkD62HK73E3m3lnBp65hwI2Z9to683
	xbcAjVRVIVhjFzVUlNw9mmuTjvwj8kwY6Nlsaq2wo/5rkEk3qNvFFaxBcSnhSzkT1W70+BPaZox
	EttSM=
X-Received: by 2002:a05:600c:c048:b0:485:39b2:a47c with SMTP id 5b1f17b1804b1-48a77b22dedmr99590625e9.25.1777485375550;
        Wed, 29 Apr 2026 10:56:15 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b3d48517sm6183750f8f.5.2026.04.29.10.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 10:56:14 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH 1/2] netfilter: ip_tables: allocate hook ops before making table visible
Date: Wed, 29 Apr 2026 17:56:11 +0000
Message-ID: <20260429175613.1459342-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429175613.1459342-1-tristmd@gmail.com>
References: <20260429175613.1459342-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

ipt_register_table() adds the table to the per-netns list via
xt_register_table() before allocating the per-netns hook ops copy
via kmemdup_array().  This leaves a window where the table is
visible in the list with ops=NULL.

If cleanup_net() runs during this window (e.g. due to concurrent
netns teardown with failslab-induced allocation failures), the
pre_exit callback finds the table via xt_find_table() and passes
the NULL ops pointer to nf_unregister_net_hooks(), causing a NULL
pointer dereference:

  general protection fault in nf_unregister_net_hooks+0xbc/0x150
  RIP: nf_unregister_net_hooks (net/netfilter/core.c:613)
  Call Trace:
    ipt_unregister_table_pre_exit
    iptable_mangle_net_pre_exit
    ops_pre_exit_list
    cleanup_net

Fix by moving the ops allocation before xt_register_table() so
the table is never in the list without valid ops.

Fixes: ae689334225f ("netfilter: ip_tables: pass table pointer via nf_hook_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/ipv4/netfilter/ip_tables.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 23c8deff8095a..c47bc776eb4f2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1745,6 +1745,21 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		return ret;
 	}
 
+	if (template_ops) {
+		num_ops = hweight32(table->valid_hooks);
+		if (num_ops == 0) {
+			xt_free_table_info(newinfo);
+			return -EINVAL;
+		}
+
+		ops = kmemdup_array(template_ops, num_ops, sizeof(*ops),
+				    GFP_KERNEL);
+		if (!ops) {
+			xt_free_table_info(newinfo);
+			return -ENOMEM;
+		}
+	}
+
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
 		struct ipt_entry *iter;
@@ -1752,27 +1767,13 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
 			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
+		kfree(ops);
 		return PTR_ERR(new_table);
 	}
 
-	/* No template? No need to do anything. This is used by 'nat' table, it registers
-	 * with the nat core instead of the netfilter core.
-	 */
 	if (!template_ops)
 		return 0;
 
-	num_ops = hweight32(table->valid_hooks);
-	if (num_ops == 0) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-
-	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
-	if (!ops) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-
 	for (i = 0; i < num_ops; i++)
 		ops[i].priv = new_table;
 
-- 
2.47.3

