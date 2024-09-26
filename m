Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F171AE85E;
	Thu, 26 Sep 2024 11:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348855; cv=none; b=G+IEvuZvSQnPS7M+Hw79pb5kUgQxXVPkdIKytkaVvA7tkJdS+hX94f+FwUOYdZf8JG9dbNZIQNw9BtKDIv94AqueAFl1mtqt+CgQNCfP0Pn1OkclTSRmOd8O/slrQv4gsTkZOj9P3xNeHVjlx35rWDvtO7U7uqcJPxTHTMhxTY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348855; c=relaxed/simple;
	bh=XznoHcZlbLFueoOqgZlH5Nw0Gvd+zlIYBdOvi4nvDXk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ata0LuAyvpZkS3m6zUORPz5oVp0QXdgdN5yEyGf6quzzRA60jXAz+mM7Fl937lTLrEbbE9ha1JLKZxyoBEGchP/ylNmYSBz244qwO8yEhDJId37GnK8Em4PHAadhOExsK+no7jrz3I/hJO58V+RG45Su4AmqEmcWrTlBfcA7ooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 03/14] selftests: netfilter: add reverse-clash resolution test case
Date: Thu, 26 Sep 2024 13:07:06 +0200
Message-Id: <20240926110717.102194-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Add test program that is sending UDP packets in both directions
and check that packets arrive without source port modification.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/net/netfilter/Makefile  |   2 +
 .../net/netfilter/conntrack_reverse_clash.c   | 125 ++++++++++++++++++
 .../net/netfilter/conntrack_reverse_clash.sh  |  51 +++++++
 3 files changed, 178 insertions(+)
 create mode 100644 tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index d13fb5ea3e89..98535c60b195 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -13,6 +13,7 @@ TEST_PROGS += conntrack_ipip_mtu.sh
 TEST_PROGS += conntrack_tcp_unreplied.sh
 TEST_PROGS += conntrack_sctp_collision.sh
 TEST_PROGS += conntrack_vrf.sh
+TEST_PROGS += conntrack_reverse_clash.sh
 TEST_PROGS += ipvs.sh
 TEST_PROGS += nf_conntrack_packetdrill.sh
 TEST_PROGS += nf_nat_edemux.sh
@@ -36,6 +37,7 @@ TEST_GEN_PROGS = conntrack_dump_flush
 
 TEST_GEN_FILES = audit_logread
 TEST_GEN_FILES += connect_close nf_queue
+TEST_GEN_FILES += conntrack_reverse_clash
 TEST_GEN_FILES += sctp_collision
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
new file mode 100644
index 000000000000..507930cee8cb
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Needs something like:
+ *
+ * iptables -t nat -A POSTROUTING -o nomatch -j MASQUERADE
+ *
+ * so NAT engine attaches a NAT null-binding to each connection.
+ *
+ * With unmodified kernels, child or parent will exit with
+ * "Port number changed" error, even though no port translation
+ * was requested.
+ */
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <time.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <sys/socket.h>
+#include <sys/wait.h>
+
+#define LEN 512
+#define PORT 56789
+#define TEST_TIME 5
+
+static void die(const char *e)
+{
+	perror(e);
+	exit(111);
+}
+
+static void die_port(uint16_t got, uint16_t want)
+{
+	fprintf(stderr, "Port number changed, wanted %d got %d\n", want, ntohs(got));
+	exit(1);
+}
+
+static int udp_socket(void)
+{
+	static const struct timeval tv = {
+		.tv_sec = 1,
+	};
+	int fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
+
+	if (fd < 0)
+		die("socket");
+
+	setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
+	return fd;
+}
+
+int main(int argc, char *argv[])
+{
+	struct sockaddr_in sa1 = {
+		.sin_family = AF_INET,
+	};
+	struct sockaddr_in sa2 = {
+		.sin_family = AF_INET,
+	};
+	int s1, s2, status;
+	time_t end, now;
+	socklen_t plen;
+	char buf[LEN];
+	bool child;
+
+	sa1.sin_port = htons(PORT);
+	sa2.sin_port = htons(PORT + 1);
+
+	s1 = udp_socket();
+	s2 = udp_socket();
+
+	inet_pton(AF_INET, "127.0.0.11", &sa1.sin_addr);
+	inet_pton(AF_INET, "127.0.0.12", &sa2.sin_addr);
+
+	if (bind(s1, (struct sockaddr *)&sa1, sizeof(sa1)) < 0)
+		die("bind 1");
+	if (bind(s2, (struct sockaddr *)&sa2, sizeof(sa2)) < 0)
+		die("bind 2");
+
+	child = fork() == 0;
+
+	now = time(NULL);
+	end = now + TEST_TIME;
+
+	while (now < end) {
+		struct sockaddr_in peer;
+		socklen_t plen = sizeof(peer);
+
+		now = time(NULL);
+
+		if (child) {
+			if (sendto(s1, buf, LEN, 0, (struct sockaddr *)&sa2, sizeof(sa2)) != LEN)
+				continue;
+
+			if (recvfrom(s2, buf, LEN, 0, (struct sockaddr *)&peer, &plen) < 0)
+				die("child recvfrom");
+
+			if (peer.sin_port != htons(PORT))
+				die_port(peer.sin_port, PORT);
+		} else {
+			if (sendto(s2, buf, LEN, 0, (struct sockaddr *)&sa1, sizeof(sa1)) != LEN)
+				continue;
+
+			if (recvfrom(s1, buf, LEN, 0, (struct sockaddr *)&peer, &plen) < 0)
+				die("parent recvfrom");
+
+			if (peer.sin_port != htons((PORT + 1)))
+				die_port(peer.sin_port, PORT + 1);
+		}
+	}
+
+	if (child)
+		return 0;
+
+	wait(&status);
+
+	if (WIFEXITED(status))
+		return WEXITSTATUS(status);
+
+	return 1;
+}
diff --git a/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
new file mode 100755
index 000000000000..a24c896347a8
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/conntrack_reverse_clash.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source lib.sh
+
+cleanup()
+{
+	cleanup_all_ns
+}
+
+checktool "nft --version" "run test without nft"
+checktool "conntrack --version" "run test without conntrack"
+
+trap cleanup EXIT
+
+setup_ns ns0
+
+# make loopback connections get nat null bindings assigned
+ip netns exec "$ns0" nft -f - <<EOF
+table ip nat {
+        chain POSTROUTING {
+                type nat hook postrouting priority srcnat; policy accept;
+                oifname "nomatch" counter packets 0 bytes 0 masquerade
+        }
+}
+EOF
+
+do_flush()
+{
+	local end
+	local now
+
+	now=$(date +%s)
+	end=$((now + 5))
+
+	while [ $now -lt $end ];do
+		ip netns exec "$ns0" conntrack -F 2>/dev/null
+		now=$(date +%s)
+	done
+}
+
+do_flush &
+
+if ip netns exec "$ns0" ./conntrack_reverse_clash; then
+	echo "PASS: No SNAT performed for null bindings"
+else
+	echo "ERROR: SNAT performed without any matching snat rule"
+	exit 1
+fi
+
+exit 0
-- 
2.30.2

