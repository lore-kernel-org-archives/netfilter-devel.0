Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCEF14264C
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 10:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723630865; cv=none; b=WW6Fw1Fp/bk2RMIERfLGsFtysH1ScQCOkL/nJmYM1IFy9Lof8EJIKH7sePrMA9IhwYWv92RNUPQ7LsMkCCTY1lHz7DcmnNT98sftLWUW0NSdEWIecJg+wabwn09++ueeZsS0zv3eKY7/UQMgoYnF8heaoaAbbyPZbJFuHffcITg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723630865; c=relaxed/simple;
	bh=Hy0yYREpMU1GQF0ZJTpiJN5rpbkqXn0fCqkHy5+X3CY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=DXa6CwCC+5aYBUlg4QRf94Fc7aw0/GS0zH115c8nXA9/KYmSH1LMnBkIiBxfXmdutqoeOPZ4s60TuV/o/RHDZ9rKq2JAj1C1okol1jkkBpe/n938YbAxSKpY0SseyUAtrq5qUdRwx0N4n4xVnQBil8Gwt45rEp4L3W7Xssirqb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH] tests: shell: skip vlan mangling testcase if egress is not support
Date: Wed, 14 Aug 2024 12:20:55 +0200
Message-Id: <20240814102055.202090-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add dependency on egress hook to skip this test in older kernels.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/packetpath/vlan_mangling | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/shell/testcases/packetpath/vlan_mangling b/tests/shell/testcases/packetpath/vlan_mangling
index b3f87c66ddec..e3fd443ebcf9 100755
--- a/tests/shell/testcases/packetpath/vlan_mangling
+++ b/tests/shell/testcases/packetpath/vlan_mangling
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_egress)
+
 rnd=$(mktemp -u XXXXXXXX)
 ns1="nft1ifname-$rnd"
 ns2="nft2ifname-$rnd"
-- 
2.30.2

