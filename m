Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA4A2FA634
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753282850; cv=none; b=k7nPtBiyE5H9A8z0Vw5MGemDv31cFuhaOvLCPyGbDDCOyAebRJLGd1chQ2KvlA29b6N93pNLi8ljqpfb1tSwLV1oIVSsiFINuj90y3mNfoPsfeASQjZg3C5m+Xpl6ABuK0OpIihvNGUKItJlCbhKWLV8d6gOLWTQHlL4ChCGXiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753282850; c=relaxed/simple;
	bh=/7F6iHEJyJ9us8zf3uFT2gJWNTWeUCu9TejxWwxnKZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edoGx4NTTHuVt7JkanrG9heM7J8i9fDAJyyADId5k8FvvAyMB7YEyEGHhtZMWHQ4RjIfADAXfWnTs5FvQ5hXQnzAlGriU6pZ3qC4o9YdDgTJxU3JJLPC8SKIXeJyLX71wuzzZZIeL6FqY+gz5NDLoLHhxYLyHRPpFiFGkhvDhJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 89DC96048A; Wed, 23 Jul 2025 17:00:26 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: fix memory leak when parsing flowtable hook declaration
Date: Wed, 23 Jul 2025 17:00:11 +0200
Message-ID: <20250723150021.10811-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <netfilter-devel>
References: <netfilter-devel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the hook location is invalid we error out but we do leak both
the priority expression and the flowtable name.  Example:

valgrind --leak-check=full nft -f flowtable-parser-err-memleak
[..] Error: unknown chain hook
hook enoent priority filter + 10
     ^^^^^^
[..]
2 bytes in 1 blocks are definitely lost in loss record 1 of 3
   at: malloc (vg_replace_malloc.c:446)
   by: strdup (in libc.so.6)
   by: xstrdup (in libnftables.so.1.1.0)
   by: nft_lex (in libnftables.so.1.1.0)
   by: nft_parse (in libnftables.so.1.1.0)
   by: __nft_run_cmd_from_filename (in libnftables.so.1.1.0)
   by: nft_run_cmd_from_filename (in libnftables.so.1.1.0)

First two reports are due to the priority expression: this needs to call
expr_free().  Third report is due to the flowtable name, the destructor
was missing so add one.

After fix:
All heap blocks were freed -- no leaks are possible

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                           | 3 ++-
 .../testcases/bogons/nft-f/flowtable-parser-err-memleak      | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/flowtable-parser-err-memleak

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5b84331f220d..aacfa2917917 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -719,7 +719,7 @@ int nft_lex(void *, void *, void *);
 %destructor { handle_free(&$$); } obj_spec objid_spec obj_or_id_spec
 
 %type <handle>			set_identifier flowtableid_spec flowtable_identifier obj_identifier
-%destructor { handle_free(&$$); } set_identifier flowtableid_spec obj_identifier
+%destructor { handle_free(&$$); } set_identifier flowtableid_spec flowtable_identifier obj_identifier
 
 %type <handle>			basehook_spec
 %destructor { handle_free(&$$); } basehook_spec
@@ -2427,6 +2427,7 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 					erec_queue(error(&@3, "unknown chain hook"),
 						   state->msgs);
 					free_const($3);
+					expr_free($4.expr);
 					YYERROR;
 				}
 				free_const($3);
diff --git a/tests/shell/testcases/bogons/nft-f/flowtable-parser-err-memleak b/tests/shell/testcases/bogons/nft-f/flowtable-parser-err-memleak
new file mode 100644
index 000000000000..ca0480bfc943
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/flowtable-parser-err-memleak
@@ -0,0 +1,5 @@
+table ip t {
+        flowtable f {
+                hook enoent priority filter + 10
+        }
+}
-- 
2.49.1

