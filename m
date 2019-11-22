Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220D9C432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7B5C20707
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V4VjWi1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfKVNkc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:40:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37772 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728130AbfKVNkc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:40:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d4/4LYGRLTTe8lPAZnqzTnY2siK2rR20xufcaN7gzT0=;
        b=V4VjWi1sjlnj4I3LbrmA/GK77QBjN6jfhtXiDEGQZrUwg6AY8vRkdIQMF0+HPzAgtyNWA4
        nq9HznAel52pGshVoHTz7+xIg4aery1bpGSAaY7Xc7WvH3x4VU+1gjzoiLCEM6UtmwBtY1
        TcLSQlsMcQtE5/M1B3qhT53BHSinGCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-cC4QGg8SMeO1gucKMsXCgQ-1; Fri, 22 Nov 2019 08:40:24 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F07BDB3A;
        Fri, 22 Nov 2019 13:40:23 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B18621036C8E;
        Fri, 22 Nov 2019 13:40:20 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v2 4/8] selftests: netfilter: Introduce tests for sets with range concatenation
Date:   Fri, 22 Nov 2019 14:40:03 +0100
Message-Id: <e9a96fb976fe2cf89db494cb22f0c3a21b82d4f5.1574428269.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574428269.git.sbrivio@redhat.com>
References: <cover.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: cC4QGg8SMeO1gucKMsXCgQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This test covers functionality and stability of the newly added
nftables set implementation supporting concatenation of ranged
fields.

For some selected set expression types, test:
- correctness, by checking that packets match or don't
- concurrency, by attempting races between insertion, deletion, lookup
- timeout feature, checking that packets don't match expired entries

and (roughly) estimate matching rates, comparing to baselines for
simple drop on netdev ingress hook and for hash and rbtrees sets.

In order to send packets, this needs one of sendip, netcat or bash.
To flood with traffic, iperf3, iperf and netperf are supported. For
performance measurements, this relies on the sample pktgen script
pktgen_bench_xmit_mode_netif_receive.sh.

If none of the tools suitable for a given test are available, specific
tests will be skipped.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: No changes

 tools/testing/selftests/netfilter/Makefile    |    3 +-
 .../selftests/netfilter/nft_concat_range.sh   | 1481 +++++++++++++++++
 2 files changed, 1483 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_concat_range.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/sel=
ftests/netfilter/Makefile
index de1032b5ddea..08194aa44006 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -2,6 +2,7 @@
 # Makefile for netfilter selftests
=20
 TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
-=09conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh
+=09conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
+=09nft_concat_range.sh
=20
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/=
testing/selftests/netfilter/nft_concat_range.sh
new file mode 100755
index 000000000000..aca21dde102a
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -0,0 +1,1481 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# nft_concat_range.sh - Tests for sets with concatenation of ranged fields
+#
+# Copyright (c) 2019 Red Hat GmbH
+#
+# Author: Stefano Brivio <sbrivio@redhat.com>
+#
+# shellcheck disable=3DSC2154,SC2034,SC2016,SC2030,SC2031
+# ^ Configuration and templates sourced with eval, counters reused in subs=
hells
+
+KSELFTEST_SKIP=3D4
+
+# Available test groups:
+# - correctness: check that packets match given entries, and only those
+# - concurrency: attempt races between insertion, deletion and lookup
+# - timeout: check that packets match entries until they expire
+# - performance: estimate matching rate, compare with rbtree and hash base=
lines
+TESTS=3D"correctness concurrency timeout"
+[ "${quicktest}" !=3D "1" ] && TESTS=3D"${TESTS} performance"
+
+# Set types, defined by TYPE_ variables below
+TYPES=3D"net_port port_net net6_port port_proto net6_port_mac net6_port_ma=
c_proto
+       net_port_net net_mac net_mac_icmp net6_mac_icmp net6_port_net6_port
+       net_port_mac_proto_net"
+
+# List of possible paths to pktgen script from kernel tree for performance=
 tests
+PKTGEN_SCRIPT_PATHS=3D"
+=09../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+=09pktgen/pktgen_bench_xmit_mode_netif_receive.sh"
+
+# Definition of set types:
+# display=09display text for test report
+# type_spec=09nftables set type specifier
+# chain_spec=09nftables type specifier for rules mapping to set
+# dst=09=09call sequence of format_*() functions for destination fields
+# src=09=09call sequence of format_*() functions for source fields
+# start=09=09initial integer used to generate addresses and ports
+# count=09=09count of entries to generate and match
+# src_delta=09number summed to destination generator for source fields
+# tools=09=09list of tools for correctness and timeout tests, any can be u=
sed
+# proto=09=09L4 protocol of test packets
+#
+# race_repeat=09race attempts per thread, 0 disables concurrency test for =
type
+# flood_tools=09list of tools for concurrency tests, any can be used
+# flood_proto=09L4 protocol of test packets for concurrency tests
+# flood_spec=09nftables type specifier for concurrency tests
+#
+# perf_duration=09duration of single pktgen injection test
+# perf_spec=09nftables type specifier for performance tests
+# perf_dst=09format_*() functions for destination fields in performance te=
st
+# perf_src=09format_*() functions for source fields in performance test
+# perf_entries=09number of set entries for performance test
+# perf_proto=09L3 protocol of test packets
+TYPE_net_port=3D"
+display=09=09net,port
+type_spec=09ipv4_addr . inet_service
+chain_spec=09ip daddr . udp dport
+dst=09=09addr4 port
+src=09=09=20
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp
+
+race_repeat=093
+flood_tools=09iperf3 iperf netperf
+flood_proto=09udp
+flood_spec=09ip daddr . udp dport
+
+perf_duration=095
+perf_spec=09ip daddr . udp dport
+perf_dst=09addr4 port
+perf_src=09=20
+perf_entries=091000
+perf_proto=09ipv4
+"
+
+TYPE_port_net=3D"
+display=09=09port,net
+type_spec=09inet_service . ipv4_addr
+chain_spec=09udp dport . ip daddr
+dst=09=09port addr4
+src=09=09=20
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp
+
+race_repeat=093
+flood_tools=09iperf3 iperf netperf
+flood_proto=09udp
+flood_spec=09udp dport . ip daddr
+
+perf_duration=095
+perf_spec=09udp dport . ip daddr
+perf_dst=09port addr4
+perf_src=09=20
+perf_entries=09100
+perf_proto=09ipv4
+"
+
+TYPE_net6_port=3D"
+display=09=09net6,port
+type_spec=09ipv6_addr . inet_service
+chain_spec=09ip6 daddr . udp dport
+dst=09=09addr6 port
+src=09=09=20
+start=09=0910
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp6
+
+race_repeat=093
+flood_tools=09iperf3 iperf netperf
+flood_proto=09tcp6
+flood_spec=09ip6 daddr . udp dport
+
+perf_duration=095
+perf_spec=09ip6 daddr . udp dport
+perf_dst=09addr6 port
+perf_src=09=20
+perf_entries=091000
+perf_proto=09ipv6
+"
+
+TYPE_port_proto=3D"
+display=09=09port,proto
+type_spec=09inet_service . inet_proto
+chain_spec=09udp dport . meta l4proto
+dst=09=09port proto
+src=09=09=20
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp
+
+race_repeat=090
+
+perf_duration=095
+perf_spec=09udp dport . meta l4proto
+perf_dst=09port proto
+perf_src=09=20
+perf_entries=0930000
+perf_proto=09ipv4
+"
+
+TYPE_net6_port_mac=3D"
+display=09=09net6,port,mac
+type_spec=09ipv6_addr . inet_service . ether_addr
+chain_spec=09ip6 daddr . udp dport . ether saddr
+dst=09=09addr6 port
+src=09=09mac
+start=09=0910
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp6
+
+race_repeat=090
+
+perf_duration=095
+perf_spec=09ip6 daddr . udp dport . ether daddr
+perf_dst=09addr6 port mac
+perf_src=09=20
+perf_entries=0910
+perf_proto=09ipv6
+"
+
+TYPE_net6_port_mac_proto=3D"
+display=09=09net6,port,mac,proto
+type_spec=09ipv6_addr . inet_service . ether_addr . inet_proto
+chain_spec=09ip6 daddr . udp dport . ether saddr . meta l4proto
+dst=09=09addr6 port
+src=09=09mac proto
+start=09=0910
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp6
+
+race_repeat=090
+
+perf_duration=095
+perf_spec=09ip6 daddr . udp dport . ether daddr . meta l4proto
+perf_dst=09addr6 port mac proto
+perf_src=09=20
+perf_entries=091000
+perf_proto=09ipv6
+"
+
+TYPE_net_port_net=3D"
+display=09=09net,port,net
+type_spec=09ipv4_addr . inet_service . ipv4_addr
+chain_spec=09ip daddr . udp dport . ip saddr
+dst=09=09addr4 port
+src=09=09addr4
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp
+
+race_repeat=093
+flood_tools=09iperf3 iperf netperf
+flood_proto=09tcp
+flood_spec=09ip daddr . udp dport . ip saddr
+
+perf_duration=090
+"
+
+TYPE_net6_port_net6_port=3D"
+display=09=09net6,port,net6,port
+type_spec=09ipv6_addr . inet_service . ipv6_addr . inet_service
+chain_spec=09ip6 daddr . udp dport . ip6 saddr . udp sport
+dst=09=09addr6 port
+src=09=09addr6 port
+start=09=0910
+count=09=095
+src_delta=092000
+tools=09=09sendip nc
+proto=09=09udp6
+
+race_repeat=093
+flood_tools=09iperf3 iperf netperf
+flood_proto=09tcp6
+flood_spec=09ip6 daddr . tcp dport . ip6 saddr . tcp sport
+
+perf_duration=090
+"
+
+TYPE_net_port_mac_proto_net=3D"
+display=09=09net,port,mac,proto,net
+type_spec=09ipv4_addr . inet_service . ether_addr . inet_proto . ipv4_addr
+chain_spec=09ip daddr . udp dport . ether saddr . meta l4proto . ip saddr
+dst=09=09addr4 port
+src=09=09mac proto addr4
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp
+
+race_repeat=090
+
+perf_duration=090
+"
+
+TYPE_net_mac=3D"
+display=09=09net,mac
+type_spec=09ipv4_addr . ether_addr
+chain_spec=09ip daddr . ether saddr
+dst=09=09addr4
+src=09=09mac
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09sendip nc bash
+proto=09=09udp
+
+race_repeat=090
+
+perf_duration=095
+perf_spec=09ip daddr . ether daddr
+perf_dst=09addr4 mac
+perf_src=09=20
+perf_entries=091000
+perf_proto=09ipv4
+"
+
+TYPE_net_mac_icmp=3D"
+display=09=09net,mac - ICMP
+type_spec=09ipv4_addr . ether_addr
+chain_spec=09ip daddr . ether saddr
+dst=09=09addr4
+src=09=09mac
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09ping
+proto=09=09icmp
+
+race_repeat=090
+
+perf_duration=090
+"
+
+TYPE_net6_mac_icmp=3D"
+display=09=09net6,mac - ICMPv6
+type_spec=09ipv6_addr . ether_addr
+chain_spec=09ip6 daddr . ether saddr
+dst=09=09addr6
+src=09=09mac
+start=09=0910
+count=09=0950
+src_delta=092000
+tools=09=09ping
+proto=09=09icmp6
+
+race_repeat=090
+
+perf_duration=090
+"
+
+TYPE_net_port_proto_net=3D"
+display=09=09net,port,proto,net
+type_spec=09ipv4_addr . inet_service . inet_proto . ipv4_addr
+chain_spec=09ip daddr . udp dport . meta l4proto . ip saddr
+dst=09=09addr4 port proto
+src=09=09addr4
+start=09=091
+count=09=095
+src_delta=092000
+tools=09=09sendip nc
+proto=09=09udp
+
+race_repeat=093
+flood_tools=09iperf3 iperf netperf
+flood_proto=09tcp
+flood_spec=09ip daddr . tcp dport . meta l4proto . ip saddr
+
+perf_duration=090
+"
+
+# Set template for all tests, types and rules are filled in depending on t=
est
+set_template=3D'
+flush ruleset
+
+table inet filter {
+=09counter test {
+=09=09packets 0 bytes 0
+=09}
+
+=09set test {
+=09=09type ${type_spec}
+=09=09flags interval,timeout
+=09}
+
+=09chain input {
+=09=09type filter hook prerouting priority 0; policy accept;
+=09=09${chain_spec} @test counter name \"test\"
+=09}
+}
+
+table netdev perf {
+=09counter test {
+=09=09packets 0 bytes 0
+=09}
+
+=09counter match {
+=09=09packets 0 bytes 0
+=09}
+
+=09set test {
+=09=09type ${type_spec}
+=09=09flags interval
+=09}
+
+=09set norange {
+=09=09type ${type_spec}
+=09}
+
+=09set noconcat {
+=09=09type ${type_spec%% *}
+=09=09flags interval
+=09}
+
+=09chain test {
+=09=09type filter hook ingress device veth_a priority 0;
+=09}
+}
+'
+
+err_buf=3D
+info_buf=3D
+
+# Append string to error buffer
+err() {
+=09err_buf=3D"${err_buf}${1}
+"
+}
+
+# Append string to information buffer
+info() {
+=09info_buf=3D"${info_buf}${1}
+"
+}
+
+# Flush error buffer to stdout
+err_flush() {
+=09printf "%s" "${err_buf}"
+=09err_buf=3D
+}
+
+# Flush information buffer to stdout
+info_flush() {
+=09printf "%s" "${info_buf}"
+=09info_buf=3D
+}
+
+# Setup veth pair: this namespace receives traffic, B generates it
+setup_veth() {
+=09ip netns add B
+=09ip link add veth_a type veth peer name veth_b || return 1
+
+=09ip link set veth_a up
+=09ip link set veth_b netns B
+
+=09ip -n B link set veth_b up
+
+=09ip addr add dev veth_a 10.0.0.1
+=09ip route add default dev veth_a
+
+=09ip -6 addr add fe80::1/64 dev veth_a nodad
+=09ip -6 addr add 2001:db8::1/64 dev veth_a nodad
+=09ip -6 route add default dev veth_a
+
+=09ip -n B route add default dev veth_b
+
+=09ip -6 -n B addr add fe80::2/64 dev veth_b nodad
+=09ip -6 -n B addr add 2001:db8::2/64 dev veth_b nodad
+=09ip -6 -n B route add default dev veth_b
+
+=09B() {
+=09=09ip netns exec B "$@" >/dev/null 2>&1
+=09}
+
+=09sleep 2
+}
+
+# Fill in set template and initialise set
+setup_set() {
+=09eval "echo \"${set_template}\"" | nft -f -
+}
+
+# Check that at least one of the needed tools is available
+check_tools() {
+=09__tools=3D
+=09for tool in ${tools}; do
+=09=09if [ "${tool}" =3D "nc" ] && [ "${proto}" =3D "udp6" ] && \
+=09=09   ! nc -u -w0 1.1.1.1 1 2>/dev/null; then
+=09=09=09# Some GNU netcat builds might not support IPv6
+=09=09=09__tools=3D"${__tools} netcat-openbsd"
+=09=09=09continue
+=09=09fi
+=09=09__tools=3D"${__tools} ${tool}"
+
+=09=09command -v "${tool}" >/dev/null && return 0
+=09done
+=09err "need one of:${__tools}, skipping" && return 1
+}
+
+# Set up function to send ICMP packets
+setup_send_icmp() {
+=09send_icmp() {
+=09=09B ping -c1 -W1 "${dst_addr4}" >/dev/null 2>&1
+=09}
+}
+
+# Set up function to send ICMPv6 packets
+setup_send_icmp6() {
+=09if command -v ping6 >/dev/null; then
+=09=09send_icmp6() {
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+=09=09=09B ping6 -q -c1 -W1 "${dst_addr6}"
+=09=09}
+=09else
+=09=09send_icmp6() {
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+=09=09=09B ping -q -6 -c1 -W1 "${dst_addr6}"
+=09=09}
+=09fi
+}
+
+# Set up function to send single UDP packets on IPv4
+setup_send_udp() {
+=09if command -v sendip >/dev/null; then
+=09=09send_udp() {
+=09=09=09[ -n "${src_port}" ] && src_port=3D"-us ${src_port}"
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-ud ${dst_port}"
+=09=09=09[ -n "${src_addr4}" ] && src_addr4=3D"-is ${src_addr4}"
+
+=09=09=09# shellcheck disable=3DSC2086 # sendip needs split options
+=09=09=09B sendip -p ipv4 -p udp ${src_addr4} ${src_port} \
+=09=09=09=09=09=09${dst_port} "${dst_addr4}"
+
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09=09src_addr4=3D
+=09=09}
+=09elif command -v nc >/dev/null; then
+=09=09if nc -u -w0 1.1.1.1 1 2>/dev/null; then
+=09=09=09# OpenBSD netcat
+=09=09=09nc_opt=3D"-w0"
+=09=09else
+=09=09=09# GNU netcat
+=09=09=09nc_opt=3D"-q0"
+=09=09fi
+
+=09=09send_udp() {
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}" dev veth_b
+=09=09=09=09__src_addr4=3D"-s ${src_addr4}"
+=09=09=09fi
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+=09=09=09[ -n "${src_port}" ] && src_port=3D"-p ${src_port}"
+
+=09=09=09echo "" | B nc -u "${nc_opt}" "${__src_addr4}" \
+=09=09=09=09  "${src_port}" "${dst_addr4}" "${dst_port}"
+
+=09=09=09src_addr4=3D
+=09=09=09src_port=3D
+=09=09}
+=09elif [ -z "$(bash -c 'type -p')" ]; then
+=09=09send_udp() {
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}/16" dev veth_b
+=09=09=09=09B ip route add default dev veth_b
+=09=09=09fi
+
+=09=09=09B bash -c "echo > /dev/udp/${dst_addr4}/${dst_port}"
+
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr del "${src_addr4}/16" dev veth_b
+=09=09=09fi
+=09=09=09src_addr4=3D
+=09=09}
+=09else
+=09=09return 1
+=09fi
+}
+
+# Set up function to send single UDP packets on IPv6
+setup_send_udp6() {
+=09if command -v sendip >/dev/null; then
+=09=09send_udp6() {
+=09=09=09[ -n "${src_port}" ] && src_port=3D"-us ${src_port}"
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-ud ${dst_port}"
+=09=09=09if [ -n "${src_addr6}" ]; then
+=09=09=09=09src_addr6=3D"-6s ${src_addr6}"
+=09=09=09else
+=09=09=09=09src_addr6=3D"-6s 2001:db8::2"
+=09=09=09fi
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B sendip -p ipv6 -p udp ${src_addr6} ${src_port} \
+=09=09=09=09=09=09${dst_port} "${dst_addr6}"
+
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09=09src_addr6=3D
+=09=09}
+=09elif command -v nc >/dev/null && nc -u -w0 1.1.1.1 1 2>/dev/null; then
+=09=09# GNU netcat might not work with IPv6, try next tool
+=09=09send_udp6() {
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+=09=09=09if [ -n "${src_addr6}" ]; then
+=09=09=09=09B ip addr add "${src_addr6}" dev veth_b nodad
+=09=09=09else
+=09=09=09=09src_addr6=3D"2001:db8::2"
+=09=09=09fi
+=09=09=09[ -n "${src_port}" ] && src_port=3D"-p ${src_port}"
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09echo "" | B nc -u w0 "-s${src_addr6}" ${src_port} \
+=09=09=09=09=09       ${dst_addr6} ${dst_port}
+
+=09=09=09src_addr6=3D
+=09=09=09src_port=3D
+=09=09}
+=09elif [ -z "$(bash -c 'type -p')" ]; then
+=09=09send_udp6() {
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+=09=09=09B ip addr add "${src_addr6}" dev veth_b nodad
+=09=09=09B bash -c "echo > /dev/udp/${dst_addr6}/${dst_port}"
+=09=09=09ip -6 addr del "${dst_addr6}" dev veth_a 2>/dev/null
+=09=09}
+=09else
+=09=09return 1
+=09fi
+}
+
+# Set up function to send TCP traffic on IPv4
+setup_flood_tcp() {
+=09if command -v iperf3 >/dev/null; then
+=09=09flood_tcp() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}/16" dev veth_b
+=09=09=09=09src_addr4=3D"-B ${src_addr4}"
+=09=09=09else
+=09=09=09=09B ip addr add dev veth_b 10.0.0.2
+=09=09=09=09src_addr4=3D"-B 10.0.0.2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09src_port=3D"--cport ${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b 2>/dev/null
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09iperf3 -s -DB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B iperf3 -c "${dst_addr4}" ${dst_port} ${src_port} \
+=09=09=09=09${src_addr4} -l16 -t 1000
+
+=09=09=09src_addr4=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09elif command -v iperf >/dev/null; then
+=09=09flood_tcp() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}/16" dev veth_b
+=09=09=09=09src_addr4=3D"-B ${src_addr4}"
+=09=09=09else
+=09=09=09=09B ip addr add dev veth_b 10.0.0.2 2>/dev/null
+=09=09=09=09src_addr4=3D"-B 10.0.0.2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09src_addr4=3D"${src_addr4}:${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09iperf -s -DB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B iperf -c "${dst_addr4}" ${dst_port} ${src_addr4} \
+=09=09=09=09-l20 -t 1000
+
+=09=09=09src_addr4=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09elif command -v netperf >/dev/null; then
+=09=09flood_tcp() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}/16" dev veth_b
+=09=09=09else
+=09=09=09=09B ip addr add dev veth_b 10.0.0.2
+=09=09=09=09src_addr4=3D"10.0.0.2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09dst_port=3D"${dst_port},${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09netserver -4 ${dst_port} -L "${dst_addr4}" \
+=09=09=09=09>/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B netperf -4 -H "${dst_addr4}" ${dst_port} \
+=09=09=09=09-L "${src_addr4}" -l 1000 -t TCP_STREAM
+
+=09=09=09src_addr4=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09else
+=09=09return 1
+=09fi
+}
+
+# Set up function to send TCP traffic on IPv6
+setup_flood_tcp6() {
+=09if command -v iperf3 >/dev/null; then
+=09=09flood_tcp6() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr6}" ]; then
+=09=09=09=09B ip addr add "${src_addr6}" dev veth_b nodad
+=09=09=09=09src_addr6=3D"-B ${src_addr6}"
+=09=09=09else
+=09=09=09=09src_addr6=3D"-B 2001:db8::2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09src_port=3D"--cport ${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09iperf3 -s -DB "${dst_addr6}" ${dst_port} >/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B iperf3 -c "${dst_addr6}" ${dst_port} \
+=09=09=09=09${src_port} ${src_addr6} -l16 -t 1000
+
+=09=09=09src_addr6=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09elif command -v iperf >/dev/null; then
+=09=09flood_tcp6() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr6}" ]; then
+=09=09=09=09B ip addr add "${src_addr6}" dev veth_b nodad
+=09=09=09=09src_addr6=3D"-B ${src_addr6}"
+=09=09=09else
+=09=09=09=09src_addr6=3D"-B 2001:db8::2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09src_addr6=3D"${src_addr6}:${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09iperf -s -VDB "${dst_addr6}" ${dst_port} >/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B iperf -c "${dst_addr6}" -V ${dst_port} \
+=09=09=09=09${src_addr6} -l1 -t 1000
+
+=09=09=09src_addr6=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09elif command -v netperf >/dev/null; then
+=09=09flood_tcp6() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr6}" ]; then
+=09=09=09=09B ip addr add "${src_addr6}" dev veth_b nodad
+=09=09=09else
+=09=09=09=09src_addr6=3D"2001:db8::2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09dst_port=3D"${dst_port},${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+=09=09=09=092>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09netserver -6 ${dst_port} -L "${dst_addr6}" \
+=09=09=09=09>/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B netperf -6 -H "${dst_addr6}" ${dst_port} \
+=09=09=09=09-L "${src_addr6}" -l 1000 -t TCP_STREAM
+
+=09=09=09src_addr6=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09else
+=09=09return 1
+=09fi
+}
+
+# Set up function to send UDP traffic on IPv4
+setup_flood_udp() {
+=09if command -v iperf3 >/dev/null; then
+=09=09flood_udp() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}/16" dev veth_b
+=09=09=09=09src_addr4=3D"-B ${src_addr4}"
+=09=09=09else
+=09=09=09=09B ip addr add dev veth_b 10.0.0.2 2>/dev/null
+=09=09=09=09src_addr4=3D"-B 10.0.0.2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09src_port=3D"--cport ${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09iperf3 -s -DB "${dst_addr4}" ${dst_port}
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B iperf3 -u -c "${dst_addr4}" -Z -b 100M -l16 -t1000 \
+=09=09=09=09${dst_port} ${src_port} ${src_addr4}
+
+=09=09=09src_addr4=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09elif command -v iperf >/dev/null; then
+=09=09flood_udp() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}/16" dev veth_b
+=09=09=09=09src_addr4=3D"-B ${src_addr4}"
+=09=09=09else
+=09=09=09=09B ip addr add dev veth_b 10.0.0.2
+=09=09=09=09src_addr4=3D"-B 10.0.0.2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09src_addr4=3D"${src_addr4}:${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09iperf -u -sDB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B iperf -u -c "${dst_addr4}" -b 100M -l1 -t1000 \
+=09=09=09=09${dst_port} ${src_addr4}
+
+=09=09=09src_addr4=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09elif command -v netperf >/dev/null; then
+=09=09flood_udp() {
+=09=09=09[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+=09=09=09if [ -n "${src_addr4}" ]; then
+=09=09=09=09B ip addr add "${src_addr4}/16" dev veth_b
+=09=09=09else
+=09=09=09=09B ip addr add dev veth_b 10.0.0.2
+=09=09=09=09src_addr4=3D"10.0.0.2"
+=09=09=09fi
+=09=09=09if [ -n "${src_port}" ]; then
+=09=09=09=09dst_port=3D"${dst_port},${src_port}"
+=09=09=09fi
+=09=09=09B ip route add default dev veth_b
+=09=09=09ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09netserver -4 ${dst_port} -L "${dst_addr4}" \
+=09=09=09=09>/dev/null 2>&1
+=09=09=09sleep 2
+
+=09=09=09# shellcheck disable=3DSC2086 # this needs split options
+=09=09=09B netperf -4 -H "${dst_addr4}" ${dst_port} \
+=09=09=09=09-L "${src_addr4}" -l 1000 -t UDP_STREAM
+
+=09=09=09src_addr4=3D
+=09=09=09src_port=3D
+=09=09=09dst_port=3D
+=09=09}
+=09else
+=09=09return 1
+=09fi
+}
+
+# Find pktgen script and set up function to start pktgen injection
+setup_perf() {
+=09for pktgen_script_path in ${PKTGEN_SCRIPT_PATHS} __notfound; do
+=09=09command -v "${pktgen_script_path}" >/dev/null && break
+=09done
+=09[ "${pktgen_script_path}" =3D "__notfound" ] && return 1
+
+=09perf_ipv4() {
+=09=09${pktgen_script_path} -s80 \
+=09=09=09-i veth_a -d "${dst_addr4}" -p "${dst_port}" \
+=09=09=09-m "${dst_mac}" \
+=09=09=09-t $(($(nproc) / 5 + 1)) -b10000 -n0 2>/dev/null &
+=09=09perf_pid=3D$!
+=09}
+=09perf_ipv6() {
+=09=09IP6=3D6 ${pktgen_script_path} -s100 \
+=09=09=09-i veth_a -d "${dst_addr6}" -p "${dst_port}" \
+=09=09=09-m "${dst_mac}" \
+=09=09=09-t $(($(nproc) / 5 + 1)) -b10000 -n0 2>/dev/null &
+=09=09perf_pid=3D$!
+=09}
+}
+
+# Clean up before each test
+cleanup() {
+=09nft reset counter inet filter test=09>/dev/null 2>&1
+=09nft flush ruleset=09=09=09>/dev/null 2>&1
+=09ip link del dummy0=09=09=092>/dev/null
+=09ip route del default=09=09=092>/dev/null
+=09ip -6 route del default=09=09=092>/dev/null
+=09ip netns del B=09=09=09=092>/dev/null
+=09ip link del veth_a=09=09=092>/dev/null
+=09timeout=3D
+=09killall iperf3=09=09=09=092>/dev/null
+=09killall iperf=09=09=09=092>/dev/null
+=09killall netperf=09=09=09=092>/dev/null
+=09killall netserver=09=09=092>/dev/null
+=09rm -f ${tmp}
+=09sleep 2
+}
+
+# Entry point for setup functions
+setup() {
+=09if [ "$(id -u)" -ne 0 ]; then
+=09=09echo "  need to run as root"
+=09=09exit ${KSELFTEST_SKIP}
+=09fi
+
+=09cleanup
+=09check_tools || return 1
+=09for arg do
+=09=09if ! eval setup_"${arg}"; then
+=09=09=09err "  ${arg} not supported"
+=09=09=09return 1
+=09=09fi
+=09done
+}
+
+# Format integer into IPv4 address, summing 10.0.0.5 (arbitrary) to it
+format_addr4() {
+=09a=3D$((${1} + 16777216 * 10 + 5))
+=09printf "%i.%i.%i.%i"=09=09=09=09=09=09\
+=09       "$((a / 16777216))" "$((a % 16777216 / 65536))"=09\
+=09       "$((a % 65536 / 256))" "$((a % 256))"
+}
+
+# Format integer into IPv6 address, summing 2001:db8:: to it
+format_addr6() {
+=09printf "2001:db8::%04x:%04x" "$((${1} / 65536))" "$((${1} % 65536))"
+}
+
+# Format integer into EUI-48 address, summing 00:01:00:00:00:00 to it
+format_mac() {
+=09printf "00:01:%02x:%02x:%02x:%02x" \
+=09       "$((${1} / 16777216))" "$((${1} % 16777216 / 65536))"=09\
+=09       "$((${1} % 65536 / 256))" "$((${1} % 256))"
+}
+
+# Format integer into port, avoid 0 port
+format_port() {
+=09printf "%i" "$((${1} % 65534 + 1))"
+}
+
+# Drop suffixed '6' from L4 protocol, if any
+format_proto() {
+=09printf "%s" "${proto}" | tr -d 6
+}
+
+# Format destination and source fields into nft concatenated type
+format() {
+=09__start=3D
+=09__end=3D
+=09__expr=3D"{ "
+
+=09for f in ${dst}; do
+=09=09[ "${__expr}" !=3D "{ " ] && __expr=3D"${__expr} . "
+
+=09=09__start=3D"$(eval format_"${f}" "${start}")"
+=09=09__end=3D"$(eval format_"${f}" "${end}")"
+
+=09=09if [ "${f}" =3D "proto" ]; then
+=09=09=09__expr=3D"${__expr}${__start}"
+=09=09else
+=09=09=09__expr=3D"${__expr}${__start}-${__end}"
+=09=09fi
+=09done
+=09for f in ${src}; do
+=09=09__expr=3D"${__expr} . "
+=09=09__start=3D"$(eval format_"${f}" "${srcstart}")"
+=09=09__end=3D"$(eval format_"${f}" "${srcend}")"
+
+=09=09if [ "${f}" =3D "proto" ]; then
+=09=09=09__expr=3D"${__expr}${__start}"
+=09=09else
+=09=09=09__expr=3D"${__expr}${__start}-${__end}"
+=09=09fi
+=09done
+
+=09if [ -n "${timeout}" ]; then
+=09=09echo "${__expr} timeout ${timeout}s }"
+=09else
+=09=09echo "${__expr} }"
+=09fi
+}
+
+# Format destination and source fields into nft type, start element only
+format_norange() {
+=09__expr=3D"{ "
+
+=09for f in ${dst}; do
+=09=09[ "${__expr}" !=3D "{ " ] && __expr=3D"${__expr} . "
+
+=09=09__expr=3D"${__expr}$(eval format_"${f}" "${start}")"
+=09done
+=09for f in ${src}; do
+=09=09__expr=3D"${__expr} . $(eval format_"${f}" "${start}")"
+=09done
+
+=09echo "${__expr} }"
+}
+
+# Format first destination field into nft type
+format_noconcat() {
+=09for f in ${dst}; do
+=09=09__start=3D"$(eval format_"${f}" "${start}")"
+=09=09__end=3D"$(eval format_"${f}" "${end}")"
+
+=09=09if [ "${f}" =3D "proto" ]; then
+=09=09=09echo "{ ${__start} }"
+=09=09else
+=09=09=09echo "{ ${__start}-${__end} }"
+=09=09fi
+=09=09return
+=09done
+}
+
+# Add single entry to 'test' set in 'inet filter' table
+add() {
+=09if ! nft add element inet filter test "${1}"; then
+=09=09err "Failed to add ${1} given ruleset:"
+=09=09err "$(nft list ruleset -a)"
+=09=09return 1
+=09fi
+}
+
+# Format and output entries for sets in 'netdev perf' table
+add_perf() {
+=09if [ "${1}" =3D "test" ]; then
+=09=09echo "add element netdev perf test $(format)"
+=09elif [ "${1}" =3D "norange" ]; then
+=09=09echo "add element netdev perf norange $(format_norange)"
+=09elif [ "${1}" =3D "noconcat" ]; then
+=09=09echo "add element netdev perf noconcat $(format_noconcat)"
+=09fi
+}
+
+# Add single entry to 'norange' set in 'netdev perf' table
+add_perf_norange() {
+=09if ! nft add element netdev perf norange "${1}"; then
+=09=09err "Failed to add ${1} given ruleset:"
+=09=09err "$(nft list ruleset -a)"
+=09=09return 1
+=09fi
+}
+
+# Add single entry to 'noconcat' set in 'netdev perf' table
+add_perf_noconcat() {
+=09if ! nft add element netdev perf noconcat "${1}"; then
+=09=09err "Failed to add ${1} given ruleset:"
+=09=09err "$(nft list ruleset -a)"
+=09=09return 1
+=09fi
+}
+
+# Delete single entry from set
+del() {
+=09if ! nft delete element inet filter test "${1}"; then
+=09=09err "Failed to delete ${1} given ruleset:"
+=09=09err "$(nft list ruleset -a)"
+=09=09return 1
+=09fi
+}
+
+# Return packet count from 'test' counter in 'inet filter' table
+count_packets() {
+=09found=3D0
+=09for token in $(nft list counter inet filter test); do
+=09=09[ ${found} -eq 1 ] && echo "${token}" && return
+=09=09[ "${token}" =3D "packets" ] && found=3D1
+=09done
+}
+
+# Return packet count from 'test' counter in 'netdev perf' table
+count_perf_packets() {
+=09found=3D0
+=09for token in $(nft list counter netdev perf test); do
+=09=09[ ${found} -eq 1 ] && echo "${token}" && return
+=09=09[ "${token}" =3D "packets" ] && found=3D1
+=09done
+}
+
+# Set MAC addresses, send traffic according to specifier
+flood() {
+=09ip link set veth_a address "$(format_mac "${1}")"
+=09ip -n B link set veth_b address "$(format_mac "${2}")"
+
+=09for f in ${dst}; do
+=09=09eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+=09done
+=09for f in ${src}; do
+=09=09eval src_"$f"=3D\$\(format_\$f "${2}"\)
+=09done
+=09eval flood_\$proto
+}
+
+# Set MAC addresses, start pktgen injection
+perf() {
+=09dst_mac=3D"$(format_mac "${1}")"
+=09ip link set veth_a address "${dst_mac}"
+
+=09for f in ${dst}; do
+=09=09eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+=09done
+=09for f in ${src}; do
+=09=09eval src_"$f"=3D\$\(format_\$f "${2}"\)
+=09done
+=09eval perf_\$perf_proto
+}
+
+# Set MAC addresses, send single packet, check that it matches, reset coun=
ter
+send_match() {
+=09ip link set veth_a address "$(format_mac "${1}")"
+=09ip -n B link set veth_b address "$(format_mac "${2}")"
+
+=09for f in ${dst}; do
+=09=09eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+=09done
+=09for f in ${src}; do
+=09=09eval src_"$f"=3D\$\(format_\$f "${2}"\)
+=09done
+=09eval send_\$proto
+=09if [ "$(count_packets)" !=3D "1" ]; then
+=09=09err "${proto} packet to:"
+=09=09err "  $(for f in ${dst}; do
+=09=09=09 eval format_\$f "${1}"; printf ' '; done)"
+=09=09err "from:"
+=09=09err "  $(for f in ${src}; do
+=09=09=09 eval format_\$f "${2}"; printf ' '; done)"
+=09=09err "should have matched ruleset:"
+=09=09err "$(nft list ruleset -a)"
+=09=09return 1
+=09fi
+=09nft reset counter inet filter test >/dev/null
+}
+
+# Set MAC addresses, send single packet, check that it doesn't match
+send_nomatch() {
+=09ip link set veth_a address "$(format_mac "${1}")"
+=09ip -n B link set veth_b address "$(format_mac "${2}")"
+
+=09for f in ${dst}; do
+=09=09eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+=09done
+=09for f in ${src}; do
+=09=09eval src_"$f"=3D\$\(format_\$f "${2}"\)
+=09done
+=09eval send_\$proto
+=09if [ "$(count_packets)" !=3D "0" ]; then
+=09=09err "${proto} packet to:"
+=09=09err "  $(for f in ${dst}; do
+=09=09=09 eval format_\$f "${1}"; printf ' '; done)"
+=09=09err "from:"
+=09=09err "  $(for f in ${src}; do
+=09=09=09 eval format_\$f "${2}"; printf ' '; done)"
+=09=09err "should not have matched ruleset:"
+=09=09err "$(nft list ruleset -a)"
+=09=09return 1
+=09fi
+}
+
+# Correctness test template:
+# - add ranged element, check that packets match it
+# - check that packets outside range don't match it
+# - remove some elements, check that packets don't match anymore
+test_correctness() {
+=09setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+
+=09range_size=3D1
+=09for i in $(seq "${start}" $((start + count))); do
+=09=09end=3D$((start + range_size))
+
+=09=09# Avoid negative or zero-sized port ranges
+=09=09if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+=09=09=09start=3D${end}
+=09=09=09end=3D$((end + 1))
+=09=09fi
+=09=09srcstart=3D$((start + src_delta))
+=09=09srcend=3D$((end + src_delta))
+
+=09=09add "$(format)" || return 1
+=09=09for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+=09=09=09send_match "${j}" $((j + src_delta)) || return 1
+=09=09done
+=09=09send_nomatch $((end + 1)) $((end + 1 + src_delta)) || return 1
+
+=09=09# Delete elements now and then
+=09=09if [ $((i % 3)) -eq 0 ]; then
+=09=09=09del "$(format)" || return 1
+=09=09=09for j in $(seq ${start} \
+=09=09=09=09   $((range_size / 2 + 1)) ${end}); do
+=09=09=09=09send_nomatch "${j}" $((j + src_delta)) \
+=09=09=09=09=09|| return 1
+=09=09=09done
+=09=09fi
+
+=09=09range_size=3D$((range_size + 1))
+=09=09start=3D$((end + range_size))
+=09done
+}
+
+# Concurrency test template:
+# - add all the elements
+# - start a thread for each physical thread that:
+#   - adds all the elements
+#   - flushes the set
+#   - adds all the elements
+#   - flushes the entire ruleset
+#   - adds the set back
+#   - adds all the elements
+#   - delete all the elements
+test_concurrency() {
+=09proto=3D${flood_proto}
+=09tools=3D${flood_tools}
+=09chain_spec=3D${flood_spec}
+=09setup veth flood_"${proto}" set || return ${KSELFTEST_SKIP}
+
+=09range_size=3D1
+=09cstart=3D${start}
+=09flood_pids=3D
+=09for i in $(seq ${start} $((start + count))); do
+=09=09end=3D$((start + range_size))
+=09=09srcstart=3D$((start + src_delta))
+=09=09srcend=3D$((end + src_delta))
+
+=09=09add "$(format)" || return 1
+
+=09=09flood "${i}" $((i + src_delta)) & flood_pids=3D"${flood_pids} $!"
+
+=09=09range_size=3D$((range_size + 1))
+=09=09start=3D$((end + range_size))
+=09done
+
+=09sleep 10
+
+=09pids=3D
+=09for c in $(seq 1 "$(nproc)"); do (
+=09=09for r in $(seq 1 "${race_repeat}"); do
+=09=09=09range_size=3D1
+
+=09=09=09# $start needs to be local to this subshell
+=09=09=09# shellcheck disable=3DSC2030
+=09=09=09start=3D${cstart}
+=09=09=09for i in $(seq ${start} $((start + count))); do
+=09=09=09=09end=3D$((start + range_size))
+=09=09=09=09srcstart=3D$((start + src_delta))
+=09=09=09=09srcend=3D$((end + src_delta))
+
+=09=09=09=09add "$(format)" 2>/dev/null
+
+=09=09=09=09range_size=3D$((range_size + 1))
+=09=09=09=09start=3D$((end + range_size))
+=09=09=09done
+
+=09=09=09nft flush inet filter test 2>/dev/null
+
+=09=09=09range_size=3D1
+=09=09=09start=3D${cstart}
+=09=09=09for i in $(seq ${start} $((start + count))); do
+=09=09=09=09end=3D$((start + range_size))
+=09=09=09=09srcstart=3D$((start + src_delta))
+=09=09=09=09srcend=3D$((end + src_delta))
+
+=09=09=09=09add "$(format)" 2>/dev/null
+
+=09=09=09=09range_size=3D$((range_size + 1))
+=09=09=09=09start=3D$((end + range_size))
+=09=09=09done
+
+=09=09=09nft flush ruleset
+=09=09=09setup set 2>/dev/null
+
+=09=09=09range_size=3D1
+=09=09=09start=3D${cstart}
+=09=09=09for i in $(seq ${start} $((start + count))); do
+=09=09=09=09end=3D$((start + range_size))
+=09=09=09=09srcstart=3D$((start + src_delta))
+=09=09=09=09srcend=3D$((end + src_delta))
+
+=09=09=09=09add "$(format)" 2>/dev/null
+
+=09=09=09=09range_size=3D$((range_size + 1))
+=09=09=09=09start=3D$((end + range_size))
+=09=09=09done
+
+=09=09=09range_size=3D1
+=09=09=09start=3D${cstart}
+=09=09=09for i in $(seq ${start} $((start + count))); do
+=09=09=09=09end=3D$((start + range_size))
+=09=09=09=09srcstart=3D$((start + src_delta))
+=09=09=09=09srcend=3D$((end + src_delta))
+
+=09=09=09=09del "$(format)" 2>/dev/null
+
+=09=09=09=09range_size=3D$((range_size + 1))
+=09=09=09=09start=3D$((end + range_size))
+=09=09=09done
+=09=09done
+=09) & pids=3D"${pids} $!"
+=09done
+
+=09# shellcheck disable=3DSC2046,SC2086 # word splitting wanted here
+=09wait $(for pid in ${pids}; do echo ${pid}; done)
+=09# shellcheck disable=3DSC2046,SC2086
+=09kill $(for pid in ${flood_pids}; do echo ${pid}; done) 2>/dev/null
+=09# shellcheck disable=3DSC2046,SC2086
+=09wait $(for pid in ${flood_pids}; do echo ${pid}; done) 2>/dev/null
+
+=09return 0
+}
+
+# Timeout test template:
+# - add all the elements with 3s timeout while checking that packets match
+# - wait 3s after the last insertion, check that packets don't match any e=
ntry
+test_timeout() {
+=09setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+
+=09timeout=3D3
+=09range_size=3D1
+=09for i in $(seq "${start}" $((start + count))); do
+=09=09end=3D$((start + range_size))
+=09=09srcstart=3D$((start + src_delta))
+=09=09srcend=3D$((end + src_delta))
+
+=09=09add "$(format)" || return 1
+
+=09=09for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+=09=09=09send_match "${j}" $((j + src_delta)) || return 1
+=09=09done
+
+=09=09range_size=3D$((range_size + 1))
+=09=09start=3D$((end + range_size))
+=09done
+=09sleep 3
+=09for i in $(seq ${start} $((start + count))); do
+=09=09end=3D$((start + range_size))
+=09=09srcstart=3D$((start + src_delta))
+=09=09srcend=3D$((end + src_delta))
+
+=09=09for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+=09=09=09send_nomatch "${j}" $((j + src_delta)) || return 1
+=09=09done
+
+=09=09range_size=3D$((range_size + 1))
+=09=09start=3D$((end + range_size))
+=09done
+}
+
+# Performance test template:
+# - add concatenated ranged entries
+# - add non-ranged concatenated entries (for hash set matching rate baseli=
ne)
+# - add ranged entries with first field only (for rbhash baseline)
+# - start pktgen injection directly on device rx path of this namespace
+# - measure drop only rate, hash and rbtree baselines, then matching rate
+test_performance() {
+=09chain_spec=3D${perf_spec}
+=09dst=3D"${perf_dst}"
+=09src=3D"${perf_src}"
+=09setup veth perf set || return ${KSELFTEST_SKIP}
+
+=09first=3D${start}
+=09range_size=3D1
+=09for set in test norange noconcat; do
+=09=09start=3D${first}
+=09=09for i in $(seq ${start} $((start + perf_entries))); do
+=09=09=09end=3D$((start + range_size))
+=09=09=09srcstart=3D$((start + src_delta))
+=09=09=09srcend=3D$((end + src_delta))
+
+=09=09=09if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+=09=09=09=09start=3D${end}
+=09=09=09=09end=3D$((end + 1))
+=09=09=09elif [ ${start} -eq ${end} ]; then
+=09=09=09=09end=3D$((start + 1))
+=09=09=09fi
+
+=09=09=09add_perf ${set}
+
+=09=09=09start=3D$((end + range_size))
+=09=09done > "${tmp}"
+=09=09nft -f "${tmp}"
+=09done
+
+=09perf $((end - 1)) ${srcstart}
+
+=09sleep 2
+
+=09nft add rule netdev perf test counter name \"test\" drop
+=09nft reset counter netdev perf test >/dev/null 2>&1
+=09sleep "${perf_duration}"
+=09pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+=09info "    baseline (drop from netdev hook):            ${pps}pps"
+=09handle=3D"$(nft -a list chain netdev perf test | grep counter)"
+=09handle=3D"${handle##* }"
+=09nft delete rule netdev perf test handle "${handle}"
+
+=09nft add rule "netdev perf test ${chain_spec} @norange \
+=09=09counter name \"test\" drop"
+=09nft reset counter netdev perf test >/dev/null 2>&1
+=09sleep "${perf_duration}"
+=09pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+=09info "    baseline hash (non-ranged entries):          ${pps}pps"
+=09handle=3D"$(nft -a list chain netdev perf test | grep counter)"
+=09handle=3D"${handle##* }"
+=09nft delete rule netdev perf test handle "${handle}"
+
+=09nft add rule "netdev perf test ${chain_spec%%. *} @noconcat \
+=09=09counter name \"test\" drop"
+=09nft reset counter netdev perf test >/dev/null 2>&1
+=09sleep "${perf_duration}"
+=09pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+=09info "    baseline rbtree (match on first field only): ${pps}pps"
+=09handle=3D"$(nft -a list chain netdev perf test | grep counter)"
+=09handle=3D"${handle##* }"
+=09nft delete rule netdev perf test handle "${handle}"
+
+=09nft add rule "netdev perf test ${chain_spec} @test \
+=09=09counter name \"test\" drop"
+=09nft reset counter netdev perf test >/dev/null 2>&1
+=09sleep "${perf_duration}"
+=09pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+=09p5=3D"$(printf %5s "${perf_entries}")"
+=09info "    set with ${p5} full, ranged entries:         ${pps}pps"
+=09kill "${perf_pid}"
+}
+
+# Run everything in a separate network namespace
+[ "${1}" !=3D "run" ] && { unshare -n "${0}" run; exit $?; }
+tmp=3D"$(mktemp)"
+trap cleanup EXIT
+
+# Entry point for test runs
+passed=3D0
+for name in ${TESTS}; do
+=09printf "TEST: %s\n" "${name}"
+=09for type in ${TYPES}; do
+=09=09eval desc=3D\$TYPE_"${type}"
+=09=09IFS=3D'
+'
+=09=09for __line in ${desc}; do
+=09=09=09# shellcheck disable=3DSC2086
+=09=09=09eval ${__line%%=09*}=3D\"${__line##*=09}\";
+=09=09done
+=09=09IFS=3D' =09
+'
+
+=09=09if [ "${name}" =3D "concurrency" ] && \
+=09=09   [ "${race_repeat}" =3D "0" ]; then
+=09=09=09continue
+=09=09fi
+=09=09if [ "${name}" =3D "performance" ] && \
+=09=09   [ "${perf_duration}" =3D "0" ]; then
+=09=09=09continue
+=09=09fi
+
+=09=09printf "  %-60s  " "${display}"
+=09=09eval test_"${name}"
+=09=09ret=3D$?
+
+=09=09if [ $ret -eq 0 ]; then
+=09=09=09printf "[ OK ]\n"
+=09=09=09info_flush
+=09=09=09passed=3D$((passed + 1))
+=09=09elif [ $ret -eq 1 ]; then
+=09=09=09printf "[FAIL]\n"
+=09=09=09err_flush
+=09=09=09exit 1
+=09=09elif [ $ret -eq ${KSELFTEST_SKIP} ]; then
+=09=09=09printf "[SKIP]\n"
+=09=09=09err_flush
+=09=09fi
+=09done
+done
+
+[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP}
--=20
2.20.1

