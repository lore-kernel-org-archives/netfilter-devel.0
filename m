Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A46A11DE2D4
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2025 22:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736203320; cv=none; b=bFh1UKL/Vf4LyutP46OcrBkHZ9becgKGgfEgnvyenZ5H5a6ANTp0Q99rPnHYMNtO1y36NFAEOyVAxobNzdz3Sq4WKOESjoDuSMomoonMjybsntFFrWnI1hRUXgAvnEidOHA4TRs+/2V5JKAMn61q9CSNcR8xk/o2xI1Xkws2Aag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736203320; c=relaxed/simple;
	bh=QWgkEOTwNlCIqX7FaeSAXNXHkymQ+1VShgQoaFSjvSs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UBYh2Jabvo13qJhkG1zFtJuNAVLQd3mVG0fJq4sME2rA4eHsYcsVQLbGD+J+4vQ7tFoJjFxH/F36nKMtn6AX5omTO+spXW9u7f8Iq74pl0UmU0+5IYNxvLNjjeiBmbcHZXnhna9l1V8mmSOzsIGqWtIgLDAeZTssW7YNC0xxn9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft 1/2] tests: shell: interval sets with size
Date: Mon,  6 Jan 2025 23:41:51 +0100
Message-Id: <20250106224152.202624-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Exercise size in set with intervals (rbtree), including corner cases
such as 0.0.0.0 and 255.255.255.255 (half-open interval).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/interval_size | 41 ++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100755 tests/shell/testcases/sets/interval_size

diff --git a/tests/shell/testcases/sets/interval_size b/tests/shell/testcases/sets/interval_size
new file mode 100755
index 000000000000..0f236bf8f4ac
--- /dev/null
+++ b/tests/shell/testcases/sets/interval_size
@@ -0,0 +1,41 @@
+#!/bin/bash
+
+RULESET="table inet x {
+	set x {
+		typeof ip saddr
+		flags interval
+		auto-merge
+		size 1
+	}
+
+	set y {
+		typeof ip saddr
+		flags interval
+		size 1
+	}
+}"
+
+$NFT -f - <<< $RULESET
+
+$NFT add element inet x x '{ 0.0.0.0, 255.255.255.255 }' && exit 1
+$NFT add element inet x x '{ 0.0.0.0 }' || exit 1
+$NFT add element inet x x '{ 255.255.255.0/24 }' && exit 1
+$NFT delete element inet x x '{ 0.0.0.0 }' || exit 1
+$NFT add element inet x x '{ 255.255.255.0/24 }' || exit 1
+$NFT add element inet x x '{ 0.0.0.0 }' && exit 1
+$NFT add element inet x x '{ 0.0.0.0-255.255.255.0 }' || exit 1
+$NFT delete element inet x x '{ 1.1.1.1 }' && exit 1
+$NFT delete element inet x x '{ 0.0.0.0/0 }' || exit 1
+$NFT add element inet x x '{ 255.255.255.0/24 }' || exit 1
+$NFT add element inet x x '{ 0.0.0.0 }' && exit 1
+
+$NFT add element inet x y '{ 0.0.0.0, 255.255.255.255 }' && exit 1
+$NFT add element inet x y '{ 0.0.0.0 }' || exit 1
+$NFT add element inet x y '{ 255.255.255.0/24 }' && exit 1
+$NFT delete element inet x y '{ 0.0.0.0 }' || exit 1
+$NFT add element inet x y '{ 255.255.255.0/24 }' || exit 1
+$NFT add element inet x y '{ 0.0.0.0 }' && exit 1
+$NFT add element inet x y '{ 0.0.0.0-255.255.255.0 }' && exit 1
+$NFT delete element inet x y '{ 255.255.255.0/24 }' || exit 1
+$NFT add element inet x y '{ 0.0.0.0 }' || exit 1
+$NFT add element inet x y '{ 255.255.255.255 }' && exit 1
-- 
2.30.2

