Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13C93C661A;
	Thu,  2 Jul 2026 10:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989440; cv=none; b=SwKpj8kLpGeBhXd+g6WLXJ32J3XHCH3yWrikV+h09zyOjI4MF23bNPeo8E/bEGvrM5blOmiHmcffVpXMRHFS330BpZaPJ/NYxo4Vjm9EDeZTs/w2EoidSHXE8I5lCVGpTLPpTv0DEkNu09ukp4lzQbHaGBAg6YDq5S5MGFDYR+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989440; c=relaxed/simple;
	bh=BEVLRaNL3omsuuBN1cVn05yN0wyxjrfpJAQTZBNgMQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1v4/h9qHDIVb2gbg3hWlInDzJtq5UPKEUDaFPwtrCE6SIshDzfOZ2tb6PJV9f1qOie/Dqp0Dj2fhLqi7Bz/FO73T1TzuMk+HOOgRAvy7wJWyMXFiVae6BJs73lpxLFvm1ad5t4zcntIlnnllGWhdZFHAuuPAceQ1yYDt2lW+0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3876B601F0; Thu, 02 Jul 2026 12:50:38 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 06/12] netfilter: xt_tcpmss: add checkentry for parameter validation
Date: Thu,  2 Jul 2026 12:49:57 +0200
Message-ID: <20260702105003.13550-7-fw@strlen.de>
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

Add tcpmss_mt_check() that validates mss_min <= mss_max and
invert <= 1.

Signed-off-by: Feng Wu <wufengwufengwufeng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_tcpmss.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index b9da8269161d..b08b077d7f0a 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -78,10 +78,23 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return false;
 }
 
+static int tcpmss_mt_check(const struct xt_mtchk_param *par)
+{
+	const struct xt_tcpmss_match_info *info = par->matchinfo;
+
+	if (info->mss_min > info->mss_max)
+		return -EINVAL;
+	if (info->invert > 1)
+		return -EINVAL;
+
+	return 0;
+}
+
 static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcpmss",
 		.family		= NFPROTO_IPV4,
+		.checkentry	= tcpmss_mt_check,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
-- 
2.54.0

