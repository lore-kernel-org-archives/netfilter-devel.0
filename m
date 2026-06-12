Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB0139150A;
	Fri, 12 Jun 2026 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781256151; cv=none; b=U5M9Yqki+k+uVVLsgXn/Ar4984N701OCoID7EOmnWs8yAKPrQKYKueSdis/Lizv6DNK63t+M1i+3j53bWRzfiL17oyTpIbU+DaCrIcwg6Y4xGEU87n12NlNQipR4zik1Qm7syBMMCsd9q6W4nszWs+xqiYa4lkZTRUCtOlh2Rk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781256151; c=relaxed/simple;
	bh=X96KAz17YtlB5wGgCf4sE/BMaQN4rR9wxHvICVud620=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEHlscI79a8wR8frAYLYR6Lt8zMRQm1vI8BQ7KdzTAc6qxsyf2CbuZfGe6OAZg9hwiIHoTjv35btA+EPP1ti5Eer58eRxODYmmg0O+CwoI3hTNI/nywd2k1NoYG40tV65dNt18Bnt0G/zZy1dFIMdn1Xgar/76ndwuYyRZqJnlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6079360842; Fri, 12 Jun 2026 11:22:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 1/2] netdevsim: tc: allow to test nf_tables offload control plane code
Date: Fri, 12 Jun 2026 11:22:08 +0200
Message-ID: <20260612092209.11966-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612092209.11966-1-fw@strlen.de>
References: <20260612092209.11966-1-fw@strlen.de>
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
code in nf_tables.  This is also for fuzzers - the fault injection
framework allows probabilistic error insertion.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: move extack error to nsim_setup_tc_block_cb

 drivers/net/netdevsim/bpf.c |  6 ------
 drivers/net/netdevsim/tc.c  | 20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 8eebcc933ddb..16aa88278398 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -123,12 +123,6 @@ int nsim_bpf_setup_tc_block_cb(enum tc_setup_type type,
 	struct netdevsim *ns = cb_priv;
 	struct bpf_prog *oldprog;
 
-	if (type != TC_SETUP_CLSBPF) {
-		NSIM_EA(cls_bpf->common.extack,
-			"only offload of BPF classifiers supported");
-		return -EOPNOTSUPP;
-	}
-
 	if (!tc_cls_can_offload_and_chain0(ns->netdev, &cls_bpf->common))
 		return -EOPNOTSUPP;
 
diff --git a/drivers/net/netdevsim/tc.c b/drivers/net/netdevsim/tc.c
index 8f013a5895a2..a415e02a6df1 100644
--- a/drivers/net/netdevsim/tc.c
+++ b/drivers/net/netdevsim/tc.c
@@ -9,7 +9,22 @@
 static int
 nsim_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 {
-	return nsim_bpf_setup_tc_block_cb(type, type_data, cb_priv);
+	struct flow_cls_common_offload *common = type_data;
+	int err = 0;
+
+	switch (type) {
+	case TC_SETUP_CLSBPF:
+		err = nsim_bpf_setup_tc_block_cb(type, type_data, cb_priv);
+		break;
+	case TC_SETUP_CLSFLOWER:
+		break;
+	default:
+		NSIM_EA(common->extack, "offload type not supported");
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
 }
 
 static void nsim_taprio_stats(struct tc_taprio_qopt_stats *stats)
@@ -73,7 +88,10 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
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

