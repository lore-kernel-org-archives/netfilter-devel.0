Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080FB32AAB2
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761670576; cv=none; b=I9Ui63W3xp16hB0WhCZWmZbhy284km/i9S8IdK1koSR38gF6LnwhKKV1pncv0S8Lu3ZN9aTlWZuxdOit9Fm7BCV5oExab4uKfLi6f2qCBMk9CM1JPm9I05BhqMIunZet2korvKRfFEla4At0WcBtv/hXytVhB/ue7zsgeE+yqso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761670576; c=relaxed/simple;
	bh=T5IvAONlCV9tEDxowzZCeSz6/UBBp3zW4rNQajYVTkI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF7JuQHHBmsZjupLNp/b6VB2I5pVz3NjcuGCwtvMIJje+K9xvayrQMrnqyijCmmtzS5iCRjh+Tggivu2AzQBd0nb/1nLd9zbz2HlplpQTKcXwVuBa7gfVd72kwthmEg8DA1H/tmx2sPfA6f++7vrn6GUrOXabDA5z9CM5O8yoHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io; spf=pass smtp.mailfrom=vyos.io; dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b=NbFj1nUf; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vyos.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vyos.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vyos.io header.i=@vyos.io header.b="NbFj1nUf"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b6dbb4a209aso272197066b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 09:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vyos.io; s=google; t=1761670572; x=1762275372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qTfXH+UziKhwD5GJAwX/xGLh1L50EXEAzZCtXvFc+XY=;
        b=NbFj1nUf5ZwLF492HzpuCQWV56c44MBdCrImZWw82p1gAidLnvnvyjh4OP8ETqerBg
         lMIfkbY2l855c9KH84JUvWpGQ2QWIUMIoWPZOF4G1wi232OhjtAR5eaR2s+YLXFjxoX4
         dsV5VhTwJU4ljmY9WE3UBHnEIMXWoQ/nDK/AyQwkA6Umox2d16fAX5CQDg2G7CSUyr+E
         3obNQCuyEJOUh3wCM9/xrkSRgLub+sOndcaPRD3paFb1rBjefhlXIRckGLktyq8fywVP
         zOqYNK/W2+nxBx/2EOxybp/BkaqbuQEWOf+RM+krC//SVUNhBFRwprP0o0eLAUqyXXPw
         Irwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761670572; x=1762275372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qTfXH+UziKhwD5GJAwX/xGLh1L50EXEAzZCtXvFc+XY=;
        b=khBPwq4UNaIBianCVsQhrPLEN938/NLZkQqIVhtPLMgBqqWREFiXtDaSVXi/dhHv+t
         JggUBYBkOPj49VUpVxGvliBsaueOoWOZJVSbJAPYZXhTr0ZDxW2xKAXQu+Oullsx3csI
         yxOeDIjPTpIlyt2LVXAHAgJXIPlQcHajLUtcTQLfI4nh98D/0GBlG2Rpd0EMgY31dsWW
         kR7aYzmH1orOrIPURo55hb8kvL6n4nWsg2Is0p2U1ILC38va0Oa4BUhlZt2rPJxuf2fp
         1sCke9nMRTV5ri/WuhJZantCVMWhBClAlrsvrYJ8J29gvL26cBeX1D0WYyhR5XzwSHAH
         ed2w==
X-Gm-Message-State: AOJu0YwbdOzJRz826jH6Af5nSXcjZMzpgO6AmTt+EYlZNp/GQuMfkBf7
	kcqyBpziyifdA626wDxbbvBZCBEfHp77uFmUxfzNAdNm1JlxtCnXUtMh6GK93EZA+NSqXs8rWsX
	S7BY3
X-Gm-Gg: ASbGncs9KiYwUXNbyrKYTe2bfmJrgg1S3GvZHBZfsXUL+HelYtBbd+blhCUaD5fEBN/
	XWXaRinRMgJK+asTMpMpxnLuotIjuNC9HP8lrZFTb6Cf2RV2Dkc8fFdZFs0cxq9EpNLjSTH23li
	+dmCDDlq1rJZgIhE7knfpC/v1UhC7lPW344pxRUbEoFJPf1SmMEET5GLBjuQXNSyN3VqsujYMvH
	AAzhcyd/ikKiGuYulOAsYCYXiu0Xy64zml3/bdeE+AJxxo4kCieDJnmWbQwzcxMlfXVlCChQnWF
	qc4DafsKLZxvgxvOkgp97XIOqKoSc9pDkWvVVuxp1pRyYpYPuJdx0Erik1VgxrnD29vJVavAvpT
	a5aB5L0Zzm70ZTcHUITmYDfjOYVhfAwcq7aO8u2X/8VfOdqIt0Lzh05qJ7sykurah6lu2wl0Dxj
	GtcYoWzRh3iUR5cs2Pv+AGkhKv
X-Google-Smtp-Source: AGHT+IFXkBePrsiTA2OfEeU2Io9GAk8JKtG4pb2kcU6Uxh0wKxWHe7o7inwhGsyPzM3U765SrLvj6g==
X-Received: by 2002:a17:906:c143:b0:b6d:7e01:cbc5 with SMTP id a640c23a62f3a-b703295401fmr22942966b.53.1761670571928;
        Tue, 28 Oct 2025 09:56:11 -0700 (PDT)
Received: from VyOS.. (213-225-2-6.nat.highway.a1.net. [213.225.2.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d8541fb5bsm1138462566b.56.2025.10.28.09.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 09:56:11 -0700 (PDT)
From: Andrii Melnychenko <a.melnychenko@vyos.io>
To: netfilter-devel@vger.kernel.org,
	fw@strlen.de
Subject: [PATCH v2 1/2] tests: shell: Refactored nat_ftp, added rulesets and testcase functions
Date: Tue, 28 Oct 2025 17:56:06 +0100
Message-ID: <20251028165607.1074310-2-a.melnychenko@vyos.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251028165607.1074310-1-a.melnychenko@vyos.io>
References: <20251028165607.1074310-1-a.melnychenko@vyos.io>
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
index d0faf2ef..bc116f6e 100755
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
+	kill $pid; sync
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
+test_case "Passive mode" [${ip_rc}]:2121 ${ip_rs}
 
 
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
+test_case "Active mode" [${ip_rc}]:2121 ${ip_rs} "-P -"
 
 # trap calls cleanup
 exit 0
-- 
2.43.0

