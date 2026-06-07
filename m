Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAF1388E62;
	Sun,  7 Jun 2026 09:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825826; cv=none; b=n+YZbWYB7pRgT4JPqBc7RnO6dFWd1fd0CdG1CzO2EIHZ7YbBWJuqH5sy/mTGOnhQ6XpvHH2bA4Bb0GSuDmgC4zAS0uSa2bY9/BcZ9wDpprRaUKX6D94V3//9RBEe688repXB7YtnCcDdrHYANWhr0sDbizeMpxmAWOIXzg/O0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825826; c=relaxed/simple;
	bh=M/czNa8HGYVZyEe8C51U0n+rfm7apoaLg8+eM7ZK6fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLwIfvUt4TAf6WW5VK5/yNVWiFaxZt+ROXQkYSmIVO0HuuGyWKdxwI0oclHkfmdqHiubk2JlkhO6qx6H1fF2J389UomgRnZf/OeMtzAG4zEY2ENkS2phkBS2/qIcVvny51LGZJ8HeJZ9f0pg70IZC5qrjaiX0ShUTpooFXCoVsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jebUclfP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jebUclfP"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AAE206019F;
	Sun,  7 Jun 2026 11:50:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825824;
	bh=BVo/yxnmQIhuAgR37LRtTUZXXFK91WquKdgqp4RNLwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jebUclfPiP/4iHLUDZcpyr/CYSrPvxtbWXshuZkilQl2JCgQLJZQdEdc4CDzL6Lxx
	 zPZLTrV/GKm/4KOyEqMCizC19bwGa81dWoxqicAtYtDMWORWUI3rtplj+6FyA6myut
	 ZF2KF/vj6NrbI6FJuj5U6qplAzQafUznR2fY18sS8ynyy0IDvSHKj7vnwGwEfpZdYf
	 kNS/M4OsvQBhSU8hhx0tyXOzvshh2Hpet8be6gbiCw55QG6cRaoKSshQH1zvdoUOTo
	 151RNOWwmIx/PPOdvI4DXcJ6z+zL7gCF3Gdg+WRX3gnPElb2osZAbudH5cSw4g4b1z
	 p5rP/+ixYqTcQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 13/15] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Sun,  7 Jun 2026 11:49:52 +0200
Message-ID: <20260607094954.48892-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
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
 net/netfilter/nf_conntrack_core.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 91255fd3b35d..4fb3a2d18631 100644
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

