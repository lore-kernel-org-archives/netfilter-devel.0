Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB99216A17
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 19:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727897944; cv=none; b=aOZiiLNmNXBpVDHs0orcPKCsk1YQfxfUhe4Ifd0BA7PN2Ff0IjWo1+VqTwnowY+PlVJB5R02oqfUQeDAGqPrRqLz03gNeSXfGn2Ygk6X62gyEEoHPRvaDgAqN/3K4CN2paO3BfZpkDkecCckCYlOppkGtbfjL0EuBodKE9qNiT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727897944; c=relaxed/simple;
	bh=IDnHKcZqf2GEl7M7gI3Pi/spP4OywpP6k9V21EeYvQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f58Rf+nhm19mwNYUKbzJR0T4h/aQBDBdswebWF+yXy+yQEe/QO6hKOoPM6hk2RJj8uPftHKVXjVAXy2rQfuXRC64CDPpvO5B53ifaIkmWzCwUzggqOYXGs4YVRKdbZlGNA8wXvxEHjhhGZ63TfjXJUUfiolFOMoQqSN35tNPUkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Cfl6x2zG; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Cfl6x2zG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Cox4wjgEoc/0Ey3Rh1muV92rnCEA/9hRe01iPKQop04=; b=Cfl6x2zG/xt1ZBJu4yaSgEMubP
	zzUiDyvYP3S61elfhGo1rKRp29/kYUbjQbXleAe/fqrkLOzLXfKJf4/Q2QfAsf970UyvtNQ1gxasy
	m4Euds1eGHOsDknvQJar5WcMwo4OwS39SLdGzGbA2ETFncJuMrA7DLaAxRpulz+xmJJHPD95HAN/q
	FeoMQnngBC/rvm+2rVnZGPX/YWzQf70/O2vUvGpm9KmBuwHHstJ+EZq+zTmH+xqB/oJPkZv9YHRRM
	So8ah8Hq4rSJdxu/YCUOfbBmISv/0TGYhE5s42DN2R+ZpjkY31A4RsvBgeRelN1ijra/ypo6EWk8B
	GJgyBMWQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sw5Bd-0000000031K-0tnd;
	Wed, 02 Oct 2024 21:39:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/9] tests: py: Fix for storing payload into missing file
Date: Wed,  2 Oct 2024 21:38:46 +0200
Message-ID: <20241002193853.13818-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running a test for which no corresponding *.payload file exists,
the *.payload.got file name was incorrectly constructed due to
'payload_path' variable not being set.

Fixes: 2cfab7a3e10fc ("tests/py: Write dissenting payload into the right file")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/nft-test.py | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tests/py/nft-test.py b/tests/py/nft-test.py
index 00799e281d566..7acdb77f2d0a2 100755
--- a/tests/py/nft-test.py
+++ b/tests/py/nft-test.py
@@ -769,10 +769,9 @@ def set_delete_elements(set_element, set_name, table, filename=None,
 
     if rule[1].strip() == "ok":
         payload_expected = None
-        payload_path = None
+        payload_path = "%s.payload" % filename_path
         try:
-            payload_log = open("%s.payload" % filename_path)
-            payload_path = payload_log.name
+            payload_log = open(payload_path)
             payload_expected = payload_find_expected(payload_log, rule[0])
         except:
             payload_log = None
-- 
2.43.0

