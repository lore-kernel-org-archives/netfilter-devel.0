Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE298A32
	for <netfilter-devel@vger.kernel.org>; Fri, 16 May 2025 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747398050; cv=none; b=Y+yhPQkfv66c1fL68GaQF6yEJ/poRZHs6JUONGdg8bGke8MnCwXB6eh7YPxbFp8ZzwaQEfCK9ZNxW8HD+TtWPllw7/Umk7nz3RzWLb/9sGUMgmP03i7LneXHL0Zp5RQxSV+hfqRRMQqW17ita3J5U527T/hYko1+OiurywcRw9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747398050; c=relaxed/simple;
	bh=E8sZWvIBYUKZFnPnLGsrxAy1VTz+E246cU0788EF4Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q2XCpVIrWTThxmOPpBbKGdS7aF/Lf99BtmShyyL4+lv3cuUW+4cm494Gf7DoVwMuj7cl8aplJz3XH93N6cRUfsQRp2DzAt890frn1Dy4fXoHOGqWcgyPJ9Bugqv2tsy+MY03zKUHDZAWxkPh0d7D6cF4nUssbjQfOMwUti8AR8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7B22D601A1; Fri, 16 May 2025 14:20:46 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds
Date: Fri, 16 May 2025 16:12:13 +0200
Message-ID: <20250516141216.26745-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its now possible to build a kernel that has no support for the classic
xtables get/setsockopt interfaces and builtin tables.

In this case, we have CONFIG_IP6_NF_MANGLE=n and
CONFIG_IP_NF_ARPTABLES=n.

For optstript, the ipv6 code is so small that we can enable it if
netfilter ipv6 support exists. For mark, check if either classic
arptables or NFT_ARP_COMPAT is set.

Fixes: a9525c7f6219 ("netfilter: xtables: allow xtables-nft only builds")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 nf-next as we're too late in this development cycle.
 I detached this from the larger 'Exclude LEGACY TABLES on PREEMPT_RT'
 as its a self-standing bug fix.

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
2.49.0

