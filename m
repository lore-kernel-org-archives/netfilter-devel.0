Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07662413234
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 17:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777485379; cv=none; b=V16CCXBjX0MG/sOZYjfvbFbl/wYrClriNRC5CMpJvTfB1qA9as8cizvn6OKgPNwyH4b9ag68wTU0JCIkUasRgGcAX6Pw3TUh7jsGC0nzdTgN9eZx4IipUBdsOBVbnOT/GzT8KLcqDdU+iZoJiFId8N4ehMRTFPjVEkFETZHmnP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777485379; c=relaxed/simple;
	bh=hPxaXd3xjy2aLoQlfjNn2TCMZsSvXUAXKxOi1BUCOho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo2V1V8gHAOSietNt2HPKoWQfZUdSriT7TYLipFyLR8+KcMxtITMROlK1EcZcOCO19ksf4uFlMfu61BdA4J/OhntwwZjLEqF3I+Y23va5MlHxhbqzRxE/+HclzwHALfleh9pFwhZcald9Lazhk2uwuxkyhRVJChY6smMJSa1BcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOCqCjDy; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOCqCjDy"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43cfd832155so59306f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 10:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777485376; x=1778090176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+m+c0QFSmHtefs8UGhgSoeILNWZg2rQuDAplxBi5ys=;
        b=cOCqCjDy12B6ro9esSG+onM18Ju1+DNt8/lJj8j5rlGgFor/h5mlDqT3erRDdbA+ES
         gHnNUhRutovnkf/sUDku21JaD+l5b3ZO7HzsvKFyA+v1p8eOYzU+H/FXzPAMhg2ke7yG
         UNeh6nngm5LEjC2jXkbTF3ix0qJV3IHHLcfDQX/YcUUl2BwRkS8XkBfbgD6gMUlnw+ji
         lC5Ht0vquY4rWMH8MPLqKQAS/TYI6O7AFSiq9VyoMmWuzZPY4MDdk5o1k7fLD+0zEts9
         TKqYWefBXPw6owlzPTYACRXr2GBB3VqLj7eitM5b9JV8SJJyPi5S7jhq1CfRZOEhEsBv
         eMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777485376; x=1778090176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m+m+c0QFSmHtefs8UGhgSoeILNWZg2rQuDAplxBi5ys=;
        b=QV3RC+kvGMOhgNRirjuGfWlIa6PKv2iJc4lYp0F+JfYUVI/gWrfbqXRWHm9iqjINc8
         moCZTFNmk+K4XhJS5EjwaPcgd5U27sZgNftsKNnpNBiZX7irmVQ7PCRfQa0bC32NjgCc
         4HjsN6eWnQ34vQ751svLiizo9beCm+4pSU74Gf5vZx6OQuSnPR3Uu2XnmXG24Vxw0ngM
         qZEGGerWxR7a4vrZjuBXiYznGceigRSGqAmk7KVpqZSpiOIZp7+8BipDMn35D52txtS9
         QJVmCmFSvifZrHznkAEYE75OsEAn5ZQW9SUtOQnL4xRzP4elsjC0ZPGnkDYwp71isMzU
         9NLA==
X-Forwarded-Encrypted: i=1; AFNElJ/Oc1OkdX4TmHTCiNk7ylq7tIsryK3HrRGHYAH4wbgoB9HSJKH0XpPUJnuiTVbwTT6w6V276DtKtmn2TNyXn7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbjVS9SCXTkyTKSvo8pnEM+YgNf9VVSdgnb0Su8NwTTSYUGUL5
	ZtJAwmZRt/YA+7knNnOFwbsk8DQMgEt4PvX3noz4pSlnby+2yPBrDxI=
X-Gm-Gg: AeBDiesS4xiUB53ALca6LBpaa9OOwkcqWd4m4dWTQUpD+P+mvqMynQLwJMgu6cz1XDD
	lk7meWAv7KH3q+1c5pDrUcyWaBBH+cN6SKgUm1Os67NtSt8NfjSPKL3jP0XVrkYxlJY1Hm4t51V
	Hw0RC6fcDpoMCxzIzqawjrzftPyrVv4lE3eDp9EvGlawILvxNMlDyIVxhwgYkXIt45bb11708rL
	GcUxPM8xQuZHBRmaOSYjyHOGu6bcmU37UlFGv7CRrTWCphEtkJPq4K3iGuOmAbWoX/7tDPMUzwz
	DvPiAVZ2xBmMdm36eciT4EgjpD55Fo08ymu15M7OmRxnKN1kzLjS/J4TeznSa+hREpXV0+NzGlq
	doRG8mYzP77H3/gZAAAitHiLRD3Ak7RNo1VMiomJ6xu7DLub8z6gjiVs8AITHg5azY33slwarUo
	GVsIXjAtDUhBzQSg==
X-Received: by 2002:a5d:5848:0:b0:441:2473:c30a with SMTP id ffacd0b85a97d-446496d79aemr15475160f8f.31.1777485376333;
        Wed, 29 Apr 2026 10:56:16 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b3d48517sm6183750f8f.5.2026.04.29.10.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 10:56:15 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH 2/2] netfilter: ip6_tables: allocate hook ops before making table visible
Date: Wed, 29 Apr 2026 17:56:12 +0000
Message-ID: <20260429175613.1459342-3-tristmd@gmail.com>
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

ip6t_register_table() first calls xt_register_table() which adds the
table to the per-netns list, making it visible to other code paths. Only
after that does it allocate the per-net copy of hook ops via
kmemdup_array(). This leaves a window where the table is findable via
xt_find_table() but has ops=NULL.

If cleanup_net runs during this window (racing namespace teardown
against lazy table init), ip6t_unregister_table_pre_exit() finds the
table via xt_find_table() and passes the NULL ops pointer to
nf_unregister_net_hooks(), causing a general protection fault when it
dereferences ops[0].pf.

Fix this by allocating the ops array before calling xt_register_table(),
so the table is never visible in the list with a NULL ops pointer.

Fixes: ee177a54413a ("netfilter: ip6_tables: pass table pointer via nf_hook_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/ipv6/netfilter/ip6_tables.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d585ac3c11133..17143277637a5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1754,6 +1754,21 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
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
 		struct ip6t_entry *iter;
@@ -1761,24 +1776,13 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
 			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
+		kfree(ops);
 		return PTR_ERR(new_table);
 	}
 
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

