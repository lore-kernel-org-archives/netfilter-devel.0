Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5762F1FD7;
	Fri,  2 Jan 2026 11:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354119; cv=none; b=jRE78MAmmyuVI/U8xtzNumRU604dt6aPzy4uN5R9pCzJsRaAWpC8065Ee90vDKNBJgFYS7cvUA9FWRdIHIhh6Qfo0wAUZSJGfofa3NgNqr0YEBjaSwHxS+DKTFtWVgpTFv+je4kKNFt6p84RREYGppcvINkbwuT5rWNg+BJ/KR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354119; c=relaxed/simple;
	bh=MiFiR2q+UE3L21e9cSJptIK3h5j//dcIsNUCvYZGx4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjtRmJHN6o7yVAPI0u3zDinqT1xaBh4mX4MMdvEDFPTy8U5KLH6YsfvsAJL5Q0Uau8KAZpc5j7pnQmX8NBf7sRJF9y+Xt/8Y8UIDvrsHx3yoiUWgcFkRtwKcRYS7Ax/+f2o0Ek0dHjEOWVvntMisvwdrtEDoOSz70lem+h8fowk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EEA2F6035A; Fri, 02 Jan 2026 12:41:54 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 4/6] netfilter: replace -EEXIST with -EBUSY
Date: Fri,  2 Jan 2026 12:41:26 +0100
Message-ID: <20260102114128.7007-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260102114128.7007-1-fw@strlen.de>
References: <20260102114128.7007-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Gomez <da.gomez@samsung.com>

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

Replace -EEXIST with -EBUSY to ensure correct error reporting in the module
initialization path.

Affected modules:
  * ebtable_broute ebtable_filter ebtable_nat arptable_filter
  * ip6table_filter ip6table_mangle ip6table_nat ip6table_raw
  * ip6table_security iptable_filter iptable_mangle iptable_nat
  * iptable_raw iptable_security

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 2 +-
 net/netfilter/nf_log.c          | 4 ++--
 net/netfilter/x_tables.c        | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5697e3949a36..a04fc1757528 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1299,7 +1299,7 @@ int ebt_register_template(const struct ebt_table *t, int (*table_init)(struct ne
 	list_for_each_entry(tmpl, &template_tables, list) {
 		if (WARN_ON_ONCE(strcmp(t->name, tmpl->name) == 0)) {
 			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
+			return -EBUSY;
 		}
 	}
 
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 74cef8bf554c..62cf6a30875e 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -89,7 +89,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	if (pf == NFPROTO_UNSPEC) {
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
 			if (rcu_access_pointer(loggers[i][logger->type])) {
-				ret = -EEXIST;
+				ret = -EBUSY;
 				goto unlock;
 			}
 		}
@@ -97,7 +97,7 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 			rcu_assign_pointer(loggers[i][logger->type], logger);
 	} else {
 		if (rcu_access_pointer(loggers[pf][logger->type])) {
-			ret = -EEXIST;
+			ret = -EBUSY;
 			goto unlock;
 		}
 		rcu_assign_pointer(loggers[pf][logger->type], logger);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 90b7630421c4..48105ea3df15 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1764,7 +1764,7 @@ EXPORT_SYMBOL_GPL(xt_hook_ops_alloc);
 int xt_register_template(const struct xt_table *table,
 			 int (*table_init)(struct net *net))
 {
-	int ret = -EEXIST, af = table->af;
+	int ret = -EBUSY, af = table->af;
 	struct xt_template *t;
 
 	mutex_lock(&xt[af].mutex);
-- 
2.51.2

