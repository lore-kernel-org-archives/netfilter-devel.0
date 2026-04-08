Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8793B27CA;
	Wed,  8 Apr 2026 16:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775666148; cv=none; b=LVTskgK0kVhbc13mY4Mw0xDdX9WZyJbxwZK74msq+Jh5NU8uifh2qYC7/YEtN9U71uG+P8BnTbzL0Pv3zx17A88wdgu/ZU4c45OZY0Tk6vpAvQWgRx1k9CDth0b0SXFYp6gaIG0es9hDyxDKYvEE9tny+uDp43FjMzZtlgY5bo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775666148; c=relaxed/simple;
	bh=+/rOeXhg1Ya6DR1P4O5XVmtQB/QwnQxKxP2BrEMvFko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERePwnZqvn3UY2kEKT3t7WkEFu9oC7QBaT+SvLm0totqSwWPpr80DqxvDQPGGy+gUZU4mxt4U2dymrTuDTQ/5ftc0sxOAUu1Hm+xSHVJYaFb9Mi61eeUNvtp71jgnuKf9sfR19DA1nDXktdAfSN+ASJOtM+9hOdydHbIjneSKHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B5D7460560; Wed, 08 Apr 2026 18:35:45 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 7/7] selftests: nft_queue.sh: add a parallel stress test
Date: Wed,  8 Apr 2026 18:35:12 +0200
Message-ID: <20260408163512.30537-8-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260408163512.30537-1-fw@strlen.de>
References: <20260408163512.30537-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Introduce a new stress test to check for race conditions in the
nfnetlink_queue subsystem, where an entry is freed while another CPU is
concurrently walking the global rhashtable.

To trigger this, `nf_queue.c` is extended with two new flags:
  * -O (out-of-order): Buffers packet IDs and flushes them in reverse.
  * -b (bogus verdicts): Floods the kernel with non-existent packet IDs.

The bogus verdict loop forces the kernel's lookup function to perform
full rhashtable bucket traversals (-ENOENT). Combined with reverse-order
flushing and heavy parallel UDP/ping flooding across 8 queues, this puts
the nfnetlink_queue code under pressure.

Joint work with Florian Westphal.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nf_queue.c        | 50 +++++++++--
 .../selftests/net/netfilter/nft_queue.sh      | 83 ++++++++++++++++---
 2 files changed, 115 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index 116c0ca0eabb..8bbec37f5356 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -19,6 +19,8 @@ struct options {
 	bool count_packets;
 	bool gso_enabled;
 	bool failopen;
+	bool out_of_order;
+	bool bogus_verdict;
 	int verbose;
 	unsigned int queue_num;
 	unsigned int timeout;
@@ -31,7 +33,7 @@ static struct options opts;
 
 static void help(const char *p)
 {
-	printf("Usage: %s [-c|-v [-vv] ] [-o] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
+	printf("Usage: %s [-c|-v [-vv] ] [-o] [-O] [-b] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
 }
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
@@ -275,7 +277,9 @@ static int mainloop(void)
 	unsigned int buflen = 64 * 1024 + MNL_SOCKET_BUFFER_SIZE;
 	struct mnl_socket *nl;
 	struct nlmsghdr *nlh;
+	uint32_t ooo_ids[16];
 	unsigned int portid;
+	int ooo_count = 0;
 	char *buf;
 	int ret;
 
@@ -308,6 +312,9 @@ static int mainloop(void)
 
 		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
 		if (ret < 0) {
+			/* bogus verdict mode will generate ENOENT error messages */
+			if (opts.bogus_verdict && errno == ENOENT)
+				continue;
 			perror("mnl_cb_run");
 			exit(EXIT_FAILURE);
 		}
@@ -316,10 +323,35 @@ static int mainloop(void)
 		if (opts.delay_ms)
 			sleep_ms(opts.delay_ms);
 
-		nlh = nfq_build_verdict(buf, id, opts.queue_num, opts.verdict);
-		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-			perror("mnl_socket_sendto");
-			exit(EXIT_FAILURE);
+		if (opts.bogus_verdict) {
+			for (int i = 0; i < 50; i++) {
+				nlh = nfq_build_verdict(buf, id + 0x7FFFFFFF + i,
+							opts.queue_num, opts.verdict);
+				mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
+			}
+		}
+
+		if (opts.out_of_order) {
+			ooo_ids[ooo_count] = id;
+			if (ooo_count >= 15) {
+				for (ooo_count; ooo_count >= 0; ooo_count--) {
+					nlh = nfq_build_verdict(buf, ooo_ids[ooo_count],
+								opts.queue_num, opts.verdict);
+					if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+						perror("mnl_socket_sendto");
+						exit(EXIT_FAILURE);
+					}
+				}
+				ooo_count = 0;
+			} else {
+				ooo_count++;
+			}
+		} else {
+			nlh = nfq_build_verdict(buf, id, opts.queue_num, opts.verdict);
+			if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+				perror("mnl_socket_sendto");
+				exit(EXIT_FAILURE);
+			}
 		}
 	}
 
@@ -332,7 +364,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "chvot:q:Q:d:G")) != -1) {
+	while ((c = getopt(argc, argv, "chvoObt:q:Q:d:G")) != -1) {
 		switch (c) {
 		case 'c':
 			opts.count_packets = true;
@@ -375,6 +407,12 @@ static void parse_opts(int argc, char **argv)
 		case 'v':
 			opts.verbose++;
 			break;
+		case 'O':
+			opts.out_of_order = true;
+			break;
+		case 'b':
+			opts.bogus_verdict = true;
+			break;
 		}
 	}
 
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index ea766bdc5d04..d80390848e85 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -11,6 +11,7 @@ ret=0
 timeout=5
 
 SCTP_TEST_TIMEOUT=60
+STRESS_TEST_TIMEOUT=30
 
 cleanup()
 {
@@ -719,6 +720,74 @@ EOF
 	fi
 }
 
+check_tainted()
+{
+	local msg="$1"
+
+	if [ "$tainted_then" -ne 0 ];then
+		return
+	fi
+
+	read tainted_now < /proc/sys/kernel/tainted
+	if [ "$tainted_now" -eq 0 ];then
+		echo "PASS: $msg"
+	else
+		echo "TAINT: $msg"
+		dmesg
+		ret=1
+	fi
+}
+
+test_queue_stress()
+{
+	read tainted_then < /proc/sys/kernel/tainted
+	local i
+
+        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet t {
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+
+		queue flags bypass to numgen random mod 8
+	}
+}
+EOF
+	timeout "$STRESS_TEST_TIMEOUT" ip netns exec "$ns2" \
+		socat -u UDP-LISTEN:12345,fork,pf=ipv4 STDOUT > /dev/null &
+
+	timeout "$STRESS_TEST_TIMEOUT" ip netns exec "$ns3" \
+		socat -u UDP-LISTEN:12345,fork,pf=ipv4 STDOUT > /dev/null &
+
+	for i in $(seq 0 7); do
+		ip netns exec "$nsrouter" timeout "$STRESS_TEST_TIMEOUT" \
+			./nf_queue -q $i -t 2 -O -b > /dev/null &
+	done
+
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+		ping -q -f 10.0.2.99 > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+		ping -q -f 10.0.3.99 > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+		ping -q -f "dead:2::99" > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+		ping -q -f "dead:3::99" > /dev/null 2>&1 &
+
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2" 12345
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3" 12345
+
+	for i in $(seq 1 4);do
+		ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+			socat -u STDIN UDP-DATAGRAM:10.0.2.99:12345 < /dev/zero > /dev/null &
+		ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+			socat -u STDIN UDP-DATAGRAM:10.0.3.99:12345 < /dev/zero > /dev/null &
+	done
+
+	wait
+
+	check_tainted "concurrent queueing"
+}
+
 test_queue_removal()
 {
 	read tainted_then < /proc/sys/kernel/tainted
@@ -742,18 +811,7 @@ EOF
 
 	ip netns exec "$ns1" nft flush ruleset
 
-	if [ "$tainted_then" -ne 0 ];then
-		return
-	fi
-
-	read tainted_now < /proc/sys/kernel/tainted
-	if [ "$tainted_now" -eq 0 ];then
-		echo "PASS: queue program exiting while packets queued"
-	else
-		echo "TAINT: queue program exiting while packets queued"
-		dmesg
-		ret=1
-	fi
+	check_tainted "queue program exiting while packets queued"
 }
 
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -799,6 +857,7 @@ test_sctp_forward
 test_sctp_output
 test_udp_nat_race
 test_udp_gro_ct
+test_queue_stress
 
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
-- 
2.52.0

