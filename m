Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC1D2DCF7D
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773251567; cv=none; b=uwOh4E+q7a4fYXW17ID/RdCsSuOsAHVmUmdjkjjMJcnEHssFN5vTifET3QDjptuGQkt52Q8Eip/6MdgpdPINIVU8CyOONVwLNit69qg0CNM+PW/zCNU18QUBgJVljCoNClg3QDQlFYv02MdQhixwJPDS2QCng+G7oTP/AI9QzOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773251567; c=relaxed/simple;
	bh=84OeYUnBPUpKBvgee0vck6zzuiPpyYT/kLX9Ja/IhRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tgGj3ghpOEOuH98NxvqqkoWWj/3OZmbQ3rO9l8mrr7+uKvgrf8OboaGUJyjvBCArAmYikfrii5zix8EVZ1LvO1wYBjcEOnynJx2b7C4aI7p8F9hWyUcGGWoHfMhhS3ud9hJUf+npa+1QRGJ/hf88ZjxTBU+vNpSrr2uuLf+sKbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E79866047A; Wed, 11 Mar 2026 18:52:37 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: add range check for synproxy wscale
Date: Wed, 11 Mar 2026 18:52:31 +0100
Message-ID: <20260311175234.24220-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After: nft -f wscale
Error: wscale must be in range 0-14
 wscale 15
        ^^

As-is the bogus value makes it to the kernel. Upcoming nf-next patch
adds futher checks to value attributes and will reject this.

Also catch this from parser and fix the single_flag test case.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                     | 30 ++++++++++++++++++--------
 tests/shell/testcases/json/single_flag |  4 ++--
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6c0e29c82065..8a470bda942e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -816,6 +816,7 @@ int nft_lex(void *, void *, void *);
 %destructor { flowtable_free($$); }	flowtable_block_alloc
 
 %type <obj>			obj_block_alloc counter_block quota_block ct_helper_block ct_timeout_block ct_expect_block limit_block secmark_block synproxy_block tunnel_block erspan_block erspan_block_alloc vxlan_block vxlan_block_alloc geneve_block geneve_block_alloc
+%type <val>			synproxy_wscale
 %destructor { obj_free($$); }	obj_block_alloc
 
 %type <list>			stmt_list stateful_stmt_list set_elem_stmt_list
@@ -3813,14 +3814,25 @@ synproxy_args		:	synproxy_arg
 			|	synproxy_args	synproxy_arg
 			;
 
+synproxy_wscale		:	WSCALE 	NUM
+			{
+				if ($2 > 14) {
+					erec_queue(error(&@2, "wscale must be in range 0-14"), state->msgs);
+					YYERROR;
+				}
+
+				$$ = $2;
+			}
+			;
+
 synproxy_arg		:	MSS	NUM
 			{
 				$<stmt>0->synproxy.mss = $2;
 				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_MSS;
 			}
-			|	WSCALE	NUM
+			|	synproxy_wscale
 			{
-				$<stmt>0->synproxy.wscale = $2;
+				$<stmt>0->synproxy.wscale = $1;
 				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_WSCALE;
 			}
 			|	TIMESTAMP
@@ -3833,7 +3845,7 @@ synproxy_arg		:	MSS	NUM
 			}
 			;
 
-synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
+synproxy_config		:	MSS	NUM	synproxy_wscale synproxy_ts	synproxy_sack
 			{
 				struct synproxy *synproxy;
 				uint32_t flags = 0;
@@ -3843,13 +3855,13 @@ synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
 				flags |= NF_SYNPROXY_OPT_MSS;
 				synproxy->wscale = $4;
 				flags |= NF_SYNPROXY_OPT_WSCALE;
+				if ($4)
+					flags |= $4;
 				if ($5)
 					flags |= $5;
-				if ($6)
-					flags |= $6;
 				synproxy->flags = flags;
 			}
-			|	MSS	NUM	stmt_separator	WSCALE	NUM	stmt_separator	synproxy_ts	synproxy_sack
+			|	MSS	NUM	stmt_separator	synproxy_wscale stmt_separator	synproxy_ts	synproxy_sack
 			{
 				struct synproxy *synproxy;
 				uint32_t flags = 0;
@@ -3857,12 +3869,12 @@ synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
 				synproxy = &$<obj>0->synproxy;
 				synproxy->mss = $2;
 				flags |= NF_SYNPROXY_OPT_MSS;
-				synproxy->wscale = $5;
+				synproxy->wscale = $4;
 				flags |= NF_SYNPROXY_OPT_WSCALE;
+				if ($6)
+					flags |= $6;
 				if ($7)
 					flags |= $7;
-				if ($8)
-					flags |= $8;
 				synproxy->flags = flags;
 			}
 			;
diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcases/json/single_flag
index fa917eb9c767..7f36e72f03e0 100755
--- a/tests/shell/testcases/json/single_flag
+++ b/tests/shell/testcases/json/single_flag
@@ -156,11 +156,11 @@ back_n_forth "$STD_SYNPROXY_2" "$JSON_SYNPROXY_2"
 STD_SYNPROXY_OBJ_1="table ip t {
 	synproxy s {
 		mss 1280
-		wscale 64
+		wscale 14
 		 sack-perm
 	}
 }"
-JSON_SYNPROXY_OBJ_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"synproxy": {"family": "ip", "name": "s", "table": "t", "handle": 0, "mss": 1280, "wscale": 64, "flags": "sack-perm"}}]}'
+JSON_SYNPROXY_OBJ_1='{"nftables": [{"table": {"family": "ip", "name": "t", "handle": 0}}, {"synproxy": {"family": "ip", "name": "s", "table": "t", "handle": 0, "mss": 1280, "wscale": 14, "flags": "sack-perm"}}]}'
 JSON_SYNPROXY_OBJ_1_EQUIV=$(sed 's/\("flags":\) \([^}]*\)/\1 [\2]/' <<< "$JSON_SYNPROXY_OBJ_1")
 
 STD_SYNPROXY_OBJ_2=$(sed 's/ \(sack-perm\)/timestamp \1/' <<< "$STD_SYNPROXY_OBJ_1")
-- 
2.52.0

