From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] test: xml: fix malformed ruleset testfile
Date: Thu, 24 Oct 2013 17:00:58 +0200
Message-ID: <20131024150058.21634.49651.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42868 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754709Ab3JXPBQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:01:16 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id 5330451ED47
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2013 15:01:09 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N6D5U51J4S3K for <netfilter-devel@vger.kernel.org>;
	Thu, 24 Oct 2013 17:01:03 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id BD51551ECD7
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2013 17:01:01 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Give a new XML ruleset testfile. For some reason, the previous was truncated.
This passed silently as nft-parsing-test is not reporting some errors properly.

This new file provides:
 * 2 tables
 * 3 chains
 * 2 sets, with and without maps
 * 3 rules with mixed exprs

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/xmlfiles/75-ruleset.xml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xmlfiles/75-ruleset.xml b/tests/xmlfiles/75-ruleset.xml
index 926c2be..5f673a6 100644
--- a/tests/xmlfiles/75-ruleset.xml
+++ b/tests/xmlfiles/75-ruleset.xml
@@ -1 +1 @@
-<nftables><table><name>filter</name><family>ip</family><flags>0</flags></table><table><name>filter2</name><family>ip</family><flags>0</flags></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>3</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><set><family>ip</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001900</data0></data_reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><
 /set_elem></set><set><family>ip</family><table>filter</table><name>set1</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_el
+<nftables><table><name>filter</name><family>ip</family><flags>0</flags></table><table><name>filter</name><family>ip6</family><flags>0</flags></table><chain><name>input</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>output</name><handle>2</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip</family></chain><chain><name>forward</name><handle>1</handle><bytes>0</bytes><packets>0</packets><table>filter</table><family>ip6</family></chain><set><family>ip6</family><table>filter</table><name>set0</name><flags>3</flags><key_type>12</key_type><key_len>2</key_len><data_type>0</data_type><data_len>0</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00004300</data0></data
 _reg></key></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00003500</data0></data_reg></key></set_elem></set><set><family>ip</family><table>filter</tabl
 e><name>map0</name><flags>11</flags><key_type>12</key_type><key_len>2</key_len><data_type>4294967040</data_type><data_len>16</data_len><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00005000</data0></data_reg></key><data><data_reg type="verdict"><verdict>drop</verdict></data_reg></data></set_elem><set_elem><flags>0</flags><key><data_reg type="value"><len>2</len><data0>0x00001600</data0></data_reg></key><data><data_reg type="verdict"><verdict>accept</verdict></data_reg></data></set_elem></set><rule><family>ip</family><table>filter</table><chain>input</chain><handle>8</handle><flags>0</flags><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept</verdict></data_reg></i
 mmediatedata></expr></rule><rule><family>ip</family><table>filter</table><chain>output</chain><handle>9</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>9</offset><len>1</l
 en><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000006</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>map0</set><sreg>1</sreg><dreg>0</dreg></expr></rule><rule><family>ip6</family><table>filter</table><chain>forward</chain><handle>2</handle><flags>0</flags><expr type="payload"><dreg>1</dreg><offset>6</offset><len>1</len><base>network</base></expr><expr type="cmp"><sreg>1</sreg><op>eq</op><cmpdata><data_reg type="value"><len>1</len><data0>0x00000011</data0></data_reg></cmpdata></expr><expr type="payload"><dreg>1</dreg><offset>2</offset><len>2</len><base>transport</base></expr><expr type="lookup"><set>set0</
 set><sreg>1</sreg><dreg>0</dreg></expr><expr type="counter"><pkts>0</pkts><bytes>0</bytes></expr><expr type="immediate"><dreg>0</dreg><immediatedata><data_reg type="verdict"><verdict>accept<
 /verdict></data_reg></immediatedata></expr></rule></nftables>

