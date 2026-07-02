Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277C23C5826;
	Thu,  2 Jul 2026 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989432; cv=none; b=S47qHu1sj/dsxQEaiq3CscT9Sq2Oxj6xbi35Ir+CbkRmP2NF194vc36Xw00+7G3Atfu9KG8Jv5p/fnJ0a806WWgqGS4Po7atEiNiU+j2EEBzxbYbvjY8JnnXHzOnRJqfjPPzFAs8jKJdNz9eYO0UtUbc7KFl0j8n31KAdxXXUoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989432; c=relaxed/simple;
	bh=PtPp87kPvvPlmL5UceFuXYr/VHMRtKEOWmn76xCRSQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlt9w35XZwmTA8GSYM/O89eWbYAJF3d9JJxk8Eu8uTaP50EJYtYHFlW929R44VJyH3jeqDpTKdonGGdfqR+iRhFuZwSe2YJ1G6Q8QyADePl+yLlYEczdwbWQ2supBB/8l13Y6i4whpEjptI/0jgnRqgYEDUuxuzBEmr3Nybjcmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AE0D6601F0; Thu, 02 Jul 2026 12:50:29 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 04/12] netfilter: avoid strcpy usage
Date: Thu,  2 Jul 2026 12:49:55 +0200
Message-ID: <20260702105003.13550-5-fw@strlen.de>
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

From: David Laight <david.laight.linux@gmail.com>

Replacing strcpy() with strscpy() ensures that overflow of the target
buffer cannot happen.

[ fw@strlen.de: cleanup. netlink policy rejects too large inputs,
  xt_recent validates content and length before the copy ]

Signed-off-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 +-
 net/netfilter/xt_recent.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 170d3db860c5..66c2016f6049 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -168,7 +168,7 @@ static int cttimeout_new_timeout(struct sk_buff *skb,
 	if (ret < 0)
 		goto err_free_timeout_policy;
 
-	strcpy(timeout->name, nla_data(cda[CTA_TIMEOUT_NAME]));
+	nla_strscpy(timeout->name, cda[CTA_TIMEOUT_NAME], sizeof(timeout->name));
 	timeout->timeout->l3num = l3num;
 	timeout->timeout->l4proto = l4proto;
 	refcount_set(&timeout->timeout->refcnt, 1);
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index f72752fa4374..d34831ce3adf 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -400,7 +400,7 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	t->nstamps_max_mask = nstamp_mask;
 
 	memcpy(&t->mask, &info->mask, sizeof(t->mask));
-	strcpy(t->name, info->name);
+	strscpy(t->name, info->name);
 	INIT_LIST_HEAD(&t->lru_list);
 	for (i = 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
-- 
2.54.0

