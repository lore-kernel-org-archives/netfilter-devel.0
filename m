Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0472AEFE;
	Mon,  4 Nov 2024 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730730433; cv=none; b=fDDDBKOl2tRGenttv9EMaypnvyKABwkHkfI/bTO7bbFGDWDb2KKDD0Nc8f2hPY3hFrJYRJMEQRe6p8v4qjL6SDJk6fDOl9uocGdmr6RK24YkEDkwf8IJl5oU/1xYtjv2WiAtJ6MmAibk295bWhtmS9M/2qrkiMkkLMleoPnQeMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730730433; c=relaxed/simple;
	bh=DSvNtnMzjpXBryKlyfmqIs192yMRZGXBqo0ljXYdBhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KnxcNPTya4jIsNzROztfQzEJ2W774MQMDme3dEz6MBUAh0jdMz58ORBS3qC6iLONIFrI/95ttCFoBCz4SxcXp+p/H0x5VvVOsN4EoHUrFd19OpPoIb/58Qubz6PmnFVJU7QsZ0gGaMUtsgdbzLAsd6T45aeUHm+Z0K05ASUzcek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t7y2v-0006bV-Ji; Mon, 04 Nov 2024 15:27:09 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] selftests: netfilter: run conntrack_dump_flush in netns
Date: Mon,  4 Nov 2024 15:25:24 +0100
Message-ID: <20241104142529.2352-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test will fail if the initial namespace has conntrack
active due to unexpected number of flows returned on dump:

  conntrack_dump_flush.c:451:test_flush_by_zone:Expected ret (7) == 2 (2)
  test_flush_by_zone: Test failed
  FAIL  conntrack_dump_flush.test_flush_by_zone
  not ok 2 conntrack_dump_flush.test_flush_by_zone

Add a wrapper that unshares this program to avoid this problem.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/Makefile                | 4 ++--
 tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index e6c9e777fead..ab543625d6a0 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -8,6 +8,7 @@ MNL_LDLIBS := $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)
 
 TEST_PROGS := br_netfilter.sh bridge_brouter.sh
 TEST_PROGS += br_netfilter_queue.sh
+TEST_PROGS += conntrack_dump_flush.sh
 TEST_PROGS += conntrack_icmp_related.sh
 TEST_PROGS += conntrack_ipip_mtu.sh
 TEST_PROGS += conntrack_tcp_unreplied.sh
@@ -35,10 +36,9 @@ TEST_PROGS += xt_string.sh
 
 TEST_PROGS_EXTENDED = nft_concat_range_perf.sh
 
-TEST_GEN_PROGS = conntrack_dump_flush
-
 TEST_GEN_FILES = audit_logread
 TEST_GEN_FILES += connect_close nf_queue
+TEST_GEN_FILES += conntrack_dump_flush
 TEST_GEN_FILES += conntrack_reverse_clash
 TEST_GEN_FILES += sctp_collision
 
diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh
new file mode 100755
index 000000000000..8b0935385849
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.sh
@@ -0,0 +1,3 @@
+#!/bin/bash
+
+exec unshare -n ./conntrack_dump_flush
-- 
2.45.2

