Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B475118FC86
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Mar 2025 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741517740; cv=none; b=JRQbvHlafVQjGB+2NmxtAbocqG5A1SG4r6XTZ455mEPp7DhpN9vqn/WfhIePKjJf7b7RS+NzlwMAkBJNtemsttrpjhuIMcCyOmviLbHKSST5NVuBWN8fBqZTvaOYl/Bxvv0h983eyLLE3KynnENPNb4fegFfTURhbBWgZtdHC8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741517740; c=relaxed/simple;
	bh=eGKjkvSHpvhfquKyI5mmE9BH68+JRU3D6rt5uvCRqJo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gfAbhXArxlVjf48qpFDmgF3mjiFBZP9CdieEZ0CPIvwtIj/yc9YCObmPdgnwwOAPFowAeCNEnkHLq/oWdgGs2aj7VEuhbPGCZhllHa7Ro+S6wm88HHXfbDsEfxR2xlzS3IlX50cxr9+HtAjcoiU+tTP2Cxfj4xbeN32FnZjmdj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1trEJk-0002jt-Ko; Sun, 09 Mar 2025 11:55:36 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnetfilter_log] autoconf: don't curl build script
Date: Sun,  9 Mar 2025 11:55:19 +0100
Message-ID: <20250309105529.42132-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a bad idea; cloning repo followed by "./autogen.sh" brings
repository into a changed state.

Partial revert of 74576db959cb
("build: doc: `make` generates requested documentation")

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 autogen.sh | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/autogen.sh b/autogen.sh
index 93e2a23135d4..5e1344a85402 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,12 +1,4 @@
 #!/bin/sh -e
 
-BUILD_MAN=doxygen/build_man.sh
-
-# Allow to override build_man.sh url for local testing
-# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
-curl ${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}/$BUILD_MAN\
-  -o$BUILD_MAN
-chmod a+x $BUILD_MAN
-
 autoreconf -fi
 rm -Rf autom4te.cache
-- 
2.48.1

