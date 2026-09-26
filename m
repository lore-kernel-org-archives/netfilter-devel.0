Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BE61FA272
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 10:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790417038; cv=none; b=Sj28YmYv/lrEdFaWt0nDq+2kR71NXhvUXHETYk/zHzQ0/x6G+4Ipc/YoI6Rvr+YNvygPPMHxe7IEP8NcmN69toz0nEPm9tt9MjtDITYnOy41IW0eNLkUgTV7uw1mXJeNyEbyhbdK9w5Gvh8OjIKbaWhBvVKKpltXNwlCeag6IFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790417038; c=relaxed/simple;
	bh=M3H48d42CkY8SzC+ynYgiJ/EzJPASoRzTDFwO4cNo70=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mSgn0aqQClFYpilyOB3kYcYsx98WMRrXwMk0Dv46ed9jlp+2zbzqmh6STnaPjskFv6lT85J0Pd4OhkxkBhS4ZMnpimpseXfVuWSiLHB6wiEswd2gecUkJcutsow1IqcUYimXA5++n50f9FMgQgk5PUPBTrgD49jRUPrPc8qPQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iADVJMLW; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iADVJMLW"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6aafdd5a5f6so824007a12.0
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 03:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790417034; x=1791021834; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dzpUIKP+r26MOPYzpw8R1RHhGCPwH0D8HOxi456WcCE=;
        b=iADVJMLW3rCUZOqgoNMPRjH4uEGjEjLyxr9qbpZyssvtxMY2TNYMuiDNo+ML9XfrZb
         FmExKsmldGGiTaTVB2iRELgAFNd9ex0as636H7DgF9j6DstYaaRQHhueRbzFS5zXLaOF
         RPNbAbSxHtX9HXLnDxVQXfLtvjGzt0UQX6lVsMsHYCJ+SgAsPw7WL/qiRWgq0NHitOMP
         CUAbuRig/lVRAEfTOa6SSb1e1WTmJ28N+ABfhsCkqx4kdQxIcRGBkRXo8B55gd4OtUtA
         2n7vcgcKcLZYTvVLfWxid7DbjwECTrlhdo52ZFmujpS3moyxzcj7PEYz6IsinrPk175y
         AhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790417034; x=1791021834;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dzpUIKP+r26MOPYzpw8R1RHhGCPwH0D8HOxi456WcCE=;
        b=QraKHxcYYLTGNJFgcacPp8bHp92EZsxDqEwGu/MtDGEy/s3AHJqMlzBkVVmQu7t/SX
         aozmrH6fWdPAGmaDr6m2hFF5eYGm/x8mKgDAJ1+weMV/VHvJbTz0dPlVn8tviNiv5txA
         2DzZPjG1UyqMhioHpkT36lq/WAWvfsDLFasj3hyyM1n+OXGmPDmdVDs6sneC2ek3L4PZ
         7bQfOJYxw7hncYR3zYRp3zm8LVglcBiJEmEpl4Yeckewk0JP15EVYPNIegJ7vwsWwghK
         7In0rLFYCGRSlU5Tk8aJw1rXKZ4pQ/cHmQPjDnK9RwHf+tb1VZOYvogxn9qyfQHSUsH6
         ezgA==
X-Gm-Message-State: AFuF++mR68on2qW4pKPctGqrC/4PVTWiu8Ja+RS6qW+qplMP6oh0Zt4V
	tn3KDnTU4NqwuPz7n68lmHjUVmLj2uHm1HWPZJ7ZheUXsQyC7B01mo4sKSx6LBkA1r2yk+1GXus
	k7kEYJAyMUiBBh0rAHPYy2Iz3I2/ElehmuJ5Ye+rkilicTvbqsh7faZAazT1kVAhtSpecmc6+QN
	BLCk6TRHM1ndB8/pW8GXNQPHqGbfchgpB8HfOZrPHCXVw=
X-Received: from edoy20.prod.google.com ([2002:aa7:c254:0:b0:6aa:495a:6bc1])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1f01:b0:6a7:ea54:397
 with SMTP id 4fb4d7f45d1cf-6aacc8678cfmr5901327a12.40.1790417033506; Sat, 26
 Sep 2026 03:03:53 -0700 (PDT)
Date: Sat, 26 Sep 2026 10:03:51 +0000
In-Reply-To: <araAhumrNKQ48-Re@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <araAhumrNKQ48-Re@strlen.de>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260926100351.2987307-2-aojea@google.com>
Subject: [PATCH nf-next 2/2] selftests: netfilter: nft_queue: check the scope
 of the hook drop flush
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
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
 .../selftests/net/netfilter/nf_queue.c        |  22 +++-
 .../selftests/net/netfilter/nft_queue.sh      | 108 ++++++++++++++++++
 2 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index 9e56b9d47037..07bc2b319840 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <errno.h>
+#include <signal.h>
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdint.h>
@@ -18,6 +19,7 @@
 struct options {
 	bool count_packets;
 	bool gso_enabled;
+	bool hold;
 	int verbose;
 	unsigned int queue_num;
 	unsigned int timeout;
@@ -31,6 +33,7 @@ static struct options opts;
 static void help(const char *p)
 {
 	printf("Usage: %s [-c|-v [-vv] ] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
+	printf("          [-H] (hold verdicts until SIGUSR1 is received)\n");
 }
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
@@ -273,6 +276,7 @@ static int mainloop(void)
 	struct mnl_socket *nl;
 	struct nlmsghdr *nlh;
 	unsigned int portid;
+	sigset_t hold_set;
 	char *buf;
 	int ret;
 
@@ -282,6 +286,12 @@ static int mainloop(void)
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
 
@@ -310,6 +320,13 @@ static int mainloop(void)
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
 
@@ -329,7 +346,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "chvt:q:Q:d:G")) != -1) {
+	while ((c = getopt(argc, argv, "chvt:q:Q:d:GH")) != -1) {
 		switch (c) {
 		case 'c':
 			opts.count_packets = true;
@@ -338,6 +355,9 @@ static void parse_opts(int argc, char **argv)
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
index 6136ceec45e0..89a4dd61845e 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -622,6 +622,113 @@ EOF
 	fi
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
@@ -668,5 +775,6 @@ test_udp_ct_race
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
 test_queue_removal
+test_hook_drop_scope
 
 exit $ret
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

