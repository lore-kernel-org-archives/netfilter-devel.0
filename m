Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182001292CE
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2024 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725031902; cv=none; b=d3t+JG4IdfNR9x/2TMq7S3Awno3/gne8ujZfeWZkyk+HkJINBsq+NGKl0DQWEf4X4kIe5+ifqRjOGl4g6JbNzHH8EK4QZSDK90uq+QWsytJnNlfLiwMzB5XwtNhrMezu3JZuKFw02icyvvSGZjNOndX+8imfP6gsiIrbB1j8TK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725031902; c=relaxed/simple;
	bh=OGL7mL2B+sumLdngU+FYRpLdkGDuKsZj9CEtKosKe+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZrtzUEHWjbv3F2KoCtStYQvZJsA2I8s0hKYP2CmLtujF2OVe1dfS5uSBMSCnSbhysrg5oKFVfDGUK7sbzV++auUm0T1Np0sQPrAQVpIh3XPmrjib5Vo88lv463jzQKQySLNNNmBUpBGAxUB39g596XPHIAiQyiG1bt7xXXYOI2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: mpagano@gentoo.org
To: netfilter-devel@vger.kernel.org
Cc: Mike Pagano <mpagano@gentoo.org>
Subject: [PATCH] ipset: Fix implicit declaration of function basename
Date: Fri, 30 Aug 2024 11:31:19 -0400
Message-ID: <20240830153119.1136721-1-mpagano@gentoo.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mike Pagano <mpagano@gentoo.org>

basename(3) is defined in libgen.h in MUSL. 
Include libgen.h where basename(3) is used.

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
---
 src/ipset.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/ipset.c b/src/ipset.c
index 162f477..d7733bf 100644
--- a/src/ipset.c
+++ b/src/ipset.c
@@ -15,6 +15,7 @@
 #include <config.h>
 #include <libipset/ipset.h>		/* ipset library */
 #include <libipset/xlate.h>		/* translate to nftables */
+#include <libgen.h>
 
 int
 main(int argc, char *argv[])
-- 
2.46.0

