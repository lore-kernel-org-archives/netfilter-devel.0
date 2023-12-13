Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7261783
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 02:18:20 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDMJn-00077v-3L; Wed, 13 Dec 2023 11:18:19 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: fix memory leaks on hookspec error processing
Date: Wed, 13 Dec 2023 11:18:06 +0100
Message-ID: <20231213101810.12316-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

prio_spec may contain an embedded expression, release it.
We also need to release the device expr and the hook string.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                            |  7 +++++++
 .../bogons/nft-f/memleak_on_hookspec_error    | 21 +++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/memleak_on_hookspec_error

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 2796e4387e03..e1addc26d20d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -727,6 +727,8 @@ int nft_lex(void *, void *, void *);
 %type <val>			family_spec family_spec_explicit
 %type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
+%destructor { expr_free($$.expr); } extended_prio_spec prio_spec
+
 %type <string>			extended_prio_name quota_unit	basehook_device_name
 %destructor { free_const($$); }	extended_prio_name quota_unit	basehook_device_name
 
@@ -2636,6 +2638,9 @@ hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
 					erec_queue(error(&@3, "unknown chain type"),
 						   state->msgs);
 					free_const($3);
+					free_const($5);
+					expr_free($6);
+					expr_free($7.expr);
 					YYERROR;
 				}
 				$<chain>0->type.loc = @3;
@@ -2649,6 +2654,8 @@ hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
 					erec_queue(error(&@5, "unknown chain hook"),
 						   state->msgs);
 					free_const($5);
+					expr_free($6);
+					expr_free($7.expr);
 					YYERROR;
 				}
 				free_const($5);
diff --git a/tests/shell/testcases/bogons/nft-f/memleak_on_hookspec_error b/tests/shell/testcases/bogons/nft-f/memleak_on_hookspec_error
new file mode 100644
index 000000000000..6f52658fb986
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/memleak_on_hookspec_error
@@ -0,0 +1,21 @@
+table ip filter {
+	ct expectation ctexpect {
+		protocol tcp
+		size 12
+		l3proto ip
+	} . inet_proto : mark
+		flags interval,timeout
+	}
+
+	chain output {
+		type gilter hook output priori
+
+	chain c {
+		cttable inet filter {
+	map test {
+		type mark . inet_service . inet_proto : mark
+		flags interval,timeout
+	}
+
+	chain output {
+		type gilter hook output priority filuer; policy 
\ No newline at end of file
-- 
2.41.0

