Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D06352030;
	Wed, 10 Jun 2026 17:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781114370; cv=none; b=Iz6sFRKQDTrebwBbyKA4XiHGaWRzCvRnkhF3DbaMgqurcbcYI5fzV5Czz4d2+6uN1RbSeAVYgh2Hcda1Y7aQbYdhFbaiWENA4rr9cPUt/TQ6QbGQQ3GR5ybmefu1KJaQ4ARE538kwk1C5+8bwYt0PPBQvAfkb5KUfTDDT71MeV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781114370; c=relaxed/simple;
	bh=zGRuR9lKpIsWFB3us5ApPBPy1f3dlTfeKxdJBrasOtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rqyd5D8ZviUxD/9kIqIHyIu5LchYWS6kHYzskNEAr5Lw4TeGoB06TBljzyMPSGSNF9FIj8jNueFVGaHkMehepezYJZC5kW2ARciTIwhZL5wbH0fy8Tayz8F4M4NupHRpjrsuZPP2mxfhMRl0Jo3rzOL86nKGdXhQZ/4Oefn+dno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 146C4608DF; Wed, 10 Jun 2026 19:59:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/2] netdevsim: tc: allow to test nf_tables offload control plane code
Date: Wed, 10 Jun 2026 19:58:43 +0200
Message-ID: <20260610175906.1767-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260610175906.1767-1-fw@strlen.de>
References: <20260610175906.1767-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The actual 'offload' is phony, all commands are ignored: this is only
useful to test control plane code.

Tag the existing callback to permit error injection to test rollback/abort
code in nf_tables.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/netdevsim/tc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/tc.c b/drivers/net/netdevsim/tc.c
index 8f013a5895a2..0c55d23dae10 100644
--- a/drivers/net/netdevsim/tc.c
+++ b/drivers/net/netdevsim/tc.c
@@ -9,7 +9,20 @@
 static int
 nsim_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 {
-	return nsim_bpf_setup_tc_block_cb(type, type_data, cb_priv);
+	int err = 0;
+
+	switch (type) {
+	case TC_SETUP_CLSBPF:
+		err = nsim_bpf_setup_tc_block_cb(type, type_data, cb_priv);
+		break;
+	case TC_SETUP_CLSFLOWER:
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
 }
 
 static void nsim_taprio_stats(struct tc_taprio_qopt_stats *stats)
@@ -73,7 +86,10 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 						  &nsim_block_cb_list,
 						  nsim_setup_tc_block_cb,
 						  ns, ns, true);
+	case TC_SETUP_FT:
+		return 0;
 	default:
 		return -EOPNOTSUPP;
 	}
 }
+ALLOW_ERROR_INJECTION(nsim_setup_tc, ERRNO);
-- 
2.53.0

