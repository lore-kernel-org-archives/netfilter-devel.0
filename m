Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58C229B1A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748515496; cv=none; b=d75VBxQRgyYa66FHu1baD+63hz96HUNPUBYlmpoE0drBZYegIyL+essPxPQ+OtXB1mh3rI6WEbsCvyqHruSP7QCYrqhm7SllprEosVVQzSpqjZvzqC7Tw5z1UhgtReRmV3A240AjmSIxcXfYepqXr3jCNpcwS4cb2eiKCAnfrL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748515496; c=relaxed/simple;
	bh=8OGTsUSksmWhBRb9YgJ+iSHSiMSKDBao6LdqZdmE794=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=E7Feg02PE8fhKPiNDFzYgHkRRy4KxYaJ3YduxLUTjDIpl7Foy0PWranViRyO7Ugqo7KNFLp1517hjT2nlBoU+wsPCCs2PfKc4bmmu0wuEfBYSGGswAPKt+tL7ZMH67kiL9m0Ya59QGNdD3HrWuvlunKVGixqAzKKL0p2FBHZ2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SYUsqzop; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rlNuOuzu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SYUsqzop";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rlNuOuzu"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0E3C460768; Thu, 29 May 2025 12:44:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748515490;
	bh=z0H2oUS/jFpsQFRssmReKE0zjPCC80AeLYmz/YzFszg=;
	h=From:To:Subject:Date:From;
	b=SYUsqzoplx6StqxmJrhOVMSL4iEk2ZyaRFGOfgNB3fN8wSxaP3ldT+29udVVQooMC
	 UNb5u9Ef4gUjaFKyWxiJGBA5hb7UGivuvisaSBYxTzQam3+ZCmGhk8N8l8OsbQdg38
	 Lm+N00GvEnJcI3glC2V4vnfWTgqliPrMka4RHxCEf5hQQJtOznYGsZOeYU5XBtPCuj
	 c9m7z5UB3Z90xzCdcsiJ5K7ny9nWM7oDy/1kl1wC/8u62OBckk+XYvtic24ziTyJdu
	 DZo1fhGRIIvKr8UdfrCIl3Hm7tYX05mnKXUJbXtnob/KTeX2bd9XRVgZ9L+HL8rroq
	 1RUfOnZICWT1w==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A197960764
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 12:44:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748515489;
	bh=z0H2oUS/jFpsQFRssmReKE0zjPCC80AeLYmz/YzFszg=;
	h=From:To:Subject:Date:From;
	b=rlNuOuzuA/zGFND6ejo00tTBhk2cUXQ6loWoM7+uHJHegSDwfTe/jNQ/eM9xtG+6S
	 +BY5jyScMY1FNfkPBSh4ZUlfxhpD1eq0+CvXIpUoKOiOzjVn1DJI0a9IfKNeC4FDzS
	 Om8KosTUofI/MAd7FxoNERYutz3oaxKdk54qPwbX+Hm40FGonHh5T8Wetel4J8KHik
	 zoYZJe/xnGTN+Evlbqmsu9vJB+4+QUWtjtrKb8p+E8vX0pcaXarP3UvkkEW0bskSBg
	 BdwrDcqqKP1xx8lIZocsnsDs13LHd3dWU/KgQZiVnBCHHDMW5efZ7hMs9JM9f1+gXZ
	 n7PUPFt3mK9yQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: check for features not available in 5.4
Date: Thu, 29 May 2025 12:44:45 +0200
Message-Id: <20250529104445.246952-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4 -stable kernels report failures in these tests, this kernel version
is lacking these feature.

The bitshift requirement is needed by this ruleset:

 table ip x {
        set s13 {
                typeof tcp option mptcp subtype
                elements = { mp-join, dss }
        }

        chain y {
                tcp option mptcp subtype @s13 accept
        }
 }

which uses bitshift in its bytecode.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/json/single_flag   | 1 +
 tests/shell/testcases/sets/elem_limit_0  | 2 +-
 tests/shell/testcases/sets/set_stmt      | 2 ++
 tests/shell/testcases/sets/typeof_sets_0 | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/json/single_flag b/tests/shell/testcases/json/single_flag
index 41fab63b0a23..43ae4528a179 100755
--- a/tests/shell/testcases/json/single_flag
+++ b/tests/shell/testcases/json/single_flag
@@ -7,6 +7,7 @@
 #   recognized in input (checked against standard syntax input/output)
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_table_flag_persist)
 
 set -e
 
diff --git a/tests/shell/testcases/sets/elem_limit_0 b/tests/shell/testcases/sets/elem_limit_0
index b57f9274bcd0..ed6009166fb9 100755
--- a/tests/shell/testcases/sets/elem_limit_0
+++ b/tests/shell/testcases/sets/elem_limit_0
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-## requires EXPR
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
 
 set -e
 
diff --git a/tests/shell/testcases/sets/set_stmt b/tests/shell/testcases/sets/set_stmt
index 0433b6768b69..ea50525a8037 100755
--- a/tests/shell/testcases/sets/set_stmt
+++ b/tests/shell/testcases/sets/set_stmt
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_set_expr)
+
 test_set_stmt() {
 	local i=$1
 	local stmt1=$2
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index ef2726db3b30..28e39b4d2cb3 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -5,6 +5,7 @@
 # ways for declaration.
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_ip_options)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_bitshift)
 
 set -e
 
-- 
2.30.2

