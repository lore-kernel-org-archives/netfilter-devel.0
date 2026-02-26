Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8E73624A1
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 14:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772115513; cv=none; b=QfVDYGhkxOpvQ2PMKXrVzzn35u0UkFtG/Ms8Y2a/zIbOyNsGiR2LzFsKbeAsGDUwckCUuIaD13GeSSXGHxgxQPYVeG5Jp5uoArGOAOiNt6eKLH/AaYgDlZ3/EvJOhNVjvReyUgMpEg0T/uy+oZJaxwdkt4lsEawmGO0VW2Q49/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772115513; c=relaxed/simple;
	bh=B3IX9lMWiTCZzGVzYS19BlJ1KlFMfWFM2opwO4AEM0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s/9Nl8Yt+SUELueJsceggeIW7qqQhsCqM5BMFaMdrsJqwS7WDVGRQkPHYXQ3OV3ti+mKp8CQb2JrjHTgqmukawpT9RdtidnPoCFTure57Dxv0ZaApLsQ8zr3vHXFmFUIUH3xGTo5MLZ2DOeJ8kC0xfj6GoRif8rzKhFkJXWs7p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2CE1C60336; Thu, 26 Feb 2026 15:18:30 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net] selftests: netfilter: nft_queue.sh: avoid flakes on debug kernels
Date: Thu, 26 Feb 2026 15:18:19 +0100
Message-ID: <20260226141823.8989-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub reports test flakes on debug kernels:
 FAIL: test_udp_gro_ct: Expected software segmentation to occur, had 23 and 17

This test assumes that the kernels nfnetlink_queue module sees N GSO
packets, segments them into M skbs and queues them to userspace for reinjection.

Hence, if M >= N, no segmentation occured.

However, its possible that this happens:
- nfnetlink_queue gets GSO packet
- segments that into n skbs
- userspace buffer is full, kernel drops the segmented skbs

-> "toqueue" counter incremented by 1, "fromqueue" is unchanged.

If this happens often enough in a single run, M >= N check triggers
incorrectly.

To solve this, allow the nf_queue.c test program to set the FAIL_OPEN
flag so that the segmented skbs bypass the queueing step in the kernel
if the receive buffer is full.

Also, reduce number of sending socat instances, decrease their priority
and increase nice value for the nf_queue program itself to reduce the
probability of overruns happening in the first place.

Fixes: 59ecffa3995e ("selftests: netfilter: nft_queue.sh: add udp fraglist gro test case")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20260218184114.0b405b72@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/nf_queue.c   | 10 ++++++++--
 tools/testing/selftests/net/netfilter/nft_queue.sh | 13 +++++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index 9e56b9d47037..116c0ca0eabb 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -18,6 +18,7 @@
 struct options {
 	bool count_packets;
 	bool gso_enabled;
+	bool failopen;
 	int verbose;
 	unsigned int queue_num;
 	unsigned int timeout;
@@ -30,7 +31,7 @@ static struct options opts;
 
 static void help(const char *p)
 {
-	printf("Usage: %s [-c|-v [-vv] ] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
+	printf("Usage: %s [-c|-v [-vv] ] [-o] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
 }
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
@@ -236,6 +237,8 @@ struct mnl_socket *open_queue(void)
 
 	flags = opts.gso_enabled ? NFQA_CFG_F_GSO : 0;
 	flags |= NFQA_CFG_F_UID_GID;
+	if (opts.failopen)
+		flags |= NFQA_CFG_F_FAIL_OPEN;
 	mnl_attr_put_u32(nlh, NFQA_CFG_FLAGS, htonl(flags));
 	mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(flags));
 
@@ -329,7 +332,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "chvt:q:Q:d:G")) != -1) {
+	while ((c = getopt(argc, argv, "chvot:q:Q:d:G")) != -1) {
 		switch (c) {
 		case 'c':
 			opts.count_packets = true;
@@ -366,6 +369,9 @@ static void parse_opts(int argc, char **argv)
 		case 'G':
 			opts.gso_enabled = false;
 			break;
+		case 'o':
+			opts.failopen = true;
+			break;
 		case 'v':
 			opts.verbose++;
 			break;
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 139bc1211878..ea766bdc5d04 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -591,6 +591,7 @@ EOF
 test_udp_gro_ct()
 {
 	local errprefix="FAIL: test_udp_gro_ct:"
+	local timeout=5
 
 	ip netns exec "$nsrouter" conntrack -F 2>/dev/null
 
@@ -630,10 +631,10 @@ table inet udpq {
 	}
 }
 EOF
-	timeout 10 ip netns exec "$ns2" socat UDP-LISTEN:12346,fork,pf=ipv4 OPEN:"$TMPFILE1",trunc &
+	timeout "$timeout" ip netns exec "$ns2" socat UDP-LISTEN:12346,fork,pf=ipv4 OPEN:"$TMPFILE1",trunc &
 	local rpid=$!
 
-	ip netns exec "$nsrouter" ./nf_queue -G -c -q 1 -t 2 > "$TMPFILE2" &
+	ip netns exec "$nsrouter" nice -n -19 ./nf_queue -G -c -q 1 -o -t 2 > "$TMPFILE2" &
 	local nfqpid=$!
 
 	ip netns exec "$nsrouter" ethtool -K "veth0" rx-udp-gro-forwarding on rx-gro-list on generic-receive-offload on
@@ -643,8 +644,12 @@ EOF
 
 	local bs=512
 	local count=$(((32 * 1024 * 1024) / bs))
-	dd if=/dev/zero bs="$bs" count="$count" 2>/dev/null | for i in $(seq 1 16); do
-		timeout 5 ip netns exec "$ns1" \
+
+	local nprocs=$(nproc)
+	[ $nprocs -gt 1 ] && nprocs=$((nprocs - 1))
+
+	dd if=/dev/zero bs="$bs" count="$count" 2>/dev/null | for i in $(seq 1 $nprocs); do
+		timeout "$timeout" nice -n 19 ip netns exec "$ns1" \
 			socat -u -b 512 STDIN UDP-DATAGRAM:10.0.2.99:12346,reuseport,bind=0.0.0.0:55221 &
 	done
 
-- 
2.52.0

