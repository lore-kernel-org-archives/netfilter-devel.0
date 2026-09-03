Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9D2456E07
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 11:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435268; cv=none; b=BeYoTqRemGkrnkjlptKxivOHbpKel9BvIhgz+j1NKfwWp0wxhTadZZP5+rF2TfPMYoHuD1o8wbXJ1h/5k4wgh/OazP4tMcrFAjdpQ9auuZRUAi30DfWW0dkHFwj/AKouNPIQJifRbG+nbHTiGA9rc8OP+r3PFQ37iLrI8vKv9B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435268; c=relaxed/simple;
	bh=6meo9qp0kth4hf2HNZ1ULB5DNibjZvdgu8j+9qdRZfs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igeqv+y2MLHRhtNIaBRdQjuPHevNBFuQyKoWil0xiy77IjH/zsjb9ERxRRpVP0tO6XfEhsXYVXP7+koOz5JDhq3YMUj48BWtWEY7qpZn6ir+OGSPhjVoSNNPs0yWjYnsp7jXW/ULcvJbUBemno8sSEEQYzR+mJIcflL04GXqIQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vuXn/6WX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vuXn/6WX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788435260;
	bh=NJ5gpC98NblaVPB1Bypzd4TEQoskw8BBPQqonOyLu1E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vuXn/6WXyptovlDMDLKwuQXKFRieeG/esFB1YlNX3jcgq4QZ4vWCOgpB2EPTguTRB
	 qPR3HpKaAJ5RyR+ZopKAbcF0iNpBOMYgwGm6WyFCWj153wDzCXCV9cCwUj/7X5c42r
	 QoE0Mx9IoRylOlaTQXPthxNikbtz6yVI397yldwwxTRBN3MQtM/axZU+kpqrfzV92P
	 V6OuEX3kL56gPY8yGOnTkS4GqQn5om9DOoBjNr3wi3nubELZHpPuqoAoaFWX7an5ZK
	 vsrcuSELJnMScNrXmocJTJFAcL8zUq35Mg9umUlexBm0niY+jZCSgJSMDxH4A6BRCv
	 mhV/Xe4KwMqYQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 991C2607EC
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:34:20 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 4/8] netfilter: synproxy: use GFP_KERNEL_ACCOUNT
Date: Thu,  3 Sep 2026 13:34:09 +0200
Message-ID: <20260903113413.1122606-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903113413.1122606-1-pablo@netfilter.org>
References: <20260903113413.1122606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate template conntrack via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_synproxy_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index acd360515972..9fc959ba2030 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -336,7 +336,7 @@ static int __net_init synproxy_net_init(struct net *net)
 	struct nf_conn *ct;
 	int err = -ENOMEM;
 
-	ct = nf_ct_tmpl_alloc(net, &nf_ct_zone_dflt, GFP_KERNEL);
+	ct = nf_ct_tmpl_alloc(net, &nf_ct_zone_dflt, GFP_KERNEL_ACCOUNT);
 	if (!ct)
 		goto err1;
 
-- 
2.47.3

