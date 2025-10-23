Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA25F27FD62
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236088; cv=none; b=PyaUTJhcARtUoDHqMEFyTzXuanNbGR0YdVZYmOVeXcc7iN+h30KDPFsufTL4atBbkgO0o+/vDInkwyg5UHuy582Dougqmvrf8vho5b848LxnpZnCi/YQn2VWU8kcOgIUPSevEMOGt7EvrH58ZDR4NE/PBPwnsk9wIu2w8ajAXnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236088; c=relaxed/simple;
	bh=QVkOt2kHF6DlVA+EpG60rrYrRM2C61gN6aIXUByqes4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOmFzVhn5BNrJFzh23wI8MEi2gjKvVEMcDJM30ruumWNNBjDsdkCpLsPU7M+np0hywrMdmoBCGomPOcimMBflo3v1DIVwJavA+vUxgr32BENuCnpJPQqW83TTeAbdCjUBWuhmDmYIAB0wVKquF1hYrk83OpMpPvvSheSB88hnaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FPjw+2Ye; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FPjw+2Ye"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Xub6H5ErZ7gBkZ64OL5KVbBi85YhIyEJcxhx5dAfRHQ=; b=FPjw+2YeveIyCw/X1p/ubosKqv
	zsLJONZNHCW+yboqH2uXiTlQXnGlaun7aIIfUM7/8dlXNPllzR4S9O014bf2oVMlT7Qv72JSZbCrV
	rFf4/d2FgzCU9T9JJqW8rFRcGfscY1Keah86Gl6Gjd8eBlltWnWZMXDTQJRpVnWnpajaFPjr9JTgR
	nDb7kQ73fxRQLapFl5in6PDgEcZc3cz7gGpzqEKQlMnWr9NwUwJI249wJcYmOyS+Vnlwusk9jM5lc
	s+mb1MqF4yKBpSA5li6RjCaRaAUrUD9p8xzJ8EaopWnyIdHqEL9z1xlpPu4O4PPIfqajAzgqFrN0N
	M8OdnDvQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxb-0000000006U-2PfE;
	Thu, 23 Oct 2025 18:14:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 23/28] tests: Adjust JSON records to improved element sorting
Date: Thu, 23 Oct 2025 18:14:12 +0200
Message-ID: <20251023161417.13228-24-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Contrary to with standard syntax, nft-test.py does not cover for
deviating set element ordering when comparing JSON output with records.
Sorting sets in JSON output is tedious due to potential nesting - the
simple algorithm searching for curly braces and checking each element is
present on both sides won't do here.

Also the above would not cover for shell test suite anyway, so just
update the records.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/ct.t.json.output                 | 20 ++---
 tests/py/any/meta.t.json.output               | 54 -------------
 tests/py/any/queue.t.json.output              |  4 +-
 tests/py/any/tcpopt.t.json.output             | 77 -------------------
 tests/py/inet/osf.t.json.output               | 54 +++++++++++++
 .../testcases/maps/dumps/0012map_0.json-nft   | 20 ++---
 .../shell/testcases/maps/dumps/0012map_0.nft  |  8 +-
 .../maps/dumps/named_ct_objects.json-nft      | 12 +--
 .../testcases/maps/dumps/named_ct_objects.nft |  6 +-
 .../maps/dumps/typeof_integer_0.json-nft      | 12 +--
 .../testcases/maps/dumps/typeof_integer_0.nft |  4 +-
 .../dumps/0012different_defines_0.json-nft    |  8 +-
 .../nft-f/dumps/0012different_defines_0.nft   |  2 +-
 .../dumps/merge_nat_inet.json-nft             | 12 +--
 .../optimizations/dumps/merge_nat_inet.nft    |  2 +-
 .../optimizations/dumps/merge_reject.json-nft | 16 ++--
 .../optimizations/dumps/merge_reject.nft      |  4 +-
 .../dumps/merge_stmts_concat.json-nft         | 42 +++++-----
 .../dumps/merge_stmts_concat.nft              |  8 +-
 .../dumps/merge_stmts_concat_vmap.json-nft    |  4 +-
 .../dumps/merge_stmts_concat_vmap.nft         |  2 +-
 .../sets/dumps/0029named_ifname_dtype_0.nft   |  4 +-
 .../0037_set_with_inet_service_0.json-nft     | 12 +--
 .../dumps/0037_set_with_inet_service_0.nft    |  8 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |  4 +-
 .../sets/dumps/sets_with_ifnames.nft          |  2 +-
 .../testcases/sets/dumps/typeof_sets_0.nft    |  4 +-
 tests/shell/testcases/sets/typeof_sets_0      |  4 +-
 28 files changed, 166 insertions(+), 243 deletions(-)

diff --git a/tests/py/any/ct.t.json.output b/tests/py/any/ct.t.json.output
index 82634c2da6720..3f7959301354a 100644
--- a/tests/py/any/ct.t.json.output
+++ b/tests/py/any/ct.t.json.output
@@ -494,14 +494,14 @@
                 "set": [
                     {
                         "concat": [
-                            "new",
-                            305419896
+                            "established",
+                            309876276
                         ]
                     },
                     {
                         "concat": [
-                            "established",
-                            309876276
+                            "new",
+                            305419896
                         ]
                     },
                     {
@@ -578,23 +578,23 @@
                     [
                         {
                             "concat": [
-                                "new",
-                                305419896
+                                "established",
+                                2271560481
                             ]
                         },
                         {
-                            "drop": null
+                            "accept": null
                         }
                     ],
                     [
                         {
                             "concat": [
-                                "established",
-                                2271560481
+                                "new",
+                                305419896
                             ]
                         },
                         {
-                            "accept": null
+                            "drop": null
                         }
                     ]
                 ]
diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
index 8f4d597a5034e..4454bb960385d 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -233,60 +233,6 @@
     }
 ]
 
-# meta iifname {"dummy0", "lo"}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "iifname" }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    "lo",
-                    "dummy0"
-                ]
-            }
-        }
-    }
-]
-
-# meta iifname != {"dummy0", "lo"}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "iifname" }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    "lo",
-                    "dummy0"
-                ]
-            }
-        }
-    }
-]
-
-# meta oifname { "dummy0", "lo"}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "oifname" }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    "lo",
-                    "dummy0"
-                ]
-            }
-        }
-    }
-]
-
 # meta skuid {"bin", "root", "daemon"} accept
 [
     {
diff --git a/tests/py/any/queue.t.json.output b/tests/py/any/queue.t.json.output
index ea3722383f113..90670cc938866 100644
--- a/tests/py/any/queue.t.json.output
+++ b/tests/py/any/queue.t.json.output
@@ -104,11 +104,11 @@
                                 0
                             ],
                             [
-                                "ppp0",
+                                "eth1",
                                 2
                             ],
                             [
-                                "eth1",
+                                "ppp0",
                                 2
                             ]
                         ]
diff --git a/tests/py/any/tcpopt.t.json.output b/tests/py/any/tcpopt.t.json.output
index ae979e7747762..4f170cf62e411 100644
--- a/tests/py/any/tcpopt.t.json.output
+++ b/tests/py/any/tcpopt.t.json.output
@@ -29,80 +29,3 @@
         }
     }
 ]
-
-# tcp option mptcp subtype . tcp dport { mp-capable . 10, mp-join . 100, add-addr . 200, remove-addr . 300, mp-prio . 400, mp-fail . 500, mp-fastclose . 600, mp-tcprst . 700 }
-[
-    {
-        "match": {
-            "left": {
-                "concat": [
-                    {
-                        "tcp option": {
-                            "field": "subtype",
-                            "name": "mptcp"
-                        }
-                    },
-                    {
-                        "payload": {
-                            "field": "dport",
-                            "protocol": "tcp"
-                        }
-                    }
-                ]
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "concat": [
-                            "mp-capable",
-                            10
-                        ]
-                    },
-                    {
-                        "concat": [
-                            "remove-addr",
-                            300
-                        ]
-                    },
-                    {
-                        "concat": [
-                            "mp-fastclose",
-                            600
-                        ]
-                    },
-                    {
-                        "concat": [
-                            "mp-join",
-                            100
-                        ]
-                    },
-                    {
-                        "concat": [
-                            "mp-prio",
-                            400
-                        ]
-                    },
-                    {
-                        "concat": [
-                            "mp-tcprst",
-                            700
-                        ]
-                    },
-                    {
-                        "concat": [
-                            "add-addr",
-                            200
-                        ]
-                    },
-                    {
-                        "concat": [
-                            "mp-fail",
-                            500
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
diff --git a/tests/py/inet/osf.t.json.output b/tests/py/inet/osf.t.json.output
index 922e395f202c7..77ca7e30e0f77 100644
--- a/tests/py/inet/osf.t.json.output
+++ b/tests/py/inet/osf.t.json.output
@@ -18,6 +18,26 @@
     }
 ]
 
+# osf version { "Windows:XP", "MacOs:Sierra" }
+[
+    {
+        "match": {
+            "left": {
+                "osf": {
+                    "key": "version"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "MacOs:Sierra",
+                    "Windows:XP"
+                ]
+            }
+        }
+    }
+]
+
 # ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
 [
     {
@@ -51,3 +71,37 @@
         }
     }
 ]
+
+# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "MacOs:Sierra",
+                                4
+                            ],
+                            [
+                                "Windows:XP",
+                                3
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "osf": {
+                            "key": "version"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
index 2892e11d71f54..6c885703ffd6b 100644
--- a/tests/shell/testcases/maps/dumps/0012map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
@@ -32,21 +32,21 @@
         "map": "verdict",
         "elem": [
           [
-            "lo",
+            "eth0",
             {
-              "accept": null
+              "drop": null
             }
           ],
           [
-            "eth0",
+            "eth1",
             {
               "drop": null
             }
           ],
           [
-            "eth1",
+            "lo",
             {
-              "drop": null
+              "accept": null
             }
           ]
         ]
@@ -69,21 +69,21 @@
               "data": {
                 "set": [
                   [
-                    "lo",
+                    "eth0",
                     {
-                      "accept": null
+                      "drop": null
                     }
                   ],
                   [
-                    "eth0",
+                    "eth1",
                     {
                       "drop": null
                     }
                   ],
                   [
-                    "eth1",
+                    "lo",
                     {
-                      "drop": null
+                      "accept": null
                     }
                   ]
                 ]
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.nft b/tests/shell/testcases/maps/dumps/0012map_0.nft
index e734fc1c70b93..0df329a550518 100644
--- a/tests/shell/testcases/maps/dumps/0012map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0012map_0.nft
@@ -1,12 +1,12 @@
 table ip x {
 	map z {
 		type ifname : verdict
-		elements = { "lo" : accept,
-			     "eth0" : drop,
-			     "eth1" : drop }
+		elements = { "eth0" : drop,
+			     "eth1" : drop,
+			     "lo" : accept }
 	}
 
 	chain y {
-		iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
+		iifname vmap { "eth0" : drop, "eth1" : drop, "lo" : accept }
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
index c0f270e372b24..21ab05653a6d3 100644
--- a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
@@ -195,8 +195,8 @@
         },
         "handle": 0,
         "elem": [
-          "sip",
-          "ftp"
+          "ftp",
+          "sip"
         ]
       }
     },
@@ -318,8 +318,8 @@
                     [
                       {
                         "concat": [
-                          "feed::17",
-                          512
+                          "dead::beef",
+                          123
                         ]
                       },
                       "exp2"
@@ -327,8 +327,8 @@
                     [
                       {
                         "concat": [
-                          "dead::beef",
-                          123
+                          "feed::17",
+                          512
                         ]
                       },
                       "exp2"
diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.nft b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
index 59f18932b28ad..18b52eb16a052 100644
--- a/tests/shell/testcases/maps/dumps/named_ct_objects.nft
+++ b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
@@ -50,15 +50,15 @@ table inet t {
 
 	set helpname {
 		typeof ct helper
-		elements = { "sip",
-			     "ftp" }
+		elements = { "ftp",
+			     "sip" }
 	}
 
 	chain y {
 		ct expectation set ip saddr map @exp
 		ct expectation set ip6 saddr map { dead::beef : "exp2" }
 		ct expectation set ip6 daddr map { dead::beef : "exp2", feed::17 : "exp2" }
-		ct expectation set ip6 daddr . tcp dport map { feed::17 . 512 : "exp2", dead::beef . 123 : "exp2" }
+		ct expectation set ip6 daddr . tcp dport map { dead::beef . 123 : "exp2", feed::17 . 512 : "exp2" }
 		ct helper set ip6 saddr map { 1c3::c01d : "myftp", dead::beef : "myftp" }
 		ct helper set ip6 saddr map @helpobj
 		ct timeout set ip daddr map @timeoutmap
diff --git a/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft b/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft
index 1df729b40a74f..65474c9e2a1b1 100644
--- a/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_integer_0.json-nft
@@ -117,23 +117,23 @@
           [
             {
               "concat": [
-                30,
-                30
+                20,
+                36
               ]
             },
             {
-              "drop": null
+              "accept": null
             }
           ],
           [
             {
               "concat": [
-                20,
-                36
+                30,
+                30
               ]
             },
             {
-              "accept": null
+              "drop": null
             }
           ]
         ]
diff --git a/tests/shell/testcases/maps/dumps/typeof_integer_0.nft b/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
index 19c24febffcc5..7bd7daaad7610 100644
--- a/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
@@ -8,8 +8,8 @@ table inet t {
 
 	map m2 {
 		typeof udp length . @ih,32,32 : verdict
-		elements = { 30 . 0x1e : drop,
-			     20 . 0x24 : accept }
+		elements = { 20 . 0x24 : accept,
+			     30 . 0x1e : drop }
 	}
 
 	chain c {
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
index 0e7ea228501b4..e266bf4c8a698 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.json-nft
@@ -361,14 +361,14 @@
                 "set": [
                   {
                     "concat": [
-                      "fe0::2",
-                      "tcp"
+                      "fe0::1",
+                      "udp"
                     ]
                   },
                   {
                     "concat": [
-                      "fe0::1",
-                      "udp"
+                      "fe0::2",
+                      "tcp"
                     ]
                   }
                 ]
diff --git a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
index 4734b2fd8bd13..a6e16e7dd0336 100644
--- a/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
+++ b/tests/shell/testcases/nft-f/dumps/0012different_defines_0.nft
@@ -8,7 +8,7 @@ table inet t {
 		ip6 daddr fe0::1 ip6 saddr fe0::2
 		ip saddr vmap { 10.0.0.0 : drop, 10.0.0.2 : accept }
 		ip6 daddr vmap { fe0::1 : drop, fe0::2 : accept }
-		ip6 saddr . ip6 nexthdr { fe0::2 . tcp, fe0::1 . udp }
+		ip6 saddr . ip6 nexthdr { fe0::1 . udp, fe0::2 . tcp }
 		ip daddr . iif vmap { 10.0.0.0 . "lo" : accept }
 		tcp dport 100-222
 		udp dport vmap { 100-222 : accept }
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat_inet.json-nft b/tests/shell/testcases/optimizations/dumps/merge_nat_inet.json-nft
index 99930f112ec69..7df802e6bd90b 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat_inet.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat_inet.json-nft
@@ -93,14 +93,14 @@
                         {
                           "concat": [
                             "enp2s0",
-                            "72.2.3.70",
-                            80
+                            "72.2.3.66",
+                            443
                           ]
                         },
                         {
                           "concat": [
                             "10.1.1.52",
-                            80
+                            443
                           ]
                         }
                       ],
@@ -123,14 +123,14 @@
                         {
                           "concat": [
                             "enp2s0",
-                            "72.2.3.66",
-                            443
+                            "72.2.3.70",
+                            80
                           ]
                         },
                         {
                           "concat": [
                             "10.1.1.52",
-                            443
+                            80
                           ]
                         }
                       ]
diff --git a/tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft b/tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft
index a1a1135482b95..1e08d5a5a1229 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_nat_inet.nft
@@ -1,7 +1,7 @@
 table inet nat {
 	chain prerouting {
 		oif "lo" accept
-		dnat ip to iifname . ip daddr . tcp dport map { "enp2s0" . 72.2.3.70 . 80 : 10.1.1.52 . 80, "enp2s0" . 72.2.3.66 . 53122 : 10.1.1.10 . 22, "enp2s0" . 72.2.3.66 . 443 : 10.1.1.52 . 443 }
+		dnat ip to iifname . ip daddr . tcp dport map { "enp2s0" . 72.2.3.66 . 443 : 10.1.1.52 . 443, "enp2s0" . 72.2.3.66 . 53122 : 10.1.1.10 . 22, "enp2s0" . 72.2.3.70 . 80 : 10.1.1.52 . 80 }
 	}
 
 	chain postrouting {
diff --git a/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft b/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft
index 46ed0677d203e..8f468e019657c 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_reject.json-nft
@@ -101,15 +101,15 @@
                   {
                     "concat": [
                       "tcp",
-                      "172.30.238.117",
-                      8080
+                      "172.30.33.71",
+                      3306
                     ]
                   },
                   {
                     "concat": [
                       "tcp",
-                      "172.30.33.71",
-                      3306
+                      "172.30.238.117",
+                      8080
                     ]
                   },
                   {
@@ -234,15 +234,15 @@
                   {
                     "concat": [
                       "tcp",
-                      "aaaa::3",
-                      8080
+                      "aaaa::2",
+                      3306
                     ]
                   },
                   {
                     "concat": [
                       "tcp",
-                      "aaaa::2",
-                      3306
+                      "aaaa::3",
+                      8080
                     ]
                   },
                   {
diff --git a/tests/shell/testcases/optimizations/dumps/merge_reject.nft b/tests/shell/testcases/optimizations/dumps/merge_reject.nft
index c29ad6d5648b6..1727d024866d7 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_reject.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_reject.nft
@@ -1,13 +1,13 @@
 table ip x {
 	chain y {
 		ip daddr 172.30.33.70 tcp dport 3306 counter packets 0 bytes 0 drop
-		meta l4proto . ip daddr . tcp dport { tcp . 172.30.238.117 . 8080, tcp . 172.30.33.71 . 3306, tcp . 172.30.254.251 . 3306 } counter packets 0 bytes 0 reject
+		meta l4proto . ip daddr . tcp dport { tcp . 172.30.33.71 . 3306, tcp . 172.30.238.117 . 8080, tcp . 172.30.254.251 . 3306 } counter packets 0 bytes 0 reject
 		ip daddr 172.30.254.252 tcp dport 3306 counter packets 0 bytes 0 reject with tcp reset
 	}
 }
 table ip6 x {
 	chain y {
-		meta l4proto . ip6 daddr . tcp dport { tcp . aaaa::3 . 8080, tcp . aaaa::2 . 3306, tcp . aaaa::4 . 3306 } counter packets 0 bytes 0 reject
+		meta l4proto . ip6 daddr . tcp dport { tcp . aaaa::2 . 3306, tcp . aaaa::3 . 8080, tcp . aaaa::4 . 3306 } counter packets 0 bytes 0 reject
 		ip6 daddr aaaa::5 tcp dport 3306 counter packets 0 bytes 0 reject with tcp reset
 	}
 }
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
index 46e740a8f5b5a..b70ee97b35ebd 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.json-nft
@@ -216,14 +216,14 @@
                   },
                   {
                     "concat": [
-                      138,
-                      "new"
+                      137,
+                      "untracked"
                     ]
                   },
                   {
                     "concat": [
-                      137,
-                      "untracked"
+                      138,
+                      "new"
                     ]
                   },
                   {
@@ -271,8 +271,8 @@
                 "set": [
                   {
                     "concat": [
-                      51820,
-                      "foo"
+                      67,
+                      "bar"
                     ]
                   },
                   {
@@ -283,8 +283,8 @@
                   },
                   {
                     "concat": [
-                      67,
-                      "bar"
+                      51820,
+                      "foo"
                     ]
                   }
                 ]
@@ -326,13 +326,13 @@
                 "set": [
                   {
                     "concat": [
-                      100,
-                      "foo"
+                      67,
+                      "bar"
                     ]
                   },
                   {
                     "concat": [
-                      51820,
+                      100,
                       "foo"
                     ]
                   },
@@ -344,8 +344,8 @@
                   },
                   {
                     "concat": [
-                      67,
-                      "bar"
+                      51820,
+                      "foo"
                     ]
                   }
                 ]
@@ -387,32 +387,32 @@
                 "set": [
                   {
                     "concat": [
-                      100,
-                      "foo"
+                      67,
+                      "bar"
                     ]
                   },
                   {
                     "concat": [
-                      51820,
+                      100,
                       "foo"
                     ]
                   },
                   {
                     "concat": [
-                      514,
-                      "bar"
+                      100,
+                      "test"
                     ]
                   },
                   {
                     "concat": [
-                      67,
+                      514,
                       "bar"
                     ]
                   },
                   {
                     "concat": [
-                      100,
-                      "test"
+                      51820,
+                      "foo"
                     ]
                   },
                   {
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
index d00ac417ca759..6150258512061 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat.nft
@@ -2,18 +2,18 @@ table ip x {
 	chain y {
 		iifname . ip saddr . ip daddr { "eth1" . 1.1.1.1 . 2.2.2.3, "eth1" . 1.1.1.2 . 2.2.2.4, "eth1" . 1.1.1.2 . 2.2.3.0/24, "eth1" . 1.1.1.2 . 2.2.4.0-2.2.4.10, "eth2" . 1.1.1.3 . 2.2.2.5 } accept
 		ip protocol . th dport { tcp . 22, udp . 67 }
-		udp dport . ct state { 137 . new, 138 . new, 137 . untracked, 138 . untracked } accept
+		udp dport . ct state { 137 . new, 137 . untracked, 138 . new, 138 . untracked } accept
 	}
 
 	chain c1 {
-		udp dport . iifname { 51820 . "foo", 514 . "bar", 67 . "bar" } accept
+		udp dport . iifname { 67 . "bar", 514 . "bar", 51820 . "foo" } accept
 	}
 
 	chain c2 {
-		udp dport . iifname { 100 . "foo", 51820 . "foo", 514 . "bar", 67 . "bar" } accept
+		udp dport . iifname { 67 . "bar", 100 . "foo", 514 . "bar", 51820 . "foo" } accept
 	}
 
 	chain c3 {
-		udp dport . iifname { 100 . "foo", 51820 . "foo", 514 . "bar", 67 . "bar", 100 . "test", 51820 . "test" } accept
+		udp dport . iifname { 67 . "bar", 100 . "foo", 100 . "test", 514 . "bar", 51820 . "foo", 51820 . "test" } accept
 	}
 }
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.json-nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.json-nft
index 5dfa40a821ebe..5259e5647cf08 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.json-nft
@@ -60,7 +60,7 @@
                     {
                       "concat": [
                         "broadcast",
-                        547
+                        67
                       ]
                     },
                     {
@@ -71,7 +71,7 @@
                     {
                       "concat": [
                         "broadcast",
-                        67
+                        547
                       ]
                     },
                     {
diff --git a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
index 780aa09adbe65..81abb99464e0a 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_stmts_concat_vmap.nft
@@ -1,6 +1,6 @@
 table ip x {
 	chain x {
-		meta pkttype . udp dport vmap { broadcast . 547 : accept, broadcast . 67 : accept, multicast . 1900 : drop }
+		meta pkttype . udp dport vmap { broadcast . 67 : accept, broadcast . 547 : accept, multicast . 1900 : drop }
 	}
 
 	chain y {
diff --git a/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft b/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
index 6f9832a96188f..e75d8a960e7d0 100644
--- a/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
+++ b/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
@@ -12,8 +12,8 @@ table inet t {
 		type inet_service . ifname
 		elements = { 22 . "eth0",
 			     80 . "eth0",
-			     81 . "eth0",
-			     80 . "eth1" }
+			     80 . "eth1",
+			     81 . "eth0" }
 	}
 
 	set nv {
diff --git a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
index 1c3b559d48d43..cf1c1cc9d479e 100644
--- a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
@@ -40,16 +40,16 @@
         "elem": [
           {
             "concat": [
-              "192.168.0.113",
+              "192.168.0.12",
               "tcp",
-              22
+              53
             ]
           },
           {
             "concat": [
               "192.168.0.12",
               "tcp",
-              53
+              80
             ]
           },
           {
@@ -61,16 +61,16 @@
           },
           {
             "concat": [
-              "192.168.0.12",
+              "192.168.0.13",
               "tcp",
               80
             ]
           },
           {
             "concat": [
-              "192.168.0.13",
+              "192.168.0.113",
               "tcp",
-              80
+              22
             ]
           }
         ]
diff --git a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
index 68b1f7bec4d84..0e85f7c20eba0 100644
--- a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
+++ b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.nft
@@ -1,11 +1,11 @@
 table inet filter {
 	set myset {
 		type ipv4_addr . inet_proto . inet_service
-		elements = { 192.168.0.113 . tcp . 22,
-			     192.168.0.12 . tcp . 53,
-			     192.168.0.12 . udp . 53,
+		elements = { 192.168.0.12 . tcp . 53,
 			     192.168.0.12 . tcp . 80,
-			     192.168.0.13 . tcp . 80 }
+			     192.168.0.12 . udp . 53,
+			     192.168.0.13 . tcp . 80,
+			     192.168.0.113 . tcp . 22 }
 	}
 
 	chain forward {
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
index ac4284293c32a..7b4849e0530d3 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
@@ -260,8 +260,8 @@
               },
               "right": {
                 "set": [
-                  "eth0",
-                  "abcdef0"
+                  "abcdef0",
+                  "eth0"
                 ]
               }
             }
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
index 77a8baf58cef2..8abca03a080ec 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
@@ -39,7 +39,7 @@ table inet testifsets {
 	chain v4icmp {
 		iifname @simple counter packets 0 bytes 0
 		iifname @simple_wild counter packets 0 bytes 0
-		iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
+		iifname { "abcdef0", "eth0" } counter packets 0 bytes 0
 		iifname { "abcdef*", "eth0" } counter packets 0 bytes 0
 		iifname vmap @map_wild
 	}
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index 34aaab601cda3..1ceddfc4cded7 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -67,8 +67,8 @@ table inet t {
 
 	set s14 {
 		typeof tcp option mptcp subtype . ip daddr
-		elements = { remove-addr . 10.1.1.1,
-			     mp-join . 10.1.1.2 }
+		elements = { mp-join . 10.1.1.2,
+			     remove-addr . 10.1.1.1 }
 	}
 
 	chain c1 {
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 28e39b4d2cb30..8850e9acea698 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -223,8 +223,8 @@ $INPUT_VERSION_SET
 
 	set s14 {
 		typeof tcp option mptcp subtype . ip daddr
-		elements = { remove-addr . 10.1.1.1,
-			     mp-join . 10.1.1.2 }
+		elements = { mp-join . 10.1.1.2,
+			     remove-addr . 10.1.1.1 }
 	}
 $INPUT_OSF_CHAIN
 	chain c2 {
-- 
2.51.0

