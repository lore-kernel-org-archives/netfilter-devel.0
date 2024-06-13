Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63757622
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 00:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718238186; cv=none; b=MZqxmUQiXr/dkdvX4xJtIwdRHg6qYec9AXhLfSVkugSDDGFg0AreGDahxljrLL3blN2fQCb58naeuUEP2D+kH83MjlGbYVeyVCwJ4Lzp3XPqTggZkX79TTt37CWQOeI5FT7EcDtocMcq+nFH18sYXe8/WyPp1IQJobXTZp3rRsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718238186; c=relaxed/simple;
	bh=FcqNecNOoWPOWb2s2Wp9m70ydfybtxO9UWDeaKXCmMs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RluaLv+I7IasJJckohhURpNnLZrjZmJHpprTpChPhN5ZyUnVLzBrYiqo6eIO3Abkpsn7UcpHs6K3HQSNZGwCNYlKmjDPBbWJNyaBhPPZ/dyq2EohbdgouCyU4an0x7daSCuIzZu77FMy91bxGvUkaZ3ry9zN/olDNqPKfwiHRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] tests: shell: skip ip option tests if kernel does not support it
Date: Thu, 13 Jun 2024 02:22:51 +0200
Message-Id: <20240613002253.103683-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613002253.103683-1-pablo@netfilter.org>
References: <20240613002253.103683-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/features/ip_options.nft      | 8 ++++++++
 tests/shell/testcases/sets/typeof_sets_0 | 2 ++
 2 files changed, 10 insertions(+)
 create mode 100644 tests/shell/features/ip_options.nft

diff --git a/tests/shell/features/ip_options.nft b/tests/shell/features/ip_options.nft
new file mode 100644
index 000000000000..0b8cb09ce11c
--- /dev/null
+++ b/tests/shell/features/ip_options.nft
@@ -0,0 +1,8 @@
+# dbb5281a1f84 ("netfilter: nf_tables: add support for matching IPv4 options")
+# v5.3-rc1~140^2~153^2~1
+
+table ip x {
+	chain y {
+		ip option ra value 255
+	}
+}
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 016227da6242..a105acffde48 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -4,6 +4,8 @@
 # s1 and s2 are identical, they just use different
 # ways for declaration.
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ip_options)
+
 set -e
 
 die() {
-- 
2.30.2

