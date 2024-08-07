Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB4F12FF71
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059661; cv=none; b=qq5MG8XRayk617MnDJxIOK8I6jaeWbVYf66VN6XwRBL90QYg883OHwv6ArmRnsZ0UEMfrE8liwcAJRtIYY5rU2l6i0qg9qijW47jERUce6pM5czQathFVT+EK0Go8FtmMvtJHZEqN1Nk1gh0oTjjFmt/jNVjGsODqBNtngTtesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059661; c=relaxed/simple;
	bh=Fop59QxMnNzUmKLjKB1yhmSrP3opQmo9Rs4732aOOJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im91IGVfE70ZQCvN1ExP7F2CInEdp5kDHJcKSv5jqcaX6L4Oh7mhqB0sucsZEICfcO6GRpT94BUcdHNnNCeUzTf6TQmg7wY/4PEUg4h7yQaK/dQLPzGQhFNbjfzucCIH62nkFQ6lFIMqu0gCH1ClLMCbV5X3moMMNp3cDOpLmyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sbmWm-0007ek-JF; Wed, 07 Aug 2024 21:40:56 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] selftests: netfilter: add test for br_netfilter+conntrack+queue combination
Date: Wed,  7 Aug 2024 21:28:42 +0200
Message-ID: <20240807192848.28007-3-fw@strlen.de>
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
 .../testing/selftests/net/netfilter/Makefile  |  1 +
 .../net/netfilter/br_netfilter_queue.sh       | 71 +++++++++++++++++++
 tools/testing/selftests/net/netfilter/lib.sh  | 16 +++++
 .../selftests/net/netfilter/nft_queue.sh      | 16 -----
 4 files changed, 88 insertions(+), 16 deletions(-)
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
index 000000000000..009ad754170a
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
@@ -0,0 +1,71 @@
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
+while true; do conntrack -F > /dev/null 2> /dev/null; sleep 0.1 ; done &
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
diff --git a/tools/testing/selftests/net/netfilter/lib.sh b/tools/testing/selftests/net/netfilter/lib.sh
index bedd35298e15..1960e7b3c982 100644
--- a/tools/testing/selftests/net/netfilter/lib.sh
+++ b/tools/testing/selftests/net/netfilter/lib.sh
@@ -8,3 +8,19 @@ checktool (){
 		exit $ksft_skip
 	fi
 }
+
+nf_queue_wait()
+{
+	local procfile="/proc/self/net/netfilter/nfnetlink_queue"
+	local netns id
+
+	netns="$1"
+	id="$2"
+
+	# if this file doesn't exist, nfnetlink_module isn't loaded.
+	# rather than loading it ourselves, wait for kernel module autoload
+	# completion, nfnetlink should do so automatically because nf_queue
+	# helper program, spawned in the background, asked for this functionality.
+	test -f "$procfile" &&
+		ip netns exec "$netns" cat "$procfile" | grep -q "^ *$id "
+}
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index c61d23a8c88d..edd0e9d6def4 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -190,22 +190,6 @@ EOF
         echo "PASS: $proto: statement with no listener results in packet drop"
 }
 
-nf_queue_wait()
-{
-	local procfile="/proc/self/net/netfilter/nfnetlink_queue"
-	local netns id
-
-	netns="$1"
-	id="$2"
-
-	# if this file doesn't exist, nfnetlink_module isn't loaded.
-	# rather than loading it ourselves, wait for kernel module autoload
-	# completion, nfnetlink should do so automatically because nf_queue
-	# helper program, spawned in the background, asked for this functionality.
-	test -f "$procfile" &&
-		ip netns exec "$netns" cat "$procfile" | grep -q "^ *$id "
-}
-
 test_queue()
 {
 	local expected="$1"
-- 
2.44.2

