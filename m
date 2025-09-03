Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF55A3112C4
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920190; cv=none; b=WS5VVEmTU3oeT1l3qo3J8hhGmbVERCsgwVhd8r1jtQidt2fmRnR0bdrMaXu980qVWtR1PT0pDx56ngNkfz7p3ETVkx7crqg1c4jOg1MGRacS7zNZrIEYwx+OTEiVgbTr/6yIekYOuL2otXyeRORQtKvUdnBMtWQ/RUbN6Y2inQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920190; c=relaxed/simple;
	bh=nsHR86D7A3R+7rRyhLJAQ0tnKeNEZ6FXVMsYNw3uk+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wx7CCo0if5NmLAIUfwtMZaZfIm9OinUzVvvTbZPlgzPcKARQqBXNZmlVwSdc9CaVP+OrlI70eEkRjvqSYxgRrplt1q+4Tmj2B3c+eY4xhRmeVHIDoR0XSt4GNKZCgiyYEWzc0DIBPCJopxTVyI3b32mvNWiv0qzxPTydki8R+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mUSr7+IH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mUSr7+IH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X2pUTsneo0UZBXY/jI3KIpG3ZVNUEnYx+MdxVhSW+SY=; b=mUSr7+IH7RcmhAiJzUuOw/xd2c
	hSZHTNttEml32oiH1dG/69o7u81fTFAz1b223yqiNnG3pIlc5qjIl7wDBko6z+IX2+LUBxGQN/Vow
	pgf2txX6a8e+VXMjDHGUQunxYRAGBlB9HVrk83XTiYgkSdjDX6ZEQY5xc9kESa2ycSGLjbQ6nzwpO
	g+C7aVYNETJ2jMHhKxN6SD1tZqm0zspyXhvjJaUTS0Au1GR3QaAmz4oFfsAtNB5LjKxOjVoAf44+J
	HtJ0nYkf9UjZh54oDEWG0fIDyYjefVUug4Czr9eMIa9Sy1NvdYbpqqEvWr15jkArqE3hn1RdwoAOK
	b/Dw9vXg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utrCN-0000000080Q-0CIz;
	Wed, 03 Sep 2025 19:23:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3 08/11] tests: json_echo: Skip if run as non-root
Date: Wed,  3 Sep 2025 19:22:56 +0200
Message-ID: <20250903172259.26266-9-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903172259.26266-1-phil@nwl.cc>
References: <20250903172259.26266-1-phil@nwl.cc>
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

