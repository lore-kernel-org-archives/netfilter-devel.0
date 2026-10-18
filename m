Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8001096F;
	Sun, 18 Oct 2026 00:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285019; cv=none; b=C1lcXA4B8u+XqOUbaPvVnrzF1jz4nfYRHZKlcpWZAjgJvrqCKk581ZdGfCWb2IOzgpp+OwMimCPWqoOD7xVLH79+v9E0/v6uWcmfGgL/cnUSK+VViPKz7aL4VlTJSN5Rlzgff8A5rMs6gEGEDxqzqRw3MZwYWY2mjHz9+lICIj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285019; c=relaxed/simple;
	bh=At/EiXhFAm1iD8Yf3UnqTrCqbR348bxy31bCS3r3hTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEk/df/rIJUPNeitUu5q4FPq2axDGd3hJCpAHUR/dT0OlVyOwTkJNt0yE+3GpdPEgL2DpTXdyjoj2wC5qBo1NMA+5Yt4y8vF3efjrfC96uPBo4JRB2+pwZAwqmT+tzqCN3kPd/C4DOhvFkNCpxppbr7x7tKl7QhmUMTFsh7/kpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YTaluFZF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YTaluFZF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285014;
	bh=E1Cbk5IszV4MBBshEiO28wQd4BdAzmupMNuTKaXt9u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTaluFZFEoXXH7sarc4DdsQIidyVIHZfv9BVlMpdYyjeX45hxsx5dkjH8XwEXebx4
	 W6gw/QrzX8AJSbgPeUMv9X2VXnFNq0MsJighhsMxd2idKtTEw1qbXCZY2n0YhCZESX
	 KdrcsJGGY1yRvYk5vDcj6vtAefVJIsPRt4gM8o/FGY4GIv2h32S9mH3vGi1fva1dKD
	 vIHu4y2HXpTBmIjQyaZhq63Zlm/SZUlj2qws/ToHxt5YSNty/J+vNt5UsQcvBRGvdv
	 ITAm0wkoY/EsSdK/2brZEbusNXRO1uKHt/NuN/JYlDncNYBJNciI2fu1PBsWdtujrb
	 eOImrExem98Zg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6691560076;
	Sun, 18 Oct 2026 02:56:54 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 05/15] selftests: netfilter: nft_queue: check the scope of the hook drop flush
Date: Sun, 18 Oct 2026 02:56:28 +0200
Message-ID: <20261018005638.1776148-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Antonio Ojea <aojea@google.com>

Add test_hook_drop_scope. It queues 20 UDP packets from an inet output
chain to a queue program that holds all verdicts, deletes a base chain
while they wait, and reads the queue length from
/proc/net/netfilter/nfnetlink_queue right after the deletion. It then
releases the queue program and checks with a counter in the input
chain and the packet total of the queue program that the surviving
packets are delivered.

Deleting a base chain at another hook point (ip6 prerouting) must keep
the 20 queued packets. Deleting a base chain at the queueing hook point
(inet output, another priority) drops them, because the index of a
queued packet into the hook array of its hook point is stale once that
array changed. The second case documents the remaining behaviour so
that a change to it is visible.

To hold the packets without depending on timing, add the -H option to
the nf_queue helper: it blocks SIGUSR1, reads the first packet and
waits in sigwait() until it receives SIGUSR1, then sends the verdicts
as usual. The test sends the signal after the ruleset change, so the
queue length it reads is exact on slow machines too.

Without the previous patch the first case fails: 0 of 20 packets remain
queued after the deletion and none is delivered.

The test and the helper option were written with an LLM coding
assistant from a task description; the author reviewed the result,
and validated the test in virtme-ng on kernels with and without the
previous patch.

Assisted-by: LLM
Signed-off-by: Antonio Ojea <aojea@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/net/netfilter/nf_queue.c        |  22 +++-
 .../selftests/net/netfilter/nft_queue.sh      | 108 ++++++++++++++++++
 2 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index 8bbec37f5356..cca6c3cfa9e4 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <errno.h>
+#include <signal.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdint.h>
@@ -21,6 +22,7 @@ struct options {
 	bool failopen;
 	bool out_of_order;
 	bool bogus_verdict;
+	bool hold;
 	int verbose;
 	unsigned int queue_num;
 	unsigned int timeout;
@@ -34,6 +36,7 @@ static struct options opts;
 static void help(const char *p)
 {
 	printf("Usage: %s [-c|-v [-vv] ] [-o] [-O] [-b] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
+	printf("          [-H] (hold verdicts until SIGUSR1 is received)\n");
 }
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
@@ -280,6 +283,7 @@ static int mainloop(void)
 	uint32_t ooo_ids[16];
 	unsigned int portid;
 	int ooo_count = 0;
+	sigset_t hold_set;
 	char *buf;
 	int ret;
 
@@ -289,6 +293,12 @@ static int mainloop(void)
 		exit(EXIT_FAILURE);
 	}
 
+	/* -H: keep SIGUSR1 pending until the first packet is read */
+	sigemptyset(&hold_set);
+	sigaddset(&hold_set, SIGUSR1);
+	if (opts.hold)
+		sigprocmask(SIG_BLOCK, &hold_set, NULL);
+
 	nl = open_queue();
 	portid = mnl_socket_get_portid(nl);
 
@@ -320,6 +330,13 @@ static int mainloop(void)
 		}
 
 		id = ret - MNL_CB_OK;
+		if (opts.hold) {
+			int sig;
+
+			sigwait(&hold_set, &sig);
+			opts.hold = false;
+		}
+
 		if (opts.delay_ms)
 			sleep_ms(opts.delay_ms);
 
@@ -364,7 +381,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "chvoObt:q:Q:d:G")) != -1) {
+	while ((c = getopt(argc, argv, "chvoObt:q:Q:d:GH")) != -1) {
 		switch (c) {
 		case 'c':
 			opts.count_packets = true;
@@ -373,6 +390,9 @@ static void parse_opts(int argc, char **argv)
 			help(argv[0]);
 			exit(0);
 			break;
+		case 'H':
+			opts.hold = true;
+			break;
 		case 'q':
 			opts.queue_num = atoi(optarg);
 			if (opts.queue_num > 0xffff)
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index c8d1f2eb4133..a07652813a4b 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -861,6 +861,113 @@ test_queue_bridge()
 	test_queue 20 "bridge"
 }
 
+hook_drop_delivered()
+{
+	ip netns exec "$ns1" nft list counter inet nfqscope delivered |
+		sed -n 's/.*packets \([0-9]*\) .*/\1/p'
+}
+
+hook_drop_queued()
+{
+	ip netns exec "$ns1" awk '$1 == 1 { print $3 }' /proc/self/net/netfilter/nfnetlink_queue
+}
+
+hook_drop_all_queued()
+{
+	[ "$(hook_drop_queued)" = "$1" ]
+}
+
+# hook_drop_case <keep|drop> <description> <nft command...>
+#
+# 1. The inet output chain sends udp packets to port 12345 to queue 1,
+#    the inet input chain counts them once they are accepted.
+# 2. nf_queue -H reads the packets but sends no verdict until it gets
+#    SIGUSR1, so the 20 packets sent stay in the kernel queue.
+# 3. The nft command removes a base chain while they are queued.  The
+#    queue length in /proc right after it tells if the kernel dropped
+#    them: still 20, or 0.
+# 4. SIGUSR1 releases nf_queue.  If the kernel kept the packets they are
+#    accepted now and reach the input counter.  If it dropped them the
+#    first verdict fails with ENOENT and nothing is counted.
+hook_drop_case()
+{
+	local expect="$1"
+	local desc="$2"
+	local packets=20
+	local delivered queued result
+	shift 2
+
+ip netns exec "$ns1" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet nfqscope {
+	chain output {
+		type filter hook output priority 0; policy accept;
+		udp dport 12345 queue num 1
+	}
+	chain input {
+		type filter hook input priority 0; policy accept;
+		udp dport 12345 counter name delivered
+	}
+	chain output2 {
+		type filter hook output priority 100; policy accept;
+	}
+	counter delivered {}
+}
+table ip6 unrelated {
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+	}
+}
+EOF
+	ip netns exec "$ns1" ./nf_queue -c -q 1 -H -t "$timeout" > "$TMPFILE1" 2>&1 &
+	local nfqpid=$!
+
+	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$ns1" 1
+
+	ip netns exec "$ns1" bash -c \
+		"for i in \$(seq $packets); do echo x > /dev/udp/127.0.0.1/12345; done"
+
+	busywait "$BUSYWAIT_TIMEOUT" hook_drop_all_queued "$packets"
+
+	ip netns exec "$ns1" nft "$@"
+	queued=$(hook_drop_queued)
+
+	kill -USR1 "$nfqpid"
+	wait "$nfqpid"
+	delivered=$(hook_drop_delivered)
+
+	if [ "$queued" = "$packets" ] && [ "$delivered" = "$packets" ] &&
+	   grep -q "^$packets packets total" "$TMPFILE1"; then
+		result="keep"
+	elif [ "$queued" = "0" ] && [ "$delivered" = "0" ]; then
+		result="drop"
+	else
+		result="inconsistent"
+	fi
+
+	if [ "$result" = "$expect" ]; then
+		echo "PASS: $desc: queued packets $result"
+	else
+		echo "FAIL: $desc: queued packets $result, expected $expect" 1>&2
+		echo "      $queued of $packets queued after the change, $delivered delivered" 1>&2
+		ret=1
+	fi
+}
+
+test_hook_drop_scope()
+{
+	# the hook array of another hook point changes, queued packets stay
+	hook_drop_case keep "base chain removed at another hook point" \
+		delete chain ip6 unrelated prerouting
+
+	# the hook array of the queueing hook point changes, the position of
+	# the queued packets in it is stale, they are dropped
+	hook_drop_case drop "base chain removed at the queueing hook point" \
+		delete chain inet nfqscope output2
+
+	ip netns exec "$ns1" nft flush ruleset
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
@@ -909,6 +1016,7 @@ test_queue_stress
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
 test_queue_removal
+test_hook_drop_scope
 
 # turns router into a bridge
 test_queue_bridge
-- 
2.47.3

