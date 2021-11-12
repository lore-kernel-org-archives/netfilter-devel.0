Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF850C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 11:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C29C960F55
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 11:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhKLLe6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 06:34:58 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57774 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhKLLe5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 06:34:57 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 096BB605C7
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2021 12:30:03 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/3] tests: py: missing ip/dnat.t json updates
Date:   Fri, 12 Nov 2021 12:31:55 +0100
Message-Id: <20211112113157.576409-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing json update for three new tests added recently.

Fixes: 640dc0c8a3da ("tests: py: extend coverage for dnat with classic range representation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/dnat.t.json | 333 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 333 insertions(+)

diff --git a/tests/py/ip/dnat.t.json b/tests/py/ip/dnat.t.json
index 0481a3683752..ede4d04bdb10 100644
--- a/tests/py/ip/dnat.t.json
+++ b/tests/py/ip/dnat.t.json
@@ -262,3 +262,336 @@
     }
 ]
 
+# iifname "eth0" tcp dport 81 dnat to 192.168.3.2:8080-8999
+[
+    {
+	"match": {
+	    "left": {
+		"meta": {
+		    "key": "iifname"
+		}
+	    },
+	    "op": "==",
+	    "right": "eth0"
+	}
+    },
+    {
+	"match": {
+	    "left": {
+		"payload": {
+		    "field": "dport",
+		    "protocol": "tcp"
+		}
+	    },
+	    "op": "==",
+	    "right": 81
+	}
+    },
+    {
+	"dnat": {
+	    "addr": "192.168.3.2",
+	    "port": {
+		"range": [
+		    8080,
+		    8999
+		]
+	    }
+	}
+    }
+]
+
+# iifname "eth0" tcp dport 81 dnat to 192.168.3.2-192.168.3.4:8080-8999
+[
+    {
+	"match": {
+	    "left": {
+		"meta": {
+		    "key": "iifname"
+		}
+	    },
+	    "op": "==",
+	    "right": "eth0"
+	}
+    },
+    {
+	"match": {
+	    "left": {
+		"payload": {
+		    "field": "dport",
+		    "protocol": "tcp"
+		}
+	    },
+	    "op": "==",
+	    "right": 81
+	}
+    },
+    {
+	"dnat": {
+	    "addr": {
+		"range": [
+		    "192.168.3.2",
+		    "192.168.3.4"
+		]
+	    },
+	    "port": {
+		"range": [
+		    8080,
+		    8999
+		]
+	    }
+	}
+    }
+]
+
+# iifname "eth0" tcp dport 81 dnat to 192.168.3.2-192.168.3.4:8080
+[
+    {
+	"match": {
+	    "left": {
+		"meta": {
+		    "key": "iifname"
+		}
+	    },
+	    "op": "==",
+	    "right": "eth0"
+	}
+    },
+    {
+	"match": {
+	    "left": {
+		"payload": {
+		    "field": "dport",
+		    "protocol": "tcp"
+		}
+	    },
+	    "op": "==",
+	    "right": 81
+	}
+    },
+    {
+	"dnat": {
+	    "addr": {
+		"range": [
+		    "192.168.3.2",
+		    "192.168.3.4"
+		]
+	    },
+	    "port": 8080
+	}
+    }
+]
+
+# dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.2 . 8888 - 8999 }
+[
+    {
+	"dnat": {
+	    "addr": {
+		"map": {
+		    "data": {
+			"set": [
+			    [
+				{
+				    "concat": [
+					"192.168.1.2",
+					80
+				    ]
+				},
+				{
+				    "concat": [
+					"10.141.10.2",
+					{
+					    "range": [
+						8888,
+						8999
+					    ]
+					}
+				    ]
+				}
+			    ]
+			]
+		    },
+		    "key": {
+			"concat": [
+			    {
+				"payload": {
+				    "field": "saddr",
+				    "protocol": "ip"
+				}
+			    },
+			    {
+				"payload": {
+				    "field": "dport",
+				    "protocol": "tcp"
+				}
+			    }
+			]
+		    }
+		}
+	    },
+	    "family": "ip"
+	}
+    }
+]
+
+# dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 8888 - 8999 }
+[
+    {
+	"dnat": {
+	    "addr": {
+		"map": {
+		    "data": {
+			"set": [
+			    [
+				{
+				    "concat": [
+					"192.168.1.2",
+					80
+				    ]
+				},
+				{
+				    "concat": [
+					{
+					    "prefix": {
+						"addr": "10.141.10.0",
+						"len": 24
+					    }
+					},
+					{
+					    "range": [
+						8888,
+						8999
+					    ]
+					}
+				    ]
+				}
+			    ]
+			]
+		    },
+		    "key": {
+			"concat": [
+			    {
+				"payload": {
+				    "field": "saddr",
+				    "protocol": "ip"
+				}
+			    },
+			    {
+				"payload": {
+				    "field": "dport",
+				    "protocol": "tcp"
+				}
+			    }
+			]
+		    }
+		}
+	    },
+	    "family": "ip"
+	}
+    }
+]
+
+# dnat ip to ip saddr . tcp dport map { 192.168.1.2 . 80 : 10.141.10.0/24  . 80 }
+[
+    {
+	"dnat": {
+	    "addr": {
+		"map": {
+		    "data": {
+			"set": [
+			    [
+				{
+				    "concat": [
+					"192.168.1.2",
+					80
+				    ]
+				},
+				{
+				    "concat": [
+					{
+					    "prefix": {
+						"addr": "10.141.10.0",
+						"len": 24
+					    }
+					},
+					80
+				    ]
+				}
+			    ]
+			]
+		    },
+		    "key": {
+			"concat": [
+			    {
+				"payload": {
+				    "field": "saddr",
+				    "protocol": "ip"
+				}
+			    },
+			    {
+				"payload": {
+				    "field": "dport",
+				    "protocol": "tcp"
+				}
+			    }
+			]
+		    }
+		}
+	    },
+	    "family": "ip"
+	}
+    }
+]
+
+# ip daddr 192.168.0.1 dnat ip to tcp dport map { 443 : 10.141.10.4 . 8443, 80 : 10.141.10.4 . 8080 }
+[
+    {
+	"match": {
+	    "left": {
+		"payload": {
+		    "field": "daddr",
+		    "protocol": "ip"
+		}
+	    },
+	    "op": "==",
+	    "right": "192.168.0.1"
+	}
+    },
+    {
+	"dnat": {
+	    "addr": {
+		"map": {
+		    "data": {
+			"set": [
+			    [
+				80,
+				{
+				    "concat": [
+					"10.141.10.4",
+					8080
+				    ]
+				}
+			    ],
+			    [
+				443,
+				{
+				    "concat": [
+					"10.141.10.4",
+					8443
+				    ]
+				}
+			    ]
+			]
+		    },
+		    "key": {
+			"payload": {
+			    "field": "dport",
+			    "protocol": "tcp"
+			}
+		    }
+		}
+	    },
+	    "family": "ip"
+	}
+    }
+]
+
-- 
2.30.2

