Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DD97DA64
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 10:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723718022; cv=none; b=XpJPdMLJdoppflfiXN+4TD0+tmPNTvTJQKl/7/7T9rCD07VqHTbI3D4xg2bKKXWv/pBpPwq52HmORCeqEtQafatjSFMg2nUfODf0PQZ89lF794AIj6DG4pF37u+u0ziSfjy4ThF0qqldtohvH48ltKH7i6O1ADIA9ihPuFtDS34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723718022; c=relaxed/simple;
	bh=bbsfhvlh+K+FkAthfEcZMNE9e7pscH+gLJ7H26hCyKg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=SUw/AVvFHCrGQCfZwzq7QsxRlVAJYa7XiVhsZiThyUnD7KeWlgWEFHIq4ku4pZqSlyqbOuEdqXkJTVnSxsYFWkwLr9NAFdEC14JOXyNTdIMabgFZT0GEe2mMr9XCqI2bQRL/N2saTy0ZyhRuRtr3Nh8uM5ul5AoRIPzdstQfDRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: add a few tests for nft -i
Date: Thu, 15 Aug 2024 12:33:33 +0200
Message-Id: <20240815103333.890296-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eric Garver recently provided a few tests for nft -i that helped
identify issues that resulted in reverting:

  e791dbe109b6 ("cache: recycle existing cache with incremental updates")

add these tests to tests/shell.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/nft-i/dumps/index_0.nft |  8 ++++++++
 tests/shell/testcases/nft-i/dumps/set_0.nft   |  7 +++++++
 tests/shell/testcases/nft-i/index_0           | 11 +++++++++++
 tests/shell/testcases/nft-i/set_0             |  9 +++++++++
 4 files changed, 35 insertions(+)
 create mode 100644 tests/shell/testcases/nft-i/dumps/index_0.nft
 create mode 100644 tests/shell/testcases/nft-i/dumps/set_0.nft
 create mode 100755 tests/shell/testcases/nft-i/index_0
 create mode 100755 tests/shell/testcases/nft-i/set_0

diff --git a/tests/shell/testcases/nft-i/dumps/index_0.nft b/tests/shell/testcases/nft-i/dumps/index_0.nft
new file mode 100644
index 000000000000..abcd1b7c10b6
--- /dev/null
+++ b/tests/shell/testcases/nft-i/dumps/index_0.nft
@@ -0,0 +1,8 @@
+table inet foo {
+	chain bar {
+		type filter hook input priority filter; policy accept;
+		accept
+		accept
+		accept
+	}
+}
diff --git a/tests/shell/testcases/nft-i/dumps/set_0.nft b/tests/shell/testcases/nft-i/dumps/set_0.nft
new file mode 100644
index 000000000000..d3377d633e8a
--- /dev/null
+++ b/tests/shell/testcases/nft-i/dumps/set_0.nft
@@ -0,0 +1,7 @@
+table inet foo {
+	set bar {
+		type ipv4_addr
+		flags interval
+		elements = { 10.1.1.1, 10.1.1.2 }
+	}
+}
diff --git a/tests/shell/testcases/nft-i/index_0 b/tests/shell/testcases/nft-i/index_0
new file mode 100755
index 000000000000..f885fdeb84fa
--- /dev/null
+++ b/tests/shell/testcases/nft-i/index_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="add table inet foo
+add chain inet foo bar { type filter hook input priority filter; }
+add rule inet foo bar accept
+insert rule inet foo bar index 0 accept
+add rule inet foo bar index 0 accept"
+
+$NFT -i <<< "$RULESET"
diff --git a/tests/shell/testcases/nft-i/set_0 b/tests/shell/testcases/nft-i/set_0
new file mode 100755
index 000000000000..e87eef1d8128
--- /dev/null
+++ b/tests/shell/testcases/nft-i/set_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+RULESET="add table inet foo
+add set inet foo bar { type ipv4_addr; flags interval; }; add element inet foo bar { 10.1.1.1/32 }
+add element inet foo bar { 10.1.1.2/32 }"
+
+$NFT -i <<< "$RULESET"
-- 
2.30.2

