Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F1C3F99F2
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 20:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780519256; cv=none; b=rXHvIAbxHfLygAP+n1Ia8TF86NuvW2u7Q18OZ0D0kHVZNLXKUjk7ehlD9UZ4FMXiaKvuvVx8Dsh/xUAPm8omwoOK/gzJVb6CYnx0StmJhdtyZSZkgyOBaEJyNtK3j1E6ugjRcFniLSynyNyjiAaveHYgW4SWNwV3sz7eC3CiUJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780519256; c=relaxed/simple;
	bh=WnYnbWjkSK1JdqfDs9hP7DEkCdYJaxiNS6jWDosV5FQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKsHRFLYoa9nqvxY/2pgq/2AjYwb/JZxEdyKg8k7tCnLmIgoumhy7JB06buJVhXhLi1SwWg2Hd4rLQQIXrhikWgjpwyplR8BtYSZUf6NlnhBAUWhS/a36rPUd6Qz62PG2FYFvTphIvnGc+JibXJkVGfIPUIxdWbr4sc+3PnKAH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XZQMhdhT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XZQMhdhT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4D1486017E
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 22:40:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780519253;
	bh=PIRx6TW/TMijmNv2r06xeNHHUdKtGkZWZA6naAasij4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XZQMhdhTKOOyYcgfjF/YoSLEitam3fWTVuI3JQnuGdfaS6OEFxfqC3rdUlU7RQR9s
	 K1sPk/i9yWI6jU1n8c3hx9eHaQFb8B3czIkK541J2ZY66Q/z2itifeF3tO+FecMfWS
	 O5/6LOHLNq/keADwOEHwsmgfxHh6WZ6AZynQussfAJL9XE6xWjIzEZhrTUaIB7of/s
	 R28aVFnkal+F8+Wt4tc5p3vy2fNi8OZzZ/BSpZt+MDhlJJQXm8i4TsWa2JYgxdFTT0
	 yMQDsaGFDLh3Q/EE5+yRWD4b82U6EK4uOIHK3BlJ0A1CSyPkITUz/R37xP7nj6FzSx
	 IdCHWv0PK8bZw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v4 6/6] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Wed,  3 Jun 2026 22:40:41 +0200
Message-ID: <20260603204041.815863-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260603204041.815863-1-pablo@netfilter.org>
References: <20260603204041.815863-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For GRE flows, validate that the ct master helper (if any) is pptp
before calling nf_ct_gre_keymap_destroy(), so the helper data area
can be accessed safely. Note that only the pptp helper provides a
.destroy callback.

Fixes: e56894356f60 ("netfilter: conntrack: remove l4proto destroy hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: new in this series, reported by AI reviewer.

 net/netfilter/nf_conntrack_core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index bae96b37287e..856cda473a14 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -562,9 +562,23 @@ static void destroy_gre_conntrack(struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CT_PROTO_GRE
 	struct nf_conn *master = ct->master;
+	struct nf_conn_help *help;
+
+	if (!master)
+		return;
+
+	help = nfct_help(master);
+	if (help) {
+		struct nf_conntrack_helper *helper;
 
-	if (master)
-		nf_ct_gre_keymap_destroy(master);
+		rcu_read_lock();
+		helper = rcu_dereference(help->helper);
+		/* Only pptp helper has a destroy callback. */
+		if (helper && helper->destroy)
+			nf_ct_gre_keymap_destroy(master);
+
+		rcu_read_unlock();
+	}
 #endif
 }
 
-- 
2.47.3

