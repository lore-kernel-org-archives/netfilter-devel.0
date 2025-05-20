Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5195D22068B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 03:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747710528; cv=none; b=VMn3tNMvM5p727MrpHO1yQxo97ReFtuQdDyOVnhMhHGAdsvSm7cLByviCYkgzm+PbsEzFeCZ0aRdJ0JEYh7cuXcEQiUhbtW4IrWfIcXWzCtUpRecDBfSqHk9P9m6bPe7BuTrFEAH3xU5cB2zkVMXMn2a7usEpkhT4bOCHWOMuFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747710528; c=relaxed/simple;
	bh=vdIIY1S1wmfVIsUff1oQMDCgHrG30Cja0WZjrZNXMIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKpDd7PsI4KCABTg2wVaLIBPJsnX0ZM5WSjKefcqT4O1e/gpzYL54pXqhO5T86Dh28JbbLWEhVmvCGM7pp5l4pfz6PSJsVd/ymPy8CfjdtjGXqolM1Ul1XijiYy6r+6YBYJZ8kGJdI3Y805vzJe/Cx0D9s+2TNHXsoMPlLg6oMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ls1zJDlu; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ls1zJDlu"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6f8b81fda4aso34805486d6.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 May 2025 20:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747710525; x=1748315325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJdfUDoxKtA/DYlPOO+8dxjIDnUJI+GCCAOs5TClaRQ=;
        b=ls1zJDluPrgIKKiWqmE30SniUL6aNM2G7hvSAVSpW2mQhO1VSBNyAk7x2kO07ny/Z7
         C2awmVIyVTYyJhAoZogh28yMMwkb/wIq/3CaIOLtFtxSGA+dkRlYporW1A6Xr5MH5FMp
         It+Q5TtP3DaQV5omp6X7D057f//7Fr2Dyf3WaW3s+VrbssJB4yIhtK7kObztHnsOOJpe
         PtZfWGEMICE94C92PPLO//KeUgCdqW3VAEb6Sg3DrpdfAXdbZfqJphKMae/QBzgcaNxj
         PghCgPX9wy1cLGNMf6WZWftq9BsQOPr2jF6CJusLChxOi7rSLfafFTZ4bMAVjCK9Qhp5
         jREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747710525; x=1748315325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJdfUDoxKtA/DYlPOO+8dxjIDnUJI+GCCAOs5TClaRQ=;
        b=k1WwZpbA+A95pvk7Lli3m28vkmMqiG22QFwpJkbDfrdKb90Ff7bKLsk0X8ABpGujXe
         IrnNzsnmEvlnk70T5jQWost9bkSmyuIUsS2Oa/QdIGCkEfxTW4eP2Os1y/o7eCCcy/Yg
         F+vJDDjg9mZw4loI7dFB6DHnvyV/hrePOcZqNlBkUZpNj01QvhDq6buKkc1NqIssoPfs
         JOg8FF1zbd5mPMoyIjakIxOy3A4p6TtMW6g3nZlt581amquR/xVaxzloeofqWEKM6deX
         2r6/5ZMRfLPao0D4aoFAaG7xui5XT1VxKnG5jxgHGnVKzNGTSsPvoqqLNhfLS//PK/G+
         jRJg==
X-Gm-Message-State: AOJu0YzHmJL1ziX8DTxicU373L1pQLt91wjjSL2hOhV49WEhELCluDH8
	Nk0Kzn1SDJ5f5jyCAGXshQE85w2m2vowpEart/eT+a26U52Zrx5sG3QwTsX+ZA==
X-Gm-Gg: ASbGnctyQiq6bU3lF85euHTkUJ6nKFqNkhMOSrqf+hnB3fGA+8+BCfFfaA2wbslsFW7
	clHE89VxCT4ujfwYLQKz5H6UPDYqQsB/f10zhKJkaH/rFyMD6o/3sHDvAD9z05x+P55+LF+bujI
	74OhB8itvD0RYmijhP2WD5Mn6hPDfXIZxfnW6UtX2mg5lBP/Ql4zhdqJPnNDqq3lehNk4jA/K+8
	gflP7A+Fw7gFR/Iq7o7aKGGlIFYknTEayhyibptBlhiIE8iM1CMQDRmgfkUUY8aBYldtKjhopfU
	+KbFsP8zc3bMfdCVUWzcHx2odwowG7aNdGWGJUXWnSklpdBIeEKwqPwRr6BLQF0HD92825ykvh8
	lm0d9DUVIjA8=
X-Google-Smtp-Source: AGHT+IH47GJi+dLiVF2Y0GmVAGXaiiVbViDM34k7l1LZl7mB3PTo1WT1FAYOI8544uF9Ud2VXpoeuw==
X-Received: by 2002:a05:6214:20ab:b0:6e8:f433:20a8 with SMTP id 6a1803df08f44-6f8b080f72dmr241858966d6.9.1747710524891;
        Mon, 19 May 2025 20:08:44 -0700 (PDT)
Received: from fedora.. (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b097a3dbsm65449146d6.101.2025.05.19.20.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 20:08:44 -0700 (PDT)
From: Shaun Brady <brady.1345@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: ppwaskie@kernel.org,
	fw@strlen.de,
	pablo@netfilter.org
Subject: [PATCH v5 2/2] Add test for nft_max_table_jumps_netns sysctl
Date: Mon, 19 May 2025 23:08:42 -0400
Message-ID: <20250520030842.3072235-2-brady.1345@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520030842.3072235-1-brady.1345@gmail.com>
References: <20250520030842.3072235-1-brady.1345@gmail.com>
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
index ffe161fac8b5..bc7df8feb0f7 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -23,6 +23,7 @@ TEST_PROGS += nft_concat_range.sh
 TEST_PROGS += nft_conntrack_helper.sh
 TEST_PROGS += nft_fib.sh
 TEST_PROGS += nft_flowtable.sh
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

