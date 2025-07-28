Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C901FC3
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 04:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753675401; cv=none; b=fbwUumuJb1SmCSnaj5PFazysNT+21YMFiKGLKc9YN6y7WmhUBHVxAL2q2bBES8bBOTvkKCzRlbLaoEcCSx9b9/Cj9i/VR6Or/ZdW9n/kE8/HIvqXDhwtzGfNIeg07xXbS62eBDWF20oqlyv+vi02IbKOnDVu/cSGUOuHohN+xss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753675401; c=relaxed/simple;
	bh=xl/SMmEGa418BYOau1Tr9MSwEcddUY/WPrXMLdW5z70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICpWK9Vh8egQr1gIDKQJptTbvQckX/1mnMsQPyapAwzkom3hO5D+sqYt4iCt5AfuX/xtHrDZ9wrZRLB3gEEfFN3gpcRAsfMWI+v2ks6fHAkJUEOV6s5IZ6ktn2LCu8amg/gfLTiaDx5ppQYWBjt6PLPaSgqv71f6R6J26z7ATB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cobyx+gC; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cobyx+gC"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-70739d1f07bso18818606d6.2
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Jul 2025 21:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753675398; x=1754280198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nqlazoG5veS25rjVG1ZtsSkyaxRru2Xwpri+y9THoU=;
        b=Cobyx+gCmP+/490ngZpyO6jOzGHIl/ihqKvdMqfMZ2PXHAU3yN0pQW/3/ND4fMLa5V
         RuJpSu7L0QMe6ngKK1ERNDC/vxh/t6puTo32S9wMkBgLypu9xqveM+1g5OosZNjxrDGz
         pO8E941UZjNiDoJ/15UaTfzb/IeYfW0Sl5jNU38NMiMPXTRjaxtU/4ruCm8VHAryI/Ln
         0P9ABG8UnG9wXC4pAA2YkMlVS+bpWuGhr8RwlYH9SRLsanaNmFftK8Npgn32yFE/zkpN
         5qBif+3xgt6r0GiLCgDh6iWXGFRvMswas7GJCJ6aLlZ8VPB/Jw4QstrwtUx+yHBHZwNq
         Z/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753675398; x=1754280198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1nqlazoG5veS25rjVG1ZtsSkyaxRru2Xwpri+y9THoU=;
        b=RDg6fXRGnCCa3XfHAM+0Fl95Yq39gVDN89GfdYXdfZQTmQPfCuud7rpcDcI6ABryaO
         96fFFQVFjsR+Uro1iQh8OYwi+L6pBvCc9DWLV44UJgmhH9PA9IvAtNs1eTuv+k2SZI7E
         /ztm+MwrpbaQRvO1KaYjliezVo7heL+pTb3wOeahh/Hxc5posNcK3O/2uduFW6QugDLG
         kBRzZfLtm7oMhEpM5g+BRXeH1xFsWu5BGGc7I3XYs6spoQUCaqkwTdoXOmY5rhXVRU5B
         0pdGqUc2hOGmm0bNtSb7WQOG3FjuWRrogHxO7vezWd2xmzA5EfYKNegvZYHx+t69/Rfk
         PoiA==
X-Gm-Message-State: AOJu0YwrvkVsZAZXl9hReGSDt0LqzmPgCz2DecNEfTRsy2h4tSsN6/Kk
	Cg4XbL4VIWkH1q1Bbxmrys3zlgZEfoYIEz+cAPkoN2hZq8lJ6EnZ5P8WpFxV4A==
X-Gm-Gg: ASbGncuyYDgMA61gv5sejNWh//smLEwLSvZmvPdirhCTw4BuRfuiQEtSm02lTtPuBMS
	nvRvkym6cDbDz7fDoC5Lna41SGMvU5xLoPWPTCHimMT48NpiImvNvnLeXno4dqB4W2Ksb36ORez
	PeFLucluzveT8zEsNyBQeDWqytkFUndnb50CyP2VbnjttiTPFM8H0XnYpvMfn020G/knYDVRJO+
	q29iT75Kq7BKG5vs7hWR0wcCFWm0GHbmSaFnnRw67AT0KdTkv8DnC+93SVHapMnR8KV838p9c0u
	xUJQ5KA1+h8B/zJOdjlHmK5oMRgpmW0XtjfpxIw/BzU5iI4ykpd21Uutc/19eNOA2bXtas2Iocl
	Jwzxsrc7YFwhJQojO+5XciNE5evFQU58gJ4gJxOfkXFITvoQR+wZhsGvbKfQAoWoH+HC5wj3r3T
	fE7bk=
X-Google-Smtp-Source: AGHT+IFmretLevjwoejNL5geART73wFiMuRPawqx+HRiRu26MifjQPvNjCikmwv7lSnr5Rydgdxdbg==
X-Received: by 2002:ad4:5be9:0:b0:705:456:c4a0 with SMTP id 6a1803df08f44-707205be62cmr122246026d6.33.1753675397508;
        Sun, 27 Jul 2025 21:03:17 -0700 (PDT)
Received: from fedora.. (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7074b52ddc7sm4928576d6.77.2025.07.27.21.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 21:03:17 -0700 (PDT)
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: ppwaskie@kernel.org,
	fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v6 2/2] Add test for nft_max_table_jumps_netns sysctl
Date: Mon, 28 Jul 2025 00:03:15 -0400
Message-ID: <20250728040315.1014454-2-brady.1345@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250728040315.1014454-1-brady.1345@gmail.com>
References: <20250728040315.1014454-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce test for recently added jump limit functionality.  Tests
sysctl behavior with regard to netns, as well as calling user_ns.

Signed-off-by: Shaun Brady <brady.1345@gmail.com>
---
 .../testing/selftests/net/netfilter/Makefile  |   1 +
 .../netfilter/nft_max_table_jumps_netns.sh    | 227 ++++++++++++++++++
 2 files changed, 228 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index a98ed892f55f..62193e0cd8ec 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -26,6 +26,7 @@ TEST_PROGS += nft_conntrack_helper.sh
 TEST_PROGS += nft_fib.sh
 TEST_PROGS += nft_flowtable.sh
 TEST_PROGS += nft_interface_stress.sh
+TEST_PROGS += nft_max_table_jumps_netns.sh
 TEST_PROGS += nft_meta.sh
 TEST_PROGS += nft_nat.sh
 TEST_PROGS += nft_nat_zones.sh
diff --git a/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh b/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh
new file mode 100755
index 000000000000..9dedd45f4fd2
--- /dev/null
+++ b/tools/testing/selftests/net/netfilter/nft_max_table_jumps_netns.sh
@@ -0,0 +1,227 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# A test script for nf_max_table_jumps_netns limit sysctl
+#
+source lib.sh
+
+DEFAULT_SYSCTL=65536
+
+user_owned_netns="a_user_owned_netns"
+
+cleanup() {
+        ip netns del $user_owned_netns 2>/dev/null || true
+}
+
+trap cleanup EXIT
+
+init_net_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
+
+# Check that init ns inits to default value
+if [ "$init_net_value" -ne "$DEFAULT_SYSCTL" ];then
+	echo "Fail: Does not init default value"
+	exit 1
+fi
+
+# Set to extremely small, demonstrate CAN exceed value
+sysctl -w net.netfilter.nf_max_table_jumps_netns=32 2>&1 >/dev/null
+new_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
+if [ "$new_value" -ne "32" ];then
+	echo "Fail: Set value not respected"
+	exit 1
+fi
+
+nft -f - <<EOF
+table inet loop-test {
+	chain test0 {
+		type filter hook input priority filter; policy accept;
+		jump test1
+		jump test1
+	}
+
+	chain test1 {
+		jump test2
+		jump test2
+	}
+
+	chain test2 {
+		jump test3
+		tcp dport 8080 drop
+		tcp dport 8080 drop
+	}
+
+	chain test3 {
+		jump test4
+	}
+
+	chain test4 {
+		jump test5
+	}
+
+	chain test5 {
+		jump test6
+	}
+
+	chain test6 {
+		jump test7
+	}
+
+	chain test7 {
+		jump test8
+	}
+
+	chain test8 {
+		jump test9
+	}
+
+	chain test9 {
+		jump test10
+	}
+
+	chain test10 {
+		jump test11
+	}
+
+	chain test11 {
+		jump test12
+	}
+
+	chain test12 {
+		jump test13
+	}
+
+	chain test13 {
+		jump test14
+	}
+
+	chain test14 {
+		jump test15
+		jump test15
+	}
+
+	chain test15 {
+	}
+}
+EOF
+
+if [ $? -ne 0 ];then
+	echo "Fail: limit not exceeded when expected"
+	exit 1
+fi
+
+nft flush ruleset
+
+# reset to default
+sysctl -w net.netfilter.nf_max_table_jumps_netns=$DEFAULT_SYSCTL 2>&1 >/dev/null
+
+# Make init_user_ns owned netns, can change value, limit is applied
+ip netns add $user_owned_netns
+ip netns exec $user_owned_netns sysctl -qw net.netfilter.nf_max_table_jumps_netns=32 2>&1
+if [ $? -ne 0 ];then
+	echo "Fail: Can't change value in init_user_ns owned namespace"
+	exit 1
+fi
+
+ip netns exec $user_owned_netns \
+nft -f - 2>&1 <<EOF
+table inet loop-test {
+	chain test0 {
+		type filter hook input priority filter; policy accept;
+		jump test1
+		jump test1
+	}
+
+	chain test1 {
+		jump test2
+		jump test2
+	}
+
+	chain test2 {
+		jump test3
+		tcp dport 8080 drop
+		tcp dport 8080 drop
+	}
+
+	chain test3 {
+		jump test4
+	}
+
+	chain test4 {
+		jump test5
+	}
+
+	chain test5 {
+		jump test6
+	}
+
+	chain test6 {
+		jump test7
+	}
+
+	chain test7 {
+		jump test8
+	}
+
+	chain test8 {
+		jump test9
+	}
+
+	chain test9 {
+		jump test10
+	}
+
+	chain test10 {
+		jump test11
+	}
+
+	chain test11 {
+		jump test12
+	}
+
+	chain test12 {
+		jump test13
+	}
+
+	chain test13 {
+		jump test14
+	}
+
+	chain test14 {
+		jump test15
+		jump test15
+	}
+
+	chain test15 {
+	}
+}
+EOF
+
+if [ $? -eq 0 ];then
+	echo "Fail: Limited incorrectly applied"
+	exit 1
+fi
+ip netns del $user_owned_netns
+
+# Previously set value does not impact root namespace; check value from before
+new_value=$(sysctl -n net.netfilter.nf_max_table_jumps_netns)
+if [ "$new_value" -ne "$DEFAULT_SYSCTL" ];then
+	echo "Fail: Non-init namespace altered init namespace"
+	exit 1
+fi
+
+# Make non-init_user_ns owned netns, can not change value
+unshare -Un sysctl -w net.netfilter.nf_max_table_jumps_netns=1234 2>&1
+if [ $? -ne 0 ];then
+	echo "Fail: Error message incorrect when non-user-init"
+	exit 1
+fi
+
+# Double check user namespace can still see limit
+new_value=(unshare -Un sysctl -n net.netfilter.nf_max_table_jumps_netns)
+if [ "$new_value" -ne "$DEFAULT_SYSCTL" ];then
+	echo "Fail: Unexpected failure when non-user-init"
+	exit 1
+fi
+
+
+exit 0
-- 
2.49.0

