Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 661A8C388F7
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C00862067C
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="kOZrhL1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgKISHQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730062AbgKISHQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 13:07:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C2FC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 10:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ickgYQQfNsR/AUZUbQRZvyBX+n2uwXzwIBgdJRvbdsg=; b=kOZrhL1KWtFHjQGPqQfrpHO8ZA
        5JtrXQAAqkSOr6PGO1VrtB/870zYJeMex7Q/VQeOC2AYVYL9SrrSXTEsCeNlp4tMBaJ1JlineuVpo
        0JEgh/YyyIOaEyAPjb05JlcK/rfzA5XKxkD/kdoilISKjLyYs8wulc3hyWMQ19qch09FhTTuHvyBp
        c40uv2WcPB797hsL+Gq/s5xfXoE0VUrChWsPCSxQ3wHmnW34tQnz5E8mxK93LNguOlfrj4D4goWmm
        0B1UZ49Y5pz0aSwPdD5eBSGyb9tElabWUKk8wgCKeArxU+BvdF/JZr9hogCnFYxan9e2uJSVeeDG1
        Q/PSwKMg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kcBZQ-0002F8-4e; Mon, 09 Nov 2020 18:07:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] tests: py: remove duplicate payloads.
Date:   Mon,  9 Nov 2020 18:07:10 +0000
Message-Id: <20201109180710.161500-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft-test.py only needs one payload per rule, but a number of rules have
duplicates, typically one per address family, so just keep the last
payload for rules listed more than once.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t.payload               |  14 -
 tests/py/any/tcpopt.t.payload           | 336 ------------------------
 tests/py/inet/ether-ip.t.payload.netdev |  15 --
 tests/py/inet/osf.t.payload             | 108 --------
 tests/py/inet/socket.t.payload          |  50 ----
 tests/py/inet/synproxy.t.payload        |  48 ----
 tests/py/netdev/reject.t.payload        |   4 -
 7 files changed, 575 deletions(-)

diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index ccbddc89959d..2f4ba4a7442e 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -329,20 +329,6 @@ ip test-ip4 output
   [ meta load mark => reg 1 ]
   [ ct set mark with reg 1 ]
 
-# ct mark set (meta mark | 0x10) << 8
-ip test-ip4 output
-  [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xffffffef ) ^ 0x00000010 ]
-  [ bitwise reg 1 = ( reg 1 << 0x00000008 ) ]
-  [ ct set mark with reg 1 ]
-
-# ct mark set (meta mark | 0x10) << 8
-ip6 test-ip6 output
-  [ meta load mark => reg 1 ]
-  [ bitwise reg 1 = (reg=1 & 0xffffffef ) ^ 0x00000010 ]
-  [ bitwise reg 1 = ( reg 1 << 0x00000008 ) ]
-  [ ct set mark with reg 1 ]
-
 # ct mark set (meta mark | 0x10) << 8
 inet test-inet output
   [ meta load mark => reg 1 ]
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index cddba613a088..56473798f8fd 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -1,17 +1,3 @@
-# tcp option eol kind 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option eol kind 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option eol kind 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -26,20 +12,6 @@ inet
   [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option maxseg kind 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg kind 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option maxseg kind 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -47,20 +19,6 @@ inet
   [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option maxseg length 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg length 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option maxseg length 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -68,20 +26,6 @@ inet
   [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option maxseg size 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-
-# tcp option maxseg size 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-
 # tcp option maxseg size 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -89,20 +33,6 @@ inet
   [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000100 ]
 
-# tcp option window kind 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window kind 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option window kind 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -110,20 +40,6 @@ inet
   [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option window length 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window length 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option window length 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -131,20 +47,6 @@ inet
   [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option window count 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window count 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option window count 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -152,20 +54,6 @@ inet
   [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-perm kind 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-perm kind 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option sack-perm kind 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -173,20 +61,6 @@ inet
   [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack-perm length 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-perm length 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option sack-perm length 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -194,20 +68,6 @@ inet
   [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack kind 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack kind 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option sack kind 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -215,20 +75,6 @@ inet
   [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack length 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack length 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option sack length 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -236,20 +82,6 @@ inet
   [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option sack left 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack left 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack left 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -257,20 +89,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack0 left 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 left 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack0 left 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -278,20 +96,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack1 left 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 left 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack1 left 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -299,20 +103,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack2 left 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 left 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack2 left 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -320,20 +110,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack3 left 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 left 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack3 left 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -341,20 +117,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack right 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack right 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack right 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -362,20 +124,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack0 right 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 right 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack0 right 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -383,20 +131,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack1 right 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 right 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack1 right 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -404,20 +138,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack2 right 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 right 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack2 right 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -425,20 +145,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option sack3 right 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 right 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option sack3 right 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -446,20 +152,6 @@ inet
   [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
   [ cmp eq reg 1 0x01000000 ]
 
-# tcp option timestamp kind 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp kind 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option timestamp kind 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -467,20 +159,6 @@ inet
   [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option timestamp length 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp length 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # tcp option timestamp length 1
 inet 
   [ meta load l4proto => reg 1 ]
@@ -488,20 +166,6 @@ inet
   [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# tcp option timestamp tsval 1
-ip 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option timestamp tsval 1
-ip6 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
 # tcp option timestamp tsval 1
 inet 
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/ether-ip.t.payload.netdev b/tests/py/inet/ether-ip.t.payload.netdev
index 16b092122c72..b0fa6d84b31b 100644
--- a/tests/py/inet/ether-ip.t.payload.netdev
+++ b/tests/py/inet/ether-ip.t.payload.netdev
@@ -13,21 +13,6 @@ netdev test-netdev ingress
   [ payload load 6b @ link header + 6 => reg 1 ]
   [ cmp eq reg 1 0x0c540f00 0x00000411 ]
 
-# tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04
-netdev test-netdev ingress 
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp eq reg 1 0x04030201 ]
-  [ meta load iiftype => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-  [ payload load 6b @ link header + 6 => reg 1 ]
-  [ cmp eq reg 1 0x0c540f00 0x00000411 ]
-
 # tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept
 netdev test-netdev ingress 
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/inet/osf.t.payload b/tests/py/inet/osf.t.payload
index 6f5fba345275..6ddab9763b64 100644
--- a/tests/py/inet/osf.t.payload
+++ b/tests/py/inet/osf.t.payload
@@ -1,79 +1,23 @@
-# osf name "Linux"
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
-
-# osf name "Linux"
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
-
 # osf name "Linux"
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
 
-# osf ttl loose name "Linux"
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
-
-# osf ttl loose name "Linux"
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
-
 # osf ttl loose name "Linux"
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
 
-# osf ttl skip name "Linux"
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
-
-# osf ttl skip name "Linux"
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
-
 # osf ttl skip name "Linux"
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ cmp eq reg 1 0x756e694c 0x00000078 0x00000000 0x00000000 ]
 
-# osf ttl skip version "Linux:3.0"
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
-
-# osf ttl skip version "Linux:3.0"
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
-
 # osf ttl skip version "Linux:3.0"
 inet osfinet osfchain
   [ osf dreg 1 ]
   [ cmp eq reg 1 0x756e694c 0x2e333a78 0x00000030 0x00000000 ]
 
-# osf name { "Windows", "MacOs" }
-__set%d osfip 3 size 2
-__set%d osfip 0
-	element 646e6957 0073776f 00000000 00000000  : 0 [end]	element 4f63614d 00000073 00000000 00000000  : 0 [end]
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# osf name { "Windows", "MacOs" }
-__set%d osfip6 3 size 2
-__set%d osfip6 0
-	element 646e6957 0073776f 00000000 00000000  : 0 [end]	element 4f63614d 00000073 00000000 00000000  : 0 [end]
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __set%d ]
-
 # osf name { "Windows", "MacOs" }
 __set%d osfinet 3 size 2
 __set%d osfinet 0
@@ -82,22 +26,6 @@ inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# osf version { "Windows:XP", "MacOs:Sierra" }
-__set%d osfip 3 size 2
-__set%d osfip 0
-	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __set%d ]
-
-# osf version { "Windows:XP", "MacOs:Sierra" }
-__set%d osfip6 3 size 2
-__set%d osfip6 0
-	element 646e6957 3a73776f 00005058 00000000  : 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 0 [end]
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __set%d ]
-
 # osf version { "Windows:XP", "MacOs:Sierra" }
 __set%d osfinet 3 size 2
 __set%d osfinet 0
@@ -106,24 +34,6 @@ inet osfinet osfchain
   [ osf dreg 1 ]
   [ lookup reg 1 set __set%d ]
 
-# ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
-__map%d osfip b size 2
-__map%d osfip 0
-	element 646e6957 0073776f 00000000 00000000  : 00000001 0 [end]	element 4f63614d 00000073 00000000 00000000  : 00000002 0 [end]
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __map%d dreg 1 ]
-  [ ct set mark with reg 1 ]
-
-# ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
-__map%d osfip6 b size 2
-__map%d osfip6 0
-	element 646e6957 0073776f 00000000 00000000  : 00000001 0 [end]	element 4f63614d 00000073 00000000 00000000  : 00000002 0 [end]
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __map%d dreg 1 ]
-  [ ct set mark with reg 1 ]
-
 # ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
 __map%d osfinet b size 2
 __map%d osfinet 0
@@ -133,24 +43,6 @@ inet osfinet osfchain
   [ lookup reg 1 set __map%d dreg 1 ]
   [ ct set mark with reg 1 ]
 
-# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
-__map%d osfip b size 2
-__map%d osfip 0
-	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
-ip osfip osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __map%d dreg 1 ]
-  [ ct set mark with reg 1 ]
-
-# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
-__map%d osfip6 b size 2
-__map%d osfip6 0
-	element 646e6957 3a73776f 00005058 00000000  : 00000003 0 [end]	element 4f63614d 69533a73 61727265 00000000  : 00000004 0 [end]
-ip6 osfip6 osfchain
-  [ osf dreg 1 ]
-  [ lookup reg 1 set __map%d dreg 1 ]
-  [ ct set mark with reg 1 ]
-
 # ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
 __map%d osfinet b size 2
 __map%d osfinet 0
diff --git a/tests/py/inet/socket.t.payload b/tests/py/inet/socket.t.payload
index 79fcea79477b..e66ccbf70aea 100644
--- a/tests/py/inet/socket.t.payload
+++ b/tests/py/inet/socket.t.payload
@@ -1,73 +1,23 @@
-# socket transparent 0
-ip sockip4 sockchain 
-  [ socket load transparent => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# socket transparent 0
-ip6 sockip6 sockchain 
-  [ socket load transparent => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
 # socket transparent 0
 inet sockin sockchain 
   [ socket load transparent => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# socket transparent 1
-ip sockip4 sockchain 
-  [ socket load transparent => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# socket transparent 1
-ip6 sockip6 sockchain 
-  [ socket load transparent => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # socket transparent 1
 inet sockin sockchain 
   [ socket load transparent => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
 
-# socket mark 0x00000005
-ip sockip4 sockchain 
-  [ socket load mark => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
-
-# socket mark 0x00000005
-ip6 sockip6 sockchain 
-  [ socket load mark => reg 1 ]
-  [ cmp eq reg 1 0x00000005 ]
-
 # socket mark 0x00000005
 inet sockin sockchain 
   [ socket load mark => reg 1 ]
   [ cmp eq reg 1 0x00000005 ]
 
-# socket wildcard 0
-ip sockip4 sockchain
-  [ socket load wildcard => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# socket wildcard 0
-ip6 sockip6 sockchain
-  [ socket load wildcard => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
 # socket wildcard 0
 inet sockin sockchain
   [ socket load wildcard => reg 1 ]
   [ cmp eq reg 1 0x00000000 ]
 
-# socket wildcard 1
-ip sockip4 sockchain
-  [ socket load wildcard => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# socket wildcard 1
-ip6 sockip6 sockchain
-  [ socket load wildcard => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
 # socket wildcard 1
 inet sockin sockchain
   [ socket load wildcard => reg 1 ]
diff --git a/tests/py/inet/synproxy.t.payload b/tests/py/inet/synproxy.t.payload
index 2e6feaaf80fd..dd318b9a4a42 100644
--- a/tests/py/inet/synproxy.t.payload
+++ b/tests/py/inet/synproxy.t.payload
@@ -1,71 +1,23 @@
-# synproxy
-ip synproxyip synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
-# synproxy
-ip6 synproxyip6 synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
 # synproxy
 inet synproxyinet synproxychain
   [ synproxy mss 0 wscale 0 ]
 
-# synproxy mss 1460 wscale 7
-ip synproxyip synproxychain
-  [ synproxy mss 1460 wscale 7 ]
-
-# synproxy mss 1460 wscale 7
-ip6 synproxyip6 synproxychain
-  [ synproxy mss 1460 wscale 7 ]
-
 # synproxy mss 1460 wscale 7
 inet synproxyinet synproxychain
   [ synproxy mss 1460 wscale 7 ]
 
-# synproxy mss 1460 wscale 5 timestamp sack-perm
-ip synproxyip synproxychain
-  [ synproxy mss 1460 wscale 5 ]
-
-# synproxy mss 1460 wscale 5 timestamp sack-perm
-ip6 synproxyip6 synproxychain
-  [ synproxy mss 1460 wscale 5 ]
-
 # synproxy mss 1460 wscale 5 timestamp sack-perm
 inet synproxyinet synproxychain
   [ synproxy mss 1460 wscale 5 ]
 
-# synproxy timestamp sack-perm
-ip synproxyip synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
-# synproxy timestamp sack-perm
-ip6 synproxyip6 synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
 # synproxy timestamp sack-perm
 inet synproxyinet synproxychain
   [ synproxy mss 0 wscale 0 ]
 
-# synproxy timestamp
-ip synproxyip synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
-# synproxy timestamp
-ip6 synproxyip6 synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
 # synproxy timestamp
 inet synproxyinet synproxychain
   [ synproxy mss 0 wscale 0 ]
 
-# synproxy sack-perm
-ip synproxyip synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
-# synproxy sack-perm
-ip6 synproxyip6 synproxychain
-  [ synproxy mss 0 wscale 0 ]
-
 # synproxy sack-perm
 inet synproxyinet synproxychain
   [ synproxy mss 0 wscale 0 ]
diff --git a/tests/py/netdev/reject.t.payload b/tests/py/netdev/reject.t.payload
index 71a66f9d97ad..d3af2f33b43a 100644
--- a/tests/py/netdev/reject.t.payload
+++ b/tests/py/netdev/reject.t.payload
@@ -6,10 +6,6 @@ netdev
 netdev 
   [ reject type 2 code 1 ]
 
-# reject
-netdev 
-  [ reject type 2 code 1 ]
-
 # reject with icmp type admin-prohibited
 netdev 
   [ reject type 0 code 13 ]
-- 
2.28.0

