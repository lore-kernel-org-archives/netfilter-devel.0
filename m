Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314712913
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 00:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718238187; cv=none; b=Fjo4MM6uAG2WpuX0aTeqy1I2hsVOTocdS1+MxUN24T0dbnI66ndhEvOhAsxQSkG5NVzb8mBdpz5zq5w4BQPXZV90zrhGnDaQ3GEYsBz6f+37gCUu+XEwppPXYriRkxMQNAeb94EQSftHdjjwQgbQjQBlTwGl0qQSGlRUnU6zXdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718238187; c=relaxed/simple;
	bh=OasLmGnpEGpRaxzZQl4Zp43giKlNwtIfE57JPtZlfgw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=meArT2X+ziMDhTsEG/fSuWKeMy0D49bL29jn5BN20Fay+lkNMLJZ2Sq/SeIfMLBMMzD7/QaFtWHCeF96kmsdLUbRwCq2Wp5mrRv6fjNE3ogTK0D8llCiUxCKozX6RjuoQ9v8hU1WysKlBQbBvMOVlVFJdIUD4MkTVPa47nm4B1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/4] tests: shell: skip ipsec tests if kernel does not support it
Date: Thu, 13 Jun 2024 02:22:52 +0200
Message-Id: <20240613002253.103683-3-pablo@netfilter.org>
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
 tests/shell/features/ipsec.nft           | 7 +++++++
 tests/shell/testcases/maps/typeof_maps_0 | 2 ++
 2 files changed, 9 insertions(+)
 create mode 100644 tests/shell/features/ipsec.nft

diff --git a/tests/shell/features/ipsec.nft b/tests/shell/features/ipsec.nft
new file mode 100644
index 000000000000..e7252271b6cf
--- /dev/null
+++ b/tests/shell/features/ipsec.nft
@@ -0,0 +1,7 @@
+# 6c47260250fc ("netfilter: nf_tables: add xfrm expression")
+# v4.20-rc1~14^2~125^2~25
+table ip x {
+	chain y {
+		ipsec in reqid 23
+	}
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_0 b/tests/shell/testcases/maps/typeof_maps_0
index 98517fd52506..764206d26dc1 100755
--- a/tests/shell/testcases/maps/typeof_maps_0
+++ b/tests/shell/testcases/maps/typeof_maps_0
@@ -4,6 +4,8 @@
 # without typeof, this is 'type string' and 'type integer',
 # but neither could be used because it lacks size information.
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ipsec)
+
 set -e
 
 die() {
-- 
2.30.2

