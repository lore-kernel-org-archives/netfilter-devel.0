Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3593126B0
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 20:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783627478; cv=none; b=OWuu6nJ7Z9HD6mEO4pDYHRtH4cglAKwrxMxeJgNq91s1UxtzpWYketaz8aIoaS5KSS87fIFgjqjNco5QZN0E5jE5fzSkyb+l0sGHFBAUAJ8KjzHnlGRBzt9fJ6a6U54QTaWbPV6/lUvll5VCY128vWjIQ3B1ZNIMU6yGgj9bkVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783627478; c=relaxed/simple;
	bh=fJ49/EkZcXS8hndYWJqswXkMAqI7vwDEIu2py4DjCZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0khXwOZ0N+1vbvD1MwsmOA96qlKjZ255wMp1oYAm/PLiVz3cqTIdNScizqftMrJR+CJ9cep2imlt37+4NylM5owwbthplqnvNKxLzx/jQ7R2nKUy8/eBTczrxJZ85JwERxAW6wOGN6XgDqeNSXmvbMHyq70U77SwYgblFhttDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 858DD602A9; Thu, 09 Jul 2026 22:04:35 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 7/7] tests: runtest.sh: add sendip emulation via scapy
Date: Thu,  9 Jul 2026 22:03:58 +0200
Message-ID: <20260709200358.15504-8-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709200358.15504-1-fw@strlen.de>
References: <20260709200358.15504-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sendip tool is ancient and not packaged on fedora (or i'm
blind).  Add a scapy-based replacement.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 README                     |  13 ++--
 tests/bitmap:ip.t          |   2 +-
 tests/check_sendip_packets |   2 +-
 tests/hash:ip.t            |   2 +-
 tests/runtest.sh           |  18 ++++-
 tests/sendip.py            | 154 +++++++++++++++++++++++++++++++++++++
 tests/sendip.sh            |   7 +-
 tests/setlist.t            |   2 +-
 8 files changed, 188 insertions(+), 12 deletions(-)
 create mode 100755 tests/sendip.py

diff --git a/README b/README
index 08b3598b6c0e..075ffd4ba991 100644
--- a/README
+++ b/README
@@ -41,12 +41,13 @@ instructions too.
    After installing the modules, you can run the testsuite as well.
    Please note, several assumptions must be met for the testsuite:
 
-	- no sets defined
-	- iptables/ip6tables rules are not set up
-	- the destination for kernel logs is /var/log/kern.log
-	- the networks 10.255.255.0/24 and 1002:1002:1002:1002::/64
-	  are not in use
-	- sendip utility is installed
+	- the destination for kernel logs is /var/log/kern.log, OR,
+	  if running from a network namespace, iptables -j LOG can
+	  write to the kernel ring buffer (dmesg).
+	- by default tests run in a extra namespace to avoid
+	  conflicts with the networks used by the tests:
+	  10.255.255.0/24 and 1002:1002:1002:1002::/64.
+	- sendip utility OR scapy is installed
 
    # make tests
 
diff --git a/tests/bitmap:ip.t b/tests/bitmap:ip.t
index 53034bbbae89..f97266450423 100644
--- a/tests/bitmap:ip.t
+++ b/tests/bitmap:ip.t
@@ -209,7 +209,7 @@
 # Counters and timeout: destroy set
 0 ipset x test
 # Counters: require sendip
-skip which sendip
+require_sendip
 # Counters: create set
 0 ipset n test bitmap:ip range 10.255.0.0/16 counters
 # Counters: add elemet with zero counters
diff --git a/tests/check_sendip_packets b/tests/check_sendip_packets
index 0dad3d0944d2..758f31d59dad 100755
--- a/tests/check_sendip_packets
+++ b/tests/check_sendip_packets
@@ -18,7 +18,7 @@ fi
 
 $cmd -A INPUT -m set --match-set test $2 -j DROP
 for x in `seq 1 $3`; do
-    sendip -p $proto -id $dst -is $src -p tcp -td 80 -ts 1025 $dst
+    ./sendip.sh -p $proto -id $dst -is $src -p tcp -td 80 -ts 1025 $dst
 done
 $cmd -D INPUT -m set --match-set test $2 -j DROP
 
diff --git a/tests/hash:ip.t b/tests/hash:ip.t
index 529e6b815069..88b36873b41d 100644
--- a/tests/hash:ip.t
+++ b/tests/hash:ip.t
@@ -195,7 +195,7 @@
 # Counters and timeout: destroy set
 0 ipset x test
 # Counters: require sendip
-skip which sendip
+require_sendip
 # Counters: create set
 0 ipset n test hash:ip counters
 # Counters: add elemet with zero counters
diff --git a/tests/runtest.sh b/tests/runtest.sh
index ba4683f59e5d..238175440cc4 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -51,6 +51,14 @@ LC_ALL=C
 export LC_ALL
 export IPSET_TMP="$tmpdir"
 
+HAVE_SENDIP=n
+[ -z "`which sendip`" ] && HAVE_SENDIP=y
+if [ $HAVE_SENDIP = "n" ]; then
+	if python -c 'from scapy.all import ( IPv6 )'; then
+		HAVE_SENDIP=y
+	fi
+fi
+
 add_tests() {
 	# inet|inet6 network
 	if [ $1 = "inet" ]; then
@@ -72,7 +80,7 @@ add_tests() {
 	fi
 	if [ `$cmd -t filter | wc -l` -eq 7 -a \
 	     `$cmd -t filter | grep ACCEPT | wc -l` -eq 3 ]; then
-	     	if [ -z "`which sendip`" ]; then
+		if [ "$HAVE_SENDIP" = "n" ]; then
 	     		echo "sendip utility is missig: skipping $1 match and target tests"
 	     		return
 	     	elif [ -n "`which ss`" ]; then
@@ -130,6 +138,14 @@ for types in $tests; do
 	    	fi
 	    	continue
 	    	;;
+	    require_sendip)
+		if [ "$HAVE_SENDIP" = "y" ]; then
+			continue
+		else
+			echo "Skipping, sendip (scapy) not available"
+			break
+		fi
+		;;
 	    *)
 		;;
 	esac
diff --git a/tests/sendip.py b/tests/sendip.py
new file mode 100755
index 000000000000..61191f485b26
--- /dev/null
+++ b/tests/sendip.py
@@ -0,0 +1,154 @@
+#!/usr/bin/env python3
+"""Minimal replacement for sendip via scapy. sends one packet."""
+
+import errno
+import os
+import socket
+import sys
+from scapy.all import (
+    send,
+    IP, IPv6,
+    TCP, UDP, ICMP,
+    ICMPv6DestUnreach, ICMPv6TimeExceeded, ICMPv6ParamProblem,
+    Raw,
+)
+from scapy.layers.inet6 import ICMPv6Unknown
+
+_LOOPBACK = {'127.0.0.1', '::1'}
+
+def parse_args(argv):
+    p = {
+        'ip_version': None,
+        'transport': None,
+        'src': None,
+        'dst': None,
+        'sport': None,
+        'dport': None,
+        'icmp_type': None,
+        'icmp_code': None,
+        'payload_size': 0,
+    }
+
+    i = 0
+    while i < len(argv):
+        a = argv[i]
+        if a == '-p':
+            proto = argv[i + 1]; i += 2
+            if proto in ('ipv4', 'ipv6'):
+                p['ip_version'] = proto
+            elif proto in ('tcp', 'udp', 'icmp'):
+                p['transport'] = proto
+            else:
+                sys.exit(f'unknown protocol: {proto}')
+        elif a == '-is':
+            p['src'] = argv[i + 1]; i += 2
+        elif a == '-id':
+            p['dst'] = argv[i + 1]; i += 2
+        elif a == '-6s':
+            p['src'] = argv[i + 1]; i += 2
+        elif a == '-6d':
+            p['dst'] = argv[i + 1]; i += 2
+        elif a == '-ts':
+            p['sport'] = int(argv[i + 1]); i += 2
+        elif a == '-td':
+            p['dport'] = int(argv[i + 1]); i += 2
+        elif a == '-us':
+            p['sport'] = int(argv[i + 1]); i += 2
+        elif a == '-ud':
+            p['dport'] = int(argv[i + 1]); i += 2
+        elif a == '-ct':
+            p['icmp_type'] = int(argv[i + 1]); i += 2
+        elif a == '-cd':
+            p['icmp_code'] = int(argv[i + 1]); i += 2
+        elif a == '-d':
+            # e.g. "r10" = 10 random bytes of payload
+            spec = argv[i + 1]; i += 2
+            if spec.startswith('r'):
+                p['payload_size'] = int(spec[1:])
+        elif not a.startswith('-'):
+            i += 1  # positional: routing dest, scapy routes by dst in header
+        else:
+            i += 1
+
+    return p
+
+
+_ICMPV6_CLASS = {
+    1: ICMPv6DestUnreach,
+    3: ICMPv6TimeExceeded,
+    4: ICMPv6ParamProblem,
+}
+
+
+def make_icmpv6(typ, code):
+    cls = _ICMPV6_CLASS.get(typ, ICMPv6Unknown)
+    pkt = cls(code=code)
+    if cls is ICMPv6Unknown:
+        pkt.type = typ
+    return pkt
+
+
+def build_packet(p):
+    if p['ip_version'] == 'ipv4':
+        ip = IP(src=p['src'], dst=p['dst'])
+    elif p['ip_version'] == 'ipv6':
+        ip = IPv6(src=p['src'], dst=p['dst'])
+    else:
+        sys.exit('no IP version specified')
+
+    t = p['transport']
+    if t == 'tcp':
+        l4 = TCP(sport=p['sport'], dport=p['dport'])
+    elif t == 'udp':
+        l4 = UDP(sport=p['sport'], dport=p['dport'])
+    elif t == 'icmp':
+        typ, code = p['icmp_type'], p['icmp_code']
+        if p['ip_version'] == 'ipv4':
+            l4 = ICMP(type=typ, code=code)
+        else:
+            l4 = make_icmpv6(typ, code)
+    else:
+        sys.exit('no transport protocol specified')
+
+    pkt = ip / l4
+    if p['payload_size'] > 0:
+        pkt = pkt / Raw(os.urandom(p['payload_size']))
+    return pkt
+
+
+def send_on_iface(pkt, dst, iface):
+    """Send via AF_INET(6) SOCK_RAW with SO_BINDTODEVICE.
+
+    The packet originates locally and traverses the OUTPUT netfilter chain,
+    matching the iptables rules under test.  No ARP on dummy interfaces.
+    """
+    is_ipv6 = IPv6 in pkt
+    if is_ipv6:
+        sock = socket.socket(socket.AF_INET6, socket.SOCK_RAW,
+                             socket.IPPROTO_RAW)
+        dst_addr = (dst, 0, 0, 0)
+    else:
+        sock = socket.socket(socket.AF_INET, socket.SOCK_RAW,
+                             socket.IPPROTO_RAW)
+        dst_addr = (dst, 0)
+    try:
+        sock.sendto(bytes(pkt), dst_addr)
+    except OSError as e:
+        if e.errno != errno.EPERM:
+            raise
+    finally:
+        sock.close()
+
+
+def main():
+    p = parse_args(sys.argv[1:])
+    iface = None if p['dst'] in _LOOPBACK else 'eth0'
+    pkt = build_packet(p)
+    if p['dst'] in _LOOPBACK:
+        send(pkt, verbose=False)
+    else:
+        send_on_iface(pkt, p['dst'], 'eth0')
+
+
+if __name__ == '__main__':
+    main()
diff --git a/tests/sendip.sh b/tests/sendip.sh
index d1f8ebe4d75b..cd65227f2ae6 100755
--- a/tests/sendip.sh
+++ b/tests/sendip.sh
@@ -2,4 +2,9 @@
 
 # Save lineno for checking
 wc -l /var/log/kern.log 2>/dev/null | cut -d ' ' -f 1 > "$IPSET_TMP/.loglines"
-sendip "$@"
+
+if [ -n "`which sendip 2>/dev/null`" ]; then
+	exec sendip "$@"
+fi
+
+exec ./sendip.py "$@"
diff --git a/tests/setlist.t b/tests/setlist.t
index c1f1d3b44816..0edebfced72d 100644
--- a/tests/setlist.t
+++ b/tests/setlist.t
@@ -174,7 +174,7 @@
 # Counters and timeout: destroy sets
 0 ipset x
 # Counters: require sendip
-skip which sendip >/dev/null
+require_sendip
 # Counters: create set
 0 ipset n a hash:ip counters
 # Counters: create list set
-- 
2.54.0

