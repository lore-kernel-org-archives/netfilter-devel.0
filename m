Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BCCC38BE0
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 18:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E18E20836
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 18:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBXSjq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 13:39:46 -0500
Received: from correo.us.es ([193.147.175.20]:45016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgBXSjq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 13:39:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1BB0E8D6F
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 19:39:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94D17DA3A4
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2020 19:39:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92720DA3A3; Mon, 24 Feb 2020 19:39:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E757DA3C4;
        Mon, 24 Feb 2020 19:39:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Feb 2020 19:39:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6A3BB424EEE5;
        Mon, 24 Feb 2020 19:39:36 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, nevola@gmail.com
Subject: [PATCH 8/6 nft,v2] tests: shell: adjust tests to new nat concatenation syntax
Date:   Mon, 24 Feb 2020 19:39:38 +0100
Message-Id: <20200224183938.318160-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200224183938.318160-1-pablo@netfilter.org>
References: <20200224183938.318160-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/maps/dumps/nat_addr_port.nft | 16 ++++++++--------
 tests/shell/testcases/maps/nat_addr_port           | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index bd20ae7e65c7..210cab7f6b00 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -19,8 +19,8 @@ table ip ipfoo {
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat to ip saddr map @y
-		dnat to ip saddr . tcp dport map @z
+		meta l4proto tcp dnat ip addr . port to ip saddr map @y
+		dnat ip addr . port to ip saddr . tcp dport map @z
 	}
 }
 table ip6 ip6foo {
@@ -42,8 +42,8 @@ table ip6 ip6foo {
 		dnat to ip6 daddr map @x
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat to ip6 saddr map @y
-		dnat to ip6 saddr . tcp dport map @z
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
+		dnat ip6 addr . port to ip6 saddr . tcp dport map @z
 	}
 }
 table inet inetfoo {
@@ -78,12 +78,12 @@ table inet inetfoo {
 		dnat ip to ip daddr map @x4
 		ip saddr 10.1.1.1 dnat ip to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat ip to 10.2.3.4:4242
-		meta l4proto tcp meta nfproto ipv4 dnat ip to ip saddr map @y4
-		meta nfproto ipv4 dnat ip to ip saddr . tcp dport map @z4
+		meta l4proto tcp meta nfproto ipv4 dnat ip addr . port to ip saddr map @y4
+		meta nfproto ipv4 dnat ip addr . port to ip saddr . tcp dport map @z4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat ip6 to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat ip6 to [c0::1a]:4242
-		meta l4proto tcp meta nfproto ipv6 dnat ip6 to ip6 saddr map @y6
-		meta nfproto ipv6 dnat ip6 to ip6 saddr . tcp dport map @z6
+		meta l4proto tcp meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr map @y6
+		meta nfproto ipv6 dnat ip6 addr . port to ip6 saddr . tcp dport map @z6
 	}
 }
diff --git a/tests/shell/testcases/maps/nat_addr_port b/tests/shell/testcases/maps/nat_addr_port
index 58bb8942720c..a8d970e5e5ef 100755
--- a/tests/shell/testcases/maps/nat_addr_port
+++ b/tests/shell/testcases/maps/nat_addr_port
@@ -21,8 +21,8 @@ table ip ipfoo {
 		dnat to ip daddr map @x
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat to ip saddr map @y
-		meta l4proto tcp dnat to ip saddr . tcp dport map @z
+		meta l4proto tcp dnat ip addr . port to ip saddr map @y
+		meta l4proto tcp dnat ip addr . port to ip saddr . tcp dport map @z
 	}
 }
 EOF
@@ -52,8 +52,8 @@ table ip6 ip6foo {
 		dnat to ip6 daddr map @x
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat to ip6 saddr map @y
-		meta l4proto tcp dnat to ip6 saddr . tcp dport map @z
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr . tcp dport map @z
 	}
 }
 EOF
@@ -93,13 +93,13 @@ table inet inetfoo {
 		dnat ip to ip daddr map @x4
 		ip saddr 10.1.1.1 dnat to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
-		meta l4proto tcp dnat ip to ip saddr map @y4
-		meta l4proto tcp dnat ip to ip saddr . tcp dport map @z4
+		meta l4proto tcp dnat ip addr . port to ip saddr map @y4
+		meta l4proto tcp dnat ip addr . port to ip saddr . tcp dport map @z4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
-		meta l4proto tcp dnat ip6 to ip6 saddr map @y6
-		meta l4proto tcp dnat ip6 to ip6 saddr . tcp dport map @z6
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y6
+		meta l4proto tcp dnat ip6 addr . port to ip6 saddr . tcp dport map @z6
 	}
 }
 EOF
-- 
2.11.0

