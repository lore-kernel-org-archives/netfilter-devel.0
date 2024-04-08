Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1066F1474A9
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 21:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712610951; cv=none; b=KoXav0ZLyS+cLr2Uija0mCvGaqachru9FghpirDz+MLHbv/Io6ANj/HreM8/nVihEjP5xCtJnOZr5hLhkgi4ahl+lV/1A81ZHkV2/R5ikQkpPk738fIIU8Uu7K3VoOMqO/LqdGGQfA7t7y/C29zEy3Hk1iSiCBXxiF4o1rvjftg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712610951; c=relaxed/simple;
	bh=Q69EZyxomTKLQ6L51jMGzlLr27u2muAcfIKoke94G4Y=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=glUwGd1+keIxVxiLIP+OAyCGnKSNpJh6kGZC4S/LIlqBpNWv/sVrRQdyHZcF2hC+X28Ojd0GkVrIHLu7bZ3/UjM6Qq6fLRdpI27BctGRtiAA0cle1miIqCWhgKxjbSf7q3+rut43kSAzv+yqPx27V7JxU6ls7HZAigW8J6CmLJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] tests: shell: payload matching requires egress support
Date: Mon,  8 Apr 2024 23:15:37 +0200
Message-Id: <20240408211540.311822-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240408211540.311822-1-pablo@netfilter.org>
References: <20240408211540.311822-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Older kernels do not support for egress hook.

Fixes: 84da729e067a ("tests: shell: add test to cover payload transport match and mangle")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/packetpath/payload | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/shell/testcases/packetpath/payload b/tests/shell/testcases/packetpath/payload
index 9f4587d27e22..4c5c42dafa92 100755
--- a/tests/shell/testcases/packetpath/payload
+++ b/tests/shell/testcases/packetpath/payload
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_egress)
+
 rnd=$(mktemp -u XXXXXXXX)
 ns1="nft1payload-$rnd"
 ns2="nft2payload-$rnd"
-- 
2.30.2

