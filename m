Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07EE38DC60
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 20:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787863387; cv=none; b=W3nrUNBEodMhKkCca4IreDR6ZspvZ8GH+JrzXIiL/AUmRZuDM8iJgUiqC56HLhoGSLTXC+AlgiO5A5lmN6WazF5qDj4Jrh+rOfXMJqstk1WYpXv7KVQDfq1CoYgefkoeJOkpvDE/TaDSLKAQ+5iKhGAE47BWzXG+agV+GUvCdZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787863387; c=relaxed/simple;
	bh=boTzbChWWqL2RcXpgk7d4FeCLSI0SwdjAGKEsSSP/lM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ttt+YdGtYyCD6FEZLrAwbfi/Yh8/3A5L1ayum2/9UU5TvnpgmSHMgMAx+09VTW2e01oIsQ62t0MS0WjPPhdEsUZ+uzZ5rRYqmukGIaGvShsji64qPgS68kT+q5hsLakYdPyEJWeeVQTXYZFKjfpjB8IYKp2KD7TZ55FjYNn528I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m8AAf4Z9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m8AAf4Z9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mEsPrvwuyax1s/DvoRouScj2/3mVFBJsor09ISimw0E=; b=m8AAf4Z9X34mBZ76VP8SrfwaUQ
	xEGKH2j57kZiJsfuyAfeKhq4kArrGWgmNcjsUEVvAcw/aFZt+0kjOSFNTEX8cXDvcKytSDm/wlH6K
	93czPCkyyZRWe0hoD+phdv4aXwUw8ZvslFsdFm0h3vBOh9JbLR14zTVEO8uNSBBSnhuVNVk3nTmzy
	u3SeIV8kNgrZBmZQPFiBUS6QAF6Ti5jrWUnURC8jPybG+ZP8IodV55AN6ZhvlDFh0hq/b4M07pwB/
	lg2FcASwdYutNQBVS1LO8NDtrIAhtUJgZNq7wkmQUnMHznhcPJvPaQYQdrgG8pdOzScGwQlis6D0G
	F2Ecm9Zg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wzgw8-000000000xW-3fLT;
	Thu, 27 Aug 2026 22:43:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [nft PATCH] tests: shell: Test odd netdev hook updates
Date: Thu, 27 Aug 2026 22:42:55 +0200
Message-ID: <20260827204255.274666-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These should cover what Fernando fixes in his kernel patch "netfilter:
nf_tables: fix device name and prefix match in hook lookup" as well as
some bonus cases I came up with.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../chains/netdev_chain_update_wildcard_hook  | 45 +++++++++++++++++++
 .../testcases/flowtable/update_wildcard_hook  | 45 +++++++++++++++++++
 2 files changed, 90 insertions(+)
 create mode 100755 tests/shell/testcases/chains/netdev_chain_update_wildcard_hook
 create mode 100755 tests/shell/testcases/flowtable/update_wildcard_hook

diff --git a/tests/shell/testcases/chains/netdev_chain_update_wildcard_hook b/tests/shell/testcases/chains/netdev_chain_update_wildcard_hook
new file mode 100755
index 0000000000000..1381f4be2a5f1
--- /dev/null
+++ b/tests/shell/testcases/chains/netdev_chain_update_wildcard_hook
@@ -0,0 +1,45 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ifname_based_hooks)
+
+RC=0
+
+die() {
+	echo "FAIL: $@"
+	((RC++))
+	$NFT list ruleset
+}
+
+$NFT add table netdev t || die "add table failed"
+
+do_chain() { # (cmd, devspec, thp)
+	$NFT $1 chain netdev t c "{ $3 devices = { $2 }; }"
+}
+
+thp='type filter hook ingress priority 0;'
+
+do_chain add foo* "$thp" || die "initial add chain failed"
+do_chain create foo* "$thp" && die "duplicated create initial chain allowed"
+do_chain add foo* || die "duplicated hook add failed"
+
+do_chain add "bar*, bar*" && die "duplicate wildcard add allowed"
+do_chain add "bar, bar" && die "duplicate device add allowed"
+
+do_chain add foo && die "update with non-wildcard allowed"
+do_chain add fo* && die "update with shorter wildcard allowed"
+do_chain add fooo* && die "update with longer wildcard allowed"
+
+# add after testing delete in case deletion is allowed when it should not
+
+do_chain delete foo && die "delete non-wildcard hook allowed"
+do_chain add foo* || die "duplicated hook add failed"
+
+do_chain delete fo* && die "delete shorter wildcard allowed"
+do_chain add foo* || die "duplicated hook add failed"
+
+do_chain delete fooo* && die "delete longer wildcard allowed"
+do_chain add foo* || die "duplicated hook add failed"
+
+do_chain delete foo* || die "delete initial chain hook failed"
+
+exit $RC
diff --git a/tests/shell/testcases/flowtable/update_wildcard_hook b/tests/shell/testcases/flowtable/update_wildcard_hook
new file mode 100755
index 0000000000000..a67c8bffe0687
--- /dev/null
+++ b/tests/shell/testcases/flowtable/update_wildcard_hook
@@ -0,0 +1,45 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ifname_based_hooks)
+
+RC=0
+
+die() {
+	echo "FAIL: $@"
+	((RC++))
+	$NFT list ruleset
+}
+
+$NFT add table t || die "add table failed"
+
+do_ft() { # (cmd, devspec, thp)
+	$NFT $1 flowtable t ft "{ $3 devices = { $2 }; }"
+}
+
+thp='hook ingress priority 0;'
+
+do_ft add foo* "$thp" || die "initial add flowtable failed"
+do_ft create foo* "$thp" && die "duplicated create initial flowtable allowed"
+do_ft add foo* || die "duplicated hook add failed"
+
+do_ft add "bar*, bar*" && die "duplicate wildcard add allowed"
+do_ft add "bar, bar" && die "duplicate device add allowed"
+
+do_ft add foo && die "update with non-wildcard allowed"
+do_ft add fo* && die "update with shorter wildcard allowed"
+do_ft add fooo* && die "update with longer wildcard allowed"
+
+# add after testing delete in case deletion is allowed when it should not
+
+do_ft delete foo && die "delete non-wildcard hook allowed"
+do_ft add foo* || die "duplicated hook add failed"
+
+do_ft delete fo* && die "delete shorter wildcard allowed"
+do_ft add foo* || die "duplicated hook add failed"
+
+do_ft delete fooo* && die "delete longer wildcard allowed"
+do_ft add foo* || die "duplicated hook add failed"
+
+do_ft delete foo* || die "delete initial flowtable hook failed"
+
+exit $RC
-- 
2.54.0

