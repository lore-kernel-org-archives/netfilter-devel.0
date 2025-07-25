Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F396D2EFD84;
	Fri, 25 Jul 2025 17:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463070; cv=none; b=MhIaThe9yW/DukyXZL08v+YCDWl9KmFwddgGomXygxEOZ6HRq2BbzrYklmT58ON0858ctTOb2zB3rP6COr0JGBS8yzNJD9AB2OOIesk6icTmvA1ZGtCGAxjYav8qnJICCs43B4LddDtiaFDrTKVVttPG/MwgcLBK8WfYZ3gGOxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463070; c=relaxed/simple;
	bh=MvtH8oKf087cTSZ5q4iB+GqBbKsp39ZnUfk+VCZterc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=peMrK52GpTf+dTC6UAhT7dttx36DUESRSLr1Ff/I6bqZNilzk8XKKgCthdZGhuhYpBY/hOxqaDqpvmhYe2KjYZn0pri1i8obsSkKj1vlClRdFf9vSmunK4UuDtukbtbYWE+WFWh/0mK7491UwaFgxSJCTzkU/3Hup03mFBqJW94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pA0Rnf+D; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XDqLOXUq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pA0Rnf+D";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XDqLOXUq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 973BD60289; Fri, 25 Jul 2025 19:04:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463067;
	bh=jByCPyWJ5BfM48/VjjBSe77goW0f0PzFnuHNkPzB4Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pA0Rnf+DjhIqgijHPAKcCZfJfHcuzACROJVk7/oZZXmh78jGkod4S3EA5IG3ACgZb
	 ZN5hluFLXl7Q3HiEaQIrRPsvdKrvWST5o8Z322o59ts9vFb81FM7qrXM2vc0DqaT1V
	 kN6n0UslerYQL43C8SQwPGwL2YHNORkqRKIbqhtuokawaTq3orDrDLZ1KrMgsqoA4L
	 No6pD/Jww079VNB+Juz6G7cdbOI2zjJiEMkkL+8ZtFJiCiMxMVHYWbupc2iE6RKoe+
	 N3ZcGJJYrCcgSVMAnk3+0M49iqi521SbHdOjWx7iopckVqkNolxBIozEF77peL5uF7
	 th2UV+vdVy3Dg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2947960283;
	Fri, 25 Jul 2025 19:04:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463061;
	bh=jByCPyWJ5BfM48/VjjBSe77goW0f0PzFnuHNkPzB4Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDqLOXUq7xH4PBh63oYJkNSZCfhi6PgYPxdR4Pf4/ieIwC8zg8KI7rl78MoAme9Il
	 Cw4dIAwI3F1uCfiE8d16MOyohCnBmjZMdL6iSw4PA2J2LPxWl5FEawI4d5sqeNv4K4
	 yr7chUdWbBCIVPpg4AGf6ADoYAU3kWRlaeKnfy7wRKd0OsVVq6he4JRJrB+zir0col
	 xAdK9dcGMJ81AIQSG+qA1MKJbtfdh36fbtG3/0nNL3dEhddeo5l8gQ0D2WhwYAeHMC
	 1gSiLH8xMBdJz0L/xlW51nTUZp8LBt992NRAW74PuSOUTwy6130BqIkgLghyOjI4GQ
	 1VLw4u2f7mCLw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 18/19] selftests: netfilter: Ignore tainted kernels in interface stress test
Date: Fri, 25 Jul 2025 19:03:39 +0200
Message-Id: <20250725170340.21327-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Complain about kernel taint value only if it wasn't set at start
already.

Fixes: 73db1b5dab6f ("selftests: netfilter: Torture nftables netdev hooks")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/net/netfilter/nft_interface_stress.sh  | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
index 5ff7be9daeee..c0fffaa6dbd9 100755
--- a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
+++ b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
@@ -10,6 +10,8 @@ source lib.sh
 checktool "nft --version" "run test without nft tool"
 checktool "iperf3 --version" "run test without iperf3 tool"
 
+read kernel_tainted < /proc/sys/kernel/tainted
+
 # how many seconds to torture the kernel?
 # default to 80% of max run time but don't exceed 48s
 TEST_RUNTIME=$((${kselftest_timeout:-60} * 8 / 10))
@@ -135,7 +137,8 @@ else
 	wait
 fi
 
-[[ $(</proc/sys/kernel/tainted) -eq 0 ]] || {
+
+[[ $kernel_tainted -eq 0 && $(</proc/sys/kernel/tainted) -ne 0 ]] && {
 	echo "FAIL: Kernel is tainted!"
 	exit $ksft_fail
 }
-- 
2.30.2

