From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] tests: xml: reorder XML elements in sets
Date: Mon, 12 Aug 2013 09:35:29 +0200
Message-ID: <20130812073529.20663.244.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:59727 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754462Ab3HLHfh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:35:37 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id C244151ED6E
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 07:35:36 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b0DfMBwpC4kE for <netfilter-devel@vger.kernel.org>;
	Mon, 12 Aug 2013 09:35:31 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 9BEE751ED78
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2013 09:35:31 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some node reorganization in order to have an input file equal to
what set_snprintf will output.


Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/xmlfiles/73-set.xml |    2 +-
 tests/xmlfiles/74-set.xml |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/xmlfiles/73-set.xml b/tests/xmlfiles/73-set.xml
index 2cf1c03..88bf402 100644
--- a/tests/xmlfiles/73-set.xml
+++ b/tests/xmlfiles/73-set.xml
@@ -1,2 +1,2 @@
-<set><name>set0</name><table>filter</table><family>ip</family><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set>
+<set><family>ip</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0300a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0200a8c0</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>4</len><data0>0x0100a8c0</data0></data_reg></key></set_elem></set>
 <!-- nft add rule ip filter test ip daddr { 192.168.0.1, 192.168.0.2, 192.168.0.3 } tcp dport 443 counter accept -->
diff --git a/tests/xmlfiles/74-set.xml b/tests/xmlfiles/74-set.xml
index eaf9b7d..5b6e8f1 100644
--- a/tests/xmlfiles/74-set.xml
+++ b/tests/xmlfiles/74-set.xml
@@ -1,2 +1,2 @@
-<set><name>set0</name><table>filter</table><family>ip6</family><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set>
+<set><family>ip6</family><table>filter</table><name>set0</name><flags>0</flags><key_type>0</key_type><key_len>0</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x70010000</data3></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>16</len><data0>0xc09a002a</data0><data1>0x2700cac1</data1><data2>0x00000000</data2><data3>0x50010000</data3></data_reg></key></set_elem></set>
 <!-- nft add rule ip6 filter test ip6 daddr { 2a00:9ac0:c1ca:27::150, 2a00:9ac0:c1ca:27::170, } counter accept -->

