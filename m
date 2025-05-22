Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ECE29AAE9;
	Thu, 22 May 2025 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932782; cv=none; b=ShV3rC92YgvH4phFUdEmxhXYkSoKeMHLu4roJAe+/6q8nmZqTReyc3dgvahNE9pzGkdvNpVD/t/Y8qKLLDdHjE1dz9RB5uMaJ8M6kU5eXWLbUqi8jBXdk0a4YI2ssJdoI0UJi34yoG9i2D4Bkm5cnv/E9dknBwM72FMZN5pOEOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932782; c=relaxed/simple;
	bh=mgqTcRk5lDodkOacgm4jt0uZo2sncko0Ps7MvStnnlg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MLMszKBC5aGTL5w40hx1M5caP2KXUoV+b6gFJiM9aeZPQmVqwX0OfmovG14sUN1eR2HfcFTOuVqAJ5wt9pPd9B6hicDBJj2I+j3WedSs8qodWyUiNUVZDZFrPvMy4qm79dyVThDDYLfdx9hXtXuO7fn8JoYPj0O4oIeUC7Y0bGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L7caK4Wa; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZTUqGCl9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L7caK4Wa";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZTUqGCl9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AE5706073E; Thu, 22 May 2025 18:52:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932773;
	bh=GNlWsZ+ScZ75VSYxJ+O1kBeOG6IyVu/QjO85aPWEEuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7caK4Wa34SmAxgjZLH2bANYf4f5L+9/Xf5kDbuSroPZDuTlK9ZAiXw7+sMPWXfEP
	 414Mzvhux9+UNx8Tih9tIRgv0lWLV+xdHuYkE0dY0rzxdNj4s1ef7sZmhAWZbooEdz
	 Fz3CUcL7o8F6NcBe+N6N9CiXLoUgCK6/1LEa8qnlzc2u3viNpsgfb14GGCZW1k6Ksj
	 ruppxA5QOFlH6ro9d12ZG+tfLvM63ZUiVY3AIag1Ua4KIOPTGX44UMIZW18DxDv0aF
	 msbifOXoB8g/NVRK8mbiziL1KNpdvTLUL6f83hNCzbI9jF01QH+j7VCK4bboc10aZT
	 +O0cAW8tKsuOA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E8EF36071E;
	Thu, 22 May 2025 18:52:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932768;
	bh=GNlWsZ+ScZ75VSYxJ+O1kBeOG6IyVu/QjO85aPWEEuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTUqGCl92xp4C+JjB5gIJ2R561x5EtwV2CvJEWNnU0lXqy27gOpLLFrtnFqp7UCXs
	 6YvV1MyO9v0SSLBryq9fVm7bgEhS8NTeFyPqg9Kk+pmn2WSGRcjNDdOHUXhFWI6nDd
	 N/E+VVCKb67hnfN10JIBRqNC/hQwQlYyf7xjotoSsmwtUQXO9MFc7wT4sWnQsfrohm
	 +xSnZuXawCQHuoNU64JJ8JzAHNktPkwyaJ/Z+aOn4VdGXhh819AyUMOkR6/7jf+dvH
	 AOj1xtqomFMm0byESIQkh7hrYCoCYJyN2JWK42uUlaajYbFvm2id4RP3yKa488UQ97
	 TPIMee6ym482g==
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
Date: Thu, 22 May 2025 18:52:14 +0200
Message-Id: <20250522165238.378456-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
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

