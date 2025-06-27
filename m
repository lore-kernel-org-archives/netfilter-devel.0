Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EED52E266E
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2025 14:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034501; cv=none; b=dvF03mrGKlaqUR1o0tUIo1hjInTP+bQcle8go35vCg0k79GsbtSJAvAxfZXO0xUSuRjSsZOD3Pm8cOsd6/gn+SxfGbQICaj5CIzGE0cTtNQ7Rr9exJTM0OI85idoQUsPA7FAszjy8eiN7g1G62/U4E4iDbaP1gcwNc8lCuyYxis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034501; c=relaxed/simple;
	bh=SfLifNmEBeQUmYm3FF3weFVTQKWVD8VxjdRqDJDXi5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wr9WiXHsJa+jb5TasEaxoFK2FBvKwjrdz2zJGUM/3X6YflEHWdkk9X5IdiDudhvLepBFoDMVDJaevrQV2LZV6nP0uffP+r+fAWI5RdlSmOgMkiXNcVEcrfhwNckLH5T8QseGJyXFx+xAYAD1XfaOrjnaZ8FpWXR5MSSumDjhhuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D53DD608B7; Fri, 27 Jun 2025 16:28:16 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/4] selftests: netfilter: add conntrack clash resolution test case
Date: Fri, 27 Jun 2025 16:27:51 +0200
Message-ID: <20250627142758.25664-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250627142758.25664-1-fw@strlen.de>
References: <20250627142758.25664-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a dedicated test to exercise conntrack clash resolution path.
Test program emits 128 identical udp packets in parallel, then reads
back replies from socat echo server.

Also check (via conntrack -S) that the clash path was hit at least once.
Due to the racy nature of the test its possible that despite the
threaded program all packets were processed in-order or on same cpu,
emit a SKIP warning in this case.

Two tests are added:
 - one to test the simpler, non-nat case
 - one to exercise clash resolution where packets
   might have different nat transformations attached to them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/.gitignore        |   1 +
 .../testing/selftests/net/netfilter/Makefile  |   3 +
 .../net/netfilter/conntrack_clash.sh          | 175 ++++++++++++++++++
 .../selftests/net/netfilter/udpclash.c        | 158 ++++++++++++++++
 4 files changed, 337 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_clash.sh
 create mode 100644 tools/testing/selftests/net/netfilter/udpclash.c

diff --git a/tools/testing/selftests/net/netfilter/.gitignore b/tools/testing/selftests/net/netfilter/.gitignore
index 64c4f8d9aa6c..5d2be9a00627 100644
--- a/tools/testing/selftests/net/netfilter/.gitignore
+++ b/tools/testing/selftests/net/netfilter/.gitignore
@@ -5,3 +5,4 @@ conntrack_dump_flush
 conntrack_reverse_clash
 sctp_collision
 nf_queue
+udpclash
diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index e9b2f553588d..a98ed892f55f 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -15,6 +15,7 @@ TEST_PROGS += conntrack_tcp_unreplied.sh
 TEST_PROGS += conntrack_resize.sh
 TEST_PROGS += conntrack_sctp_collision.sh
 TEST_PROGS += conntrack_vrf.sh
+TEST_PROGS += conntrack_clash.sh
 TEST_PROGS += conntrack_reverse_clash.sh
 TEST_PROGS += ipvs.sh
 TEST_PROGS += nf_conntrack_packetdrill.sh
@@ -44,6 +45,7 @@ TEST_GEN_FILES += connect_close nf_queue
 TEST_GEN_FILES += conntrack_dump_flush
 TEST_GEN_FILES += conntrack_reverse_clash
 TEST_GEN_FILES += sctp_collision
+TEST_GEN_FILES += udpclash
 
 include ../../lib.mk
 
@@ -52,6 +54,7 @@ $(OUTPUT)/nf_queue: LDLIBS += $(MNL_LDLIBS)
 
 $(OUTPUT)/conntrack_dump_flush: CFLAGS += $(MNL_CFLAGS)
 $(OUTPUT)/conntrack_dump_flush: LDLIBS += $(MNL_LDLIBS)
+$(OUTPUT)/udpclash: LDLIBS += -lpthread
 
 TEST_FILES := lib.sh
 TEST_FILES += packetdrill
diff --git a/tools/testing/selftests/net/netfilter/conntrack_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
new file mode 100755
index 000000000000..3712c1b9b38b
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
@@ -0,0 +1,175 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source lib.sh
+
+clash_resolution_active=0
+dport=22111
+ret=0
+
+cleanup()
+{
+	# netns cleanup also zaps any remaining socat echo server.
+	cleanup_all_ns
+}
+
+checktool "nft --version" "run test without nft"
+checktool "conntrack --version" "run test without conntrack"
+checktool "socat -h" "run test without socat"
+
+trap cleanup EXIT
+
+setup_ns nsclient1 nsclient2 nsrouter
+
+ip netns exec "$nsrouter" nft -f -<<EOF
+table ip t {
+	chain lb {
+		meta l4proto udp dnat to numgen random mod 3 map { 0 : 10.0.2.1 . 9000, 1 : 10.0.2.1 . 9001, 2 : 10.0.2.1 . 9002 }
+	}
+
+	chain prerouting {
+		type nat hook prerouting priority dstnat
+
+		udp dport $dport counter jump lb
+	}
+
+	chain output {
+		type nat hook output priority dstnat
+
+		udp dport $dport counter jump lb
+	}
+}
+EOF
+
+load_simple_ruleset()
+{
+ip netns exec "$1" nft -f -<<EOF
+table ip t {
+	chain forward {
+		type filter hook forward priority 0
+
+		ct state new counter
+	}
+}
+EOF
+}
+
+spawn_servers()
+{
+	local ns="$1"
+	local ports="9000 9001 9002"
+
+	for port in $ports; do
+		ip netns exec "$ns" socat UDP-RECVFROM:$port,fork PIPE 2>/dev/null &
+	done
+
+	for port in $ports; do
+		wait_local_port_listen "$ns" $port udp
+	done
+}
+
+add_addr()
+{
+	local ns="$1"
+	local dev="$2"
+	local i="$3"
+	local j="$4"
+
+	ip -net "$ns" link set "$dev" up
+	ip -net "$ns" addr add "10.0.$i.$j/24" dev "$dev"
+}
+
+ping_test()
+{
+	local ns="$1"
+	local daddr="$2"
+
+	if ! ip netns exec "$ns" ping -q -c 1 $daddr > /dev/null;then
+		echo "FAIL: ping from $ns to $daddr"
+		exit 1
+	fi
+}
+
+run_one_clash_test()
+{
+	local ns="$1"
+	local daddr="$2"
+	local dport="$3"
+	local entries
+	local cre
+
+	if ! ip netns exec "$ns" ./udpclash $daddr $dport;then
+		echo "FAIL: did not receive expected number of replies for $daddr:$dport"
+		ret=1
+		return 1
+	fi
+
+	entries=$(conntrack -S | wc -l)
+	cre=$(conntrack -S | grep -v "clash_resolve=0" | wc -l)
+
+	if [ "$cre" -ne "$entries" ] ;then
+		clash_resolution_active=1
+		return 0
+	fi
+
+	# 1 cpu -> parallel insertion impossible
+	if [ "$entries" -eq 1 ]; then
+		return 0
+	fi
+
+	# not a failure: clash resolution logic did not trigger, but all replies
+	# were received.  With right timing, xmit completed sequentially and
+	# no parallel insertion occurs.
+	return $ksft_skip
+}
+
+run_clash_test()
+{
+	local ns="$1"
+	local daddr="$2"
+	local dport="$3"
+
+	for i in $(seq 1 10);do
+		run_one_clash_test "$ns" "$daddr" "$dport"
+		local rv=$?
+		if [ $rv -eq 0 ];then
+			echo "PASS: clash resolution test for $daddr:$dport on attempt $i"
+			return 0
+		elif [ $rv -eq 1 ];then
+			echo "FAIL: clash resolution test for $daddr:$dport on attempt $i"
+			return 1
+		fi
+	done
+}
+
+ip link add veth0 netns "$nsclient1" type veth peer name veth0 netns "$nsrouter"
+ip link add veth0 netns "$nsclient2" type veth peer name veth1 netns "$nsrouter"
+add_addr "$nsclient1" veth0 1 1
+add_addr "$nsclient2" veth0 2 1
+add_addr "$nsrouter" veth0 1 99
+add_addr "$nsrouter" veth1 2 99
+
+ip -net "$nsclient1" route add default via 10.0.1.99
+ip -net "$nsclient2" route add default via 10.0.2.99
+ip netns exec "$nsrouter" sysctl -q net.ipv4.ip_forward=1
+
+ping_test "$nsclient1" 10.0.1.99
+ping_test "$nsclient1" 10.0.2.1
+ping_test "$nsclient2" 10.0.1.1
+
+spawn_servers "$nsclient2"
+
+# exercise clash resolution with nat:
+# nsrouter is supposed to dnat to 10.0.2.1:900{0,1,2,3}.
+run_clash_test "$nsclient1" 10.0.1.99 "$dport"
+
+# exercise clash resolution without nat.
+load_simple_ruleset "$nsclient2"
+run_clash_test "$nsclient2" 127.0.0.1 9001
+
+if [ $clash_resolution_active -eq 0 ];then
+	[ "$ret" -eq 0 ] && ret=$ksft_skip
+	echo "SKIP: Clash resolution did not trigger"
+fi
+
+exit $ret
diff --git a/tools/testing/selftests/net/netfilter/udpclash.c b/tools/testing/selftests/net/netfilter/udpclash.c
new file mode 100644
index 000000000000..85c7b906ad08
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/udpclash.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Usage: ./udpclash <IP> <PORT>
+ *
+ * Emit THREAD_COUNT UDP packets sharing the same saddr:daddr pair.
+ *
+ * This mimics DNS resolver libraries that emit A and AAAA requests
+ * in parallel.
+ *
+ * This exercises conntrack clash resolution logic added and later
+ * refined in
+ *
+ *  71d8c47fc653 ("netfilter: conntrack: introduce clash resolution on insertion race")
+ *  ed07d9a021df ("netfilter: nf_conntrack: resolve clash for matching conntracks")
+ *  6a757c07e51f ("netfilter: conntrack: allow insertion of clashing entries")
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/socket.h>
+#include <pthread.h>
+
+#define THREAD_COUNT 128
+
+struct thread_args {
+	const struct sockaddr_in *si_remote;
+	int sockfd;
+};
+
+static int wait = 1;
+
+static void *thread_main(void *varg)
+{
+	const struct sockaddr_in *si_remote;
+	const struct thread_args *args = varg;
+	static const char msg[] = "foo";
+
+	si_remote = args->si_remote;
+
+	while (wait == 1)
+		;
+
+	if (sendto(args->sockfd, msg, strlen(msg), MSG_NOSIGNAL,
+		   (struct sockaddr *)si_remote, sizeof(*si_remote)) < 0)
+		exit(111);
+
+	return varg;
+}
+
+static int run_test(int fd, const struct sockaddr_in *si_remote)
+{
+	struct thread_args thread_args = {
+		.si_remote = si_remote,
+		.sockfd = fd,
+	};
+	pthread_t *tid = calloc(THREAD_COUNT, sizeof(pthread_t));
+	unsigned int repl_count = 0, timeout = 0;
+	int i;
+
+	if (!tid) {
+		perror("calloc");
+		return 1;
+	}
+
+	for (i = 0; i < THREAD_COUNT; i++) {
+		int err = pthread_create(&tid[i], NULL, &thread_main, &thread_args);
+
+		if (err != 0) {
+			perror("pthread_create");
+			exit(1);
+		}
+	}
+
+	wait = 0;
+
+	for (i = 0; i < THREAD_COUNT; i++)
+		pthread_join(tid[i], NULL);
+
+	while (repl_count < THREAD_COUNT) {
+		struct sockaddr_in si_repl;
+		socklen_t si_repl_len = sizeof(si_repl);
+		char repl[512];
+		ssize_t ret;
+
+		ret = recvfrom(fd, repl, sizeof(repl), MSG_NOSIGNAL,
+			       (struct sockaddr *) &si_repl, &si_repl_len);
+		if (ret < 0) {
+			if (timeout++ > 5000) {
+				fputs("timed out while waiting for reply from thread\n", stderr);
+				break;
+			}
+
+			/* give reply time to pass though the stack */
+			usleep(1000);
+			continue;
+		}
+
+		if (si_repl_len != sizeof(*si_remote)) {
+			fprintf(stderr, "warning: reply has unexpected repl_len %d vs %d\n",
+				(int)si_repl_len, (int)sizeof(si_repl));
+		} else if (si_remote->sin_addr.s_addr != si_repl.sin_addr.s_addr ||
+			si_remote->sin_port != si_repl.sin_port) {
+			char a[64], b[64];
+
+			inet_ntop(AF_INET, &si_remote->sin_addr, a, sizeof(a));
+			inet_ntop(AF_INET, &si_repl.sin_addr, b, sizeof(b));
+
+			fprintf(stderr, "reply from wrong source: want %s:%d got %s:%d\n",
+				a, ntohs(si_remote->sin_port), b, ntohs(si_repl.sin_port));
+		}
+
+		repl_count++;
+	}
+
+	printf("got %d of %d replies\n", repl_count, THREAD_COUNT);
+
+	free(tid);
+
+	return repl_count == THREAD_COUNT ? 0 : 1;
+}
+
+int main(int argc, char *argv[])
+{
+	struct sockaddr_in si_local = {
+		.sin_family = AF_INET,
+	};
+	struct sockaddr_in si_remote = {
+		.sin_family = AF_INET,
+	};
+	int fd, ret;
+
+	if (argc < 3) {
+		fputs("Usage: send_udp <daddr> <dport>\n", stderr);
+		return 1;
+	}
+
+	si_remote.sin_port = htons(atoi(argv[2]));
+	si_remote.sin_addr.s_addr = inet_addr(argv[1]);
+
+	fd = socket(AF_INET, SOCK_DGRAM|SOCK_CLOEXEC|SOCK_NONBLOCK, IPPROTO_UDP);
+	if (fd < 0) {
+		perror("socket");
+		return 1;
+	}
+
+	if (bind(fd, (struct sockaddr *)&si_local, sizeof(si_local)) < 0) {
+		perror("bind");
+		return 1;
+	}
+
+	ret = run_test(fd, &si_remote);
+
+	close(fd);
+
+	return ret;
+}
-- 
2.49.0

