Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C300613DDB6
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2024 08:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724662507; cv=none; b=nO/KG4uquu+TpTwrX9qyuvqTaFat9DQdi6356mruCPSHiNXP+W1jOeA9TV1Mojmg6lKCEkRvlGzMZeKFW09YjuA/DLNAt49CgqEtyJDeT1lZc/zr3HlDjyQN8iTUVsGrBRsuQ9PlOybhhxZmdGv4cqYo+xYv8qrPb2wNwpliX6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724662507; c=relaxed/simple;
	bh=qxUEniRcHLfiKyVp9iw0kbxIr0PC3bfqaZIYKDkgciA=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ut2s8i30gAXotaTz0nJjiA025V2jPEUYf9SY1B+sHS4fyNxolqtL7+beWWwtHW5jRuZEOlghHilgjwa0TgPxTBJ2XifrRDQtL0qTwaG3+MP9F3WbFJQSHUglXIBuhaUG6B40ngXfGVaROH0lsrfuJL97inejC88vDmzl3UWjXME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 7/7] tests: shell: cover reset command with counter and quota
Date: Mon, 26 Aug 2024 10:54:55 +0200
Message-Id: <20240826085455.163392-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240826085455.163392-1-pablo@netfilter.org>
References: <20240826085455.163392-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 tests/shell/testcases/listing/reset_objects | 104 ++++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100755 tests/shell/testcases/listing/reset_objects

diff --git a/tests/shell/testcases/listing/reset_objects b/tests/shell/testcases/listing/reset_objects
new file mode 100755
index 000000000000..0b6720b62c04
--- /dev/null
+++ b/tests/shell/testcases/listing/reset_objects
@@ -0,0 +1,104 @@
+#!/bin/bash
+
+set -e
+
+load_ruleset()
+{
+	$NFT -f - <<EOF
+table ip test {
+	quota https-quota {
+		25 mbytes used 10 mbytes
+	}
+	counter https-counter {
+		packets 10 bytes 4096
+	}
+}
+EOF
+}
+
+check_list_quota()
+{
+	EXPECT="table ip test {
+	quota https-quota {
+		25 mbytes
+	}
+}"
+	$DIFF -u <(echo "$EXPECT") <($NFT list quotas)
+}
+
+check_list_counter()
+{
+	EXPECT="table ip test {
+	counter https-counter {
+		packets 0 bytes 0
+	}
+}"
+	$DIFF -u <(echo "$EXPECT") <($NFT list counters)
+}
+
+load_ruleset
+
+EXPECT="table ip test {
+	quota https-quota {
+		25 mbytes used 10 mbytes
+	}
+}"
+$DIFF -u <(echo "$EXPECT") <($NFT reset quotas)
+
+check_list_quota
+$NFT flush ruleset
+load_ruleset
+
+EXPECT="table ip test {
+	quota https-quota {
+		25 mbytes used 10 mbytes
+	}
+}"
+$DIFF -u <(echo "$EXPECT") <($NFT reset quotas ip)
+
+check_list_quota
+$NFT flush ruleset
+load_ruleset
+
+EXPECT="table ip test {
+	quota https-quota {
+		25 mbytes used 10 mbytes
+	}
+}"
+$DIFF -u <(echo "$EXPECT") <($NFT reset quota ip test https-quota)
+
+check_list_quota
+$NFT flush ruleset
+load_ruleset
+
+EXPECT="table ip test {
+	counter https-counter {
+		packets 10 bytes 4096
+	}
+}"
+$DIFF -u <(echo "$EXPECT") <($NFT reset counters)
+
+check_list_counter
+$NFT flush ruleset
+load_ruleset
+
+EXPECT="table ip test {
+	counter https-counter {
+		packets 10 bytes 4096
+	}
+}"
+$DIFF -u <(echo "$EXPECT") <($NFT reset counters ip)
+
+check_list_counter
+$NFT flush ruleset
+load_ruleset
+
+EXPECT="table ip test {
+	counter https-counter {
+		packets 10 bytes 4096
+	}
+}"
+$DIFF -u <(echo "$EXPECT") <($NFT reset counter ip test https-counter)
+
+check_list_counter
+$NFT flush ruleset
-- 
2.30.2

