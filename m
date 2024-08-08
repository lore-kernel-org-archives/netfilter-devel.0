Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096BB158D92
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 21:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723152123; cv=none; b=pUPS/+IQFSDBpmILEZJ9EKwDlaCvUZVOnb3dqbiY0ylFUHIzQ0jFICL+sZu4h2Hu/zmEL4JbbP2NIB28hxkLBOZdLBT08Gab+QXJP3b/RXtfDZN30cq0xIijHXEknhN6Tys8+O6TpJNkI4HA/4IH4l/AK4vqACZ1caWpZyFq6LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723152123; c=relaxed/simple;
	bh=hrNnGCXCaS+x0dAybu8z6ASReZvGW9zTqEudA4rnsh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBcuyo8CVhmW7X1VhSRSLdB8qMwSjC3YV0VRrWXi5qMvyyee+IrhCg9JM5u2Eq8GWw8VZ89KsmKCx75VEO66Lfag1qO3SNr4nHJFUCtB9tuX8CS0KdrlCHKdiNtYxPn69/1ObrxszfKe6LHixddYliyDosShUHYnMrOFU+klKbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1scAa1-0002yp-FM; Thu, 08 Aug 2024 23:21:53 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2 2/2] selftests: netfilter: add test for br_netfilter+conntrack+queue combination
Date: Thu,  8 Aug 2024 23:14:43 +0200
Message-ID: <20240808211607.1833-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240807192848.28007-1-fw@strlen.de>
References: <20240807192848.28007-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trigger cloned skbs leaving softirq protection.
This triggers splat without the preceeding change
("netfilter: nf_queue: drop packets with cloned unconfirmed
 conntracks"):

WARNING: at net/netfilter/nf_conntrack_core.c:1198 __nf_conntrack_confirm..

because local delivery and forwarding will race for confirmation.

Based on a reproducer script from Yi Chen.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: remove unwanted change to lib.sh and remove
 conntrack -F busyloop.

 .../testing/selftests/net/netfilter/Makefile  |  1 +
 .../net/netfilter/br_netfilter_queue.sh       | 78 +++++++++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/br_netfilter_queue.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index 47945b2b3f92..d13fb5ea3e89 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -7,6 +7,7 @@ MNL_CFLAGS := $(shell $(HOSTPKG_CONFIG) --cflags libmnl 2>/dev/null)
 MNL_LDLIBS := $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)
 
 TEST_PROGS := br_netfilter.sh bridge_brouter.sh
+TEST_PROGS += br_netfilter_queue.sh
 TEST_PROGS += conntrack_icmp_related.sh
 TEST_PROGS += conntrack_ipip_mtu.sh
 TEST_PROGS += conntrack_tcp_unreplied.sh
diff --git a/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh b/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
new file mode 100755
index 000000000000..6a764d70ab06
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
@@ -0,0 +1,78 @@
+#!/bin/bash
+
+source lib.sh
+
+checktool "nft --version" "run test without nft tool"
+
+cleanup() {
+	cleanup_all_ns
+}
+
+setup_ns c1 c2 c3 sender
+
+trap cleanup EXIT
+
+nf_queue_wait()
+{
+	grep -q "^ *$1 " "/proc/self/net/netfilter/nfnetlink_queue"
+}
+
+port_add() {
+	ns="$1"
+	dev="$2"
+	a="$3"
+
+	ip link add name "$dev" type veth peer name "$dev" netns "$ns"
+
+	ip -net "$ns" addr add 192.168.1."$a"/24 dev "$dev"
+	ip -net "$ns" link set "$dev" up
+
+	ip link set "$dev" master br0
+	ip link set "$dev" up
+}
+
+[ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }
+
+ip link add br0 type bridge
+ip addr add 192.168.1.254/24 dev br0
+
+port_add "$c1" "c1" 1
+port_add "$c2" "c2" 2
+port_add "$c3" "c3" 3
+port_add "$sender" "sender" 253
+
+ip link set br0 up
+
+modprobe -q br_netfilter
+
+sysctl net.bridge.bridge-nf-call-iptables=1 || exit 1
+
+ip netns exec "$sender" ping -I sender -c1 192.168.1.1 || exit 1
+ip netns exec "$sender" ping -I sender -c1 192.168.1.2 || exit 2
+ip netns exec "$sender" ping -I sender -c1 192.168.1.3 || exit 3
+
+nft -f /dev/stdin <<EOF
+table ip filter {
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+		ct state new counter
+		ip protocol icmp counter queue num 0 bypass
+	}
+}
+EOF
+./nf_queue -t 5 > /dev/null &
+
+busywait 5000 nf_queue_wait
+
+for i in $(seq 1 5); do conntrack -F > /dev/null 2> /dev/null; sleep 0.1 ; done &
+ip netns exec "$sender" ping -I sender -f -c 50 -b 192.168.1.255
+
+read t < /proc/sys/kernel/tainted
+if [ "$t" -eq 0 ];then
+	echo PASS: kernel not tainted
+else
+	echo ERROR: kernel is tainted
+	exit 1
+fi
+
+exit 0
-- 
2.44.2

