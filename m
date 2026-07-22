Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DF3420E89;
	Wed, 22 Jul 2026 21:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754890; cv=none; b=SBw1/sEivpRfGCETo68B/ycXNnqKf18JS/EVufFX5qlGTqcOCvueSeg49J/W9UVUCT+TPacCvSis+4x0sMwzspgx9ds7I7A61jB+bR14LLURwIoBTGnYc+ngxXxSptj6qMDt2mxCNVnHid2/wJTwzeprxPjpcUDf1JOMQlPgE84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754890; c=relaxed/simple;
	bh=Yp8cNqYd17Jb/kBRxFFBwlf9eVaWwTXzX/nahnjLd28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp6CKxvDwhvMiXsOyEWUS37zt3yNH93wevvkXSTRd50/5+CGK1A9PPH/3lsr0fVewNrtlde3U8h1HdsUmgDQL9HQfIUjZxPxzvvEpwZNz9+XWuPYcaKqrO4Xh+cv4gEEUdH+8CenqQmr6nao1vfivEFrjlOrqNVAHPc0ToC+ce8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ORnMUTQ1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ORnMUTQ1"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8DB2F60193;
	Wed, 22 Jul 2026 23:14:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754884;
	bh=SJrk/1yGa8UKL6VEcejLUHbbfnxEEXZzE5ArnLEiLF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORnMUTQ1Mmsx1z63HYds0ZYyMsUOp4bx2xX/0PdVSv9m75RGosQrBgS/i3DVJJq5/
	 KivUKEzHgNYVfdvieSxINEaxLnPsJYo6BCarGFTjcadRPKVjxF3GHtat2FEx/7AJcz
	 uCGBrrLRT43Mhtv46pGpb1wLejNHuPQ9scEsK/S7imPEoJaYBt4ufWacWPJHbumcPZ
	 8VgFOsBFIBNXGTIU+mlnGeuyK2Yfi/81JetUpws2tjX6xe9uWYm81SRfn/OxDAYluP
	 JMxcBDnqcKrVRhfyDJ0LHh4DebwXztrp/UhBoAEmaRftiSkl2Dr3NYTTjiNve6BrQ8
	 cgyK+FyV9U54w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/13] ipvs: clear the nfct flag under lock
Date: Wed, 22 Jul 2026 23:14:19 +0200
Message-ID: <20260722211420.153933-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211420.153933-1-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko warns that cp->flags should be changed under cp->lock

Fixes: 35dfb013149f ("ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1")
Fixes: f0a5e4d7a594 ("ipvs: allow connection reuse for unconfirmed conntrack")
Link: https://sashiko.dev/#/patchset/CALMqdkR704S2BG_QD_bgHTFp2%2B1QCi7n0T4zoZyTo8mDZevYSA%40mail.gmail.com
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 7efa209a517b..6b79e0c4d9e2 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2194,8 +2194,11 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 		}
 
 		if (resched) {
-			if (!old_ct)
+			if (!old_ct) {
+				spin_lock_bh(&cp->lock);
 				cp->flags &= ~IP_VS_CONN_F_NFCT;
+				spin_unlock_bh(&cp->lock);
+			}
 			if (!atomic_read(&cp->n_control))
 				ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
@@ -2211,8 +2214,11 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 		if (sysctl_expire_nodest_conn(ipvs)) {
 			bool old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 
-			if (!old_ct)
+			if (!old_ct) {
+				spin_lock_bh(&cp->lock);
 				cp->flags &= ~IP_VS_CONN_F_NFCT;
+				spin_unlock_bh(&cp->lock);
+			}
 
 			ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
-- 
2.47.3

