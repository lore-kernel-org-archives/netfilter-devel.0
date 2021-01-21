Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AF6C433E9
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A746233F8
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 13:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbhAUN4i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 08:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbhAUN4N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 08:56:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63199C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 05:55:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2aQu-00047W-2K; Thu, 21 Jan 2021 14:55:32 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/4] json: icmp: refresh json output
Date:   Thu, 21 Jan 2021 14:55:10 +0100
Message-Id: <20210121135510.14941-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121135510.14941-1-fw@strlen.de>
References: <20210121135510.14941-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft inserts dependencies for icmp header types, but I forgot to
update the json test files to reflect this change.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/icmp.t.json | 648 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 568 insertions(+), 80 deletions(-)

diff --git a/tests/py/ip/icmp.t.json b/tests/py/ip/icmp.t.json
index 965eb10be9ed..480740afb525 100644
--- a/tests/py/ip/icmp.t.json
+++ b/tests/py/ip/icmp.t.json
@@ -8,7 +8,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "echo-reply"
         }
     },
@@ -27,7 +27,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "destination-unreachable"
         }
     },
@@ -46,7 +46,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "source-quench"
         }
     },
@@ -65,7 +65,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "redirect"
         }
     },
@@ -84,7 +84,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "echo-request"
         }
     },
@@ -103,7 +103,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "time-exceeded"
         }
     },
@@ -122,7 +122,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "parameter-problem"
         }
     },
@@ -141,7 +141,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "timestamp-request"
         }
     },
@@ -160,7 +160,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "timestamp-reply"
         }
     },
@@ -179,7 +179,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "info-request"
         }
     },
@@ -198,7 +198,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "info-reply"
         }
     },
@@ -217,7 +217,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "address-mask-request"
         }
     },
@@ -236,7 +236,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "address-mask-reply"
         }
     },
@@ -255,7 +255,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "router-advertisement"
         }
     },
@@ -274,7 +274,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": "router-solicitation"
         }
     },
@@ -293,7 +293,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     "echo-reply",
@@ -301,6 +301,8 @@
                     "source-quench",
                     "redirect",
                     "echo-request",
+                    "router-advertisement",
+                    "router-solicitation",
                     "time-exceeded",
                     "parameter-problem",
                     "timestamp-request",
@@ -308,9 +310,7 @@
                     "info-request",
                     "info-reply",
                     "address-mask-request",
-                    "address-mask-reply",
-                    "router-advertisement",
-                    "router-solicitation"
+                    "address-mask-reply"
                 ]
             }
         }
@@ -352,7 +352,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 111
         }
     },
@@ -390,9 +390,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ 33, 55 ]
+                "range": [
+                    33,
+                    55
+                ]
             }
         }
     }
@@ -410,7 +413,10 @@
             },
             "op": "!=",
             "right": {
-                "range": [ 33, 55 ]
+                "range": [
+                    33,
+                    55
+                ]
             }
         }
     }
@@ -426,10 +432,15 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -449,7 +460,12 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -466,11 +482,11 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    2,
-                    4,
+                    "prot-unreachable",
+                    "frag-needed",
                     33,
                     54,
                     56
@@ -514,7 +530,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 12343
         }
     },
@@ -552,9 +568,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ 11, 343 ]
+                "range": [
+                    11,
+                    343
+                ]
             }
         }
     },
@@ -575,7 +594,10 @@
             },
             "op": "!=",
             "right": {
-                "range": [ 11, 343 ]
+                "range": [
+                    11,
+                    343
+                ]
             }
         }
     },
@@ -594,10 +616,15 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 11, 343 ] }
+                    {
+                        "range": [
+                            11,
+                            343
+                        ]
+                    }
                 ]
             }
         }
@@ -620,7 +647,12 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 11, 343 ] }
+                    {
+                        "range": [
+                            11,
+                            343
+                        ]
+                    }
                 ]
             }
         }
@@ -640,12 +672,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    1111,
                     222,
-                    343
+                    343,
+                    1111
                 ]
             }
         }
@@ -668,9 +700,9 @@
             "op": "!=",
             "right": {
                 "set": [
-                    1111,
                     222,
-                    343
+                    343,
+                    1111
                 ]
             }
         }
@@ -682,6 +714,23 @@
 
 # icmp id 1245 log
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -690,7 +739,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 1245
         }
     },
@@ -701,6 +750,23 @@
 
 # icmp id 22
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -709,7 +775,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 22
         }
     }
@@ -717,6 +783,23 @@
 
 # icmp id != 233
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -733,6 +816,23 @@
 
 # icmp id 33-45
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -741,9 +841,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -751,6 +854,23 @@
 
 # icmp id != 33-45
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -761,7 +881,10 @@
             },
             "op": "!=",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -769,6 +892,23 @@
 
 # icmp id { 33-55}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -777,10 +917,15 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -789,6 +934,23 @@
 
 # icmp id != { 33-55}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -800,7 +962,12 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -809,6 +976,23 @@
 
 # icmp id { 22, 34, 333}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -817,7 +1001,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     22,
@@ -831,6 +1015,23 @@
 
 # icmp id != { 22, 34, 333}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -853,6 +1054,23 @@
 
 # icmp sequence 22
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -861,7 +1079,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 22
         }
     }
@@ -869,6 +1087,23 @@
 
 # icmp sequence != 233
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -885,6 +1120,23 @@
 
 # icmp sequence 33-45
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -893,9 +1145,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -903,6 +1158,23 @@
 
 # icmp sequence != 33-45
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -913,7 +1185,10 @@
             },
             "op": "!=",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -921,6 +1196,23 @@
 
 # icmp sequence { 33, 55, 67, 88}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -929,7 +1221,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     33,
@@ -944,6 +1236,23 @@
 
 # icmp sequence != { 33, 55, 67, 88}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -967,6 +1276,23 @@
 
 # icmp sequence { 33-55}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -975,10 +1301,15 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -987,6 +1318,23 @@
 
 # icmp sequence != { 33-55}
 [
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
     {
         "match": {
             "left": {
@@ -998,10 +1346,105 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
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
+# icmp id 1 icmp sequence 2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
+                ]
+            }
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmp"
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
+                    "field": "sequence",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
+# icmp type { echo-reply, echo-request} icmp id 1 icmp sequence 2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "type",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "echo-reply",
+                    "echo-request"
                 ]
             }
         }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "icmp"
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
+                    "field": "sequence",
+                    "protocol": "icmp"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
     }
 ]
 
@@ -1015,7 +1458,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 33
         }
     }
@@ -1031,9 +1474,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ 22, 33 ]
+                "range": [
+                    22,
+                    33
+                ]
             }
         }
     }
@@ -1049,10 +1495,15 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 22, 33 ] }
+                    {
+                        "range": [
+                            22,
+                            33
+                        ]
+                    }
                 ]
             }
         }
@@ -1072,7 +1523,12 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 22, 33 ] }
+                    {
+                        "range": [
+                            22,
+                            33
+                        ]
+                    }
                 ]
             }
         }
@@ -1089,7 +1545,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 22
         }
     }
@@ -1121,9 +1577,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -1141,7 +1600,10 @@
             },
             "op": "!=",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -1157,7 +1619,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     33,
@@ -1203,10 +1665,15 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -1226,7 +1693,12 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -1243,7 +1715,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": 22
         }
     }
@@ -1275,9 +1747,12 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -1295,7 +1770,10 @@
             },
             "op": "!=",
             "right": {
-                "range": [ 33, 45 ]
+                "range": [
+                    33,
+                    45
+                ]
             }
         }
     }
@@ -1311,7 +1789,7 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
                     33,
@@ -1357,10 +1835,15 @@
                     "protocol": "icmp"
                 }
             },
-	    "op": "==",
+            "op": "==",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
@@ -1380,7 +1863,12 @@
             "op": "!=",
             "right": {
                 "set": [
-                    { "range": [ 33, 55 ] }
+                    {
+                        "range": [
+                            33,
+                            55
+                        ]
+                    }
                 ]
             }
         }
-- 
2.26.2

