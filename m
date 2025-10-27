Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAC52FB991
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565157; cv=none; b=N3rwq6xwyyJWz1GmmggmIQY+O3s/6t+MFXGxXrmMkeKPGAMur23dXtpN0oCdt9XO3BNElRfE3ln+YFoSb8KjWSxBiA3iz9XPmLFMbCyZa5/olW6ohCgr1xeFH0Z/c8cv3H0bPtstmLLugCWATEgX4RRYRhR15vbnHUDr0VYw3tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565157; c=relaxed/simple;
	bh=kYXMHmu0kPYTwSm4rTdiVZSq5Y/THjx2nCjNCtxmi68=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YBnwh8w6EVmrHdMB96Y9U2e4IDm22CKdbNci670W/fGnYbB2NpfWH6LX9sTaHjzrRWh3YpJPRXHnBT+ogFNAD2GrX/o5WTAckqlvU2sORDhPfff75c6Qs8a1yUxmi5eOyyyYM77ZZfjIZeb8qSYpH3tMOwGjQpvwKidQDkzkFRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=pfVUYgx+; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="pfVUYgx+"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so857441766b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 04:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761565151; x=1762169951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=m0zXqEDRg8DnVEpQ5SEQSvp9OCp8zQxNUnqsMUAbG3Y=;
        b=pfVUYgx+NO5evEpn6Ixwgq/kcKoo9+uaZogSw0OovsY2MAkh0R6cljy4Uy1I7Wvv/D
         7a78JwL3bpWkMR4mJKMjOR1HPFJPBoRpkyGrDyro2Ga2UuJq4YxcB0lqgeII7FO/YLRg
         wyPNq8rQItusXfzyA5z1IKpZAB4iQ77q23JgIfX07RC/U9490qNkYlCsDcrKJxxu3m6s
         Rp9hN/PUG1M7rfP+Whsbnd4L0uB+/KrtsAqsPbicwG5Zz5LG05DUH9bCOl+2U9y+egUB
         R+McCdbM9kWPBCKx9HUywNj6alzSK3Eg8l++6pEPqrqQ51LT9DVe4oRfUKkMxC7fMJ7W
         1IYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565151; x=1762169951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m0zXqEDRg8DnVEpQ5SEQSvp9OCp8zQxNUnqsMUAbG3Y=;
        b=G0eFDynoMIGv55JkxE7HQGeILdhtatBoynfLloisLrcSDfuFkLUcBZmstdHMa0AbfF
         0Mdj3v/CYrwwPdadFnVQMpk3IK2ZGrpM5WbDy/kWWswDnu8JD1mlnXO0S/l3Iw7xtx5h
         NnNW0CBZn4JWNw/Vm+c2ysF/AEKwe0GQN0THPG7QQUsOBfuqStFP2tGaIbU9HODocIE0
         1sUU3QKXVX0T28tzfOBVn3inDzm9hs+M0+0Q9aiaRJ0c0UnahAJ6QRZMte32iCBKjVRm
         RcKxVnPf7mET3sqmRcPDLyaCsANRKxI04PggGlyxu0dVXBOL09OjzSp5VQ6X2K1VrfbK
         NZCQ==
X-Gm-Message-State: AOJu0YzcxVXU36aTESo6QfwmtZ2a/zanU8+iqWtWt4hTRSRDp+Q98RGy
	Qnox0nxNg3TYfxjMyLxS8NUZT+u5/WoXgl/XyhB2axPtIvhSGQBdnMCyWXsFxJ6uw6F6hLXShsf
	n25k+
X-Gm-Gg: ASbGnctRZ03GEmwMSvlvWOuHkTqGN6Hjb1foB7n5b8ffitGqbtV6XAwt5Djn1Ga/ndK
	q/EQiIPslMRHrbaAIGQf77GcxAs8vhrCEcPTwQdaK5yUF6tuDMCi9GhM8keVaUlYvY69tzZek05
	T0BGzwHIjOuu7leNjnWSJcw6gyfQkDzjSQAFSzT/vUgDE851ClLJwGTeB55YbsRLbJS53xbR3HC
	kCppRuDBlhoitSXucXI0ap2oRHldC6KY1TwLxZHgt6Wlbq9+1o4Jc8bEAdyxf/O8zsLjjegX4AB
	REcPlCeJhpaeaDXR7Py9ITNCRuiaDz2L8VD+WPSuq1O0Id5hIvLU52dQwr8kldlR3/wlR4EEc+U
	9klh9RlG/Kq3lzuUgvnxIG25RrzOw7EDFIcHn1xkXMNSvphPNaI4g0AdjCOFWZYOkcv9Uc5Kmv/
	ujuUA6F5+l0VSSn66LUq6yN1iJ
X-Google-Smtp-Source: AGHT+IFoCoaORi2Lw9Kny9XYtknBobsmH5i/3+z0l9kiY+7xiJt6OvSn+idqqzfhwT2SFw30hQOHow==
X-Received: by 2002:a17:907:9701:b0:b3e:babd:f263 with SMTP id a640c23a62f3a-b6d6fe02237mr1340424266b.3.1761565151460;
        Mon, 27 Oct 2025 04:39:11 -0700 (PDT)
Received: from VyOS.. (213-225-2-6.nat.highway.a1.net. [213.225.2.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d85ba3798sm741070066b.39.2025.10.27.04.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 04:39:10 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH 1/1] tests: shell: Updated nat_ftp tests
Date: Mon, 27 Oct 2025 12:39:07 +0100
Message-ID: <20251027113907.451391-1-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added DNAT and SNAT only tests.
There was an issue with DNAT that was not covered by tests.
DNAT misses setting up the `seqadj`, which leads to FTP failures.
The fix for DNAT has already been proposed to the kernel.

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
---
 tests/shell/testcases/packetpath/nat_ftp | 127 +++++++++++++++++++++--
 1 file changed, 120 insertions(+), 7 deletions(-)

diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index d0faf2ef..8d9e5d45 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -77,31 +77,45 @@ ip -net $S route add ${ip_rc}/64 via ${ip_rs} dev s_r
 ip netns exec $C ping -q -6 ${ip_sr} -c1 > /dev/null
 assert_pass "topo initialization"
 
-reload_ruleset()
+reload_ruleset_base()
 {
-	ip netns exec $R conntrack -F 2> /dev/null
-	ip netns exec $R $NFT -f - <<-EOF
+	[[ $# -eq 2 && ( $1 -ne 0 || $2 -ne 0 ) ]]
+	assert_pass "reload ruleset options"
+
+	add_dnat=$1
+	add_snat=$2
+	ruleset=""
+
+	# flush and add FTP helper
+	read -r -d '' str <<-EOF
 	flush ruleset
 	table ip6 ftp_helper_nat_test {
 		ct helper ftp-standard {
 			type "ftp" protocol tcp;
 		}
+	EOF
+	ruleset+=$str$'\n'
 
+	# add DNAT
+	if [[ $add_dnat -ne 0 ]]; then
+		read -r -d '' str <<-EOF
 		chain PRE-dnat {
 			type nat hook prerouting priority dstnat; policy accept;
 			# Dnat the control connection, data connection will be automaticly NATed.
 			ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
 		}
+		EOF
+		ruleset+=$str$'\n'
+	fi
 
+	# add FORWARD
+	read -r -d '' str <<-EOF
 		chain PRE-aftnat {
 			type filter hook prerouting priority 350; policy drop;
 			iifname r_c tcp dport 21 ct state new ct helper set "ftp-standard" counter accept
-
 			ip6 nexthdr tcp ct state related counter accept
 			ip6 nexthdr tcp ct state established counter accept
-
 			ip6 nexthdr icmpv6 counter accept
-
 			counter log
 		}
 
@@ -111,18 +125,51 @@ reload_ruleset()
 			ip6 nexthdr tcp ct state established counter accept
 			ip6 nexthdr tcp ct state related     counter log accept
 		}
+	EOF
+	ruleset+=$str$'\n'
 
+	# add SNAT
+	if [[ $add_snat -ne 0 ]]; then
+		read -r -d '' str <<-EOF
 		chain POST-srcnat {
 			type nat hook postrouting priority srcnat; policy accept;
 			ip6 daddr ${ip_sr} ip6 nexthdr tcp tcp dport 21 counter snat ip6 to [${ip_rs}]:16500
 		}
-	}
+		EOF
+	ruleset+=$str$'\n'
+	fi
+
+	ruleset+=$'}\n'
+	
+	ip netns exec $R conntrack -F 2> /dev/null
+	ip netns exec $R $NFT -f - <<-EOF
+		${ruleset}
 	EOF
+
 	assert_pass "apply ftp helper ruleset"
 }
 
+reload_ruleset()
+{
+	reload_ruleset_base 1 1
+}
+
+reload_ruleset_dnat_only()
+{
+	reload_ruleset_base 1 0
+}
+
+reload_ruleset_snat_only()
+{
+	reload_ruleset_base 0 1
+}
+
 dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
 chmod 755 $INFILE
+
+mkdir -p /var/run/vsftpd/empty/
+cp $INFILE /var/run/vsftpd/empty/
+
 assert_pass "Prepare the file for FTP transmission"
 
 cat > ${FTPCONF} <<-EOF
@@ -158,6 +205,38 @@ tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
 assert_pass "assert FTP traffic NATed"
 
 
+# test passive mode DNAT only
+reload_ruleset_dnat_only
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
+pid=$!
+sleep 0.5
+ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
+assert_pass "curl ftp passive mode DNAT only"
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Passive mode DNAT only: The input and output files remain the same when traffic passes through NAT."
+
+kill $pid; sync
+tcpdump -nnr ${PCAP} src ${ip_cr} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic DNATed"
+
+
+# test passive mode SNAT only
+reload_ruleset_snat_only
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
+pid=$!
+sleep 0.5
+ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${ip_sr}]:21/$(basename $INFILE) -o $OUTFILE
+assert_pass "curl ftp passive mode SNAT only"
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Passive mode SNAT only: The input and output files remain the same when traffic passes through NAT."
+
+kill $pid; sync
+tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic SNATed"
+
+
 # test active mode
 reload_ruleset
 
@@ -174,5 +253,39 @@ kill $pid; sync
 tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
 assert_pass "assert FTP traffic NATed"
 
+
+# test active mode DNAT only
+reload_ruleset_dnat_only
+
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
+pid=$!
+sleep 0.5
+ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
+assert_pass "curl ftp active mode "
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
+
+kill $pid; sync
+tcpdump -nnr ${PCAP} src ${ip_cr} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic DNATed"
+
+
+# test active mode SNAT only
+reload_ruleset_snat_only
+
+ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
+pid=$!
+sleep 0.5
+ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_sr}]:21/$(basename $INFILE) -o $OUTFILE
+assert_pass "curl ftp active mode "
+
+cmp "$INFILE" "$OUTFILE"
+assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
+
+kill $pid; sync
+tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
+assert_pass "assert FTP traffic SNATed"
+
 # trap calls cleanup
 exit 0
-- 
2.43.0

