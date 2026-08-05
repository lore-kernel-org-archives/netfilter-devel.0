Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1BF48A2B1
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785947968; cv=none; b=rMr+TlratnUrVFuOWyoSpJi/iS1Zp0XhIKfTfToLQusYg8AiFO7p4XHu/k6015z6C/1TcqV7bUyh2gtxuuJgQaCaT/CkaKRQTwcDdECtm5hJ74bf3/+858xLRmG1Y557cXQ/j+eHiGrl295Eh5VLZIRaOHBRmcpwYpZl9dAUSdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785947968; c=relaxed/simple;
	bh=Cplh6r9Ng0/E/hFbZCLGslOl7O0JvnkplUxQaADPx6Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqXGzGbNKHhx0f48HfIIDqdOHoCi1G9n4ABfjp9evnYbFHkxFyY0i22x69g27veY/i8es8TnB8k44kD0zA+yFwx/d9wNTPraTnhpxaRrKul11d6/qLqj76t6LRtlMm27ZvudLF+ZlrUNBV1W5PBb0Wn2YGb2PyqgDLcaX9RdP/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Bmst8dLs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Bmst8dLs"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 037C660296
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 18:39:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785947965;
	bh=9RhvJkoHy5RzkMUXU7awDmT0ETkosyjpv8ghSifCmTE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Bmst8dLs2ILB/QTwQ0HRvpof8Q0Yv3cV2jUnHPhzOGzWJls5RrhCRIreyYoY0F6rJ
	 opRx3vh0ZZ6kd9Vq3Utb8FHgK05kz8pb5pFO1gfGjBDTIaayqb1N12k363CfVqRLKD
	 56OEYr8OJu5YdnsdGRp/khAetL7H7tWNQGS4qwWPqRyq1hppTzP5InwZ4Qe5FsyDGm
	 i8UevvT3hfxXRTWegR80jFhk7NTuxq7BmDSfOlHq+csGBrxtF4N8ayAucL0gi4y07T
	 PJh8oA419xv/fbW76hD0sur4VVjdDsfQS7h91Ai9IaZX5tirqJiJym+95wEO1SuIt8
	 XRMoNgChWLGUA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] tests: shell: add flush set after expiration
Date: Wed,  5 Aug 2026 18:39:20 +0200
Message-ID: <20260805163920.238975-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805163920.238975-1-pablo@netfilter.org>
References: <20260805163920.238975-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new test to cover for flush commands after elements have expired,
this allowed me to catch a bug in:

("netfilter: nf_tables: call set ops .commit when building new ruleset")

This tests works fine with <= 7.2-rc6, this is not specifically covering
any existing regression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../sets/dumps/flush_after_expiration.nodump  |  0
 .../testcases/sets/flush_after_expiration     | 45 +++++++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/flush_after_expiration.nodump
 create mode 100755 tests/shell/testcases/sets/flush_after_expiration

diff --git a/tests/shell/testcases/sets/dumps/flush_after_expiration.nodump b/tests/shell/testcases/sets/dumps/flush_after_expiration.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/sets/flush_after_expiration b/tests/shell/testcases/sets/flush_after_expiration
new file mode 100755
index 000000000000..eaf03a546ca0
--- /dev/null
+++ b/tests/shell/testcases/sets/flush_after_expiration
@@ -0,0 +1,45 @@
+#!/bin/bash
+
+$NFT -f - <<EOF
+table ip x {
+        set s0 {
+                type inet_service
+                elements = { 20, 21, 22 }
+                flags interval
+                timeout 3s
+        }
+}
+EOF
+
+sleep 6
+
+$NFT flush set ip x s0
+
+$NFT -f - <<EOF
+table ip x {
+        set s1 {
+                type ipv4_addr . inet_service
+                elements = { 1.2.3.4 . 20, 1.2.3.5 . 21, 1.2.3.6 . 22 }
+                flags interval
+                timeout 3s
+        }
+}
+EOF
+
+sleep 6
+
+$NFT flush set ip x s1
+
+$NFT -f - <<EOF
+table ip x {
+        set s2 {
+                type ipv4_addr
+                elements = { 2.2.2.1, 2.2.2.2, 2.2.2.3 }
+                timeout 3s
+        }
+}
+EOF
+
+sleep 6
+
+$NFT flush set ip x s2
-- 
2.47.3

