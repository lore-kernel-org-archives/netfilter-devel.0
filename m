Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C522641D4;
	Thu, 13 Mar 2025 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741859811; cv=none; b=nGxiJPGgXIKXrlqaf9KR7BjRCLWfkRDx6jmEF+chC2oDe9YK5+86NelV8oQIThuLbFygFloGGR871H7zhfSs2r6dtbwDu4MI01HORRfRF1O4fOCQA/gSy78yPa82GIxxgmQDtL45UDi+YBfZbdr/N9nPIt8X9GpXSWxT+f/acus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741859811; c=relaxed/simple;
	bh=jwDLIPRDw7fhdn/k6p9BtqhraUokmqVoEtgSeZtpe6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h/5a4KPSn00Pluu+Iwug45cFjbSvLT6MxLzdSeJdTe9MxfyVWfMPJjkflYelCMtuiALtmfD/NpgJqgWsle5PozKypeEonwLfjT680Whg7WaGEybmArgIF9H36itOLxbr24mPK+F8NkxQL4sXArRSQeC19mojXUhpaeK93Mw5xlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ykv5lFwR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IyAt+bW5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ykv5lFwR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IyAt+bW5"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 24871602BC; Thu, 13 Mar 2025 10:56:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859808;
	bh=e0AmXukwq9P57vmpf7gE0yMY2x9P0bff4+QdRRFXZkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ykv5lFwR35ScQgf13RBr2GfCb+xW/xZYgaHjvy3gT3wXk4337gz/w+B3p+7HKPjh3
	 XphYj5gCzwR471J7PASpN16n2+dloUCXLcGx5lqJYd1QD0mNJmQSiYjRxktPzqxliU
	 xyqw1P8N8md9GWmagal3Hw76dSGEPaLQMsIJIaitJpzXK0pvUs+Hs8qyUWER8xFo1V
	 EkD4nWPShw8qRxZk4nh6Soc35bQV26gx2hT3gSo5al/jUKWeWN1j47s2aXLR+G2gVf
	 N6penQ44sqz1Ope4S2zMDl0sx+FPeYFVAVqy+gEVF9vo6cEEChnuLpljR5prbwSIFk
	 IfCwewm4qoC1g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3DCD560292;
	Thu, 13 Mar 2025 10:56:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741859803;
	bh=e0AmXukwq9P57vmpf7gE0yMY2x9P0bff4+QdRRFXZkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyAt+bW5aNar+6JeWP5nFHVczawDC5JVRnaejabk+SOwf9izvUMnKMAx/qWE27lPg
	 HpiSpgrEM+hHoEOLS6QrF9S+MMBFUkEl+XTU5KoMjYQB1wussdT64KrmFaS9sCjMkE
	 Taduj/6KLEPyFnWJHvHywahLNXyIFTMmZTa7TEixIEMay6EDvrfnOiEq6lD0ELm+Dy
	 4yZY5o7de4H0Goq9NmkM0VDKqIdhUO9BXtRdmjbOZmkl+hLhGNMJY6U/xRGwcBSDTk
	 K/oYEY51fXK/huGBmj9pU2kI5Gd9WW0fq6bEwz6KiblUYLW2BQhXQCBcWAL00k8vsR
	 1tkfMW7HI02wg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/4] selftests: netfilter: skip br_netfilter queue tests if kernel is tainted
Date: Thu, 13 Mar 2025 10:56:34 +0100
Message-Id: <20250313095636.2186-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250313095636.2186-1-pablo@netfilter.org>
References: <20250313095636.2186-1-pablo@netfilter.org>
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

