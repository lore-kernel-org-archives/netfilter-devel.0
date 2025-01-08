Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9B81F9A9C
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jan 2025 11:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736337276; cv=none; b=gUTvhkObGxNNP6sPCvZI4+SqKw/+6TBX9bqMW10DGnxant2tfLKlZ6ECWV1yymyLlUkRZEF9HBWhiWB+vsWZJXCM/9JhqiI+SsjFT6ldInT/ZxXxQHbxd9Q1HfAHDOV3XI1RJMzEqO1HMT42M/NgirmnyBnlx+FGZ2Rs5kyWrN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736337276; c=relaxed/simple;
	bh=a24wMTEyxZQYgVZbVR55G5LMtKnxeOfuA8763lL5Nvc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ps5J0jDSKo8W3lpHAMlXroXKmTRW/+DnHhok+oHWwmhiDAzvWiOGmDs49BYmKh6lpLgVT5ZHYKzyzFM3rBW3eL51JN7Nrd/5HEIYHcBpeOLltuHg20ruUvYY/2GI5Th+yuplFUuAEmdMT+Y2UcjyrDK2VTVfiidbTY7z2Ny5kFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tVUdr-0002kC-Ji; Wed, 08 Jan 2025 12:54:31 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] rule: make cmd_free(NULL) valid
Date: Wed,  8 Jan 2025 12:30:15 +0100
Message-ID: <20250108113022.12499-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

bison uses cmd_free($$) as destructor, but base_cmd can
set it to NULL, e.g.

  |       ELEMENT         set_spec        set_block_expr
  {
    if (nft_cmd_collapse_elems(CMD_ADD, state->cmds, &$2, $3)) {
       handle_free(&$2);
       expr_free($3);
       $$ = NULL;   // cmd set to NULL
       break;
    }
    $$ = cmd_alloc(CMD_ADD, CMD_OBJ_ELEMENTS, &$2, &@$, $3);

expr_free(NULL) is legal, cmd_free() causes crash.  So just allow
this to avoid cluttering parser_bison.y with "if ($$)".

Also add the afl-generated bogon input to the test files.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c                                    |  3 +++
 .../bogons/nft-f/cmd_is_null_on_free          | 20 +++++++++++++++++++
 2 files changed, 23 insertions(+)
 create mode 100644 tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free

diff --git a/src/rule.c b/src/rule.c
index 151ed531969c..cc43cd18b7c7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1372,6 +1372,9 @@ void monitor_free(struct monitor *m)
 
 void cmd_free(struct cmd *cmd)
 {
+	if (cmd == NULL)
+		return;
+
 	handle_free(&cmd->handle);
 	if (cmd->data != NULL) {
 		switch (cmd->obj) {
diff --git a/tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free b/tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free
new file mode 100644
index 000000000000..6a42aa90cd53
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/cmd_is_null_on_free
@@ -0,0 +1,20 @@
+nt      rootepep test- {
+* : 1:3 }
+        element root tesip {
+* : 1:3 }
+        elent   rootsel s1 {
+        typ�    elements < { "Linux" }
+        }
+tatlet e t {
+        thataepep test- {
+* : 1:3 }
+        element root tesip {
+* : 1:3 }�      table Cridgents < t {
+list            set y p
+        type i , {
+        sel s1 {
+        typ�    elements < { "Linux" }
+        }
+tatlet e t {
+        thatable Cridgents < t {
+lis
-- 
2.45.2

