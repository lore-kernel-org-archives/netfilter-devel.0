Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50379C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbhLUThS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbhLUThQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10B1C061401
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4Gzuu/dBA+kKL7rj2Tle08HxJbwjT/QJCOuf5HCrwLc=; b=dgPXfQw5zxLhkJjx83kBh88s21
        cAoSdbFojhOzPPv9WsPJtDQdw1P/I3TwsSOb/l/a/2y/vNQyOqj08H4RToubtn5KHA/uZjB3HfkJ9
        B62R8Tt5bnHWbTpuAc/AEdTSoDjtuCMMqhXp4OL0jLjULWm+6xfSmwp/3Vw9o1Azb+VgeDuCHOMwS
        wl9ZKx3y6PySWVLHh+iJDKmeOv0hBqaP2i0s001/31DAaDK9ivy17+BexXmenzpHgVhtRqzujDkGH
        +ej9td7xBghvUUnpEHh8eLQkO5HotRanYDzeX5WlK8XH92ONGdyNWuuOyx4UmfllhCdKaEKwHnp5W
        t6O3xW3w==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwj-0019T9-ND
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 02/11] tests: py: fix inet/ip.t payloads
Date:   Tue, 21 Dec 2021 19:36:48 +0000
Message-Id: <20211221193657.430866-3-jeremy@azazel.net>
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

In one of the bridge payloads, the wrong command is given to load the
protocol.

The leading comment for one of the netdev payload includes a redundant
payload dependency.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/inet/ip.t.payload.bridge | 2 +-
 tests/py/inet/ip.t.payload.netdev | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/py/inet/ip.t.payload.bridge b/tests/py/inet/ip.t.payload.bridge
index a422ed76c2de..57dbc9eb42e7 100644
--- a/tests/py/inet/ip.t.payload.bridge
+++ b/tests/py/inet/ip.t.payload.bridge
@@ -3,7 +3,7 @@ __set%d test-bridge 3
 __set%d test-bridge 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
 bridge test-bridge input
-  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
index 38ed0ad316e4..f11225396d35 100644
--- a/tests/py/inet/ip.t.payload.netdev
+++ b/tests/py/inet/ip.t.payload.netdev
@@ -12,7 +12,7 @@ netdev test-netdev ingress
   [ payload load 6b @ link header + 6 => reg 10 ]
   [ lookup reg 1 set __set%d ]
 
-# meta protocol ip ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
+# ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
 __set%d test-netdev 3
 __set%d test-netdev 0
 	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
-- 
2.34.1

