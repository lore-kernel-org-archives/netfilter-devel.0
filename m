From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nft PATCH] tests: shell: add a basic scapy test
Date: Wed, 30 Nov 2016 10:39:06 +0100
Message-ID: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: shivanib134@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40919 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754515AbcK3JjQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 04:39:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

This test uses scapy to send a packet and test our packet/data path.
We grep the 'nft list ruleset' output for a counter increment.

If we like this approach, then we could easily add more testcases
following the pattern in this patch.

Reference:
 https://unixia.wordpress.com/2016/02/17/testing-with-scapy/

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/testcases/scapy/0001_ip_ttl_0 |   33 +++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100755 tests/shell/testcases/scapy/0001_ip_ttl_0

diff --git a/tests/shell/testcases/scapy/0001_ip_ttl_0 b/tests/shell/testcases/scapy/0001_ip_ttl_0
new file mode 100755
index 0000000..1e4489e
--- /dev/null
+++ b/tests/shell/testcases/scapy/0001_ip_ttl_0
@@ -0,0 +1,33 @@
+#!/usr/bin/env python
+
+# this testcase launches an IP packet with ttl=2. An input
+# rule should capture the packet and increment the counter which
+# we will then grep to know about the result
+
+import os
+from subprocess import call
+try:
+	from scapy.all import *
+except ImportError:
+	sys.stderr.write("Unable to import scapy")
+	exit(0)
+
+# config
+nft = os.environ['NFT']
+conf.L3socket = L3RawSocket
+
+# capturing ruleset
+call([nft + " add table ip t"], shell=True)
+call([nft + " add chain ip t c {type filter hook input priority 0 \; policy accept \;}"], shell=True)
+call([nft + " add rule ip t c ip ttl 2 counter"], shell = True)
+
+# scapy packet
+pkt = IP()
+pkt.ttl = 2
+sr1(pkt, verbose=False)
+
+# results
+ruleset = call([nft + " list ruleset | grep \"ip ttl 2 counter packets 1\" >/dev/null"], shell=True)
+if ruleset != 0:
+	sys.stderr.write("Packet not captured by nftables?")
+	exit(1)

