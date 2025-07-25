Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C641A2F0044;
	Fri, 25 Jul 2025 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463050; cv=none; b=YbMrMwYemn9QAXrMmR6Rl9CDYSmNxpbBLPjrBJZ0b4dEUbzfVlPwt4RsR6CQrBEMJl8OzVO4zSdhOXPeJwZ4jo3rcGCaoctwLN5wXTbyKJDa540xeXvKhyDJ94E31F6sUSmI9/hGHdcLHK6ned7scEG7r5yzh5E5C7EoXXR5vUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463050; c=relaxed/simple;
	bh=CrdJw1btgrhbLsuvQPlFEttEavzxZ36FG7w1rD5QzE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sBzTNBBDQcozJuPN5GPyiFC35s+lBAs6lM/lc7MEWW0gdWm5sCvrUKUphBgKyNsMIAiu1ZX+bZjbybCpBPrTQ5GZYnBMyimK/9VzTYS8CxVv3I/XDrfqBbToNOLw7YUkTcbzVvAznXngjrmB6JDXDKAY/s7k8meeEADhz7kRcK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tVjscfZf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f6nEgTi1; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tVjscfZf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f6nEgTi1"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3945F60278; Fri, 25 Jul 2025 19:04:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463047;
	bh=8Mzn8QbaLMBR6gr7taomQoVtkj/UE/Qhsi5nhKnhzks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVjscfZf59kmZQtiClC5kxjFR+caclTocNEUim5AqxZVWvNsgUctVyiSFzzB1wUoU
	 hBSflHDRYsk607rxE6wmwF4EP6LneLXyc7h4nXV065EnPjrIyLRMyny2LM9d6J3p2O
	 yiYX4JuRrYR1jrAGf95DBfgdItg+ge6jdPJA8a7wIjZ9HeLmDS4qBLEEuukOV8mj7F
	 2rpMrEQ3Aq71eeiCyPXmNQexOl/zirKkPTtX/OAvYlMnsQcyqQ8nBDioAlUEroX3bO
	 msgX6gJ/bCya3WAGOHw55GUWkq5hjTbXmb5hIjSeu67/Rn/GCk8BSzLrr7m+47a0VR
	 uw9gImslKo+3A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DAFCF6026F;
	Fri, 25 Jul 2025 19:04:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463043;
	bh=8Mzn8QbaLMBR6gr7taomQoVtkj/UE/Qhsi5nhKnhzks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6nEgTi1I5MdV0WYkV04NDOK66Pr3OLDXDaz92iYCH7tcovhUPVXKPY4Q2s3hk4wg
	 6AksOht5CEAQJA3AJY0i/yy3K0wvefw02BMjUDVjemSB4eTgP7dqi0UlEFRqXPZhgZ
	 62/zbLhm7l1bMFHN4Q+9IqSbbSj80JFFbIOF/eKS2sZ6U1VdlcjsltZyp0Xqt4/2mA
	 5oQfxBZjK5U0iInjmtYnXxdC8Zb8Tv3WoEgAQoSH/Ntb3sU81y0TIEP+cWiD7pyFLm
	 4TssBFHHMsvVGz/0jQzBHbhQBnyESPokhlaZ4KQiWKtrHINCypKVE7SGTq+Dt+yFx/
	 cVv/3AyWi9NCQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 09/19] ipvs: Rename del_timer in comment in ip_vs_conn_expire_now()
Date: Fri, 25 Jul 2025 19:03:30 +0200
Message-Id: <20250725170340.21327-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WangYuli <wangyuli@uniontech.com>

Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
switched del_timer to timer_delete, but did not modify the comment for
ip_vs_conn_expire_now(). Now fix it.

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 44b2ad695c15..965f3c8e5089 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -926,7 +926,7 @@ static void ip_vs_conn_expire(struct timer_list *t)
 void ip_vs_conn_expire_now(struct ip_vs_conn *cp)
 {
 	/* Using mod_timer_pending will ensure the timer is not
-	 * modified after the final del_timer in ip_vs_conn_expire.
+	 * modified after the final timer_delete in ip_vs_conn_expire.
 	 */
 	if (timer_pending(&cp->timer) &&
 	    time_after(cp->timer.expires, jiffies))
-- 
2.30.2

