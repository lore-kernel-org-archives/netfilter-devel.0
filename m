Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00075130A73
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 08:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742460382; cv=none; b=cq84FaHFoGJmkWxr83Zo4GrTC/XIY0gRrk5ANDmmQf4K2f8FzZH/z9u2853dfCf8b2RIIhB14mYzU/iseq0J3E1GjWkRNEYCGs9Cqk4eLHKKmO4OGGSUjM3q3lg2uFAVC0cs1dn1H04NsV5YlL7NtPXFdrWL/pBApG5VPvaBRBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742460382; c=relaxed/simple;
	bh=K+CwmaP0tI3VYJgvLd/1ZO3XL/UcQ231M6W1jAgdV1g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qvOVp+VwyzrXjPEk/dvGMYL4yvP9TFJXW8xKFHaXHQ8sa00DJdrjowQm19zPsfFUv3GJJU2/v6HjusBKo4JIBng/ehSupSJectL+pYQVgtjeYs1bKvWehUUhgBZgazLGP6Xdp0Y96Wc5GxmIvqe8yqbMO4vGoK4lF7ZeZqsb2dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tvBXf-0000fc-0Y; Thu, 20 Mar 2025 09:46:19 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: don't allow nat map with specified protocol
Date: Thu, 20 Mar 2025 09:39:20 +0100
Message-ID: <20250320083944.12541-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon asserts:
src/netlink_linearize.c:1305: netlink_gen_nat_stmt: Assertion `stmt->nat.proto == NULL' failed.

The comment right above the assertion says:
  nat_stmt evaluation step doesn't allow
  STMT_NAT_F_CONCAT && stmt->nat.proto.

... except it does allow it.  Disable this.

Fixes: c68314dd4263 ("src: infer NAT mapping with concatenation from set")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                           | 4 ++++
 tests/shell/testcases/bogons/nat_map_and_protocol_assert | 5 +++++
 2 files changed, 9 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nat_map_and_protocol_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index 95b9b3d547d9..3a453d010538 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4196,6 +4196,10 @@ static int stmt_evaluate_nat_map(struct eval_ctx *ctx, struct stmt *stmt)
 	int addr_type;
 	int err;
 
+	if (stmt->nat.proto)
+		return stmt_binary_error(ctx, stmt, stmt->nat.proto,
+				  "nat map and protocol are mutually exclusive");
+
 	if (stmt->nat.family == NFPROTO_INET)
 		expr_family_infer(pctx, stmt->nat.addr, &stmt->nat.family);
 
diff --git a/tests/shell/testcases/bogons/nat_map_and_protocol_assert b/tests/shell/testcases/bogons/nat_map_and_protocol_assert
new file mode 100644
index 000000000000..67f2ae873cd1
--- /dev/null
+++ b/tests/shell/testcases/bogons/nat_map_and_protocol_assert
@@ -0,0 +1,5 @@
+table t {
+ chain y {
+  snat to ip saddr . tcp sport map { 1.1.1.1 . 1 : 1.1.1.2 . 1 } : 6
+ }
+}
-- 
2.48.1

