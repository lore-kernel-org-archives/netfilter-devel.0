Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE512F39A0
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Nov 2025 14:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763648905; cv=none; b=ogZ5FusybygcxDjUUwBe+6wtm0og9K0a6dTQyEfQEWNHP6ez8NdOyx84BQHW9C982YjVDaG+gE3N80JFch15dmMQDS/S1JV4DPBSXc6BlkFTVde4m4cQBtdZ62oxYaEjVaQder2FZHxy+y2LgSBa+1OQGzLFsX8P0/moh4Lp5xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763648905; c=relaxed/simple;
	bh=VzM2wmDOgsquuY7lAarkI2b0oY12QOU0GZDNNcX6Kmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M8py3BDhF/ok8WVX3Awrlx0rqT8b2XuN+sgfw7rLIqllq13dVHcfphMR6HErWirHNSd5lef7IQgofvfnf9DMk+towvueltZHJgbG+IN7H4dWzfHUs4+47FMC1koOabBi+IynF7z50uh/8AoChUNHkXZwrBLLCcX+3PsOL8OQouQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FU/bkxs+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FU/bkxs+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BhvNsBHMOpSGAlr3ONHMSaTpAFjA6GLkssoyVitDYM0=; b=FU/bkxs+nh2sv0KVIEKXnZOMzL
	JIl8R0LdT+FxagCJWGjM5YIHSPUt4UybXD/xF/ZQrQal3azsIQLCdUiUKFoGRDSkEMArEWWQJWV8E
	EtDixggrl7IbLKfsaNo+pTQz7bI7ExeRsAPiJWhxX8iIaAMskPAtOEZuAnmMD3eQa5zHcWPwxypu1
	6hlyzO1YmWMmtykEBQQhYhDoSrCbqGe2zkUKn4q9HqGP30OM5TG2htfoW8OgayaEqrCkY2HyyNTks
	Ied8Nyqd2sRwYm3LAJ8yIHAgro2okieFYwlKLXS91Bsx57svRfDWgWdHDd1iF1KPqWYgLkgDJ+Koo
	ehW5z/0A==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vM5e0-000000002NZ-0cmC;
	Thu, 20 Nov 2025 15:28:20 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: gorbanev.es@gmail.com
Subject: [iptables PATCH] nft: Support replacing a rule added in the same batch
Date: Thu, 20 Nov 2025 15:28:14 +0100
Message-ID: <20251120142814.8599-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As reported in nfbz#1820, trying to add a rule and replacing it in the
same batch would crash iptables due to a stale rule pointer left in an
obj_update.

Doing this is perfectly fine in legacy iptables, so implement the
missing feature instead of merely preventing the crash.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1820
Fixes: b199aca80da57 ("nft: Fix leak when replacing a rule")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                | 52 +++++++++++++++++--
 .../testcases/ipt-restore/0018-replace-new_0  | 31 +++++++++++
 2 files changed, 79 insertions(+), 4 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0018-replace-new_0

diff --git a/iptables/nft.c b/iptables/nft.c
index 908f544319b74..85080a6dc9ba7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1764,6 +1764,31 @@ nft_rule_new(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	return NULL;
 }
 
+static struct obj_update *obj_update_by_rule(struct nft_handle *h,
+					     struct nftnl_rule *r)
+{
+	struct obj_update *n;
+
+	list_for_each_entry(n, &h->obj_list, head) {
+		if (n->rule == r)
+			return n;
+	}
+	return NULL;
+}
+
+static void copy_nftnl_rule_attr(struct nftnl_rule *to,
+				 const struct nftnl_rule *from,
+				 uint16_t attr)
+{
+	const void *data;
+	uint32_t len;
+
+	if (nftnl_rule_is_set(from, attr)) {
+		data = nftnl_rule_get_data(from, attr, &len);
+		nftnl_rule_set_data(to, attr, data, len);
+	}
+}
+
 int
 nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 		struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose)
@@ -1775,12 +1800,31 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 
 	nft_fn = nft_rule_append;
 
-	if (ref) {
-		nftnl_rule_set_u64(r, NFTNL_RULE_HANDLE,
-				   nftnl_rule_get_u64(ref, NFTNL_RULE_HANDLE));
+	if (ref && !nftnl_rule_is_set(ref, NFTNL_RULE_HANDLE)) {
+		/* replacing a new rule, hijack its obj_update */
+		struct obj_update *n = obj_update_by_rule(h, ref);
+
+		if (!n) {
+			errno = ENOENT;
+			return 0;
+		}
+		if (n->type != NFT_COMPAT_RULE_APPEND &&
+		    n->type != NFT_COMPAT_RULE_INSERT) {
+			errno = EINVAL;
+			return 0;
+		}
+		copy_nftnl_rule_attr(r, ref, NFTNL_RULE_POSITION);
+		copy_nftnl_rule_attr(r, ref, NFTNL_RULE_ID);
+		nftnl_chain_rule_del(ref);
+		nftnl_rule_free(ref);
+		n->rule = r;
+		return 1;
+	} else if (ref) {
+		copy_nftnl_rule_attr(r, ref, NFTNL_RULE_HANDLE);
 		type = NFT_COMPAT_RULE_REPLACE;
-	} else
+	} else {
 		type = NFT_COMPAT_RULE_APPEND;
+	}
 
 	if (batch_rule_add(h, type, r) == NULL)
 		return 0;
diff --git a/iptables/tests/shell/testcases/ipt-restore/0018-replace-new_0 b/iptables/tests/shell/testcases/ipt-restore/0018-replace-new_0
new file mode 100755
index 0000000000000..3930bdeaca155
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0018-replace-new_0
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+set -e
+
+RS='*filter
+-A FORWARD -m comment --comment "new rule being replaced"
+-R FORWARD 1 -m comment --comment "new replacing rule"
+COMMIT'
+EXP='*filter
+:INPUT ACCEPT [0:0]
+:FORWARD ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+-A FORWARD -m comment --comment "new replacing rule"
+COMMIT'
+$XT_MULTI iptables-restore <<< "$RS"
+diff -u -Z <(echo -e "$EXP") <($XT_MULTI iptables-save | grep -v '^#')
+
+RS='*filter
+-A FORWARD -m comment --comment "rule to insert before"
+-I FORWARD 1 -m comment --comment "new rule being replaced"
+-R FORWARD 1 -m comment --comment "new replacing rule"
+COMMIT'
+EXP='*filter
+:INPUT ACCEPT [0:0]
+:FORWARD ACCEPT [0:0]
+:OUTPUT ACCEPT [0:0]
+-A FORWARD -m comment --comment "new replacing rule"
+-A FORWARD -m comment --comment "rule to insert before"
+COMMIT'
+$XT_MULTI iptables-restore <<< "$RS"
+diff -u -Z <(echo -e "$EXP") <($XT_MULTI iptables-save | grep -v '^#')
-- 
2.51.0

