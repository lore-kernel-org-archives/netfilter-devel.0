Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD7C156242;
	Wed, 19 Jun 2024 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718816755; cv=none; b=ekqeEKDklDBfR/VdJXlfK7hqdGKH2bjP+IJ+2+zrQWFnrtpqWedQ6MAJsJU1gIAz+W/ltzAfSBbUiJgxg9gwpqIl5OqBujZ2U7tG5KAvdv7mPCUR2RDmh77ayWNMONE4S1/EigiFL7hBoCu7g6ziQWLp4HO39tWaqUvS/EgSvvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718816755; c=relaxed/simple;
	bh=nt1G2C3kPWJaNCi9c9dGTZBHcvPYesKvmAl9nL5WZEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GEyBDbPj0imU9gGBNOXQ/Ga1MdJOYcqWHv8DuvoP4Xvk3pkOSBxBTUJPK0Hf8Ym8DSLnual7SdWomRfAp3HCu8bw8Pc6rHW70TIAyFGF79FxUdPMD+kEEgVIMHNwsAEFzv1IBSuY5e1tMbiBEvLC26cga3BICa7GEbKnuz1y95E=
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
Subject: [PATCH net 5/5] selftests: add selftest for the SRv6 End.DX6 behavior with netfilter
Date: Wed, 19 Jun 2024 19:05:37 +0200
Message-Id: <20240619170537.2846-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240619170537.2846-1-pablo@netfilter.org>
References: <20240619170537.2846-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jianguo Wu <wujianguo@chinatelecom.cn>

this selftest is designed for evaluating the SRv6 End.DX6 behavior
used with netfilter(rpfilter), in this example, for implementing
IPv6 L3 VPN use cases.

Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/config            |   1 +
 .../net/srv6_end_dx6_netfilter_test.sh        | 340 ++++++++++++++++++
 3 files changed, 342 insertions(+)
 create mode 100755 tools/testing/selftests/net/srv6_end_dx6_netfilter_test.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 7a5f7dd320de..d9393569d03a 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -44,6 +44,7 @@ TEST_PROGS += srv6_end_next_csid_l3vpn_test.sh
 TEST_PROGS += srv6_end_x_next_csid_l3vpn_test.sh
 TEST_PROGS += srv6_end_flavors_test.sh
 TEST_PROGS += srv6_end_dx4_netfilter_test.sh
+TEST_PROGS += srv6_end_dx6_netfilter_test.sh
 TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS += arp_ndisc_evict_nocarrier.sh
 TEST_PROGS += ndisc_unsolicited_na_test.sh
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index c2766e558f92..d4891f7a2bfa 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -102,3 +102,4 @@ CONFIG_CRYPTO_ARIA=y
 CONFIG_XFRM_INTERFACE=m
 CONFIG_XFRM_USER=m
 CONFIG_IP_NF_MATCH_RPFILTER=m
+CONFIG_IP6_NF_MATCH_RPFILTER=m
diff --git a/tools/testing/selftests/net/srv6_end_dx6_netfilter_test.sh b/tools/testing/selftests/net/srv6_end_dx6_netfilter_test.sh
new file mode 100755
index 000000000000..9e69a2ed5bc3
--- /dev/null
+++ b/tools/testing/selftests/net/srv6_end_dx6_netfilter_test.sh
@@ -0,0 +1,340 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# author: Jianguo Wu <wujianguo@chinatelecom.cn>
+#
+# Mostly copied from tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh.
+#
+# This script is designed for testing the support of netfilter hooks for
+# SRv6 End.DX4 behavior.
+#
+# Hereafter a network diagram is shown, where one tenants (named 100) offer
+# IPv6 L3 VPN services allowing hosts to communicate with each other across
+# an IPv6 network.
+#
+# Routers rt-1 and rt-2 implement IPv6 L3 VPN services leveraging the SRv6
+# architecture. The key components for such VPNs are: a) SRv6 Encap behavior,
+# b) SRv6 End.DX4 behavior.
+#
+# To explain how an IPv6 L3 VPN based on SRv6 works, let us briefly consider an
+# example where, within the same domain of tenant 100, the host hs-1 pings
+# the host hs-2.
+#
+# First of all, L2 reachability of the host hs-2 is taken into account by
+# the router rt-1 which acts as an arp proxy.
+#
+# When the host hs-1 sends an IPv6 packet destined to hs-2, the router rt-1
+# receives the packet on the internal veth-t100 interface, rt-1 contains the
+# SRv6 Encap route for encapsulating the IPv6 packet in a IPv6 plus the Segment
+# Routing Header (SRH) packet. This packet is sent through the (IPv6) core
+# network up to the router rt-2 that receives it on veth0 interface.
+#
+# The rt-2 router uses the 'localsid' routing table to process incoming
+# IPv6+SRH packets which belong to the VPN of the tenant 100. For each of these
+# packets, the SRv6 End.DX4 behavior removes the outer IPv6+SRH headers and
+# routs the packet to the specified nexthop. Afterwards, the packet is sent to
+# the host hs-2 through the veth-t100 interface.
+#
+# The ping response follows the same processing but this time the role of rt-1
+# and rt-2 are swapped.
+#
+# And when net.netfilter.nf_hooks_lwtunnel is set to 1 in rt-1 or rt-2, and a
+# rpfilter iptables rule is added, SRv6 packets will go through netfilter PREROUTING
+# hooks.
+#
+#
+# +-------------------+                                   +-------------------+
+# |                   |                                   |                   |
+# |    hs-1 netns     |                                   |     hs-2 netns    |
+# |                   |                                   |                   |
+# |  +-------------+  |                                   |  +-------------+  |
+# |  |    veth0    |  |                                   |  |    veth0    |  |
+# |  | cafe::1/64  |  |                                   |  | cafe::2/64  |  |
+# |  +-------------+  |                                   |  +-------------+  |
+# |        .          |                                   |         .         |
+# +-------------------+                                   +-------------------+
+#          .                                                        .
+#          .                                                        .
+#          .                                                        .
+# +-----------------------------------+   +-----------------------------------+
+# |        .                          |   |                         .         |
+# | +---------------+                 |   |                 +---------------- |
+# | |   veth-t100   |                 |   |                 |   veth-t100   | |
+# | | cafe::11/64   |    +----------+ |   | +----------+    | cafe::22/64   | |
+# | +-------+-------+   |   route   | |   | |   route  |    +-------+-------- |
+# |                     |   table   | |   | |   table  |                      |
+# |                      +----------+ |   | +----------+                      |
+# |                  +--------------+ |   | +--------------+                  |
+# |                 |      veth0    | |   | |   veth0       |                 |
+# |                 | 2001:11::1/64 |.|...|.| 2001:11::2/64 |                 |
+# |                  +--------------+ |   | +--------------+                  |
+# |                                   |   |                                   |
+# |                        rt-1 netns |   | rt-2 netns                        |
+# |                                   |   |                                   |
+# +-----------------------------------+   +-----------------------------------+
+#
+# ~~~~~~~~~~~~~~~~~~~~~~~~~
+# | Network configuration |
+# ~~~~~~~~~~~~~~~~~~~~~~~~~
+#
+# rt-1: localsid table
+# +----------------------------------------------------------------+
+# |SID              |Action                                        |
+# +----------------------------------------------------------------+
+# |fc00:21:100::6004|apply SRv6 End.DX6 nh6 cafe::1 dev veth-t100  |
+# +----------------------------------------------------------------+
+#
+# rt-1: route table
+# +---------------------------------------------------+
+# |host       |Action                                 |
+# +---------------------------------------------------+
+# |cafe::2    |apply seg6 encap segs fc00:12:100::6004|
+# +---------------------------------------------------+
+# |cafe::/64  |forward to dev veth_t100               |
+# +---------------------------------------------------+
+#
+#
+# rt-2: localsid table
+# +---------------------------------------------------------------+
+# |SID              |Action                                       |
+# +---------------------------------------------------------------+
+# |fc00:12:100::6004|apply SRv6 End.DX6 nh6 cafe::2 dev veth-t100 |
+# +---------------------------------------------------------------+
+#
+# rt-2: route table
+# +---------------------------------------------------+
+# |host       |Action                                 |
+# +---------------------------------------------------+
+# |cafe::1    |apply seg6 encap segs fc00:21:100::6004|
+# +---------------------------------------------------+
+# |cafe::/64  |forward to dev veth_t100               |
+# +---------------------------------------------------+
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+readonly IPv6_RT_NETWORK=2001:11
+readonly IPv6_HS_NETWORK=cafe
+readonly SID_LOCATOR=fc00
+
+PING_TIMEOUT_SEC=4
+
+ret=0
+
+PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		nsuccess=$((nsuccess+1))
+		printf "\n    TEST: %-60s  [ OK ]\n" "${msg}"
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "\n    TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+}
+
+print_log_test_results()
+{
+	if [ "$TESTS" != "none" ]; then
+		printf "\nTests passed: %3d\n" ${nsuccess}
+		printf "Tests failed: %3d\n"   ${nfail}
+	fi
+}
+
+log_section()
+{
+	echo
+	echo "################################################################################"
+	echo "TEST SECTION: $*"
+	echo "################################################################################"
+}
+
+cleanup()
+{
+	ip link del veth-rt-1 2>/dev/null || true
+	ip link del veth-rt-2 2>/dev/null || true
+
+	# destroy routers rt-* and hosts hs-*
+	for ns in $(ip netns show | grep -E 'rt-*|hs-*'); do
+		ip netns del ${ns} || true
+	done
+}
+
+# Setup the basic networking for the routers
+setup_rt_networking()
+{
+	local rt=$1
+	local nsname=rt-${rt}
+
+	ip netns add ${nsname}
+
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.default.accept_dad=0
+
+	ip link set veth-rt-${rt} netns ${nsname}
+	ip -netns ${nsname} link set veth-rt-${rt} name veth0
+
+	ip -netns ${nsname} addr add ${IPv6_RT_NETWORK}::${rt}/64 dev veth0 nodad
+	ip -netns ${nsname} link set veth0 up
+	ip -netns ${nsname} link set lo up
+
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.all.forwarding=1
+}
+
+setup_rt_netfilter()
+{
+	local rt=$1
+	local nsname=rt-${rt}
+
+	ip netns exec ${nsname} sysctl -wq net.netfilter.nf_hooks_lwtunnel=1
+	ip netns exec ${nsname} ip6tables -t raw -A PREROUTING -m rpfilter --invert -j DROP
+}
+
+setup_hs()
+{
+	local hs=$1
+	local rt=$2
+	local tid=$3
+	local hsname=hs-${hs}
+	local rtname=rt-${rt}
+	local rtveth=veth-t${tid}
+
+	# set the networking for the host
+	ip netns add ${hsname}
+
+	ip -netns ${hsname} link add veth0 type veth peer name ${rtveth}
+	ip -netns ${hsname} link set ${rtveth} netns ${rtname}
+	ip -netns ${hsname} addr add ${IPv6_HS_NETWORK}::${hs}/64 dev veth0 nodad
+	ip -netns ${hsname} link set veth0 up
+	ip -netns ${hsname} link set lo up
+
+	ip -netns ${rtname} addr add ${IPv6_HS_NETWORK}::${rt}${hs}/64 dev ${rtveth}
+	ip -netns ${rtname} link set ${rtveth} up
+
+	ip netns exec ${rtname} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${rtname} sysctl -wq net.ipv6.conf.default.accept_dad=0
+
+	ip netns exec ${rtname} sysctl -wq net.ipv6.conf.${rtveth}.proxy_ndp=1
+}
+
+setup_vpn_config()
+{
+	local hssrc=$1
+	local rtsrc=$2
+	local hsdst=$3
+	local rtdst=$4
+	local tid=$5
+
+	local hssrc_name=hs-t${tid}-${hssrc}
+	local hsdst_name=hs-t${tid}-${hsdst}
+	local rtsrc_name=rt-${rtsrc}
+	local rtdst_name=rt-${rtdst}
+	local rtveth=veth-t${tid}
+	local vpn_sid=${SID_LOCATOR}:${hssrc}${hsdst}:${tid}::6004
+
+	ip -netns ${rtsrc_name} -6 neigh add proxy ${IPv6_HS_NETWORK}::${hsdst} dev ${rtveth}
+
+	# set the encap route for encapsulating packets which arrive from the
+	# host hssrc and destined to the access router rtsrc.
+	ip -netns ${rtsrc_name} -6 route add ${IPv6_HS_NETWORK}::${hsdst}/128 \
+		encap seg6 mode encap segs ${vpn_sid} dev veth0
+	ip -netns ${rtsrc_name} -6 route add ${vpn_sid}/128 \
+		via 2001:11::${rtdst} dev veth0
+
+	# set the decap route for decapsulating packets which arrive from
+	# the rtdst router and destined to the hsdst host.
+	ip -netns ${rtdst_name} -6 route add ${vpn_sid}/128 \
+		encap seg6local action End.DX6 nh6 ${IPv6_HS_NETWORK}::${hsdst} dev veth-t${tid}
+}
+
+setup()
+{
+	ip link add veth-rt-1 type veth peer name veth-rt-2
+	# setup the networking for router rt-1 and router rt-2
+	setup_rt_networking 1
+	setup_rt_networking 2
+
+	# setup two hosts for the tenant 100.
+	#  - host hs-1 is directly connected to the router rt-1;
+	#  - host hs-2 is directly connected to the router rt-2.
+	setup_hs 1 1 100
+	setup_hs 2 2 100
+
+	# setup the IPv4 L3 VPN which connects the host hs-1 and host hs-2.
+	setup_vpn_config 1 1 2 2 100  #args: src_host src_router dst_host dst_router tenant
+	setup_vpn_config 2 2 1 1 100
+}
+
+check_hs_connectivity()
+{
+	local hssrc=$1
+	local hsdst=$2
+	local tid=$3
+
+	ip netns exec hs-${hssrc} ping -6 -c 1 -W ${PING_TIMEOUT_SEC} \
+		${IPv6_HS_NETWORK}::${hsdst} >/dev/null 2>&1
+}
+
+check_and_log_hs_connectivity()
+{
+	local hssrc=$1
+	local hsdst=$2
+	local tid=$3
+
+	check_hs_connectivity ${hssrc} ${hsdst} ${tid}
+	log_test $? 0 "Hosts connectivity: hs-${hssrc} -> hs-${hsdst} (tenant ${tid})"
+}
+
+host_tests()
+{
+	log_section "SRv6 VPN connectivity test among hosts in the same tenant"
+
+	check_and_log_hs_connectivity 1 2 100
+	check_and_log_hs_connectivity 2 1 100
+}
+
+router_netfilter_tests()
+{
+	log_section "SRv6 VPN connectivity test with netfilter enabled in routers"
+	setup_rt_netfilter 1
+	setup_rt_netfilter 2
+
+	check_and_log_hs_connectivity 1 2 100
+	check_and_log_hs_connectivity 2 1 100
+}
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+cleanup &>/dev/null
+
+setup
+
+host_tests
+router_netfilter_tests
+
+print_log_test_results
+
+cleanup &>/dev/null
+
+exit ${ret}
-- 
2.30.2

