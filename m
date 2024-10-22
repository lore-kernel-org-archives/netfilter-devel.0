Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67881B86D5
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729611051; cv=none; b=H8wdkc+x8oDPc9pn+BtJi3gI87ds558uksQ612UOIk0wWcr7xLxWXiR3sAfjxD41icDdxLvo6ghMHr4VfMr0KtwI/XtnRUEnoYUyhcemNNxgHa61UWw5KLrBgFsYcTKp1LtbK/0RzawEwqOBEgmutYv25itpLfaIRdbW3iIkGlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729611051; c=relaxed/simple;
	bh=UNsKr/tpTDK9FjI3O4qyqGM/cXpOPq5qYyYPu0rNHWc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZfHg2nAXjJXQHTSEkXPoxBdyjZrbFArs+3tWDj2sylt57tTXE7i/gLhwX+hzy4PAmm6rcgcoX4YgTtTS2fqozQZ0prPm4pQDQkQqdufGQwI+XgyY2Y2jy64ppfC0gbQRBfrilDc+TjDpiIio5jRjTuZE4lDjGLrmquXs0LbrjZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	fw@strlen.de
Subject: [PATCH iptables,v3] tests: iptables-test: extend coverage for ip6tables
Date: Tue, 22 Oct 2024 17:30:42 +0200
Message-Id: <20241022153042.214643-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update iptables-test.py to run libxt_*.t both for iptables and
ip6tables. For libxt_*.t tests, display result only once after last run
test run (usually ip6tables), so no two result lines are printed. This
update requires changes in the existing tests.

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
v3: - consolidate common tests in libxt_*.t files, per Phil Sutter
    - print test result only once when successful, per Phil Sutter

 extensions/libip6t_TEE.t                      |  3 +
 extensions/libip6t_TPROXY.t                   |  5 ++
 extensions/libip6t_connlimit.t                | 16 +++++
 extensions/libip6t_conntrack.t                |  5 ++
 extensions/libip6t_iprange.t                  | 10 +++
 extensions/libip6t_ipvs.t                     |  4 ++
 extensions/libip6t_policy.t                   |  4 ++
 extensions/libip6t_recent.t                   | 10 +++
 extensions/libipt_TEE.t                       |  3 +
 .../{libxt_TPROXY.t => libipt_TPROXY.t}       |  0
 extensions/libipt_connlimit.t                 | 11 +++
 extensions/libipt_conntrack.t                 |  5 ++
 extensions/libipt_iprange.t                   | 10 +++
 extensions/libipt_ipvs.t                      |  4 ++
 extensions/{libxt_osf.t => libipt_osf.t}      |  0
 extensions/libipt_policy.t                    |  4 ++
 extensions/libipt_recent.t                    | 10 +++
 extensions/libipt_standard.t                  | 21 ++++++
 extensions/libxt_TEE.t                        |  2 -
 extensions/libxt_connlimit.t                  | 10 ---
 extensions/libxt_conntrack.t                  |  4 --
 extensions/libxt_iprange.t                    |  9 ---
 extensions/libxt_ipvs.t                       |  3 -
 extensions/libxt_mark.t                       |  2 +-
 extensions/libxt_policy.t                     |  3 -
 extensions/libxt_recent.t                     |  9 ---
 extensions/libxt_standard.t                   | 19 -----
 iptables-test.py                              | 72 +++++++++++++------
 28 files changed, 175 insertions(+), 83 deletions(-)
 create mode 100644 extensions/libip6t_TEE.t
 create mode 100644 extensions/libip6t_TPROXY.t
 create mode 100644 extensions/libip6t_connlimit.t
 create mode 100644 extensions/libip6t_conntrack.t
 create mode 100644 extensions/libip6t_iprange.t
 create mode 100644 extensions/libip6t_ipvs.t
 create mode 100644 extensions/libip6t_policy.t
 create mode 100644 extensions/libip6t_recent.t
 create mode 100644 extensions/libipt_TEE.t
 rename extensions/{libxt_TPROXY.t => libipt_TPROXY.t} (100%)
 create mode 100644 extensions/libipt_connlimit.t
 create mode 100644 extensions/libipt_conntrack.t
 create mode 100644 extensions/libipt_iprange.t
 create mode 100644 extensions/libipt_ipvs.t
 rename extensions/{libxt_osf.t => libipt_osf.t} (100%)
 create mode 100644 extensions/libipt_policy.t
 create mode 100644 extensions/libipt_recent.t
 create mode 100644 extensions/libipt_standard.t

diff --git a/extensions/libip6t_TEE.t b/extensions/libip6t_TEE.t
new file mode 100644
index 000000000000..8e668290280e
--- /dev/null
+++ b/extensions/libip6t_TEE.t
@@ -0,0 +1,3 @@
+:INPUT,FORWARD,OUTPUT
+-j TEE --gateway 2001:db8::1;=;OK
+-j TEE ! --gateway 2001:db8::1;;FAIL
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
index 000000000000..462d4e619bb6
--- /dev/null
+++ b/extensions/libip6t_conntrack.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD,OUTPUT
+-m conntrack --ctorigsrc 2001:db8::1;=;OK
+-m conntrack --ctorigdst 2001:db8::1;=;OK
+-m conntrack --ctreplsrc 2001:db8::1;=;OK
+-m conntrack --ctrepldst 2001:db8::1;=;OK
diff --git a/extensions/libip6t_iprange.t b/extensions/libip6t_iprange.t
new file mode 100644
index 000000000000..b98f2c29539b
--- /dev/null
+++ b/extensions/libip6t_iprange.t
@@ -0,0 +1,10 @@
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
diff --git a/extensions/libip6t_ipvs.t b/extensions/libip6t_ipvs.t
new file mode 100644
index 000000000000..ff7d9d81ba9e
--- /dev/null
+++ b/extensions/libip6t_ipvs.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m ipvs --vaddr 2001:db8::1;=;OK
+-m ipvs ! --vaddr 2001:db8::/64;=;OK
+-m ipvs --vproto 6 --vaddr 2001:db8::/64 --vport 22 --vdir ORIGINAL --vmethod GATE;=;OK
diff --git a/extensions/libip6t_policy.t b/extensions/libip6t_policy.t
new file mode 100644
index 000000000000..06ed71b5c4ff
--- /dev/null
+++ b/extensions/libip6t_policy.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --mode tunnel --tunnel-dst 2001:db8::/32 --tunnel-src 2001:db8::/32 --next --reqid 2;=;OK
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --tunnel-dst 2001:db8::/32;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp --mode tunnel --tunnel-dst 2001:db8::/32 --tunnel-src 2001:db8::/32 --next --reqid 2;=;OK
diff --git a/extensions/libip6t_recent.t b/extensions/libip6t_recent.t
new file mode 100644
index 000000000000..55ae8dd5f526
--- /dev/null
+++ b/extensions/libip6t_recent.t
@@ -0,0 +1,10 @@
+:INPUT,FORWARD,OUTPUT
+-m recent --set;-m recent --set --name DEFAULT --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;OK
+-m recent --rcheck --hitcount 8 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --rcheck --hitcount 12 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;OK
+-m recent --rcheck --hitcount 65536 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;;FAIL
+# nonsensical, but all should load successfully:
+-m recent --rcheck --hitcount 3 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource -m recent --rcheck --hitcount 4 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --rcheck --hitcount 4 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource -m recent --rcheck --hitcount 4 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
+-m recent --rcheck --hitcount 8 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource -m recent --rcheck --hitcount 12 --name foo --mask ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff --rsource;=;OK
diff --git a/extensions/libipt_TEE.t b/extensions/libipt_TEE.t
new file mode 100644
index 000000000000..23dceada5e3b
--- /dev/null
+++ b/extensions/libipt_TEE.t
@@ -0,0 +1,3 @@
+:INPUT,FORWARD,OUTPUT
+-j TEE --gateway 1.1.1.1;=;OK
+-j TEE ! --gateway 1.1.1.1;;FAIL
diff --git a/extensions/libxt_TPROXY.t b/extensions/libipt_TPROXY.t
similarity index 100%
rename from extensions/libxt_TPROXY.t
rename to extensions/libipt_TPROXY.t
diff --git a/extensions/libipt_connlimit.t b/extensions/libipt_connlimit.t
new file mode 100644
index 000000000000..245a47849e73
--- /dev/null
+++ b/extensions/libipt_connlimit.t
@@ -0,0 +1,11 @@
+:INPUT,FORWARD,OUTPUT
+-m connlimit --connlimit-upto 0;-m connlimit --connlimit-upto 0 --connlimit-mask 32 --connlimit-saddr;OK
+-m connlimit --connlimit-upto 4294967295 --connlimit-mask 32 --connlimit-saddr;=;OK
+-m connlimit --connlimit-upto 4294967296 --connlimit-mask 32 --connlimit-saddr;;FAIL
+-m connlimit --connlimit-above 0;-m connlimit --connlimit-above 0 --connlimit-mask 32 --connlimit-saddr;OK
+-m connlimit --connlimit-above 4294967295 --connlimit-mask 32 --connlimit-saddr;=;OK
+-m connlimit --connlimit-above 4294967296 --connlimit-mask 32 --connlimit-saddr;;FAIL
+-m connlimit --connlimit-above 10 --connlimit-saddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;OK
+-m connlimit --connlimit-above 10 --connlimit-daddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-daddr;OK
+-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;=;OK
+-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-daddr;=;OK
diff --git a/extensions/libipt_conntrack.t b/extensions/libipt_conntrack.t
new file mode 100644
index 000000000000..d70ab71fe957
--- /dev/null
+++ b/extensions/libipt_conntrack.t
@@ -0,0 +1,5 @@
+:INPUT,FORWARD,OUTPUT
+-m conntrack --ctorigsrc 1.1.1.1;=;OK
+-m conntrack --ctorigdst 1.1.1.1;=;OK
+-m conntrack --ctreplsrc 1.1.1.1;=;OK
+-m conntrack --ctrepldst 1.1.1.1;=;OK
diff --git a/extensions/libipt_iprange.t b/extensions/libipt_iprange.t
new file mode 100644
index 000000000000..8b4434176e5d
--- /dev/null
+++ b/extensions/libipt_iprange.t
@@ -0,0 +1,10 @@
+:INPUT,FORWARD,OUTPUT
+-m iprange --src-range 1.1.1.1-1.1.1.10;=;OK
+-m iprange ! --src-range 1.1.1.1-1.1.1.10;=;OK
+-m iprange --dst-range 1.1.1.1-1.1.1.10;=;OK
+-m iprange ! --dst-range 1.1.1.1-1.1.1.10;=;OK
+# it shows -A INPUT -m iprange --src-range 1.1.1.1-1.1.1.1, should we support this?
+# ERROR: should fail: iptables -A INPUT -m iprange --src-range 1.1.1.1
+# -m iprange --src-range 1.1.1.1;;FAIL
+# ERROR: should fail: iptables -A INPUT -m iprange --dst-range 1.1.1.1
+#-m iprange --dst-range 1.1.1.1;;FAIL
diff --git a/extensions/libipt_ipvs.t b/extensions/libipt_ipvs.t
new file mode 100644
index 000000000000..bb23ccf2462a
--- /dev/null
+++ b/extensions/libipt_ipvs.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD,OUTPUT
+-m ipvs --vaddr 1.2.3.4;=;OK
+-m ipvs ! --vaddr 1.2.3.4/255.255.255.0;-m ipvs ! --vaddr 1.2.3.4/24;OK
+-m ipvs --vproto 6 --vaddr 1.2.3.4/16 --vport 22 --vdir ORIGINAL --vmethod GATE;=;OK
diff --git a/extensions/libxt_osf.t b/extensions/libipt_osf.t
similarity index 100%
rename from extensions/libxt_osf.t
rename to extensions/libipt_osf.t
diff --git a/extensions/libipt_policy.t b/extensions/libipt_policy.t
new file mode 100644
index 000000000000..1fa3dcfd096b
--- /dev/null
+++ b/extensions/libipt_policy.t
@@ -0,0 +1,4 @@
+:INPUT,FORWARD
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --tunnel-dst 10.0.0.0/8;;FAIL
+-m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
diff --git a/extensions/libipt_recent.t b/extensions/libipt_recent.t
new file mode 100644
index 000000000000..764a415d4c6b
--- /dev/null
+++ b/extensions/libipt_recent.t
@@ -0,0 +1,10 @@
+:INPUT,FORWARD,OUTPUT
+-m recent --set;-m recent --set --name DEFAULT --mask 255.255.255.255 --rsource;OK
+-m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask 255.255.255.255 --rsource;OK
+-m recent --rcheck --hitcount 65536 --name foo --mask 255.255.255.255 --rsource;;FAIL
+# nonsensical, but all should load successfully:
+-m recent --rcheck --hitcount 3 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
diff --git a/extensions/libipt_standard.t b/extensions/libipt_standard.t
new file mode 100644
index 000000000000..4eb144d1cc30
--- /dev/null
+++ b/extensions/libipt_standard.t
@@ -0,0 +1,21 @@
+:INPUT,FORWARD,OUTPUT
+-s 127.0.0.1/32 -d 0.0.0.0/8 -j DROP;=;OK
+! -s 0.0.0.0 -j ACCEPT;! -s 0.0.0.0/32 -j ACCEPT;OK
+! -d 0.0.0.0/32 -j ACCEPT;=;OK
+-s 0.0.0.0/24 -j RETURN;=;OK
+-s 10.11.12.13/8;-s 10.0.0.0/8;OK
+-s 10.11.12.13/9;-s 10.0.0.0/9;OK
+-s 10.11.12.13/10;-s 10.0.0.0/10;OK
+-s 10.11.12.13/11;-s 10.0.0.0/11;OK
+-s 10.11.12.13/12;-s 10.0.0.0/12;OK
+-s 10.11.12.13/30;-s 10.11.12.12/30;OK
+-s 10.11.12.13/31;-s 10.11.12.12/31;OK
+-s 10.11.12.13/32;-s 10.11.12.13/32;OK
+-s 10.11.12.13/255.0.0.0;-s 10.0.0.0/8;OK
+-s 10.11.12.13/255.128.0.0;-s 10.0.0.0/9;OK
+-s 10.11.12.13/255.0.255.0;-s 10.0.12.0/255.0.255.0;OK
+-s 10.11.12.13/255.0.12.0;-s 10.0.12.0/255.0.12.0;OK
+:FORWARD
+--protocol=tcp --source=1.2.3.4 --destination=5.6.7.8/32 --in-interface=eth0 --out-interface=eth1 --jump=ACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
+-ptcp -s1.2.3.4 -d5.6.7.8/32 -ieth0 -oeth1 -jACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
+-i + -d 1.2.3.4;-d 1.2.3.4/32;OK
diff --git a/extensions/libxt_TEE.t b/extensions/libxt_TEE.t
index ce8b103e0dc2..3c7b929cac4c 100644
--- a/extensions/libxt_TEE.t
+++ b/extensions/libxt_TEE.t
@@ -1,4 +1,2 @@
 :INPUT,FORWARD,OUTPUT
--j TEE --gateway 1.1.1.1;=;OK
--j TEE ! --gateway 1.1.1.1;;FAIL
 -j TEE;;FAIL
diff --git a/extensions/libxt_connlimit.t b/extensions/libxt_connlimit.t
index 366cea745c65..79d08748a4cf 100644
--- a/extensions/libxt_connlimit.t
+++ b/extensions/libxt_connlimit.t
@@ -1,16 +1,6 @@
 :INPUT,FORWARD,OUTPUT
--m connlimit --connlimit-upto 0;-m connlimit --connlimit-upto 0 --connlimit-mask 32 --connlimit-saddr;OK
--m connlimit --connlimit-upto 4294967295 --connlimit-mask 32 --connlimit-saddr;=;OK
--m connlimit --connlimit-upto 4294967296 --connlimit-mask 32 --connlimit-saddr;;FAIL
 -m connlimit --connlimit-upto -1;;FAIL
--m connlimit --connlimit-above 0;-m connlimit --connlimit-above 0 --connlimit-mask 32 --connlimit-saddr;OK
--m connlimit --connlimit-above 4294967295 --connlimit-mask 32 --connlimit-saddr;=;OK
--m connlimit --connlimit-above 4294967296 --connlimit-mask 32 --connlimit-saddr;;FAIL
 -m connlimit --connlimit-above -1;;FAIL
 -m connlimit --connlimit-upto 1 --conlimit-above 1;;FAIL
--m connlimit --connlimit-above 10 --connlimit-saddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;OK
--m connlimit --connlimit-above 10 --connlimit-daddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-daddr;OK
 -m connlimit --connlimit-above 10 --connlimit-saddr --connlimit-daddr;;FAIL
--m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;=;OK
--m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-daddr;=;OK
 -m connlimit;;FAIL
diff --git a/extensions/libxt_conntrack.t b/extensions/libxt_conntrack.t
index 5e27ddce4fe6..2377a0168d77 100644
--- a/extensions/libxt_conntrack.t
+++ b/extensions/libxt_conntrack.t
@@ -8,10 +8,6 @@
 -m conntrack --ctstate wrong;;FAIL
 # should we convert this to output "tcp" instead of 6?
 -m conntrack --ctproto tcp;-m conntrack --ctproto 6;OK
--m conntrack --ctorigsrc 1.1.1.1;=;OK
--m conntrack --ctorigdst 1.1.1.1;=;OK
--m conntrack --ctreplsrc 1.1.1.1;=;OK
--m conntrack --ctrepldst 1.1.1.1;=;OK
 -m conntrack --ctexpire 0;=;OK
 -m conntrack --ctexpire 4294967295;=;OK
 -m conntrack --ctexpire 0:4294967295;=;OK
diff --git a/extensions/libxt_iprange.t b/extensions/libxt_iprange.t
index 6fd98be65602..83a67d117ed3 100644
--- a/extensions/libxt_iprange.t
+++ b/extensions/libxt_iprange.t
@@ -1,11 +1,2 @@
 :INPUT,FORWARD,OUTPUT
--m iprange --src-range 1.1.1.1-1.1.1.10;=;OK
--m iprange ! --src-range 1.1.1.1-1.1.1.10;=;OK
--m iprange --dst-range 1.1.1.1-1.1.1.10;=;OK
--m iprange ! --dst-range 1.1.1.1-1.1.1.10;=;OK
-# it shows -A INPUT -m iprange --src-range 1.1.1.1-1.1.1.1, should we support this?
-# ERROR: should fail: iptables -A INPUT -m iprange --src-range 1.1.1.1
-# -m iprange --src-range 1.1.1.1;;FAIL
-# ERROR: should fail: iptables -A INPUT -m iprange --dst-range 1.1.1.1
-#-m iprange --dst-range 1.1.1.1;;FAIL
 -m iprange;;FAIL
diff --git a/extensions/libxt_ipvs.t b/extensions/libxt_ipvs.t
index c2acc6668d1b..a76a69670d89 100644
--- a/extensions/libxt_ipvs.t
+++ b/extensions/libxt_ipvs.t
@@ -4,8 +4,6 @@
 -m ipvs --vproto tcp;-m ipvs --vproto 6;OK
 -m ipvs ! --vproto TCP;-m ipvs ! --vproto 6;OK
 -m ipvs --vproto 23;=;OK
--m ipvs --vaddr 1.2.3.4;=;OK
--m ipvs ! --vaddr 1.2.3.4/255.255.255.0;-m ipvs ! --vaddr 1.2.3.4/24;OK
 -m ipvs --vport http;-m ipvs --vport 80;OK
 -m ipvs ! --vport ssh;-m ipvs ! --vport 22;OK
 -m ipvs --vport 22;=;OK
@@ -17,4 +15,3 @@
 -m ipvs --vmethod MASQ;=;OK
 -m ipvs --vportctl 21;=;OK
 -m ipvs ! --vportctl 21;=;OK
--m ipvs --vproto 6 --vaddr 1.2.3.4/16 --vport 22 --vdir ORIGINAL --vmethod GATE;=;OK
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
diff --git a/extensions/libxt_policy.t b/extensions/libxt_policy.t
index 6524122bcf79..fea708bbd930 100644
--- a/extensions/libxt_policy.t
+++ b/extensions/libxt_policy.t
@@ -3,6 +3,3 @@
 -m policy --dir in --pol ipsec --proto ipcomp;=;OK
 -m policy --dir in --pol ipsec --strict;;FAIL
 -m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp;=;OK
--m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
--m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto esp --tunnel-dst 10.0.0.0/8;;FAIL
--m policy --dir in --pol ipsec --strict --reqid 1 --spi 0x1 --proto ipcomp --mode tunnel --tunnel-dst 10.0.0.0/8 --tunnel-src 10.0.0.0/8 --next --reqid 2;=;OK
diff --git a/extensions/libxt_recent.t b/extensions/libxt_recent.t
index 3b0dd9fa29c9..6c2cbd23f6fb 100644
--- a/extensions/libxt_recent.t
+++ b/extensions/libxt_recent.t
@@ -1,11 +1,2 @@
 :INPUT,FORWARD,OUTPUT
--m recent --set;-m recent --set --name DEFAULT --mask 255.255.255.255 --rsource;OK
--m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask 255.255.255.255 --rsource;OK
 -m recent --set --rttl;;FAIL
--m recent --rcheck --hitcount 65536 --name foo --mask 255.255.255.255 --rsource;;FAIL
-# nonsensical, but all should load successfully:
--m recent --rcheck --hitcount 3 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
diff --git a/extensions/libxt_standard.t b/extensions/libxt_standard.t
index 7c83cfa3ba23..947e92afd930 100644
--- a/extensions/libxt_standard.t
+++ b/extensions/libxt_standard.t
@@ -1,28 +1,9 @@
 :INPUT,FORWARD,OUTPUT
--s 127.0.0.1/32 -d 0.0.0.0/8 -j DROP;=;OK
-! -s 0.0.0.0 -j ACCEPT;! -s 0.0.0.0/32 -j ACCEPT;OK
-! -d 0.0.0.0/32 -j ACCEPT;=;OK
--s 0.0.0.0/24 -j RETURN;=;OK
 -p tcp -j ACCEPT;=;OK
 ! -p udp -j ACCEPT;=;OK
 -j DROP;=;OK
 -j ACCEPT;=;OK
 -j RETURN;=;OK
 ! -p 0 -j ACCEPT;=;FAIL
--s 10.11.12.13/8;-s 10.0.0.0/8;OK
--s 10.11.12.13/9;-s 10.0.0.0/9;OK
--s 10.11.12.13/10;-s 10.0.0.0/10;OK
--s 10.11.12.13/11;-s 10.0.0.0/11;OK
--s 10.11.12.13/12;-s 10.0.0.0/12;OK
--s 10.11.12.13/30;-s 10.11.12.12/30;OK
--s 10.11.12.13/31;-s 10.11.12.12/31;OK
--s 10.11.12.13/32;-s 10.11.12.13/32;OK
--s 10.11.12.13/255.0.0.0;-s 10.0.0.0/8;OK
--s 10.11.12.13/255.128.0.0;-s 10.0.0.0/9;OK
--s 10.11.12.13/255.0.255.0;-s 10.0.12.0/255.0.255.0;OK
--s 10.11.12.13/255.0.12.0;-s 10.0.12.0/255.0.12.0;OK
 :FORWARD
---protocol=tcp --source=1.2.3.4 --destination=5.6.7.8/32 --in-interface=eth0 --out-interface=eth1 --jump=ACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
--ptcp -s1.2.3.4 -d5.6.7.8/32 -ieth0 -oeth1 -jACCEPT;-s 1.2.3.4/32 -d 5.6.7.8/32 -i eth0 -o eth1 -p tcp -j ACCEPT;OK
--i + -d 1.2.3.4;-d 1.2.3.4/32;OK
 -i + -p tcp;-p tcp;OK
diff --git a/iptables-test.py b/iptables-test.py
index 77278925d721..3f77d1ec2fdc 100755
--- a/iptables-test.py
+++ b/iptables-test.py
@@ -385,7 +385,7 @@ def run_test_file_fast(iptables, filename, netns):
 
     return tests
 
-def run_test_file(filename, netns):
+def _run_test_file(iptables, filename, netns, print_result):
     '''
     Runs a test file
 
@@ -398,30 +398,10 @@ def run_test_file(filename, netns):
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
-        if tests > 0:
+        if tests > 0 and print_result:
             print(filename + ": " + maybe_colored('green', "OK", STDOUT_IS_TTY))
             return tests, tests
         fast_failed = True
@@ -502,7 +482,7 @@ def run_test_file(filename, netns):
 
     if netns:
         execute_cmd("ip netns del " + netns, filename)
-    if total_test_passed:
+    if total_test_passed and print_result:
         suffix = ""
         if fast_failed:
             suffix = maybe_colored('red', " but fast mode failed!", STDOUT_IS_TTY)
@@ -511,6 +491,52 @@ def run_test_file(filename, netns):
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
+    print_result = False
+    for index, iptables in enumerate(xtables):
+        if index == len(xtables) - 1:
+            print_result = True
+
+        file_tests, file_passed = _run_test_file(iptables, filename, netns, print_result)
+        if file_tests:
+            tests += file_tests
+            passed += file_passed
+
+    return tests, passed
 
 def show_missing():
     '''
-- 
2.30.2

