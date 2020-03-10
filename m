Return-Path: <SRS0=Yj8l=43=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4F9C10F27
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 15:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95DDA20727
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Mar 2020 15:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCJPSJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Mar 2020 11:18:09 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45224 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgCJPSJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 11:18:09 -0400
Received: from localhost ([::1]:58314 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jBgdx-0002JX-Be; Tue, 10 Mar 2020 16:18:05 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/py: Move tcpopt.t to any/ directory
Date:   Tue, 10 Mar 2020 16:17:56 +0100
Message-Id: <20200310151756.10905-1-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge tcpopt.t files in ip, ip6 and inet into a common one, they were
just marignally different.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/{inet => any}/tcpopt.t             |   3 +
 tests/py/{inet => any}/tcpopt.t.json        |  70 ++-
 tests/py/{inet => any}/tcpopt.t.json.output |   0
 tests/py/any/tcpopt.t.payload               | 603 ++++++++++++++++++++
 tests/py/inet/tcpopt.t.payload              | 200 -------
 tests/py/ip/tcpopt.t                        |  38 --
 tests/py/ip/tcpopt.t.json                   | 416 --------------
 tests/py/ip/tcpopt.t.json.output            |  16 -
 tests/py/ip/tcpopt.t.payload                | 181 ------
 tests/py/ip6/tcpopt.t                       |  37 --
 tests/py/ip6/tcpopt.t.json                  | 416 --------------
 tests/py/ip6/tcpopt.t.json.output           |  16 -
 tests/py/ip6/tcpopt.t.payload               | 181 ------
 13 files changed, 649 insertions(+), 1528 deletions(-)
 rename tests/py/{inet => any}/tcpopt.t (94%)
 rename tests/py/{inet => any}/tcpopt.t.json (88%)
 rename tests/py/{inet => any}/tcpopt.t.json.output (100%)
 create mode 100644 tests/py/any/tcpopt.t.payload
 delete mode 100644 tests/py/inet/tcpopt.t.payload
 delete mode 100644 tests/py/ip/tcpopt.t
 delete mode 100644 tests/py/ip/tcpopt.t.json
 delete mode 100644 tests/py/ip/tcpopt.t.json.output
 delete mode 100644 tests/py/ip/tcpopt.t.payload
 delete mode 100644 tests/py/ip6/tcpopt.t
 delete mode 100644 tests/py/ip6/tcpopt.t.json
 delete mode 100644 tests/py/ip6/tcpopt.t.json.output
 delete mode 100644 tests/py/ip6/tcpopt.t.payload

diff --git a/tests/py/inet/tcpopt.t b/tests/py/any/tcpopt.t
similarity index 94%
rename from tests/py/inet/tcpopt.t
rename to tests/py/any/tcpopt.t
index b457691f7f27a..08b1dcb3c4899 100644
--- a/tests/py/inet/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -1,5 +1,7 @@
 :input;type filter hook input priority 0
 
+*ip;test-ip4;input
+*ip6;test-ip6;input
 *inet;test-inet;input
 
 tcp option eol kind 1;ok
@@ -19,6 +21,7 @@ tcp option sack0 left 1;ok;tcp option sack left 1
 tcp option sack1 left 1;ok
 tcp option sack2 left 1;ok
 tcp option sack3 left 1;ok
+tcp option sack right 1;ok
 tcp option sack0 right 1;ok;tcp option sack right 1
 tcp option sack1 right 1;ok
 tcp option sack2 right 1;ok
diff --git a/tests/py/inet/tcpopt.t.json b/tests/py/any/tcpopt.t.json
similarity index 88%
rename from tests/py/inet/tcpopt.t.json
rename to tests/py/any/tcpopt.t.json
index 45e9c29353de3..48eb339cee355 100644
--- a/tests/py/inet/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -8,7 +8,7 @@
                     "name": "eol"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -24,7 +24,7 @@
                     "name": "noop"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -40,7 +40,7 @@
                     "name": "maxseg"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -56,7 +56,7 @@
                     "name": "maxseg"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -72,7 +72,7 @@
                     "name": "maxseg"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -88,7 +88,7 @@
                     "name": "window"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -104,7 +104,7 @@
                     "name": "window"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -120,7 +120,7 @@
                     "name": "window"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -136,7 +136,7 @@
                     "name": "sack-permitted"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -152,7 +152,7 @@
                     "name": "sack-permitted"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -168,7 +168,7 @@
                     "name": "sack"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -184,7 +184,7 @@
                     "name": "sack"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -200,7 +200,7 @@
                     "name": "sack"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -216,7 +216,7 @@
                     "name": "sack0"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -232,7 +232,7 @@
                     "name": "sack1"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -248,7 +248,7 @@
                     "name": "sack2"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -264,7 +264,23 @@
                     "name": "sack3"
                 }
             },
-	    "op": "==",
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# tcp option sack right 1
+[
+    {
+        "match": {
+            "left": {
+                "tcp option": {
+                    "field": "right",
+                    "name": "sack"
+                }
+            },
+            "op": "==",
             "right": 1
         }
     }
@@ -280,7 +296,7 @@
                     "name": "sack0"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -296,7 +312,7 @@
                     "name": "sack1"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -312,7 +328,7 @@
                     "name": "sack2"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -328,7 +344,7 @@
                     "name": "sack3"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -344,7 +360,7 @@
                     "name": "timestamp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -360,7 +376,7 @@
                     "name": "timestamp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -376,7 +392,7 @@
                     "name": "timestamp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -392,7 +408,7 @@
                     "name": "timestamp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1
         }
     }
@@ -407,7 +423,7 @@
                     "name": "window"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": true
         }
     }
@@ -422,7 +438,7 @@
                     "name": "window"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": false
         }
     }
diff --git a/tests/py/inet/tcpopt.t.json.output b/tests/py/any/tcpopt.t.json.output
similarity index 100%
rename from tests/py/inet/tcpopt.t.json.output
rename to tests/py/any/tcpopt.t.json.output
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
new file mode 100644
index 0000000000000..63751cf26e751
--- /dev/null
+++ b/tests/py/any/tcpopt.t.payload
@@ -0,0 +1,603 @@
+# tcp option eol kind 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option eol kind 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option eol kind 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option noop kind 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option noop kind 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option noop kind 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg kind 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg kind 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg kind 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg length 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg length 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg length 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg size 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# tcp option maxseg size 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# tcp option maxseg size 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# tcp option window kind 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window kind 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window kind 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window length 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window length 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window length 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window count 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window count 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window count 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack-permitted kind 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack-permitted kind 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack-permitted kind 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack-permitted length 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack-permitted length 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack-permitted length 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack kind 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack kind 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack kind 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack length 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack length 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack length 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack left 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack left 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack left 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack0 left 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack0 left 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack0 left 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack1 left 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack1 left 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack1 left 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack2 left 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack2 left 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack2 left 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack3 left 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack3 left 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack3 left 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack right 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack right 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack right 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack0 right 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack0 right 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack0 right 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack1 right 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack1 right 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack1 right 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack2 right 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack2 right 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack2 right 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack3 right 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack3 right 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack3 right 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp kind 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp kind 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp kind 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp length 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp length 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp length 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp tsval 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsval 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsval 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsecr 1
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsecr 1
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsecr 1
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option window exists
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window exists
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window exists
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window missing
+ip 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# tcp option window missing
+ip6 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# tcp option window missing
+inet 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# tcp option maxseg size set 1360
+ip 
+  [ immediate reg 1 0x00005005 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
+
+# tcp option maxseg size set 1360
+ip6 
+  [ immediate reg 1 0x00005005 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
+
+# tcp option maxseg size set 1360
+inet 
+  [ immediate reg 1 0x00005005 ]
+  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
+
diff --git a/tests/py/inet/tcpopt.t.payload b/tests/py/inet/tcpopt.t.payload
deleted file mode 100644
index 7e254ed3f6056..0000000000000
--- a/tests/py/inet/tcpopt.t.payload
+++ /dev/null
@@ -1,200 +0,0 @@
-# tcp option eol kind 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option noop kind 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg kind 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg length 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg size 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-
-# tcp option window kind 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window length 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window count 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-permitted kind 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-permitted length 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack kind 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack length 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack left 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 left 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 left 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 left 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 left 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack right 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 right 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 right 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 right 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 right 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option timestamp kind 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp length 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp tsval 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option timestamp tsecr 1
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option window exists
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window missing
-inet test-inet input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 present => reg 1 ]
-  [ cmp eq reg 1 0x00000000 ]
-
-# tcp option maxseg size set 1360
-inet test-inet input
-  [ immediate reg 1 0x00005005 ]
-  [ exthdr write tcpopt reg 1 => 2b @ 2 + 2 ]
diff --git a/tests/py/ip/tcpopt.t b/tests/py/ip/tcpopt.t
deleted file mode 100644
index 7ee50a89d9c5f..0000000000000
--- a/tests/py/ip/tcpopt.t
+++ /dev/null
@@ -1,38 +0,0 @@
-:input;type filter hook input priority 0
-
-*ip;test-ip;input
-
-tcp option eol kind 1;ok
-tcp option noop kind 1;ok
-tcp option maxseg kind 1;ok
-tcp option maxseg length 1;ok
-tcp option maxseg size 1;ok
-tcp option window kind 1;ok
-tcp option window length 1;ok
-tcp option window count 1;ok
-tcp option sack-permitted kind 1;ok
-tcp option sack-permitted length 1;ok
-tcp option sack kind 1;ok
-tcp option sack length 1;ok
-tcp option sack left 1;ok
-tcp option sack0 left 1;ok;tcp option sack left 1
-tcp option sack1 left 1;ok
-tcp option sack2 left 1;ok
-tcp option sack3 left 1;ok
-tcp option sack right 1;ok
-tcp option sack0 right 1;ok;tcp option sack right 1
-tcp option sack1 right 1;ok
-tcp option sack2 right 1;ok
-tcp option sack3 right 1;ok
-tcp option timestamp kind 1;ok
-tcp option timestamp length 1;ok
-tcp option timestamp tsval 1;ok
-tcp option timestamp tsecr 1;ok
-
-tcp option foobar;fail
-tcp option foo bar;fail
-tcp option eol left;fail
-tcp option eol left 1;fail
-tcp option eol left 1;fail
-tcp option sack window;fail
-tcp option sack window 1;fail
diff --git a/tests/py/ip/tcpopt.t.json b/tests/py/ip/tcpopt.t.json
deleted file mode 100644
index d573dd1c229b6..0000000000000
--- a/tests/py/ip/tcpopt.t.json
+++ /dev/null
@@ -1,416 +0,0 @@
-# tcp option eol kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "eol"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option noop kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "noop"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option maxseg kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "maxseg"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option maxseg length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "maxseg"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option maxseg size 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "size",
-                    "name": "maxseg"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option window kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "window"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option window length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "window"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option window count 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "count",
-                    "name": "window"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack-permitted kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "sack-permitted"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack-permitted length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "sack-permitted"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack0 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack1 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack1"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack2 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack2"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack3 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack3"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack0 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack0"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack1 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack1"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack2 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack2"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack3 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack3"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp tsval 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "tsval",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp tsecr 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "tsecr",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
diff --git a/tests/py/ip/tcpopt.t.json.output b/tests/py/ip/tcpopt.t.json.output
deleted file mode 100644
index 81dd8ad80da84..0000000000000
--- a/tests/py/ip/tcpopt.t.json.output
+++ /dev/null
@@ -1,16 +0,0 @@
-# tcp option sack0 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
diff --git a/tests/py/ip/tcpopt.t.payload b/tests/py/ip/tcpopt.t.payload
deleted file mode 100644
index b2e5bdb29d1c3..0000000000000
--- a/tests/py/ip/tcpopt.t.payload
+++ /dev/null
@@ -1,181 +0,0 @@
-# tcp option eol kind 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option noop kind 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg kind 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg length 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg size 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-
-# tcp option window kind 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window length 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window count 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-permitted kind 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-permitted length 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack kind 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack length 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack left 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 left 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 left 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 left 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 left 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack right 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 right 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 right 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 right 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 right 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option timestamp kind 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp length 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp tsval 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option timestamp tsecr 1
-ip test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
diff --git a/tests/py/ip6/tcpopt.t b/tests/py/ip6/tcpopt.t
deleted file mode 100644
index 497f69fc86785..0000000000000
--- a/tests/py/ip6/tcpopt.t
+++ /dev/null
@@ -1,37 +0,0 @@
-:input;type filter hook input priority 0
-*ip6;test-ip6;input
-
-tcp option eol kind 1;ok
-tcp option noop kind 1;ok
-tcp option maxseg kind 1;ok
-tcp option maxseg length 1;ok
-tcp option maxseg size 1;ok
-tcp option window kind 1;ok
-tcp option window length 1;ok
-tcp option window count 1;ok
-tcp option sack-permitted kind 1;ok
-tcp option sack-permitted length 1;ok
-tcp option sack kind 1;ok
-tcp option sack length 1;ok
-tcp option sack left 1;ok
-tcp option sack0 left 1;ok;tcp option sack left 1
-tcp option sack1 left 1;ok
-tcp option sack2 left 1;ok
-tcp option sack3 left 1;ok
-tcp option sack right 1;ok
-tcp option sack0 right 1;ok;tcp option sack right 1
-tcp option sack1 right 1;ok
-tcp option sack2 right 1;ok
-tcp option sack3 right 1;ok
-tcp option timestamp kind 1;ok
-tcp option timestamp length 1;ok
-tcp option timestamp tsval 1;ok
-tcp option timestamp tsecr 1;ok
-
-tcp option foobar;fail
-tcp option foo bar;fail
-tcp option eol left;fail
-tcp option eol left 1;fail
-tcp option eol left 1;fail
-tcp option sack window;fail
-tcp option sack window 1;fail
diff --git a/tests/py/ip6/tcpopt.t.json b/tests/py/ip6/tcpopt.t.json
deleted file mode 100644
index d573dd1c229b6..0000000000000
--- a/tests/py/ip6/tcpopt.t.json
+++ /dev/null
@@ -1,416 +0,0 @@
-# tcp option eol kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "eol"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option noop kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "noop"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option maxseg kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "maxseg"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option maxseg length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "maxseg"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option maxseg size 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "size",
-                    "name": "maxseg"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option window kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "window"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option window length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "window"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option window count 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "count",
-                    "name": "window"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack-permitted kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "sack-permitted"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack-permitted length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "sack-permitted"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack0 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack1 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack1"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack2 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack2"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack3 left 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "left",
-                    "name": "sack3"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack0 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack0"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack1 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack1"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack2 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack2"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option sack3 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack3"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp kind 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "kind",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp length 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "length",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp tsval 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "tsval",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
-# tcp option timestamp tsecr 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "tsecr",
-                    "name": "timestamp"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
diff --git a/tests/py/ip6/tcpopt.t.json.output b/tests/py/ip6/tcpopt.t.json.output
deleted file mode 100644
index 81dd8ad80da84..0000000000000
--- a/tests/py/ip6/tcpopt.t.json.output
+++ /dev/null
@@ -1,16 +0,0 @@
-# tcp option sack0 right 1
-[
-    {
-        "match": {
-            "left": {
-                "tcp option": {
-                    "field": "right",
-                    "name": "sack"
-                }
-            },
-	    "op": "==",
-            "right": 1
-        }
-    }
-]
-
diff --git a/tests/py/ip6/tcpopt.t.payload b/tests/py/ip6/tcpopt.t.payload
deleted file mode 100644
index 4b1891974c75a..0000000000000
--- a/tests/py/ip6/tcpopt.t.payload
+++ /dev/null
@@ -1,181 +0,0 @@
-# tcp option eol kind 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option noop kind 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg kind 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg length 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option maxseg size 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000100 ]
-
-# tcp option window kind 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window length 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option window count 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-permitted kind 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack-permitted length 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack kind 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack length 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option sack left 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 left 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 left 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 left 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 left 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack right 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack0 right 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack1 right 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack2 right 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option sack3 right 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option timestamp kind 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp length 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000001 ]
-
-# tcp option timestamp tsval 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# tcp option timestamp tsecr 1
-ip6 test-ip input
-  [ meta load l4proto => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-- 
2.25.1

