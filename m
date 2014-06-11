From: Ana Rey <anarey@gmail.com>
Subject: [libnftnl PATCH 5/5] tests: xmlfile: Test files without unset child elements in set elements
Date: Wed, 11 Jun 2014 17:50:51 +0200
Message-ID: <1402501851-22208-7-git-send-email-anarey@gmail.com>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:54538 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbaFKPvY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:51:24 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so6963956wes.22
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 08:51:20 -0700 (PDT)
In-Reply-To: <1402501851-22208-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test files without unset child element in set elements.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/xmlfiles/73-set.xml     | 2 +-
 tests/xmlfiles/74-set.xml     | 2 +-
 tests/xmlfiles/75-ruleset.xml | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
index 6a9323a..1af61fa 100644
--- a/tests/xmlfiles/73-set.xml
+++ b/tests/xmlfiles/73-set.xml
@@ -1 +1 @@
-<nftables><set><family>ip</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set></nftables>
+<nftables><set><family>ip</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set></nftables>
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
index 5f0e7ae..a8cabaf 100644
--- a/tests/xmlfiles/74-set.xml
+++ b/tests/xmlfiles/74-set.xml
@@ -1 +1 @@
-<nftables><set><family>ip6</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set></nftables>
+<nftables><set><family>ip6</family><table>filter</table><name>set0</name><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set></nftables>
diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
index e4c8389..0eb4075 100644
--- a/tests/xmlfiles/75-ruleset.xml
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -1 +1 @@
-<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>
 0x00004300</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input<
 /chain><handle>8</handle><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</of
 fset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags><use>0</use></table><table><name>filter</name><family>ip6</family><flags>0</flags><use>0</use></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><key><data_reg type="value"><len>2</len><data0>0x00004300</data
 0></data_reg></key></set_elem><set_elem><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</table><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>8</handle><expr type="counter"><pkts>0</pkts><byt
 es>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sr
 eg>1</sreg><op>eq</op><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><data_reg type="verdict"><verdict>accept</verdict></data_reg></expr></rule></nftables>
-- 
2.0.0

