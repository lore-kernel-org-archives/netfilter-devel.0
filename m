Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE6D19ABD8
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 09:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759914996; cv=none; b=W4MTxu5pvVtMGtAjRua/GBNFcOJG2IuxXFO6zmMhoOu8v0hKwiSB4lDYFL5IAaqNVPke2IT93cjaGZ9XCpEu11J2/eU/zHBkZQfuTl/xnqBmoQ6NgS1rZzUerfdXD5qfHwTkPiLKuvU9yQHcFX1/8wDSt72e7fwChmREu4wbgMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759914996; c=relaxed/simple;
	bh=nhq1CSiwSy+XrUssuMj2bY5nsAM6JHHeb9jZkEJ70Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sJ5WBED+Bd3DVSapiQ1bDLjVBOjvjrHKIjYpP75/DJXJLP8yGvs66XrWmX+qQWBN0zcf6kiVQDIzhtIMgj7c0redvkKkrxcdvj+qOnHxGjvD2Om1MVLMSDmfwghnyIdPxbI7TRG4pExkMBVvuQl8NctoSuTKUJHeWksoXf2NnUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EB6E960321; Wed,  8 Oct 2025 11:16:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add packetpath test for reject statement
Date: Wed,  8 Oct 2025 11:16:19 +0200
Message-ID: <20251008091621.23597-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test case for:
91a79b792204 ("netfilter: nf_reject: don't leak dst refcount for loopback packets")
and
db99b2f2b3e2 ("netfilter: nf_reject: don't reply to icmp error messages")

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/packetpath/reject_loopback      | 223 ++++++++++++++++++
 1 file changed, 223 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/reject_loopback

diff --git a/tests/shell/testcases/packetpath/reject_loopback b/tests/shell/testcases/packetpath/reject_loopback
new file mode 100755
index 000000000000..d199b1275f3f
--- /dev/null
+++ b/tests/shell/testcases/packetpath/reject_loopback
@@ -0,0 +1,223 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+
+# Tests reject functionality for both IPv4 and IPv6 with TCP and ICMP traffic on
+# the loopback interface.
+#
+# - check reject works, i.e. ping and connect fail
+# - check we don't reply to tcp resets with another tcp reset
+# - check we don't reply to icmp error with another icmp error
+
+ret=0
+port=14512
+
+ip link set lo up
+
+load_ruleset_netdev()
+{
+echo load netdev test ruleset
+$NFT -f -<<EOF
+table netdev t {
+	chain in {
+		type filter hook ingress device lo priority 0
+
+		ip protocol icmp counter reject
+		ip6 nexthdr icmpv6 counter reject
+		meta l4proto tcp counter reject with tcp reset
+	}
+}
+EOF
+}
+
+load_ruleset_inet()
+{
+echo load inet test ruleset
+$NFT -f -<<EOF
+table inet t {
+        chain in {
+                type filter hook prerouting priority filter; policy accept;
+                iifname lo jump {
+	                icmp type echo-request counter reject with icmp port-unreachable
+	                icmpv6 type echo-request counter reject with icmpv6 port-unreachable
+	                meta l4proto tcp tcp flags syn counter reject with tcp reset
+		}
+        }
+}
+EOF
+}
+
+# try to get nf_tables to reset tcp rest with tcp reset and
+# reject icmp port-unreach with port-unreach.
+# Should NOT be possible.
+# Note that this ruleset is nonsensical:
+# meta l4proto tcp ... reject with tcp reset, on loopback,
+# will drop the reset packet so the client times out.
+#
+# This isn't an issue for remote clients, as the reset
+# won't appear in prerouting.
+load_ruleset_inet_loop()
+{
+echo load inet loop ruleset
+$NFT -f -<<EOF
+table inet t {
+	counter tcprstc { }
+	counter icmp4c { }
+	counter icmp6c { }
+
+        chain in {
+                type filter hook prerouting priority filter; policy accept;
+                iifname lo jump {
+	                ip protocol icmp counter name icmp4c reject with icmp port-unreachable
+	                ip6 nexthdr icmpv6 counter name icmp6c reject with icmpv6 port-unreachable
+	                meta l4proto tcp counter name tcprstc reject with tcp reset
+		}
+        }
+}
+EOF
+}
+
+load_ruleset_netdev_loop()
+{
+echo load netdev loop ruleset
+$NFT -f -<<EOF
+table netdev t {
+	counter tcprstc { }
+	counter icmp4c { }
+	counter icmp6c { }
+
+        chain in {
+		type filter hook ingress device lo priority 0
+                ip protocol icmp counter name icmp4c reject with icmp port-unreachable
+                ip6 nexthdr icmpv6 counter name icmp6c reject with icmpv6 port-unreachable
+                meta l4proto tcp counter name tcprstc reject with tcp reset
+        }
+}
+EOF
+}
+
+check_counter()
+{
+	local family="$1"
+	local countername="$2"
+	local wanted_packetcount="$3"
+	local max_packetcount="$4"
+
+	echo "counter $family t $countername has $pcount packets"
+	if $NFT list counter "$family" "t" "$countername" | grep packets\ $wanted_packetcount;then
+		return
+	fi
+
+	# the _loop rulesets drop tcp resets, so we must tolerate retransmitted syns.
+	if [ "$max_packetcount" -gt 0 ];then
+		local pcount=$($NFT list counter "$family" "t" "$countername" | grep packets)
+
+		pcount=${pcount%bytes*}
+		pcount=${pcount#*packets}
+
+		if [ "$pcount" -gt 0 ] && [ "$pcount" -le "$max_packetcount" ];then
+			echo "Tolerated $pcount packets (max $max_packetcount)"
+			return
+		fi
+	fi
+
+	echo "Unexpected packetcount, expected $wanted_packetcount / max $max_packetcount"
+	$NFT list counter "$family" "t" "$countername"
+	ret=1
+}
+
+check_counters()
+{
+	local family="$1"
+
+	# one syn, one rst
+	check_counter "$family" tcprstc 4 16
+
+	# one for echo, one for dst-unreach
+	check_counter "$family" icmp4c 2 2
+	check_counter "$family" icmp6c 2 2
+}
+
+maybe_error()
+{
+	local ret="$1"
+	shift
+	local err_wanted="$1"
+	shift
+
+	local errmsg="$@"
+
+
+	if [ $ret -eq 0 ];then
+		errmsg="$errmsg succeeded"
+
+		if [ $err_wanted -ne 0 ]; then
+			echo "$errmsg but expected to fail"
+			ret=1
+			return
+		fi
+	else
+		errmsg="$errmsg failed ($ret)"
+
+		if [ $err_wanted -eq 0 ]; then
+			echo "$errmsg but expected to work"
+			ret=1
+			return
+		fi
+
+	fi
+}
+
+test_all()
+{
+	local err_wanted="$1"
+
+	ping -W 1 -q -c 1 127.0.0.1 > /dev/null
+	maybe_error $? "$err_wanted" "ping 127.0.0.1"
+
+	socat -u STDIN TCP-CONNECT:127.0.0.1:$port,connect-timeout=1 < /dev/null 2>/dev/null
+	maybe_error $? "$err_wanted" "connect 127.0.0.1"
+
+	ping -W 1 -q -c 1 ::1 > /dev/null
+	maybe_error $? "$err_wanted" "connect 127.0.0.1"
+
+	socat -u STDIN TCP-CONNECT:[::1]:$port,connect-timeout=1 < /dev/null 2>/dev/null
+	maybe_error $? "$err_wanted" "connect ::1"
+}
+
+# Start socat listeners in background
+timeout 10 socat TCP-LISTEN:$port,bind=127.0.0.1,reuseaddr PIPE &
+SOCAT_PID4=$!
+
+timeout 10 socat TCP6-LISTEN:$port,bind=::1,reuseaddr PIPE &
+SOCAT_PID6=$!
+
+# Give listeners time to start
+sleep 1
+
+# empty ruleset
+test_all 0
+
+load_ruleset_inet
+test_all 1
+$NFT delete table inet t
+
+load_ruleset_netdev
+test_all 1
+$NFT delete table netdev t
+
+load_ruleset_inet_loop
+test_all 1
+check_counters inet
+$NFT delete table inet t
+
+load_ruleset_netdev_loop
+test_all 1
+check_counters netdev
+$NFT delete table netdev t
+
+# Clean up listeners
+kill $SOCAT_PID4 $SOCAT_PID6 2>/dev/null
+
+echo "Exiting with $ret"
+exit $ret
-- 
2.49.1

