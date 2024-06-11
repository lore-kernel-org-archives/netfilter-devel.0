Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1894A41C6D
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Jun 2024 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718127506; cv=none; b=UAOBR93TRwQWlByXL0nCCLfAQURSZHPXe4a2tugF5XhBDmglbqJizi8rPmMo1W0gd39PDFjpcuF2Z0PY1VAIR040Ebz4Nfd2ebHyFXa2ca96NiZSbVVPTcQQ4chw+Tr2hjvA7NvzGoUdKoZXXnYSvbLmGgBTRa3CHhjSVVWTB20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718127506; c=relaxed/simple;
	bh=iexWsyl2IWaBxxJCMOJOgiucnw0NPMP4KNhI0a0aGwE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=b1ezM7Fq7xc/dtvuGM0l8LN7z8Y6L8FmhUln0fvpayTQUTwsMtcyBHAtFfPmPdH0fHZPdbRQVjTpECVJe/AqxDlmdM2qP59HUWDprUmCw9gw7ER8lqmGLjyDYuSIf0CBEJ2G9ohtkHkW4T6xTOgZf5N/7hwqnwbZzWYWg4QbngI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] cmd: skip variable set elements when collapsing commands
Date: Tue, 11 Jun 2024 19:38:12 +0200
Message-Id: <20240611173812.173224-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ASAN reports an issue when collapsing commands that represent an element
through a variable:

include/list.h:60:13: runtime error: member access within null pointer of type 'struct list_head'
AddressSanitizer:DEADLYSIGNAL
=================================================================
==11398==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000000 (pc 0x7ffb77cf09c2 bp 0x7ffc818267c0 sp 0x7ffc818267a0 T0)
==11398==The signal is caused by a WRITE memory access.
==11398==Hint: address points to the zero page.
    #0 0x7ffb77cf09c2 in __list_add include/list.h:60
    #1 0x7ffb77cf0ad9 in list_add_tail include/list.h:87
    #2 0x7ffb77cf0e72 in list_move_tail include/list.h:169
    #3 0x7ffb77cf86ad in nft_cmd_collapse src/cmd.c:478
    #4 0x7ffb77da9f16 in nft_evaluate src/libnftables.c:531
    #5 0x7ffb77dac471 in __nft_run_cmd_from_filename src/libnftables.c:720
    #6 0x7ffb77dad703 in nft_run_cmd_from_filename src/libnftables.c:807

Skip such commands to address this issue.

This patch also extends tests/shell to cover for this bug.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1754
Fixes: 498a5f0c219d ("rule: collapse set element commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: extend tests/shell

 src/cmd.c                                                 | 3 +++
 tests/shell/testcases/sets/collapse_elem_0                | 6 ++++++
 tests/shell/testcases/sets/dumps/collapse_elem_0.json-nft | 5 ++++-
 tests/shell/testcases/sets/dumps/collapse_elem_0.nft      | 2 +-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/src/cmd.c b/src/cmd.c
index d6b1d844ed8d..37d93abc2cd4 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -455,6 +455,9 @@ bool nft_cmd_collapse(struct list_head *cmds)
 			continue;
 		}
 
+		if (cmd->expr->etype == EXPR_VARIABLE)
+			continue;
+
 		if (!elems) {
 			elems = cmd;
 			continue;
diff --git a/tests/shell/testcases/sets/collapse_elem_0 b/tests/shell/testcases/sets/collapse_elem_0
index 7699e9da3e75..52a42c2f7305 100755
--- a/tests/shell/testcases/sets/collapse_elem_0
+++ b/tests/shell/testcases/sets/collapse_elem_0
@@ -17,3 +17,9 @@ add element ip a x { 2 }
 add element ip6 a x { 2 }"
 
 $NFT -f - <<< $RULESET
+
+RULESET="define m = { 3, 4 }
+add element ip a x \$m
+add element ip a x { 5 }"
+
+$NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/sets/dumps/collapse_elem_0.json-nft b/tests/shell/testcases/sets/dumps/collapse_elem_0.json-nft
index c713828d2843..c8ff43471428 100644
--- a/tests/shell/testcases/sets/dumps/collapse_elem_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/collapse_elem_0.json-nft
@@ -23,7 +23,10 @@
         "handle": 0,
         "elem": [
           1,
-          2
+          2,
+          3,
+          4,
+          5
         ]
       }
     },
diff --git a/tests/shell/testcases/sets/dumps/collapse_elem_0.nft b/tests/shell/testcases/sets/dumps/collapse_elem_0.nft
index a3244fc616de..775f0ab15d67 100644
--- a/tests/shell/testcases/sets/dumps/collapse_elem_0.nft
+++ b/tests/shell/testcases/sets/dumps/collapse_elem_0.nft
@@ -1,7 +1,7 @@
 table ip a {
 	set x {
 		type inet_service
-		elements = { 1, 2 }
+		elements = { 1, 2, 3, 4, 5 }
 	}
 }
 table ip6 a {
-- 
2.30.2

