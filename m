Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BE3C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFCD2239EB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbhAUN5V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729669AbhAUN4B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 08:56:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77B2C061757
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 05:55:20 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2aQh-000475-GM; Thu, 21 Jan 2021 14:55:19 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/4] json: fix icmpv6.t test cases
Date:   Thu, 21 Jan 2021 14:55:07 +0100
Message-Id: <20210121135510.14941-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121135510.14941-1-fw@strlen.de>
References: <20210121135510.14941-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip6/icmpv6.t.json        |  27 +-
 tests/py/ip6/icmpv6.t.json.output | 586 +++++++++++++++++++++++++++++-
 2 files changed, 597 insertions(+), 16 deletions(-)

diff --git a/tests/py/ip6/icmpv6.t.json b/tests/py/ip6/icmpv6.t.json
index f6cfbf172f56..ffc4931c4e0c 100644
--- a/tests/py/ip6/icmpv6.t.json
+++ b/tests/py/ip6/icmpv6.t.json
@@ -1185,7 +1185,7 @@
             "left": {
                 "payload": {
                     "field": "max-delay",
-                    "name": "icmpv6"
+                    "protocol": "icmpv6"
                 }
             },
 	    "op": "==",
@@ -1203,7 +1203,7 @@
             "left": {
                 "payload": {
                     "field": "max-delay",
-                    "name": "icmpv6"
+                    "protocol": "icmpv6"
                 }
             },
             "op": "!=",
@@ -1221,7 +1221,7 @@
             "left": {
                 "payload": {
                     "field": "max-delay",
-                    "name": "icmpv6"
+                    "protocol": "icmpv6"
                 }
             },
 	    "op": "==",
@@ -1244,7 +1244,7 @@
             "left": {
                 "payload": {
                     "field": "max-delay",
-                    "name": "icmpv6"
+                    "protocol": "icmpv6"
                 }
             },
             "op": "!=",
@@ -1267,7 +1267,7 @@
             "left": {
                 "payload": {
                     "field": "max-delay",
-                    "name": "icmpv6"
+                    "protocol": "icmpv6"
                 }
             },
 	    "op": "==",
@@ -1287,7 +1287,7 @@
             "left": {
                 "payload": {
                     "field": "max-delay",
-                    "name": "icmpv6"
+                    "protocol": "icmpv6"
                 }
             },
             "op": "!=",
@@ -1300,3 +1300,18 @@
     }
 ]
 
+# icmpv6 type packet-too-big icmpv6 mtu 1280
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "mtu",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": 1280
+        }
+    }
+]
diff --git a/tests/py/ip6/icmpv6.t.json.output b/tests/py/ip6/icmpv6.t.json.output
index 3a1066211f56..7b8f5c1909db 100644
--- a/tests/py/ip6/icmpv6.t.json.output
+++ b/tests/py/ip6/icmpv6.t.json.output
@@ -8,7 +8,7 @@
                     "protocol": "icmpv6"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "mld-listener-done"
         }
     },
@@ -27,7 +27,7 @@
                     "protocol": "icmpv6"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     "time-exceeded",
@@ -53,7 +53,7 @@
                     "protocol": "icmpv6"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     "time-exceeded",
@@ -103,7 +103,7 @@
                     "protocol": "icmpv6"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "port-unreachable"
         }
     }
@@ -119,9 +119,12 @@
                     "protocol": "icmpv6"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ "addr-unreachable", 66 ]
+                "range": [
+                    "addr-unreachable",
+                    66
+                ]
             }
         }
     }
@@ -137,7 +140,7 @@
                     "protocol": "icmpv6"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     "policy-fail",
@@ -162,10 +165,15 @@
                     "protocol": "icmpv6"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ "addr-unreachable", 66 ] }
+                    {
+                        "range": [
+                            "addr-unreachable",
+                            66
+                        ]
+                    }
                 ]
             }
         }
@@ -185,7 +193,565 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ "addr-unreachable", 66 ] }
+                    {
+                        "range": [
+                            "addr-unreachable",
+                            66
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 id 33-45
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    33,
+                    45
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 id != 33-45
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "!=",
+            "right": {
+                "range": [
+                    33,
+                    45
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 id {33, 55, 67, 88}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    33,
+                    55,
+                    67,
+                    88
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 id != {33, 55, 67, 88}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "!=",
+            "right": {
+                "set": [
+                    33,
+                    55,
+                    67,
+                    88
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 id {33-55}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 id != {33-55}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "!=",
+            "right": {
+                "set": [
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 sequence 2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# icmpv6 sequence {3, 4, 5, 6, 7} accept
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    3,
+                    4,
+                    5,
+                    6,
+                    7
+                ]
+            }
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
+# icmpv6 sequence {2, 4}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    2,
+                    4
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 sequence != {2, 4}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "!=",
+            "right": {
+                "set": [
+                    2,
+                    4
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 sequence 2-4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    2,
+                    4
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 sequence != 2-4
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "!=",
+            "right": {
+                "range": [
+                    2,
+                    4
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 sequence { 2-4}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "range": [
+                            2,
+                            4
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# icmpv6 sequence != { 2-4}
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-request",
+                    "echo-reply"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sequence",
+                    "protocol": "icmpv6"
+                }
+            },
+            "op": "!=",
+            "right": {
+                "set": [
+                    {
+                        "range": [
+                            2,
+                            4
+                        ]
+                    }
                 ]
             }
         }
-- 
2.26.2

