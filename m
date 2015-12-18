From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/5] tests: add ct tests for ip family
Date: Fri, 18 Dec 2015 22:08:03 +0100
Message-ID: <1450472883-19743-6-git-send-email-fw@strlen.de>
References: <1450472883-19743-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40520 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965392AbbLRVMC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 16:12:02 -0500
In-Reply-To: <1450472883-19743-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cannot check e.g. saddr for 192.168.0.1 for 'any' protocol, nft
needs to expect arguments of a specific address type.

So e.g. when using 'inet' we need to add a rule that makes the expected
family explicit, e.g. 'meta nfproto ipv4'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/ip/ct.t         | 23 ++++++++++++++++++
 tests/py/ip/ct.t.payload | 63 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)
 create mode 100644 tests/py/ip/ct.t
 create mode 100644 tests/py/ip/ct.t.payload

diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
new file mode 100644
index 0000000..28ad766
--- /dev/null
+++ b/tests/py/ip/ct.t
@@ -0,0 +1,23 @@
+*ip;test-ip4
+
+:output;type filter hook output priority 0
+
+ct saddr original 192.168.0.1;ok
+ct saddr reply 192.168.0.1;ok
+ct daddr original 192.168.0.1;ok
+ct daddr reply 192.168.0.1;ok
+
+# same, but with a netmask
+ct saddr original 192.168.1.0/24;ok
+ct saddr reply 192.168.1.0/24;ok
+ct daddr original 192.168.1.0/24;ok
+ct daddr reply 192.168.1.0/24;ok
+
+ct l3proto original ipv4;ok
+ct l3proto reply foobar;fail
+
+ct protocol original 6 ct proto-dst original 22;ok
+ct protocol original 17 ct proto-src reply 53;ok
+
+# wrong address family
+ct daddr reply dead::beef;fail
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
new file mode 100644
index 0000000..4a23455
--- /dev/null
+++ b/tests/py/ip/ct.t.payload
@@ -0,0 +1,63 @@
+# ct saddr original 192.168.0.1
+ip test-ip4 output
+  [ ct load src => reg 1 , dir original ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+
+# ct saddr reply 192.168.0.1
+ip test-ip4 output
+  [ ct load src => reg 1 , dir reply ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+
+# ct daddr original 192.168.0.1
+ip test-ip4 output
+  [ ct load dst => reg 1 , dir original ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+
+# ct daddr reply 192.168.0.1
+ip test-ip4 output
+  [ ct load dst => reg 1 , dir reply ]
+  [ cmp eq reg 1 0x0100a8c0 ]
+
+# ct saddr original 192.168.1.0/24
+ip test-ip4 output
+  [ ct load src => reg 1 , dir original ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0001a8c0 ]
+
+# ct saddr reply 192.168.1.0/24
+ip test-ip4 output
+  [ ct load src => reg 1 , dir reply ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0001a8c0 ]
+
+# ct daddr original 192.168.1.0/24
+ip test-ip4 output
+  [ ct load dst => reg 1 , dir original ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0001a8c0 ]
+
+# ct daddr reply 192.168.1.0/24
+ip test-ip4 output
+  [ ct load dst => reg 1 , dir reply ]
+  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0001a8c0 ]
+
+# ct l3proto original ipv4
+ip test-ip4 output
+  [ ct load l3protocol => reg 1 , dir original ]
+  [ cmp eq reg 1 0x00000002 ]
+
+# ct protocol original 6 ct proto-dst original 22
+ip test-ip4 output
+  [ ct load protocol => reg 1 , dir original ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ ct load proto_dst => reg 1 , dir original ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# ct protocol original 17 ct proto-src reply 53
+ip test-ip4 output
+  [ ct load protocol => reg 1 , dir original ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ ct load proto_src => reg 1 , dir reply ]
+  [ cmp eq reg 1 0x00003500 ]
+
-- 
2.4.10

