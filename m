Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28840C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 11:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 118E960551
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 11:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhKLLe7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 06:34:59 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57776 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbhKLLe6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 06:34:58 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 441D960639
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2021 12:30:05 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/3] tests: py: missing ip/snat.t json updates
Date:   Fri, 12 Nov 2021 12:31:56 +0100
Message-Id: <20211112113157.576409-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211112113157.576409-1-pablo@netfilter.org>
References: <20211112113157.576409-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing json update for new tests added recently.

Fixes: 50780456a01a ("evaluate: check for missing transport protocol match in nat map with concatenations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/snat.t.json        | 170 +++++++++++++++++++++++++++++++
 tests/py/ip/snat.t.json.output | 177 +++++++++++++++++++++++++++++++++
 2 files changed, 347 insertions(+)

diff --git a/tests/py/ip/snat.t.json b/tests/py/ip/snat.t.json
index 0813086c8405..967560e636a9 100644
--- a/tests/py/ip/snat.t.json
+++ b/tests/py/ip/snat.t.json
@@ -358,3 +358,173 @@
     }
 ]
 
+# meta l4proto 17 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": "udp"
+        }
+    },
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "10.141.11.4",
+                                {
+                                    "concat": [
+                                        "192.168.2.3",
+                                        80
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# snat ip to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
+[
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "10.141.11.4",
+                                {
+                                    "range": [
+                                        "192.168.2.2",
+                                        "192.168.2.4"
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# snat ip to ip saddr map { 10.141.12.14 : 192.168.2.0/24 }
+[
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "10.141.12.14",
+                                {
+                                    "prefix": {
+                                        "addr": "192.168.2.0",
+                                        "len": 24
+                                    }
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# meta l4proto { 6, 17} snat ip to ip saddr . th dport map { 10.141.11.4 . 20 : 192.168.2.3 . 80}
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "tcp",
+                    "udp"
+                ]
+            }
+        }
+    },
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        "10.141.11.4",
+                                        20
+                                    ]
+                                },
+                                {
+                                    "concat": [
+                                        "192.168.2.3",
+                                        80
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "dport",
+                                    "protocol": "th"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
diff --git a/tests/py/ip/snat.t.json.output b/tests/py/ip/snat.t.json.output
index 1365316c1b18..2a99780131d9 100644
--- a/tests/py/ip/snat.t.json.output
+++ b/tests/py/ip/snat.t.json.output
@@ -70,3 +70,180 @@
     }
 ]
 
+# snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
+[
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "10.141.11.4",
+                                {
+                                    "concat": [
+                                        "192.168.2.3",
+                                        80
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# meta l4proto 17 snat ip to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": 17
+        }
+    },
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "10.141.11.4",
+                                {
+                                    "concat": [
+                                        "192.168.2.3",
+                                        80
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# meta l4proto { 6, 17} snat ip to ip saddr . th dport map { 10.141.11.4 . 20 : 192.168.2.3 . 80}
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "l4proto"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    6,
+                    17
+                ]
+            }
+        }
+    },
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        "10.141.11.4",
+                                        20
+                                    ]
+                                },
+                                {
+                                    "concat": [
+                                        "192.168.2.3",
+                                        80
+                                    ]
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "payload": {
+                                    "field": "saddr",
+                                    "protocol": "ip"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "dport",
+                                    "protocol": "th"
+                                }
+                            }
+                        ]
+                    }
+                }
+            },
+            "family": "ip"
+        }
+    }
+]
+
+# snat ip prefix to ip saddr map { 10.141.11.0/24 : 192.168.2.0/24 }
+[
+    {
+        "snat": {
+            "addr": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "prefix": {
+                                        "addr": "10.141.11.0",
+                                        "len": 24
+                                    }
+                                },
+                                {
+                                    "prefix": {
+                                        "addr": "192.168.2.0",
+                                        "len": 24
+                                    }
+                                }
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    }
+                }
+            },
+            "family": "ip",
+            "flags": "netmap",
+            "type_flags": "prefix"
+        }
+    }
+]
+
-- 
2.30.2

