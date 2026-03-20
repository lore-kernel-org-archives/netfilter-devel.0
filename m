Received: from mail.wilcox-tech.com (mail.wilcox-tech.com [45.32.83.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D399C344031
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 08:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.32.83.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773996761; cv=none; b=XHsgtYd+lprMTGDbC2MFhlzLKy1KCAhrs1cUjb8LjYuPrezbkFYgQuMmx6SQmVbFl9R+Xw0NPBBkZQQhgNKHad94pK/pqqfg3dgVJd7z9Pew+QezAX6TVVGBx2Rg4VWZUeBpPN/FTUucxEa4/GWFWItElkOOf9flEZoWeaIrbCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773996761; c=relaxed/simple;
	bh=4RNG6PXPANtcjP1jjIgrRikuU2pBUP+Sx8XCbs1s1ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=swzmsyoAFHlVrK3Bf+/P50WA34fywJHRlrOl0fo8EyRsuUj1j6v9kX4vVHwJc9S/4fkCMrHAn9j/jCPrOk79qboiTutAN2ZZ8xRCiM8x/lwcW3MCErsl1XGXnAksqhxt0Iwo0kZpzBsbAflidfjvy8E8aZN1LHtu/z8PHJ8fh1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com; spf=pass smtp.mailfrom=Wilcox-Tech.com; arc=none smtp.client-ip=45.32.83.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Wilcox-Tech.com
Received: (qmail 17761 invoked from network); 20 Mar 2026 08:45:37 -0000
Received: from 201.sub-97-232-75.myvzw.com (HELO localhost.localdomain) (awilcox@wilcox-tech.com@97.232.75.201)
  by mail.wilcox-tech.com with ESMTPA; 20 Mar 2026 08:45:37 -0000
From: Anna Wilcox <AWilcox@Wilcox-Tech.com>
To: netfilter-devel@vger.kernel.org
Cc: Anna Wilcox <AWilcox@Wilcox-Tech.com>
Subject: [libnftnl PATCH] examples: nft-rule-add: Fix compile on musl libc
Date: Fri, 20 Mar 2026 03:43:04 -0500
Message-ID: <20260320084340.26543-2-AWilcox@Wilcox-Tech.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Without `_GNU_SOURCE`, the `dest` field on `tcphdr` is not present:

nft-rule-add.c: In function 'setup_rule':
nft-rule-add.c:108:21: error: 'struct tcphdr' has no member named 'dest'

Signed-off-by: Anna Wilcox <AWilcox@Wilcox-Tech.com>
---
 examples/nft-rule-add.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 937b436..486544a 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -5,6 +5,7 @@
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
+#define _GNU_SOURCE	/* for tcphdr.dest */
 #include <stdlib.h>
 #include <time.h>
 #include <string.h>
-- 
2.52.0

