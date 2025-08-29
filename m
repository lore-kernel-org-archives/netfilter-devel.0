Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E7E3203A9
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477527; cv=none; b=Ned/4NGEXhulaCep92T8+0MzpbH9sLLUkfS4/JzANZL9Rk2nsJumTZ4/F2V4J7I4aZR8Q0ExgPEfIuVFFckCP4SMBjmZaxB3H/F7y4z6JRBWKchxnHqsc0d4rzzK51oTpgqRgIGyNsCmD43fFJEnOy+W07DuthmrpQXGwsMj4RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477527; c=relaxed/simple;
	bh=imiHlq1j4o+CWLWDH+CsKPALPOl09uOX500kXkMWkg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSfayOeugGBw05d6X4ohrH2vxb8KekQg8QudcCdJnnFQrEpBrL8u9RCB0fN2QMS2pjCAAjGXyMSiBueCNUOCVpWi6WN+wqR6QQgA91uJYznLoHPnmK+pzyqYE9Csiqmhqmt24EkZnASHCTVVpVC4D93PK59r5BtGJBwDzHqr3Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YMK2Ld8R; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YMK2Ld8R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pL398BB5niwHiG+HMpus11qjNciovvz1ZvqZqKxM4+E=; b=YMK2Ld8RTcwPJzD/JoGv1oJa5H
	w3PqbE3BePX+1JFpdtXnf9JIszl/3TY4N2l/+YNnOeZFYInEGUDyXPaekXSk2pIHRCGsQw9ywhF74
	S5rlfK3tifQyZP1ppTFa++CNzdyUFg2RtIWVsBMM7zYxkMqshpceL+eyeebmELberckMg/AwC90Nb
	pyzU4+GD8rPvSpRX4R7mDQaHixmy8Wgjucpuyb/Q62AUnYJQ/LC/hsKZsHWul6aoCzkdpS8WG8yji
	4yI5aK+cDip826od9bJNX5SXh3WOPP0el3Ihq07ajuPe0YEB2veX4X8H94/w0p+EpzAv5MaL1Eks1
	xUPPkaeA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us02d-0000000073T-2gn4;
	Fri, 29 Aug 2025 16:25:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/5] tests: monitor: Extend testcases a bit
Date: Fri, 29 Aug 2025 16:25:13 +0200
Message-ID: <20250829142513.4608-6-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829142513.4608-1-phil@nwl.cc>
References: <20250829142513.4608-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Try to cover for reduced table and chain deletion notifications by
creating them with data which is omitted by the kernel during deletion.

Also try to expose the difference in reported flowtable hook deletion
vs. flowtable deletion.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/chain.t            | 41 ++++++++++++++++++++++
 tests/monitor/testcases/flowtable-simple.t | 12 +++++++
 tests/monitor/testcases/table.t            | 15 ++++++++
 3 files changed, 68 insertions(+)
 create mode 100644 tests/monitor/testcases/chain.t
 create mode 100644 tests/monitor/testcases/table.t

diff --git a/tests/monitor/testcases/chain.t b/tests/monitor/testcases/chain.t
new file mode 100644
index 0000000000000..975ccf1d33919
--- /dev/null
+++ b/tests/monitor/testcases/chain.t
@@ -0,0 +1,41 @@
+I add table inet t
+O -
+J {"add": {"table": {"family": "inet", "name": "t", "handle": 0}}}
+
+I add chain inet t c
+O -
+J {"add": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0}}}
+
+I delete chain inet t c
+O -
+J {"delete": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0}}}
+
+I add chain inet t c { type filter hook input priority filter; }
+O add chain inet t c { type filter hook input priority 0; policy accept; }
+J {"add": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}}}
+
+I delete chain inet t c
+O -
+J {"delete": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0}}}
+
+I add chain inet t c { type filter hook ingress priority filter; devices = { "lo" }; }
+O add chain inet t c { type filter hook ingress devices = { "lo" } priority 0; policy accept; }
+J {"add": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0, "dev": "lo", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+I delete chain inet t c
+O -
+J {"delete": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0}}}
+
+I add chain inet t c { type filter hook ingress priority filter; devices = { "eth1", "lo" }; }
+O add chain inet t c { type filter hook ingress devices = { "eth1", "lo" } priority 0; policy accept; }
+J {"add": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0, "dev": ["eth1", "lo"], "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+I delete chain inet t c { type filter hook ingress priority filter; devices = { "eth1" }; }
+O delete chain inet t c { type filter hook ingress devices = { "eth1" } priority 0; policy accept; }
+J {"delete": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0, "dev": "eth1", "type": "filter", "hook": "ingress", "prio": 0, "policy": "accept"}}}
+
+I delete chain inet t c
+O -
+J {"delete": {"chain": {"family": "inet", "table": "t", "name": "c", "handle": 0}}}
+
+
diff --git a/tests/monitor/testcases/flowtable-simple.t b/tests/monitor/testcases/flowtable-simple.t
index 11254c51fcab7..e1889ae5d0076 100644
--- a/tests/monitor/testcases/flowtable-simple.t
+++ b/tests/monitor/testcases/flowtable-simple.t
@@ -8,3 +8,15 @@ J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0
 I delete flowtable ip t ft
 O -
 J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0}}}
+
+I add flowtable ip t ft { hook ingress priority 0; devices = { "eth1", "lo" }; }
+O -
+J {"add": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": ["eth1", "lo"]}}}
+
+I delete flowtable ip t ft { hook ingress priority 0; devices = { "eth1" }; }
+O -
+J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0, "hook": "ingress", "prio": 0, "dev": "eth1"}}}
+
+I delete flowtable ip t ft
+O -
+J {"delete": {"flowtable": {"family": "ip", "name": "ft", "table": "t", "handle": 0}}}
diff --git a/tests/monitor/testcases/table.t b/tests/monitor/testcases/table.t
new file mode 100644
index 0000000000000..35a0f510436dc
--- /dev/null
+++ b/tests/monitor/testcases/table.t
@@ -0,0 +1,15 @@
+I add table ip t
+O -
+J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
+
+I delete table ip t
+O -
+J {"delete": {"table": {"family": "ip", "name": "t", "handle": 0}}}
+
+I add table ip t { comment "foo bar"; flags dormant; }
+O add table ip t { flags dormant; }
+J {"add": {"table": {"family": "ip", "name": "t", "handle": 0, "flags": ["dormant"], "comment": "foo bar"}}}
+
+I delete table ip t
+O -
+J {"delete": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-- 
2.51.0

