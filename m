Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B07152E1F;
	Mon, 22 Apr 2024 15:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713799894; cv=none; b=slNnfrmxHCd5qD9J21b5XjPq+MtA69kv+6BZpgOwqeSNXkF5M3ddH5kY5jntxh2oxTNUoV5ZTS7iGiBpCnmQGf1bXyFd/8uwUkd/G0Eh9RxcpM1cuGAdOLFlPdJUz+Tp+/9YP4O+g0zeZZFO5xxk0/HV3EGw/TOd96VlvkpINx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713799894; c=relaxed/simple;
	bh=ZX7ezTTTUMTmVtmYsyG3PnhRs5cysy7HO5gbmBVheck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KIeXivxn7sVe8pYse7iZ2gKqrcm04iShsH6m8K9GL5g3MnkMoRwL4V4uWEqcjvE8PPq5wYS27BQCNIu2rbfRLLXUCUfWRN2Zq88h0zIWqnFxg4a1sG3oGM6+iy16roQyySvugLBoyJ7Ls4RkzpFcyg/bF2FnNMmI2AUCRDx1VFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1ryvdg-0000fj-7G; Mon, 22 Apr 2024 17:31:28 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next] tools: testing: selftests: switch conntrack_dump_flush to TEST_PROGS
Date: Mon, 22 Apr 2024 17:26:59 +0200
Message-ID: <20240422152701.13518-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently conntrack_dump_flush test program always runs when passing
TEST_PROGS argument:

% make -C tools/testing/selftests TARGETS=net/netfilter TEST_PROGS=conntrack_ipip_mtu.sh run_tests
make: Entering [..]
TAP version 13
1..2 [..]
  selftests: net/netfilter: conntrack_dump_flush [..]

Move away from TEST_CUSTOM_PROGS to avoid this.  After this,
above command will only run the program specified in TEST_PROGS.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I noticed that conntrack_dump_flush test case runs on each test
 iteration in the netdev test infra, hence this patch.

 Alternative would be to also pass TEST_CUSTOM_PROGS="", but I guess
 its better to stop using this feature, no other net subtests do this.

 tools/testing/selftests/net/netfilter/Makefile                | 3 +--
 tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh | 4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index 68e4780edfdc..15d2f2087aee 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -7,6 +7,7 @@ MNL_CFLAGS := $(shell $(HOSTPKG_CONFIG) --cflags libmnl 2>/dev/null)
 MNL_LDLIBS := $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)
 
 TEST_PROGS := br_netfilter.sh bridge_brouter.sh
+TEST_PROGS += conntrack_dump_flush.sh
 TEST_PROGS += conntrack_icmp_related.sh
 TEST_PROGS += conntrack_ipip_mtu.sh
 TEST_PROGS += conntrack_tcp_unreplied.sh
@@ -28,8 +29,6 @@ TEST_PROGS += nft_zones_many.sh
 TEST_PROGS += rpath.sh
 TEST_PROGS += xt_string.sh
 
-TEST_CUSTOM_PROGS += conntrack_dump_flush
-
 TEST_GEN_FILES = audit_logread
 TEST_GEN_FILES += conntrack_dump_flush
 TEST_GEN_FILES += connect_close nf_queue
diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh
new file mode 100755
index 000000000000..5e81c8284aa9
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+exec ./conntrack_dump_flush
-- 
2.43.2

