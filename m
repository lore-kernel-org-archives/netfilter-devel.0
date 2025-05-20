Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB98D1FECC3
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 00:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700682; cv=none; b=Klmncm44Jxp362Jwmp94s2NMdilRxYf2Y1EsrjMPAo84+e3zbsRrTTXFlfriIaSJUXXFBCjWBDEqRqUSN7W6hp1K6A7P+Ahv9uXcrufiLbgmAQqy9gcWQBKzBcch0KSXxxRxP9IwUJOd+ug4Dl872B/th1QAVnX2LZjgXqEKaUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700682; c=relaxed/simple;
	bh=b4zb/I77wEe/awwPBo8RwrXBiaMUX4MlAqsYL7ZOCmM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=rVQjn9zOPEcSrpZF10ZG6ssIGFbUo8K5Tyj+r6zThG1I9o/5npIidgn+2uFNy2VVda70d2DUigR15KQv2wf6gRMsJ2LhHJfRVU0yEB/96BQPhC0c7rwA9p/SehSBPlHiegBmglGZj/gFPGGiYLOylRxWoE1Tcy2C4y10BTE5tjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FbppF1ZA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FbppF1ZA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FbppF1ZA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FbppF1ZA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 46E7160278; Tue, 20 May 2025 02:24:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700679;
	bh=RmYAgSHoAqYrNVXJBtSz86JHjI8SvfR4AuUoK4UPykA=;
	h=From:To:Subject:Date:From;
	b=FbppF1ZAW+vWE25EgjBupdqQP7A+nyExoorA3q2gkGmicOe4NLierwzy+4ACas+ks
	 0r3kbge44ecMHkzWkUs0N/VqTRmoEfuQSYfVnAPoZ3aNHViyF+nH5nZhNJCI4lyoRC
	 +pHv49xGiP7hjAJT6dF6JYI0jxAvhD/NjXDnKdYPrgIXHtq/oAny4LRPd9NNqaTvd4
	 1wtBWIfKNeEpGu6r7JwQ1PCxidZ3gz+5uZrhSE8+BosOputNbrkwJ+tW7P6LklaTu7
	 EaMtz/3eC9gVn7Jco/Ox6A0Qis8LcjmwYDqZRF9SWHeYgXGP6FWKzOTBLWkTRUr5LK
	 5WvREuHP/lYPA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E8A9D60264
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 02:24:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700679;
	bh=RmYAgSHoAqYrNVXJBtSz86JHjI8SvfR4AuUoK4UPykA=;
	h=From:To:Subject:Date:From;
	b=FbppF1ZAW+vWE25EgjBupdqQP7A+nyExoorA3q2gkGmicOe4NLierwzy+4ACas+ks
	 0r3kbge44ecMHkzWkUs0N/VqTRmoEfuQSYfVnAPoZ3aNHViyF+nH5nZhNJCI4lyoRC
	 +pHv49xGiP7hjAJT6dF6JYI0jxAvhD/NjXDnKdYPrgIXHtq/oAny4LRPd9NNqaTvd4
	 1wtBWIfKNeEpGu6r7JwQ1PCxidZ3gz+5uZrhSE8+BosOputNbrkwJ+tW7P6LklaTu7
	 EaMtz/3eC9gVn7Jco/Ox6A0Qis8LcjmwYDqZRF9SWHeYgXGP6FWKzOTBLWkTRUr5LK
	 5WvREuHP/lYPA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: check if kernel supports for cgroupsv2 matching
Date: Tue, 20 May 2025 02:24:35 +0200
Message-Id: <20250520002435.185494-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update packetpath/cgroupv2 to skip it if kernel does not support it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/cgroupsv2.nft        | 7 +++++++
 tests/shell/testcases/packetpath/cgroupv2 | 1 +
 2 files changed, 8 insertions(+)
 create mode 100644 tests/shell/features/cgroupsv2.nft

diff --git a/tests/shell/features/cgroupsv2.nft b/tests/shell/features/cgroupsv2.nft
new file mode 100644
index 000000000000..b6a3869dbe89
--- /dev/null
+++ b/tests/shell/features/cgroupsv2.nft
@@ -0,0 +1,7 @@
+# e0bb96db96f8 ("netfilter: nft_socket: add support for cgroupsv2")
+# v5.13-rc1~94^2~35^2~20
+table ip t {
+	chain c {
+		socket cgroupv2 level 1 "user.slice" counter
+	}
+}
diff --git a/tests/shell/testcases/packetpath/cgroupv2 b/tests/shell/testcases/packetpath/cgroupv2
index 65916e9db1e8..0a6199fee91f 100755
--- a/tests/shell/testcases/packetpath/cgroupv2
+++ b/tests/shell/testcases/packetpath/cgroupv2
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_cgroupsv2)
 
 doit="$1"
 rc=0
-- 
2.30.2

