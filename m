Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6386C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhLUT75 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLUT74 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:59:56 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA75C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8v8eYW0k8ydn2+eLbcdekDw8Q4Sg84uzDD/7/JS1CQo=; b=qi0cC61j69DtavMsfACIMXTET6
        2Nv7rr3oHZLpz6hqarH+yO2u6KAQh7qtAV73aPH3Qk5l9aTaHklxCv5nDbPHBFdVLl2AxjcmbGc6Y
        iAk5yv/A1mCW+zSEjXFUlgJv1SR4otbP4tTCWM3hMUJj0ufdW4RDvx95yrfAOZATrHMVJaWC1O3Uh
        shyPQYEqJCnW+OPkAAMq1tlGfj+LjSzucoKa+M3EqbReXfvuN5KecDx2HOC/7v0fXPQvmINmEHmdZ
        xY3ECG8M7kBwaOFWeCDvW6RKAtffmMxv4aN/RrM3mhEQUwduuuZsXfRBsMSOAjT3HLlcQuC3NdGs/
        TnGsP2VA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwk-0019T9-DM
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 10/11] tests: py: remove redundant payload expressions
Date:   Tue, 21 Dec 2021 19:36:56 +0000
Message-Id: <20211221193657.430866-11-jeremy@azazel.net>
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
payloads are eliminated.  Remove these from the Python test-cases.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/inet/icmpX.t             |  2 +-
 tests/py/inet/icmpX.t.json.output |  9 ---------
 tests/py/inet/sets.t.json         | 11 -----------
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/tests/py/inet/icmpX.t b/tests/py/inet/icmpX.t
index 97ff96d0cf0e..9430b3d3d579 100644
--- a/tests/py/inet/icmpX.t
+++ b/tests/py/inet/icmpX.t
@@ -7,4 +7,4 @@ icmp type echo-request;ok
 ip6 nexthdr icmpv6 icmpv6 type echo-request;ok;ip6 nexthdr 58 icmpv6 type echo-request
 icmpv6 type echo-request;ok
 # must not remove 'ip protocol' dependency, this explicitly matches icmpv6-in-ipv4.
-ip protocol ipv6-icmp meta l4proto ipv6-icmp icmpv6 type 1;ok;ip protocol 58 meta l4proto 58 icmpv6 type destination-unreachable
+ip protocol ipv6-icmp meta l4proto ipv6-icmp icmpv6 type 1;ok;ip protocol 58 icmpv6 type destination-unreachable
diff --git a/tests/py/inet/icmpX.t.json.output b/tests/py/inet/icmpX.t.json.output
index 9b0bf9f75ed5..7765cd908e24 100644
--- a/tests/py/inet/icmpX.t.json.output
+++ b/tests/py/inet/icmpX.t.json.output
@@ -68,15 +68,6 @@
             "right": 58
         }
     },
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "l4proto" }
-            },
-	    "op": "==",
-            "right": 58
-        }
-    },
     {
         "match": {
             "left": {
diff --git a/tests/py/inet/sets.t.json b/tests/py/inet/sets.t.json
index ef0cedca8159..b44ffc20d70d 100644
--- a/tests/py/inet/sets.t.json
+++ b/tests/py/inet/sets.t.json
@@ -73,17 +73,6 @@
 
 # ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
 [
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "nfproto"
-                }
-            },
-            "op": "==",
-            "right": "ipv4"
-        }
-    },
     {
         "match": {
             "left": {
-- 
2.34.1

