Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9398C4321E
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 18:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbiAOS1y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 13:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiAOS1w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 13:27:52 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BE1C061746
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 10:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+93SElwU6Hxp3X8hG/YQPyA9TJe/W7PPn7PPwSc9uxs=; b=Gg4kUhglwJL/f5SncLnMxkniLV
        rAnhebDBkOuWOJGTwDQ2XtoqDAKiDcWAi0TWWbXVcEHHR9kbxhAVHjRoG0XrcXIxXP72K7Kf6u2HT
        Asew76+FL0SapXdawIoo3mp58SqHOKTEHmunmBw30IyMb2Poi5fm5wh6yUy77T6qS20zMv3GR5Clx
        fhYbxqQm7Jqjyqtu3I3cbsl8BXMqGw6X2RVSx8pz2Z6CmgkkMIVFARIVwShSrNgiiLnZKdfxNBMpF
        j/l/P674gWPBC+JBdIbgFcyf8+JwvjY5Gfrz3X8W9itjX36nfex4tZMC4KoIjihXJHOuC9hojl/Y9
        r1HIkFkQ==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8nmI-008OQb-3h; Sat, 15 Jan 2022 18:27:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 5/5] tests: shell: remove redundant payload expressions
Date:   Sat, 15 Jan 2022 18:27:09 +0000
Message-Id: <20220115182709.1999424-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220115182709.1999424-1-jeremy@azazel.net>
References: <20220115182709.1999424-1-jeremy@azazel.net>
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

