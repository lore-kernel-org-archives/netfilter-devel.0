Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D423C17
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Jun 2025 10:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749120561; cv=none; b=osd+I01pkPXKtFK0UW4Z2I9W6366/AgUKHxYX+BTAxEgNmqcYLTobehQfkTP/X0n19L0LnkJjUeIyf7zHzJ3krifd5v0HISHjEmSYOxMwv+LNgapDDL4IyIJ00lRonZGTZEzFHDMx/MTZNAUJuV+gJbm5JTlEnecMDdigUJkeds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749120561; c=relaxed/simple;
	bh=YN0hJoHSso/agPxjaaJXv205Q0lhXCTqwSsMgNDPGiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jx1KpgLzFIoqyrx7aJfLSwPgaM0E4ml3I0mn7hu0jMdOKDhCuBvoqJobLrbUWWsd5fzzG4Cil+UudpBXb0PP280TlGF2l6nzZIZmfiBUTXW24PCeJEM672VBqIN1mJY7xRO/fZCJQv5U5e5BaOkv0BjCqQZlyE1QSK7HKdJvCZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ffOEQvdt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ffOEQvdt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749120557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJcwcRhKk3YrvP+IhsWgbBiVzLwM38/WoYz7CsxXgKg=;
	b=ffOEQvdtxGSMs8BZRFm1n+kitpZ4bTbohxsNftaBtQG1Nj9loIpKblI4wAYaDgHusISy5b
	sUSAUlETHouRTQ69mac3w0M8uO0AUFYceV74eMRqi9ZqKwd3Y+WJ2Bd1bhqdj3x9d8Zzb3
	aJ0i+07i09yQNrBg47dtXQgbCrih7B4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-C7vB7va0Opya1q7ruE2uFw-1; Thu,
 05 Jun 2025 06:49:16 -0400
X-MC-Unique: C7vB7va0Opya1q7ruE2uFw-1
X-Mimecast-MFC-AGG-ID: C7vB7va0Opya1q7ruE2uFw_1749120555
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C0BB18004A3;
	Thu,  5 Jun 2025 10:49:15 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.64])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D66341956087;
	Thu,  5 Jun 2025 10:49:13 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2] tests: shell: Add a test case for FTP helper combined with NAT.
Date: Thu,  5 Jun 2025 18:49:11 +0800
Message-ID: <20250605104911.727026-1-yiche@redhat.com>
In-Reply-To: <20250605103339.719169-1-yiche@redhat.com>
References: <20250605103339.719169-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

This test verifies functionality of the FTP helper,
for both passive, active FTP modes,
and the functionality of the nf_nat_ftp module.

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/features/curl.sh             |   4 +
 tests/shell/features/tcpdump.sh          |   4 +
 tests/shell/features/vsftpd.sh           |   4 +
 tests/shell/testcases/packetpath/nat_ftp | 164 +++++++++++++++++++++++
 4 files changed, 176 insertions(+)
 create mode 100755 tests/shell/features/curl.sh
 create mode 100755 tests/shell/features/tcpdump.sh
 create mode 100755 tests/shell/features/vsftpd.sh
 create mode 100755 tests/shell/testcases/packetpath/nat_ftp

diff --git a/tests/shell/features/curl.sh b/tests/shell/features/curl.sh
new file mode 100755
index 00000000..fa0c43be
--- /dev/null
+++ b/tests/shell/features/curl.sh
@@ -0,0 +1,4 @@
+#!/bin/sh
+
+# check whether curl is installed
+curl -h >/dev/null 2>&1
diff --git a/tests/shell/features/tcpdump.sh b/tests/shell/features/tcpdump.sh
new file mode 100755
index 00000000..70df9f68
--- /dev/null
+++ b/tests/shell/features/tcpdump.sh
@@ -0,0 +1,4 @@
+#!/bin/sh
+
+# check whether tcpdump is installed
+tcpdump -h >/dev/null 2>&1
diff --git a/tests/shell/features/vsftpd.sh b/tests/shell/features/vsftpd.sh
new file mode 100755
index 00000000..d3500640
--- /dev/null
+++ b/tests/shell/features/vsftpd.sh
@@ -0,0 +1,4 @@
+#!/bin/sh
+
+# check whether vsftpd is installed
+which vsftpd >/dev/null 2>&1
diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
new file mode 100755
index 00000000..24fbecaa
--- /dev/null
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -0,0 +1,164 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_tcpdump)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_curl)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_vsftpd)
+
+rnd=$(mktemp -u XXXXXXXX)
+R="cthelper-router-$rnd"
+C="cthelper-client-$rnd"
+S="cthelper-server-$rnd"
+
+cleanup()
+{
+	for i in $R $C $S;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+	rm -f $INFILE $OUTFILE
+}
+trap cleanup EXIT
+
+INFILE=$(mktemp -p /var/ftp/pub/)
+OUTFILE=$(mktemp)
+
+assert_pass()
+{
+	local ret=$?
+	if [ $ret != 0 ]
+	then
+		echo "FAIL: ${@}"
+		ip netns exec $R nft list ruleset
+		tcpdump -nnr ${0##*/}.pcap
+		ip netns exec $R cat /proc/net/nf_conntrack
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
+
+ip_sr=2001:db8:ffff:22::1
+ip_cr=2001:db8:ffff:21::2
+ip_rs=2001:db8:ffff:22::fffe
+ip_rc=2001:db8:ffff:21::fffe
+
+ip netns add $R
+ip netns add $S
+ip netns add $C
+ip -net $S link set lo up
+ip -net $R link set lo up
+ip -net $C link set lo up
+ip netns exec $R sysctl -wq net.ipv6.conf.all.forwarding=1
+
+ip link add s_r netns $S type veth peer name r_s netns $R
+ip link add c_r netns $C type veth peer name r_c netns $R
+ip -net $S link set s_r up
+ip -net $R link set r_s up
+ip -net $R link set r_c up
+ip -net $C link set c_r up
+
+ip -net $S addr add ${ip_sr}/64 dev s_r
+ip -net $C addr add ${ip_cr}/64 dev c_r
+ip -net $R addr add ${ip_rs}/64 dev r_s
+ip -net $R addr add ${ip_rc}/64 dev r_c
+ip -net $C route add ${ip_rs}/64 via ${ip_rc} dev c_r
+ip -net $S route add ${ip_rc}/64 via ${ip_rs} dev s_r
+
+sleep 3
+ip netns exec $C ping -q -6 ${ip_sr} -c1 > /dev/null
+assert_pass "topo initialization"
+
+reload_ruleset()
+{
+	ip netns exec $R conntrack -F 2> /dev/null
+	ip netns exec $R nft -f - <<-EOF
+	flush ruleset
+	table ip6 ftp_helper_nat_test {
+		ct helper ftp-standard {
+			type "ftp" protocol tcp;
+		}
+
+		chain PRE-dnat {
+			type nat hook prerouting priority dstnat; policy accept;
+			# Dnat the control connection, data connection will be automaticly NATed.
+			ip6 daddr ${ip_rc} ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
+		}
+
+		chain PRE-aftnat {
+			type filter hook prerouting priority 350; policy drop;
+			iifname r_c tcp dport 21 ct state new ct helper set "ftp-standard" counter accept
+
+			ip6 nexthdr tcp ct state related counter accept
+			ip6 nexthdr tcp ct state established counter accept
+
+			ip6 nexthdr icmpv6 counter accept
+
+			counter log
+		}
+
+		chain forward {
+			type filter hook forward priority filter; policy drop;
+			ip6 daddr ${ip_sr} tcp dport 21 ct state new counter accept
+			ct state established counter accept
+			ct state related     counter log accept
+		}
+
+		chain POST-srcnat {
+			type nat hook postrouting priority srcnat; policy accept;
+			ip6 daddr ${ip_sr} ip6 nexthdr tcp tcp dport 21 counter snat ip6 to [${ip_rs}]:16500
+		}
+	}
+	EOF
+	assert_pass "apply ftp helper ruleset"
+}
+
+dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
+chmod 755 $INFILE
+assert_pass "Prepare the file for FTP transmission"
+
+cat > ./vsftpd.conf <<-EOF
+anonymous_enable=YES
+local_enable=YES
+connect_from_port_20=YES
+listen=NO
+listen_ipv6=YES
+pam_service_name=vsftpd
+background=YES
+EOF
+ip netns exec $S vsftpd ./vsftpd.conf
+sleep 1
+ip netns exec $S ss -6ltnp | grep -q '*:21'
+assert_pass "start vsftpd server"
+
+# test passive mode
+reload_ruleset
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap 2> /dev/null & sleep 2
+ip netns exec $C curl -s --connect-timeout 5 ftp://[${ip_rc}]:2121${INFILE#/var/ftp} -o $OUTFILE
+assert_pass "curl ftp passive mode "
+
+pkill tcpdump
+tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic NATed"
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Passive mode: The input and output files remain the same when traffic passes through NAT."
+
+
+# test active mode
+reload_ruleset
+modprobe nf_nat_ftp
+assert_pass "modprobe nf_nat_ftp. Active mode need it to modify the client ip in PORT command under SNAT"
+
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap 2> /dev/null & sleep 2
+ip netns exec $C curl -s -P - --connect-timeout 5 ftp://[${ip_rc}]:2121${INFILE#/var/ftp} -o $OUTFILE
+assert_pass "curl ftp active mode "
+
+pkill tcpdump
+tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic NATed"
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
+
+# trap calls cleanup
+exit 0
-- 
2.49.0

