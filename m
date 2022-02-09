Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B258C43217
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 15:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbiBIPlO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 10:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236133AbiBIPlN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 10:41:13 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19319C0613C9
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 07:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OzfRxuaEVE90OagKU5n/lKS4hUtibjNPkil+qZ5Z5wE=; b=aiWnOjfYzOZ81KiUphNgm+z8Nk
        fxMD99bZ3a5gjbiOEeq12PbpmO0SEvjB7JHgtf9DW3d0efxcSLmQlsaYWT1z/rXAX6kXsasz0E7y0
        xXwJPrcqQgZH/0BGt8+4vnttVtXwgP+Zj/keaalnZm39ixq+HDVVgrytiov+a3XL21GfszMRoILzd
        gDYsIEx8pyiiR2ZughE9argVApWj2/nrFZb42RaJM8yiFCM+B7E0SCybBFGBQps5n8YN8VmCQV0+G
        K23JDWpn0KgeuI0vmNwDh1ApvpMDM/xV2Hc2317z6UeL1lVvkUuDmF60g8W+grrQ1Pq0eXzQ5+VL8
        6NYYchxQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nHp5m-0003iG-78; Wed, 09 Feb 2022 16:41:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2] tests: iptables-test: Support variant deviation
Date:   Wed,  9 Feb 2022 16:41:07 +0100
Message-Id: <20220209154107.25328-1-phil@nwl.cc>
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

Introduce an optional fourth test spec field to specify the variant it
applies to. Consequently, the opposite result is expected with the other
variant.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Do not replace "OK" result but add a fourth field as requested in v1
  review.
---
 extensions/libipt_CLUSTERIP.t |  4 ++--
 extensions/libxt_TCPMSS.t     |  2 +-
 iptables-test.py              | 25 +++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/extensions/libipt_CLUSTERIP.t b/extensions/libipt_CLUSTERIP.t
index 5af555e005c1d..30b80167a6223 100644
--- a/extensions/libipt_CLUSTERIP.t
+++ b/extensions/libipt_CLUSTERIP.t
@@ -1,4 +1,4 @@
 :INPUT
 -d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 0 --hash-init 1;=;FAIL
--d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;OK
--d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 2 --hash-init 1;=;OK
+-d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 1 --hash-init 1;=;OK;LEGACY
+-d 10.31.3.236/32 -i lo -j CLUSTERIP --new --hashmode sourceip --clustermac 01:AA:7B:47:F7:D7 --total-nodes 2 --local-node 2 --hash-init 1;=;OK;LEGACY
diff --git a/extensions/libxt_TCPMSS.t b/extensions/libxt_TCPMSS.t
index 553a3452e4876..fbfbfcf88d81a 100644
--- a/extensions/libxt_TCPMSS.t
+++ b/extensions/libxt_TCPMSS.t
@@ -1,6 +1,6 @@
 :FORWARD,OUTPUT,POSTROUTING
 *mangle
 -j TCPMSS;;FAIL
--p tcp -j TCPMSS --set-mss 42;;FAIL
+-p tcp -j TCPMSS --set-mss 42;;FAIL;LEGACY
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 42;=;OK
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --clamp-mss-to-pmtu;=;OK
diff --git a/iptables-test.py b/iptables-test.py
index 95fa11b1475ca..b49afcab3c40c 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -182,6 +182,28 @@ def execute_cmd(cmd, filename, lineno):
     return ret
 
 
+def variant_res(res, variant):
+    '''
+    Adjust expected result with given variant
+
+    If expected result is scoped to a variant, the other one yields a different
+    result. Therefore map @res to itself if given variant is current, invert it
+    otherwise.
+
+    :param res: expected result from test spec ("OK" or "FAIL")
+    :param variant: variant @res is scoped to by test spec ("NFT" or "LEGACY")
+    '''
+    variant_executable = {
+            "NFT": "xtables-nft-multi",
+            "LEGACY": "xtables-legacy-multi"
+    }
+    res_inverse = { "OK": "FAIL", "FAIL": "OK" }
+
+    if variant_executable[variant] == EXECUTABLE:
+        return res
+    return res_inverse[res]
+
+
 def run_test_file(filename, netns):
     '''
     Runs a test file
@@ -275,6 +297,9 @@ def run_test_file(filename, netns):
                 rule_save = chain + " " + item[1]
 
             res = item[2].rstrip()
+            if len(item) > 3:
+                res = variant_res(res, item[3].rstrip())
+
             ret = run_test(iptables, rule, rule_save,
                            res, filename, lineno + 1, netns)
 
-- 
2.34.1

