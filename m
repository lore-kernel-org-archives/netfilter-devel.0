Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579A6370D6D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2026 09:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778145633; cv=none; b=gviH40aWKaQ+JTZdt5nMW2QYqW3D9dV1zPKdB6q2pNWbRlspqinC8DlKduRKYwvERrZ1oTnDxiKvk8YTa/OgSMKIpHI6nxCyVHjsu2GKmy0X4t0NOqGIdziFzugACMkzuRnhcPIhIZRGilRDScPk/AquPXhp1HPMvVN1UG6+VpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778145633; c=relaxed/simple;
	bh=9DSXW2TUYZRK98JxZIrLyW9X1ajP6NS+2E1LfDjeb50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOwu+TD2z1Qh7nAooS8eri7qMrlWcDTPEUNOzm+a60doHNnpmsOZoH4Txm1GlKkFAQ3g8ybO69Zl9YTDHZRHCR3DyxB/MRagm969fRoCkDv2fr7WPL5qvpf32Bpnew7VdVnFVNKltHOpeNEINr90++jE5+RKPKUJmqFcN+vPdy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D805C60D41; Thu, 07 May 2026 11:20:19 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf 9/8] netfilter: bridge: eb_tables: close module init race
Date: Thu,  7 May 2026 11:19:22 +0200
Message-ID: <20260507092014.17981-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260506100728.2664-1-fw@strlen.de>
References: <20260506100728.2664-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko reports for unrelated patch:
 Does the core ebtables initialization in ebtables.c suffer from a similar race?
 Once nf_register_sockopt() completes, the sockopts are exposed globally.

sockopt has to be registered last, just like in ip/ip6/arptables.

Fixes: 5b53951cfc85 ("netfilter: ebtables: use net_generic infra")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 3578ffbc14ae..b9f4daac09af 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2583,19 +2583,20 @@ static int __init ebtables_init(void)
 {
 	int ret;
 
-	ret = xt_register_target(&ebt_standard_target);
+	ret = register_pernet_subsys(&ebt_net_ops);
 	if (ret < 0)
 		return ret;
-	ret = nf_register_sockopt(&ebt_sockopts);
+
+	ret = xt_register_target(&ebt_standard_target);
 	if (ret < 0) {
-		xt_unregister_target(&ebt_standard_target);
+		unregister_pernet_subsys(&ebt_net_ops);
 		return ret;
 	}
 
-	ret = register_pernet_subsys(&ebt_net_ops);
+	ret = nf_register_sockopt(&ebt_sockopts);
 	if (ret < 0) {
-		nf_unregister_sockopt(&ebt_sockopts);
 		xt_unregister_target(&ebt_standard_target);
+		unregister_pernet_subsys(&ebt_net_ops);
 		return ret;
 	}
 
-- 
2.53.0

