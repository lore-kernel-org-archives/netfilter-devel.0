Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869FF61690
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 12:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706532993; cv=none; b=SvaZJmLc7LDa5iY5XxrD2f3N7hP+SzjNk71sy56UUzywYu7/FjKox2c6HqvqQpMF9SDeuDJBTpl3HhqQUx9KiLfw57Wi9vaYnEe9ztEyRH3kxYVjxaOcxDLEJlnsAomQLYBl9ReEeEKssYd4M050xXcVd9QDlkClIKHmMx03NGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706532993; c=relaxed/simple;
	bh=lnoKxKBaWzuT6bz3BzGGtCfawzaXtROFNQ3Z5Z1/wxE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=SZRDNdsCGNCc+pqU5N243mLKWQbuNAdPBOZ38vxOqu79cULqURV1jMG/X1h3O6VA8sL3Lp7mTsM0An2gM9MS33Xw4U6Riz4ShfBPnAW7v7QlUXkj3Mnccj1zJIbWb1BYxpT+F9cmdHDTbyGH+ujeQ/MoPN0wmxh2wfG9I+tOpI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Mon, 29 Jan 2024 13:56:26 +0100
Message-Id: <20240129125626.196950-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Module reference is bumped for each user, this should not ever happen.

But BUG_ON check should use rcu_access_pointer() instead.

If this ever happens, do WARN_ON_ONCE() instead of BUG_ON() and
consolidate pointer check under the rcu read side lock section.

Fixes: fab4085f4e24 ("netfilter: log: nf_log_packet() as real unified interface")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 8cc52d2bd31b..e16f158388bb 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -193,11 +193,12 @@ void nf_logger_put(int pf, enum nf_log_type type)
 		return;
 	}
 
-	BUG_ON(loggers[pf][type] == NULL);
-
 	rcu_read_lock();
 	logger = rcu_dereference(loggers[pf][type]);
-	module_put(logger->me);
+	if (!logger)
+		WARN_ON_ONCE(1);
+	else
+		module_put(logger->me);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_logger_put);
-- 
2.30.2

