Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D80A5
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 02:10:09 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDMBr-00074R-Km; Wed, 13 Dec 2023 11:10:07 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: close chain scope before chain release
Date: Wed, 13 Dec 2023 11:09:58 +0100
Message-ID: <20231213101002.11673-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cmd_alloc() will free the chain, so we must close the scope opened
in chain_block_alloc beforehand.

The included test file will cause a use-after-free because nft attempts
to search for an identifier in a scope that has been freed:

AddressSanitizer: heap-use-after-free on address 0x618000000368 at pc 0x7f1cbc0e6959 bp 0x7ffd3ccb7850 sp 0x7ffd3ccb7840
    #0 0x7f1cbc0e6958 in symbol_lookup src/rule.c:629
    #1 0x7f1cbc0e66a1 in symbol_get src/rule.c:588
    #2 0x7f1cbc120d67 in nft_parse src/parser_bison.y:4325

Fixes: a66b5ad9540d ("src: allow for updating devices on existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                           | 1 +
 .../testcases/bogons/nft-f/use_after_free_on_chain_removal   | 5 +++++
 2 files changed, 6 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/use_after_free_on_chain_removal

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e1addc26d20d..44d440f762e7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1419,6 +1419,7 @@ delete_cmd		:	TABLE		table_or_id_spec
 			{
 				$5->location = @5;
 				handle_merge(&$3->handle, &$2);
+				close_scope(state);
 				$$ = cmd_alloc(CMD_DELETE, CMD_OBJ_CHAIN, &$2, &@$, $5);
 			}
 			|	RULE		ruleid_spec
diff --git a/tests/shell/testcases/bogons/nft-f/use_after_free_on_chain_removal b/tests/shell/testcases/bogons/nft-f/use_after_free_on_chain_removal
new file mode 100644
index 000000000000..bb9632b053be
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/use_after_free_on_chain_removal
@@ -0,0 +1,5 @@
+delete	chain d iUi {
+}}
+delete	chain d hUi {
+delete	chain o
+c b icmpv6  id$i
-- 
2.41.0

