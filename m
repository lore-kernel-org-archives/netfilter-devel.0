Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E326E6FE
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 12:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751373722; cv=none; b=bpFAhAo3S93VSsnx+SlLjQ1arUqyc4tDce/108/ArPFAGMQq00aDqXuG1jURxtuio1n5Ula9QAZIk7mF40t+LEVUiW7flSNepuJ6siGboVJTh8Op+fn8e4o4RCHW1dhLZmXjwbQah1ufSGWYyIK3Fc4AnWFc6QEQ6c98Qog3fis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751373722; c=relaxed/simple;
	bh=zu6Nxjmvz6FEP+HM9s3AttlX8/ZOhwPYczOBXbk3kWo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eQMwb5yB2NI3BNF+pXlkCgxZIaE2p6xUARmueG1J1T2827ST/y3Di88IfmPJHzLWi9UZ6FoQ3x+NK4ZnJ8kMKeNllQv9tG6hN755J98GpvxWG9r9Fn6BDRqRL6FQAoWnlvawqolfTOVs5iCwCTIMXs2/iv+ZTPkqfY0WqtJ6RFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BB38C6061F; Tue,  1 Jul 2025 14:41:57 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] selftests: netfilter: nft_concat_range.sh: send packets to empty set
Date: Tue,  1 Jul 2025 14:41:37 +0200
Message-ID: <20250701124145.20954-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The selftest doesn't cover this error path:
 scratch = *raw_cpu_ptr(m->scratch);
 if (unlikely(!scratch)) { // here

cover this too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 can also be applied to -next, but I see no reason to defer this.

 tools/testing/selftests/net/netfilter/nft_concat_range.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index cd12b8b5ac0e..20e76b395c85 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -1311,6 +1311,9 @@ maybe_send_match() {
 # - remove some elements, check that packets don't match anymore
 test_correctness_main() {
 	range_size=1
+
+	send_nomatch $((end + 1)) $((end + 1 + src_delta)) || return 1
+
 	for i in $(seq "${start}" $((start + count))); do
 		local elem=""
 
-- 
2.49.0

