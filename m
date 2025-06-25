Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C653074AC
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 17:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750872027; cv=none; b=KYWk56yOl+sou0OlaBLBUAhGH7pOLrESXzzufth4+7b0GHgERWv2+gKIrQz1vuQCV+nghMbBeM01PW40kwuK21XT9m2BOI2J6xkSotMwzThhYdi2Cx7eVJtXMOgMgttVO7k8JjbIVnicRAcVRWeyyUMOmL87lgr8maqtw88Jv2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750872027; c=relaxed/simple;
	bh=QYVzvkamg5YODEHL5Jqs5qmVlfFTbjZuXfIMUN2El+E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r+0wNkSCSMZf26tZQlVmTktYWCep6QaRuZgwqxw72T7lQnBrRL9Yj7XKb9dxkq8T2chGB8Rt/Ma4VsxuMdzLmNp4pV6W5MqGnOoeGOWdL70d9pn+usUqYe2g0l/JRK2mcJB1Ap5nOiohiU+sDgGxOW96an8o/792hLTLdQ3ijmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bq2TJfds; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bq2TJfds"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SeqwK2M4mnARq+O5vfN8FGnGlXibJRL4gHjzgaNZClE=; b=bq2TJfds2IH5Of6PiyHy5BZBSS
	LVV7SPLtDkRy10wSPcwTWG+VpVx5kKLtx/JKgFIA0b9HudystKzOVjOTSG+PKyDyKqLNArAj8qzo7
	VuQKu0lnj1RuuTpOs1UH/gBKtonbKUnBM8ARfs2ZDfSvza2dOB6nkKsVRLYgYxzl6ronEYTo2HCEd
	e6TE+z6tkuqJfeCdW9QP/ll58JIV2O7Cyxz+VgX6yJicJwvTevVmk5E3ngQgLFEK+8byDkx/OfIJ4
	ROmPWhFdTw/UHLqYuRoLysFRC9S4ErmF7u5S/V/4IH27nq7EKNjgol5Qpd34gvqGC2rcqxdwZ0T7f
	RmmAnnxQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uUTNV-000000000Wm-1RQF;
	Wed, 25 Jun 2025 18:53:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH] tests: shell: Fix ifname_based_hooks feature check
Date: Wed, 25 Jun 2025 18:53:36 +0200
Message-ID: <20250625165336.26654-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test was technically incorrect: Instead of detecting whether
interface hooks are name-based or not, it actually tested whether
netdev-family chains are removed along with their last hook.

Since the latter behaviour is established in kernel commit fc0133428e7a
("netfilter: nf_tables: Tolerate chains with no remaining hooks") and
thus independent from the name-based hooks change, treating both as the
same kernel feature is not acceptable.

Fix this by detecting whether a netdev-family chain may be added despite
specifying a non-existent interface to hook into. Keep the old check
around with a better name, although unused for now.

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: f27e5abd81f29 ("tests: shell: Adjust to ifname-based hooks")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/features/empty_netdev_chains.sh | 12 ++++++++++++
 tests/shell/features/ifname_based_hooks.sh  | 18 +++++++++---------
 2 files changed, 21 insertions(+), 9 deletions(-)
 create mode 100755 tests/shell/features/empty_netdev_chains.sh

diff --git a/tests/shell/features/empty_netdev_chains.sh b/tests/shell/features/empty_netdev_chains.sh
new file mode 100755
index 0000000000000..cada6956f165b
--- /dev/null
+++ b/tests/shell/features/empty_netdev_chains.sh
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# check if netdev chains survive without a single device
+
+unshare -n bash -c "ip link add d0 type dummy; \
+	$NFT \"table netdev t { \
+		chain c { \
+			type filter hook ingress priority 0; devices = { d0 }; \
+		}; \
+	}\"; \
+	ip link del d0; \
+	$NFT list chain netdev t c"
diff --git a/tests/shell/features/ifname_based_hooks.sh b/tests/shell/features/ifname_based_hooks.sh
index cada6956f165b..1f6af531c8c42 100755
--- a/tests/shell/features/ifname_based_hooks.sh
+++ b/tests/shell/features/ifname_based_hooks.sh
@@ -1,12 +1,12 @@
 #!/bin/bash
 
-# check if netdev chains survive without a single device
+# check if adding a netdev-family chain hooking into a non-existent device is
+# accepted or not
 
-unshare -n bash -c "ip link add d0 type dummy; \
-	$NFT \"table netdev t { \
-		chain c { \
-			type filter hook ingress priority 0; devices = { d0 }; \
-		}; \
-	}\"; \
-	ip link del d0; \
-	$NFT list chain netdev t c"
+RULESET="table netdev t {
+	chain c {
+		type filter hook ingress priority 0
+		devices = { foobar123 }
+	}
+}"
+unshare -n $NFT -f - <<< "$RULESET"
-- 
2.49.0

