Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEE863AE
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2024 01:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719452385; cv=none; b=rUbM6/lbGYNsTlR3qzDQKq8Qji9M8IdDvfiaErTgVgT6Su+wTMmOP55V7BQrf63ZA5CnZONwHfFhTbxn8qrdDNSrQLy5kd4d3vAkXHrkJtuxfwZrE7Ft0fAwfFRKxmRdk49jWWUYrLpDM+lDj8Dw+VO8OUa1JdkaujvCgZ6ioN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719452385; c=relaxed/simple;
	bh=6srObsQX78DWSWSmgpLJn7ng1V6uwn5W4An2oDgXM/A=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=NC9LqGQhP+1cNOfkLH1zBTeectz84H3bPSUwQYi/fthYtep4ppbBZnVFfylpTgiAqpQTTpVHAxMtumY30Z6GeXjOV3MqSrFSMWTsohTwzzcj9VaK6PaHpp494Bj254uzQ1hp2V2DofQDU6PyWrr7/XP7dG0SpVJMjFeVaoD5yTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: check for removing table via handle with incorrect family
Date: Thu, 27 Jun 2024 03:39:37 +0200
Message-Id: <20240627013937.2310-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test checks for upstream commit:

f6e1532a2697 ("netfilter: nf_tables: validate family when identifying table via handle")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/handle_bad_family | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/handle_bad_family

diff --git a/tests/shell/testcases/transactions/handle_bad_family b/tests/shell/testcases/transactions/handle_bad_family
new file mode 100755
index 000000000000..592241890a69
--- /dev/null
+++ b/tests/shell/testcases/transactions/handle_bad_family
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+NFT=nft
+
+HANDLE=$($NFT -a -e add table ip x | cut -d '#' -f 2 | awk '{ print $2 }' | head -1)
+
+# should fail
+$NFT delete table inet handle $HANDLE
+[ $? -ne 0 ] && exit 0
-- 
2.30.2

