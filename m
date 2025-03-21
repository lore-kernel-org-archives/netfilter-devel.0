Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3422236FC
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 11:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742558083; cv=none; b=qjeYqP+QMbeHo7BHjaCeTZKXK/6EjP68bKWoc8PfdvAGsMkvHXp58TgZUhtEUWp4BEQLR9RKVOufoioiTVZ+i89g0pED82yvdJelmkiZUzRLF+l89SD7Gplv3x4QiPR7z3xfiwgqQk1RzJMV8UIqnvPJmhKiEN9i9PZhVkepbMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742558083; c=relaxed/simple;
	bh=1raMOue76aterqUgXnw8jqRdpFC0lw0pHbMN6Fe7j18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDRwqm0yl8W0vkNFSc3O//r+VJ3dWrCn7AZC5aPKyn9LjzHQw+A+Mv//WAv7ErVmpllwUTtmuKZJUcScxPd7i/9DX4r50CIn31PZ8nTsndN5JAD2sERjvih93Y/Omc6xaOCjiS9nJRst9dQt31ALS335TUSI4E88uAf28ALIckQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tvaxT-00041a-DO; Fri, 21 Mar 2025 12:54:39 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] json: make sure timeout list is initialised
Date: Fri, 21 Mar 2025 12:53:40 +0100
Message-ID: <20250321115343.25103-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On parser error, obj_free will iterate this list.
Included json bogon crashes due to null deref because
list head initialisation did not yet happen.

Fixes: c82a26ebf7e9 ("json: Add ct timeout support")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_json.c                             |  2 +-
 tests/shell/testcases/bogons/assert_failures  | 35 +++++++++---
 .../bogons/nft-j-f/ct_timeout_null_crash      | 54 +++++++++++++++++++
 3 files changed, 84 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-j-f/ct_timeout_null_crash

diff --git a/src/parser_json.c b/src/parser_json.c
index 17bc38b565ae..dd085d78d0dd 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3722,6 +3722,7 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		break;
 	case NFT_OBJECT_CT_TIMEOUT:
 		cmd_obj = CMD_OBJ_CT_TIMEOUT;
+		init_list_head(&obj->ct_timeout.timeout_list);
 		obj->type = NFT_OBJECT_CT_TIMEOUT;
 		if (!json_unpack(root, "{s:s}", "protocol", &tmp)) {
 			if (!strcmp(tmp, "tcp")) {
@@ -3740,7 +3741,6 @@ static struct cmd *json_parse_cmd_add_object(struct json_ctx *ctx,
 		}
 		obj->ct_timeout.l3proto = l3proto;
 
-		init_list_head(&obj->ct_timeout.timeout_list);
 		if (json_parse_ct_timeout_policy(ctx, root, obj))
 			goto err_free_obj;
 		break;
diff --git a/tests/shell/testcases/bogons/assert_failures b/tests/shell/testcases/bogons/assert_failures
index 3dee63b3f97b..74e162ad476c 100755
--- a/tests/shell/testcases/bogons/assert_failures
+++ b/tests/shell/testcases/bogons/assert_failures
@@ -1,6 +1,8 @@
 #!/bin/bash
 
 dir=$(dirname $0)/nft-f/
+jsondir=$(dirname $0)/nft-j-f/
+
 tmpfile=$(mktemp)
 
 cleanup()
@@ -10,18 +12,39 @@ cleanup()
 
 trap cleanup EXIT
 
-for f in $dir/*; do
-	echo "Check $f"
-	$NFT --check -f "$f" 2> "$tmpfile"
+die_on_error()
+{
+	local rv="$1"
+	local fname="$2"
 
-	if [ $? -ne 1 ]; then
-		echo "Bogus input file $f did not cause expected error code" 1>&2
+	if [ $rv -ne 1 ]; then
+		echo "Bogus input file $fname did not cause expected error code" 1>&2
 		exit 111
 	fi
 
 	if grep AddressSanitizer "$tmpfile"; then
-		echo "Address sanitizer splat for $f" 1>&2
+		echo "Address sanitizer splat for $fname" 1>&2
 		cat "$tmpfile"
 		exit 111
 	fi
+}
+
+for f in $dir/*; do
+	echo "Check $f"
+	$NFT --check -f "$f" 2> "$tmpfile"
+
+	die_on_error $? "$f"
+done
+
+if [ "$NFT_TEST_HAVE_json" = "n" ];then
+	# Intentionally do not skip if we lack json input,
+	# we ran all the tests that we could.
+	exit 0
+fi
+
+for f in $jsondir/*; do
+	echo "Check json input $f"
+	$NFT --check -j -f "$f" 2> "$tmpfile"
+
+	die_on_error $?
 done
diff --git a/tests/shell/testcases/bogons/nft-j-f/ct_timeout_null_crash b/tests/shell/testcases/bogons/nft-j-f/ct_timeout_null_crash
new file mode 100644
index 000000000000..c8c662e93b8c
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-j-f/ct_timeout_null_crash
@@ -0,0 +1,54 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "filter",
+        "name": "c",
+        "handle": 0
+      }
+    },
+    {
+      "ct timeout": {
+        "family": "ip",
+        "name": "cttime",
+        "table": "filter",
+        "handle": 0,
+        "protocol": "Xcp",
+        "l3proto": "ip",
+        "policy": {
+          "established": 123,
+          "close": 12
+        }
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "filter",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "ct timeout": "cttime"
+          }
+        ]
+      }
+    }
+  ]
+}
+
-- 
2.48.1

