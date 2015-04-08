From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 4/4] tests: regression: add xt compat tests
Date: Wed, 08 Apr 2015 19:48:34 +0200
Message-ID: <20150408174834.28553.53067.stgit@nfdev2.cica.es>
References: <20150408174818.28553.96128.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:38453 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754753AbbDHRsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 13:48:43 -0400
In-Reply-To: <20150408174818.28553.96128.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds several regression test for the xt compat stuff.

Note the current output is:
 ip/xt.t: 25 unit tests, 0 error, 0 warning
 ip6/xt.t: 25 unit tests, 0 error, 0 warning
 bridge/xt.t: 26 unit tests, 0 error, 0 warning
 arp/xt.t: 12 unit tests, 0 error, 0 warning

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/regression/bridge/xt.t |   45 ++++++++++++++++++++++++++++++++++++++++++
 tests/regression/ip/xt.t     |   45 ++++++++++++++++++++++++++++++++++++++++++
 tests/regression/ip6/xt.t    |   45 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 135 insertions(+)
 create mode 100644 tests/regression/bridge/xt.t
 create mode 100644 tests/regression/ip/xt.t
 create mode 100644 tests/regression/ip6/xt.t

diff --git a/tests/regression/bridge/xt.t b/tests/regression/bridge/xt.t
new file mode 100644
index 0000000..b3f4beb
--- /dev/null
+++ b/tests/regression/bridge/xt.t
@@ -0,0 +1,45 @@
+*bridge;test-bridge
+:test-forward;type filter hook forward priority 0
+
+# standard load of match, target, watcher
+xt match 802_3 [ --802_3-sap 0x1 ];ok;xt match 802_3 [--802_3-sap 0x01  ]
+xt target mark [ --mark-set 0x1 ];ok;xt target mark [--mark-set 0x1 --mark-target ACCEPT ]
+xt watcher log [ ];ok;xt watcher log [--log-level notice --log-prefix ""  ]
+xt watcher log;ok;xt watcher log [--log-level notice --log-prefix ""  ]
+
+# more than one argument in a single statement
+xt match 802_3 [ --802_3-sap 0x1 --802_3-type 0x2 ];ok;xt match 802_3 [--802_3-sap 0x01 --802_3-type 0x0002  ]
+xt target mark [ --mark-set 0x1 --mark-target CONTINUE ];ok;xt target mark [--mark-set 0x1 --mark-target CONTINUE ]
+xt watcher log [ --log-level notice --log-prefix "test" ];ok;xt watcher log [--log-level notice --log-prefix "test"  ]
+
+# repeated statement with different argument (also testing final statement flag)
+xt match 802_3 [ --802_3-sap 0x1 --802_3-type 0x2 ] xt match 802_3 [ --802_3-type 0x3 --802_3-sap 0x4 ];ok;xt match 802_3 [--802_3-sap 0x01 --802_3-type 0x0002  ] xt match 802_3 [--802_3-sap 0x04 --802_3-type 0x0003  ]
+xt target mark [ --mark-set 0x1 --mark-target CONTINUE ] xt target mark [ --mark-set 0x1 ];fail
+xt watcher log [ --log-level notice ] xt watcher log [ --log-level notice --log-prefix "test" ];ok;xt watcher log [--log-level notice --log-prefix ""  ] xt watcher log [--log-level notice --log-prefix "test"  ]
+
+# statement with weird/invalid options
+xt match mark_m [ --test ];fail
+xt target mark [];ok;xt target mark [--mark-set 0x0 --mark-target ACCEPT ]
+xt target mark;ok;xt target mark [--mark-set 0x0 --mark-target ACCEPT ]
+xt watcher log [];ok;xt watcher log [--log-level notice --log-prefix ""  ]
+xt watcher log [--test];ok;xt watcher log [--log-level notice --log-prefix ""  ]
+
+# statement with invalid argument
+xt match 802_3 [ --802_3-sap -1 ];fail
+xt target mark [ --mark-target TEST ];fail
+xt watcher log [ --log-level test ];fail
+
+# inversions
+xt match 802_3 [ ! --802_3-sap 0x1 ];ok;xt match 802_3 [--802_3-sap ! 0x01  ]
+xt match 802_3 [ --802_3-sap ! 0x1 ];ok;xt match 802_3 [--802_3-sap ! 0x01  ]
+ether type ip xt match ip [ --ip-src ! 1.1.1.1 ];ok;ether type ip xt match ip [--ip-src ! 1.1.1.1  ]
+
+# protocol context games
+xt match ip [ --ip-src 1.1.1.1 ];fail
+ether type ip xt match ip [ --ip-src 1.1.1.1 ];ok;ether type ip xt match ip [--ip-src 1.1.1.1  ]
+ether type ip6 xt match ip [ --ip-src 1.1.1.1 ];fail
+ether type ip xt match ip [ --ip-proto tcp --ip-sport 123 ];ok;ether type ip xt match ip [--ip-proto tcp --ip-sport 123  ]
+
+# quoted strings
+xt watcher log [ --log-prefix \"test test\" ];ok;xt watcher log [--log-level notice --log-prefix "test test"  ]
+xt watcher log [ --log-prefix \"test test \" ];ok;xt watcher log [--log-level notice --log-prefix "test test "  ]
diff --git a/tests/regression/ip/xt.t b/tests/regression/ip/xt.t
new file mode 100644
index 0000000..0ee3a21
--- /dev/null
+++ b/tests/regression/ip/xt.t
@@ -0,0 +1,45 @@
+*ip;nat
+:test-postrouting;type nat hook postrouting priority 0
+
+# standard load of match, target, watcher
+ip protocol 6 xt match multiport [ --dports 123,234,345 ];ok
+xt target MASQUERADE;ok;xt target MASQUERADE [ ]
+xt target LOG;ok;xt target LOG [ ]
+xt target LOG [];ok;xt target LOG [ ]
+xt target LOG [ ];ok;xt target LOG [ ]
+xt watcher log;fail
+
+# foreing extensions
+xt match 802_3 [ --802_3-sap 0x1 ];fail
+xt target mark [ --mark-set 0x1 ];fail
+
+# more than one argument in a single statement
+xt match conntrack [ --ctstate NEW --ctdir ORIGINAL ];ok
+xt target SNAT [ --to-source 10.0.0.10 --persistent ];ok
+
+# repeated statement with different argument (also testing final statement flag)
+xt match conntrack [ --ctstate NEW ] xt match conntrack [ --ctstate ESTABLISHED ] xt match conntrack [ --ctstate NEW,ESTABLISHED ];ok
+xt target SNAT [ --to-source 10.0.0.10 ] xt target SNAT [ --to-source 10.0.0.10 ];fail
+
+# statement with weird/invalid options
+xt match conntrack [ --asdasd --asdasd ];fail
+xt match multiport;fail
+xt match multiport [];fail
+xt match multiport [ ];fail
+xt target SNAT [ --asdasd --asdasd ];fail
+
+# statement with invalid argument
+xt match conntrack [ --ctstate TEST ];fail
+xt target SNAT [ --to-source asd ];fail
+
+# inversions
+xt match conntrack [ ! --ctstate NEW ! --ctstatus CONFIRMED --ctdir REPLY ];ok
+
+# protocol context games
+ip protocol 6 xt match multiport [ --dports 1,2,3 ]; ok
+ip protocol 17 xt match multiport [ --dports 1,2,3 ]; ok
+xt match multiport [ --dports 1,2,3 ]; fail
+
+# quoted strings
+xt match comment [ --comment \"test test\" ];ok;xt match comment [ --comment "test test" ]
+xt target LOG [ --log-prefix \"test test\" ];ok;xt target LOG [ --log-prefix "test test" ]
diff --git a/tests/regression/ip6/xt.t b/tests/regression/ip6/xt.t
new file mode 100644
index 0000000..0ee3a21
--- /dev/null
+++ b/tests/regression/ip6/xt.t
@@ -0,0 +1,45 @@
+*ip;nat
+:test-postrouting;type nat hook postrouting priority 0
+
+# standard load of match, target, watcher
+ip protocol 6 xt match multiport [ --dports 123,234,345 ];ok
+xt target MASQUERADE;ok;xt target MASQUERADE [ ]
+xt target LOG;ok;xt target LOG [ ]
+xt target LOG [];ok;xt target LOG [ ]
+xt target LOG [ ];ok;xt target LOG [ ]
+xt watcher log;fail
+
+# foreing extensions
+xt match 802_3 [ --802_3-sap 0x1 ];fail
+xt target mark [ --mark-set 0x1 ];fail
+
+# more than one argument in a single statement
+xt match conntrack [ --ctstate NEW --ctdir ORIGINAL ];ok
+xt target SNAT [ --to-source 10.0.0.10 --persistent ];ok
+
+# repeated statement with different argument (also testing final statement flag)
+xt match conntrack [ --ctstate NEW ] xt match conntrack [ --ctstate ESTABLISHED ] xt match conntrack [ --ctstate NEW,ESTABLISHED ];ok
+xt target SNAT [ --to-source 10.0.0.10 ] xt target SNAT [ --to-source 10.0.0.10 ];fail
+
+# statement with weird/invalid options
+xt match conntrack [ --asdasd --asdasd ];fail
+xt match multiport;fail
+xt match multiport [];fail
+xt match multiport [ ];fail
+xt target SNAT [ --asdasd --asdasd ];fail
+
+# statement with invalid argument
+xt match conntrack [ --ctstate TEST ];fail
+xt target SNAT [ --to-source asd ];fail
+
+# inversions
+xt match conntrack [ ! --ctstate NEW ! --ctstatus CONFIRMED --ctdir REPLY ];ok
+
+# protocol context games
+ip protocol 6 xt match multiport [ --dports 1,2,3 ]; ok
+ip protocol 17 xt match multiport [ --dports 1,2,3 ]; ok
+xt match multiport [ --dports 1,2,3 ]; fail
+
+# quoted strings
+xt match comment [ --comment \"test test\" ];ok;xt match comment [ --comment "test test" ]
+xt target LOG [ --log-prefix \"test test\" ];ok;xt target LOG [ --log-prefix "test test" ]

