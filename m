Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4FA299A8C
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999509; cv=none; b=pQ7IyviKlJoHYmzE4k9zfromrmyGjL6h+vSbYwsSiLKuxx/QSvybKZdZRIBj64Fh4YCqLUWGQPsTzvtMLBsjt5kP/ijrCFcw9turUjeivG5KbtrVyWEA7kYaYognvmKuLJaA/xEJoe0O51RAuAgR6VqsM+0nQlCv4tcB5ZlvRjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999509; c=relaxed/simple;
	bh=nsHR86D7A3R+7rRyhLJAQ0tnKeNEZ6FXVMsYNw3uk+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iomt1xQDeEuvLlDFfWMoN7sYTk7Sf4K0eQQ82w380mbKJ2HjNlCnY7r79JizAso0jodsZ54BOdjZetu+AUEV/QtnczVAkOUOnSlAgJDgPYCXp7UxCr/rfzrcgvhzYUN6be0z8mMDmqNKK8of+8Pt9wnqnq+IkdZ6SZ4giXYDDAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VWQhR65Z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VWQhR65Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X2pUTsneo0UZBXY/jI3KIpG3ZVNUEnYx+MdxVhSW+SY=; b=VWQhR65ZjhBiMfLbt8ANCa9RRy
	Kv3D3ltSsDtBVG9xw2nIBfomxvwBTX1r+42MXoFwu5xR0sKVlhuw44/Dp9RtcqqcdaExXORCjp3B2
	oJjTSvSaI1vJFuDqaG9LuF9F4+cg/EMmuXVrYOvGn4s83vQZeDf/Ug/X0LRzzF0hew+jrlx2e5lnc
	U5aKKVnyJ5Jj1L7R4GqEWpXMROH/GYejh+VQ5KLvOwbbjoLTLpZ3zfOqSGzd+3//jRy//lUyXGs2g
	U0SU0UvF30sdxEFe/FsP01t7+BlfoM4AjMQ/TGtMkcLh6aukCe2XSQiU+kaLwNPCfDyjEMTRO3knv
	FHwt9pYQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBpi-000000001ps-2ZdX;
	Thu, 04 Sep 2025 17:25:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v4 4/8] tests: json_echo: Skip if run as non-root
Date: Thu,  4 Sep 2025 17:24:50 +0200
Message-ID: <20250904152454.13054-5-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250904152454.13054-1-phil@nwl.cc>
References: <20250904152454.13054-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test suite manipulates the kernel ruleset. Use the well-known return
code 77 to indicate test execution being skipped.

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
2.51.0

