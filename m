Received: from localhost.localdomain (203.red-83-63-38.staticip.rima-tde.net [83.63.38.203])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4783238C3A
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 11:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.63.38.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756812943; cv=none; b=eLkJVfAodraAWjGw6WejWoKT7+sbzThfaqisjW9jf3bIH4FxYXj/IQG0/IDUsyp7sHqL3OcwsqAxkybRQ8BIRP3E65GekkcDlw4uSUHte8FZEaxmEF0gJt1fRFG0sv/7MEwpIotQEX1bnSB6nlE0VLbuHG8rP3gfWqb5LW2HnJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756812943; c=relaxed/simple;
	bh=U9YazKHtzS8pqOfc9l08UwATVuel61LI+501IsQZ8Co=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sPw+i8O+6JY4iVYjki+jVeUcD13GP7zI6FbER+tOeQ2Qs7kP5CtU1+7NYHInwUXNVPjqD0i+2YaPl0xsZbP0sUimnXfGk9RJpqJrkGma/dJoLts5DS6LiQxk34CdpuHcHKtg6Y2JgnzmVoUon1j3LwDpd2I2crFix+M5aqSdHrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=none smtp.mailfrom=localhost.localdomain; arc=none smtp.client-ip=83.63.38.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=localhost.localdomain
Received: by localhost.localdomain (Postfix, from userid 1000)
	id 833C224DA0B7; Tue,  2 Sep 2025 13:35:40 +0200 (CEST)
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft] meta: introduce meta ibrhwdr support
Date: Tue,  2 Sep 2025 13:35:29 +0200
Message-ID: <20250902113529.5456-1-fmancera@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Can be used in bridge prerouting hook to redirect the packet to the
receiving physical device for processing.

table bridge nat {
        chain PREROUTING {
                type filter hook prerouting priority 0; policy accept;
                ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr accept
        }
}

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/meta.c                          |  4 ++++
 tests/py/bridge/meta.t              |  1 +
 tests/py/bridge/pass_up.t           |  6 ++++++
 tests/py/bridge/pass_up.t.json      | 19 +++++++++++++++++++
 tests/py/bridge/pass_up.t.payload   |  4 ++++
 6 files changed, 36 insertions(+)
 create mode 100644 tests/py/bridge/pass_up.t
 create mode 100644 tests/py/bridge/pass_up.t.json
 create mode 100644 tests/py/bridge/pass_up.t.payload

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f57963e8..34a9b117 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -949,6 +949,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
  * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
+ * @NFT_META_BRI_IIFHWADDR: packet input bridge interface ethernet address
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -989,6 +990,7 @@ enum nft_meta_keys {
 	NFT_META_SDIFNAME,
 	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
+	NFT_META_BRI_IIFHWADDR,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 1010209d..9e0d02c6 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -23,6 +23,7 @@
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
 #include <linux/pkt_sched.h>
+#include <linux/if_ether.h>
 #include <linux/if_packet.h>
 #include <time.h>
 
@@ -704,6 +705,9 @@ const struct meta_template meta_templates[] = {
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_BRI_BROUTE]	= META_TEMPLATE("broute",   &integer_type,
 						1    , BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFHWADDR] = META_TEMPLATE("ibrhwdr", &etheraddr_type,
+						 ETH_ALEN * BITS_PER_BYTE,
+						 BYTEORDER_BIG_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/tests/py/bridge/meta.t b/tests/py/bridge/meta.t
index 171aa610..b7744023 100644
--- a/tests/py/bridge/meta.t
+++ b/tests/py/bridge/meta.t
@@ -11,3 +11,4 @@ meta protocol ip udp dport 67;ok
 meta protocol ip6 udp dport 67;ok
 
 meta broute set 1;fail
+meta ibrhwdr;fail
diff --git a/tests/py/bridge/pass_up.t b/tests/py/bridge/pass_up.t
new file mode 100644
index 00000000..97de13f4
--- /dev/null
+++ b/tests/py/bridge/pass_up.t
@@ -0,0 +1,6 @@
+:prerouting;type filter hook prerouting priority 0
+
+*bridge;test-bridge;prerouting
+
+ether daddr set meta ibrhwdr;ok
+meta ibrhwdr set 00:1a:2b:3c:4d:5e;fail
diff --git a/tests/py/bridge/pass_up.t.json b/tests/py/bridge/pass_up.t.json
new file mode 100644
index 00000000..937c0c11
--- /dev/null
+++ b/tests/py/bridge/pass_up.t.json
@@ -0,0 +1,19 @@
+# ether daddr set meta ibrhwdr
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ether"
+                }
+            },
+            "value": {
+                "meta": {
+                    "key": "ibrhwdr"
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/bridge/pass_up.t.payload b/tests/py/bridge/pass_up.t.payload
new file mode 100644
index 00000000..f9826d9c
--- /dev/null
+++ b/tests/py/bridge/pass_up.t.payload
@@ -0,0 +1,4 @@
+# ether daddr set meta ibrhwdr
+bridge test-bridge prerouting
+  [ meta load ibrhwdr => reg 1 ]
+  [ payload write reg 1 => 6b @ link header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
-- 
2.51.0

