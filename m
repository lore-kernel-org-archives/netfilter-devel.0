Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094842882A1
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 14:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761836260; cv=none; b=N7EIGL8mlOF0DRXa8Ir/3GyAHx3/7B91UNNDuOGH4FnCMTSTROTcB9x6sv7skhsS3aNF//Ok/Twr1nD34ylYu7W80xixColv5RpVZcpnc2UIN4yJacmq60YWGNqxYPZbSlOhqC8Wpq+g40t/jRQp/Q4jAesPKkgii2AcLbefhPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761836260; c=relaxed/simple;
	bh=tOee828P9dxTidWj1uOul3Um52bWH6klwX/PzU7i5r0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ym09a10Y+26hgO9/zU8Ei5j0r2385O5KMgUqMTvrrkXOcIirtRABezwK5jDoVvhe1OK2o5OZDeQucI7PPfnKtsPOZZ81JC5OXPoypQ1dbRpyMzQ0u2f/pQXsErF0aiwy+ii2Zf6kNC+S82nGEvoKXRD7hK+iV49zFcHGqARHqYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=pZA5xIeS; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="pZA5xIeS"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so259833666b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 07:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761836257; x=1762441057; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4MzU6hJvoCG2LsA85ql8/3F3asDXpRK9SqMdj88vzN4=;
        b=pZA5xIeSSFRmVI2Pe+5iEguDV7cmDqfBD/KKj3za7u36VzRrJssHBv+f9wofAfU9OO
         1zcsuYtntLGHBzopEn/WYqQDfVljjxagiglqAOOZ4BRIVyJdaZ+sBVYoR+N5Ebbvt6iY
         i430EUy21nRQQGCveskwjLgPxfsSe/91ToiB6r6gMoOuOfqzZBzW3RRJhX95bgbORbXb
         4kDCD0ESHk2Eky2oX4xvH5R7SY/1vgTWbIupuRckCll/HXW3ivHeiVP6mwMcXK9WX3bg
         V4PaINvGysr7cgaWlca1PnWV+XViTUD87+ZKXHiXm7pc+3eQTMotvhlwAnVZEU3w7LXA
         cSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761836257; x=1762441057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MzU6hJvoCG2LsA85ql8/3F3asDXpRK9SqMdj88vzN4=;
        b=bzW2qWazUGswec0+nfMfmHb8er6ccPWl1ndVZiuch0KjSOCZsYhTM4RejBv7YI1OuV
         6yrVrJGr8BhIddCceKDxJc9bbmo+j1ACtcabqdhQKSEpnv8ckV0QjPBuaDMnKmTtXy/M
         4dGA34kuJq5AIbhqRDyra8zwnnYYZ7wtYRdTkKB54kK95gcFgSBXueAB8CXYetclsytW
         Kk1Zelqv9oQEtquB0MiLbMtCaI1bi4YMeNChqygae5HCHSJ9RTqfaDjrw1SJ7nN5Pp7o
         KtOqK+FDKjElxExPOl8GgrIwwggYfTa+tZq6smDJGZj2IZSYqbqmY7b+Oy/vtQ+ylgrl
         Mahw==
X-Gm-Message-State: AOJu0YxF69UrsWlcYEtD9pKGgs735v0J4w7/kqz81mBGv8+/p6e2n/1L
	LPG+fVsn8E+yRls8iUo00LttrTzLhdIFy1RudBaXySPgSa8vgpLA5v+UFL/nLGVQf5T19Mvvdhk
	akeR3
X-Gm-Gg: ASbGncvjPpo2rrrIMshxXgZdzCGbCvsf5a+Aotd4/a7Mg6ytL/b7dV0LEC/7fLTRBka
	Pshk6l7xe4r86GZslukARpr4it+ZXrYnvop2o+mChiN2rOQrxJZRcGdcWnlfmMqQBYYktz/YW0b
	JOs1h17RKHbNJKMOuk5kTPg4G06PvkeA8osV853tndJM2v+tXzrMLmnINgaP1ISBfiop04uaXod
	PoyBmgQ342pu2yG3IGBwZxJY2xvoXVxWPTYd4+cQpN+/0AfChU7BfkMhwDPwFD8GN+jpEtfQHDk
	p/rLia1nUC5W1bbDkBNm7mQPhMJBNdlT3Mc2XjEfY6BUw8RXx526VdaSw42nkkAOc3GI3BG/2wf
	uj+YkI03jX3+LC6Jkdjh2RQOqXd5y2Ufob5ipgZtCiFE9M9088YfS64t8DTPDUg/G9IxR3pQVwi
	oj0pVx+PBEV60gkMz0c5E/QWoJ
X-Google-Smtp-Source: AGHT+IHDOiVSBed2WIBjIloKYy3uDfjUxpn2YcxqpZmoe10uuMtuN8N9hbphPAGRsQLjamz3RL+0Yg==
X-Received: by 2002:a17:907:1c0a:b0:b3d:9c3c:9ab6 with SMTP id a640c23a62f3a-b703d3831a1mr710769066b.29.1761836256110;
        Thu, 30 Oct 2025 07:57:36 -0700 (PDT)
Received: from VyOS.. (213-225-2-6.nat.highway.a1.net. [213.225.2.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853c549fsm1790483966b.37.2025.10.30.07.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 07:57:35 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH v3 1/2] tests: shell: Refactored nat_ftp, added rulesets and testcase functions
Date: Thu, 30 Oct 2025 15:57:30 +0100
Message-ID: <20251030145731.2234648-2-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251030145731.2234648-1-a.melnychenko@vyos.io>
References: <20251030145731.2234648-1-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactored the setup of nft rulesets, now it is possible to set up an
SNAT or DNAT-only ruleset for future tests.
Presented the testcase function to test passive or active modes.

Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
---
 tests/shell/testcases/packetpath/nat_ftp | 86 +++++++++++++++---------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index d0faf2ef..93330225 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -77,7 +77,7 @@ ip -net $S route add ${ip_rc}/64 via ${ip_rs} dev s_r
 ip netns exec $C ping -q -6 ${ip_sr} -c1 > /dev/null
 assert_pass "topo initialization"
 
-reload_ruleset()
+reload_ruleset_base()
 {
 	ip netns exec $R conntrack -F 2> /dev/null
 	ip netns exec $R $NFT -f - <<-EOF
@@ -87,12 +87,6 @@ reload_ruleset()
 			type "ftp" protocol tcp;
 		}
 
-		chain PRE-dnat {
-			type nat hook prerouting priority dstnat; policy accept;
-			# Dnat the control connection, data connection will be automaticly NATed.
-			ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
-		}
-
 		chain PRE-aftnat {
 			type filter hook prerouting priority 350; policy drop;
 			iifname r_c tcp dport 21 ct state new ct helper set "ftp-standard" counter accept
@@ -111,14 +105,43 @@ reload_ruleset()
 			ip6 nexthdr tcp ct state established counter accept
 			ip6 nexthdr tcp ct state related     counter log accept
 		}
+	}
+	EOF
+	assert_pass "apply ftp helper base ruleset"
+}
+
+load_dnat()
+{
+	ip netns exec $R $NFT -f - <<-EOF
+	table ip6 ftp_helper_nat_test {
+		chain PRE-dnat {
+			type nat hook prerouting priority dstnat; policy accept;
+			# Dnat the control connection, data connection will be automaticly NATed.
+			ip6 daddr ${ip_rc} counter ip6 nexthdr tcp tcp dport 2121 counter dnat ip6 to [${ip_sr}]:21
+		}
+	}
+	EOF
+	assert_pass "apply ftp helper DNAT ruleset"
+}
 
+load_snat()
+{
+	ip netns exec $R $NFT -f - <<-EOF
+	table ip6 ftp_helper_nat_test {
 		chain POST-srcnat {
 			type nat hook postrouting priority srcnat; policy accept;
 			ip6 daddr ${ip_sr} ip6 nexthdr tcp tcp dport 21 counter snat ip6 to [${ip_rs}]:16500
 		}
 	}
 	EOF
-	assert_pass "apply ftp helper ruleset"
+	assert_pass "apply ftp helper SNAT ruleset"
+}
+
+reload_ruleset()
+{
+	reload_ruleset_base
+	load_dnat
+	load_snat
 }
 
 dd if=/dev/urandom of="$INFILE" bs=4096 count=1 2>/dev/null
@@ -141,38 +164,35 @@ wait_local_port_listen $S 21 tcp
 ip netns exec $S ss -6ltnp | grep -q '*:21'
 assert_pass "start vsftpd server"
 
+test_case()
+{
+	tag=$1
+	ftp_ip_and_port=$2
+	client_ip_to_check=$3
+	additional_curl_options=$4
+
+	ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
+	pid=$!
+	sleep 0.5
+	ip netns exec $C curl ${additional_curl_options} --no-progress-meter --connect-timeout 5 ftp://${ftp_ip_and_port}/$(basename $INFILE) -o $OUTFILE
+	assert_pass "curl ftp "${tag}
+
+	cmp "$INFILE" "$OUTFILE"
+	assert_pass "FTP "${tag}": The input and output files remain the same when traffic passes through NAT."
+
+	kill $pid;
+	tcpdump -nnr ${PCAP} src ${client_ip_to_check} and dst ${ip_sr} 2>&1 |grep -q FTP
+	assert_pass "assert FTP traffic NATed"
+}
 
 # test passive mode
 reload_ruleset
-ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
-pid=$!
-sleep 0.5
-ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
-assert_pass "curl ftp passive mode "
-
-cmp "$INFILE" "$OUTFILE"
-assert_pass "FTP Passive mode: The input and output files remain the same when traffic passes through NAT."
-
-kill $pid; sync
-tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
-assert_pass "assert FTP traffic NATed"
+test_case "Passive mode" "[${ip_rc}]:2121" ${ip_rs}
 
 
 # test active mode
 reload_ruleset
-
-ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
-pid=$!
-sleep 0.5
-ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
-assert_pass "curl ftp active mode "
-
-cmp "$INFILE" "$OUTFILE"
-assert_pass "FTP Active mode: in and output files remain the same when FTP traffic passes through NAT."
-
-kill $pid; sync
-tcpdump -nnr ${PCAP} src ${ip_rs} and dst ${ip_sr} 2>&1 |grep -q FTP
-assert_pass "assert FTP traffic NATed"
+test_case "Active mode" "[${ip_rc}]:2121" ${ip_rs} "-P -"
 
 # trap calls cleanup
 exit 0
-- 
2.43.0

