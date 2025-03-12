Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE921F2365;
	Wed, 12 Mar 2025 23:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821509; cv=none; b=Xkj2H8DUnWrcWElizto7rkt2DX+ZTyZTMOEq57X9grayhHw773h8RwiMaoxbqJ6kVPd8PiRvaXjJ12iwcWcw/naegQQcoMDX4Nz9bRb5r3mch8XgKQtpr1hUUHlGEGXG3Fv2O0rJ8nqB+Mpl0CQE73b/39v98lmJpqVw+zJOdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821509; c=relaxed/simple;
	bh=jwDLIPRDw7fhdn/k6p9BtqhraUokmqVoEtgSeZtpe6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jQKYjs/6bPUq2HKMjtZvF1Fk0CXqcnuvZLNgqyMh61fOshO91Qi15C3R0yLAz7nsvVnqW5OBdR4musyh95YvWmVvqsUjvl8zDgJwO6DjosZyMA8u6vR1+KHKp+cjFVY7UzgY5pSlxTyEPhDIAKjfcb5fKA8YtnSABG3L33y6a+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RW5lar1/; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aYivw0U0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RW5lar1/";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aYivw0U0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7EF53602A2; Thu, 13 Mar 2025 00:18:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821505;
	bh=e0AmXukwq9P57vmpf7gE0yMY2x9P0bff4+QdRRFXZkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RW5lar1/0So7Ime/myTrD3r31Tu0111CoDvpUZikuZpRSD3IEKzDwRIowiRo4x3ZD
	 UMFZsg8a0cYqPwXPtXCk1FXqk16+ebXUFYSKm9RpKZCUd/it79A7KNlPz7C0L3FRXo
	 cs2v3sUOLyqCNoOPULJVVa/Vpl4EtvQeGMAvqgu5wstykjgKHMbb2KXoREVeVZYQTQ
	 vzZF8a12KM+XTClVZFqXYiGka8+sX5gN78CtQW3XAFXep0Av4XE6V9E/9QK+t8rGIo
	 YdYoCnXmvTxoZsnhJsd8Ss/RjGEl5PHM00S/ttwOOZ610l1gct7/gdp7fWhmFpgA1G
	 YGTuWWVASxnBA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6DBCA6028A;
	Thu, 13 Mar 2025 00:18:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741821501;
	bh=e0AmXukwq9P57vmpf7gE0yMY2x9P0bff4+QdRRFXZkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYivw0U0sw9o8MXvkyiLbv2vE/tJvCa3HySiiCx/8Xj0NfCjSxEHHtz82YJvCH9Zr
	 CVpIEmaAEaucTUmc1MnxIicu2AvgVSCDZs15k/nQhpYm/UKrErC9q/PlvO2yw1hfZl
	 A4Az48FEDtVKvS4K7lQ1X3FcmdNhum29+UbQqYr/p+Wa+XOaxaIPdRQuXQYpnC3JGU
	 BNtEowcPbuVz7JvMrAPby1nCBM86xid3GrBUxk6JsVnJbQ5yYCiGfVS9oyu09GWUal
	 +OwLWhTVpSj8ZBqo9/Nmhez5QY2rVuIFdyXj25m3nvNfUkcJxBRaq+ALz9LrqUVack
	 bYg/XQf07ULyw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/3] selftests: netfilter: skip br_netfilter queue tests if kernel is tainted
Date: Thu, 13 Mar 2025 00:18:11 +0100
Message-Id: <20250312231812.4091-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250312231812.4091-1-pablo@netfilter.org>
References: <20250312231812.4091-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

These scripts fail if the kernel is tainted which leads to wrong test
failure reports in CI environments when an unrelated test triggers some
splat.

Check taint state at start of script and SKIP if its already dodgy.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/br_netfilter.sh      | 7 +++++++
 .../testing/selftests/net/netfilter/br_netfilter_queue.sh  | 7 +++++++
 tools/testing/selftests/net/netfilter/nft_queue.sh         | 1 +
 3 files changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/br_netfilter.sh b/tools/testing/selftests/net/netfilter/br_netfilter.sh
index c28379a965d8..1559ba275105 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter.sh
@@ -13,6 +13,12 @@ source lib.sh
 
 checktool "nft --version" "run test without nft tool"
 
+read t < /proc/sys/kernel/tainted
+if [ "$t" -ne 0 ];then
+	echo SKIP: kernel is tainted
+	exit $ksft_skip
+fi
+
 cleanup() {
 	cleanup_all_ns
 }
@@ -165,6 +171,7 @@ if [ "$t" -eq 0 ];then
 	echo PASS: kernel not tainted
 else
 	echo ERROR: kernel is tainted
+	dmesg
 	ret=1
 fi
 
diff --git a/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh b/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
index 6a764d70ab06..4788641717d9 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter_queue.sh
@@ -4,6 +4,12 @@ source lib.sh
 
 checktool "nft --version" "run test without nft tool"
 
+read t < /proc/sys/kernel/tainted
+if [ "$t" -ne 0 ];then
+	echo SKIP: kernel is tainted
+	exit $ksft_skip
+fi
+
 cleanup() {
 	cleanup_all_ns
 }
@@ -72,6 +78,7 @@ if [ "$t" -eq 0 ];then
 	echo PASS: kernel not tainted
 else
 	echo ERROR: kernel is tainted
+	dmesg
 	exit 1
 fi
 
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 785e3875a6da..784d1b46912b 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -593,6 +593,7 @@ EOF
 		echo "PASS: queue program exiting while packets queued"
 	else
 		echo "TAINT: queue program exiting while packets queued"
+		dmesg
 		ret=1
 	fi
 }
-- 
2.30.2

