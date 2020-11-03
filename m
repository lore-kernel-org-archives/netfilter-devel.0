Return-Path: <SRS0=5/tH=EJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74165C388F2
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Nov 2020 18:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E64120786
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Nov 2020 18:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgKCSUx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCSUx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Nov 2020 13:20:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5838AC0613D1
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2020 10:20:53 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ka0vL-0001cl-Dn; Tue, 03 Nov 2020 19:20:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] tests: json: add missing test case output
Date:   Tue,  3 Nov 2020 19:20:38 +0100
Message-Id: <20201103182040.24858-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103182040.24858-1-fw@strlen.de>
References: <20201103182040.24858-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix warnings and errors when running nf-test.py -j due to missing json test case updates.
This also makes bridge/reject.t pass in json mode.

No code changes.

Fixes: 8615ed93f6e4c4 ("evaluate: enable reject with 802.1q")
Fixes: fae0a0972d7a71 ("tests: py: Enable anonymous set rule with concatenated ranges in inet/sets.t")
Fixes: 2a20b5bdbde8a1 ("datatype: add frag-needed (ipv4) to reject options")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/bridge/reject.t       |  2 +-
 tests/py/bridge/reject.t.json  | 72 +++++++++++++++++++++++++++++++++
 tests/py/inet/sets.t.json      | 74 ++++++++++++++++++++++++++++++++++
 tests/py/ip/icmp.t.json        |  4 +-
 tests/py/ip/icmp.t.json.output |  2 +-
 5 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/tests/py/bridge/reject.t b/tests/py/bridge/reject.t
index f5ed203815e5..ee33af77eab6 100644
--- a/tests/py/bridge/reject.t
+++ b/tests/py/bridge/reject.t
@@ -32,7 +32,7 @@ ether type ip6 reject with icmp type host-unreachable;fail
 ether type ip reject with icmpv6 type no-route;fail
 ether type vlan reject;ok
 ether type arp reject;fail
-ether type vlan reject with tcp reset;ok
+ether type vlan reject with tcp reset;ok;meta l4proto 6 ether type vlan reject with tcp reset
 ether type arp reject with tcp reset;fail
 ip protocol udp reject with tcp reset;fail
 
diff --git a/tests/py/bridge/reject.t.json b/tests/py/bridge/reject.t.json
index d20a1d8b5f9e..aea871f70907 100644
--- a/tests/py/bridge/reject.t.json
+++ b/tests/py/bridge/reject.t.json
@@ -267,3 +267,75 @@
     }
 ]
 
+# ether type vlan reject with tcp reset
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "ether"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "reject": {
+            "type": "tcp reset"
+        }
+    }
+]
+
+# ether type vlan reject
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "ether"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "reject": null
+    }
+]
+
+# ether type vlan reject with icmpx type admin-prohibited
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "ether"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "reject": {
+            "expr": "admin-prohibited",
+            "type": "icmpx"
+        }
+    }
+]
diff --git a/tests/py/inet/sets.t.json b/tests/py/inet/sets.t.json
index 58e19ef64705..ef0cedca8159 100644
--- a/tests/py/inet/sets.t.json
+++ b/tests/py/inet/sets.t.json
@@ -71,3 +71,77 @@
     }
 ]
 
+# ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "nfproto"
+                }
+            },
+            "op": "==",
+            "right": "ipv4"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "tcp"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            {
+                                "prefix": {
+                                    "addr": "10.0.0.0",
+                                    "len": 8
+                                }
+                            },
+                            {
+                                "range": [
+                                    10,
+                                    23
+                                ]
+                            }
+                        ]
+                    },
+                    {
+                        "concat": [
+                            {
+                                "range": [
+                                    "192.168.1.1",
+                                    "192.168.3.8"
+                                ]
+                            },
+                            {
+                                "range": [
+                                    80,
+                                    443
+                                ]
+                            }
+                        ]
+                    }
+                ]
+            }
+        }
+    },
+    {
+        "accept": null
+    }
+]
diff --git a/tests/py/ip/icmp.t.json b/tests/py/ip/icmp.t.json
index 4e1727458779..965eb10be9ed 100644
--- a/tests/py/ip/icmp.t.json
+++ b/tests/py/ip/icmp.t.json
@@ -480,7 +480,7 @@
     }
 ]
 
-# icmp code != { prot-unreachable, 4, 33, 54, 56}
+# icmp code != { prot-unreachable, frag-needed, 33, 54, 56}
 [
     {
         "match": {
@@ -494,7 +494,7 @@
             "right": {
                 "set": [
                     "prot-unreachable",
-                    4,
+                    "frag-needed",
                     33,
                     54,
                     56
diff --git a/tests/py/ip/icmp.t.json.output b/tests/py/ip/icmp.t.json.output
index e8045bb8182e..2391983ab826 100644
--- a/tests/py/ip/icmp.t.json.output
+++ b/tests/py/ip/icmp.t.json.output
@@ -49,7 +49,7 @@
             "right": {
                 "set": [
                     "prot-unreachable",
-                    4,
+                    "frag-needed",
                     33,
                     54,
                     56
-- 
2.26.2

