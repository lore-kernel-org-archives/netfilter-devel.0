Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3616C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 11:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2EF660551
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 11:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhKLLe7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 06:34:59 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57778 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhKLLe6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 06:34:58 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7DA826063A
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2021 12:30:06 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] tests: py: missing json output update in ip6/meta.t
Date:   Fri, 12 Nov 2021 12:31:57 +0100
Message-Id: <20211112113157.576409-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112113157.576409-1-pablo@netfilter.org>
References: <20211112113157.576409-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update json output for 'meta protocol ip6 udp dport 67'.

Fixes: 646c5d02a5db ("rule: remove redundant meta protocol from the evaluation step")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip6/meta.t.json.output | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tests/py/ip6/meta.t.json.output b/tests/py/ip6/meta.t.json.output
index dede9b16904f..61adf1848b0b 100644
--- a/tests/py/ip6/meta.t.json.output
+++ b/tests/py/ip6/meta.t.json.output
@@ -46,3 +46,19 @@
     }
 ]
 
+# meta protocol ip6 udp dport 67
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "udp"
+                }
+            },
+            "op": "==",
+            "right": 67
+        }
+    }
+]
+
-- 
2.30.2

