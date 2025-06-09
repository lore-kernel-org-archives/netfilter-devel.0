Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D71F4608
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Jun 2025 21:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749504924; cv=none; b=Cwhk++TFV5/oh5wxmoAmcYv6MB7UYGgVqCaKuTOnlavB4GMT9gTgArH400wtacRbKoJsvdrSiX/o0kNCeXmeC4ps/QSNw1LOjcTfaXBW400gBEzVubnrmS2xVPnnxmiYQ0gYRX97s86SBx7E9q9NS/LZLlcgljHGe70ZcvLfNWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749504924; c=relaxed/simple;
	bh=TBmoB4RS9TSybOkJq/jKxjzRN0qLjbDn56yxyqL9HK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBuj31NlHERnXrD4tIZL04L1NkgfrsjuDzzlQC4p71Z09euuBWN8XGZZIMo0Rj3NQ/VVWj/kp9FKf/mOUIDuTRqRtMLzE6pEhaCHE88Sbd98s4E6Q0dmLcOqDEO5mKJMxBG6GVoL8EdR+SaQEQqMYRroA5Q6OVULfl9YlZV1TsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4E43761284; Mon,  9 Jun 2025 23:35:19 +0200 (CEST)
Date: Mon, 9 Jun 2025 23:35:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] tests: shell: Add a test case for FTP helper combined
 with NAT.
Message-ID: <aEdTln3VvlQNgPXT@strlen.de>
References: <20250605103339.719169-1-yiche@redhat.com>
 <20250609081428.9219-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609081428.9219-1-yiche@redhat.com>

Yi Chen <yiche@redhat.com> wrote:
> This test verifies functionality of the FTP helper,
> for both passive, active FTP modes,
> and the functionality of the nf_nat_ftp module.

Thanks, I had to apply this delta to make this work for me, can
you check that it still passes on your end?

I guess nf_nat_ftp module is already loaded on
your system, its needed for all tests as the FTP server
is on a different address than what the client connectects to.

The important changes are:
 - load nf_nat_ftp early
 - use ${PCAP} for last tcpdump too, local dir isn't writeable
   in my virtme-ng setup.

Rest is debugging aid/cosmetic.  The curl feature check gets extended
to skip in case curl exists but was built with no ftp support.

I removed -s flag from curl, this also removes the error messages,
if any, which makes it harder to debug.  Its fine to have more
information available in case something goes wrong.

I now get:
  I: [OK]         1/1 tests/shell/testcases/packetpath/nat_ftp

No need to resend unless you want to make further enhancements.

diff --git a/tests/shell/features/curl.sh b/tests/shell/features/curl.sh
--- a/tests/shell/features/curl.sh
+++ b/tests/shell/features/curl.sh
@@ -1,4 +1,4 @@
 #!/bin/sh
 
-# check whether curl is installed
-curl -h >/dev/null 2>&1
+# check whether curl is installed and supports ftp
+curl --version | grep "^Protocols: "| grep -q " ftp"
diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -22,7 +22,10 @@ assert_pass()
 		echo "FAIL: ${@}"
 		ip netns exec $R nft list ruleset
 		tcpdump -nnr ${PCAP}
-		ip netns exec $R cat /proc/net/nf_conntrack
+		test -r /proc/net/nf_conntrack && ip netns exec $R cat /proc/net/nf_conntrack
+		ip netns exec $R conntrack -S
+		ip netns exec $R conntrack -L
+		ip netns exec $S ss -nitepal
 		exit 1
 	else
 		echo "PASS: ${@}"
@@ -43,6 +46,9 @@ PCAP="$WORKDIR/tcpdump.pcap"
 mkdir -p $WORKDIR
 assert_pass "mkdir $WORKDIR"
 
+modprobe nf_nat_ftp
+assert_pass "modprobe nf_nat_ftp. Needed for DNAT of data connection and active mode PORT change with SNAT"
+
 ip_sr=2001:db8:ffff:22::1
 ip_cr=2001:db8:ffff:21::2
 ip_rs=2001:db8:ffff:22::fffe
@@ -86,7 +92,7 @@ reload_ruleset()
 		chain PRE-dnat {
 			type nat hook prerouting priority dstnat; policy accept;
 			# Dnat the control connection, data connection will be automaticly NATed.
-			ip6 daddr ${ip_rc} ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
+			ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
 		}
 
 		chain PRE-aftnat {
@@ -103,7 +109,7 @@ reload_ruleset()
 
 		chain forward {
 			type filter hook forward priority filter; policy drop;
-			ip6 daddr ${ip_sr} tcp dport 21 ct state new counter accept
+			ip6 daddr ${ip_sr} counter tcp dport 21 ct state new counter accept
 			ip6 nexthdr tcp ct state established counter accept
 			ip6 nexthdr tcp ct state related     counter log accept
 		}
@@ -142,7 +148,7 @@ reload_ruleset
 ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
 pid=$!
 sleep 1
-ip netns exec $C curl -s --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
+ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
 assert_pass "curl ftp passive mode "
 
 cmp "$INFILE" "$OUTFILE"
@@ -155,19 +161,17 @@ assert_pass "assert FTP traffic NATed"
 
 # test active mode
 reload_ruleset
-modprobe nf_nat_ftp
-assert_pass "modprobe nf_nat_ftp. Active mode need it to modify the client ip in PORT command under SNAT"
 
-ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap 2> /dev/null &
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
 pid=$!
-ip netns exec $C curl -s -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
+ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
 assert_pass "curl ftp active mode "
 
 cmp "$INFILE" "$OUTFILE"
 assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
 
 kill $pid; sync
-tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
+tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
 assert_pass "assert FTP traffic NATed"
 
 # trap calls cleanup
