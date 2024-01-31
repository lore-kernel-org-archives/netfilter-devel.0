Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C433A8EF;
	Wed, 31 Jan 2024 22:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706741997; cv=none; b=ZGnJ6RcqiikJo5wx4HEH72yoMXnxl7rJe6B88v2LHHF6g2+gaiEK1QnKjw5nrb/Z4ZByT9cNIwH68Fy3Hc9vG7FfMYi5EtCtSAA06bDDW3HfEGSfjxjASrcAhl/q/ccS920IT7w/vPO+LILpl5wULoAWOqpVLk9OWR8HcyIqRog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706741997; c=relaxed/simple;
	bh=lnoKxKBaWzuT6bz3BzGGtCfawzaXtROFNQ3Z5Z1/wxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VBj5JyhwogyU85LtvFqpglTVdljKldv8HNtF2fdFzXRGCDPAUQ6WhQ0N+PU7iSFZPtmLVSaFHZit/zTu1koxhRKxVH75QGCWHUrFirF6Xges6CJfg4NOCymk61uQ2HoY42JH+UoBbHh7eB5AF/5eGmptU8mLDAc3IMvrN5P0Y7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 5/6] netfilter: nf_log: replace BUG_ON by WARN_ON_ONCE when putting logger
Date: Wed, 31 Jan 2024 23:59:42 +0100
Message-Id: <20240131225943.7536-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240131225943.7536-1-pablo@netfilter.org>
References: <20240131225943.7536-1-pablo@netfilter.org>
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

