Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F78257AFE
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Jun 2025 08:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749456881; cv=none; b=G7vwMU5ev4ibXbxINLf7AGMJ7EPEr7aCWHVBojy62hVZqAPuiBfuIpzsMAvjxglBHaDpG5oC2cg+McljFIIcOmzlwbAuqf1G1LHFld00cyuKUbdD0CfhuBA5j6kdCT224HZffx4sU5IDqwn+an3maiya7JnvHkavbiKeiHvfBks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749456881; c=relaxed/simple;
	bh=RKJV9K92/7sDYjOayfQUlYAkgr0/u+jX2vN3Im8HLig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmuKwomPqbSjsOi2AdtfMLmPAeY0kooSRJVKDmbgYzGJTPYKzNMz/rQs/hDZeaeurJakquWmDhiMXHZ67AYoPpgAW3m1XnQz5+aQuB6aJQeupoKVEa5ryAPSmq6Ki7bWnANnMeJ/EmMYSnfx2uZg1flxZLTQN1oXE75yXgd7vFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UGY3Yh1L; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UGY3Yh1L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749456877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SSctyZkrIiO1FDjV+P9cBSpm86uwfBArLaltHVDhoxc=;
	b=UGY3Yh1L2vUqthjwkQRcCgfAVDiRSse2FjeJp3RKYCh3tbsWlwBxPMNIqHfKBVS3CrCZ2S
	Tlm0F9XvhBXXrmU5pcjGnLLqRqMvs8FP1SwNUm/SqeGxnNNnBBeTa4dGTzZ6Zhw1/qq6tp
	NFi+SIPRzGrifMSJJ0nfDAU2jjLcy0Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-0mRJrAddP2aUDbQlwb-9Kw-1; Mon,
 09 Jun 2025 04:14:34 -0400
X-MC-Unique: 0mRJrAddP2aUDbQlwb-9Kw-1
X-Mimecast-MFC-AGG-ID: 0mRJrAddP2aUDbQlwb-9Kw_1749456873
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 140FA195608B;
	Mon,  9 Jun 2025 08:14:33 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.63])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2CE0219560A7;
	Mon,  9 Jun 2025 08:14:30 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2] tests: shell: Add a test case for FTP helper combined with NAT.
Date: Mon,  9 Jun 2025 16:14:28 +0800
Message-ID: <20250609081428.9219-1-yiche@redhat.com>
In-Reply-To: <20250605103339.719169-1-yiche@redhat.com>
References: <20250605103339.719169-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This test verifies functionality of the FTP helper,
for both passive, active FTP modes,
and the functionality of the nf_nat_ftp module.

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/features/curl.sh             |   4 +
 tests/shell/features/tcpdump.sh          |   4 +
 tests/shell/features/vsftpd.sh           |   4 +
 tests/shell/testcases/packetpath/nat_ftp | 174 +++++++++++++++++++++++
 4 files changed, 186 insertions(+)
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
index 00000000..8d0ce24b
--- /dev/null
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -0,0 +1,174 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_tcpdump)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_curl)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_vsftpd)
+
+cleanup()
+{
+	for i in $R $C $S;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+	rm -rf $WORKDIR
+}
+trap cleanup EXIT
+
+assert_pass()
+{
+	local ret=$?
+	if [ $ret != 0 ]
+	then
+		echo "FAIL: ${@}"
+		ip netns exec $R nft list ruleset
+		tcpdump -nnr ${PCAP}
+		ip netns exec $R cat /proc/net/nf_conntrack
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
+
+rnd=$(mktemp -u XXXXXXXX)
+R="natftp-router-$rnd"
+C="natftp-client-$rnd"
+S="natftp-server-$rnd"
+
+WORKDIR="/tmp/nat_ftp_test-$rnd"
+FTPCONF="$WORKDIR/ftp-conf"
+INFILE="$WORKDIR/infile"
+OUTFILE="$WORKDIR/outfile"
+PCAP="$WORKDIR/tcpdump.pcap"
+
+mkdir -p $WORKDIR
+assert_pass "mkdir $WORKDIR"
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
+ip -net $S addr add ${ip_sr}/64 dev s_r nodad
+ip -net $C addr add ${ip_cr}/64 dev c_r nodad
+ip -net $R addr add ${ip_rs}/64 dev r_s nodad
+ip -net $R addr add ${ip_rc}/64 dev r_c nodad
+ip -net $C route add ${ip_rs}/64 via ${ip_rc} dev c_r
+ip -net $S route add ${ip_rc}/64 via ${ip_rs} dev s_r
+
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
+			ip6 nexthdr tcp ct state established counter accept
+			ip6 nexthdr tcp ct state related     counter log accept
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
+cat > ${FTPCONF} <<-EOF
+anonymous_enable=YES
+anon_root=${WORKDIR}
+local_enable=YES
+connect_from_port_20=YES
+listen=NO
+listen_ipv6=YES
+pam_service_name=vsftpd
+background=YES
+EOF
+ip netns exec $S vsftpd ${FTPCONF}
+sleep 1
+ip netns exec $S ss -6ltnp | grep -q '*:21'
+assert_pass "start vsftpd server"
+
+
+# test passive mode
+reload_ruleset
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
+pid=$!
+sleep 1
+ip netns exec $C curl -s --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
+assert_pass "curl ftp passive mode "
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Passive mode: The input and output files remain the same when traffic passes through NAT."
+
+kill $pid; sync
+tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic NATed"
+
+
+# test active mode
+reload_ruleset
+modprobe nf_nat_ftp
+assert_pass "modprobe nf_nat_ftp. Active mode need it to modify the client ip in PORT command under SNAT"
+
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${0##*/}.pcap 2> /dev/null &
+pid=$!
+ip netns exec $C curl -s -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
+assert_pass "curl ftp active mode "
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
+
+kill $pid; sync
+tcpdump -nnr ${0##*/}.pcap src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic NATed"
+
+# trap calls cleanup
+exit 0
-- 
2.49.0

