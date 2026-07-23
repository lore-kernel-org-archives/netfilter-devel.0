Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D20F370AF1;
	Thu, 23 Jul 2026 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824794; cv=none; b=u7zL0lOZQEAQnRfZcbb9du9afEpXNSaNKcaEC3k0zVZi9q30amDjHtyOTrRGMwAo409BKZJlx0durl/FXN5vWFY1iLS/8uBj3bTT3REHPYtG3KACPFkn1kLhOTY9ZX1wDXOxVR4o1topYuYUXu3sA+Lyb5z+TI3a+zjBgXYAq/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824794; c=relaxed/simple;
	bh=Yp8cNqYd17Jb/kBRxFFBwlf9eVaWwTXzX/nahnjLd28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooYsF44/LP40/d3mxMdGeL5Uudp9TL5sNNY3VUCWhMx+6Rf9+SEjqqaDsTYzogeIfaG7s4/ULXsFg/6y4bjcd+PGymsBqmkTTPiJkouduzFDFZHTlLHYcMzj0S3WSPxrCo3kkSuV0NngrXj6OW3y02MTXaLquFND3UXnmlLjsMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=talq+/bd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="talq+/bd"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BCD34601C5;
	Thu, 23 Jul 2026 18:39:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824784;
	bh=SJrk/1yGa8UKL6VEcejLUHbbfnxEEXZzE5ArnLEiLF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=talq+/bdehpCk2U1FcGQoauf7V5CehO12RYa27GBrTYSYHTAk+KjJnyhG3PSqq+Li
	 m1zstqOWu6vEXamwuc8tFbCc1SysmHh3yg1wi6KCbhYkU6yOCgnYo9WN6TWNWelJOq
	 60lCSTIcvb5P8/Cn1Gmv+WANfPm6WEJm3nd6kwssvVD5rqUcrzs6/yzBa9BepKGWYt
	 fjFYZAxpX87SzakVz2BprLRgdP2uONu8ShESWvBuQ5Zi37YH8yO+jnBIJzQk+QPdML
	 aAbNz4wyW1NF9PGrHGSp7VtKbhJFPw4e4XunHp04r3hdHzXpGKswZJWu2BK6TignTf
	 zoebJy1fjgSJg==
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
Date: Thu, 23 Jul 2026 18:39:09 +0200
Message-ID: <20260723163910.274695-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723163910.274695-1-pablo@netfilter.org>
References: <20260723163910.274695-1-pablo@netfilter.org>
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

