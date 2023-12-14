Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C5B10E
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 06:39:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDmsD-000196-26; Thu, 14 Dec 2023 15:39:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: don't crash if prefix for < byte is requested
Date: Thu, 14 Dec 2023 15:39:27 +0100
Message-ID: <20231214143931.19225-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If prefix is used with a datatype that has less than 8 bits an
assertion is triggered:

src/netlink.c:243: netlink_gen_raw_data: Assertion `len > 0' failed.

This is esoteric, the alternative would be to restrict prefixes
to ipv4/ipv6 addresses.

Simpler fix is to use round_up instead of divide.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c         |  3 ++-
 tests/py/ip/ip.t                |  2 ++
 tests/py/ip/ip.t.json           | 21 +++++++++++++++++++++
 tests/py/ip/ip.t.payload        |  8 ++++++++
 tests/py/ip/ip.t.payload.bridge | 10 ++++++++++
 tests/py/ip/ip.t.payload.inet   | 10 ++++++++++
 tests/py/ip/ip.t.payload.netdev | 10 ++++++++++
 7 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 61828eb9f295..d8b41a088948 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -460,7 +460,8 @@ static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
 	mpz_init(mask);
 	mpz_prefixmask(mask, expr->right->len, expr->right->prefix_len);
 	netlink_gen_raw_data(mask, expr->right->byteorder,
-			     expr->right->len / BITS_PER_BYTE, &nld);
+			     div_round_up(expr->right->len, BITS_PER_BYTE),
+			     &nld);
 	mpz_clear(mask);
 
 	zero.len = nld.len;
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 720d9ae92b60..e6999c29478b 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -133,3 +133,5 @@ ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128
 
 ip saddr 1.2.3.4 ip daddr 3.4.5.6;ok
 ip saddr 1.2.3.4 counter ip daddr 3.4.5.6;ok
+
+ip dscp 1/6;ok;ip dscp & 0x3f == lephb
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 882c94eb4e15..a170e5c15965 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -1809,3 +1809,24 @@
         }
     }
 ]
+
+# ip dscp 1/6
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    63
+                ]
+            },
+            "op": "==",
+            "right": "lephb"
+        }
+    }
+]
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 43605a361a7a..d7ddf7be0c3b 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -556,3 +556,11 @@ ip test-ip4 input
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x06050403 ]
+
+# ip dscp 1/6
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index e506f300c947..53f881d336df 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -726,3 +726,13 @@ bridge test-bridge input
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x06050403 ]
+
+# ip dscp 1/6
+bridge test-bridge input
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index a7fa0faffba3..08674c98e022 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -726,3 +726,13 @@ inet test-inet input
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x06050403 ]
+
+# ip dscp 1/6
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index aebd9d64c8e3..8220b05d11c1 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -726,3 +726,13 @@ netdev test-netdev ingress
   [ counter pkts 0 bytes 0 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
   [ cmp eq reg 1 0x06050403 ]
+
+# ip dscp 1/6
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000001 ]
-- 
2.41.0

