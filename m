Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB30C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 10:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCEKaM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 05:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjCEKaI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 05:30:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE57AD303
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xbP848LAEnGO6VF83EV9Q20ACWwqK65eyjfUXJ6ZnIY=; b=A1GWsDRw4ujnU7wpn770KITesd
        +rD+MM4iCzmiUbh31tsu/i8hpbf3JGIIUe3lhwxCYZcbCLfIW06IVALOXjVCZfXtNtD0Ka6QxW+nT
        DyqiZX0QITt/iQzJJ6uVnwwQFrgU19lIDwGo8JsjwhlocK58YHxTc5a38UWZt26SdKGbj/mqA90oY
        eITPp8rH65k8BEsj1flO1XMU4O+xnuptfJ4M6XfPOvEHihw7UPCFolnIR0mrRMU9506cd7AaoMbmg
        W/DqdLxOYaiEvxHLCQGVnO8fR7TJTBlJAseVk3ScYa9PuKxyKiY58Ns7m9FOEMbt31hzUNjys90Ny
        lYzrJAkQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYlcw-00DzC0-49
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 10:30:02 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 8/8] test: py: add tests for shifted nat port-ranges
Date:   Sun,  5 Mar 2023 10:14:18 +0000
Message-Id: <20230305101418.2233910-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305101418.2233910-1-jeremy@azazel.net>
References: <20230305101418.2233910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/inet/dnat.t                  |  3 +
 tests/py/inet/dnat.t.json             | 91 +++++++++++++++++++++++++++
 tests/py/inet/dnat.t.payload          | 33 ++++++++++
 tests/py/inet/snat.t                  |  3 +
 tests/py/inet/snat.t.json             | 91 +++++++++++++++++++++++++++
 tests/py/inet/snat.t.payload          | 34 ++++++++++
 tests/py/ip/masquerade.t              |  1 +
 tests/py/ip/masquerade.t.json         | 26 ++++++++
 tests/py/ip/masquerade.t.payload      |  8 +++
 tests/py/ip/redirect.t                |  1 +
 tests/py/ip/redirect.t.json           | 26 ++++++++
 tests/py/ip/redirect.t.payload        |  8 +++
 tests/py/ip6/masquerade.t             |  1 +
 tests/py/ip6/masquerade.t.json        | 25 ++++++++
 tests/py/ip6/masquerade.t.payload.ip6 |  8 +++
 tests/py/ip6/redirect.t               |  1 +
 tests/py/ip6/redirect.t.json          | 26 ++++++++
 tests/py/ip6/redirect.t.payload.ip6   |  8 +++
 18 files changed, 394 insertions(+)

diff --git a/tests/py/inet/dnat.t b/tests/py/inet/dnat.t
index e4e169f2bc3e..9c47f51cfc71 100644
--- a/tests/py/inet/dnat.t
+++ b/tests/py/inet/dnat.t
@@ -20,3 +20,6 @@ meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80;ok;meta l4proto { 6, 17} dnat ip
 ip protocol { tcp, udp } dnat ip to 1.1.1.1:80;ok;ip protocol { 6, 17} dnat ip to 1.1.1.1:80
 meta l4proto { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80;fail
 ip protocol { tcp, udp } tcp dport 20 dnat to 1.1.1.1:80;fail
+
+ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900;ok
+ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900;ok
diff --git a/tests/py/inet/dnat.t.json b/tests/py/inet/dnat.t.json
index c341a0455fea..58d0ed4b76da 100644
--- a/tests/py/inet/dnat.t.json
+++ b/tests/py/inet/dnat.t.json
@@ -239,3 +239,94 @@
     }
 ]
 
+# ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "10.0.0.1"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    55900,
+                    55910
+                ]
+            }
+        }
+    },
+    {
+        "dnat": {
+            "addr": "192.168.127.1",
+            "family": "ip",
+            "port": {
+                "range": [
+                    5900,
+                    5910
+                ]
+            },
+	    "base_port": 55900
+        }
+    }
+]
+
+# ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ip6"
+                }
+            },
+            "op": "==",
+            "right": "10::1"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    55900,
+                    55910
+                ]
+            }
+        }
+    },
+    {
+        "dnat": {
+            "addr": "::c0:a8:7f:1",
+            "family": "ip6",
+            "port": {
+                "range": [
+                    5900,
+                    5910
+                ]
+            },
+	    "base_port": 55900
+        }
+    }
+]
diff --git a/tests/py/inet/dnat.t.payload b/tests/py/inet/dnat.t.payload
index ce1601ab5c9e..9747018ae89c 100644
--- a/tests/py/inet/dnat.t.payload
+++ b/tests/py/inet/dnat.t.payload
@@ -84,3 +84,36 @@ inet
   [ immediate reg 1 0x00005000 ]
   [ nat dnat inet proto_min reg 1 flags 0x2 ]
 
+# ip daddr 10.0.0.1 tcp dport 55900-55910 dnat ip to 192.168.127.1:5900-5910/55900
+inet test-inet prerouting
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x0100000a ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00005cda ]
+  [ cmp lte reg 1 0x000066da ]
+  [ immediate reg 1 0x017fa8c0 ]
+  [ immediate reg 2 0x00000c17 ]
+  [ immediate reg 3 0x00001617 ]
+  [ immediate reg 4 0x00005cda ]
+  [ nat dnat ip addr_min reg 1 proto_min reg 2 proto_max reg 3 proto_base reg 4 flags 0x2 ]
+
+# ip6 daddr 10::1 tcp dport 55900-55910 dnat ip6 to [::c0:a8:7f:1]:5900-5910/55900
+inet test-inet prerouting
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 24 => reg 1 ]
+  [ cmp eq reg 1 0x00001000 0x00000000 0x00000000 0x01000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00005cda ]
+  [ cmp lte reg 1 0x000066da ]
+  [ immediate reg 1 0x00000000 0x00000000 0xa800c000 0x01007f00 ]
+  [ immediate reg 2 0x00000c17 ]
+  [ immediate reg 3 0x00001617 ]
+  [ immediate reg 4 0x00005cda ]
+  [ nat dnat ip6 addr_min reg 1 proto_min reg 2 proto_max reg 3 proto_base reg 4 flags 0x2 ]
diff --git a/tests/py/inet/snat.t b/tests/py/inet/snat.t
index cf23b5cff1bb..1276145918f5 100644
--- a/tests/py/inet/snat.t
+++ b/tests/py/inet/snat.t
@@ -19,3 +19,6 @@ snat ip to dead::beef;fail
 snat ip daddr 1.2.3.4 to dead::beef;fail
 snat ip daddr 1.2.3.4 ip6 to dead::beef;fail
 snat ip6 saddr dead::beef to 1.2.3.4;fail
+
+ip saddr 10.0.0.1 tcp sport 55900-55910 snat ip to 192.168.127.1:5900-5910/55900;ok
+ip6 saddr 10::1 tcp sport 55900-55910 snat ip6 to [::c0:a8:7f:1]:5900-5910/55900;ok
diff --git a/tests/py/inet/snat.t.json b/tests/py/inet/snat.t.json
index 4671625dc06d..03e5823d4258 100644
--- a/tests/py/inet/snat.t.json
+++ b/tests/py/inet/snat.t.json
@@ -129,3 +129,94 @@
     }
 ]
 
+# ip saddr 10.0.0.1 tcp sport 55900-55910 snat ip to 192.168.127.1:5900-5910/55900
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip"
+                }
+            },
+            "op": "==",
+            "right": "10.0.0.1"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    55900,
+                    55910
+                ]
+            }
+        }
+    },
+    {
+        "snat": {
+            "addr": "192.168.127.1",
+            "family": "ip",
+            "port": {
+                "range": [
+                    5900,
+                    5910
+                ]
+            },
+	    "base_port": 55900
+        }
+    }
+]
+
+# ip6 saddr 10::1 tcp sport 55900-55910 snat ip6 to [::c0:a8:7f:1]:5900-5910/55900
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "saddr",
+                    "protocol": "ip6"
+                }
+            },
+            "op": "==",
+            "right": "10::1"
+        }
+    },
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "sport",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "range": [
+                    55900,
+                    55910
+                ]
+            }
+        }
+    },
+    {
+        "snat": {
+            "addr": "::c0:a8:7f:1",
+            "family": "ip6",
+            "port": {
+                "range": [
+                    5900,
+                    5910
+                ]
+            },
+	    "base_port": 55900
+        }
+    }
+]
diff --git a/tests/py/inet/snat.t.payload b/tests/py/inet/snat.t.payload
index 50519c6b6bb6..c2b5e5884b89 100644
--- a/tests/py/inet/snat.t.payload
+++ b/tests/py/inet/snat.t.payload
@@ -40,3 +40,37 @@ inet test-inet postrouting
   [ meta load iifname => reg 1 ]
   [ cmp eq reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
   [ masq flags 0x4 ]
+
+# ip saddr 10.0.0.1 tcp sport 55900-55910 snat ip to 192.168.127.1:5900-5910/55900
+inet test-inet postrouting
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0100000a ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00005cda ]
+  [ cmp lte reg 1 0x000066da ]
+  [ immediate reg 1 0x017fa8c0 ]
+  [ immediate reg 2 0x00000c17 ]
+  [ immediate reg 3 0x00001617 ]
+  [ immediate reg 4 0x00005cda ]
+  [ nat snat ip addr_min reg 1 proto_min reg 2 proto_max reg 3 proto_base reg 4 flags 0x2 ]
+
+# ip6 saddr 10::1 tcp sport 55900-55910 snat ip6 to [::c0:a8:7f:1]:5900-5910/55900
+inet test-inet postrouting
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00001000 0x00000000 0x00000000 0x01000000 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00005cda ]
+  [ cmp lte reg 1 0x000066da ]
+  [ immediate reg 1 0x00000000 0x00000000 0xa800c000 0x01007f00 ]
+  [ immediate reg 2 0x00000c17 ]
+  [ immediate reg 3 0x00001617 ]
+  [ immediate reg 4 0x00005cda ]
+  [ nat snat ip6 addr_min reg 1 proto_min reg 2 proto_max reg 3 proto_base reg 4 flags 0x2 ]
diff --git a/tests/py/ip/masquerade.t b/tests/py/ip/masquerade.t
index 384ac72a15f0..98858149dfed 100644
--- a/tests/py/ip/masquerade.t
+++ b/tests/py/ip/masquerade.t
@@ -18,6 +18,7 @@ udp dport 53 masquerade persistent,fully-random,random;ok;udp dport 53 masquerad
 # using ports
 ip protocol 6 masquerade to :1024;ok
 ip protocol 6 masquerade to :1024-2048;ok
+ip protocol 6 masquerade to :1024-2048/4096;ok
 
 # masquerade is a terminal statement
 tcp dport 22 masquerade counter packets 0 bytes 0 accept;fail
diff --git a/tests/py/ip/masquerade.t.json b/tests/py/ip/masquerade.t.json
index 4a90c7062d47..29d16dd75a02 100644
--- a/tests/py/ip/masquerade.t.json
+++ b/tests/py/ip/masquerade.t.json
@@ -427,3 +427,29 @@
     }
 ]
 
+# ip protocol 6 masquerade to :1024-2048/4096
+[
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
+        "masquerade": {
+            "base_port": 4096,
+            "port": {
+                "range": [
+                    1024,
+                    2048
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index 79e52856a22d..804d35377f56 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -140,3 +140,11 @@ ip test-ip4 postrouting
   [ immediate reg 2 0x00000008 ]
   [ masq proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
+# ip protocol 6 masquerade to :1024-2048/4096
+ip test-ip4 postrouting
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000004 ]
+  [ immediate reg 2 0x00000008 ]
+  [ immediate reg 3 0x00000010 ]
+  [ masq proto_min reg 1 proto_max reg 2 proto_base reg 3 flags 0x2 ]
diff --git a/tests/py/ip/redirect.t b/tests/py/ip/redirect.t
index d2991ce288b0..5321396fc079 100644
--- a/tests/py/ip/redirect.t
+++ b/tests/py/ip/redirect.t
@@ -23,6 +23,7 @@ udp dport 1234 redirect to :4321;ok
 ip daddr 172.16.0.1 udp dport 9998 redirect to :6515;ok
 tcp dport 39128 redirect to :993;ok
 ip protocol tcp redirect to :100-200;ok;ip protocol 6 redirect to :100-200
+ip protocol tcp redirect to :100-200/1000;ok;ip protocol 6 redirect to :100-200/1000
 redirect to :1234;fail
 redirect to :12341111;fail
 
diff --git a/tests/py/ip/redirect.t.json b/tests/py/ip/redirect.t.json
index 3544e7f1b9c5..41a4be95a2ee 100644
--- a/tests/py/ip/redirect.t.json
+++ b/tests/py/ip/redirect.t.json
@@ -635,3 +635,29 @@
     }
 ]
 
+# ip protocol tcp redirect to :100-200/1000
+[
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
+        "redirect": {
+            "base_port": 1000,
+            "port": {
+                "range": [
+                    100,
+                    200
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index 424ad7b4f7ec..d4935c695ff3 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -218,3 +218,11 @@ ip test-ip4 output
   [ lookup reg 1 set __map%d dreg 1 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
+# ip protocol tcp redirect to :100-200/1000
+ip test-ip4 output
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00006400 ]
+  [ immediate reg 2 0x0000c800 ]
+  [ immediate reg 3 0x0000e803 ]
+  [ redir proto_min reg 1 proto_max reg 2 proto_base reg 3 flags 0x2 ]
diff --git a/tests/py/ip6/masquerade.t b/tests/py/ip6/masquerade.t
index 4eb0467c362e..3d87fa1d71bb 100644
--- a/tests/py/ip6/masquerade.t
+++ b/tests/py/ip6/masquerade.t
@@ -18,6 +18,7 @@ udp dport 53 masquerade persistent,fully-random,random;ok;udp dport 53 masquerad
 # using ports
 meta l4proto 6 masquerade to :1024;ok
 meta l4proto 6 masquerade to :1024-2048;ok
+meta l4proto 6 masquerade to :1024-2048/4096;ok
 
 # masquerade is a terminal statement
 tcp dport 22 masquerade counter packets 0 bytes 0 accept;fail
diff --git a/tests/py/ip6/masquerade.t.json b/tests/py/ip6/masquerade.t.json
index 824b44f8a5f5..a56c4372e101 100644
--- a/tests/py/ip6/masquerade.t.json
+++ b/tests/py/ip6/masquerade.t.json
@@ -421,3 +421,28 @@
     }
 ]
 
+# meta l4proto 6 masquerade to :1024-2048/4096
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
+        "masquerade": {
+            "base_port": 4096,
+            "port": {
+                "range": [
+                    1024,
+                    2048
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index 43ae2ae48244..bf64313b6b60 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -140,3 +140,11 @@ ip6 test-ip6 postrouting
   [ immediate reg 2 0x00000008 ]
   [ masq proto_min reg 1 proto_max reg 2 flags 0x2 ]
 
+# meta l4proto 6 masquerade to :1024-2048/4096
+ip6 test-ip6 postrouting
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000004 ]
+  [ immediate reg 2 0x00000008 ]
+  [ immediate reg 3 0x00000010 ]
+  [ masq proto_min reg 1 proto_max reg 2 proto_base reg 3 flags 0x2 ]
diff --git a/tests/py/ip6/redirect.t b/tests/py/ip6/redirect.t
index 778d53f33ce6..9e8747f50185 100644
--- a/tests/py/ip6/redirect.t
+++ b/tests/py/ip6/redirect.t
@@ -23,6 +23,7 @@ udp dport 53 redirect persistent,fully-random,random;ok;udp dport 53 redirect ra
 udp dport 1234 redirect to :1234;ok
 ip6 daddr fe00::cafe udp dport 9998 redirect to :6515;ok
 ip6 nexthdr tcp redirect to :100-200;ok;ip6 nexthdr 6 redirect to :100-200
+ip6 nexthdr tcp redirect to :100-200/1000;ok;ip6 nexthdr 6 redirect to :100-200/1000
 tcp dport 39128 redirect to :993;ok
 redirect to :1234;fail
 redirect to :12341111;fail
diff --git a/tests/py/ip6/redirect.t.json b/tests/py/ip6/redirect.t.json
index 0059c7accc06..4689b0c71c8b 100644
--- a/tests/py/ip6/redirect.t.json
+++ b/tests/py/ip6/redirect.t.json
@@ -599,3 +599,29 @@
     }
 ]
 
+# ip6 nexthdr tcp redirect to :100-200/1000
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "nexthdr",
+                    "protocol": "ip6"
+                }
+            },
+            "op": "==",
+            "right": 6
+        }
+    },
+    {
+        "redirect": {
+            "base_port": 1000,
+            "port": {
+                "range": [
+                    100,
+                    200
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index e9a203161485..4a19df99a3cd 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -202,3 +202,11 @@ ip6 test-ip6 output
   [ lookup reg 1 set __map%d dreg 1 ]
   [ redir proto_min reg 1 flags 0x2 ]
 
+# ip6 nexthdr tcp redirect to :100-200/1000
+ip6 test-ip6 output
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00006400 ]
+  [ immediate reg 2 0x0000c800 ]
+  [ immediate reg 3 0x0000e803 ]
+  [ redir proto_min reg 1 proto_max reg 2 proto_base reg 3 flags 0x2 ]
-- 
2.39.2

