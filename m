Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0E83998BA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 10:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802930; cv=none; b=IXxf3utpO7FpscIrVhukOcyGgkNsBtVHiucO+8+SjdWu69UMG9KehqveQl+BWHPxlNZzcwLHdmG5l8zhhjDJLDHFkf2sgWQkSTln+hLX2+OrhM48QEAsc5yk13f/Rzafv5iK/Gt465ldUQVcjBxgP71deSgp6Nw8VnclNrbhrek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802930; c=relaxed/simple;
	bh=rVBPqRleV3+yk6FI+JR60wl+kQmhihTPhHIdl/3oAVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyPRtiMz8D6hi8qci/ktVK5NzPtC/3wcr8Fvv4VJc016PjhodbENkzBQ51uGXaJZZS5QnalMrOqVgyLRtXTngO6AcFw2esODqQqvmLYC/AT17i8O5Qz9O+v4Bzwz0it6exfsgy+136ixzJIvKoxoPCVc6pMRCgjWHYepZuZIVd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F3FEA60E9D; Thu, 23 Jul 2026 12:35:18 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: kadlec@netfilter.org
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 1/5] tests: check_extensions: introduce and use IPSET_MACHINE_SLOW
Date: Thu, 23 Jul 2026 12:35:00 +0200
Message-ID: <20260723103504.3175-2-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723103504.3175-1-fw@strlen.de>
References: <20260723103504.3175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running ipset tests on my laptop with a debug kernel (i.e. kasan,
kmemleak and so on) fails the check_extensions subtests because the
observed timeout is below the lower threshold.  Add IPSET_MACHINE_SLOW,
similar to KSFT_MACHINE_SLOW used in the kernel kselftest framework.

If set, raise the slack value to 30s.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/check_extensions | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/tests/check_extensions b/tests/check_extensions
index 77e7c2cd8b90..ce39366ad46d 100755
--- a/tests/check_extensions
+++ b/tests/check_extensions
@@ -1,11 +1,26 @@
 #!/bin/bash
 
 ipset=${IPSET_BIN:-../src/ipset}
+setname="$1"
+elem="$2"
+wanted_timeout="$3"
+wanted_packets="$4"
+wanted_bytes="$5"
 
-read ip t timeout p packets b bytes <<< $($ipset l $1 | grep ^$2)
-test -z "$timeout" -o -z "$packets" -o -z "$bytes" && exit 1
-test $timeout -gt $3 -o $timeout -lt $(($3 - 10)) && exit 1
-test $packets -ne $4 -o $bytes -ne $5 && exit 1
+allowed_slack=10
+[ "$IPSET_MACHINE_SLOW" = "yes" ] && allowed_slack=30
+
+die() {
+	echo "FAIL: $0: $@"
+	exit 1
+}
+
+timeout_lower=$((wanted_timeout - allowed_slack))
+
+read ip t timeout p packets b bytes <<< $($ipset l $setname | grep ^$elem)
+test -z "$timeout" -o -z "$packets" -o -z "$bytes" && die "at least of one timeout $timeout, packets $packets, bytes $bytes not set"
+test $timeout -gt $wanted_timeout -o $timeout -lt $timeout_lower && die "timeout $timeout gt $wanted_timeout or $timeout lt $timeout_lower"
+test $packets -ne $wanted_packets -o $bytes -ne $wanted_bytes && die "packets $packets ne $wanted_packets or $bytes ne $wanted_bytes"
 exit 0
 
 
-- 
2.54.0

