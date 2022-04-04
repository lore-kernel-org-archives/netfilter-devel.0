Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1B3C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbiDDMaI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344310AbiDDMaH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4023DDD6
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rNand+ginhhoENHhXtZlwL//K3nk/Jm+EkZPK1QMU7Y=; b=eTwMrvc1FxD1KVEkb2efoxPGvZ
        XITF1rN8eP29ornvkLSZGHSivdGBnCwmqd9MkzP+Mm1VGdNl9S0Ql1Q+cyIcfqMnZ+eLSDWgXU/FB
        xClOwcENxbOTrJyH2pWTjeUz+DdNeh3SLGtfIeJt8ScmNoqv6hJhtfjNIJaQhNZbFOt2b37jf/Vrc
        XFlirLFZjHNYZfZqTFqGK1Y89ovQyM50Slh/fVpLNqJAaBcyQHdIm8DUBrQl6Plckzn9QgpLRASLz
        8fAa9gEBKmZL0Ev57zmZ0QX8Cq36gWwcBX0ofvmEISnrLailQ+PQOxKnWYe5m01Dirsh8EMnPrXXC
        2KzIKPiw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbJ-007FTC-Sx; Mon, 04 Apr 2022 13:14:29 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 15/32] tests: shell: rename some test-cases
Date:   Mon,  4 Apr 2022 13:13:53 +0100
Message-Id: <20220404121410.188509-16-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `0040mark_shift_?` tests are testing not just shifts, but binops
more generally, so name them accordingly.

Change the priorities of the chains to match the type.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 .../testcases/chains/{0040mark_shift_0 => 0040mark_binop_0}     | 2 +-
 .../testcases/chains/{0040mark_shift_1 => 0040mark_binop_1}     | 2 +-
 .../chains/dumps/{0040mark_shift_0.nft => 0040mark_binop_0.nft} | 2 +-
 .../chains/dumps/{0040mark_shift_1.nft => 0040mark_binop_1.nft} | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename tests/shell/testcases/chains/{0040mark_shift_0 => 0040mark_binop_0} (68%)
 rename tests/shell/testcases/chains/{0040mark_shift_1 => 0040mark_binop_1} (70%)
 rename tests/shell/testcases/chains/dumps/{0040mark_shift_0.nft => 0040mark_binop_0.nft} (58%)
 rename tests/shell/testcases/chains/dumps/{0040mark_shift_1.nft => 0040mark_binop_1.nft} (64%)

diff --git a/tests/shell/testcases/chains/0040mark_shift_0 b/tests/shell/testcases/chains/0040mark_binop_0
similarity index 68%
rename from tests/shell/testcases/chains/0040mark_shift_0
rename to tests/shell/testcases/chains/0040mark_binop_0
index ef3dccfa049a..4280e33ac45a 100755
--- a/tests/shell/testcases/chains/0040mark_shift_0
+++ b/tests/shell/testcases/chains/0040mark_binop_0
@@ -4,7 +4,7 @@ set -e
 
 RULESET="
   add table t
-  add chain t c { type filter hook output priority mangle; }
+  add chain t c { type filter hook output priority filter; }
   add rule t c oif lo ct mark set (meta mark | 0x10) << 8
 "
 
diff --git a/tests/shell/testcases/chains/0040mark_shift_1 b/tests/shell/testcases/chains/0040mark_binop_1
similarity index 70%
rename from tests/shell/testcases/chains/0040mark_shift_1
rename to tests/shell/testcases/chains/0040mark_binop_1
index b609f5ef10ad..7e71f3eb43a8 100755
--- a/tests/shell/testcases/chains/0040mark_shift_1
+++ b/tests/shell/testcases/chains/0040mark_binop_1
@@ -4,7 +4,7 @@ set -e
 
 RULESET="
   add table t
-  add chain t c { type filter hook input priority mangle; }
+  add chain t c { type filter hook input priority filter; }
   add rule t c iif lo ct mark & 0xff 0x10 meta mark set ct mark >> 8
 "
 
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_0.nft
similarity index 58%
rename from tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
rename to tests/shell/testcases/chains/dumps/0040mark_binop_0.nft
index 52d59d2c6da4..fc0a600a4dbe 100644
--- a/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_0.nft
@@ -1,6 +1,6 @@
 table ip t {
 	chain c {
-		type filter hook output priority mangle; policy accept;
+		type filter hook output priority filter; policy accept;
 		oif "lo" ct mark set (meta mark | 0x00000010) << 8
 	}
 }
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft b/tests/shell/testcases/chains/dumps/0040mark_binop_1.nft
similarity index 64%
rename from tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
rename to tests/shell/testcases/chains/dumps/0040mark_binop_1.nft
index 56ec8dc766ca..dbaacefb93c7 100644
--- a/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
+++ b/tests/shell/testcases/chains/dumps/0040mark_binop_1.nft
@@ -1,6 +1,6 @@
 table ip t {
 	chain c {
-		type filter hook input priority mangle; policy accept;
+		type filter hook input priority filter; policy accept;
 		iif "lo" ct mark & 0x000000ff == 0x00000010 meta mark set ct mark >> 8
 	}
 }
-- 
2.35.1

