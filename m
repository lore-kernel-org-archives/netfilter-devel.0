Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B966C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0C2E60BBB
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 08:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349823AbhDNIVk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 04:21:40 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:48331 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349808AbhDNIVi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 04:21:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 041A75803F5;
        Wed, 14 Apr 2021 04:21:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 14 Apr 2021 04:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EhLd98H3IIjnjfFDYVD4hQS2drb87AUHuN+UrLDZvmM=; b=FPYGm29+
        AJnbHXZMCW00sKUmmIaRSMBKC7JUCK2UQn9khL3TZMTojdhvVPokVJ60/27UnIA/
        F5N63Tl7yq+RcbIze1iJGoW4VTYsuUDOLpwObz2miydzhJa+2ZzZuJqVvbl0ZWso
        9sPiH8Egp4+t9njSSfoZ7x52i4oe6ixbwcXD/hcD61IdrdQ9Q+bZPsK6vYmkEzjP
        cbvxGLsSWrBkx4XPUKKIXG+ZSGweHQaqkqiJ1pnigMMhlrMFGC3om1tGLhxbVVTf
        9HFezSyVBivkcalQYIKMQywUbD0sKMBxMbRvusIoajdSbw5xn3L0G/E1xIBJlXm7
        MfD/0IRU+vU28A==
X-ME-Sender: <xms:_KV2YHM5Y6xRdYzq6igpY5-xSrL8tIBW0N2-8mEXOP3Vo5JuH8CgcA>
    <xme:_KV2YB_k1oOlK6R2CKwqezhY0tpWFWsaszBd20XluzzqyVTfZi4pUSkpQfR7-aWh-
    mF7FB-aUnkxsGs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeluddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_KV2YGRTZ1lVRIPRpGjFtxlsL7Iyruuj1zcAlwWofdsBgthVe0kgwQ>
    <xmx:_KV2YLvF_cIbF9pg-VrvaAfez1bmMQjH8Cr8gFpOsMXGoScOXAhROA>
    <xmx:_KV2YPf2WrRI5wujak-gaHH_n_NoFFda_cljFCa2CN6bd3OQHO787A>
    <xmx:_aV2YBu0zRcpZRAbUfq3R_sf6NqqLkXITO2KeySQ1s9aFupUrDBbnA>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B9F024005A;
        Wed, 14 Apr 2021 04:21:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        msoltyspl@yandex.pl, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH nf-next v2 2/2] selftests: fib_tests: Add test cases for interaction with mangling
Date:   Wed, 14 Apr 2021 11:20:33 +0300
Message-Id: <20210414082033.1568363-3-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414082033.1568363-1-idosch@idosch.org>
References: <20210414082033.1568363-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that packets are correctly routed when netfilter mangling rules are
present.

Without previous patch:

 # ./fib_tests.sh -t ipv4_mangle

 IPv4 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [FAIL]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [FAIL]

 Tests passed:   3
 Tests failed:   2

 # ./fib_tests.sh -t ipv6_mangle

 IPv6 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [FAIL]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [FAIL]

 Tests passed:   3
 Tests failed:   2

With previous patch:

 # ./fib_tests.sh -t ipv4_mangle

 IPv4 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [ OK ]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [ OK ]

 Tests passed:   5
 Tests failed:   0

 # ./fib_tests.sh -t ipv6_mangle

 IPv6 mangling tests
     TEST:     Connection with correct parameters                        [ OK ]
     TEST:     Connection with incorrect parameters                      [ OK ]
     TEST:     Connection with correct parameters - mangling             [ OK ]
     TEST:     Connection with correct parameters - no mangling          [ OK ]
     TEST:     Connection check - server side                            [ OK ]

 Tests passed:   5
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/fib_tests.sh | 152 ++++++++++++++++++++++-
 1 file changed, 151 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 2b5707738609..76d9487fb03c 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,7 +9,7 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr"
+TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
@@ -1653,6 +1653,154 @@ ipv4_route_v6_gw_test()
 	route_cleanup
 }
 
+socat_check()
+{
+	if [ ! -x "$(command -v socat)" ]; then
+		echo "socat command not found. Skipping test"
+		return 1
+	fi
+
+	return 0
+}
+
+iptables_check()
+{
+	iptables -t mangle -L OUTPUT &> /dev/null
+	if [ $? -ne 0 ]; then
+		echo "iptables configuration not supported. Skipping test"
+		return 1
+	fi
+
+	return 0
+}
+
+ip6tables_check()
+{
+	ip6tables -t mangle -L OUTPUT &> /dev/null
+	if [ $? -ne 0 ]; then
+		echo "ip6tables configuration not supported. Skipping test"
+		return 1
+	fi
+
+	return 0
+}
+
+ipv4_mangle_test()
+{
+	local rc
+
+	echo
+	echo "IPv4 mangling tests"
+
+	socat_check || return 1
+	iptables_check || return 1
+
+	route_setup
+	sleep 2
+
+	local tmp_file=$(mktemp)
+	ip netns exec ns2 socat UDP4-LISTEN:54321,fork $tmp_file &
+
+	# Add a FIB rule and a route that will direct our connection to the
+	# listening server.
+	$IP rule add pref 100 ipproto udp sport 12345 dport 54321 table 123
+	$IP route add table 123 172.16.101.0/24 dev veth1
+
+	# Add an unreachable route to the main table that will block our
+	# connection in case the FIB rule is not hit.
+	$IP route add unreachable 172.16.101.2/32
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters"
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=11111"
+	log_test $? 1 "    Connection with incorrect parameters"
+
+	# Add a mangling rule and make sure connection is still successful.
+	$NS_EXEC iptables -t mangle -A OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - mangling"
+
+	# Delete the mangling rule and make sure connection is still
+	# successful.
+	$NS_EXEC iptables -t mangle -D OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP4:172.16.101.2:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - no mangling"
+
+	# Verify connections were indeed successful on server side.
+	[[ $(cat $tmp_file | wc -l) -eq 3 ]]
+	log_test $? 0 "    Connection check - server side"
+
+	$IP route del unreachable 172.16.101.2/32
+	$IP route del table 123 172.16.101.0/24 dev veth1
+	$IP rule del pref 100
+
+	{ kill %% && wait %%; } 2>/dev/null
+	rm $tmp_file
+
+	route_cleanup
+}
+
+ipv6_mangle_test()
+{
+	local rc
+
+	echo
+	echo "IPv6 mangling tests"
+
+	socat_check || return 1
+	ip6tables_check || return 1
+
+	route_setup
+	sleep 2
+
+	local tmp_file=$(mktemp)
+	ip netns exec ns2 socat UDP6-LISTEN:54321,fork $tmp_file &
+
+	# Add a FIB rule and a route that will direct our connection to the
+	# listening server.
+	$IP -6 rule add pref 100 ipproto udp sport 12345 dport 54321 table 123
+	$IP -6 route add table 123 2001:db8:101::/64 dev veth1
+
+	# Add an unreachable route to the main table that will block our
+	# connection in case the FIB rule is not hit.
+	$IP -6 route add unreachable 2001:db8:101::2/128
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters"
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=11111"
+	log_test $? 1 "    Connection with incorrect parameters"
+
+	# Add a mangling rule and make sure connection is still successful.
+	$NS_EXEC ip6tables -t mangle -A OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - mangling"
+
+	# Delete the mangling rule and make sure connection is still
+	# successful.
+	$NS_EXEC ip6tables -t mangle -D OUTPUT -j MARK --set-mark 1
+
+	run_cmd "echo a | $NS_EXEC socat STDIN UDP6:[2001:db8:101::2]:54321,sourceport=12345"
+	log_test $? 0 "    Connection with correct parameters - no mangling"
+
+	# Verify connections were indeed successful on server side.
+	[[ $(cat $tmp_file | wc -l) -eq 3 ]]
+	log_test $? 0 "    Connection check - server side"
+
+	$IP -6 route del unreachable 2001:db8:101::2/128
+	$IP -6 route del table 123 2001:db8:101::/64 dev veth1
+	$IP -6 rule del pref 100
+
+	{ kill %% && wait %%; } 2>/dev/null
+	rm $tmp_file
+
+	route_cleanup
+}
+
 ################################################################################
 # usage
 
@@ -1725,6 +1873,8 @@ do
 	ipv6_route_metrics)		ipv6_route_metrics_test;;
 	ipv4_route_metrics)		ipv4_route_metrics_test;;
 	ipv4_route_v6_gw)		ipv4_route_v6_gw_test;;
+	ipv4_mangle)			ipv4_mangle_test;;
+	ipv6_mangle)			ipv6_mangle_test;;
 
 	help) echo "Test names: $TESTS"; exit 0;;
 	esac
-- 
2.30.2

