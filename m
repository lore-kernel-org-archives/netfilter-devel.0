Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3778D28C5D9
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754064679; cv=none; b=pDBh0ONt97YH1t+usoS2qGahSQkzpUAHUVX9wOdDAIyqGCVkUeo2PlNiIB8dMpjpnZoPexTlRH/KrHi1XST8mr044DniryjH8mFBaHai9NnlVLabu8oG82tprG3cH+mYOtekr9zT4tXs3Cgf0rX2/WXiTNH8OaZFpi1V+kRrU5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754064679; c=relaxed/simple;
	bh=oOEAOA8jpCdlBdKKViUBS4YcXQ1KAjkT61o7h86hu+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqA6SrLa9xbeJ5GazlzhuumiOnSrvFXzwJrYcBn4VZzrS8L251xqC6IC5o0+5dOIuAgX4rrrOuD7OutH1AhhowNolrbFVw5dstS7fQG3k4CEP0Z1SGWCRlnQx1eYvhtL5ykte126QQqPdtUnBmCSbH/mMxjWILlNO2rzbolDFcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iypy0Qrv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iypy0Qrv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tqi1qvfDgiB3hWj0YlYzPCRn0CrbGDyFqJpp8v71KD8=; b=iypy0Qrv2Gx+gYz6/+1FVXRn1W
	4IXwgZBTVwDif3XjcnegqtIQPYJSRogCLerY7nDhJc1dpahe1MxofYXsC/YfiK753DVep4bnlG6Ik
	IbP75n3lqYA3os9x4tr+iQttvzoGXtDglPpRvhfBeI4Dyz3bsv5e8SS49ndeS9ktTMlgew68Tkmdv
	S2XvdAZYOdHJZBWKrU0Us7ysUaurEISvV3/NGKzaSdsuHo9qN57rAcBBcSGJSf8mRmB1nGh5NP/xZ
	thpq3bs3IbiXTrJaglQY6WgBFIhV46ibQEywbvA/89atNe2oEPH8qcUKsJUU3p5H+NX9CIGBDSri8
	taDyoT4w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhsLh-000000005Ib-1lnf;
	Fri, 01 Aug 2025 18:11:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/6] tests: json_echo: Skip if run as non-root
Date: Fri,  1 Aug 2025 18:11:03 +0200
Message-ID: <20250801161105.24823-5-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250801161105.24823-1-phil@nwl.cc>
References: <20250801161105.24823-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/json_echo/run-test.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/json_echo/run-test.py b/tests/json_echo/run-test.py
index a6bdfc61afd7b..a3085b35ade6b 100755
--- a/tests/json_echo/run-test.py
+++ b/tests/json_echo/run-test.py
@@ -6,6 +6,10 @@ import os
 import json
 import argparse
 
+if os.getuid() != 0:
+    print("You need to be root to run this, sorry")
+    sys.exit(77)
+
 TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TESTS_PATH, '../../py/'))
 
-- 
2.49.0

