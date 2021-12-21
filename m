Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD080C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241808AbhLUThS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241812AbhLUThQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1C9C06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+lefcZ5U4pD4d7rkH7+80+jww5y/sFFK9Nd8XFSHgJk=; b=fojAcc+BMYRHYqIpOR5lZzuXi2
        VMVExfPV+SegA+FVgljRABXw/eJs5YL5BqXB/l8vDC9a9/wyfr6wOM0HZLseQI3jFiApA8va4qIeF
        Fz4RO+m0+Fw6mDYxyTn3ZKKrsZ0KCuTxwdEiGc+d+zb3xA90f/ouueHWF3rlF6gL3CSDwg58b11wI
        h3OplJNf030ZD40gu2SG/U3uIf9vTVFE4ZeWkQURy7EoH2eH796cGdJ8ytvzNjPkHhNIzA9gGhh6I
        6uzJbvEu1y3swb5pGodjzOG+8k0mDIF7e9yoVEqNxZYaf21D9hwfsh2Z52S3F19qfvv7sQloNzDAk
        DCA7lQhg==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwj-0019T9-Kl
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 01/11] tests: py: fix inet/sets.t netdev payload
Date:   Tue, 21 Dec 2021 19:36:47 +0000
Message-Id: <20211221193657.430866-2-jeremy@azazel.net>
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

The netdev payload for one of the inet/sets.t tests was cut-and-pasted
from the inet payload without being properly updated.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/inet/sets.t.payload.netdev | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/py/inet/sets.t.payload.netdev b/tests/py/inet/sets.t.payload.netdev
index 9d6f6bbd62b1..e31aeb9274e6 100644
--- a/tests/py/inet/sets.t.payload.netdev
+++ b/tests/py/inet/sets.t.payload.netdev
@@ -15,9 +15,9 @@ netdev test-netdev ingress
   [ immediate reg 0 accept ]
 
 # ip saddr . ip daddr . tcp dport @set3 accept
-inet 
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x00000002 ]
+netdev
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-- 
2.34.1

