Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7780C47F4A
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 21:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750800070; cv=none; b=LpdNaxrJG/MNR0VevP7iv9pQ9VgAaKZcQSnfpCnd3bsHMdjZSTv3nTHMBHr5UaVnUbpL7vu0twFmf00lsi5dQbZFnUTrIwoqrYQazh+LaaBfTr6QkDhc/A6EJ4WOBsQJLf9Vz7Aj402HXZL+s0lf07Y38JNy3rBrsh9bqW6eTuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750800070; c=relaxed/simple;
	bh=D8SgcCbLvEg7pbZcUKRHTaddiHJzMj2Z7k/nF6e9uNY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OLNWAEf+RRIM5B0Np7jgb5B1bara33flPmJhjNv006afLZgF5LBjAEZfuzvZKZxoJof5AwkUzBxwdfWIsyrB8lAJGYOTs8VO2A0dVXQCkU8U6mrh5f0fIVvRTt0j0BiWoKXt/UHnnXRlNWpj2RRYFQOdvvvQ9sGYFF708aoTzkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 733FC61597; Tue, 24 Jun 2025 23:21:06 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: avoid double-free on error handling of bogus objref maps
Date: Tue, 24 Jun 2025 23:20:58 +0200
Message-ID: <20250624212101.18722-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 98c51aaac42b ("evaluate: bail out if anonymous concat set defines a non concat expression")
clears set->init to avoid a double-free.

Extend this to also handle object maps.
The included bogon triggers a double-free of set->init expression:

Error: unqualified type invalid specified in map definition. Try "typeof expression" instead of "type datatype".
ct helper set ct  saddr map { 1c3:: : "p", dead::beef : "myftp" }
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This might not crash, depending on libc/malloc, but ASAN reports this:
==17728==ERROR: AddressSanitizer: heap-use-after-free on address 0x50b0000005e8 at ..
READ of size 4 at 0x50b0000005e8 thread T0
    #0 0x7f1be3cb7526 in expr_free src/expression.c:87
    #1 0x7f1be3cbdf29 in map_expr_destroy src/expression.c:1488
    #2 0x7f1be3cb74d5 in expr_destroy src/expression.c:80
    #3 0x7f1be3cb75c6 in expr_free src/expression.c:96
    #4 0x7f1be3d5925e in objref_stmt_destroy src/statement.c:331
    #5 0x7f1be3d5831f in stmt_free src/statement.c:56
    #6 0x7f1be3d583c2 in stmt_list_free src/statement.c:66
    #7 0x7f1be3d42805 in rule_free src/rule.c:495
    #8 0x7f1be3d48329 in cmd_free src/rule.c:1417
    #9 0x7f1be3cd2c7c in __nft_run_cmd_from_filename src/libnftables.c:759
    #10 0x7f1be3cd340c in nft_run_cmd_from_filename src/libnftables.c:847
    #11 0x55dcde0440be in main src/main.c:535

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                        |  2 +-
 tests/shell/testcases/bogons/objref_double_free_crash | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/objref_double_free_crash

diff --git a/src/evaluate.c b/src/evaluate.c
index 699891106cb9..204796d00800 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -137,7 +137,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	handle_merge(&set->handle, &ctx->cmd->handle);
 
 	if (set_evaluate(ctx, set) < 0) {
-		if (set->flags & NFT_SET_MAP)
+		if (set->flags & (NFT_SET_MAP|NFT_SET_OBJECT))
 			set->init = NULL;
 		set_free(set);
 		return NULL;
diff --git a/tests/shell/testcases/bogons/objref_double_free_crash b/tests/shell/testcases/bogons/objref_double_free_crash
new file mode 100644
index 000000000000..52b0435bfddc
--- /dev/null
+++ b/tests/shell/testcases/bogons/objref_double_free_crash
@@ -0,0 +1,10 @@
+table arp test {
+	ct helper myftp {
+		type "ftp" protocol tcp
+		l3proto inet
+	}
+
+	chain y {
+		ct helper set ct  saddr map { 1c3:: : "p", dead::beef : "myftp" }
+	}
+}
-- 
2.49.0

