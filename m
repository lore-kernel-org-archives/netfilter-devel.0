Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF4EC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 12:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE73B610A0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 12:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhJ0MXT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 08:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241923AbhJ0MXT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 08:23:19 -0400
X-Greylist: delayed 367 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Oct 2021 05:20:52 PDT
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ef0:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4E2C061570
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Oct 2021 05:20:52 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 5142D2801FD33;
        Wed, 27 Oct 2021 14:14:42 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 46E30267E5E; Wed, 27 Oct 2021 14:14:42 +0200 (CEST)
Date:   Wed, 27 Oct 2021 14:14:42 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: Support netdev egress hook
Message-ID: <20211027121442.GA20375@wunner.de>
References: <20211027101715.47905-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20211027101715.47905-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 27, 2021 at 12:17:15PM +0200, Pablo Neira Ayuso wrote:
> Hi Lukas,
> 
> This is the rebase I'm using here locally for testing, let me know if
> you have more pending updates on your side.

I'm using the attached two patches.  The first one moves Python tests
dup.t and fwd.t to the netdev directory, the second one adds nft egress
support.

Phil and Florian noted back in January that the payload dumps should
contain "oiftype" instead of "iiftype".  That's the only remaining
issue not yet addressed in the attached patches:

https://lore.kernel.org/all/20210125133405.GR19605@breakpoint.cc/

The difference between the patch you've posted here and the attached ones
are primarily more extensive docs.  Also, the following two issues are
not present in my version:


> +All packets leaving the system are processed by this hook. It is invoked after
> +layer 3 protocol handlers and after *tc* egress. It can be used for late
                                 ^^^^^
				 before

> --- a/tests/py/inet/ah.t
> +++ b/tests/py/inet/ah.t
> @@ -1,10 +1,12 @@
>  :input;type filter hook input priority 0
>  :ingress;type filter hook ingress device lo priority 0
> +:egress;type filter hook ingress device lo priority 0
                            ^^^^^^^
			    egress

Thanks,

Lukas

--6TrnltStXW4iwmi0
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-tests-py-Move-netdev-specific-tests-to-appropriate-s.patch"

From 22d11d9956b54e151b716ad76b39ae9bb3fa3ebc Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Sun, 24 Oct 2021 09:37:35 +0200
Subject: [PATCH 1/2] tests: py: Move netdev-specific tests to appropriate
 subdirectory

The fwd and dup statements are specific to netdev hooks, so move their
tests to the appropriate subdirectory.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 tests/py/any/dup.t                |  7 ------
 tests/py/any/dup.t.json           | 30 -------------------------
 tests/py/any/dup.t.payload        | 14 ------------
 tests/py/any/fwd.t                |  8 -------
 tests/py/any/fwd.t.json           | 47 ---------------------------------------
 tests/py/any/fwd.t.json.output    | 27 ----------------------
 tests/py/any/fwd.t.payload        | 20 -----------------
 tests/py/netdev/dup.t             |  7 ++++++
 tests/py/netdev/dup.t.json        | 30 +++++++++++++++++++++++++
 tests/py/netdev/dup.t.payload     | 14 ++++++++++++
 tests/py/netdev/fwd.t             |  8 +++++++
 tests/py/netdev/fwd.t.json        | 47 +++++++++++++++++++++++++++++++++++++++
 tests/py/netdev/fwd.t.json.output | 27 ++++++++++++++++++++++
 tests/py/netdev/fwd.t.payload     | 20 +++++++++++++++++
 14 files changed, 153 insertions(+), 153 deletions(-)
 delete mode 100644 tests/py/any/dup.t
 delete mode 100644 tests/py/any/dup.t.json
 delete mode 100644 tests/py/any/dup.t.payload
 delete mode 100644 tests/py/any/fwd.t
 delete mode 100644 tests/py/any/fwd.t.json
 delete mode 100644 tests/py/any/fwd.t.json.output
 delete mode 100644 tests/py/any/fwd.t.payload
 create mode 100644 tests/py/netdev/dup.t
 create mode 100644 tests/py/netdev/dup.t.json
 create mode 100644 tests/py/netdev/dup.t.payload
 create mode 100644 tests/py/netdev/fwd.t
 create mode 100644 tests/py/netdev/fwd.t.json
 create mode 100644 tests/py/netdev/fwd.t.json.output
 create mode 100644 tests/py/netdev/fwd.t.payload

diff --git a/tests/py/any/dup.t b/tests/py/any/dup.t
deleted file mode 100644
index 181b419..0000000
--- a/tests/py/any/dup.t
+++ /dev/null
@@ -1,7 +0,0 @@
-:ingress;type filter hook ingress device lo priority 0
-
-*netdev;test-netdev;ingress
-
-dup to "lo";ok
-dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
-
diff --git a/tests/py/any/dup.t.json b/tests/py/any/dup.t.json
deleted file mode 100644
index dc56f64..0000000
--- a/tests/py/any/dup.t.json
+++ /dev/null
@@ -1,30 +0,0 @@
-# dup to "lo"
-[
-    {
-        "dup": {
-            "addr": "lo"
-        }
-    }
-]
-
-# dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
-[
-    {
-        "dup": {
-            "addr": {
-                "map": {
-                    "key": {
-                        "meta": { "key": "mark" }
-                    },
-                    "data": {
-                        "set": [
-                            [ 1, "lo" ],
-                            [ 2, "lo" ]
-                        ]
-                    }
-                }
-            }
-        }
-    }
-]
-
diff --git a/tests/py/any/dup.t.payload b/tests/py/any/dup.t.payload
deleted file mode 100644
index 51ff782..0000000
--- a/tests/py/any/dup.t.payload
+++ /dev/null
@@ -1,14 +0,0 @@
-# dup to "lo"
-netdev test-netdev ingress 
-  [ immediate reg 1 0x00000001 ]
-  [ dup sreg_dev 1 ]
-
-# dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
-__map%d test-netdev b
-__map%d test-netdev 0
-	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
-netdev test-netdev ingress 
-  [ meta load mark => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 1 ]
-  [ dup sreg_dev 1 ]
-
diff --git a/tests/py/any/fwd.t b/tests/py/any/fwd.t
deleted file mode 100644
index 2e34d55..0000000
--- a/tests/py/any/fwd.t
+++ /dev/null
@@ -1,8 +0,0 @@
-:ingress;type filter hook ingress device lo priority 0
-
-*netdev;test-netdev;ingress
-
-fwd to "lo";ok
-fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
-
-fwd ip to 192.168.2.200 device "lo";ok
diff --git a/tests/py/any/fwd.t.json b/tests/py/any/fwd.t.json
deleted file mode 100644
index 583606c..0000000
--- a/tests/py/any/fwd.t.json
+++ /dev/null
@@ -1,47 +0,0 @@
-# fwd to "lo"
-[
-    {
-        "fwd": {
-            "dev": "lo"
-	}
-    }
-]
-
-# fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
-[
-    {
-        "fwd": {
-            "dev": {
-                "map": {
-                    "key": {
-                        "meta": { "key": "mark" }
-                    },
-                    "data": {
-                        "set": [
-                            [
-                                "0x00000001",
-                                "lo"
-                            ],
-                            [
-                                "0x00000002",
-                                "lo"
-                            ]
-                        ]
-                    }
-                }
-            }
-        }
-    }
-]
-
-# fwd ip to 192.168.2.200 device "lo"
-[
-    {
-        "fwd": {
-            "addr": "192.168.2.200",
-            "dev": "lo",
-            "family": "ip"
-        }
-    }
-]
-
diff --git a/tests/py/any/fwd.t.json.output b/tests/py/any/fwd.t.json.output
deleted file mode 100644
index 8433e49..0000000
--- a/tests/py/any/fwd.t.json.output
+++ /dev/null
@@ -1,27 +0,0 @@
-# fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
-[
-    {
-        "fwd": {
-            "dev": {
-                "map": {
-                    "key": {
-                        "meta": { "key": "mark" }
-                    },
-                    "data": {
-                        "set": [
-                            [
-                                1,
-                                "lo"
-                            ],
-                            [
-                                2,
-                                "lo"
-                            ]
-                        ]
-                    }
-                }
-            }
-        }
-    }
-]
-
diff --git a/tests/py/any/fwd.t.payload b/tests/py/any/fwd.t.payload
deleted file mode 100644
index f03077a..0000000
--- a/tests/py/any/fwd.t.payload
+++ /dev/null
@@ -1,20 +0,0 @@
-# fwd to "lo"
-netdev test-netdev ingress 
-  [ immediate reg 1 0x00000001 ]
-  [ fwd sreg_dev 1 ]
-
-# fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
-__map%d test-netdev b
-__map%d test-netdev 0
-	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
-netdev test-netdev ingress 
-  [ meta load mark => reg 1 ]
-  [ lookup reg 1 set __map%d dreg 1 ]
-  [ fwd sreg_dev 1 ]
-
-# fwd ip to 192.168.2.200 device "lo"
-netdev test-netdev ingress 
-  [ immediate reg 1 0x00000001 ]
-  [ immediate reg 2 0xc802a8c0 ]
-  [ fwd sreg_dev 1 sreg_addr 2 nfproto 2 ]
-
diff --git a/tests/py/netdev/dup.t b/tests/py/netdev/dup.t
new file mode 100644
index 0000000..181b419
--- /dev/null
+++ b/tests/py/netdev/dup.t
@@ -0,0 +1,7 @@
+:ingress;type filter hook ingress device lo priority 0
+
+*netdev;test-netdev;ingress
+
+dup to "lo";ok
+dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
+
diff --git a/tests/py/netdev/dup.t.json b/tests/py/netdev/dup.t.json
new file mode 100644
index 0000000..dc56f64
--- /dev/null
+++ b/tests/py/netdev/dup.t.json
@@ -0,0 +1,30 @@
+# dup to "lo"
+[
+    {
+        "dup": {
+            "addr": "lo"
+        }
+    }
+]
+
+# dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
+[
+    {
+        "dup": {
+            "addr": {
+                "map": {
+                    "key": {
+                        "meta": { "key": "mark" }
+                    },
+                    "data": {
+                        "set": [
+                            [ 1, "lo" ],
+                            [ 2, "lo" ]
+                        ]
+                    }
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/netdev/dup.t.payload b/tests/py/netdev/dup.t.payload
new file mode 100644
index 0000000..51ff782
--- /dev/null
+++ b/tests/py/netdev/dup.t.payload
@@ -0,0 +1,14 @@
+# dup to "lo"
+netdev test-netdev ingress 
+  [ immediate reg 1 0x00000001 ]
+  [ dup sreg_dev 1 ]
+
+# dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
+__map%d test-netdev b
+__map%d test-netdev 0
+	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
+netdev test-netdev ingress 
+  [ meta load mark => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ dup sreg_dev 1 ]
+
diff --git a/tests/py/netdev/fwd.t b/tests/py/netdev/fwd.t
new file mode 100644
index 0000000..2e34d55
--- /dev/null
+++ b/tests/py/netdev/fwd.t
@@ -0,0 +1,8 @@
+:ingress;type filter hook ingress device lo priority 0
+
+*netdev;test-netdev;ingress
+
+fwd to "lo";ok
+fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
+
+fwd ip to 192.168.2.200 device "lo";ok
diff --git a/tests/py/netdev/fwd.t.json b/tests/py/netdev/fwd.t.json
new file mode 100644
index 0000000..583606c
--- /dev/null
+++ b/tests/py/netdev/fwd.t.json
@@ -0,0 +1,47 @@
+# fwd to "lo"
+[
+    {
+        "fwd": {
+            "dev": "lo"
+	}
+    }
+]
+
+# fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
+[
+    {
+        "fwd": {
+            "dev": {
+                "map": {
+                    "key": {
+                        "meta": { "key": "mark" }
+                    },
+                    "data": {
+                        "set": [
+                            [
+                                "0x00000001",
+                                "lo"
+                            ],
+                            [
+                                "0x00000002",
+                                "lo"
+                            ]
+                        ]
+                    }
+                }
+            }
+        }
+    }
+]
+
+# fwd ip to 192.168.2.200 device "lo"
+[
+    {
+        "fwd": {
+            "addr": "192.168.2.200",
+            "dev": "lo",
+            "family": "ip"
+        }
+    }
+]
+
diff --git a/tests/py/netdev/fwd.t.json.output b/tests/py/netdev/fwd.t.json.output
new file mode 100644
index 0000000..8433e49
--- /dev/null
+++ b/tests/py/netdev/fwd.t.json.output
@@ -0,0 +1,27 @@
+# fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
+[
+    {
+        "fwd": {
+            "dev": {
+                "map": {
+                    "key": {
+                        "meta": { "key": "mark" }
+                    },
+                    "data": {
+                        "set": [
+                            [
+                                1,
+                                "lo"
+                            ],
+                            [
+                                2,
+                                "lo"
+                            ]
+                        ]
+                    }
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/netdev/fwd.t.payload b/tests/py/netdev/fwd.t.payload
new file mode 100644
index 0000000..f03077a
--- /dev/null
+++ b/tests/py/netdev/fwd.t.payload
@@ -0,0 +1,20 @@
+# fwd to "lo"
+netdev test-netdev ingress 
+  [ immediate reg 1 0x00000001 ]
+  [ fwd sreg_dev 1 ]
+
+# fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"}
+__map%d test-netdev b
+__map%d test-netdev 0
+	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
+netdev test-netdev ingress 
+  [ meta load mark => reg 1 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ fwd sreg_dev 1 ]
+
+# fwd ip to 192.168.2.200 device "lo"
+netdev test-netdev ingress 
+  [ immediate reg 1 0x00000001 ]
+  [ immediate reg 2 0xc802a8c0 ]
+  [ fwd sreg_dev 1 sreg_addr 2 nfproto 2 ]
+
-- 
2.31.1


--6TrnltStXW4iwmi0
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-src-Support-netdev-egress-hook.patch"

From 1c61def0bfcdb2cda9301e6c93e5272aa6a0a91f Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 11 Mar 2020 13:20:06 +0100
Subject: [PATCH 2/2] src: Support netdev egress hook

Add userspace support for the netdev egress hook which is queued up for
v5.16-rc1, complete with documentation and tests.  Usage is identical to
the ingress hook.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 doc/nft.txt                                       |   34 +-
 doc/statements.txt                                |    6 +-
 include/linux/netfilter.h                         |    1 +
 src/evaluate.c                                    |    2 +
 src/rule.c                                        |    3 +
 tests/py/any/icmpX.t.netdev                       |    3 +-
 tests/py/any/limit.t                              |    3 +-
 tests/py/any/meta.t                               |    3 +-
 tests/py/any/objects.t                            |    3 +-
 tests/py/any/quota.t                              |    3 +-
 tests/py/any/rawpayload.t                         |    3 +-
 tests/py/arp/arp.t                                |    3 +-
 tests/py/bridge/vlan.t                            |    3 +-
 tests/py/inet/ah.t                                |    3 +-
 tests/py/inet/comp.t                              |    3 +-
 tests/py/inet/dccp.t                              |    3 +-
 tests/py/inet/esp.t                               |    3 +-
 tests/py/inet/ether-ip.t                          |    3 +-
 tests/py/inet/ether.t                             |    3 +-
 tests/py/inet/ip.t                                |    3 +-
 tests/py/inet/ip.t.payload.netdev                 |   14 +
 tests/py/inet/ip_tcp.t                            |    3 +-
 tests/py/inet/map.t                               |    3 +-
 tests/py/inet/sctp.t                              |    3 +-
 tests/py/inet/sets.t                              |    3 +-
 tests/py/inet/tcp.t                               |    3 +-
 tests/py/inet/udp.t                               |    3 +-
 tests/py/inet/udplite.t                           |    3 +-
 tests/py/ip/ip.t                                  |    3 +-
 tests/py/ip/ip_tcp.t                              |    2 +
 tests/py/ip/ip_tcp.t.payload.netdev               |   93 +
 tests/py/ip/sets.t                                |    3 +-
 tests/py/ip6/frag.t                               |    2 +
 tests/py/ip6/frag.t.payload.netdev                | 2186 +++++++++++++++++++++
 tests/py/ip6/sets.t                               |    3 +-
 tests/py/ip6/vmap.t                               |    3 +-
 tests/py/netdev/dup.t                             |    3 +-
 tests/py/netdev/fwd.t                             |    3 +-
 tests/shell/testcases/chains/0021prio_0           |    1 +
 tests/shell/testcases/chains/0026prio_netdev_1    |    4 +-
 tests/shell/testcases/chains/dumps/0021prio_0.nft |   20 +
 41 files changed, 2413 insertions(+), 39 deletions(-)
 create mode 100644 tests/py/ip/ip_tcp.t.payload.netdev
 create mode 100644 tests/py/ip6/frag.t.payload.netdev

diff --git a/doc/nft.txt b/doc/nft.txt
index 13fe8b1..9855150 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -193,7 +193,7 @@ packet processing paths, which invoke nftables if rules for these hooks exist.
 *inet*:: Internet (IPv4/IPv6) address family.
 *arp*:: ARP address family, handling IPv4 ARP packets.
 *bridge*:: Bridge address family, handling packets which traverse a bridge device.
-*netdev*:: Netdev address family, handling packets from ingress.
+*netdev*:: Netdev address family, handling packets on ingress and egress.
 
 All nftables objects exist in address family specific namespaces, therefore all
 identifiers include an address family. If an identifier is specified without an
@@ -251,9 +251,9 @@ The list of supported hooks is identical to IPv4/IPv6/Inet address families abov
 
 NETDEV ADDRESS FAMILY
 ~~~~~~~~~~~~~~~~~~~~
-The Netdev address family handles packets from the device ingress path. This
-family allows you to filter packets of any ethertype such as ARP, VLAN 802.1q,
-VLAN 802.1ad (Q-in-Q) as well as IPv4 and IPv6 packets.
+The Netdev address family handles packets from the device ingress and egress
+path. This family allows you to filter packets of any ethertype such as ARP,
+VLAN 802.1q, VLAN 802.1ad (Q-in-Q) as well as IPv4 and IPv6 packets.
 
 .Netdev address family hooks
 [options="header"]
@@ -263,8 +263,27 @@ VLAN 802.1ad (Q-in-Q) as well as IPv4 and IPv6 packets.
 All packets entering the system are processed by this hook. It is invoked after
 the network taps (ie. *tcpdump*), right after *tc* ingress and before layer 3
 protocol handlers, it can be used for early filtering and policing.
+|egress |
+All packets leaving the system are processed by this hook. It is invoked after
+layer 3 protocol handlers and before *tc* egress. It can be used for late
+filtering and policing.
 |=================
 
+Tunneled packets (such as *vxlan*) are processed by netdev family hooks both
+in decapsulated and encapsulated (tunneled) form. So a packet can be filtered
+on the overlay network as well as on the underlying network.
+
+Note that the order of netfilter and *tc* is mirrored on ingress versus egress.
+This ensures symmetry for NAT and other packet mangling.
+
+Ingress packets which are redirected out some other interface are only
+processed by netfilter on egress if they have passed through netfilter ingress
+processing before. Thus, ingress packets which are redirected by *tc* are not
+subjected to netfilter. But they are if they are redirected by *netfilter* on
+ingress. Conceptually, tc and netfilter can be thought of as layers, with
+netfilter layered above tc: If the packet hasn't been passed up from the
+tc layer to the netfilter layer, it's not subjected to netfilter on egress.
+
 RULESET
 -------
 [verse]
@@ -388,9 +407,10 @@ Apart from the special cases illustrated above (e.g. *nat* type not supporting
 *forward* hook or *route* type only supporting *output* hook), there are three
 further quirks worth noticing:
 
-* The netdev family supports merely a single combination, namely *filter* type and
-  *ingress* hook. Base chains in this family also require the *device* parameter
-  to be present since they exist per incoming interface only.
+* The netdev family supports merely two combinations, namely *filter* type with
+  *ingress* hook and *filter* type with *egress* hook. Base chains in this
+  family also require the *device* parameter to be present since they exist per
+  interface only.
 * The arp family supports only the *input* and *output* hooks, both in chains of type
   *filter*.
 * The inet family also supports the *ingress* hook (since Linux kernel 5.10),
diff --git a/doc/statements.txt b/doc/statements.txt
index af98e42..2c919cc 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -657,7 +657,7 @@ string
 ip filter forward dup to 10.2.3.4 device "eth0"
 
 # copy raw frame to another interface
-netdetv ingress dup to "eth0"
+netdev ingress dup to "eth0"
 dup to "eth0"
 
 # combine with map dst addr to gateways
@@ -667,8 +667,8 @@ dup to ip daddr map { 192.168.7.1 : "eth0", 192.168.7.2 : "eth1" }
 FWD STATEMENT
 ~~~~~~~~~~~~~
 The fwd statement is used to redirect a raw packet to another interface. It is
-only available in the netdev family ingress hook. It is similar to the dup
-statement except that no copy is made.
+only available in the netdev family ingress and egress hooks. It is similar to
+the dup statement except that no copy is made.
 
 *fwd to* 'device'
 
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index feb6287..9e07888 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -54,6 +54,7 @@ enum nf_inet_hooks {
 
 enum nf_dev_hooks {
 	NF_NETDEV_INGRESS,
+	NF_NETDEV_EGRESS,
 	NF_NETDEV_NUMHOOKS
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 8ebc756..896adac 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4296,6 +4296,8 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	case NFPROTO_NETDEV:
 		if (!strcmp(hook, "ingress"))
 			return NF_NETDEV_INGRESS;
+		else if (!strcmp(hook, "egress"))
+			return NF_NETDEV_EGRESS;
 		break;
 	default:
 		break;
diff --git a/src/rule.c b/src/rule.c
index 3e59f27..3868741 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -675,6 +675,7 @@ static const char * const chain_hookname_str_array[] = {
 	"postrouting",
 	"output",
 	"ingress",
+	"egress",
 	NULL,
 };
 
@@ -832,6 +833,8 @@ const char *hooknum2str(unsigned int family, unsigned int hooknum)
 		switch (hooknum) {
 		case NF_NETDEV_INGRESS:
 			return "ingress";
+		case NF_NETDEV_EGRESS:
+			return "egress";
 		}
 		break;
 	default:
diff --git a/tests/py/any/icmpX.t.netdev b/tests/py/any/icmpX.t.netdev
index a327ce6..cf40242 100644
--- a/tests/py/any/icmpX.t.netdev
+++ b/tests/py/any/icmpX.t.netdev
@@ -1,6 +1,7 @@
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 ip protocol icmp icmp type echo-request;ok;icmp type echo-request
 icmp type echo-request;ok
diff --git a/tests/py/any/limit.t b/tests/py/any/limit.t
index ef7f931..0110e77 100644
--- a/tests/py/any/limit.t
+++ b/tests/py/any/limit.t
@@ -1,12 +1,13 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 limit rate 400/minute;ok
 limit rate 20/second;ok
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index 125b0a3..fadcd46 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -1,12 +1,13 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
 *arp;test-arp;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 meta length 1000;ok
 meta length 22;ok
diff --git a/tests/py/any/objects.t b/tests/py/any/objects.t
index 89a9545..7b51f91 100644
--- a/tests/py/any/objects.t
+++ b/tests/py/any/objects.t
@@ -1,12 +1,13 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 %cnt1 type counter;ok
 %qt1 type quota 25 mbytes;ok
diff --git a/tests/py/any/quota.t b/tests/py/any/quota.t
index 9a8db11..79dd765 100644
--- a/tests/py/any/quota.t
+++ b/tests/py/any/quota.t
@@ -1,12 +1,13 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;output
 *ip6;test-ip6;output
 *inet;test-inet;output
 *arp;test-arp;output
 *bridge;test-bridge;output
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 quota 1025 bytes;ok
 quota 1 kbytes;ok
diff --git a/tests/py/any/rawpayload.t b/tests/py/any/rawpayload.t
index c3382a9..9687729 100644
--- a/tests/py/any/rawpayload.t
+++ b/tests/py/any/rawpayload.t
@@ -1,8 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 meta l4proto { tcp, udp, sctp} @th,16,16 { 22, 23, 80 };ok;meta l4proto { 6, 17, 132} th dport { 22, 23, 80}
 meta l4proto tcp @th,16,16 { 22, 23, 80};ok;tcp dport { 22, 23, 80}
diff --git a/tests/py/arp/arp.t b/tests/py/arp/arp.t
index 178cf82..222b91c 100644
--- a/tests/py/arp/arp.t
+++ b/tests/py/arp/arp.t
@@ -1,9 +1,10 @@
 # filter chains available are: input, output, forward
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *arp;test-arp;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 arp htype 1;ok
 arp htype != 1;ok
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index fd39d22..0b13be7 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -1,8 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 vlan id 4094;ok
 vlan id 0;ok
diff --git a/tests/py/inet/ah.t b/tests/py/inet/ah.t
index 78c454f..83b6202 100644
--- a/tests/py/inet/ah.t
+++ b/tests/py/inet/ah.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 - ah nexthdr esp;ok
 - ah nexthdr ah;ok
diff --git a/tests/py/inet/comp.t b/tests/py/inet/comp.t
index ec9924f..2ef5382 100644
--- a/tests/py/inet/comp.t
+++ b/tests/py/inet/comp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 # BUG: nft: payload.c:88: payload_expr_pctx_update: Assertion `left->payload.base + 1 <= (__PROTO_BASE_MAX - 1)' failed.
 - comp nexthdr esp;ok;comp nexthdr 50
diff --git a/tests/py/inet/dccp.t b/tests/py/inet/dccp.t
index 2216fa2..90142f5 100644
--- a/tests/py/inet/dccp.t
+++ b/tests/py/inet/dccp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 dccp sport 21-35;ok
 dccp sport != 21-35;ok
diff --git a/tests/py/inet/esp.t b/tests/py/inet/esp.t
index 58e9f88..536260c 100644
--- a/tests/py/inet/esp.t
+++ b/tests/py/inet/esp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 esp spi 100;ok
 esp spi != 100;ok
diff --git a/tests/py/inet/ether-ip.t b/tests/py/inet/ether-ip.t
index 0c8c7f9..759124d 100644
--- a/tests/py/inet/ether-ip.t
+++ b/tests/py/inet/ether-ip.t
@@ -1,8 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 tcp dport 22 iiftype ether ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 ip daddr 1.2.3.4 accept
 tcp dport 22 ip daddr 1.2.3.4 ether saddr 00:0f:54:0c:11:04;ok
diff --git a/tests/py/inet/ether.t b/tests/py/inet/ether.t
index afdf8b8..c4b1ced 100644
--- a/tests/py/inet/ether.t
+++ b/tests/py/inet/ether.t
@@ -1,11 +1,12 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept;ok
diff --git a/tests/py/inet/ip.t b/tests/py/inet/ip.t
index ac5b825..bdb3330 100644
--- a/tests/py/inet/ip.t
+++ b/tests/py/inet/ip.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe };ok
 ip saddr vmap { 10.0.1.0-10.0.1.255 : accept, 10.0.1.1-10.0.2.255 : drop };fail
diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
index 95be919..38ed0ad 100644
--- a/tests/py/inet/ip.t.payload.netdev
+++ b/tests/py/inet/ip.t.payload.netdev
@@ -12,3 +12,17 @@ netdev test-netdev ingress
   [ payload load 6b @ link header + 6 => reg 10 ]
   [ lookup reg 1 set __set%d ]
 
+# meta protocol ip ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 6b @ link header + 6 => reg 10 ]
+  [ lookup reg 1 set __set%d ]
+
diff --git a/tests/py/inet/ip_tcp.t b/tests/py/inet/ip_tcp.t
index f2a28eb..ab76ffa 100644
--- a/tests/py/inet/ip_tcp.t
+++ b/tests/py/inet/ip_tcp.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 # must not remove ip dependency -- ONLY ipv4 packets should be matched
 ip protocol tcp tcp dport 22;ok;ip protocol 6 tcp dport 22
diff --git a/tests/py/inet/map.t b/tests/py/inet/map.t
index e83490a..5a7161b 100644
--- a/tests/py/inet/map.t
+++ b/tests/py/inet/map.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 mark set ip saddr map { 10.2.3.2 : 0x0000002a, 10.2.3.1 : 0x00000017};ok;meta mark set ip saddr map { 10.2.3.1 : 0x00000017, 10.2.3.2 : 0x0000002a}
 mark set ip hdrlength map { 5 : 0x00000017, 4 : 0x00000001};ok;meta mark set ip hdrlength map { 4 : 0x00000001, 5 : 0x00000017}
diff --git a/tests/py/inet/sctp.t b/tests/py/inet/sctp.t
index 57b9e67..016173b 100644
--- a/tests/py/inet/sctp.t
+++ b/tests/py/inet/sctp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 sctp sport 23;ok
 sctp sport != 23;ok
diff --git a/tests/py/inet/sets.t b/tests/py/inet/sets.t
index 1c6f323..5b22e1f 100644
--- a/tests/py/inet/sets.t
+++ b/tests/py/inet/sets.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *inet;test-inet;input
 *bridge;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 !set1 type ipv4_addr timeout 60s;ok
 ?set1 192.168.3.4 timeout 30s, 10.2.1.1;ok
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index aa07c3b..f51ebd3 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 tcp dport set {1, 2, 3};fail
 
diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index c434f2e..7f21c8e 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 udp sport 80 accept;ok
 udp sport != 60 accept;ok
diff --git a/tests/py/inet/udplite.t b/tests/py/inet/udplite.t
index a8fdc8e..6a54709 100644
--- a/tests/py/inet/udplite.t
+++ b/tests/py/inet/udplite.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 udplite sport 80 accept;ok
 udplite sport != 60 accept;ok
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index f4a3667..d5a4d8a 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -1,10 +1,11 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
 *bridge;test-bridge;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 - ip version 2;ok
 
diff --git a/tests/py/ip/ip_tcp.t b/tests/py/ip/ip_tcp.t
index 467da3e..646b0ca 100644
--- a/tests/py/ip/ip_tcp.t
+++ b/tests/py/ip/ip_tcp.t
@@ -1,7 +1,9 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip;input
+*netdev;test-netdev;ingress,egress
 
 # can remove ip dependency -- its redundant in ip family
 ip protocol tcp tcp dport 22;ok;tcp dport 22
diff --git a/tests/py/ip/ip_tcp.t.payload.netdev b/tests/py/ip/ip_tcp.t.payload.netdev
new file mode 100644
index 0000000..74dc119
--- /dev/null
+++ b/tests/py/ip/ip_tcp.t.payload.netdev
@@ -0,0 +1,93 @@
+# ip protocol tcp tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev ingress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ip protocol tcp meta mark set 1 tcp dport 22
+netdev test-netdev egress 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ immediate reg 1 0x00000001 ]
+  [ meta set mark with reg 1 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
diff --git a/tests/py/ip/sets.t b/tests/py/ip/sets.t
index 7dc884f..a224d0f 100644
--- a/tests/py/ip/sets.t
+++ b/tests/py/ip/sets.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip4;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 !w type ipv4_addr;ok
 !x type inet_proto;ok
diff --git a/tests/py/ip6/frag.t b/tests/py/ip6/frag.t
index 945398d..6bbd6ac 100644
--- a/tests/py/ip6/frag.t
+++ b/tests/py/ip6/frag.t
@@ -1,8 +1,10 @@
 :output;type filter hook output priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip6;test-ip6;output
 *inet;test-inet;output
+*netdev;test-netdev;ingress,egress
 
 frag nexthdr tcp;ok;frag nexthdr 6
 frag nexthdr != icmp;ok;frag nexthdr != 1
diff --git a/tests/py/ip6/frag.t.payload.netdev b/tests/py/ip6/frag.t.payload.netdev
new file mode 100644
index 0000000..821d567
--- /dev/null
+++ b/tests/py/ip6/frag.t.payload.netdev
@@ -0,0 +1,2186 @@
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag nexthdr tcp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr tcp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr != icmp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr != icmp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr esp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr esp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr ah
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag nexthdr ah
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag reserved 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag id 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id != 33
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id != 33
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr tcp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr tcp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr != icmp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr != icmp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag nexthdr esp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr esp
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr ah
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag nexthdr ah
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag reserved 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ range neq reg 1 0x00000021 0x0000002d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag id 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id != 33
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id != 33
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ range neq reg 1 0x21000000 0x2d000000 ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag id != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off 22
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000b000 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off != 233
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00004807 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000801 ]
+  [ cmp lte reg 1 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off != 33-45
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ range neq reg 1 0x00000801 0x00006801 ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33, 55, 67, 88}
+__set%d test-netdev 3
+__set%d test-netdev 0
+	element 00000801  : 0 [end]	element 0000b801  : 0 [end]	element 00001802  : 0 [end]	element 0000c002  : 0 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag frag-off != { 33-55}
+__set%d test-netdev 7
+__set%d test-netdev 0
+	element 00000000  : 1 [end]	element 00000801  : 0 [end]	element 0000b901  : 1 [end]
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
+  [ lookup reg 1 set __set%d 0x1 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag reserved2 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000006 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 0
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# frag more-fragments 1
+netdev 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ exthdr load ipv6 1b @ 44 + 3 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000001 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
+
diff --git a/tests/py/ip6/sets.t b/tests/py/ip6/sets.t
index add82eb..3b99d66 100644
--- a/tests/py/ip6/sets.t
+++ b/tests/py/ip6/sets.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 !w type ipv6_addr;ok
 !x type inet_proto;ok
diff --git a/tests/py/ip6/vmap.t b/tests/py/ip6/vmap.t
index 434f5d9..2d54b82 100644
--- a/tests/py/ip6/vmap.t
+++ b/tests/py/ip6/vmap.t
@@ -1,9 +1,10 @@
 :input;type filter hook input priority 0
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
 *ip6;test-ip6;input
 *inet;test-inet;input
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 ip6 saddr vmap { abcd::3 : accept };ok
 ip6 saddr 1234:1234:1234:1234:1234:1234:1234:1234:1234;fail
diff --git a/tests/py/netdev/dup.t b/tests/py/netdev/dup.t
index 181b419..5632802 100644
--- a/tests/py/netdev/dup.t
+++ b/tests/py/netdev/dup.t
@@ -1,6 +1,7 @@
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 dup to "lo";ok
 dup to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
diff --git a/tests/py/netdev/fwd.t b/tests/py/netdev/fwd.t
index 2e34d55..6051560 100644
--- a/tests/py/netdev/fwd.t
+++ b/tests/py/netdev/fwd.t
@@ -1,6 +1,7 @@
 :ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
 
-*netdev;test-netdev;ingress
+*netdev;test-netdev;ingress,egress
 
 fwd to "lo";ok
 fwd to meta mark map { 0x00000001 : "lo", 0x00000002 : "lo"};ok
diff --git a/tests/shell/testcases/chains/0021prio_0 b/tests/shell/testcases/chains/0021prio_0
index e761297..d450dc0 100755
--- a/tests/shell/testcases/chains/0021prio_0
+++ b/tests/shell/testcases/chains/0021prio_0
@@ -69,6 +69,7 @@ done
 family=netdev
 echo "add table $family x"
 gen_chains $family ingress filter lo
+gen_chains $family egress filter lo
 
 family=bridge
 echo "add table $family x"
diff --git a/tests/shell/testcases/chains/0026prio_netdev_1 b/tests/shell/testcases/chains/0026prio_netdev_1
index aa902e9..b6fa3db 100755
--- a/tests/shell/testcases/chains/0026prio_netdev_1
+++ b/tests/shell/testcases/chains/0026prio_netdev_1
@@ -1,7 +1,8 @@
 #!/bin/bash
 
 family=netdev
-	hook=ingress
+	for hook in ingress egress
+	do
 		for prioname in raw mangle dstnat security srcnat
 		do
 			$NFT add table $family x || exit 1
@@ -12,4 +13,5 @@ family=netdev
 				exit 1
 			fi
 		done
+	done
 exit 0
diff --git a/tests/shell/testcases/chains/dumps/0021prio_0.nft b/tests/shell/testcases/chains/dumps/0021prio_0.nft
index ca94d44..4297d24 100644
--- a/tests/shell/testcases/chains/dumps/0021prio_0.nft
+++ b/tests/shell/testcases/chains/dumps/0021prio_0.nft
@@ -1382,6 +1382,26 @@ table netdev x {
 	chain ingressfilterp11 {
 		type filter hook ingress device "lo" priority 11; policy accept;
 	}
+
+	chain egressfilterm11 {
+		type filter hook egress device "lo" priority -11; policy accept;
+	}
+
+	chain egressfilterm10 {
+		type filter hook egress device "lo" priority filter - 10; policy accept;
+	}
+
+	chain egressfilter {
+		type filter hook egress device "lo" priority filter; policy accept;
+	}
+
+	chain egressfilterp10 {
+		type filter hook egress device "lo" priority filter + 10; policy accept;
+	}
+
+	chain egressfilterp11 {
+		type filter hook egress device "lo" priority 11; policy accept;
+	}
 }
 table bridge x {
 	chain preroutingfilterm11 {
-- 
2.31.1


--6TrnltStXW4iwmi0--
