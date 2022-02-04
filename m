Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E97C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 17:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376981AbiBDRz3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiBDRz3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 12:55:29 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A409C061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 09:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XLwiHqXxsbBrX6zrcvUMepqU8ggmlhUJHjAZPsQLZTg=; b=FbcTcejV1hU7oGna+tEbr4RxW6
        i/oSkntVbU6nIgCg54EwPn67+NIkpPttj29bHu94TT+7bRftxY2hnMhb0iwCik65Uz2ukX04YMAXt
        VAvsRTjHtpWfc5Q/FxuhE8ekjexJsxaAsdJUXhDCKvxynIoNtlDrA1xqFhphZKaTiRXQKwInD15Js
        Y3dZ0WN8WlNxaOC3trwPLqLfLJc29mtC9+yV6Wl29SdLGfvExSq/Ny3mB2yQbXBfcSJsdA1IwZ9s0
        CUKHHDMlajd5s5MkRKkVzxWVAhK4d8ZaXC8wdAHkDd1cDUz8aEpBUfEiPnHsrndAVioZ6x0o3xViE
        fN3gZBYg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nG2nu-0004iq-NX; Fri, 04 Feb 2022 18:55:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: iptables-test: Support variant deviation
Date:   Fri,  4 Feb 2022 18:55:20 +0100
Message-Id: <20220204175520.29755-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some test results are not consistent between variants:

* CLUSTERIP is not supported with nft_compat, so all related tests fail
  with iptables-nft.
* iptables-legacy mandates TCPMSS be combined with SYN flag match,
  iptables-nft does not care. (Or precisely, xt_TCPMSS.ko can't validate
  match presence.)

Avoid the expected failures by allowing "NFT" and "LGC" outcomes in
addition to "OK" and "FAIL". They specify the variant with which given
test should pass.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_CLUSTERIP.t | 4 ++--
 extensions/libxt_TCPMSS.t     | 2 +-
 iptables-test.py              | 7 +++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/extensions/libipt_CLUSTERIP.t b/extensions/libipt_CLUSTERIP.t
index 5af555e005c1d..d3a2d6cbb1b2e 100644
--- a/extensions/libipt_CLUSTERIP.t
+++ b/extensions/libipt_CLUSTERIP.t
@@ -1,4 +1,4 @@
 :INPUT
 -d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 0 --hash-init 1;=;FAIL
--d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;OK
--d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 2 --hash-init 1;=;OK
+-d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;LGC
+-d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 2 --hash-init 1;=;LGC
diff --git a/extensions/libxt_TCPMSS.t b/extensions/libxt_TCPMSS.t
index 553a3452e4876..c3ee2de880826 100644
--- a/extensions/libxt_TCPMSS.t
+++ b/extensions/libxt_TCPMSS.t
@@ -1,6 +1,6 @@
 :FORWARD,OUTPUT,POSTROUTING
 *mangle
 -j TCPMSS;;FAIL
--p tcp -j TCPMSS --set-mss 42;;FAIL
+-p tcp -j TCPMSS --set-mss 42;;NFT
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 42;=;OK
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --clamp-mss-to-pmtu;=;OK
diff --git a/iptables-test.py b/iptables-test.py
index 95fa11b1475ca..be1b1a94decf4 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -91,8 +91,11 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
     #
     # report failed test
     #
+    should_pass = (res == "OK") or \
+                  (res == "NFT" and EXECUTABLE == "xtables-nft-multi") or \
+                  (res == "LGC" and EXECUTABLE == "xtables-legacy-multi")
     if ret:
-        if res == "OK":
+        if should_pass:
             reason = "cannot load: " + cmd
             print_error(reason, filename, lineno)
             return -1
@@ -100,7 +103,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
             # do not report this error
             return 0
     else:
-        if res == "FAIL":
+        if not should_pass:
             reason = "should fail: " + cmd
             print_error(reason, filename, lineno)
             delete_rule(iptables, rule, filename, lineno)
-- 
2.34.1

