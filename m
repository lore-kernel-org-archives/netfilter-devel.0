Return-Path: <SRS0=245l=WZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D162C3A59F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12FB2215EA
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Aug 2019 14:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfH2OC1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 10:02:27 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50850 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726283AbfH2OC1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 10:02:27 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1i3L0L-0004BA-Ke; Thu, 29 Aug 2019 16:02:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     a@juaristi.eus, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] tests: add meta time test cases
Date:   Thu, 29 Aug 2019 16:09:03 +0200
Message-Id: <20190829140904.3858-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829140904.3858-1-fw@strlen.de>
References: <20190829140904.3858-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Ander Juaristi <a@juaristi.eus>

Signed-off-by: Ander Juaristi <a@juaristi.eus>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/any/meta.t             |  15 ++
 tests/py/any/meta.t.json        | 233 +++++++++++++++++++++++++++++++
 tests/py/any/meta.t.json.output | 234 ++++++++++++++++++++++++++++++++
 tests/py/any/meta.t.payload     |  77 +++++++++++
 4 files changed, 559 insertions(+)

diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 4b3c604de110..5911b74ac060 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -203,3 +203,18 @@ meta iif . meta oif vmap { "lo" . "lo" : drop };ok;iif . oif vmap { "lo" . "lo"
 
 meta random eq 1;ok;meta random 1
 meta random gt 1000000;ok;meta random > 1000000
+
+meta time "1970-05-23 21:07:14" drop;ok
+meta time 12341234 drop;ok;meta time "1970-05-23 21:07:14" drop
+meta time "2019-06-21 17:00:00" drop;ok
+meta time "2019-07-01 00:00:00" drop;ok
+meta time "2019-07-01 00:01:00" drop;ok
+meta time "2019-07-01 00:00:01" drop;ok
+meta day "Saturday" drop;ok
+meta day 6 drop;ok;meta day "Saturday" drop
+meta day "Satturday" drop;fail
+meta hour "17:00" drop;ok
+meta hour "17:00:00" drop;ok;meta hour "17:00" drop
+meta hour "17:00:01" drop;ok
+meta hour "00:00" drop;ok
+meta hour "00:01" drop;ok
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 447e553f8ba7..47dc0724d0b8 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2473,3 +2473,236 @@
     }
 ]
 
+# meta time "1970-05-23 21:07:14" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "1970-05-23 21:07:14"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time 12341234 drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "12341234"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-06-21 17:00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-06-21 17:00:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-07-01 00:00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-07-01 00:00:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-07-01 00:01:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-07-01 00:01:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-07-01 00:00:01" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-07-01 00:00:01"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta day "Saturday" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "day"
+                }
+            },
+            "op": "==",
+            "right": "Saturday"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta day 6 drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "day"
+                }
+            },
+            "op": "==",
+            "right": "6"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "17:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "17:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "17:00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "17:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "17:00:01" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "17:00:01"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "00:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "00:01" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "00:01"
+        }
+    },
+    {
+        "drop": null
+    }
+]
diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
index 3c0c6c8c644f..037f67189682 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -592,3 +592,237 @@
     }
 ]
 
+# meta time "1970-05-23 21:07:14" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "1970-05-23 21:07:14"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time 12341234 drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "1970-05-23 21:07:14"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-06-21 17:00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-06-21 17:00:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-07-01 00:00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-07-01 00:00:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-07-01 00:01:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-07-01 00:01:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta time "2019-07-01 00:00:01" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "time"
+                }
+            },
+            "op": "==",
+            "right": "2019-07-01 00:00:01"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta day "Saturday" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "day"
+                }
+            },
+            "op": "==",
+            "right": "Saturday"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta day 6 drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "day"
+                }
+            },
+            "op": "==",
+            "right": "Saturday"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "17:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "17:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "17:00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "17:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "17:00:01" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "17:00:01"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "00:00" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "00:00"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
+# meta hour "00:01" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "hour"
+                }
+            },
+            "op": "==",
+            "right": "00:01"
+        }
+    },
+    {
+        "drop": null
+    }
+]
+
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 1d8426de9632..402caae5cad8 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1047,3 +1047,80 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# meta time "1970-05-23 21:07:14" drop
+ip meta-test input
+  [ meta load time => reg 1 ]
+  [ cmp eq reg 1 0x74a8f400 0x002bd849 ]
+  [ immediate reg 0 drop ]
+
+# meta time 12341234 drop
+ip meta-test input
+  [ meta load time => reg 1 ]
+  [ cmp eq reg 1 0x74a8f400 0x002bd849 ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-06-21 17:00:00" drop
+ip meta-test input
+  [ meta load time => reg 1 ]
+  [ cmp eq reg 1 0x767d6000 0x15aa3ebc ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-07-01 00:00:00" drop
+ip meta-test input
+  [ meta load time => reg 1 ]
+  [ cmp eq reg 1 0xe750c000 0x15ad18e0 ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-07-01 00:01:00" drop
+ip meta-test input
+  [ meta load time => reg 1 ]
+  [ cmp eq reg 1 0xdf981800 0x15ad18ee ]
+  [ immediate reg 0 drop ]
+
+# meta time "2019-07-01 00:00:01" drop
+ip meta-test input
+  [ meta load time => reg 1 ]
+  [ cmp eq reg 1 0x22eb8a00 0x15ad18e1 ]
+  [ immediate reg 0 drop ]
+
+# meta day "Saturday" drop
+ip test-ip4 input
+  [ meta load day => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 drop ]
+
+# meta day 6 drop
+ip test-ip4 input
+  [ meta load day => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "17:00" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x0000d2f0 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "17:00:00" drop
+ip test-ip4 input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x0000d2f0 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "17:00:01" drop
+ip meta-test input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x0000d2f1 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "00:00" drop
+ip meta-test input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x00013560 ]
+  [ immediate reg 0 drop ]
+
+# meta hour "00:01" drop
+ip meta-test input
+  [ meta load hour => reg 1 ]
+  [ cmp eq reg 1 0x0001359c ]
+  [ immediate reg 0 drop ]
-- 
2.21.0

