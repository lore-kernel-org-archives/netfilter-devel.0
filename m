Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D6E8143872
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 21:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720128872; cv=none; b=Z0bNayo1FSyQRFqoKvwpcqenX395fK8MXaWGEldb+lL1RJpPE3owlZ2QWM+2OMQGOND3i/VDk9SBlJzN6dEreSqTXEA57ooFFe2aq82veB3L/9CgoYqAtk3neJv3SGRYUDJHo0/Fk2q46o0G3audKDV0Fnnv9HW5AbsasWSwUmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720128872; c=relaxed/simple;
	bh=3nuW8iKwLmr1V1yweXx7w8JeS8jD9kN1gq6JUEtJG3s=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fFqTJPGrZltSqd5q3fovipqP7J19BbQyFzOYnTVyZhhfICTJ5opg7F3CcQtzDRh25iz3imBshhHT2jAWyPKC5oAqMFbjSjhXdU43Pi9Ylf3LZHDfgmX9HtwwLZ6BL+flbzSjeV6iJFh3wdE4PJPdJmOKfAIvJ1hOXFORiiq8cKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 4/4] tests: shell: cover set element deletion in maps
Date: Thu,  4 Jul 2024 23:34:23 +0200
Message-Id: <20240704213423.254356-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240704213423.254356-1-pablo@netfilter.org>
References: <20240704213423.254356-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend existing coverage to deal with set element deletion, including
catchall elements too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/maps/delete_element     | 28 +++++++++++++++
 .../testcases/maps/delete_element_catchall    | 35 +++++++++++++++++++
 .../maps/dumps/delete_elem_catchall.nft       | 12 +++++++
 .../testcases/maps/dumps/delete_element.nft   | 12 +++++++
 4 files changed, 87 insertions(+)
 create mode 100755 tests/shell/testcases/maps/delete_element
 create mode 100755 tests/shell/testcases/maps/delete_element_catchall
 create mode 100644 tests/shell/testcases/maps/dumps/delete_elem_catchall.nft
 create mode 100644 tests/shell/testcases/maps/dumps/delete_element.nft

diff --git a/tests/shell/testcases/maps/delete_element b/tests/shell/testcases/maps/delete_element
new file mode 100755
index 000000000000..75272f448dbf
--- /dev/null
+++ b/tests/shell/testcases/maps/delete_element
@@ -0,0 +1,28 @@
+#!/bin/bash
+
+set -e
+
+RULESET="flush ruleset
+
+table ip x {
+        map m {
+                typeof ct bytes : meta priority
+                flags interval
+                elements = {
+                        0-2048000 : 1:0001,
+                        2048001-4000000 : 1:0002,
+                }
+        }
+
+        chain y {
+                type filter hook output priority 0; policy accept;
+
+                meta priority set ct bytes map @m
+        }
+}"
+
+$NFT -f - <<< $RULESET
+
+$NFT delete element ip x m { 0-2048000 }
+$NFT add element ip x m { 0-2048000 : 1:0002 }
+$NFT delete element ip x m { 0-2048000 : 1:0002 }
diff --git a/tests/shell/testcases/maps/delete_element_catchall b/tests/shell/testcases/maps/delete_element_catchall
new file mode 100755
index 000000000000..a6a0fc6f3e04
--- /dev/null
+++ b/tests/shell/testcases/maps/delete_element_catchall
@@ -0,0 +1,35 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_catchall_element)
+
+set -e
+
+RULESET="flush ruleset
+
+table ip x {
+        map m {
+                typeof ct bytes : meta priority
+                flags interval
+                elements = {
+                        0-2048000 : 1:0001,
+                        * : 1:0002,
+                }
+        }
+
+        chain y {
+                type filter hook output priority 0; policy accept;
+
+                meta priority set ct bytes map @m
+        }
+}"
+
+$NFT -f - <<< $RULESET
+
+$NFT delete element ip x m { 0-2048000 }
+$NFT add element ip x m { 0-2048000 : 1:0002 }
+$NFT delete element ip x m { 0-2048000 : 1:0002 }
+
+$NFT 'delete element ip x m { * }'
+$NFT 'add element ip x m { * : 1:0003 }'
+$NFT 'delete element ip x m { * : 1:0003 }'
+$NFT 'add element ip x m { * : 1:0003 }'
diff --git a/tests/shell/testcases/maps/dumps/delete_elem_catchall.nft b/tests/shell/testcases/maps/dumps/delete_elem_catchall.nft
new file mode 100644
index 000000000000..14054f4dc4d5
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/delete_elem_catchall.nft
@@ -0,0 +1,12 @@
+table ip x {
+	map m {
+		typeof ct bytes : meta priority
+		flags interval
+		elements = { * : 1:3 }
+	}
+
+	chain y {
+		type filter hook output priority filter; policy accept;
+		meta priority set ct bytes map @m
+	}
+}
diff --git a/tests/shell/testcases/maps/dumps/delete_element.nft b/tests/shell/testcases/maps/dumps/delete_element.nft
new file mode 100644
index 000000000000..5275b4dc2a68
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/delete_element.nft
@@ -0,0 +1,12 @@
+table ip x {
+	map m {
+		typeof ct bytes : meta priority
+		flags interval
+		elements = { 2048001-4000000 : 1:2 }
+	}
+
+	chain y {
+		type filter hook output priority filter; policy accept;
+		meta priority set ct bytes map @m
+	}
+}
-- 
2.30.2

