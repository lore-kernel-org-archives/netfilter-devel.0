Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C05A440C
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Oct 2024 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729464437; cv=none; b=YXbE3DiOP7O2cIGlZhEx8wVxkhBhaGo6YGQeQWoCshKrVh3dalTVzdssTn3ZCxA0VeKI/Y+miT3V+oFYZXyPrYjgi2g6Th6HehFQoOuCqZU9mlKTKc1jSJm0a6qyBNt97G5Vz1mC9rWwEsvnxDG8ZfA+LyEpOe8qAFy0LxQrioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729464437; c=relaxed/simple;
	bh=mJ/0EnVZvbcCURb/RFXzrJZdja3xPyOQ7GObN9Bb/OE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OTCkVOVeDlxgqm/nAgEp3hA99THPl610yxm371zx+v0eyn0YV+d50zJJ0Rd+CyDJJe+J/p/1WSp2Ndu+rm9j7Iw3oJkQEpH5DKn0YdUSkpctrK1KaQOj9nf+pMDmrwLaSbegSvXzQzAd3l1x7nH4maRVuhQ0X9PM1vX/THli/Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH iptables] tests: iptables-test: extend coverage for ip6tables
Date: Mon, 21 Oct 2024 00:47:07 +0200
Message-Id: <20241020224707.69249-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update iptables-test.py to run libxt_*.t both for iptables and
ip6tables. This update requires changes in the existing tests.

* Rename libxt_*.t into libipt_*.t and add libip6_*.t variant.

- TEE
- TPROXY
- connlimit
- conntrack
- iprange
- ipvs
- policy
- recent

* Rename the following libxt_*.t to libipt_*.t since they are IPv4
  specific:

- standard
- osf

* Remove IPv4 specific test in libxt_mark.t

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libip6t_TEE.t                      |  4 ++
 extensions/libip6t_TPROXY.t                   |  5 ++
 extensions/libip6t_connlimit.t                | 16 +++++
 extensions/libip6t_conntrack.t                | 55 ++++++++++++++++
 extensions/libip6t_iprange.t                  | 11 ++++
 extensions/libip6t_ipvs.t                     | 20 ++++++
 extensions/libip6t_policy.t                   |  8 +++
 extensions/libip6t_recent.t                   | 11 ++++
 extensions/{libxt_TEE.t => libipt_TEE.t}      |  0
 .../{libxt_TPROXY.t => libipt_TPROXY.t}       |  0
 .../{libxt_connlimit.t => libipt_connlimit.t} |  0
 .../{libxt_conntrack.t => libipt_conntrack.t} |  0
 .../{libxt_iprange.t => libipt_iprange.t}     |  0
 extensions/{libxt_ipvs.t => libipt_ipvs.t}    |  0
 extensions/{libxt_osf.t => libipt_osf.t}      |  0
 .../{libxt_policy.t => libipt_policy.t}       |  0
 .../{libxt_recent.t => libipt_recent.t}       |  0
 .../{libxt_standard.t => libipt_standard.t}   |  0
 extensions/libxt_mark.t                       |  2 +-
 iptables-test.py                              | 64 +++++++++++++------
 20 files changed, 174 insertions(+), 22 deletions(-)
 create mode 100644 extensions/libip6t_TEE.t
 create mode 100644 extensions/libip6t_TPROXY.t
 create mode 100644 extensions/libip6t_connlimit.t
 create mode 100644 extensions/libip6t_conntrack.t
 create mode 100644 extensions/libip6t_iprange.t
 create mode 100644 extensions/libip6t_ipvs.t
 create mode 100644 extensions/libip6t_policy.t
 create mode 100644 extensions/libip6t_recent.t
 rename extensions/{libxt_TEE.t => libipt_TEE.t} (100%)
 rename extensions/{libxt_TPROXY.t => libipt_TPROXY.t} (100%)
 rename extensions/{libxt_connlimit.t => libipt_connlimit.t} (100%)
 rename extensions/{libxt_conntrack.t => libipt_conntrack.t} (100%)
 rename extensions/{libxt_iprange.t => libipt_iprange.t} (100%)
 rename extensions/{libxt_ipvs.t => libipt_ipvs.t} (100%)
 rename extensions/{libxt_osf.t => libipt_osf.t} (100%)
 rename extensions/{libxt_policy.t => libipt_policy.t} (100%)
 rename extensions/{libxt_recent.t => libipt_recent.t} (100%)
 rename extensions/{libxt_standard.t => libipt_standard.t} (100%)

diff --git a/extensions/libip6t_TEE.t b/extensions/libip6t_TEE.t
new file mode 100644
index 000000000000..fcaa3c2664ca
--- /dev/null
+++ b/extensions/libip6t_TEE.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-j TEE --gateway 2001:db8::1;=;OK
+-j TEE ! --gateway 2001:db8::1;;FAIL
+-j TEE;;FAIL
diff --git a/extensions/libip6t_TPROXY.t b/extensions/libip6t_TPROXY.t
new file mode 100644
index 000000000000..5af67542f1bd
--- /dev/null
+++ b/extensions/libip6t_TPROXY.t
@@ -0,0 +1,5 @@
+:PREROUTING
+*mangle
+-j TPROXY --on-port 12345 --on-ip 2001:db8::1 --tproxy-mark 0x23/0xff;;FAIL
+-p udp -j TPROXY --on-port 12345 --on-ip 2001:db8::1 --tproxy-mark 0x23/0xff;=;OK
+-p tcp -m tcp --dport 2342 -j TPROXY --on-port 12345 --on-ip 2001:db8::1 --tproxy-mark 0x23/0xff;=;OK
diff --git a/extensions/libip6t_connlimit.t b/extensions/libip6t_connlimit.t
new file mode 100644
index 000000000000..8b7b3677b56d
--- /dev/null
+++ b/extensions/libip6t_connlimit.t
@@ -0,0 +1,16 @@
+:INPUT,FORWARD,OUTPUT
+-m connlimit --connlimit-upto 0;-m connlimit --connlimit-upto 0 --connlimit-mask 128 --connlimit-saddr;OK
+-m connlimit --connlimit-upto 4294967295 --connlimit-mask 128 --connlimit-saddr;=;OK
+-m connlimit --connlimit-upto 4294967296 --connlimit-mask 128 --connlimit-saddr;;FAIL
+-m connlimit --connlimit-upto -1;;FAIL
+-m connlimit --connlimit-above 0;-m connlimit --connlimit-above 0 --connlimit-mask 128 --connlimit-saddr;OK
+-m connlimit --connlimit-above 4294967295 --connlimit-mask 128 --connlimit-saddr;=;OK
+-m connlimit --connlimit-above 4294967296 --connlimit-mask 128 --connlimit-saddr;;FAIL
+-m connlimit --connlimit-above -1;;FAIL
+-m connlimit --connlimit-upto 1 --conlimit-above 1;;FAIL
+-m connlimit --connlimit-above 10 --connlimit-saddr;-m connlimit --connlimit-above 10 --connlimit-mask 128 --connlimit-saddr;OK
+-m connlimit --connlimit-above 10 --connlimit-daddr;-m connlimit --connlimit-above 10 --connlimit-mask 128 --connlimit-daddr;OK
+-m connlimit --connlimit-above 10 --connlimit-saddr --connlimit-daddr;;FAIL
+-m connlimit --connlimit-above 10 --connlimit-mask 128 --connlimit-saddr;=;OK
+-m connlimit --connlimit-above 10 --connlimit-mask 128 --connlimit-daddr;=;OK
+-m connlimit;;FAIL
diff --git a/extensions/libip6t_conntrack.t b/extensions/libip6t_conntrack.t
new file mode 100644
index 000000000000..9dd8b5799779
--- /dev/null
+++ b/extensions/libip6t_conntrack.t
@@ -0,0 +1,55 @@
+:INPUT,FORWARD,OUTPUT
+-m conntrack --ctstate NEW;=;OK
+-m conntrack --ctstate NEW,ESTABLISHED;=;OK
+-m conntrack --ctstate NEW,RELATED,ESTABLISHED;=;OK
+-m conntrack --ctstate INVALID;=;OK
+-m conntrack --ctstate UNTRACKED;=;OK
+-m conntrack --ctstate SNAT,DNAT;=;OK
+-m conntrack --ctstate wrong;;FAIL
+# should we convert this to output "tcp" instead of 6?
+-m conntrack --ctproto tcp;-m conntrack --ctproto 6;OK
+-m conntrack --ctorigsrc 2001:db8::1;=;OK
+-m conntrack --ctorigdst 2001:db8::1;=;OK
+-m conntrack --ctreplsrc 2001:db8::1;=;OK
+-m conntrack --ctrepldst 2001:db8::1;=;OK
+-m conntrack --ctexpire 0;=;OK
+-m conntrack --ctexpire 4294967295;=;OK
+-m conntrack --ctexpire 0:4294967295;=;OK
+-m conntrack --ctexpire 42949672956;;FAIL
+-m conntrack --ctexpire -1;;FAIL
+-m conntrack --ctexpire 3:3;-m conntrack --ctexpire 3;OK
+-m conntrack --ctexpire 4:3;;FAIL
+-m conntrack --ctdir ORIGINAL;=;OK
+-m conntrack --ctdir REPLY;=;OK
+-m conntrack --ctstatus NONE;=;OK
+-m conntrack --ctstatus CONFIRMED;=;OK
+-m conntrack --ctstatus ASSURED;=;OK
+-m conntrack --ctstatus EXPECTED;=;OK
+-m conntrack --ctstatus SEEN_REPLY;=;OK
+-m conntrack;;FAIL
+-m conntrack --ctproto 0;;FAIL
+-m conntrack ! --ctproto 0;;FAIL
+-m conntrack --ctorigsrcport :;-m conntrack --ctorigsrcport 0:65535;OK
+-m conntrack --ctorigsrcport :4;-m conntrack --ctorigsrcport 0:4;OK
+-m conntrack --ctorigsrcport 4:;-m conntrack --ctorigsrcport 4:65535;OK
+-m conntrack --ctorigsrcport 3:4;=;OK
+-m conntrack --ctorigsrcport 4:4;-m conntrack --ctorigsrcport 4;OK
+-m conntrack --ctorigsrcport 4:3;;FAIL
+-m conntrack --ctreplsrcport :;-m conntrack --ctreplsrcport 0:65535;OK
+-m conntrack --ctreplsrcport :4;-m conntrack --ctreplsrcport 0:4;OK
+-m conntrack --ctreplsrcport 4:;-m conntrack --ctreplsrcport 4:65535;OK
+-m conntrack --ctreplsrcport 3:4;=;OK
+-m conntrack --ctreplsrcport 4:4;-m conntrack --ctreplsrcport 4;OK
+-m conntrack --ctreplsrcport 4:3;;FAIL
+-m conntrack --ctorigdstport :;-m conntrack --ctorigdstport 0:65535;OK
+-m conntrack --ctorigdstport :4;-m conntrack --ctorigdstport 0:4;OK
+-m conntrack --ctorigdstport 4:;-m conntrack --ctorigdstport 4:65535;OK
+-m conntrack --ctorigdstport 3:4;=;OK
+-m conntrack --ctorigdstport 4:4;-m conntrack --ctorigdstport 4;OK
+-m conntrack --ctorigdstport 4:3;;FAIL
+-m conntrack --ctrepldstport :;-m conntrack --ctrepldstport 0:65535;OK
+-m conntrack --ctrepldstport :4;-m conntrack --ctrepldstport 0:4;OK
+-m conntrack --ctrepldstport 4:;-m conntrack --ctrepldstport 4:65535;OK
+-m conntrack --ctrepldstport 3:4;=;OK
+-m conntrack --ctrepldstport 4:4;-m conntrack --ctrepldstport 4;OK
+-m conntrack --ctrepldstport 4:3;;FAIL
diff --git a/extensions/libip6t_iprange.t b/extensions/libip6t_iprange.t
new file mode 100644
index 000000000000..94cf41139744
--- /dev/null
+++ b/extensions/libip6t_iprange.t
@@ -0,0 +1,11 @@
+:INPUT,FORWARD,OUTPUT
+-m iprange --src-range 2001:db8::1-2001:db8::10;=;OK
+-m iprange ! --src-range 2001:db8::1-2001:db8::10;=;OK
+-m iprange --dst-range 2001:db8::1-2001:db8::10;=;OK
+-m iprange ! --dst-range 2001:db8::1-2001:db8::10;=;OK
+# it shows -A INPUT -m iprange --src-range 2001:db8::1-2001:db8::1, should we support this?
+# ERROR: should fail: ip6tables -A INPUT -m iprange --src-range 2001:db8::1
+# -m iprange --src-range 2001:db8::1;;FAIL
+# ERROR: should fail: ip6tables -A INPUT -m iprange --dst-range 2001:db8::1
+#-m iprange --dst-range 2001:db8::1;;FAIL
+-m iprange;;FAIL
diff --git a/extensions/libip6t_ipvs.t b/extensions/libip6t_ipvs.t
new file mode 100644
index 000000000000..8d528f130d90
--- /dev/null
+++ b/extensions/libip6t_ipvs.t
@@ -0,0 +1,20 @@
+:INPUT,FORWARD,OUTPUT
+-m ipvs --ipvs;=;OK
+-m ipvs ! --ipvs;=;OK
+-m ipvs --vproto tcp;-m ipvs --vproto 6;OK
+-m ipvs ! --vproto TCP;-m ipvs ! --vproto 6;OK
+-m ipvs --vproto 23;=;OK
+-m ipvs --vaddr 2001:db8::1;=;OK
+-m ipvs ! --vaddr 2001:db8::/64;=;OK
+-m ipvs --vport http;-m ipvs --vport 80;OK
+-m ipvs ! --vport ssh;-m ipvs ! --vport 22;OK
+-m ipvs --vport 22;=;OK
+-m ipvs ! --vport 443;=;OK
+-m ipvs --vdir ORIGINAL;=;OK
+-m ipvs --vdir REPLY;=;OK
+-m ipvs --vmethod GATE;=;OK
+-m ipvs ! --vmethod IPIP;=;OK
+-m ipvs --vmethod MASQ;=;OK
+-m ipvs --vportctl 21;=;OK
+-m ipvs ! --vportctl 21;=;OK
+-m ipvs --vproto 6 --vaddr 2001:db8::/64 --vport 22 --vdir ORIGINAL --vmethod GATE;=;OK
diff --git a/extensions/libip6t_policy.t b/extensions/libip6t_policy.t
new file mode 100644
index 000000000000..95dad19c142f
--- /dev/null
+++ b/extensions/libip6t_policy.t
@@ -0,0 +1,8 @@
+:INPUT,FORWARD
+-m policy --dir in --pol ipsec;=;OK
+-m policy --dir in --pol ipsec --proto ipcomp;=;OK
+-m policy --dir in --pol ipsec --strict;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp;=;OK
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --mode tunnel --tunnel-dst 2001:db8::/32 --tunnel-src 2001:db8::/32 --next --reqid 2;=;OK
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --tunnel-dst 2001:db8::/32;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp --mode tunnel --tunnel-dst 2001:db8::/32 --tunnel-src 2001:db8::/32 --next --reqid 2;=;OK
diff --git a/extensions/libip6t_recent.t b/extensions/libip6t_recent.t
new file mode 100644
index 000000000000..1ecad5aff83b
--- /dev/null
+++ b/extensions/libip6t_recent.t
@@ -0,0 +1,11 @@
+:INPUT,FORWARD,OUTPUT
+-m recent --set;-m recent --set --name DEFAULT --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;OK
+-m recent --rcheck --hitcount 8 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --rcheck --hitcount 12 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;OK
+-m recent --set --rttl;;FAIL
+-m recent --rcheck --hitcount 999 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;;FAIL
+# nonsensical, but all should load successfully:
+-m recent --rcheck --hitcount 3 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource -m recent --rcheck --hitcount 4 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --rcheck --hitcount 4 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource -m recent --rcheck --hitcount 4 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --rcheck --hitcount 8 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource -m recent --rcheck --hitcount 12 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
diff --git a/extensions/libxt_TEE.t b/extensions/libipt_TEE.t
similarity index 100%
rename from extensions/libxt_TEE.t
rename to extensions/libipt_TEE.t
diff --git a/extensions/libxt_TPROXY.t b/extensions/libipt_TPROXY.t
similarity index 100%
rename from extensions/libxt_TPROXY.t
rename to extensions/libipt_TPROXY.t
diff --git a/extensions/libxt_connlimit.t b/extensions/libipt_connlimit.t
similarity index 100%
rename from extensions/libxt_connlimit.t
rename to extensions/libipt_connlimit.t
diff --git a/extensions/libxt_conntrack.t b/extensions/libipt_conntrack.t
similarity index 100%
rename from extensions/libxt_conntrack.t
rename to extensions/libipt_conntrack.t
diff --git a/extensions/libxt_iprange.t b/extensions/libipt_iprange.t
similarity index 100%
rename from extensions/libxt_iprange.t
rename to extensions/libipt_iprange.t
diff --git a/extensions/libxt_ipvs.t b/extensions/libipt_ipvs.t
similarity index 100%
rename from extensions/libxt_ipvs.t
rename to extensions/libipt_ipvs.t
diff --git a/extensions/libxt_osf.t b/extensions/libipt_osf.t
similarity index 100%
rename from extensions/libxt_osf.t
rename to extensions/libipt_osf.t
diff --git a/extensions/libxt_policy.t b/extensions/libipt_policy.t
similarity index 100%
rename from extensions/libxt_policy.t
rename to extensions/libipt_policy.t
diff --git a/extensions/libxt_recent.t b/extensions/libipt_recent.t
similarity index 100%
rename from extensions/libxt_recent.t
rename to extensions/libipt_recent.t
diff --git a/extensions/libxt_standard.t b/extensions/libipt_standard.t
similarity index 100%
rename from extensions/libxt_standard.t
rename to extensions/libipt_standard.t
diff --git a/extensions/libxt_mark.t b/extensions/libxt_mark.t
index 12c058655f6b..b8dc3cb31aec 100644
--- a/extensions/libxt_mark.t
+++ b/extensions/libxt_mark.t
@@ -5,4 +5,4 @@
 -m mark --mark 4294967296;;FAIL
 -m mark --mark -1;;FAIL
 -m mark;;FAIL
--s 1.2.0.0/15 -m mark --mark 0x0/0xff0;=;OK
+-m mark --mark 0x0/0xff0;=;OK
diff --git a/iptables-test.py b/iptables-test.py
index 77278925d721..15e1112e6cbe 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -385,7 +385,7 @@ def run_test_file_fast(iptables, filename, netns):
 
     return tests
 
-def run_test_file(filename, netns):
+def _run_test_file(iptables, filename, netns):
     '''
     Runs a test file
 
@@ -398,26 +398,6 @@ def run_test_file(filename, netns):
     if not filename.endswith(".t"):
         return 0, 0
 
-    if "libipt_" in filename:
-        iptables = IPTABLES
-    elif "libip6t_" in filename:
-        iptables = IP6TABLES
-    elif "libxt_"  in filename:
-        iptables = IPTABLES
-    elif "libarpt_" in filename:
-        # only supported with nf_tables backend
-        if EXECUTABLE != "xtables-nft-multi":
-           return 0, 0
-        iptables = ARPTABLES
-    elif "libebt_" in filename:
-        # only supported with nf_tables backend
-        if EXECUTABLE != "xtables-nft-multi":
-           return 0, 0
-        iptables = EBTABLES
-    else:
-        # default to iptables if not known prefix
-        iptables = IPTABLES
-
     fast_failed = False
     if fast_run_possible(filename):
         tests = run_test_file_fast(iptables, filename, netns)
@@ -511,6 +491,48 @@ def run_test_file(filename, netns):
     f.close()
     return tests, passed
 
+def run_test_file(filename, netns):
+    '''
+    Runs a test file
+
+    :param filename: name of the file with the test rules
+    :param netns: network namespace to perform test run in
+    '''
+    #
+    # if this is not a test file, skip.
+    #
+    if not filename.endswith(".t"):
+        return 0, 0
+
+    if "libipt_" in filename:
+        xtables = [ IPTABLES ]
+    elif "libip6t_" in filename:
+        xtables = [ IP6TABLES ]
+    elif "libxt_"  in filename:
+        xtables = [ IPTABLES, IP6TABLES ]
+    elif "libarpt_" in filename:
+        # only supported with nf_tables backend
+        if EXECUTABLE != "xtables-nft-multi":
+           return 0, 0
+        xtables = [ ARPTABLES ]
+    elif "libebt_" in filename:
+        # only supported with nf_tables backend
+        if EXECUTABLE != "xtables-nft-multi":
+           return 0, 0
+        xtables = [ EBTABLES ]
+    else:
+        # default to iptables if not known prefix
+        xtables = [ IPTABLES ]
+
+    tests = 0
+    passed = 0
+    for iptables in xtables:
+        file_tests, file_passed =  _run_test_file(iptables, filename, netns)
+        if file_tests:
+            tests += file_tests
+            passed += file_passed
+
+    return tests, passed
 
 def show_missing():
     '''
-- 
2.30.2

