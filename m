Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC772920B9;
	Fri, 23 May 2025 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006850; cv=none; b=iTE9EtzagMnehw2uZ/r3LfQ7t75aW23vBhcjNV3dQ+zfEpRqzoCAL0M5wvRj17D2exOpwhlm+SjSp0zPJoqzqvk5R0IXWtDuJl/2LjBgB3//a7RCRCvkp24GNNlG6LmLqHALP4hBRt1HXRxmBOyUWrUup9yUaVJzEEhJItwtXqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006850; c=relaxed/simple;
	bh=mgqTcRk5lDodkOacgm4jt0uZo2sncko0Ps7MvStnnlg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f4wEk8K7GvR620HeZO2Vu68joIgZ0ZvEObH4crnv4/nNASzB3xE4u2U30mt0fOyhvPPYuLlBidNItnyhzykqIlqKK/s5wQqoB2c1OFDsZBzkXFAnS8OnhvvzC6jH0PkgzBoTBeEk6LK0aYSKd9I5o4QERlpg6Dm9cNU7tWVaABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b351QjNO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=juSnSogH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b351QjNO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="juSnSogH"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1BAA06077D; Fri, 23 May 2025 15:27:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006847;
	bh=GNlWsZ+ScZ75VSYxJ+O1kBeOG6IyVu/QjO85aPWEEuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b351QjNO9gg8MJLXnboD8Oik39kUizbi9ZrePkaS8ly6CSU1NP4paDBOEVIDtyfya
	 6wvpr0g7t9vhe+xOCk97Lru0H8GyiS7j9dl3oNz0kJYsnQ+aePvQraB4clbPChtrCA
	 7BTewvXR9v/+n4cIUgl0FoV14Q+jcWB8hUHUofIUw+OtMb7G0yx8uX1XGnBaMLqK8C
	 2WAwNsrHKgMGWv7yldYMyElfkE+ik8Xa+KNP1lk6vKmDNV2DwDBU2tFGKJnK0SMSl9
	 u5rxUQmrFVeXADkhq5JTkes5ZGPLhwU4luFeOayOEBAX1acoM7wmMUv+h7+9pxeZ0V
	 Bcgnv9Qhk8+rQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 243AB60763;
	Fri, 23 May 2025 15:27:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006841;
	bh=GNlWsZ+ScZ75VSYxJ+O1kBeOG6IyVu/QjO85aPWEEuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juSnSogHZSUa4sgv1rq2nLjDgfprQ8WCDS6UtPRdZcMi79VwsIyAvvuNXzpH7ekbP
	 6Tsk/F+WUshXUvTa8JwsQtiUUILwEzMlCeWV3/WtrrPLZqwBgFpzuTcNedrLrF0vxU
	 opFg6VH7Pf/Jn5f9hJLPncjUhi7Oya2c6AC1NK2f3X3wjR7Lw8XX940pzk8YLKxa/0
	 0UdMCqN4KzSDfHkHt0lvDztuN+Cqq0ET2MGwHc+4xeKPel6FX+OltY58OgUPJlTiCF
	 jrGsOUBCA8JPpHxyVhwl11I7JkRCl1ba90Ks43Myn2CABh27dfWuFJdSd5/FKSXFfX
	 7m+pthfjodZJw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 02/26] netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds
Date: Fri, 23 May 2025 15:26:48 +0200
Message-Id: <20250523132712.458507-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Its now possible to build a kernel that has no support for the classic
xtables get/setsockopt interfaces and builtin tables.

In this case, we have CONFIG_IP6_NF_MANGLE=n and
CONFIG_IP_NF_ARPTABLES=n.

For optstript, the ipv6 code is so small that we can enable it if
netfilter ipv6 support exists. For mark, check if either classic
arptables or NFT_ARP_COMPAT is set.

Fixes: a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_TCPOPTSTRIP.c | 4 ++--
 net/netfilter/xt_mark.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 30e99464171b..93f064306901 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -91,7 +91,7 @@ tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	return tcpoptstrip_mangle_packet(skb, par, ip_hdrlen(skb));
 }
 
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static unsigned int
 tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -119,7 +119,7 @@ static struct xt_target tcpoptstrip_tg_reg[] __read_mostly = {
 		.targetsize = sizeof(struct xt_tcpoptstrip_target_info),
 		.me         = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP6_NF_MANGLE)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
 		.name       = "TCPOPTSTRIP",
 		.family     = NFPROTO_IPV6,
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 65b965ca40ea..59b9d04400ca 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -48,7 +48,7 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.targetsize     = sizeof(struct xt_mark_tginfo2),
 		.me             = THIS_MODULE,
 	},
-#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES)
+#if IS_ENABLED(CONFIG_IP_NF_ARPTABLES) || IS_ENABLED(CONFIG_NFT_COMPAT_ARP)
 	{
 		.name           = "MARK",
 		.revision       = 2,
-- 
2.30.2

