Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CF9C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 18:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiAOS1y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 13:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiAOS1w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 13:27:52 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C7C061401
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 10:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8v8eYW0k8ydn2+eLbcdekDw8Q4Sg84uzDD/7/JS1CQo=; b=aYVJ1Dw3x3p0t3v8Bt9vOSe7aY
        x9+3jY1cn6WwvbBnrvJbU/fXCl1U55tgq4AJJZPTd6cPHXhZgOgr/XOkoHdatNf73KwWkMbtlkMzr
        O7YvcnAUNm4YBLAbziYIIzrGL8mqC5p/8xGlW19sf3tUATATpcJqkT3eEP8lFR04OrGIEIkxUyHWx
        s2fFnvXrpoR/4/orrcBPXjMgtWrwa5zfw7AYx4qZmE1R7QZTrCYAjX2RQsEVhD+z/+HOS7x5i8eti
        2Hz4YNkKTd1ju+eJR998mYHWq+Zd2JVdOcanTIaJN6BaPM8X8Wf7vTdQe07+8NATqDstTFUNRzvYn
        9dIkj1Fg==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8nmH-008OQb-Sw; Sat, 15 Jan 2022 18:27:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH v2 4/5] tests: py: remove redundant payload expressions
Date:   Sat, 15 Jan 2022 18:27:08 +0000
Message-Id: <20220115182709.1999424-5-jeremy@azazel.net>
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

