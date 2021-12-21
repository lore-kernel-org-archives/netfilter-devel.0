Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14242C43217
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 19:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241812AbhLUThS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 14:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241813AbhLUThQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 14:37:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62CAC061747
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JJYSE0ym//i4p2apx3Im5VF24FnzcvorW3mY3yVb4Eo=; b=mTAo7+bIYsBYaNREzQg3EzNXgt
        XzYJmxk4lF9eWZ8psBOx9lcbYHiR36zS2gytF3fj1yky1B6qFdxXLNtCJkDP9eW1G2/e3XlCIkRPs
        0MkI6/V0FQXLO/84zxNZTTsZ0fPM8RAoGp0Pt7jU/hC44rqDgzFn0d3jb2qt6Cphz8a351YGEoAQq
        SNS3aOrXFXru1w8jMP+ngfeLZ7zx0hSlFrcy0V0OuwIgF1c62yMKvYNqd0fyxQ2UgcrGdFhbKOZ3Q
        WamtnwWBlbHjccFV+u6W5URaTC36sCIP09N8xBnYByus65MCsW5zTO0BkvYE/tItsXFVp/wy2RqgY
        pEWG6mxA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mzkwj-0019T9-Pb
        for netfilter-devel@vger.kernel.org; Tue, 21 Dec 2021 19:37:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [nft PATCH 03/11] tests: py: fix inet/ip_tcp.t test
Date:   Tue, 21 Dec 2021 19:36:49 +0000
Message-Id: <20211221193657.430866-4-jeremy@azazel.net>
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

Contrary to the comment and expected output, nft does _not_ eliminate
the redundant `ip protocol` expression from the second test.  Dependency
elimination requires a higher level expression.  `ip saddr` cannot lead
to the elimination of `ip protocol` since they are both L3 expressions.
`tcp dport` cannot because although `ip saddr` and `ip protocol` both
imply that the L3 protocol is `ip`, only protocol matches are stored as
dependencies, so the redundancy is not apparent, and in fact,
`payload_may_dependency_kill` explicitly checks for the combination of
inet, bridge or netdev family, L4 expression and L3 ipv4 or ipv6
dependency and returns false.

Correct the expected output and comment.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/inet/ip_tcp.t             |  4 ++--
 tests/py/inet/ip_tcp.t.json.output | 12 ++++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tests/py/inet/ip_tcp.t b/tests/py/inet/ip_tcp.t
index ab76ffa90a9c..03bafc098536 100644
--- a/tests/py/inet/ip_tcp.t
+++ b/tests/py/inet/ip_tcp.t
@@ -9,8 +9,8 @@
 # must not remove ip dependency -- ONLY ipv4 packets should be matched
 ip protocol tcp tcp dport 22;ok;ip protocol 6 tcp dport 22
 
-# can remove it here, ip protocol is implied via saddr.
-ip protocol tcp ip saddr 1.2.3.4 tcp dport 22;ok;ip saddr 1.2.3.4 tcp dport 22
+# could in principle remove it here since ipv4 is implied via saddr.
+ip protocol tcp ip saddr 1.2.3.4 tcp dport 22;ok;ip protocol 6 ip saddr 1.2.3.4 tcp dport 22
 
 # but not here.
 ip protocol tcp counter ip saddr 1.2.3.4 tcp dport 22;ok;ip protocol 6 counter ip saddr 1.2.3.4 tcp dport 22
diff --git a/tests/py/inet/ip_tcp.t.json.output b/tests/py/inet/ip_tcp.t.json.output
index 4a6a05d7f10a..acad8b1fae76 100644
--- a/tests/py/inet/ip_tcp.t.json.output
+++ b/tests/py/inet/ip_tcp.t.json.output
@@ -28,6 +28,18 @@
 
 # ip protocol tcp ip saddr 1.2.3.4 tcp dport 22
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+	    "op": "==",
+            "right": 6
+        }
+    },
     {
         "match": {
             "left": {
-- 
2.34.1

