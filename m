Return-Path: <SRS0=JlPR=VE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956EAC48BE1
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 20:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62F4120684
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jul 2019 20:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfGGUzn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jul 2019 16:55:43 -0400
Received: from fnsib-smtp07.srv.cat ([46.16.61.64]:50888 "EHLO
        fnsib-smtp07.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfGGUzn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jul 2019 16:55:43 -0400
Received: from localhost.localdomain (unknown [47.62.206.189])
        by fnsib-smtp07.srv.cat (Postfix) with ESMTPSA id DD938810E;
        Sun,  7 Jul 2019 22:55:37 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Cc:     Ander Juaristi <a@juaristi.eus>
Subject: [PATCH v5 2/3] tests/py: Add tests for 'time', 'day' and 'hour'
Date:   Sun,  7 Jul 2019 22:55:30 +0200
Message-Id: <20190707205531.6628-2-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190707205531.6628-1-a@juaristi.eus>
References: <20190707205531.6628-1-a@juaristi.eus>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This commit also modifies nft to print the days of the week in short
format (e.g. "Sat" instead of "Saturday").

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 src/meta.c                     |  14 +-
 tests/py/ip/meta.t             |  15 ++
 tests/py/ip/meta.t.json        | 252 +++++++++++++++++++++++++++++++++
 tests/py/ip/meta.t.json.output | 252 +++++++++++++++++++++++++++++++++
 4 files changed, 526 insertions(+), 7 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 00ff267..642741f 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -477,13 +477,13 @@ success:
 static void day_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const char *days[] = {
-		"Sunday",
-		"Monday",
-		"Tuesday",
-		"Wednesday",
-		"Thursday",
-		"Friday",
-		"Saturday"
+		"Sun",
+		"Mon",
+		"Tue",
+		"Wed",
+		"Thu",
+		"Fri",
+		"Sat"
 	};
 
 	uint8_t daynum = mpz_get_uint8(expr->value), numdays = array_size(days);
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 4db8835..ce3da1d 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -3,6 +3,21 @@
 *ip;test-ip4;input
 
 icmp type echo-request;ok
+meta time "1970-05-23 21:07:14" drop;ok
+meta time 12341234 drop;ok;meta time "1970-05-23 21:07:14" drop
+meta time "2019-06-21 17:00:00" drop;ok
+meta time "2019-07-01 00:00:00" drop;ok
+meta time "2019-07-01 00:01:00" drop;ok
+meta time "2019-07-01 00:00:01" drop;ok
+meta day "Sat" drop;ok
+meta day "Saturday" drop;ok;meta day "Sat" drop
+meta day 6 drop;ok;meta day "Sat" drop
+meta day "Sa" drop;fail
+meta hour "17:00" drop;ok
+meta hour "17:00:00" drop;ok;meta hour "17:00" drop
+meta hour "17:00:01" drop;ok
+meta hour "00:00" drop;ok
+meta hour "00:01" drop;ok
 meta l4proto icmp icmp type echo-request;ok;icmp type echo-request
 meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
 meta l4proto 58 icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
index f873aa8..30dcd0b 100644
--- a/tests/py/ip/meta.t.json
+++ b/tests/py/ip/meta.t.json
@@ -14,6 +14,258 @@
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
+# meta day "Sat" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "day"
+                }
+            },
+            "op": "==",
+            "right": "Sat"
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
+
 # meta l4proto icmp icmp type echo-request
 [
     {
diff --git a/tests/py/ip/meta.t.json.output b/tests/py/ip/meta.t.json.output
index 091282b..c4c7664 100644
--- a/tests/py/ip/meta.t.json.output
+++ b/tests/py/ip/meta.t.json.output
@@ -14,6 +14,258 @@
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
+# meta day "Sat" drop
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "day"
+                }
+            },
+            "op": "==",
+            "right": "Sat"
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
+            "right": "Sat"
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
+            "right": "Sat"
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
 # meta l4proto ipv6-icmp icmpv6 type nd-router-advert
 [
     {
-- 
2.17.1

