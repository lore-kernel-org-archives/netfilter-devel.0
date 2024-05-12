Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793EA50A65;
	Sun, 12 May 2024 16:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530496; cv=none; b=uWauMvfmy5fnz2yzwYsQm5whuqspQUH3CdeQHqRnRKScIR7GLYLo+p9W3Xeopyufw9oeu7KRTtSG6ACE5iXf9PWPKJKhbh0QmNzT1hyFaAa7TOi1NZPNCa5vFDQsmuxTTfoX8/FMIfOxyNLTjg5dM6T1hBn8zBJyFGgcbEWXBbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530496; c=relaxed/simple;
	bh=tQOaYqO1oTiML+3yU0Cc3TheNftBXcY1C13+R+k/fXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W27Z6mvKkxyIbLEvrxKqizDbJ/j+oUkEy7nGoYXAy4Qmwh3bA1k729rMDtbK1fUmXj+4oiZck0qQ+AeWMz/jqUpQgHX+SZBNcBnA62qP6C97Jgvd3LxlVcDEtCv5n5MYvUTh5z8gERekzqbwHGCTZEXG6GfgJ6vm25WW84a8zEw=
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
Subject: [PATCH net-next 16/17] selftests: netfilter: add packetdrill based conntrack tests
Date: Sun, 12 May 2024 18:14:35 +0200
Message-Id: <20240512161436.168973-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Add a new test script that uses packetdrill tool to exercise conntrack
state machine.

Needs ip/ip6tables and conntrack tool (to check if we have an entry in
the expected state).

Test cases added here cover following scenarios:
1. already-acked (retransmitted) packets are not tagged as INVALID
2. RST packet coming when conntrack is already closing (FIN/CLOSE_WAIT)
  transitions conntrack to CLOSE even if the RST is not an exact match
3. RST packets with out-of-window sequence numbers are marked as INVALID
4. SYN+Challenge ACK: check that challenge ack is allowed to pass
5. Old SYN/ACK: check conntrack handles the case where SYN is answered
  with SYN/ACK for an old, previous connection attempt
6. Check SYN reception while in ESTABLISHED state generates a challenge
   ack, RST response clears 'outdated' state + next SYN retransmit gets
   us into 'SYN_RECV' conntrack state.

Tests get run twice, once with ipv4 and once with ipv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/net/netfilter/Makefile  |   2 +
 tools/testing/selftests/net/netfilter/config  |   1 +
 .../net/netfilter/nf_conntrack_packetdrill.sh |  71 +++++++++++
 .../net/netfilter/packetdrill/common.sh       |  33 +++++
 .../packetdrill/conntrack_ack_loss_stall.pkt  | 118 ++++++++++++++++++
 .../packetdrill/conntrack_inexact_rst.pkt     |  62 +++++++++
 .../packetdrill/conntrack_rst_invalid.pkt     |  59 +++++++++
 .../conntrack_syn_challenge_ack.pkt           |  44 +++++++
 .../packetdrill/conntrack_synack_old.pkt      |  51 ++++++++
 .../packetdrill/conntrack_synack_reuse.pkt    |  34 +++++
 10 files changed, 475 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nf_conntrack_packetdrill.sh
 create mode 100755 tools/testing/selftests/net/netfilter/packetdrill/common.sh
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_ack_loss_stall.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_inexact_rst.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_rst_invalid.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_old.pkt
 create mode 100644 tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index e9a6c702b8c9..47945b2b3f92 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -13,6 +13,7 @@ TEST_PROGS += conntrack_tcp_unreplied.sh
 TEST_PROGS += conntrack_sctp_collision.sh
 TEST_PROGS += conntrack_vrf.sh
 TEST_PROGS += ipvs.sh
+TEST_PROGS += nf_conntrack_packetdrill.sh
 TEST_PROGS += nf_nat_edemux.sh
 TEST_PROGS += nft_audit.sh
 TEST_PROGS += nft_concat_range.sh
@@ -45,6 +46,7 @@ $(OUTPUT)/conntrack_dump_flush: CFLAGS += $(MNL_CFLAGS)
 $(OUTPUT)/conntrack_dump_flush: LDLIBS += $(MNL_LDLIBS)
 
 TEST_FILES := lib.sh
+TEST_FILES += packetdrill
 
 TEST_INCLUDES := \
 	../lib.sh
diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing/selftests/net/netfilter/config
index 5b5b764f6cd0..63ef80ef47a4 100644
--- a/tools/testing/selftests/net/netfilter/config
+++ b/tools/testing/selftests/net/netfilter/config
@@ -86,3 +86,4 @@ CONFIG_VLAN_8021Q=m
 CONFIG_XFRM_USER=m
 CONFIG_XFRM_STATISTICS=y
 CONFIG_NET_PKTGEN=m
+CONFIG_TUN=m
diff --git a/tools/testing/selftests/net/netfilter/nf_conntrack_packetdrill.sh b/tools/testing/selftests/net/netfilter/nf_conntrack_packetdrill.sh
new file mode 100755
index 000000000000..c6fdd2079f4d
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nf_conntrack_packetdrill.sh
@@ -0,0 +1,71 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+source lib.sh
+
+checktool "conntrack --version" "run test without conntrack"
+checktool "iptables --version" "run test without iptables"
+checktool "ip6tables --version" "run test without ip6tables"
+
+modprobe -q tun
+modprobe -q nf_conntrack
+# echo 1 > /proc/sys/net/netfilter/nf_log_all_netns
+
+PDRILL_TIMEOUT=10
+
+files="
+conntrack_ack_loss_stall.pkt
+conntrack_inexact_rst.pkt
+conntrack_syn_challenge_ack.pkt
+conntrack_synack_old.pkt
+conntrack_synack_reuse.pkt
+conntrack_rst_invalid.pkt
+"
+
+if ! packetdrill --dry_run --verbose "packetdrill/conntrack_ack_loss_stall.pkt";then
+	echo "SKIP: packetdrill not installed"
+	exit ${ksft_skip}
+fi
+
+ret=0
+
+run_packetdrill()
+{
+	filename="$1"
+	ipver="$2"
+	local mtu=1500
+
+	export NFCT_IP_VERSION="$ipver"
+
+	if [ "$ipver" = "ipv4" ];then
+		export xtables="iptables"
+	elif [ "$ipver" = "ipv6" ];then
+		export xtables="ip6tables"
+		mtu=1520
+	fi
+
+	timeout "$PDRILL_TIMEOUT" unshare -n packetdrill --ip_version="$ipver" --mtu=$mtu \
+		--tolerance_usecs=1000000 --non_fatal packet "$filename"
+}
+
+run_one_test_file()
+{
+	filename="$1"
+
+	for v in ipv4 ipv6;do
+		printf "%-50s(%s)%-20s" "$filename" "$v" ""
+		if run_packetdrill packetdrill/"$f" "$v";then
+			echo OK
+		else
+			echo FAIL
+			ret=1
+		fi
+	done
+}
+
+echo "Replaying packetdrill test cases:"
+for f in $files;do
+	run_one_test_file packetdrill/"$f"
+done
+
+exit $ret
diff --git a/tools/testing/selftests/net/netfilter/packetdrill/common.sh b/tools/testing/selftests/net/netfilter/packetdrill/common.sh
new file mode 100755
index 000000000000..ed36d535196d
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/packetdrill/common.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# for debugging set net.netfilter.nf_log_all_netns=1 in init_net
+# or do not use net namespaces.
+modprobe -q nf_conntrack
+sysctl -q net.netfilter.nf_conntrack_log_invalid=6
+
+# Flush old cached data (fastopen cookies).
+ip tcp_metrics flush all > /dev/null 2>&1
+
+# TCP min, default, and max receive and send buffer sizes.
+sysctl -q net.ipv4.tcp_rmem="4096 540000 $((15*1024*1024))"
+sysctl -q net.ipv4.tcp_wmem="4096 $((256*1024)) 4194304"
+
+# TCP congestion control.
+sysctl -q net.ipv4.tcp_congestion_control=cubic
+
+# TCP slow start after idle.
+sysctl -q net.ipv4.tcp_slow_start_after_idle=0
+
+# TCP Explicit Congestion Notification (ECN)
+sysctl -q net.ipv4.tcp_ecn=0
+
+sysctl -q net.ipv4.tcp_notsent_lowat=4294967295 > /dev/null 2>&1
+
+# Override the default qdisc on the tun device.
+# Many tests fail with timing errors if the default
+# is FQ and that paces their flows.
+tc qdisc add dev tun0 root pfifo
+
+# Enable conntrack
+$xtables -A INPUT -m conntrack --ctstate NEW -p tcp --syn
diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_ack_loss_stall.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_ack_loss_stall.pkt
new file mode 100644
index 000000000000..d755bd64c54f
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_ack_loss_stall.pkt
@@ -0,0 +1,118 @@
+// check that already-acked (retransmitted) packet is let through rather
+// than tagged as INVALID.
+
+`packetdrill/common.sh`
+
+// should set -P DROP but it disconnects VM w.o. extra netns
++0 `$xtables -A INPUT -m conntrack --ctstate INVALID -j DROP`
+
++0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
++0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
++0 bind(3, ..., ...) = 0
++0 listen(3, 10) = 0
+
++0 < S 0:0(0) win 32792 <mss 1000>
++0 > S. 0:0(0) ack 1 <mss 1460>
++.01 < . 1:1(0) ack 1 win 65535
++0 accept(3, ..., ...) = 4
+
++0.0001 < P. 1:1461(1460) ack 1 win 257
++.0 > . 1:1(0) ack 1461 win 65535
++0.0001 < P. 1461:2921(1460) ack 1 win 257
++.0 > . 1:1(0) ack 2921 win 65535
++0.0001 < P. 2921:4381(1460) ack 1 win 257
++.0 > . 1:1(0) ack 4381 win 65535
++0.0001 < P. 4381:5841(1460) ack 1 win 257
++.0 > . 1:1(0) ack 5841 win 65535
++0.0001 < P. 5841:7301(1460) ack 1 win 257
++.0 > . 1:1(0) ack 7301 win 65535
++0.0001 < P. 7301:8761(1460) ack 1 win 257
++.0 > . 1:1(0) ack 8761 win 65535
++0.0001 < P. 8761:10221(1460) ack 1 win 257
++.0 > . 1:1(0) ack 10221 win 65535
++0.0001 < P. 10221:11681(1460) ack 1 win 257
++.0 > . 1:1(0) ack 11681 win 65535
++0.0001 < P. 11681:13141(1460) ack 1 win 257
++.0 > . 1:1(0) ack 13141 win 65535
++0.0001 < P. 13141:14601(1460) ack 1 win 257
++.0 > . 1:1(0) ack 14601 win 65535
++0.0001 < P. 14601:16061(1460) ack 1 win 257
++.0 > . 1:1(0) ack 16061 win 65535
++0.0001 < P. 16061:17521(1460) ack 1 win 257
++.0 > . 1:1(0) ack 17521 win 65535
++0.0001 < P. 17521:18981(1460) ack 1 win 257
++.0 > . 1:1(0) ack 18981 win 65535
++0.0001 < P. 18981:20441(1460) ack 1 win 257
++.0 > . 1:1(0) ack 20441 win 65535
++0.0001 < P. 20441:21901(1460) ack 1 win 257
++.0 > . 1:1(0) ack 21901 win 65535
++0.0001 < P. 21901:23361(1460) ack 1 win 257
++.0 > . 1:1(0) ack 23361 win 65535
++0.0001 < P. 23361:24821(1460) ack 1 win 257
+0.055 > . 1:1(0) ack 24821 win 65535
++0.0001 < P. 24821:26281(1460) ack 1 win 257
++.0 > . 1:1(0) ack 26281 win 65535
++0.0001 < P. 26281:27741(1460) ack 1 win 257
++.0 > . 1:1(0) ack 27741 win 65535
++0.0001 < P. 27741:29201(1460) ack 1 win 257
++.0 > . 1:1(0) ack 29201 win 65535
++0.0001 < P. 29201:30661(1460) ack 1 win 257
++.0 > . 1:1(0) ack 30661 win 65535
++0.0001 < P. 30661:32121(1460) ack 1 win 257
++.0 > . 1:1(0) ack 32121 win 65535
++0.0001 < P. 32121:33581(1460) ack 1 win 257
++.0 > . 1:1(0) ack 33581 win 65535
++0.0001 < P. 33581:35041(1460) ack 1 win 257
++.0 > . 1:1(0) ack 35041 win 65535
++0.0001 < P. 35041:36501(1460) ack 1 win 257
++.0 > . 1:1(0) ack 36501 win 65535
++0.0001 < P. 36501:37961(1460) ack 1 win 257
++.0 > . 1:1(0) ack 37961 win 65535
++0.0001 < P. 37961:39421(1460) ack 1 win 257
++.0 > . 1:1(0) ack 39421 win 65535
++0.0001 < P. 39421:40881(1460) ack 1 win 257
++.0 > . 1:1(0) ack 40881 win 65535
++0.0001 < P. 40881:42341(1460) ack 1 win 257
++.0 > . 1:1(0) ack 42341 win 65535
++0.0001 < P. 42341:43801(1460) ack 1 win 257
++.0 > . 1:1(0) ack 43801 win 65535
++0.0001 < P. 43801:45261(1460) ack 1 win 257
++.0 > . 1:1(0) ack 45261 win 65535
++0.0001 < P. 45261:46721(1460) ack 1 win 257
++.0 > . 1:1(0) ack 46721 win 65535
++0.0001 < P. 46721:48181(1460) ack 1 win 257
++.0 > . 1:1(0) ack 48181 win 65535
++0.0001 < P. 48181:49641(1460) ack 1 win 257
++.0 > . 1:1(0) ack 49641 win 65535
++0.0001 < P. 49641:51101(1460) ack 1 win 257
++.0 > . 1:1(0) ack 51101 win 65535
++0.0001 < P. 51101:52561(1460) ack 1 win 257
++.0 > . 1:1(0) ack 52561 win 65535
++0.0001 < P. 52561:54021(1460) ack 1 win 257
++.0 > . 1:1(0) ack 54021 win 65535
++0.0001 < P. 54021:55481(1460) ack 1 win 257
++.0 > . 1:1(0) ack 55481 win 65535
++0.0001 < P. 55481:56941(1460) ack 1 win 257
++.0 > . 1:1(0) ack 56941 win 65535
++0.0001 < P. 56941:58401(1460) ack 1 win 257
++.0 > . 1:1(0) ack 58401 win 65535
++0.0001 < P. 58401:59861(1460) ack 1 win 257
++.0 > . 1:1(0) ack 59861 win 65535
++0.0001 < P. 59861:61321(1460) ack 1 win 257
++.0 > . 1:1(0) ack 61321 win 65535
++0.0001 < P. 61321:62781(1460) ack 1 win 257
++.0 > . 1:1(0) ack 62781 win 65535
++0.0001 < P. 62781:64241(1460) ack 1 win 257
++.0 > . 1:1(0) ack 64241 win 65535
++0.0001 < P. 64241:65701(1460) ack 1 win 257
++.0 > . 1:1(0) ack 65701 win 65535
++0.0001 < P. 65701:67161(1460) ack 1 win 257
++.0 > . 1:1(0) ack 67161 win 65535
+
+// nf_ct_proto_6: SEQ is under the lower bound (already ACKed data retransmitted) IN=tun0 OUT= MAC= SRC=192.0.2.1 DST=192.168.24.72 LEN=1500 TOS=0x00 PREC=0x00 TTL=255 ID=0 PROTO=TCP SPT=34375 DPT=8080 SEQ=1 ACK=4162510439 WINDOW=257 RES=0x00 ACK PSH URGP=0
++0.0001 < P. 1:1461(1460) ack 1 win 257
+
+// only sent if above packet isn't flagged as invalid
++.0 > . 1:1(0) ack 67161 win 65535
+
++0 `$xtables -D INPUT -m conntrack --ctstate INVALID -j DROP`
diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_inexact_rst.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_inexact_rst.pkt
new file mode 100644
index 000000000000..dccdd4c009c6
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_inexact_rst.pkt
@@ -0,0 +1,62 @@
+// check RST packet that doesn't exactly match expected next sequence
+// number still transitions conntrack state to CLOSE iff its already in
+// FIN/CLOSE_WAIT.
+
+`packetdrill/common.sh`
+
+//  5.771921 server_ip > client_ip TLSv1.2 337 [Packet size limited during capture]
+//  5.771994 server_ip > client_ip TLSv1.2 337 [Packet size limited during capture]
+//  5.772212 client_ip > server_ip TCP 66 45020 > 443 [ACK] Seq=1905874048 Ack=781810658 Win=36352 Len=0 TSval=3317842872 TSecr=675936334
+//  5.787924 server_ip > client_ip TLSv1.2 1300 [Packet size limited during capture]
+//  5.788126 server_ip > client_ip TLSv1.2 90 Application Data
+//  5.788207 server_ip > client_ip TCP 66 443 > 45020 [FIN, ACK] Seq=781811916 Ack=1905874048 Win=31104 Len=0 TSval=675936350 TSecr=3317842872
+//  5.788447 client_ip > server_ip TLSv1.2 90 Application Data
+//  5.788479 client_ip > server_ip TCP 66 45020 > 443 [RST, ACK] Seq=1905874072 Ack=781811917 Win=39040 Len=0 TSval=3317842889 TSecr=675936350
+//  5.788581 server_ip > client_ip TCP 54 8443 > 45020 [RST] Seq=781811892 Win=0 Len=0
+
++0 `iptables -A INPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
++0 `iptables -A OUTPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
+
++0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
++0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
+
+0.1 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
+
+0.1 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 8>
+
++0.1 < S. 1:1(0) ack 1 win 65535 <mss 1460>
+
++0 > . 1:1(0) ack 1 win 65535
++0 < . 1:1001(1000) ack 1 win 65535
++0 < . 1001:2001(1000) ack 1 win 65535
++0 < . 2001:3001(1000) ack 1 win 65535
+
++0 > . 1:1(0) ack 1001 win 65535
++0 > . 1:1(0) ack 2001 win 65535
++0 > . 1:1(0) ack 3001 win 65535
+
++0 write(3, ..., 1000) = 1000
+
++0.0 > P. 1:1001(1000) ack 3001 win 65535
+
++0.1 read(3, ..., 1000) = 1000
+
+// Conntrack should move to FIN_WAIT, then CLOSE_WAIT.
++0 < F. 3001:3001(0) ack 1001 win 65535
++0 >  . 1001:1001(0) ack 3002 win 65535
+
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q CLOSE_WAIT`
+
++1 close(3) = 0
+// RST: unread data. FIN was seen, hence ack + 1
++0 > R. 1001:1001(0) ack 3002 win 65535
+// ... and then, CLOSE.
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q CLOSE\ `
+
+// Spurious RST from peer -- no sk state.  Should NOT get
+// marked INVALID, because conntrack is already closing.
++0.1 < R 2001:2001(0) win 0
+
+// No packets should have been marked INVALID
++0 `iptables -v -S INPUT  | grep INVALID | grep -q -- "-c 0 0"`
++0 `iptables -v -S OUTPUT | grep INVALID | grep -q -- "-c 0 0"`
diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_rst_invalid.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_rst_invalid.pkt
new file mode 100644
index 000000000000..686f18a3d9ef
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_rst_invalid.pkt
@@ -0,0 +1,59 @@
+// check that out of window resets are marked as INVALID and conntrack remains
+// in ESTABLISHED state.
+
+`packetdrill/common.sh`
+
++0 `$xtables -A INPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
++0 `$xtables -A OUTPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
+
++0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
++0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
+
+0.1 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
+
+0.1 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 8>
+
++0.1 < S. 1:1(0) ack 1 win 65535 <mss 1460>
+
++0 > . 1:1(0) ack 1 win 65535
++0 < . 1:1001(1000) ack 1 win 65535
++0 < . 1001:2001(1000) ack 1 win 65535
++0 < . 2001:3001(1000) ack 1 win 65535
+
++0 > . 1:1(0) ack 1001 win 65535
++0 > . 1:1(0) ack 2001 win 65535
++0 > . 1:1(0) ack 3001 win 65535
+
++0 write(3, ..., 1000) = 1000
+
+// out of window
++0.0 < R	0:0(0)	win 0
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q ESTABLISHED`
+
+// out of window
++0.0 < R	1000000:1000000(0)	win 0
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q ESTABLISHED`
+
+// in-window but not exact match
++0.0 < R	42:42(0)	win 0
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q ESTABLISHED`
+
++0.0 > P. 1:1001(1000) ack 3001 win 65535
+
++0.1 read(3, ..., 1000) = 1000
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q ESTABLISHED`
+
++0 < . 3001:3001(0) ack 1001 win 65535
+
++0.0 < R. 3000:3000(0) ack 1001 win 0
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q ESTABLISHED`
+
+// exact next sequence
++0.0 < R. 3001:3001(0) ack 1001 win 0
+// Conntrack should move to CLOSE
+
+// Expect four invalid RSTs
++0 `$xtables -v -S INPUT  | grep INVALID | grep -q -- "-c 4 "`
++0 `$xtables -v -S OUTPUT | grep INVALID | grep -q -- "-c 0 0"`
+
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null |grep -q CLOSE\ `
diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
new file mode 100644
index 000000000000..3442cd29bc93
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_syn_challenge_ack.pkt
@@ -0,0 +1,44 @@
+// Check connection re-use, i.e. peer that receives the SYN answers with
+// a challenge-ACK.
+// Check that conntrack lets all packets pass, including the challenge ack,
+// and that a new connection is established.
+
+`packetdrill/common.sh`
+
+// S  >
+//  . < (challnge-ack)
+// R. >
+// S  >
+// S. <
+// Expected outcome: established connection.
+
++0 `$xtables -A INPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
++0 `$xtables -A OUTPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
+
++0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
++0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
+
+0.1 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
+0.1 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 8>
+
+// Challenge ACK, old incarnation.
+0.1 < . 145824453:145824453(0) ack 643160523 win 240 <mss 1460,nop,nop,TS val 1 ecr 1,nop,wscale 0>
+
++0.01 > R 643160523:643160523(0) win 0
+
++0.01 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep UNREPLIED | grep -q SYN_SENT`
+
+// Must go through.
++0.01 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 8>
+
+// correct synack
++0.1 < S. 0:0(0) ack 1 win 250 <mss 1460,nop,nop,TS val 1 ecr 1,nop,wscale 0>
+
+// 3whs completes.
++0.01 > . 1:1(0) ack 1 win 256 <nop,nop,TS val 1 ecr 1>
+
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep ESTABLISHED | grep -q ASSURED`
+
+// No packets should have been marked INVALID
++0 `$xtables -v -S INPUT  | grep INVALID | grep -q -- "-c 0 0"`
++0 `$xtables -v -S OUTPUT | grep INVALID | grep -q -- "-c 0 0"`
diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_old.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_old.pkt
new file mode 100644
index 000000000000..3047160c4bf3
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_old.pkt
@@ -0,0 +1,51 @@
+// Check conntrack copes with syn/ack reply for a previous, old incarnation.
+
+// tcpdump with buggy sequence
+// 10.176.25.8.829 > 10.192.171.30.2049: Flags [S], seq 2375731741, win 29200, options [mss 1460,sackOK,TS val 2083107423 ecr 0,nop,wscale 7], length 0
+// OLD synack, for old/previous S
+// 10.192.171.30.2049 > 10.176.25.8.829: Flags [S.], seq 145824453, ack 643160523, win 65535, options [mss 8952,nop,wscale 5,TS val 3215437785 ecr 2082921663,nop,nop], length 0
+// This reset never makes it to the endpoint, elided in the packetdrill script
+// 10.192.171.30.2049 > 10.176.25.8.829: Flags [R.], seq 1, ack 1, win 65535, options [mss 8952,nop,wscale 5,TS val 3215443451 ecr 2082921663,nop,nop], length 0
+// Syn retransmit, no change
+// 10.176.25.8.829 > 10.192.171.30.2049: Flags [S], seq 2375731741, win 29200, options [mss 1460,sackOK,TS val 2083115583 ecr 0,nop,wscale 7], length 0
+// CORRECT synack, should be accepted, but conntrack classified this as INVALID:
+// SEQ is over the upper bound (over the window of the receiver) IN=tun0 OUT= MAC= SRC=192.0.2.1 DST=192.168.37.78 LEN=40 TOS=0x00 PREC=0x00 TTL=255 ID=0 PROTO=TCP SPT=8080 DPT=34500 SEQ=162602411 ACK=2124350315 ..
+// 10.192.171.30.2049 > 10.176.25.8.829: Flags [S.], seq 162602410, ack 2375731742, win 65535, options [mss 8952,nop,wscale 5,TS val 3215445754 ecr 2083115583,nop,nop], length 0
+
+`packetdrill/common.sh`
+
++0 `$xtables -A INPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
++0 `$xtables -A OUTPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
+
++0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
++0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
+
+0.1 connect(3, ..., ...) = -1 EINPROGRESS (Operation now in progress)
+0.1 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1 ecr 0,nop,wscale 8>
+
+// bogus/outdated synack, invalid ack value
+0.1 < S. 145824453:145824453(0) ack 643160523 win 240 <mss 1440,nop,nop,TS val 1 ecr 1,nop,wscale 0>
+
+// syn retransmitted
+1.01 > S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1015 ecr 0,nop,wscale 8>
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep UNREPLIED | grep -q SYN_SENT`
+
+// correct synack
++0 < S. 145758918:145758918(0) ack 1 win 250 <mss 1460,nop,nop,TS val 1 ecr 1,nop,wscale 0>
++0 write(3, ..., 1) = 1
+
+// with buggy conntrack above packet is dropped, so SYN rtx is seen:
+// script packet:  1.054007 . 1:1(0) ack 16777958 win 256 <nop,nop,TS val 1033 ecr 1>
+// actual packet:  3.010000 S 0:0(0) win 65535 <mss 1460,sackOK,TS val 1015 ecr 0,nop,wscale 8>
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep ESTABLISHED | grep -q ASSURED`
+
++0 > P. 1:2(1) ack 4294901762 win 256 <nop,nop,TS val 1067 ecr 1>
+
++0 `conntrack -f $NFCT_IP_VERSION -L -p tcp --dport 8080 2>/dev/null | grep ASSURED | grep -q ESTABLISHED`
+
+// No packets should have been marked INVALID in OUTPUT direction, 1 in INPUT
++0 `$xtables -v -S OUTPUT | grep INVALID | grep -q -- "-c 0 0"`
++0 `$xtables -v -S INPUT  | grep INVALID | grep -q -- "-c 1 "`
+
++0 `$xtables -D INPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
++0 `$xtables -D OUTPUT -p tcp -m conntrack --ctstate INVALID -j DROP`
diff --git a/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt
new file mode 100644
index 000000000000..21e1bb6395e4
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/packetdrill/conntrack_synack_reuse.pkt
@@ -0,0 +1,34 @@
+// Check reception of another SYN while we have an established conntrack state.
+// Challenge ACK is supposed to pass through, RST reply should clear conntrack
+// state and SYN retransmit should give us new 'SYN_RECV' connection state.
+
+`packetdrill/common.sh`
+
+// should show a match if bug is present:
++0 `iptables -A INPUT -m conntrack --ctstate INVALID -p tcp --tcp-flags SYN,ACK SYN,ACK`
+
++0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
++0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
++0 bind(3, ..., ...) = 0
++0 listen(3, 10) = 0
+
++0 < S 0:0(0) win 32792 <mss 1000,nop,wscale 7, TS val 1 ecr 0,nop,nop>
++0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,TS val 100 ecr 1,nop,wscale 8>
++.01 < . 1:1(0) ack 1 win 257 <TS val 1 ecr 100,nop,nop>
++0 accept(3, ..., ...) = 4
+
++0 < P. 1:101(100) ack 1 win 257 <TS val 2 ecr 100,nop,nop>
++.001 > . 1:1(0) ack 101 win 256 <nop,nop,TS val 110 ecr 2>
++0 read(4, ..., 101) = 100
+
+1.0 < S 2000:2000(0) win 32792 <mss 1000,nop,wscale 7, TS val 233 ecr 0,nop,nop>
+// Won't expect this: challenge ack.
+
++0 > . 1:1(0) ack 101 win 256 <nop,nop,TS val 112 ecr 2>
++0 < R. 101:101(0) ack 1 win 257
++0 close(4) = 0
+
+1.5 < S 2000:2000(0) win 32792 <mss 1000,nop,wscale 0, TS val 233 ecr 0,nop,nop>
+
++0 `conntrack -L -p tcp --dport 8080 2>/dev/null | grep -q SYN_RECV`
++0 `iptables -v -S INPUT | grep INVALID | grep -q -- "-c 0 0"`
-- 
2.30.2

