Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34BC22B5A3;
	Fri, 19 Dec 2025 05:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766121224; cv=none; b=WBtqXsowQMt0gGWTiag2UolGCoVIN2josAy1dgsyxXlrLnv+hi4k2KU4qZTATnrbwljUKpiRxRcTVeuCfKTw2dqi8o3Ed1cMbDBxX1kIs1Q71VWzCwRMlzEgYi748x1Cchdq97PPwthZX4I2ZiClZmDcpS7cKptp1fb7TYXs8gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766121224; c=relaxed/simple;
	bh=gsvvD4fusz8UOMAocP96M5y9o3JhQPWaOjsWz3Kq8bE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hqG8V3Syb0HeLgZWMY894xQ9zxU9Agx5RZZ8JfyW130aWvvp8DTM+2DUgoY9rB8MBFZTCY+e376wsq9U/YBmv+rwXHjRcZQGRdqdHzgXkPPUsXqK2uScRie44Un5tmtirz06c6w4VPNQAbnq7fQScxl7V0uLE5TZzSlr1RC0GNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjq/AAtp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjq/AAtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53052C116D0;
	Fri, 19 Dec 2025 05:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766121224;
	bh=gsvvD4fusz8UOMAocP96M5y9o3JhQPWaOjsWz3Kq8bE=;
	h=From:Date:Subject:To:Cc:From;
	b=rjq/AAtpu2++A/EjejYLIgRcB0d9a7LoMcuTj2d6IJPcXtn58LE8ikZMO8i00goP5
	 1f/7WYa5XcPrSf1Uzd94Dwei2Czb4Hp91v2QOGGRh1O+LL6we+3DrQFv6e28MYx3ux
	 dGlycK2G5FWFSnFfhv+ghEpvmQucXV89FGcwunjO0Uhzka6tCor8NROjsg1zsRCaxf
	 x2zNGMJaw3THo9P2DTOi1ODskmZ3j3ZVVmIdJah9LJ9W9qzr9yXkqEqn0SGvkczL97
	 M51Ey8LZVP1f+HoNSr98z17EuUqdgTBolCAAG2atHzVwqoRmY/+kYJngT/iGhdBX7z
	 q7H733E3kMxww==
From: Daniel Gomez <da.gomez@kernel.org>
Date: Fri, 19 Dec 2025 06:13:20 +0100
Subject: [PATCH] netfilter: replace -EEXIST with -EBUSY
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-dev-module-init-eexists-netfilter-v1-1-efd3f62412dc@samsung.com>
X-B4-Tracking: v=1; b=H4sIAO/eRGkC/x2NwQqDMBAFf0X23IUmNVL6K9JDNS+6YKNkowjiv
 xs8DgMzBymSQOlTHZSwicocC5hHRf34iwNYfGGyT+uMNW/22Pg/+3UqJkpmYBfNyhE5yJSR2DW
 hDt3LWd93VDpLQpD9frTf87wA+wCYS3MAAAA=
X-Change-ID: 20251218-dev-module-init-eexists-netfilter-56f4fb352dcb
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>, 
 Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
 Aaron Tomlin <atomlin@atomlin.com>, Lucas De Marchi <demarchi@kernel.org>, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 bridge@lists.linux.dev, netdev@vger.kernel.org, 
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daniel Gomez <da.gomez@samsung.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3967; i=da.gomez@samsung.com;
 h=from:subject:message-id; bh=aLysHjbqpI8FaFJ4wtkcZbXvdugD32ypDbpUfYtRcaE=;
 b=owEBbQKS/ZANAwAIAUCeo8QfGVH7AcsmYgBpRN77Y8OOuXAROsrdnRmMDgZy4zuf/ygiHytLh
 91q+5GbhcmJAjMEAAEIAB0WIQTvdRrhHw9z4bnGPFNAnqPEHxlR+wUCaUTe+wAKCRBAnqPEHxlR
 +5xrD/9P2SgKSwKvpQRtM9kmAOh93wT4s4ZSnBztJZMV4mzJV40AOfTIDpHGgeDVem09lfB2ZMA
 YE1L912aK1qiUk9YDCjtn98C5xqtOXvZtHwRwl5dkStnYOqlpC+mA+bXUz+kEKsE/hKWmO7x2I1
 7OADPTymgeGRDJIpLhkNx0OrLdbAAN8dbYs/eCpPkT0+YResXIsfbkYiINLmWeBdmbmxqwWbxzc
 usIaNiSl4OzDI7VPg8sHrsJz4sbMEOAz+VNoM6Wgq/3qnnKMRGdrg5X/iRWthcD6U8tggNdzNhg
 dQhusUZv2pQ1kw37mXwVJ6j3f/jpFeIS4CwKbF9S3nKd3+tle9CwfRfmAdCe5vhhjveAj3Yqhna
 milZZT5mIaBD6BTFNFr5Hb5nqpIrOivQocOmu2WlhFu1jFfCEMnQgv0t1/lgghzKM07Xos7nn60
 nPTTCNbgujniIVURYeEWDAn+mpu6pC8Is1R9EGMYajeZC26dGPqF0WcHJJtHdI30Jlnn3W3ab0n
 IprltDMy+1pga2kvqNg2U5/fGcNxlMn66D61RtQSoaBntfRaINhBt9LZINHDBGZEeC2M2zf2aTF
 IssZlq7yQb8wp5YFAkDTVpdKgCZeuIP7+xhywNLiWTo12iQez4so/XZurSTJNva36Vvc7UVpsIK
 7UCpVRoBp8QWoHQ==
X-Developer-Key: i=da.gomez@samsung.com; a=openpgp;
 fpr=B2A7A9CFDD03B540FF58B27185F56EA4E9E8138F

From: Daniel Gomez <da.gomez@samsung.com>

The -EEXIST error code is reserved by the module loading infrastructure
to indicate that a module is already loaded. When a module's init
function returns -EEXIST, userspace tools like kmod interpret this as
"module already loaded" and treat the operation as successful, returning
0 to the user even though the module initialization actually failed.

This follows the precedent set by commit 54416fd76770 ("netfilter:
conntrack: helper: Replace -EEXIST by -EBUSY") which fixed the same
issue in nf_conntrack_helper_register().

Affected modules:
  * ebtable_broute ebtable_filter ebtable_nat arptable_filter
  * ip6table_filter ip6table_mangle ip6table_nat ip6table_raw
  * ip6table_security iptable_filter iptable_mangle iptable_nat
  * iptable_raw iptable_security

Signed-off-by: Daniel Gomez <da.gomez@samsung.com>
---
The error code -EEXIST is reserved by the kernel module loader to
indicate that a module with the same name is already loaded. When a
module's init function returns -EEXIST, kmod interprets this as "module
already loaded" and reports success instead of failure [1].

The kernel module loader will include a safety net that provides -EEXIST
to -EBUSY with a warning [2], and a documentation patch has been sent to
prevent future occurrences [3].

These affected code paths were identified using a static analysis tool
[4] that traces -EEXIST returns to module_init(). The tool was developed
with AI assistance and all findings were manually validated.

Link: https://lore.kernel.org/all/aKEVQhJpRdiZSliu@orbyte.nwl.cc/ [1]
Link: https://lore.kernel.org/all/20251013-module-warn-ret-v1-0-ab65b41af01f@intel.com/ [2]
Link: https://lore.kernel.org/all/20251218-dev-module-init-eexists-modules-docs-v1-0-361569aa782a@samsung.com/ [3]
Link: https://gitlab.com/-/snippets/4913469 [4]
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

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251218-dev-module-init-eexists-netfilter-56f4fb352dcb

Best regards,
--  
Daniel Gomez <da.gomez@samsung.com>

