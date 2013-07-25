From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] tests: xml: add realistic XML tests files
Date: Thu, 25 Jul 2013 22:44:40 +0200
Message-ID: <20130725204440.22426.12913.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54348 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753048Ab3GYUox (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:44:53 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id BB03B51EE82
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 20:44:50 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5KzFw9w5we5d for <netfilter-devel@vger.kernel.org>;
	Thu, 25 Jul 2013 22:44:43 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 3618751EDBE
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2013 22:44:42 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch refresh current XML testfiles with some realworld expressions extracted from rules.
The nft instruction itself is added as a comment for future references.

All XMl files are now indented with tabs instead of spaces.

Also, a bunch of new realworld rules with mixed expressions are added.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/xmlfiles/20-rule-bitwise.xml   |   43 +++++-------
 tests/xmlfiles/21-rule-byteorder.xml |   16 ++--
 tests/xmlfiles/22-rule-cmp.xml       |   28 ++++----
 tests/xmlfiles/23-rule-counter.xml   |   13 ++--
 tests/xmlfiles/24-rule-ct.xml        |   13 ++--
 tests/xmlfiles/25-rule-exthdr.xml    |   14 ++--
 tests/xmlfiles/26-rule-immediate.xml |   22 +++---
 tests/xmlfiles/26-rule-limit.xml     |    7 --
 tests/xmlfiles/27-rule-limit.xml     |    7 ++
 tests/xmlfiles/28-rule-log.xml       |   17 +++--
 tests/xmlfiles/29-rule-lookup.xml    |   15 ++--
 tests/xmlfiles/30-rule-match.xml     |    8 +-
 tests/xmlfiles/31-rule-meta.xml      |   13 ++--
 tests/xmlfiles/32-rule-nat6.xml      |   18 +++--
 tests/xmlfiles/34-rule-payload.xml   |   17 +++--
 tests/xmlfiles/35-rule-target.xml    |    8 +-
 tests/xmlfiles/36-rule-real.xml      |   25 +++++++
 tests/xmlfiles/37-rule-real.xml      |   95 ++++++++++++++++++++++++++
 tests/xmlfiles/38-rule-real.xml      |   59 ++++++++++++++++
 tests/xmlfiles/39-rule-real.xml      |  122 ++++++++++++++++++++++++++++++++++
 tests/xmlfiles/40-rule-real.xml      |   20 ++++++
 tests/xmlfiles/41-rule-real.xml      |   30 ++++++++
 tests/xmlfiles/42-rule-real.xml      |   24 +++++++
 tests/xmlfiles/43-rule-real.xml      |   32 +++++++++
 tests/xmlfiles/44-rule-real.xml      |   30 ++++++++
 tests/xmlfiles/45-rule-real.xml      |   40 +++++++++++
 tests/xmlfiles/46-rule-real.xml      |   40 +++++++++++
 tests/xmlfiles/47-rule-real.xml      |   25 +++++++
 tests/xmlfiles/48-rule-real.xml      |   37 ++++++++++
 tests/xmlfiles/49-rule-real.xml      |   37 ++++++++++
 tests/xmlfiles/50-rule-real.xml      |   40 +++++++++++
 tests/xmlfiles/51-rule-real.xml      |   23 ++++++
 tests/xmlfiles/52-rule-real.xml      |   23 ++++++
 tests/xmlfiles/53-rule-real.xml      |   23 ++++++
 tests/xmlfiles/54-rule-real.xml      |   23 ++++++
 tests/xmlfiles/55-rule-real.xml      |   23 ++++++
 tests/xmlfiles/56-rule-real.xml      |   23 ++++++
 tests/xmlfiles/57-rule-real.xml      |   23 ++++++
 tests/xmlfiles/58-rule-real.xml      |   22 ++++++
 tests/xmlfiles/59-rule-real.xml      |   22 ++++++
 tests/xmlfiles/60-rule-real.xml      |   22 ++++++
 tests/xmlfiles/61-rule-real.xml      |   22 ++++++
 tests/xmlfiles/62-rule-real.xml      |   25 +++++++
 tests/xmlfiles/63-rule-real.xml      |   22 ++++++
 tests/xmlfiles/64-rule-real.xml      |   25 +++++++
 tests/xmlfiles/65-rule-real.xml      |   22 ++++++
 tests/xmlfiles/66-rule-real.xml      |   22 ++++++
 tests/xmlfiles/67-rule-real.xml      |   22 ++++++
 tests/xmlfiles/68-rule-real.xml      |   35 ++++++++++
 tests/xmlfiles/69-rule-real.xml      |   15 ++++
 tests/xmlfiles/70-rule-real.xml      |   31 +++++++++
 tests/xmlfiles/71-rule-real.xml      |   31 +++++++++
 tests/xmlfiles/72-rule-real.xml      |   15 ++++
 53 files changed, 1302 insertions(+), 127 deletions(-)
 delete mode 100644 tests/xmlfiles/26-rule-limit.xml
 create mode 100644 tests/xmlfiles/27-rule-limit.xml
 create mode 100644 tests/xmlfiles/36-rule-real.xml
 create mode 100644 tests/xmlfiles/37-rule-real.xml
 create mode 100644 tests/xmlfiles/38-rule-real.xml
 create mode 100644 tests/xmlfiles/39-rule-real.xml
 create mode 100644 tests/xmlfiles/40-rule-real.xml
 create mode 100644 tests/xmlfiles/41-rule-real.xml
 create mode 100644 tests/xmlfiles/42-rule-real.xml
 create mode 100644 tests/xmlfiles/43-rule-real.xml
 create mode 100644 tests/xmlfiles/44-rule-real.xml
 create mode 100644 tests/xmlfiles/45-rule-real.xml
 create mode 100644 tests/xmlfiles/46-rule-real.xml
 create mode 100644 tests/xmlfiles/47-rule-real.xml
 create mode 100644 tests/xmlfiles/48-rule-real.xml
 create mode 100644 tests/xmlfiles/49-rule-real.xml
 create mode 100644 tests/xmlfiles/50-rule-real.xml
 create mode 100644 tests/xmlfiles/51-rule-real.xml
 create mode 100644 tests/xmlfiles/52-rule-real.xml
 create mode 100644 tests/xmlfiles/53-rule-real.xml
 create mode 100644 tests/xmlfiles/54-rule-real.xml
 create mode 100644 tests/xmlfiles/55-rule-real.xml
 create mode 100644 tests/xmlfiles/56-rule-real.xml
 create mode 100644 tests/xmlfiles/57-rule-real.xml
 create mode 100644 tests/xmlfiles/58-rule-real.xml
 create mode 100644 tests/xmlfiles/59-rule-real.xml
 create mode 100644 tests/xmlfiles/60-rule-real.xml
 create mode 100644 tests/xmlfiles/61-rule-real.xml
 create mode 100644 tests/xmlfiles/62-rule-real.xml
 create mode 100644 tests/xmlfiles/63-rule-real.xml
 create mode 100644 tests/xmlfiles/64-rule-real.xml
 create mode 100644 tests/xmlfiles/65-rule-real.xml
 create mode 100644 tests/xmlfiles/66-rule-real.xml
 create mode 100644 tests/xmlfiles/67-rule-real.xml
 create mode 100644 tests/xmlfiles/68-rule-real.xml
 create mode 100644 tests/xmlfiles/69-rule-real.xml
 create mode 100644 tests/xmlfiles/70-rule-real.xml
 create mode 100644 tests/xmlfiles/71-rule-real.xml
 create mode 100644 tests/xmlfiles/72-rule-real.xml

diff --git a/tests/xmlfiles/20-rule-bitwise.xml b/tests/xmlfiles/20-rule-bitwise.xml
index ce2d851..a61f4fb 100644
--- a/tests/xmlfiles/20-rule-bitwise.xml
+++ b/tests/xmlfiles/20-rule-bitwise.xml
@@ -1,26 +1,21 @@
 <rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="bitwise">
-    <sreg>2</sreg>
-    <dreg>2</dreg>
-    <len>16</len>
-    <mask>
-      <data_reg type="value">
-        <len>16</len>
-        <data0>0xffffffff</data0>
-        <data1>0xffffffff</data1>
-        <data2>0xffffffff</data2>
-        <data3>0x000000ff</data3>
-      </data_reg>
-    </mask>
-    <xor>
-      <data_reg type="value">
-        <len>16</len>
-        <data0>0xfaceb00c</data0>
-        <data1>0xc1cac1ca</data1>
-        <data2>0xcafecafe</data2>
-        <data3>0xdeadbeef</data3>
-      </data_reg>
-    </xor>
-  </expr>
+	<rule_flags>0</rule_flags>
+	<expr type="bitwise">
+		<sreg>1</sreg>
+		<dreg>1</dreg>
+		<len>4</len>
+		<mask>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0000000a</data0>
+			</data_reg>
+		</mask>
+		<xor>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</xor>
+	</expr>
 </rule>
+<!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/21-rule-byteorder.xml b/tests/xmlfiles/21-rule-byteorder.xml
index c749e77..ee2fcb2 100644
--- a/tests/xmlfiles/21-rule-byteorder.xml
+++ b/tests/xmlfiles/21-rule-byteorder.xml
@@ -1,10 +1,10 @@
 <rule family="ip" table="test" chain="test" handle="1000" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="byteorder">
-	<sreg>3</sreg>
-	<dreg>4</dreg>
-	<op>hton</op>
-	<len>4</len>
-	<size>4</size>
-  </expr>
+	<rule_flags>0</rule_flags>
+	<expr type="byteorder">
+		<sreg>3</sreg>
+		<dreg>4</dreg>
+		<op>hton</op>
+		<len>4</len>
+		<size>4</size>
+	</expr>
 </rule>
diff --git a/tests/xmlfiles/22-rule-cmp.xml b/tests/xmlfiles/22-rule-cmp.xml
index c135bcd..6730c77 100644
--- a/tests/xmlfiles/22-rule-cmp.xml
+++ b/tests/xmlfiles/22-rule-cmp.xml
@@ -1,13 +1,17 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="cmp">
-    <sreg>1</sreg>
-    <op>eq</op>
-    <cmpdata>
-      <data_reg type="value">
-        <len>4</len>
-        <data0>0x01010101</data0>
-      </data_reg>
-    </cmpdata>
-  </expr>
+<rule family="ip6" table="filter" chain="test" handle="36" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>16</len>
+				<data0>0x00000000</data0>
+				<data1>0x6e6f6200</data1>
+				<data2>0x2e303164</data2>
+				<data3>0x00393331</data3>
+			</data_reg>
+		</cmpdata>
+	</expr>
 </rule>
+<!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/23-rule-counter.xml b/tests/xmlfiles/23-rule-counter.xml
index a288c1d..047bd8d 100644
--- a/tests/xmlfiles/23-rule-counter.xml
+++ b/tests/xmlfiles/23-rule-counter.xml
@@ -1,7 +1,8 @@
-<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="counter">
-    <pkts>123123</pkts>
-    <bytes>321321</bytes>
-  </expr>
+<rule family="ip6" table="filter" chain="test" handle="39" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="counter">
+		<pkts>3</pkts>
+		<bytes>177</bytes>
+	</expr>
 </rule>
+<!-- nft add rule ip6 filter test udp dport 53 counter accept -->
diff --git a/tests/xmlfiles/24-rule-ct.xml b/tests/xmlfiles/24-rule-ct.xml
index 6bcd149..01dd68a 100644
--- a/tests/xmlfiles/24-rule-ct.xml
+++ b/tests/xmlfiles/24-rule-ct.xml
@@ -1,8 +1,9 @@
 <rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="ct">
-    <dreg>4</dreg>
-    <dir>1</dir>
-    <key>state</key>
-  </expr>
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>state</key>
+		<dir>0</dir>
+	</expr>
 </rule>
+<!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/25-rule-exthdr.xml b/tests/xmlfiles/25-rule-exthdr.xml
index 48abd57..fbba3cc 100644
--- a/tests/xmlfiles/25-rule-exthdr.xml
+++ b/tests/xmlfiles/25-rule-exthdr.xml
@@ -1,9 +1,9 @@
 <rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="exthdr">
-    <dreg>1</dreg>
-    <exthdr_type>mh</exthdr_type>
-    <offset>2</offset>
-    <len>16</len>
-  </expr>
+	<rule_flags>0</rule_flags>
+	<expr type="exthdr">
+		<dreg>1</dreg>
+		<exthdr_type>mh</exthdr_type>
+		<offset>2</offset>
+		<len>16</len>
+	</expr>
 </rule>
diff --git a/tests/xmlfiles/26-rule-immediate.xml b/tests/xmlfiles/26-rule-immediate.xml
index d58a13d..665078a 100644
--- a/tests/xmlfiles/26-rule-immediate.xml
+++ b/tests/xmlfiles/26-rule-immediate.xml
@@ -1,12 +1,12 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="immediate">
-    <dreg>1</dreg>
-    <immdata>
-      <data_reg type="value">
-        <len>4</len>
-	<data0>0xaabbccdd</data0>
-      </data_reg>
-    </immdata>
-  </expr>
+<rule family="ip" table="filter" chain="input" handle="32" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="immediate">
+		<dreg>0</dreg>
+		<immediatedata>
+			<data_reg type="verdict">
+				<verdict>accept</verdict>
+			</data_reg>
+		</immediatedata>
+	</expr>
 </rule>
+<!-- nft add rule filter input ct state new,established accept -->
diff --git a/tests/xmlfiles/26-rule-limit.xml b/tests/xmlfiles/26-rule-limit.xml
deleted file mode 100644
index 92a2bd9..0000000
--- a/tests/xmlfiles/26-rule-limit.xml
+++ /dev/null
@@ -1,7 +0,0 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="limit">
-    <rate>123123</rate>
-    <depth>321321</depth>
-  </expr>
-</rule>
diff --git a/tests/xmlfiles/27-rule-limit.xml b/tests/xmlfiles/27-rule-limit.xml
new file mode 100644
index 0000000..92a2bd9
--- /dev/null
+++ b/tests/xmlfiles/27-rule-limit.xml
@@ -0,0 +1,7 @@
+<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
+  <rule_flags>0</rule_flags>
+  <expr type="limit">
+    <rate>123123</rate>
+    <depth>321321</depth>
+  </expr>
+</rule>
diff --git a/tests/xmlfiles/28-rule-log.xml b/tests/xmlfiles/28-rule-log.xml
index e33ff25..a8e4a42 100644
--- a/tests/xmlfiles/28-rule-log.xml
+++ b/tests/xmlfiles/28-rule-log.xml
@@ -1,9 +1,10 @@
-<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="log">
-    <group>10</group>
-    <snaplen>4000000</snaplen>
-    <qthreshold>1222222</qthreshold>
-    <prefix>prefixtest</prefix>
-  </expr>
+<rule family="ip6" table="filter" chain="test" handle="96" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="log">
+		<prefix>test_chain</prefix>
+		<group>1</group>
+		<snaplen>0</snaplen>
+		<qthreshold>0</qthreshold>
+	</expr>
 </rule>
+<!-- nft add rule ip6 filter test log prefix test_chain group 1 -->
diff --git a/tests/xmlfiles/29-rule-lookup.xml b/tests/xmlfiles/29-rule-lookup.xml
index f67ecb9..7099d35 100644
--- a/tests/xmlfiles/29-rule-lookup.xml
+++ b/tests/xmlfiles/29-rule-lookup.xml
@@ -1,8 +1,9 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="lookup">
-    <sreg>2</sreg>
-    <dreg>1</dreg>
-    <set>set_name_test</set>
-  </expr>
+<rule family="ip6" table="filter" chain="test" handle="37" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="lookup">
+		<set>set0</set>
+		<sreg>1</sreg>
+		<dreg>0</dreg>
+	</expr>
 </rule>
+<!-- nft add rule ip6 filter test ip6 saddr { ::2 , ::3 } drop -->
diff --git a/tests/xmlfiles/30-rule-match.xml b/tests/xmlfiles/30-rule-match.xml
index 1738aa1..5a88ee6 100644
--- a/tests/xmlfiles/30-rule-match.xml
+++ b/tests/xmlfiles/30-rule-match.xml
@@ -1,6 +1,6 @@
 <rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="match">
-    <name>state</name>
-  </expr>
+	<rule_flags>0</rule_flags>
+	<expr type="match">
+		<name>state</name>
+	</expr>
 </rule>
diff --git a/tests/xmlfiles/31-rule-meta.xml b/tests/xmlfiles/31-rule-meta.xml
index 7e2f57a..673abc9 100644
--- a/tests/xmlfiles/31-rule-meta.xml
+++ b/tests/xmlfiles/31-rule-meta.xml
@@ -1,7 +1,8 @@
-<rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="meta">
-    <dreg>1</dreg>
-    <key>oifname</key>
-  </expr>
+<rule family="ip6" table="filter" chain="test" handle="36" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>iifname</key>
+	</expr>
 </rule>
+<!-- nft add rule ip6 filter test meta iifname bond10.139 accept -->
diff --git a/tests/xmlfiles/32-rule-nat6.xml b/tests/xmlfiles/32-rule-nat6.xml
index e84bf1c..4cc6571 100644
--- a/tests/xmlfiles/32-rule-nat6.xml
+++ b/tests/xmlfiles/32-rule-nat6.xml
@@ -1,11 +1,11 @@
 <rule family="ip6" table="nat" chain="OUTPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="nat">
-    <family>ip6</family>
-    <nat_type>snat</nat_type>
-    <sreg_addr_min>1</sreg_addr_min>
-    <sreg_addr_max>2</sreg_addr_max>
-    <sreg_proto_min>3</sreg_proto_min>
-    <sreg_proto_max>4</sreg_proto_max>
-  </expr>
+	<rule_flags>0</rule_flags>
+	<expr type="nat">
+		<family>ip6</family>
+		<nat_type>snat</nat_type>
+		<sreg_addr_min>1</sreg_addr_min>
+		<sreg_addr_max>2</sreg_addr_max>
+		<sreg_proto_min>3</sreg_proto_min>
+		<sreg_proto_max>4</sreg_proto_max>
+	</expr>
 </rule>
diff --git a/tests/xmlfiles/34-rule-payload.xml b/tests/xmlfiles/34-rule-payload.xml
index a7846d6..d3e466f 100644
--- a/tests/xmlfiles/34-rule-payload.xml
+++ b/tests/xmlfiles/34-rule-payload.xml
@@ -1,9 +1,10 @@
-<rule family="ip6" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="payload">
-    <dreg>1</dreg>
-    <base>transport</base>
-    <offset>12</offset>
-    <len>4</len>
-  </expr>
+<rule family="ip6" table="filter" chain="test" handle="34" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
 </rule>
+<!-- nft add rule ip6 filter test tcp dport 22 accept -->
diff --git a/tests/xmlfiles/35-rule-target.xml b/tests/xmlfiles/35-rule-target.xml
index 2a4f5e9..86f6d43 100644
--- a/tests/xmlfiles/35-rule-target.xml
+++ b/tests/xmlfiles/35-rule-target.xml
@@ -1,6 +1,6 @@
 <rule family="ip" table="filter" chain="INPUT" handle="100" version="0">
-  <rule_flags>0</rule_flags>
-  <expr type="target">
-    <name>LOG</name>
-  </expr>
+	<rule_flags>0</rule_flags>
+	<expr type="target">
+		<name>LOG</name>
+	</expr>
 </rule>
diff --git a/tests/xmlfiles/36-rule-real.xml b/tests/xmlfiles/36-rule-real.xml
new file mode 100644
index 0000000..dd70252
--- /dev/null
+++ b/tests/xmlfiles/36-rule-real.xml
@@ -0,0 +1,25 @@
+<rule family="ip" table="filter" chain="output" handle="22" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>12</offset>
+		<len>8</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>8</len>
+				<data0>0x0100a8c0</data0>
+				<data1>0x6400a8c0</data1>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter INPUT ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/37-rule-real.xml b/tests/xmlfiles/37-rule-real.xml
new file mode 100644
index 0000000..5dfdcfd
--- /dev/null
+++ b/tests/xmlfiles/37-rule-real.xml
@@ -0,0 +1,95 @@
+<rule family="ip" table="filter" chain="INPUT" handle="25" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>iifname</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>16</len>
+				<data0>0x00000000</data0>
+				<data1>0x00000000</data1>
+				<data2>0x65000000</data2>
+				<data3>0x00306874</data3>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>2</len>
+				<data0>0x00001600</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>state</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="bitwise">
+		<sreg>1</sreg>
+		<dreg>1</dreg>
+		<len>4</len>
+		<mask>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0000000a</data0>
+			</data_reg>
+		</mask>
+		<xor>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</xor>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>neq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+	<expr type="log">
+		<prefix>testprefix</prefix>
+		<group>1</group>
+		<snaplen>0</snaplen>
+		<qthreshold>0</qthreshold>
+	</expr>
+</rule>
+<!-- nft add rule filter INPUT meta iifname "eth0" tcp dport 22 ct state new,established counter log prefix testprefix group 1 -->
diff --git a/tests/xmlfiles/38-rule-real.xml b/tests/xmlfiles/38-rule-real.xml
new file mode 100644
index 0000000..423ef6d
--- /dev/null
+++ b/tests/xmlfiles/38-rule-real.xml
@@ -0,0 +1,59 @@
+<rule family="ip" table="filter" chain="INPUT" handle="30" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="lookup">
+		<set>set3</set>
+		<sreg>1</sreg>
+		<dreg>0</dreg>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>2</len>
+				<data0>0x0000bb01</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+	<expr type="immediate">
+		<dreg>0</dreg>
+		<immediatedata>
+			<data_reg type="verdict">
+				<verdict>accept</verdict>
+			</data_reg>
+		</immediatedata>
+	</expr>
+</rule>
+<!-- nft add rule ip filter INPUT ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/39-rule-real.xml b/tests/xmlfiles/39-rule-real.xml
new file mode 100644
index 0000000..249160e
--- /dev/null
+++ b/tests/xmlfiles/39-rule-real.xml
@@ -0,0 +1,122 @@
+<rule family="ip6" table="filter" chain="test" handle="31" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>iifname</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>16</len>
+				<data0>0x00000000</data0>
+				<data1>0x00000000</data1>
+				<data2>0x6f620000</data2>
+				<data3>0x0030646e</data3>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>oifname</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>16</len>
+				<data0>0x00000000</data0>
+				<data1>0x62000000</data1>
+				<data2>0x31646e6f</data2>
+				<data3>0x0037322e</data3>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>8</offset>
+		<len>16</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>16</len>
+				<data0>0xc09a002a</data0>
+				<data1>0x2700cac1</data1>
+				<data2>0x00000000</data2>
+				<data3>0x50010000</data3>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>6</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000011</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>2</len>
+				<data0>0x00003500</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>status</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000001</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+	<expr type="log">
+		<prefix>dns_drop</prefix>
+		<group>2</group>
+		<snaplen>0</snaplen>
+		<qthreshold>0</qthreshold>
+	</expr>
+	<expr type="immediate">
+		<dreg>0</dreg>
+		<immediatedata>
+			<data_reg type="verdict">
+				<verdict>drop</verdict>
+			</data_reg>
+		</immediatedata>
+	</expr>
+</rule>
+<!-- nft add rule ip6 filter test meta iifname "bond0" meta oifname "bond1.27" ip6 saddr 2a00:9ac0:c1ca:27::150 udp dport 53 ct status expected counter log prefix dns_drop group 2 drop -->
diff --git a/tests/xmlfiles/40-rule-real.xml b/tests/xmlfiles/40-rule-real.xml
new file mode 100644
index 0000000..981715d
--- /dev/null
+++ b/tests/xmlfiles/40-rule-real.xml
@@ -0,0 +1,20 @@
+<rule family="ip" table="filter" chain="output" handle="2" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0100a8c0</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+</rule>
+<!-- nft add rule filter output ip daddr 192.168.0.1 -->
diff --git a/tests/xmlfiles/41-rule-real.xml b/tests/xmlfiles/41-rule-real.xml
new file mode 100644
index 0000000..1a80e42
--- /dev/null
+++ b/tests/xmlfiles/41-rule-real.xml
@@ -0,0 +1,30 @@
+<rule family="ip" table="filter" chain="output" handle="3" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>gte</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0100a8c0</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>lte</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0xfa00a8c0</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+</rule>
+<!-- nft add rule filter output ip daddr 192.168.0.1-192.168.0.250 -->
diff --git a/tests/xmlfiles/42-rule-real.xml b/tests/xmlfiles/42-rule-real.xml
new file mode 100644
index 0000000..74eb226
--- /dev/null
+++ b/tests/xmlfiles/42-rule-real.xml
@@ -0,0 +1,24 @@
+<rule family="ip" table="filter" chain="output" handle="4" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0100a8c0</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ip daddr 192.168.0.1 counter -->
diff --git a/tests/xmlfiles/43-rule-real.xml b/tests/xmlfiles/43-rule-real.xml
new file mode 100644
index 0000000..7c24e26
--- /dev/null
+++ b/tests/xmlfiles/43-rule-real.xml
@@ -0,0 +1,32 @@
+<rule family="ip" table="filter" chain="output" handle="5" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0100a8c0</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+	<expr type="immediate">
+		<dreg>0</dreg>
+		<immediatedata>
+			<data_reg type="verdict">
+				<verdict>drop</verdict>
+			</data_reg>
+		</immediatedata>
+	</expr>
+</rule>
+<!-- nft add rule filter output ip daddr 192.168.0.1 counter drop -->
diff --git a/tests/xmlfiles/44-rule-real.xml b/tests/xmlfiles/44-rule-real.xml
new file mode 100644
index 0000000..36cba92
--- /dev/null
+++ b/tests/xmlfiles/44-rule-real.xml
@@ -0,0 +1,30 @@
+<rule family="ip" table="filter" chain="output" handle="6" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0100a8c0</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+	<expr type="log">
+		<prefix>(null)</prefix>
+		<group>0</group>
+		<snaplen>0</snaplen>
+		<qthreshold>0</qthreshold>
+	</expr>
+</rule>
+<!-- nft add rule filter output ip daddr 192.168.0.1 counter log -->
diff --git a/tests/xmlfiles/45-rule-real.xml b/tests/xmlfiles/45-rule-real.xml
new file mode 100644
index 0000000..ff36c26
--- /dev/null
+++ b/tests/xmlfiles/45-rule-real.xml
@@ -0,0 +1,40 @@
+<rule family="ip" table="filter" chain="output" handle="7" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>2</len>
+				<data0>0x00001600</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output tcp dport 22 counter -->
diff --git a/tests/xmlfiles/46-rule-real.xml b/tests/xmlfiles/46-rule-real.xml
new file mode 100644
index 0000000..9c9d796
--- /dev/null
+++ b/tests/xmlfiles/46-rule-real.xml
@@ -0,0 +1,40 @@
+<rule family="ip" table="filter" chain="output" handle="8" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>0</offset>
+		<len>4</len>
+		<base>transport</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x16000004</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output tcp sport 1024 tcp dport 22 counter -->
diff --git a/tests/xmlfiles/47-rule-real.xml b/tests/xmlfiles/47-rule-real.xml
new file mode 100644
index 0000000..a7fcdf4
--- /dev/null
+++ b/tests/xmlfiles/47-rule-real.xml
@@ -0,0 +1,25 @@
+<rule family="ip" table="filter" chain="output" handle="9" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>12</offset>
+		<len>8</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>8</len>
+				<data0>0x0100a8c0</data0>
+				<data1>0x6400a8c0</data1>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ip saddr 192.168.0.1 ip daddr 192.168.0.100 counter -->
diff --git a/tests/xmlfiles/48-rule-real.xml b/tests/xmlfiles/48-rule-real.xml
new file mode 100644
index 0000000..8dbf189
--- /dev/null
+++ b/tests/xmlfiles/48-rule-real.xml
@@ -0,0 +1,37 @@
+<rule family="ip" table="filter" chain="output" handle="10" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>0</offset>
+		<len>8</len>
+		<base>transport</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>8</len>
+				<data0>0x16000004</data0>
+				<data1>0x00000000</data1>
+			</data_reg>
+		</cmpdata>
+	</expr>
+</rule>
+<!-- nft add rule filter output tcp sequence 0 tcp sport 1024 tcp dport 22 -->
diff --git a/tests/xmlfiles/49-rule-real.xml b/tests/xmlfiles/49-rule-real.xml
new file mode 100644
index 0000000..fefa727
--- /dev/null
+++ b/tests/xmlfiles/49-rule-real.xml
@@ -0,0 +1,37 @@
+<rule family="ip" table="filter" chain="output" handle="11" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>0</offset>
+		<len>8</len>
+		<base>transport</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>8</len>
+				<data0>0x16000004</data0>
+				<data1>0x00000000</data1>
+			</data_reg>
+		</cmpdata>
+	</expr>
+</rule>
+<!-- nft add rule filter output tcp sport 1024 tcp dport 22 tcp sequence 0 -->
diff --git a/tests/xmlfiles/50-rule-real.xml b/tests/xmlfiles/50-rule-real.xml
new file mode 100644
index 0000000..814cde2
--- /dev/null
+++ b/tests/xmlfiles/50-rule-real.xml
@@ -0,0 +1,40 @@
+<rule family="ip" table="filter" chain="output" handle="12" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>state</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="bitwise">
+		<sreg>1</sreg>
+		<dreg>1</dreg>
+		<len>4</len>
+		<mask>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0000000a</data0>
+			</data_reg>
+		</mask>
+		<xor>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</xor>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>neq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>55</pkts>
+		<bytes>11407</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ct state new,established counter -->
diff --git a/tests/xmlfiles/51-rule-real.xml b/tests/xmlfiles/51-rule-real.xml
new file mode 100644
index 0000000..0b0c737
--- /dev/null
+++ b/tests/xmlfiles/51-rule-real.xml
@@ -0,0 +1,23 @@
+<rule family="ip" table="filter" chain="output" handle="13" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>direction</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>5</pkts>
+		<bytes>160</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ct direction original counter -->
diff --git a/tests/xmlfiles/52-rule-real.xml b/tests/xmlfiles/52-rule-real.xml
new file mode 100644
index 0000000..7e13a38
--- /dev/null
+++ b/tests/xmlfiles/52-rule-real.xml
@@ -0,0 +1,23 @@
+<rule family="ip" table="filter" chain="output" handle="14" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>direction</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000001</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>50</pkts>
+		<bytes>11247</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ct direction reply counter -->
diff --git a/tests/xmlfiles/53-rule-real.xml b/tests/xmlfiles/53-rule-real.xml
new file mode 100644
index 0000000..78db321
--- /dev/null
+++ b/tests/xmlfiles/53-rule-real.xml
@@ -0,0 +1,23 @@
+<rule family="ip" table="filter" chain="output" handle="15" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>status</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000001</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ct status expected counter -->
diff --git a/tests/xmlfiles/54-rule-real.xml b/tests/xmlfiles/54-rule-real.xml
new file mode 100644
index 0000000..73fec98
--- /dev/null
+++ b/tests/xmlfiles/54-rule-real.xml
@@ -0,0 +1,23 @@
+<rule family="ip" table="filter" chain="output" handle="16" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>mark</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000064</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft rule add filter output ct mark 100 counter -->
diff --git a/tests/xmlfiles/55-rule-real.xml b/tests/xmlfiles/55-rule-real.xml
new file mode 100644
index 0000000..728fb69
--- /dev/null
+++ b/tests/xmlfiles/55-rule-real.xml
@@ -0,0 +1,23 @@
+<rule family="ip" table="filter" chain="output" handle="17" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>secmark</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>55</pkts>
+		<bytes>11407</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ct secmark 0 counter -->
diff --git a/tests/xmlfiles/56-rule-real.xml b/tests/xmlfiles/56-rule-real.xml
new file mode 100644
index 0000000..a0ab9bb
--- /dev/null
+++ b/tests/xmlfiles/56-rule-real.xml
@@ -0,0 +1,23 @@
+<rule family="ip" table="filter" chain="output" handle="18" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>expiration</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x0000001e</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ct expiration 30 counter -->
diff --git a/tests/xmlfiles/57-rule-real.xml b/tests/xmlfiles/57-rule-real.xml
new file mode 100644
index 0000000..cb6de17
--- /dev/null
+++ b/tests/xmlfiles/57-rule-real.xml
@@ -0,0 +1,23 @@
+<rule family="ip" table="filter" chain="output" handle="19" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="ct">
+		<dreg>1</dreg>
+		<key>helper</key>
+		<dir>0</dir>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00707466</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output ct helper "ftp" counter -->
diff --git a/tests/xmlfiles/58-rule-real.xml b/tests/xmlfiles/58-rule-real.xml
new file mode 100644
index 0000000..0a09cf0
--- /dev/null
+++ b/tests/xmlfiles/58-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="20" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>len</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x000003e8</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta length 1000 counter -->
diff --git a/tests/xmlfiles/59-rule-real.xml b/tests/xmlfiles/59-rule-real.xml
new file mode 100644
index 0000000..ce597fc
--- /dev/null
+++ b/tests/xmlfiles/59-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="21" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>protocol</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>2</len>
+				<data0>0x00000008</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>55</pkts>
+		<bytes>11407</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta protocol 0x0800 counter -->
diff --git a/tests/xmlfiles/60-rule-real.xml b/tests/xmlfiles/60-rule-real.xml
new file mode 100644
index 0000000..95ef299
--- /dev/null
+++ b/tests/xmlfiles/60-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="22" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>mark</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>55</pkts>
+		<bytes>11407</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta mark 0 counter -->
diff --git a/tests/xmlfiles/61-rule-real.xml b/tests/xmlfiles/61-rule-real.xml
new file mode 100644
index 0000000..a7edb58
--- /dev/null
+++ b/tests/xmlfiles/61-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="23" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>iif</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000001</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta iif lo counter -->
diff --git a/tests/xmlfiles/62-rule-real.xml b/tests/xmlfiles/62-rule-real.xml
new file mode 100644
index 0000000..a4744a2
--- /dev/null
+++ b/tests/xmlfiles/62-rule-real.xml
@@ -0,0 +1,25 @@
+<rule family="ip" table="filter" chain="output" handle="24" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>iifname</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>16</len>
+				<data0>0x00000000</data0>
+				<data1>0x00000000</data1>
+				<data2>0x65000000</data2>
+				<data3>0x00306874</data3>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta iifname "eth0" counter -->
diff --git a/tests/xmlfiles/63-rule-real.xml b/tests/xmlfiles/63-rule-real.xml
new file mode 100644
index 0000000..ef53bb2
--- /dev/null
+++ b/tests/xmlfiles/63-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="25" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>oif</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000001</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta oif lo counter -->
diff --git a/tests/xmlfiles/64-rule-real.xml b/tests/xmlfiles/64-rule-real.xml
new file mode 100644
index 0000000..e77e646
--- /dev/null
+++ b/tests/xmlfiles/64-rule-real.xml
@@ -0,0 +1,25 @@
+<rule family="ip" table="filter" chain="output" handle="26" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>oifname</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>16</len>
+				<data0>0x00000000</data0>
+				<data1>0x00000000</data1>
+				<data2>0x65000000</data2>
+				<data3>0x00306874</data3>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta oifname "eth0" counter -->
diff --git a/tests/xmlfiles/65-rule-real.xml b/tests/xmlfiles/65-rule-real.xml
new file mode 100644
index 0000000..4982350
--- /dev/null
+++ b/tests/xmlfiles/65-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="27" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>skuid</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x000003e8</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta skuid 1000 counter -->
diff --git a/tests/xmlfiles/66-rule-real.xml b/tests/xmlfiles/66-rule-real.xml
new file mode 100644
index 0000000..12ecdcf
--- /dev/null
+++ b/tests/xmlfiles/66-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="28" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>skgid</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x000003e8</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta skgid 1000 counter -->
diff --git a/tests/xmlfiles/67-rule-real.xml b/tests/xmlfiles/67-rule-real.xml
new file mode 100644
index 0000000..71922a9
--- /dev/null
+++ b/tests/xmlfiles/67-rule-real.xml
@@ -0,0 +1,22 @@
+<rule family="ip" table="filter" chain="output" handle="29" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="meta">
+		<dreg>1</dreg>
+		<key>secmark</key>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>4</len>
+				<data0>0x00000000</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="counter">
+		<pkts>55</pkts>
+		<bytes>11407</bytes>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output meta secmark 0 counter -->
diff --git a/tests/xmlfiles/68-rule-real.xml b/tests/xmlfiles/68-rule-real.xml
new file mode 100644
index 0000000..119c637
--- /dev/null
+++ b/tests/xmlfiles/68-rule-real.xml
@@ -0,0 +1,35 @@
+<rule family="ip" table="filter" chain="output" handle="32" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
+	<expr type="lookup">
+		<set>set0</set>
+		<sreg>1</sreg>
+		<dreg>0</dreg>
+	</expr>
+	<expr type="counter">
+		<pkts>0</pkts>
+		<bytes>0</bytes>
+	</expr>
+</rule>
+<!-- nft add rule filter output tcp dport { 22, 23 } counter -->
diff --git a/tests/xmlfiles/69-rule-real.xml b/tests/xmlfiles/69-rule-real.xml
new file mode 100644
index 0000000..9225bf9
--- /dev/null
+++ b/tests/xmlfiles/69-rule-real.xml
@@ -0,0 +1,15 @@
+<rule family="ip" table="filter" chain="output" handle="33" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="lookup">
+		<set>set1</set>
+		<sreg>1</sreg>
+		<dreg>0</dreg>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } -->
diff --git a/tests/xmlfiles/70-rule-real.xml b/tests/xmlfiles/70-rule-real.xml
new file mode 100644
index 0000000..48b1d30
--- /dev/null
+++ b/tests/xmlfiles/70-rule-real.xml
@@ -0,0 +1,31 @@
+<rule family="ip" table="filter" chain="output" handle="34" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
+	<expr type="lookup">
+		<set>map0</set>
+		<sreg>1</sreg>
+		<dreg>0</dreg>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output tcp dport vmap { 22 => jump chain1, 23 => jump chain2, } -->
diff --git a/tests/xmlfiles/71-rule-real.xml b/tests/xmlfiles/71-rule-real.xml
new file mode 100644
index 0000000..6bed65b
--- /dev/null
+++ b/tests/xmlfiles/71-rule-real.xml
@@ -0,0 +1,31 @@
+<rule family="ip" table="filter" chain="output" handle="35" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>9</offset>
+		<len>1</len>
+		<base>network</base>
+	</expr>
+	<expr type="cmp">
+		<sreg>1</sreg>
+		<op>eq</op>
+		<cmpdata>
+			<data_reg type="value">
+				<len>1</len>
+				<data0>0x00000006</data0>
+			</data_reg>
+		</cmpdata>
+	</expr>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>2</offset>
+		<len>2</len>
+		<base>transport</base>
+	</expr>
+	<expr type="lookup">
+		<set>map1</set>
+		<sreg>1</sreg>
+		<dreg>0</dreg>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output tcp dport vmap { 22 => accept, 23 => drop, } -->
diff --git a/tests/xmlfiles/72-rule-real.xml b/tests/xmlfiles/72-rule-real.xml
new file mode 100644
index 0000000..e14a888
--- /dev/null
+++ b/tests/xmlfiles/72-rule-real.xml
@@ -0,0 +1,15 @@
+<rule family="ip" table="filter" chain="output" handle="36" version="0">
+	<rule_flags>0</rule_flags>
+	<expr type="payload">
+		<dreg>1</dreg>
+		<offset>16</offset>
+		<len>4</len>
+		<base>network</base>
+	</expr>
+	<expr type="lookup">
+		<set>map2</set>
+		<sreg>1</sreg>
+		<dreg>0</dreg>
+	</expr>
+</rule>
+<!-- nft add rule ip filter output ip daddr vmap { 192.168.1.1 => accept, 192.168.1.2 => drop, } -->

