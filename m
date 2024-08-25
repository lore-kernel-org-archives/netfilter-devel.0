Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009A677F12
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Aug 2024 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724626043; cv=none; b=hd9jS+nq7O6Hudab0CfFQ4RbFEA92Jyghogf6TO3kcRNUuz8cFB+rmHJ5BTJKsAX/HR6WyN54aOM0i1xlRdvhXHKOUwA5ncuY2EcFJ48SivCw89W6fAN1ok7gTEQTynhsqYnSMrI+UZSNlIkY92u68vwc/E99vLrcSZRzsc8154=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724626043; c=relaxed/simple;
	bh=wGcSmpiD8AJgGHsXJt1uWnVrx1H5ogWs+q5FBgz/8e8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=U0tI9Jp24yzjzatqccCztMdn4J+evLukbMx27iAJr8rEmWtroIf54uYaowKsKClz3ZTFLPOsNapqjBd7vg+edSGFV0rM6Z+dqUmYwtEKdIR26WbNBT35MhMg5WUHLvMaUyUgQuuDGFks/3FfqNuvx4u/8OMxCVTZ5CmF5Pm+5qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 5/5] tests: shell: cover reset command with counter and quota
Date: Mon, 26 Aug 2024 00:47:07 +0200
Message-Id: <20240825224707.3687-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240825224707.3687-1-pablo@netfilter.org>
References: <20240825224707.3687-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

