From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nftables 7/7] tests: py: Add basic tests for ip, ip6 and inet
Date: Tue,  7 Feb 2017 03:14:15 +0100
Message-ID: <20170207021415.22460-8-mm@skelett.io>
References: <20170207021415.22460-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:32787 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751748AbdBGCTx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:53 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 36818B02B1
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:14:37 -0500 (EST)
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Manuel Messner <mm@skelett.io>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/tcpopt.t              |  38 ++++++++
 tests/py/inet/tcpopt.t.payload.inet | 181 ++++++++++++++++++++++++++++++++++++
 tests/py/ip/tcpopt.t                |  38 ++++++++
 tests/py/ip/tcpopt.t.payload        | 181 ++++++++++++++++++++++++++++++++++++
 tests/py/ip6/tcpopt.t               |  37 ++++++++
 tests/py/ip6/tcpopt.t.payload       | 181 ++++++++++++++++++++++++++++++++++++
 6 files changed, 656 insertions(+)
 create mode 100644 tests/py/inet/tcpopt.t
 create mode 100644 tests/py/inet/tcpopt.t.payload.inet
 create mode 100644 tests/py/ip/tcpopt.t
 create mode 100644 tests/py/ip/tcpopt.t.payload
 create mode 100644 tests/py/ip6/tcpopt.t
 create mode 100644 tests/py/ip6/tcpopt.t.payload

diff --git a/tests/py/inet/tcpopt.t b/tests/py/inet/tcpopt.t
new file mode 100644
index 0000000..39204fd
--- /dev/null
+++ b/tests/py/inet/tcpopt.t
@@ -0,0 +1,38 @@
+:input;type filter hook input priority 0
+
+*inet;test-inet;input
+
+tcp option eol kind 1;ok
+tcp option noop kind 1;ok
+tcp option maxseg kind 1;ok
+tcp option maxseg length 1;ok
+tcp option maxseg size 1;ok
+tcp option window kind 1;ok
+tcp option window length 1;ok
+tcp option window count 1;ok
+tcp option sack_permitted kind 1;ok
+tcp option sack_permitted length 1;ok
+tcp option sack kind 1;ok
+tcp option sack length 1;ok
+tcp option sack left 1;ok
+tcp option sack 0 left 1;ok;tcp option sack left 1
+tcp option sack 1 left 1;ok
+tcp option sack 2 left 1;ok
+tcp option sack 3 left 1;ok
+tcp option sack right 1;ok
+tcp option sack 0 right 1;ok;tcp option sack right 1
+tcp option sack 1 right 1;ok
+tcp option sack 2 right 1;ok
+tcp option sack 3 right 1;ok
+tcp option timestamp kind 1;ok
+tcp option timestamp length 1;ok
+tcp option timestamp tsval 1;ok
+tcp option timestamp tsecr 1;ok
+
+tcp option foobar;fail
+tcp option foo bar;fail
+tcp option eol left;fail
+tcp option eol left 1;fail
+tcp option eol left 1;fail
+tcp option sack window;fail
+tcp option sack window 1;fail
diff --git a/tests/py/inet/tcpopt.t.payload.inet b/tests/py/inet/tcpopt.t.payload.inet
new file mode 100644
index 0000000..1343ae5
--- /dev/null
+++ b/tests/py/inet/tcpopt.t.payload.inet
@@ -0,0 +1,181 @@
+# tcp option eol kind 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option noop kind 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg kind 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg length 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg size 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# tcp option window kind 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window length 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window count 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack_permitted kind 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack_permitted length 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack kind 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack length 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack left 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 0 left 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 1 left 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 2 left 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 3 left 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack right 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 0 right 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 1 right 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 2 right 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 3 right 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp kind 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp length 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp tsval 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsecr 1
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
diff --git a/tests/py/ip/tcpopt.t b/tests/py/ip/tcpopt.t
new file mode 100644
index 0000000..fccc6dd
--- /dev/null
+++ b/tests/py/ip/tcpopt.t
@@ -0,0 +1,38 @@
+:input;type filter hook input priority 0
+
+*ip;test-ip;input
+
+tcp option eol kind 1;ok
+tcp option noop kind 1;ok
+tcp option maxseg kind 1;ok
+tcp option maxseg length 1;ok
+tcp option maxseg size 1;ok
+tcp option window kind 1;ok
+tcp option window length 1;ok
+tcp option window count 1;ok
+tcp option sack_permitted kind 1;ok
+tcp option sack_permitted length 1;ok
+tcp option sack kind 1;ok
+tcp option sack length 1;ok
+tcp option sack left 1;ok
+tcp option sack 0 left 1;ok;tcp option sack left 1
+tcp option sack 1 left 1;ok
+tcp option sack 2 left 1;ok
+tcp option sack 3 left 1;ok
+tcp option sack right 1;ok
+tcp option sack 0 right 1;ok;tcp option sack right 1
+tcp option sack 1 right 1;ok
+tcp option sack 2 right 1;ok
+tcp option sack 3 right 1;ok
+tcp option timestamp kind 1;ok
+tcp option timestamp length 1;ok
+tcp option timestamp tsval 1;ok
+tcp option timestamp tsecr 1;ok
+
+tcp option foobar;fail
+tcp option foo bar;fail
+tcp option eol left;fail
+tcp option eol left 1;fail
+tcp option eol left 1;fail
+tcp option sack window;fail
+tcp option sack window 1;fail
diff --git a/tests/py/ip/tcpopt.t.payload b/tests/py/ip/tcpopt.t.payload
new file mode 100644
index 0000000..47e4dee
--- /dev/null
+++ b/tests/py/ip/tcpopt.t.payload
@@ -0,0 +1,181 @@
+# tcp option eol kind 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option noop kind 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg kind 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg length 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg size 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# tcp option window kind 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window length 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window count 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack_permitted kind 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack_permitted length 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack kind 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack length 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack left 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 0 left 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 1 left 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 2 left 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 3 left 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack right 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 0 right 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 1 right 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 2 right 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 3 right 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp kind 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp length 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp tsval 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsecr 1
+ip test-ip input
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
diff --git a/tests/py/ip6/tcpopt.t b/tests/py/ip6/tcpopt.t
new file mode 100644
index 0000000..d6f2dba
--- /dev/null
+++ b/tests/py/ip6/tcpopt.t
@@ -0,0 +1,37 @@
+:input;type filter hook input priority 0
+*ip6;test-ip6;input
+
+tcp option eol kind 1;ok
+tcp option noop kind 1;ok
+tcp option maxseg kind 1;ok
+tcp option maxseg length 1;ok
+tcp option maxseg size 1;ok
+tcp option window kind 1;ok
+tcp option window length 1;ok
+tcp option window count 1;ok
+tcp option sack_permitted kind 1;ok
+tcp option sack_permitted length 1;ok
+tcp option sack kind 1;ok
+tcp option sack length 1;ok
+tcp option sack left 1;ok
+tcp option sack 0 left 1;ok;tcp option sack left 1
+tcp option sack 1 left 1;ok
+tcp option sack 2 left 1;ok
+tcp option sack 3 left 1;ok
+tcp option sack right 1;ok
+tcp option sack 0 right 1;ok;tcp option sack right 1
+tcp option sack 1 right 1;ok
+tcp option sack 2 right 1;ok
+tcp option sack 3 right 1;ok
+tcp option timestamp kind 1;ok
+tcp option timestamp length 1;ok
+tcp option timestamp tsval 1;ok
+tcp option timestamp tsecr 1;ok
+
+tcp option foobar;fail
+tcp option foo bar;fail
+tcp option eol left;fail
+tcp option eol left 1;fail
+tcp option eol left 1;fail
+tcp option sack window;fail
+tcp option sack window 1;fail
diff --git a/tests/py/ip6/tcpopt.t.payload b/tests/py/ip6/tcpopt.t.payload
new file mode 100644
index 0000000..98389b0
--- /dev/null
+++ b/tests/py/ip6/tcpopt.t.payload
@@ -0,0 +1,181 @@
+# tcp option eol kind 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 0 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option noop kind 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 1 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg kind 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg length 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 2 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option maxseg size 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 2b @ 2 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# tcp option window kind 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window length 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option window count 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack_permitted kind 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack_permitted length 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack kind 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack length 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 5 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option sack left 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 0 left 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 1 left 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 10 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 2 left 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 18 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 3 left 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 26 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack right 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 0 right 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 1 right 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 14 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 2 right 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 22 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option sack 3 right 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 5 + 30 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp kind 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp length 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 1b @ 8 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# tcp option timestamp tsval 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 2 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# tcp option timestamp tsecr 1
+ip6 test-ip input
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ exthdr load tcpopt 4b @ 8 + 6 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
-- 
2.11.1

