Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D083F8252
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 10:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802929; cv=none; b=Z1IHuaFkBqQl0eVZx2rPqpVusJCwlufUF/euK0G3WKpYJzwUSnn6JvrhVZF2G+O3Ugdeu7xtR78cL6siND7gLIRMyWQ3v2haVwjRLFoNpr87SFjCENjTWnM7CcCPeJ82HG+ZsPWVuBZTsELDONQWXA6ZOkmcdWkb0vGCQjLt668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802929; c=relaxed/simple;
	bh=gd9eG9lvrrrvCkmFcT7YhBo8XpvLTCoxbTCN7A56VR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwBDO1YepjCYIIC87yfnIy46U3vrW1SDETUmpC1zyp8hTp/4ip8jiK6njEtdgV9kwo1YzYAnLheox+AOz7l2aLau30EQCr0UoU0BMnETEWYGQ2p8oOizqMghlrGl+RgG6sT09Y87+xpaj5iC8unrKmi5bN/l6yAnDCc5qeaGJCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 389D960EA1; Thu, 23 Jul 2026 12:35:23 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: kadlec@netfilter.org
Cc: <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 2/5] tests: hash:net.t: prefer tail -n
Date: Thu, 23 Jul 2026 12:35:01 +0200
Message-ID: <20260723103504.3175-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723103504.3175-1-fw@strlen.de>
References: <20260723103504.3175-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

seen on fedora 44:
 tail: cannot open '+2' for reading: No such file or directory

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/hash:net.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/hash:net.t b/tests/hash:net.t
index 4f88327684a4..73e36b5f80ab 100644
--- a/tests/hash:net.t
+++ b/tests/hash:net.t
@@ -61,7 +61,7 @@
 # List set and check the number of elements
 0 n=`ipset -L test|grep '^10.'|wc -l` && test $n -eq 43520
 # Stress test del with range notation
-0 ./netgen.sh | tail +2|sed 's/^a/d/' | ipset restore
+0 ./netgen.sh | tail -n +2 | sed 's/^a/d/' | ipset restore
 # List set and check the number of elements
 0 n=`ipset -L test|grep '^10.'|wc -l` && test $n -eq 0
 # Destroy test set
-- 
2.54.0

