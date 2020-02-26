Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209EAC4BA0B
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 12:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E508E20838
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 12:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgBZM0l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 07:26:41 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33552 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbgBZM0l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 07:26:41 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6vlv-0002Yr-7E; Wed, 26 Feb 2020 13:26:39 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] tests: update nat_addr_port with typeof+concat maps
Date:   Wed, 26 Feb 2020 13:26:27 +0100
Message-Id: <20200226122627.27835-2-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226122627.27835-1-fw@strlen.de>
References: <20200226122627.27835-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/maps/dumps/nat_addr_port.nft    | 40 +++++++++++++++++++
 tests/shell/testcases/maps/nat_addr_port      | 40 +++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index 210cab7f6b00..89c3bd145b4d 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -1,4 +1,12 @@
 table ip ipfoo {
+	map t1 {
+		typeof numgen inc mod 2 : ip daddr
+	}
+
+	map t2 {
+		typeof numgen inc mod 2 : ip daddr . tcp dport
+	}
+
 	map x {
 		type ipv4_addr : ipv4_addr
 	}
@@ -21,9 +29,19 @@ table ip ipfoo {
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
 		meta l4proto tcp dnat ip addr . port to ip saddr map @y
 		dnat ip addr . port to ip saddr . tcp dport map @z
+		dnat to numgen inc mod 2 map @t1
+		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2
 	}
 }
 table ip6 ip6foo {
+	map t1 {
+		typeof numgen inc mod 2 : ip6 daddr
+	}
+
+	map t2 {
+		typeof numgen inc mod 2 : ip6 daddr . tcp dport
+	}
+
 	map x {
 		type ipv6_addr : ipv6_addr
 	}
@@ -44,9 +62,27 @@ table ip6 ip6foo {
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
 		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
 		dnat ip6 addr . port to ip6 saddr . tcp dport map @z
+		dnat to numgen inc mod 2 map @t1
+		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2
 	}
 }
 table inet inetfoo {
+	map t1v4 {
+		typeof numgen inc mod 2 : ip daddr
+	}
+
+	map t2v4 {
+		typeof numgen inc mod 2 : ip daddr . tcp dport
+	}
+
+	map t1v6 {
+		typeof numgen inc mod 2 : ip6 daddr
+	}
+
+	map t2v6 {
+		typeof numgen inc mod 2 : ip6 daddr . tcp dport
+	}
+
 	map x4 {
 		type ipv4_addr : ipv4_addr
 	}
@@ -80,10 +116,14 @@ table inet inetfoo {
 		ip saddr 10.1.1.2 tcp dport 42 dnat ip to 10.2.3.4:4242
 		meta l4proto tcp meta nfproto ipv4 dnat ip addr . port to ip saddr map @y4
 		meta nfproto ipv4 dnat ip addr . port to ip saddr . tcp dport map @z4
+		dnat ip to numgen inc mod 2 map @t1v4
+		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2v4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat ip6 to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat ip6 to [c0::1a]:4242
 		meta l4proto tcp meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr map @y6
 		meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr . tcp dport map @z6
+		dnat ip6 to numgen inc mod 2 map @t1v6
+		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2v6
 	}
 }
diff --git a/tests/shell/testcases/maps/nat_addr_port b/tests/shell/testcases/maps/nat_addr_port
index a8d970e5e5ef..2804d48ca406 100755
--- a/tests/shell/testcases/maps/nat_addr_port
+++ b/tests/shell/testcases/maps/nat_addr_port
@@ -3,6 +3,14 @@
 # skeleton
 $NFT -f /dev/stdin <<EOF || exit 1
 table ip ipfoo {
+	map t1 {
+		typeof numgen inc mod 2 : ip daddr;
+	}
+
+	map t2 {
+		typeof numgen inc mod 2 : ip daddr . tcp dport
+	}
+
 	map x {
 		type ipv4_addr : ipv4_addr
 	}
@@ -23,6 +31,8 @@ table ip ipfoo {
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
 		meta l4proto tcp dnat ip addr . port to ip saddr map @y
 		meta l4proto tcp dnat ip addr . port to ip saddr . tcp dport map @z
+		dnat ip to numgen inc mod 2 map @t1
+		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2
 	}
 }
 EOF
@@ -36,6 +46,14 @@ $NFT add rule 'ip ipfoo c dnat to ip daddr map @y' && exit 1
 # skeleton 6
 $NFT -f /dev/stdin <<EOF || exit 1
 table ip6 ip6foo {
+	map t1 {
+		typeof numgen inc mod 2 : ip6 daddr;
+	}
+
+	map t2 {
+		typeof numgen inc mod 2 : ip6 daddr . tcp dport
+	}
+
 	map x {
 		type ipv6_addr : ipv6_addr
 	}
@@ -54,6 +72,8 @@ table ip6 ip6foo {
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
 		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
 		meta l4proto tcp dnat ip6 addr . port to ip6 saddr . tcp dport map @z
+		dnat ip6 to numgen inc mod 2 map @t1
+		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2
 	}
 }
 EOF
@@ -67,6 +87,22 @@ $NFT add rule 'ip6 ip6foo c dnat to ip daddr map @y' && exit 1
 # skeleton inet
 $NFT -f /dev/stdin <<EOF || exit 1
 table inet inetfoo {
+	map t1v4 {
+		typeof numgen inc mod 2 : ip daddr
+	}
+
+	map t2v4 {
+		typeof numgen inc mod 2 : ip daddr . tcp dport;
+	}
+
+	map t1v6 {
+		typeof numgen inc mod 2 : ip6 daddr;
+	}
+
+	map t2v6 {
+		typeof numgen inc mod 2 : ip6 daddr . tcp dport
+	}
+
 	map x4 {
 		type ipv4_addr : ipv4_addr
 	}
@@ -95,11 +131,15 @@ table inet inetfoo {
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
 		meta l4proto tcp dnat ip addr . port to ip saddr map @y4
 		meta l4proto tcp dnat ip addr . port to ip saddr . tcp dport map @z4
+		dnat ip to numgen inc mod 2 map @t1v4
+		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2v4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
 		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y6
 		meta l4proto tcp dnat ip6 addr . port to ip6 saddr . tcp dport map @z6
+		dnat ip6 to numgen inc mod 2 map @t1v6
+		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2v6
 	}
 }
 EOF
-- 
2.24.1

