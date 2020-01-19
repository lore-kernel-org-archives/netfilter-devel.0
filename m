Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17BEC33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC3220663
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yk4D95ti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgASNdv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:33:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57629 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727075AbgASNdu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:33:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NnCfQfszAy/iudHiMfGCgWW0MXmdmyyb5m3RbyMEQ6g=;
        b=Yk4D95tiBoYeOo5tTEEqRA0ljvqRmQddBzBJmYl4XrWzo5AQuNlbnt75CjZyib2PQrSOkX
        zZCYuVFXAT+bRF9OHGl6Ua/dZLNEVIxxFui798IrLgMm5WTfwEpqVSKDHUJi2dlH4pR2ZJ
        pGtuVHjdzorqSndR9j3QR9us17OKfmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-GJLUphaRPPy_fyv97Qs0Yg-1; Sun, 19 Jan 2020 08:33:45 -0500
X-MC-Unique: GJLUphaRPPy_fyv97Qs0Yg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D94FE100550E;
        Sun, 19 Jan 2020 13:33:43 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74D315D9CA;
        Sun, 19 Jan 2020 13:33:40 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v3 6/9] selftests: netfilter: Introduce tests for sets with range concatenation
Date:   Sun, 19 Jan 2020 14:33:18 +0100
Message-Id: <ebb1bdb700cf8328531c77c0276af1fb45eec6d9.1579434906.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579434906.git.sbrivio@redhat.com>
References: <cover.1579434906.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
v3: No changes
v2: No changes

 tools/testing/selftests/netfilter/Makefile    |    3 +-
 .../selftests/netfilter/nft_concat_range.sh   | 1481 +++++++++++++++++
 2 files changed, 1483 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_concat_range.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/s=
elftests/netfilter/Makefile
index de1032b5ddea..08194aa44006 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -2,6 +2,7 @@
 # Makefile for netfilter selftests
=20
 TEST_PROGS :=3D nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
-	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh
+	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
+	nft_concat_range.sh
=20
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tool=
s/testing/selftests/netfilter/nft_concat_range.sh
new file mode 100755
index 000000000000..aca21dde102a
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -0,0 +1,1481 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# nft_concat_range.sh - Tests for sets with concatenation of ranged fiel=
ds
+#
+# Copyright (c) 2019 Red Hat GmbH
+#
+# Author: Stefano Brivio <sbrivio@redhat.com>
+#
+# shellcheck disable=3DSC2154,SC2034,SC2016,SC2030,SC2031
+# ^ Configuration and templates sourced with eval, counters reused in su=
bshells
+
+KSELFTEST_SKIP=3D4
+
+# Available test groups:
+# - correctness: check that packets match given entries, and only those
+# - concurrency: attempt races between insertion, deletion and lookup
+# - timeout: check that packets match entries until they expire
+# - performance: estimate matching rate, compare with rbtree and hash ba=
selines
+TESTS=3D"correctness concurrency timeout"
+[ "${quicktest}" !=3D "1" ] && TESTS=3D"${TESTS} performance"
+
+# Set types, defined by TYPE_ variables below
+TYPES=3D"net_port port_net net6_port port_proto net6_port_mac net6_port_=
mac_proto
+       net_port_net net_mac net_mac_icmp net6_mac_icmp net6_port_net6_po=
rt
+       net_port_mac_proto_net"
+
+# List of possible paths to pktgen script from kernel tree for performan=
ce tests
+PKTGEN_SCRIPT_PATHS=3D"
+	../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+	pktgen/pktgen_bench_xmit_mode_netif_receive.sh"
+
+# Definition of set types:
+# display	display text for test report
+# type_spec	nftables set type specifier
+# chain_spec	nftables type specifier for rules mapping to set
+# dst		call sequence of format_*() functions for destination fields
+# src		call sequence of format_*() functions for source fields
+# start		initial integer used to generate addresses and ports
+# count		count of entries to generate and match
+# src_delta	number summed to destination generator for source fields
+# tools		list of tools for correctness and timeout tests, any can be use=
d
+# proto		L4 protocol of test packets
+#
+# race_repeat	race attempts per thread, 0 disables concurrency test for =
type
+# flood_tools	list of tools for concurrency tests, any can be used
+# flood_proto	L4 protocol of test packets for concurrency tests
+# flood_spec	nftables type specifier for concurrency tests
+#
+# perf_duration	duration of single pktgen injection test
+# perf_spec	nftables type specifier for performance tests
+# perf_dst	format_*() functions for destination fields in performance te=
st
+# perf_src	format_*() functions for source fields in performance test
+# perf_entries	number of set entries for performance test
+# perf_proto	L3 protocol of test packets
+TYPE_net_port=3D"
+display		net,port
+type_spec	ipv4_addr . inet_service
+chain_spec	ip daddr . udp dport
+dst		addr4 port
+src		=20
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	3
+flood_tools	iperf3 iperf netperf
+flood_proto	udp
+flood_spec	ip daddr . udp dport
+
+perf_duration	5
+perf_spec	ip daddr . udp dport
+perf_dst	addr4 port
+perf_src	=20
+perf_entries	1000
+perf_proto	ipv4
+"
+
+TYPE_port_net=3D"
+display		port,net
+type_spec	inet_service . ipv4_addr
+chain_spec	udp dport . ip daddr
+dst		port addr4
+src		=20
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	3
+flood_tools	iperf3 iperf netperf
+flood_proto	udp
+flood_spec	udp dport . ip daddr
+
+perf_duration	5
+perf_spec	udp dport . ip daddr
+perf_dst	port addr4
+perf_src	=20
+perf_entries	100
+perf_proto	ipv4
+"
+
+TYPE_net6_port=3D"
+display		net6,port
+type_spec	ipv6_addr . inet_service
+chain_spec	ip6 daddr . udp dport
+dst		addr6 port
+src		=20
+start		10
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp6
+
+race_repeat	3
+flood_tools	iperf3 iperf netperf
+flood_proto	tcp6
+flood_spec	ip6 daddr . udp dport
+
+perf_duration	5
+perf_spec	ip6 daddr . udp dport
+perf_dst	addr6 port
+perf_src	=20
+perf_entries	1000
+perf_proto	ipv6
+"
+
+TYPE_port_proto=3D"
+display		port,proto
+type_spec	inet_service . inet_proto
+chain_spec	udp dport . meta l4proto
+dst		port proto
+src		=20
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	5
+perf_spec	udp dport . meta l4proto
+perf_dst	port proto
+perf_src	=20
+perf_entries	30000
+perf_proto	ipv4
+"
+
+TYPE_net6_port_mac=3D"
+display		net6,port,mac
+type_spec	ipv6_addr . inet_service . ether_addr
+chain_spec	ip6 daddr . udp dport . ether saddr
+dst		addr6 port
+src		mac
+start		10
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp6
+
+race_repeat	0
+
+perf_duration	5
+perf_spec	ip6 daddr . udp dport . ether daddr
+perf_dst	addr6 port mac
+perf_src	=20
+perf_entries	10
+perf_proto	ipv6
+"
+
+TYPE_net6_port_mac_proto=3D"
+display		net6,port,mac,proto
+type_spec	ipv6_addr . inet_service . ether_addr . inet_proto
+chain_spec	ip6 daddr . udp dport . ether saddr . meta l4proto
+dst		addr6 port
+src		mac proto
+start		10
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp6
+
+race_repeat	0
+
+perf_duration	5
+perf_spec	ip6 daddr . udp dport . ether daddr . meta l4proto
+perf_dst	addr6 port mac proto
+perf_src	=20
+perf_entries	1000
+perf_proto	ipv6
+"
+
+TYPE_net_port_net=3D"
+display		net,port,net
+type_spec	ipv4_addr . inet_service . ipv4_addr
+chain_spec	ip daddr . udp dport . ip saddr
+dst		addr4 port
+src		addr4
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	3
+flood_tools	iperf3 iperf netperf
+flood_proto	tcp
+flood_spec	ip daddr . udp dport . ip saddr
+
+perf_duration	0
+"
+
+TYPE_net6_port_net6_port=3D"
+display		net6,port,net6,port
+type_spec	ipv6_addr . inet_service . ipv6_addr . inet_service
+chain_spec	ip6 daddr . udp dport . ip6 saddr . udp sport
+dst		addr6 port
+src		addr6 port
+start		10
+count		5
+src_delta	2000
+tools		sendip nc
+proto		udp6
+
+race_repeat	3
+flood_tools	iperf3 iperf netperf
+flood_proto	tcp6
+flood_spec	ip6 daddr . tcp dport . ip6 saddr . tcp sport
+
+perf_duration	0
+"
+
+TYPE_net_port_mac_proto_net=3D"
+display		net,port,mac,proto,net
+type_spec	ipv4_addr . inet_service . ether_addr . inet_proto . ipv4_addr
+chain_spec	ip daddr . udp dport . ether saddr . meta l4proto . ip saddr
+dst		addr4 port
+src		mac proto addr4
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	0
+"
+
+TYPE_net_mac=3D"
+display		net,mac
+type_spec	ipv4_addr . ether_addr
+chain_spec	ip daddr . ether saddr
+dst		addr4
+src		mac
+start		1
+count		5
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	5
+perf_spec	ip daddr . ether daddr
+perf_dst	addr4 mac
+perf_src	=20
+perf_entries	1000
+perf_proto	ipv4
+"
+
+TYPE_net_mac_icmp=3D"
+display		net,mac - ICMP
+type_spec	ipv4_addr . ether_addr
+chain_spec	ip daddr . ether saddr
+dst		addr4
+src		mac
+start		1
+count		5
+src_delta	2000
+tools		ping
+proto		icmp
+
+race_repeat	0
+
+perf_duration	0
+"
+
+TYPE_net6_mac_icmp=3D"
+display		net6,mac - ICMPv6
+type_spec	ipv6_addr . ether_addr
+chain_spec	ip6 daddr . ether saddr
+dst		addr6
+src		mac
+start		10
+count		50
+src_delta	2000
+tools		ping
+proto		icmp6
+
+race_repeat	0
+
+perf_duration	0
+"
+
+TYPE_net_port_proto_net=3D"
+display		net,port,proto,net
+type_spec	ipv4_addr . inet_service . inet_proto . ipv4_addr
+chain_spec	ip daddr . udp dport . meta l4proto . ip saddr
+dst		addr4 port proto
+src		addr4
+start		1
+count		5
+src_delta	2000
+tools		sendip nc
+proto		udp
+
+race_repeat	3
+flood_tools	iperf3 iperf netperf
+flood_proto	tcp
+flood_spec	ip daddr . tcp dport . meta l4proto . ip saddr
+
+perf_duration	0
+"
+
+# Set template for all tests, types and rules are filled in depending on=
 test
+set_template=3D'
+flush ruleset
+
+table inet filter {
+	counter test {
+		packets 0 bytes 0
+	}
+
+	set test {
+		type ${type_spec}
+		flags interval,timeout
+	}
+
+	chain input {
+		type filter hook prerouting priority 0; policy accept;
+		${chain_spec} @test counter name \"test\"
+	}
+}
+
+table netdev perf {
+	counter test {
+		packets 0 bytes 0
+	}
+
+	counter match {
+		packets 0 bytes 0
+	}
+
+	set test {
+		type ${type_spec}
+		flags interval
+	}
+
+	set norange {
+		type ${type_spec}
+	}
+
+	set noconcat {
+		type ${type_spec%% *}
+		flags interval
+	}
+
+	chain test {
+		type filter hook ingress device veth_a priority 0;
+	}
+}
+'
+
+err_buf=3D
+info_buf=3D
+
+# Append string to error buffer
+err() {
+	err_buf=3D"${err_buf}${1}
+"
+}
+
+# Append string to information buffer
+info() {
+	info_buf=3D"${info_buf}${1}
+"
+}
+
+# Flush error buffer to stdout
+err_flush() {
+	printf "%s" "${err_buf}"
+	err_buf=3D
+}
+
+# Flush information buffer to stdout
+info_flush() {
+	printf "%s" "${info_buf}"
+	info_buf=3D
+}
+
+# Setup veth pair: this namespace receives traffic, B generates it
+setup_veth() {
+	ip netns add B
+	ip link add veth_a type veth peer name veth_b || return 1
+
+	ip link set veth_a up
+	ip link set veth_b netns B
+
+	ip -n B link set veth_b up
+
+	ip addr add dev veth_a 10.0.0.1
+	ip route add default dev veth_a
+
+	ip -6 addr add fe80::1/64 dev veth_a nodad
+	ip -6 addr add 2001:db8::1/64 dev veth_a nodad
+	ip -6 route add default dev veth_a
+
+	ip -n B route add default dev veth_b
+
+	ip -6 -n B addr add fe80::2/64 dev veth_b nodad
+	ip -6 -n B addr add 2001:db8::2/64 dev veth_b nodad
+	ip -6 -n B route add default dev veth_b
+
+	B() {
+		ip netns exec B "$@" >/dev/null 2>&1
+	}
+
+	sleep 2
+}
+
+# Fill in set template and initialise set
+setup_set() {
+	eval "echo \"${set_template}\"" | nft -f -
+}
+
+# Check that at least one of the needed tools is available
+check_tools() {
+	__tools=3D
+	for tool in ${tools}; do
+		if [ "${tool}" =3D "nc" ] && [ "${proto}" =3D "udp6" ] && \
+		   ! nc -u -w0 1.1.1.1 1 2>/dev/null; then
+			# Some GNU netcat builds might not support IPv6
+			__tools=3D"${__tools} netcat-openbsd"
+			continue
+		fi
+		__tools=3D"${__tools} ${tool}"
+
+		command -v "${tool}" >/dev/null && return 0
+	done
+	err "need one of:${__tools}, skipping" && return 1
+}
+
+# Set up function to send ICMP packets
+setup_send_icmp() {
+	send_icmp() {
+		B ping -c1 -W1 "${dst_addr4}" >/dev/null 2>&1
+	}
+}
+
+# Set up function to send ICMPv6 packets
+setup_send_icmp6() {
+	if command -v ping6 >/dev/null; then
+		send_icmp6() {
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+			B ping6 -q -c1 -W1 "${dst_addr6}"
+		}
+	else
+		send_icmp6() {
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+			B ping -q -6 -c1 -W1 "${dst_addr6}"
+		}
+	fi
+}
+
+# Set up function to send single UDP packets on IPv4
+setup_send_udp() {
+	if command -v sendip >/dev/null; then
+		send_udp() {
+			[ -n "${src_port}" ] && src_port=3D"-us ${src_port}"
+			[ -n "${dst_port}" ] && dst_port=3D"-ud ${dst_port}"
+			[ -n "${src_addr4}" ] && src_addr4=3D"-is ${src_addr4}"
+
+			# shellcheck disable=3DSC2086 # sendip needs split options
+			B sendip -p ipv4 -p udp ${src_addr4} ${src_port} \
+						${dst_port} "${dst_addr4}"
+
+			src_port=3D
+			dst_port=3D
+			src_addr4=3D
+		}
+	elif command -v nc >/dev/null; then
+		if nc -u -w0 1.1.1.1 1 2>/dev/null; then
+			# OpenBSD netcat
+			nc_opt=3D"-w0"
+		else
+			# GNU netcat
+			nc_opt=3D"-q0"
+		fi
+
+		send_udp() {
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}" dev veth_b
+				__src_addr4=3D"-s ${src_addr4}"
+			fi
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+			[ -n "${src_port}" ] && src_port=3D"-p ${src_port}"
+
+			echo "" | B nc -u "${nc_opt}" "${__src_addr4}" \
+				  "${src_port}" "${dst_addr4}" "${dst_port}"
+
+			src_addr4=3D
+			src_port=3D
+		}
+	elif [ -z "$(bash -c 'type -p')" ]; then
+		send_udp() {
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}/16" dev veth_b
+				B ip route add default dev veth_b
+			fi
+
+			B bash -c "echo > /dev/udp/${dst_addr4}/${dst_port}"
+
+			if [ -n "${src_addr4}" ]; then
+				B ip addr del "${src_addr4}/16" dev veth_b
+			fi
+			src_addr4=3D
+		}
+	else
+		return 1
+	fi
+}
+
+# Set up function to send single UDP packets on IPv6
+setup_send_udp6() {
+	if command -v sendip >/dev/null; then
+		send_udp6() {
+			[ -n "${src_port}" ] && src_port=3D"-us ${src_port}"
+			[ -n "${dst_port}" ] && dst_port=3D"-ud ${dst_port}"
+			if [ -n "${src_addr6}" ]; then
+				src_addr6=3D"-6s ${src_addr6}"
+			else
+				src_addr6=3D"-6s 2001:db8::2"
+			fi
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B sendip -p ipv6 -p udp ${src_addr6} ${src_port} \
+						${dst_port} "${dst_addr6}"
+
+			src_port=3D
+			dst_port=3D
+			src_addr6=3D
+		}
+	elif command -v nc >/dev/null && nc -u -w0 1.1.1.1 1 2>/dev/null; then
+		# GNU netcat might not work with IPv6, try next tool
+		send_udp6() {
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+			if [ -n "${src_addr6}" ]; then
+				B ip addr add "${src_addr6}" dev veth_b nodad
+			else
+				src_addr6=3D"2001:db8::2"
+			fi
+			[ -n "${src_port}" ] && src_port=3D"-p ${src_port}"
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			echo "" | B nc -u w0 "-s${src_addr6}" ${src_port} \
+					       ${dst_addr6} ${dst_port}
+
+			src_addr6=3D
+			src_port=3D
+		}
+	elif [ -z "$(bash -c 'type -p')" ]; then
+		send_udp6() {
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+			B ip addr add "${src_addr6}" dev veth_b nodad
+			B bash -c "echo > /dev/udp/${dst_addr6}/${dst_port}"
+			ip -6 addr del "${dst_addr6}" dev veth_a 2>/dev/null
+		}
+	else
+		return 1
+	fi
+}
+
+# Set up function to send TCP traffic on IPv4
+setup_flood_tcp() {
+	if command -v iperf3 >/dev/null; then
+		flood_tcp() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}/16" dev veth_b
+				src_addr4=3D"-B ${src_addr4}"
+			else
+				B ip addr add dev veth_b 10.0.0.2
+				src_addr4=3D"-B 10.0.0.2"
+			fi
+			if [ -n "${src_port}" ]; then
+				src_port=3D"--cport ${src_port}"
+			fi
+			B ip route add default dev veth_b 2>/dev/null
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			iperf3 -s -DB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B iperf3 -c "${dst_addr4}" ${dst_port} ${src_port} \
+				${src_addr4} -l16 -t 1000
+
+			src_addr4=3D
+			src_port=3D
+			dst_port=3D
+		}
+	elif command -v iperf >/dev/null; then
+		flood_tcp() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}/16" dev veth_b
+				src_addr4=3D"-B ${src_addr4}"
+			else
+				B ip addr add dev veth_b 10.0.0.2 2>/dev/null
+				src_addr4=3D"-B 10.0.0.2"
+			fi
+			if [ -n "${src_port}" ]; then
+				src_addr4=3D"${src_addr4}:${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			iperf -s -DB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B iperf -c "${dst_addr4}" ${dst_port} ${src_addr4} \
+				-l20 -t 1000
+
+			src_addr4=3D
+			src_port=3D
+			dst_port=3D
+		}
+	elif command -v netperf >/dev/null; then
+		flood_tcp() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}/16" dev veth_b
+			else
+				B ip addr add dev veth_b 10.0.0.2
+				src_addr4=3D"10.0.0.2"
+			fi
+			if [ -n "${src_port}" ]; then
+				dst_port=3D"${dst_port},${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			netserver -4 ${dst_port} -L "${dst_addr4}" \
+				>/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B netperf -4 -H "${dst_addr4}" ${dst_port} \
+				-L "${src_addr4}" -l 1000 -t TCP_STREAM
+
+			src_addr4=3D
+			src_port=3D
+			dst_port=3D
+		}
+	else
+		return 1
+	fi
+}
+
+# Set up function to send TCP traffic on IPv6
+setup_flood_tcp6() {
+	if command -v iperf3 >/dev/null; then
+		flood_tcp6() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr6}" ]; then
+				B ip addr add "${src_addr6}" dev veth_b nodad
+				src_addr6=3D"-B ${src_addr6}"
+			else
+				src_addr6=3D"-B 2001:db8::2"
+			fi
+			if [ -n "${src_port}" ]; then
+				src_port=3D"--cport ${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			iperf3 -s -DB "${dst_addr6}" ${dst_port} >/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B iperf3 -c "${dst_addr6}" ${dst_port} \
+				${src_port} ${src_addr6} -l16 -t 1000
+
+			src_addr6=3D
+			src_port=3D
+			dst_port=3D
+		}
+	elif command -v iperf >/dev/null; then
+		flood_tcp6() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr6}" ]; then
+				B ip addr add "${src_addr6}" dev veth_b nodad
+				src_addr6=3D"-B ${src_addr6}"
+			else
+				src_addr6=3D"-B 2001:db8::2"
+			fi
+			if [ -n "${src_port}" ]; then
+				src_addr6=3D"${src_addr6}:${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			iperf -s -VDB "${dst_addr6}" ${dst_port} >/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B iperf -c "${dst_addr6}" -V ${dst_port} \
+				${src_addr6} -l1 -t 1000
+
+			src_addr6=3D
+			src_port=3D
+			dst_port=3D
+		}
+	elif command -v netperf >/dev/null; then
+		flood_tcp6() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr6}" ]; then
+				B ip addr add "${src_addr6}" dev veth_b nodad
+			else
+				src_addr6=3D"2001:db8::2"
+			fi
+			if [ -n "${src_port}" ]; then
+				dst_port=3D"${dst_port},${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
+				2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			netserver -6 ${dst_port} -L "${dst_addr6}" \
+				>/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B netperf -6 -H "${dst_addr6}" ${dst_port} \
+				-L "${src_addr6}" -l 1000 -t TCP_STREAM
+
+			src_addr6=3D
+			src_port=3D
+			dst_port=3D
+		}
+	else
+		return 1
+	fi
+}
+
+# Set up function to send UDP traffic on IPv4
+setup_flood_udp() {
+	if command -v iperf3 >/dev/null; then
+		flood_udp() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}/16" dev veth_b
+				src_addr4=3D"-B ${src_addr4}"
+			else
+				B ip addr add dev veth_b 10.0.0.2 2>/dev/null
+				src_addr4=3D"-B 10.0.0.2"
+			fi
+			if [ -n "${src_port}" ]; then
+				src_port=3D"--cport ${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			iperf3 -s -DB "${dst_addr4}" ${dst_port}
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B iperf3 -u -c "${dst_addr4}" -Z -b 100M -l16 -t1000 \
+				${dst_port} ${src_port} ${src_addr4}
+
+			src_addr4=3D
+			src_port=3D
+			dst_port=3D
+		}
+	elif command -v iperf >/dev/null; then
+		flood_udp() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}/16" dev veth_b
+				src_addr4=3D"-B ${src_addr4}"
+			else
+				B ip addr add dev veth_b 10.0.0.2
+				src_addr4=3D"-B 10.0.0.2"
+			fi
+			if [ -n "${src_port}" ]; then
+				src_addr4=3D"${src_addr4}:${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			iperf -u -sDB "${dst_addr4}" ${dst_port} >/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B iperf -u -c "${dst_addr4}" -b 100M -l1 -t1000 \
+				${dst_port} ${src_addr4}
+
+			src_addr4=3D
+			src_port=3D
+			dst_port=3D
+		}
+	elif command -v netperf >/dev/null; then
+		flood_udp() {
+			[ -n "${dst_port}" ] && dst_port=3D"-p ${dst_port}"
+			if [ -n "${src_addr4}" ]; then
+				B ip addr add "${src_addr4}/16" dev veth_b
+			else
+				B ip addr add dev veth_b 10.0.0.2
+				src_addr4=3D"10.0.0.2"
+			fi
+			if [ -n "${src_port}" ]; then
+				dst_port=3D"${dst_port},${src_port}"
+			fi
+			B ip route add default dev veth_b
+			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			netserver -4 ${dst_port} -L "${dst_addr4}" \
+				>/dev/null 2>&1
+			sleep 2
+
+			# shellcheck disable=3DSC2086 # this needs split options
+			B netperf -4 -H "${dst_addr4}" ${dst_port} \
+				-L "${src_addr4}" -l 1000 -t UDP_STREAM
+
+			src_addr4=3D
+			src_port=3D
+			dst_port=3D
+		}
+	else
+		return 1
+	fi
+}
+
+# Find pktgen script and set up function to start pktgen injection
+setup_perf() {
+	for pktgen_script_path in ${PKTGEN_SCRIPT_PATHS} __notfound; do
+		command -v "${pktgen_script_path}" >/dev/null && break
+	done
+	[ "${pktgen_script_path}" =3D "__notfound" ] && return 1
+
+	perf_ipv4() {
+		${pktgen_script_path} -s80 \
+			-i veth_a -d "${dst_addr4}" -p "${dst_port}" \
+			-m "${dst_mac}" \
+			-t $(($(nproc) / 5 + 1)) -b10000 -n0 2>/dev/null &
+		perf_pid=3D$!
+	}
+	perf_ipv6() {
+		IP6=3D6 ${pktgen_script_path} -s100 \
+			-i veth_a -d "${dst_addr6}" -p "${dst_port}" \
+			-m "${dst_mac}" \
+			-t $(($(nproc) / 5 + 1)) -b10000 -n0 2>/dev/null &
+		perf_pid=3D$!
+	}
+}
+
+# Clean up before each test
+cleanup() {
+	nft reset counter inet filter test	>/dev/null 2>&1
+	nft flush ruleset			>/dev/null 2>&1
+	ip link del dummy0			2>/dev/null
+	ip route del default			2>/dev/null
+	ip -6 route del default			2>/dev/null
+	ip netns del B				2>/dev/null
+	ip link del veth_a			2>/dev/null
+	timeout=3D
+	killall iperf3				2>/dev/null
+	killall iperf				2>/dev/null
+	killall netperf				2>/dev/null
+	killall netserver			2>/dev/null
+	rm -f ${tmp}
+	sleep 2
+}
+
+# Entry point for setup functions
+setup() {
+	if [ "$(id -u)" -ne 0 ]; then
+		echo "  need to run as root"
+		exit ${KSELFTEST_SKIP}
+	fi
+
+	cleanup
+	check_tools || return 1
+	for arg do
+		if ! eval setup_"${arg}"; then
+			err "  ${arg} not supported"
+			return 1
+		fi
+	done
+}
+
+# Format integer into IPv4 address, summing 10.0.0.5 (arbitrary) to it
+format_addr4() {
+	a=3D$((${1} + 16777216 * 10 + 5))
+	printf "%i.%i.%i.%i"						\
+	       "$((a / 16777216))" "$((a % 16777216 / 65536))"	\
+	       "$((a % 65536 / 256))" "$((a % 256))"
+}
+
+# Format integer into IPv6 address, summing 2001:db8:: to it
+format_addr6() {
+	printf "2001:db8::%04x:%04x" "$((${1} / 65536))" "$((${1} % 65536))"
+}
+
+# Format integer into EUI-48 address, summing 00:01:00:00:00:00 to it
+format_mac() {
+	printf "00:01:%02x:%02x:%02x:%02x" \
+	       "$((${1} / 16777216))" "$((${1} % 16777216 / 65536))"	\
+	       "$((${1} % 65536 / 256))" "$((${1} % 256))"
+}
+
+# Format integer into port, avoid 0 port
+format_port() {
+	printf "%i" "$((${1} % 65534 + 1))"
+}
+
+# Drop suffixed '6' from L4 protocol, if any
+format_proto() {
+	printf "%s" "${proto}" | tr -d 6
+}
+
+# Format destination and source fields into nft concatenated type
+format() {
+	__start=3D
+	__end=3D
+	__expr=3D"{ "
+
+	for f in ${dst}; do
+		[ "${__expr}" !=3D "{ " ] && __expr=3D"${__expr} . "
+
+		__start=3D"$(eval format_"${f}" "${start}")"
+		__end=3D"$(eval format_"${f}" "${end}")"
+
+		if [ "${f}" =3D "proto" ]; then
+			__expr=3D"${__expr}${__start}"
+		else
+			__expr=3D"${__expr}${__start}-${__end}"
+		fi
+	done
+	for f in ${src}; do
+		__expr=3D"${__expr} . "
+		__start=3D"$(eval format_"${f}" "${srcstart}")"
+		__end=3D"$(eval format_"${f}" "${srcend}")"
+
+		if [ "${f}" =3D "proto" ]; then
+			__expr=3D"${__expr}${__start}"
+		else
+			__expr=3D"${__expr}${__start}-${__end}"
+		fi
+	done
+
+	if [ -n "${timeout}" ]; then
+		echo "${__expr} timeout ${timeout}s }"
+	else
+		echo "${__expr} }"
+	fi
+}
+
+# Format destination and source fields into nft type, start element only
+format_norange() {
+	__expr=3D"{ "
+
+	for f in ${dst}; do
+		[ "${__expr}" !=3D "{ " ] && __expr=3D"${__expr} . "
+
+		__expr=3D"${__expr}$(eval format_"${f}" "${start}")"
+	done
+	for f in ${src}; do
+		__expr=3D"${__expr} . $(eval format_"${f}" "${start}")"
+	done
+
+	echo "${__expr} }"
+}
+
+# Format first destination field into nft type
+format_noconcat() {
+	for f in ${dst}; do
+		__start=3D"$(eval format_"${f}" "${start}")"
+		__end=3D"$(eval format_"${f}" "${end}")"
+
+		if [ "${f}" =3D "proto" ]; then
+			echo "{ ${__start} }"
+		else
+			echo "{ ${__start}-${__end} }"
+		fi
+		return
+	done
+}
+
+# Add single entry to 'test' set in 'inet filter' table
+add() {
+	if ! nft add element inet filter test "${1}"; then
+		err "Failed to add ${1} given ruleset:"
+		err "$(nft list ruleset -a)"
+		return 1
+	fi
+}
+
+# Format and output entries for sets in 'netdev perf' table
+add_perf() {
+	if [ "${1}" =3D "test" ]; then
+		echo "add element netdev perf test $(format)"
+	elif [ "${1}" =3D "norange" ]; then
+		echo "add element netdev perf norange $(format_norange)"
+	elif [ "${1}" =3D "noconcat" ]; then
+		echo "add element netdev perf noconcat $(format_noconcat)"
+	fi
+}
+
+# Add single entry to 'norange' set in 'netdev perf' table
+add_perf_norange() {
+	if ! nft add element netdev perf norange "${1}"; then
+		err "Failed to add ${1} given ruleset:"
+		err "$(nft list ruleset -a)"
+		return 1
+	fi
+}
+
+# Add single entry to 'noconcat' set in 'netdev perf' table
+add_perf_noconcat() {
+	if ! nft add element netdev perf noconcat "${1}"; then
+		err "Failed to add ${1} given ruleset:"
+		err "$(nft list ruleset -a)"
+		return 1
+	fi
+}
+
+# Delete single entry from set
+del() {
+	if ! nft delete element inet filter test "${1}"; then
+		err "Failed to delete ${1} given ruleset:"
+		err "$(nft list ruleset -a)"
+		return 1
+	fi
+}
+
+# Return packet count from 'test' counter in 'inet filter' table
+count_packets() {
+	found=3D0
+	for token in $(nft list counter inet filter test); do
+		[ ${found} -eq 1 ] && echo "${token}" && return
+		[ "${token}" =3D "packets" ] && found=3D1
+	done
+}
+
+# Return packet count from 'test' counter in 'netdev perf' table
+count_perf_packets() {
+	found=3D0
+	for token in $(nft list counter netdev perf test); do
+		[ ${found} -eq 1 ] && echo "${token}" && return
+		[ "${token}" =3D "packets" ] && found=3D1
+	done
+}
+
+# Set MAC addresses, send traffic according to specifier
+flood() {
+	ip link set veth_a address "$(format_mac "${1}")"
+	ip -n B link set veth_b address "$(format_mac "${2}")"
+
+	for f in ${dst}; do
+		eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+	done
+	for f in ${src}; do
+		eval src_"$f"=3D\$\(format_\$f "${2}"\)
+	done
+	eval flood_\$proto
+}
+
+# Set MAC addresses, start pktgen injection
+perf() {
+	dst_mac=3D"$(format_mac "${1}")"
+	ip link set veth_a address "${dst_mac}"
+
+	for f in ${dst}; do
+		eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+	done
+	for f in ${src}; do
+		eval src_"$f"=3D\$\(format_\$f "${2}"\)
+	done
+	eval perf_\$perf_proto
+}
+
+# Set MAC addresses, send single packet, check that it matches, reset co=
unter
+send_match() {
+	ip link set veth_a address "$(format_mac "${1}")"
+	ip -n B link set veth_b address "$(format_mac "${2}")"
+
+	for f in ${dst}; do
+		eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+	done
+	for f in ${src}; do
+		eval src_"$f"=3D\$\(format_\$f "${2}"\)
+	done
+	eval send_\$proto
+	if [ "$(count_packets)" !=3D "1" ]; then
+		err "${proto} packet to:"
+		err "  $(for f in ${dst}; do
+			 eval format_\$f "${1}"; printf ' '; done)"
+		err "from:"
+		err "  $(for f in ${src}; do
+			 eval format_\$f "${2}"; printf ' '; done)"
+		err "should have matched ruleset:"
+		err "$(nft list ruleset -a)"
+		return 1
+	fi
+	nft reset counter inet filter test >/dev/null
+}
+
+# Set MAC addresses, send single packet, check that it doesn't match
+send_nomatch() {
+	ip link set veth_a address "$(format_mac "${1}")"
+	ip -n B link set veth_b address "$(format_mac "${2}")"
+
+	for f in ${dst}; do
+		eval dst_"$f"=3D\$\(format_\$f "${1}"\)
+	done
+	for f in ${src}; do
+		eval src_"$f"=3D\$\(format_\$f "${2}"\)
+	done
+	eval send_\$proto
+	if [ "$(count_packets)" !=3D "0" ]; then
+		err "${proto} packet to:"
+		err "  $(for f in ${dst}; do
+			 eval format_\$f "${1}"; printf ' '; done)"
+		err "from:"
+		err "  $(for f in ${src}; do
+			 eval format_\$f "${2}"; printf ' '; done)"
+		err "should not have matched ruleset:"
+		err "$(nft list ruleset -a)"
+		return 1
+	fi
+}
+
+# Correctness test template:
+# - add ranged element, check that packets match it
+# - check that packets outside range don't match it
+# - remove some elements, check that packets don't match anymore
+test_correctness() {
+	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+
+	range_size=3D1
+	for i in $(seq "${start}" $((start + count))); do
+		end=3D$((start + range_size))
+
+		# Avoid negative or zero-sized port ranges
+		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+			start=3D${end}
+			end=3D$((end + 1))
+		fi
+		srcstart=3D$((start + src_delta))
+		srcend=3D$((end + src_delta))
+
+		add "$(format)" || return 1
+		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+			send_match "${j}" $((j + src_delta)) || return 1
+		done
+		send_nomatch $((end + 1)) $((end + 1 + src_delta)) || return 1
+
+		# Delete elements now and then
+		if [ $((i % 3)) -eq 0 ]; then
+			del "$(format)" || return 1
+			for j in $(seq ${start} \
+				   $((range_size / 2 + 1)) ${end}); do
+				send_nomatch "${j}" $((j + src_delta)) \
+					|| return 1
+			done
+		fi
+
+		range_size=3D$((range_size + 1))
+		start=3D$((end + range_size))
+	done
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
+	proto=3D${flood_proto}
+	tools=3D${flood_tools}
+	chain_spec=3D${flood_spec}
+	setup veth flood_"${proto}" set || return ${KSELFTEST_SKIP}
+
+	range_size=3D1
+	cstart=3D${start}
+	flood_pids=3D
+	for i in $(seq ${start} $((start + count))); do
+		end=3D$((start + range_size))
+		srcstart=3D$((start + src_delta))
+		srcend=3D$((end + src_delta))
+
+		add "$(format)" || return 1
+
+		flood "${i}" $((i + src_delta)) & flood_pids=3D"${flood_pids} $!"
+
+		range_size=3D$((range_size + 1))
+		start=3D$((end + range_size))
+	done
+
+	sleep 10
+
+	pids=3D
+	for c in $(seq 1 "$(nproc)"); do (
+		for r in $(seq 1 "${race_repeat}"); do
+			range_size=3D1
+
+			# $start needs to be local to this subshell
+			# shellcheck disable=3DSC2030
+			start=3D${cstart}
+			for i in $(seq ${start} $((start + count))); do
+				end=3D$((start + range_size))
+				srcstart=3D$((start + src_delta))
+				srcend=3D$((end + src_delta))
+
+				add "$(format)" 2>/dev/null
+
+				range_size=3D$((range_size + 1))
+				start=3D$((end + range_size))
+			done
+
+			nft flush inet filter test 2>/dev/null
+
+			range_size=3D1
+			start=3D${cstart}
+			for i in $(seq ${start} $((start + count))); do
+				end=3D$((start + range_size))
+				srcstart=3D$((start + src_delta))
+				srcend=3D$((end + src_delta))
+
+				add "$(format)" 2>/dev/null
+
+				range_size=3D$((range_size + 1))
+				start=3D$((end + range_size))
+			done
+
+			nft flush ruleset
+			setup set 2>/dev/null
+
+			range_size=3D1
+			start=3D${cstart}
+			for i in $(seq ${start} $((start + count))); do
+				end=3D$((start + range_size))
+				srcstart=3D$((start + src_delta))
+				srcend=3D$((end + src_delta))
+
+				add "$(format)" 2>/dev/null
+
+				range_size=3D$((range_size + 1))
+				start=3D$((end + range_size))
+			done
+
+			range_size=3D1
+			start=3D${cstart}
+			for i in $(seq ${start} $((start + count))); do
+				end=3D$((start + range_size))
+				srcstart=3D$((start + src_delta))
+				srcend=3D$((end + src_delta))
+
+				del "$(format)" 2>/dev/null
+
+				range_size=3D$((range_size + 1))
+				start=3D$((end + range_size))
+			done
+		done
+	) & pids=3D"${pids} $!"
+	done
+
+	# shellcheck disable=3DSC2046,SC2086 # word splitting wanted here
+	wait $(for pid in ${pids}; do echo ${pid}; done)
+	# shellcheck disable=3DSC2046,SC2086
+	kill $(for pid in ${flood_pids}; do echo ${pid}; done) 2>/dev/null
+	# shellcheck disable=3DSC2046,SC2086
+	wait $(for pid in ${flood_pids}; do echo ${pid}; done) 2>/dev/null
+
+	return 0
+}
+
+# Timeout test template:
+# - add all the elements with 3s timeout while checking that packets mat=
ch
+# - wait 3s after the last insertion, check that packets don't match any=
 entry
+test_timeout() {
+	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+
+	timeout=3D3
+	range_size=3D1
+	for i in $(seq "${start}" $((start + count))); do
+		end=3D$((start + range_size))
+		srcstart=3D$((start + src_delta))
+		srcend=3D$((end + src_delta))
+
+		add "$(format)" || return 1
+
+		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+			send_match "${j}" $((j + src_delta)) || return 1
+		done
+
+		range_size=3D$((range_size + 1))
+		start=3D$((end + range_size))
+	done
+	sleep 3
+	for i in $(seq ${start} $((start + count))); do
+		end=3D$((start + range_size))
+		srcstart=3D$((start + src_delta))
+		srcend=3D$((end + src_delta))
+
+		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+			send_nomatch "${j}" $((j + src_delta)) || return 1
+		done
+
+		range_size=3D$((range_size + 1))
+		start=3D$((end + range_size))
+	done
+}
+
+# Performance test template:
+# - add concatenated ranged entries
+# - add non-ranged concatenated entries (for hash set matching rate base=
line)
+# - add ranged entries with first field only (for rbhash baseline)
+# - start pktgen injection directly on device rx path of this namespace
+# - measure drop only rate, hash and rbtree baselines, then matching rat=
e
+test_performance() {
+	chain_spec=3D${perf_spec}
+	dst=3D"${perf_dst}"
+	src=3D"${perf_src}"
+	setup veth perf set || return ${KSELFTEST_SKIP}
+
+	first=3D${start}
+	range_size=3D1
+	for set in test norange noconcat; do
+		start=3D${first}
+		for i in $(seq ${start} $((start + perf_entries))); do
+			end=3D$((start + range_size))
+			srcstart=3D$((start + src_delta))
+			srcend=3D$((end + src_delta))
+
+			if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+				start=3D${end}
+				end=3D$((end + 1))
+			elif [ ${start} -eq ${end} ]; then
+				end=3D$((start + 1))
+			fi
+
+			add_perf ${set}
+
+			start=3D$((end + range_size))
+		done > "${tmp}"
+		nft -f "${tmp}"
+	done
+
+	perf $((end - 1)) ${srcstart}
+
+	sleep 2
+
+	nft add rule netdev perf test counter name \"test\" drop
+	nft reset counter netdev perf test >/dev/null 2>&1
+	sleep "${perf_duration}"
+	pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+	info "    baseline (drop from netdev hook):            ${pps}pps"
+	handle=3D"$(nft -a list chain netdev perf test | grep counter)"
+	handle=3D"${handle##* }"
+	nft delete rule netdev perf test handle "${handle}"
+
+	nft add rule "netdev perf test ${chain_spec} @norange \
+		counter name \"test\" drop"
+	nft reset counter netdev perf test >/dev/null 2>&1
+	sleep "${perf_duration}"
+	pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+	info "    baseline hash (non-ranged entries):          ${pps}pps"
+	handle=3D"$(nft -a list chain netdev perf test | grep counter)"
+	handle=3D"${handle##* }"
+	nft delete rule netdev perf test handle "${handle}"
+
+	nft add rule "netdev perf test ${chain_spec%%. *} @noconcat \
+		counter name \"test\" drop"
+	nft reset counter netdev perf test >/dev/null 2>&1
+	sleep "${perf_duration}"
+	pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+	info "    baseline rbtree (match on first field only): ${pps}pps"
+	handle=3D"$(nft -a list chain netdev perf test | grep counter)"
+	handle=3D"${handle##* }"
+	nft delete rule netdev perf test handle "${handle}"
+
+	nft add rule "netdev perf test ${chain_spec} @test \
+		counter name \"test\" drop"
+	nft reset counter netdev perf test >/dev/null 2>&1
+	sleep "${perf_duration}"
+	pps=3D"$(printf %10s $(($(count_perf_packets) / perf_duration)))"
+	p5=3D"$(printf %5s "${perf_entries}")"
+	info "    set with ${p5} full, ranged entries:         ${pps}pps"
+	kill "${perf_pid}"
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
+	printf "TEST: %s\n" "${name}"
+	for type in ${TYPES}; do
+		eval desc=3D\$TYPE_"${type}"
+		IFS=3D'
+'
+		for __line in ${desc}; do
+			# shellcheck disable=3DSC2086
+			eval ${__line%%	*}=3D\"${__line##*	}\";
+		done
+		IFS=3D' =09
+'
+
+		if [ "${name}" =3D "concurrency" ] && \
+		   [ "${race_repeat}" =3D "0" ]; then
+			continue
+		fi
+		if [ "${name}" =3D "performance" ] && \
+		   [ "${perf_duration}" =3D "0" ]; then
+			continue
+		fi
+
+		printf "  %-60s  " "${display}"
+		eval test_"${name}"
+		ret=3D$?
+
+		if [ $ret -eq 0 ]; then
+			printf "[ OK ]\n"
+			info_flush
+			passed=3D$((passed + 1))
+		elif [ $ret -eq 1 ]; then
+			printf "[FAIL]\n"
+			err_flush
+			exit 1
+		elif [ $ret -eq ${KSELFTEST_SKIP} ]; then
+			printf "[SKIP]\n"
+			err_flush
+		fi
+	done
+done
+
+[ ${passed} -eq 0 ] && exit ${KSELFTEST_SKIP}
--=20
2.24.1

