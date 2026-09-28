Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8430B378822
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 19:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622325; cv=none; b=isLLIYJ74KI9NrPy0JrdXI3fhCjbWhvFQJtI2/LC8mx9bwMq/D2cg3NYGyE3zYPYjhXUBAi1xFBRJAHISOKwZCFLqgmq2pArEAePGMbAfUZ1QrYNULc/5ij4XN58QhO3QAA9txhY23d0/CYX8UgoJoaPsCASQvo0bcJ0V/OhHuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622325; c=relaxed/simple;
	bh=fHiPJ7NRrJ/f0HuIApo5pAz5Q0DonZmo4/4xMDXlld0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qhiK8fOO7G/3yJK33YIXgjQNTpKc6fjtiTbfaHJ5qjbrFsSXbk6ZF3acbmZn+SY+84htJEoULIggQWUVdOa0KU1FcO43Er/yQBtu079A/3+PJ2SN5WHoesmPLhT+bVEMnVBRETVlbJ2MYLQo6Ele/2diixOu2fPRWIb/UQiuj2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VZmKl6P1; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VZmKl6P1"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2dbfd4d3e7so227075866b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 12:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790622320; x=1791227120; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=718Wj5iuIMMw7nHbd3E9meZQ2CMFFpa/PUMqZXpRxz0=;
        b=VZmKl6P15Rxo9ugiaKTeNgrsppkmZ56lbyQ28n+KY1l5tJBb9zX5L42++uppUJ3xsy
         CvG+CucwmMvzlYwsjrd6+1iaP2YcThdQ62ROb+wBuql5+BlL1WlScPd7iBggUOV9vqBb
         6s+rsgRvDRGnys4gWW3BioXfnDkZTVHVy6XYZxGQQA1VnZpxT3kJ/LatpbWIDRuVIjoB
         0Z4aZVx9aR0Tc8veUbe+lC3AB1jCEeV1/ZFQ5FjRFPM6i4xk7RpwGNV69g1vtlRRcoP6
         t5jYIKMWW+IEedgjsnoHTEB0voqB2n3GXwEydIFyxFmUlfQzDLKpnk0GXho19UCpI7XX
         2vkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790622320; x=1791227120;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=718Wj5iuIMMw7nHbd3E9meZQ2CMFFpa/PUMqZXpRxz0=;
        b=X2LbO6OHvLnqWTonx7NVe5n3+ZAkpcxeP9u5eOWu4tqZlGifkoEzRQqAvTduqP2+Nv
         9jYh2I+hAy7wx483bzE2v5S0ubcX4CGSMGVUXehADcFcpz2E0xHfK0JrDsAd7wnxYJ3W
         94oq7/+MU6UJjjvtSC7rkZnTcQuDG849ISVqJVHFwkmGh026+Nrqx6Q2zXNZtD9zNr4J
         cGEsemjnxPGdJpJRP3+2adm2ovEid4oMJ8A1ECGlHg4aLRBm36Wekq2+nKzf1fYitgjN
         g02yha/lEIXD2RbP3QhFWgLiMbFebcrQ5bOn5V1YGxhT6upUFgC3901IvTW0Tb/BqPWJ
         AtVg==
X-Gm-Message-State: AFq9FYIrlGcNZ4n43IaJqqEVBBCQAHh6U77c/NpI33Fq52f0lTfZfCPm
	z+A/Ps7O6emZNbzFmY4JcBOxGp8dMi/Lb1lxbJXSVTeLRwNYgIbbUZdjlIjgNwjEh2Re8eJbM3B
	i0Q==
X-Received: from edb11.prod.google.com ([2002:a05:6402:238b:b0:6aa:ffb8:ba5])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4491:b0:6ac:692a:683f
 with SMTP id 4fb4d7f45d1cf-6ac692a6babmr3895624a12.31.1790622320191; Mon, 28
 Sep 2026 12:05:20 -0700 (PDT)
Date: Mon, 28 Sep 2026 18:58:03 +0000
In-Reply-To: <20260928185803.335307-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260928185803.335307-1-aojea@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928185803.335307-2-aojea@google.com>
Subject: [PATCH nf-next v2 2/2] selftests: netfilter: nft_queue: check the
 scope of the hook drop flush
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
v1: https://lore.kernel.org/netfilter-devel/20260926100351.2987307-2-aojea@google.com/

Changes in v2:
- rebase on nf-next; nf_queue.c gained the -o, -O and -b options, -H is
  added next to them.

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
index 7c857a2e0f34..01723c0f3e31 100755
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
2.56.0.rc1.315.gc6ed9934b7-goog

