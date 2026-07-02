Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA233C415C;
	Thu,  2 Jul 2026 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989445; cv=none; b=Ohhb7hl7ghIsftc0QRpXGT49FoSitvYDAiJ2YSf/07i/W3sh1080HDMp/oavxSAljwbgC/ZzRM0GIHLch/DMe0TBF4Yi0UQBiIrZXscaXPQcDsaBOztuNSUclUVLjf2Ksb5AZc+hJUxbSXtwbYBvncHxJmUoiYIVqje69iLxI78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989445; c=relaxed/simple;
	bh=V/TtPrVZ/mXao087FqUy2YwjaUFmNTQUyGeLfOpoNEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RM0318WQp6beLyCHwoeOqoTUqlfM+umiA54QmP9CNzVdzYl3AGdXQPVJfm34JVOUDJl7YXQYD7vRc6Xs6N6+WuVx3navd9+IhEtsV2igWSFugobCx56c+ZliwIB8tmTY3AMIMACCFmQYTuSSXmTg90uYqUnPShsAeel0yR8BYiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7916B601F0; Thu, 02 Jul 2026 12:50:42 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 07/12] netfilter: xt_dscp: add checkentry for tos match
Date: Thu,  2 Jul 2026 12:49:58 +0200
Message-ID: <20260702105003.13550-8-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260702105003.13550-1-fw@strlen.de>
References: <20260702105003.13550-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Feng Wu <wufengwufengwufeng@gmail.com>

The 'tos' match registered in xt_dscp.c has no .checkentry callback,
allowing userspace to insert rules with a non-boolean invert field
without any validation.

Add tos_mt_check() that rejects invert > 1 and attach it to both the
IPv4 and IPv6 'tos' match registrations.

Signed-off-by: Feng Wu <wufengwufengwufeng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_dscp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index fb0169a8f9bb..878f27016e99 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -49,6 +49,16 @@ static int dscp_mt_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static int tos_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_tos_match_info *info = par->matchinfo;
+
+	if (info->invert > 1)
+		return -EINVAL;
+
+	return 0;
+}
+
 static bool tos_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_tos_match_info *info = par->matchinfo;
@@ -82,6 +92,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 		.name		= "tos",
 		.revision	= 1,
 		.family		= NFPROTO_IPV4,
+		.checkentry	= tos_mt_check,
 		.match		= tos_mt,
 		.matchsize	= sizeof(struct xt_tos_match_info),
 		.me		= THIS_MODULE,
@@ -90,6 +101,7 @@ static struct xt_match dscp_mt_reg[] __read_mostly = {
 		.name		= "tos",
 		.revision	= 1,
 		.family		= NFPROTO_IPV6,
+		.checkentry	= tos_mt_check,
 		.match		= tos_mt,
 		.matchsize	= sizeof(struct xt_tos_match_info),
 		.me		= THIS_MODULE,
-- 
2.54.0

