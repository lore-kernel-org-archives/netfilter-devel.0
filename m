Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE20335961
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 15:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756482735; cv=none; b=K7QR6TnR9mE9SB0qAAz/Wl1SEXIqAo+MBpnzdOrCxPHcaBYnWDJdYutLdQ1BKc+InFq1DWcwBANvNvpvlG/RLqr3W5Dwb5tBZQ657qMbU1dDbwreQjrVCv/wAqSe08okvw7/0EzkqGXAAZti57YFxl93daWiD5Wpx+HZ6xsw/fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756482735; c=relaxed/simple;
	bh=nsHR86D7A3R+7rRyhLJAQ0tnKeNEZ6FXVMsYNw3uk+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfOwOAZGMGPsgMqNOewbRFZN600VSivfMoErn5n8tPzrspmkMLdmo5x6UuOdghSobUkOz9lXlhfUjZa6IAONtqR6wPYsChoJuxoIXe63AnS+szYzfOZ8L2EbwoEOgqF/mB+z/+gFOWHz7KRVN2SuaEVXuw1kgvTkB+Kr4+AFv+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fu+g0fe9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fu+g0fe9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X2pUTsneo0UZBXY/jI3KIpG3ZVNUEnYx+MdxVhSW+SY=; b=fu+g0fe9iN80Z5fjQ3NJj5LO/Z
	5Q5b0pxnZYJl/zdI44hwXrtXb6dqHv/CkleDCM57C06KOOi8qCEWaXgYNrPTeBtQ4Zfo6gBj4nE63
	A8ej7GAcfcwYejnRweMA94q0hI8aozn6E+3wvMHutOoSx5h81njXKJuuTOXkdnl0wONw29TQzAoMo
	a4xqJcIEmULeoKZKLcO3lnc29k5DDh+zEXGOTsPfkvewSr6K4RQIrnLUJy9jnAVGt50XOqh1EKMCS
	HI2NO5vlms07J/Q+zTBSIqOeQ0VaxfuaawpOL3F/HJsuaZEI+Wa54so7Yp0CsSqhCQEzJfhr51G+M
	7V3ClGrw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us1Od-000000001S5-3EgC;
	Fri, 29 Aug 2025 17:52:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 4/7] tests: json_echo: Skip if run as non-root
Date: Fri, 29 Aug 2025 17:52:00 +0200
Message-ID: <20250829155203.29000-5-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829155203.29000-1-phil@nwl.cc>
References: <20250829155203.29000-1-phil@nwl.cc>
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

