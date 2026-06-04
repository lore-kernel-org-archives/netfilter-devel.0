Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A4A3D6CCD
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 06:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780554089; cv=none; b=Sy3N/Hvvz+cfhfZHHvbo0mADOZFF2ExvyetC//pNe9YhFsqbMldG3V3/mJBMpLpu2xa9wFGiUmPdIuBQOPbxEOQb646At4WDZy4BpWR33QtZqHgzsfdI7mQZew6jatIpkNocTH/RkAlm3rnTdTRGfmWGChP2QD9AtcVX9Aju+Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780554089; c=relaxed/simple;
	bh=QjWqEpYuCHa78eGbhw/ERhlgPRdIZOXJ7CGixLYYaVw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKF9swNvptQtEz+uupLzwAZXw3Ea5eJQ2UzeZOkpu6ZARVnCLAW8VTlRruc2vvHR+x+wR5WT47RuwNVAecZnisPcz7nbpsYJpVcDDb+8gDIpYRh94zi6JpxPXrHJVidqOaqK+IxZmFGSlxWFZhjduj9MrFSJEYrEFFDjR+YsyJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ObYQbwT8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ObYQbwT8"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A071B6019B
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 08:21:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780554086;
	bh=LoZCsN9XsVupK8Jm7QIoy4Hp1kzyerE7WyNxhLKp6Gg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ObYQbwT8pkNFQ4fEaa/6YtPl7e0dblzpf0Wlhp5JSow30Uq8XpuIlhBmOdDSfTkSm
	 oSRivY1t4AEW0kpbDoBzHEcghaP+wo6+j5cdgYhtk+BW4lvj09mK4Mc+dU9MFzbPVi
	 k7mT8xkr9z8Opf+sJI2Wo2h7Jk7MeBhAOIN/G7REnyHsy4O5XlQyVLqIBasMo9JixM
	 QwTPLHb/tTstQEJO93AiiBA4hiCUFBcQqNzRXyvmrLN3+5K/gpo+/8eDXlJUG5WWUY
	 YCBqA2mJQNionx9q+SAO308K+MSJVK2QeCZ/trMNZMXRGHmoKmxXs9I8Dey1pnYe/i
	 t+IJHJeco1aEw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 6/7] netfilter: conntrack: call nf_ct_gre_keymap_destroy() if master helper is pptp
Date: Thu,  4 Jun 2026 08:21:13 +0200
Message-ID: <20260604062114.832273-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604062114.832273-1-pablo@netfilter.org>
References: <20260604062114.832273-1-pablo@netfilter.org>
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
v5: no changes

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

