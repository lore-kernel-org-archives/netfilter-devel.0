Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D89C35670
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23AE82071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBXAEK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:04:10 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46034 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbgBXAEJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:04:09 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j61EB-0004m8-Ku; Mon, 24 Feb 2020 01:04:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     nevola@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 6/6] tests: nat: add and use maps with both address and service
Date:   Mon, 24 Feb 2020 01:03:24 +0100
Message-Id: <20200224000324.9333-7-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224000324.9333-1-fw@strlen.de>
References: <20200224000324.9333-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/maps/dumps/nat_addr_port.nft    | 76 +++++++++++++++++
 tests/shell/testcases/maps/nat_addr_port      | 84 +++++++++++++++++++
 2 files changed, 160 insertions(+)

diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index 3ed6812e585f..bd20ae7e65c7 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -3,11 +3,87 @@ table ip ipfoo {
 		type ipv4_addr : ipv4_addr
 	}
 
+	map y {
+		type ipv4_addr : ipv4_addr . inet_service
+		elements = { 192.168.7.2 : 10.1.1.1 . 4242 }
+	}
+
+	map z {
+		type ipv4_addr . inet_service : ipv4_addr . inet_service
+		elements = { 192.168.7.2 . 42 : 10.1.1.1 . 4242 }
+	}
+
 	chain c {
 		type nat hook prerouting priority dstnat; policy accept;
 		iifname != "foobar" accept
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
+		meta l4proto tcp dnat to ip saddr map @y
+		dnat to ip saddr . tcp dport map @z
+	}
+}
+table ip6 ip6foo {
+	map x {
+		type ipv6_addr : ipv6_addr
+	}
+
+	map y {
+		type ipv6_addr : ipv6_addr . inet_service
+	}
+
+	map z {
+		type ipv6_addr . inet_service : ipv6_addr . inet_service
+	}
+
+	chain c {
+		type nat hook prerouting priority dstnat; policy accept;
+		iifname != "foobar" accept
+		dnat to ip6 daddr map @x
+		ip6 saddr dead::1 dnat to feed::1
+		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
+		meta l4proto tcp dnat to ip6 saddr map @y
+		dnat to ip6 saddr . tcp dport map @z
+	}
+}
+table inet inetfoo {
+	map x4 {
+		type ipv4_addr : ipv4_addr
+	}
+
+	map y4 {
+		type ipv4_addr : ipv4_addr . inet_service
+	}
+
+	map z4 {
+		type ipv4_addr . inet_service : ipv4_addr . inet_service
+		elements = { 192.168.7.2 . 42 : 10.1.1.1 . 4242 }
+	}
+
+	map x6 {
+		type ipv6_addr : ipv6_addr
+	}
+
+	map y6 {
+		type ipv6_addr : ipv6_addr . inet_service
+	}
+
+	map z6 {
+		type ipv6_addr . inet_service : ipv6_addr . inet_service
+	}
+
+	chain c {
+		type nat hook prerouting priority dstnat; policy accept;
+		iifname != "foobar" accept
+		dnat ip to ip daddr map @x4
+		ip saddr 10.1.1.1 dnat ip to 10.2.3.4
+		ip saddr 10.1.1.2 tcp dport 42 dnat ip to 10.2.3.4:4242
+		meta l4proto tcp meta nfproto ipv4 dnat ip to ip saddr map @y4
+		meta nfproto ipv4 dnat ip to ip saddr . tcp dport map @z4
+		dnat ip6 to ip6 daddr map @x6
+		ip6 saddr dead::1 dnat ip6 to feed::1
+		ip6 saddr dead::2 tcp dport 42 dnat ip6 to [c0::1a]:4242
+		meta l4proto tcp meta nfproto ipv6 dnat ip6 to ip6 saddr map @y6
+		meta nfproto ipv6 dnat ip6 to ip6 saddr . tcp dport map @z6
 	}
 }
diff --git a/tests/shell/testcases/maps/nat_addr_port b/tests/shell/testcases/maps/nat_addr_port
index 77a2f110aeb9..58bb8942720c 100755
--- a/tests/shell/testcases/maps/nat_addr_port
+++ b/tests/shell/testcases/maps/nat_addr_port
@@ -6,6 +6,14 @@ table ip ipfoo {
 	map x {
 		type ipv4_addr : ipv4_addr
 	}
+	map y {
+		type ipv4_addr : ipv4_addr . inet_service
+		elements = { 192.168.7.2 : 10.1.1.1 . 4242 }
+	}
+	map z {
+		type ipv4_addr . inet_service : ipv4_addr . inet_service
+		elements = { 192.168.7.2 . 42 : 10.1.1.1 . 4242 }
+	}
 
 	chain c {
 		type nat hook prerouting priority dstnat; policy accept;
@@ -13,6 +21,8 @@ table ip ipfoo {
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
+		meta l4proto tcp dnat to ip saddr map @y
+		meta l4proto tcp dnat to ip saddr . tcp dport map @z
 	}
 }
 EOF
@@ -20,6 +30,80 @@ EOF
 # should fail: rule has no test for l4 protocol
 $NFT add rule 'ip ipfoo c ip saddr 10.1.1.2 dnat to 10.2.3.4:4242' && exit 1
 
+# should fail: rule has no test for l4 protocol, but map has inet_service
+$NFT add rule 'ip ipfoo c dnat to ip daddr map @y' && exit 1
+
+# skeleton 6
+$NFT -f /dev/stdin <<EOF || exit 1
+table ip6 ip6foo {
+	map x {
+		type ipv6_addr : ipv6_addr
+	}
+	map y {
+		type ipv6_addr : ipv6_addr . inet_service
+	}
+	map z {
+		type ipv6_addr . inet_service : ipv6_addr . inet_service
+	}
+
+	chain c {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta iifname != "foobar" accept
+		dnat to ip6 daddr map @x
+		ip6 saddr dead::1 dnat to feed::1
+		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
+		meta l4proto tcp dnat to ip6 saddr map @y
+		meta l4proto tcp dnat to ip6 saddr . tcp dport map @z
+	}
+}
+EOF
+
+# should fail: rule has no test for l4 protocol
+$NFT add rule 'ip6 ip6foo c ip6 saddr f0:0b::a3 dnat to [1c::3]:42' && exit 1
+
+# should fail: rule has no test for l4 protocol, but map has inet_service
+$NFT add rule 'ip6 ip6foo c dnat to ip daddr map @y' && exit 1
+
+# skeleton inet
+$NFT -f /dev/stdin <<EOF || exit 1
+table inet inetfoo {
+	map x4 {
+		type ipv4_addr : ipv4_addr
+	}
+	map y4 {
+		type ipv4_addr : ipv4_addr . inet_service
+	}
+	map z4 {
+		type ipv4_addr . inet_service : ipv4_addr . inet_service
+		elements = { 192.168.7.2 . 42 : 10.1.1.1 . 4242 }
+	}
+	map x6 {
+		type ipv6_addr : ipv6_addr
+	}
+	map y6 {
+		type ipv6_addr : ipv6_addr . inet_service
+	}
+	map z6 {
+		type ipv6_addr . inet_service : ipv6_addr . inet_service
+	}
+
+	chain c {
+		type nat hook prerouting priority dstnat; policy accept;
+		meta iifname != "foobar" accept
+		dnat ip to ip daddr map @x4
+		ip saddr 10.1.1.1 dnat to 10.2.3.4
+		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
+		meta l4proto tcp dnat ip to ip saddr map @y4
+		meta l4proto tcp dnat ip to ip saddr . tcp dport map @z4
+		dnat ip6 to ip6 daddr map @x6
+		ip6 saddr dead::1 dnat to feed::1
+		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
+		meta l4proto tcp dnat ip6 to ip6 saddr map @y6
+		meta l4proto tcp dnat ip6 to ip6 saddr . tcp dport map @z6
+	}
+}
+EOF
+
 # should fail: map has wrong family: 4->6
 $NFT add rule 'inet inetfoo c dnat to ip daddr map @x6' && exit 1
 
-- 
2.24.1

