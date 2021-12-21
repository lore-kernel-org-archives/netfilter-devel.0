Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC428C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhLUT7z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLUT7y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:59:54 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F13C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:59:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+93SElwU6Hxp3X8hG/YQPyA9TJe/W7PPn7PPwSc9uxs=; b=oh7m47kKlAhxhR5nhXninNsKNm
        7+zQN2K40AeCxUboSDuflvewMgKRFHEZ7mvJ1w9AVlJIIbxVu8JBQS+TeT9g5cdWS8t2yhN0Hpuu5
        OtaudViuuPjGeUcNSpI9FwXq43vcfMff5R7aC19aS0hPzaMCU1/dbc+mvCiRWG4x59nMZaPmnn4sc
        uQD1I5VQK32sZH/l3inMk/iJBoaEOJ5XPa9B21UPI73gX9S+C8q7sSWk+FMx5sqqkc+QaAdQioJVx
        Cr4qCYPjXYn9xRfU999eQBNwt/2OSSgNpcEEJuomYUM6HN2c3hG1aZLPRzc7zLdwepANOMVc4xYlU
        6fVRUEuQ==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwk-0019T9-Fo
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 11/11] tests: shell: remove redundant payload expressions
Date:   Tue, 21 Dec 2021 19:36:57 +0000
Message-Id: <20211221193657.430866-12-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221193657.430866-1-jeremy@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Now that we keep track of more payload dependencies, more redundant
payloads are eliminated.  Remove these from the shell test-cases.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/maps/dumps/0010concat_map_0.nft | 2 +-
 tests/shell/testcases/maps/dumps/nat_addr_port.nft    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/shell/testcases/maps/dumps/0010concat_map_0.nft b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
index b6bc338c55b7..2f796b51d46b 100644
--- a/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0010concat_map_0.nft
@@ -6,6 +6,6 @@ table inet x {
 
 	chain y {
 		type nat hook prerouting priority dstnat; policy accept;
-		meta nfproto ipv4 dnat ip to ip saddr . ip protocol . tcp dport map @z
+		dnat ip to ip saddr . ip protocol . tcp dport map @z
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index cf6b957f0a9b..c8493b3adbf2 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -114,15 +114,15 @@ table inet inetfoo {
 		dnat ip to ip daddr map @x4
 		ip saddr 10.1.1.1 dnat ip to 10.2.3.4
 		ip saddr 10.1.1.2 tcp dport 42 dnat ip to 10.2.3.4:4242
-		meta l4proto tcp meta nfproto ipv4 dnat ip to ip saddr map @y4
-		meta nfproto ipv4 dnat ip to ip saddr . tcp dport map @z4
+		meta l4proto tcp dnat ip to ip saddr map @y4
+		dnat ip to ip saddr . tcp dport map @z4
 		dnat ip to numgen inc mod 2 map @t1v4
 		meta l4proto tcp dnat ip to numgen inc mod 2 map @t2v4
 		dnat ip6 to ip6 daddr map @x6
 		ip6 saddr dead::1 dnat ip6 to feed::1
 		ip6 saddr dead::2 tcp dport 42 dnat ip6 to [c0::1a]:4242
-		meta l4proto tcp meta nfproto ipv6 dnat ip6 to ip6 saddr map @y6
-		meta nfproto ipv6 dnat ip6 to ip6 saddr . tcp dport map @z6
+		meta l4proto tcp dnat ip6 to ip6 saddr map @y6
+		dnat ip6 to ip6 saddr . tcp dport map @z6
 		dnat ip6 to numgen inc mod 2 map @t1v6
 		meta l4proto tcp dnat ip6 to numgen inc mod 2 map @t2v6
 	}
-- 
2.34.1

