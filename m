Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EB4C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C44610E5
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhDASSb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237935AbhDASJL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 14:09:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5894CC02C3F3
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 07:09:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRy0S-0001aL-Uw; Thu, 01 Apr 2021 16:09:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 4/4] tests: add 8021.AD vlan test cases
Date:   Thu,  1 Apr 2021 16:08:46 +0200
Message-Id: <20210401140846.24452-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210401140846.24452-1-fw@strlen.de>
References: <20210401140846.24452-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check nft doesn't remove the explicit '8021ad' type check and that
the expected dependency chains are generated.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/bridge/vlan.t                |   5 +
 tests/py/bridge/vlan.t.json           | 176 ++++++++++++++++++++++++++
 tests/py/bridge/vlan.t.json.output    | 173 +++++++++++++++++++++++++
 tests/py/bridge/vlan.t.payload        |  45 +++++++
 tests/py/bridge/vlan.t.payload.netdev |  51 ++++++++
 5 files changed, 450 insertions(+)

diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index 7a52a5020efa..8553ba56351d 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -34,6 +34,11 @@ vlan id { 1, 2, 4, 100, 4096 };fail
 
 ether type vlan ip protocol 1 accept;ok
 
+# IEEE 802.1AD
+ether type 8021ad vlan id 1 ip protocol 6 accept;ok
+ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter;ok
+ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6;ok;ether type 8021ad vlan id 1 vlan type vlan vlan id 2 ip protocol 6
+
 # illegal dependencies
 ether type ip vlan id 1;fail
 ether type ip vlan id 1 ip saddr 10.0.0.1;fail
diff --git a/tests/py/bridge/vlan.t.json b/tests/py/bridge/vlan.t.json
index 3fb2e4f71c75..8eab271d790b 100644
--- a/tests/py/bridge/vlan.t.json
+++ b/tests/py/bridge/vlan.t.json
@@ -530,3 +530,179 @@
     }
 ]
 
+# ether type 8021ad vlan id 1 ip protocol 6 accept
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
+            "right": "8021ad"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "tcp"
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
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
+            "right": "8021ad"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": "ip"
+        }
+    },
+    {
+        "counter": {
+            "bytes": 0,
+            "packets": 0
+        }
+    }
+]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
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
+            "right": "8021ad"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "tcp"
+        }
+    }
+]
diff --git a/tests/py/bridge/vlan.t.json.output b/tests/py/bridge/vlan.t.json.output
index 8f27ec0e7aad..a2cc212ea314 100644
--- a/tests/py/bridge/vlan.t.json.output
+++ b/tests/py/bridge/vlan.t.json.output
@@ -29,3 +29,176 @@
     }
 ]
 
+# ether type 8021ad vlan id 1 ip protocol 6 accept
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
+            "right": "8021ad"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
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
+            "right": "8021ad"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": "ip"
+        }
+    },
+    {
+        "counter": null
+    }
+]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
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
+            "right": "8021ad"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": "vlan"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "protocol",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    }
+]
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 2f045d18e564..f60c752de401 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -209,3 +209,48 @@ bridge test-bridge input
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
+# ether type 8021ad vlan id 1 ip protocol 6 accept
+bridge
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000a888 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 accept ]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
+bridge
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000a888 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 18 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000200 ]
+  [ payload load 2b @ link header + 20 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ counter pkts 0 bytes 0 ]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
+bridge
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000a888 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 18 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000200 ]
+  [ payload load 2b @ link header + 20 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 9d1fe557c7ac..94ca6867c271 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -245,3 +245,54 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000001 ]
   [ immediate reg 0 accept ]
 
+# ether type 8021ad vlan id 1 ip protocol 6 accept
+netdev
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000a888 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 accept ]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip counter
+netdev
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000a888 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 18 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000200 ]
+  [ payload load 2b @ link header + 20 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ counter pkts 0 bytes 0 ]
+
+# ether type 8021ad vlan id 1 vlan type vlan vlan id 2 vlan type ip ip protocol 6
+netdev
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0000a888 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 18 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000200 ]
+  [ payload load 2b @ link header + 20 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
-- 
2.26.3

