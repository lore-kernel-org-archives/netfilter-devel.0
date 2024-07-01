Received: from cmccmta2.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6691422A6;
	Mon,  1 Jul 2024 11:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719834790; cv=none; b=UERR6EufMyH+1nDKfcMkuzSXE8nWOtoduQsOfkJWq3Q5w8hkEnYP4jxnePndSiP7n9AsG9Qohduv7Q08Tyk1n+P9csgXFX0jiijlrjN9et+xvSi+ZigaynFy0T2jwCtliX//6Km6qbrn1A2KPdgMMCUzYsIkuU+RAbj55Nlg5UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719834790; c=relaxed/simple;
	bh=qWG7kb8w8R9vl1bgDVpM+lu85kOrxk6mqBBK6s8rVyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e4O4Udr+d1VHy+A7O/5Ux22Cs03ULmm+NvlDYayYZTAJliMZa0BdyiNNpedDcjoSuiQjx4c2S1DC1bm3zl9Z6VWwhIW/zSa6PYWmuGCNIqZfqX/tPh6EdDxsjOSUhXtvJgnpec+Re9GTrRwHvzSSPtTvZ8fZV0Z1dRFJjv51ZNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86682989df94-1afc0;
	Mon, 01 Jul 2024 19:53:05 +0800 (CST)
X-RM-TRANSID:2ee86682989df94-1afc0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain.localdomain (unknown[10.54.5.252])
	by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee66682989f269-6a7e8;
	Mon, 01 Jul 2024 19:53:05 +0800 (CST)
X-RM-TRANSID:2ee66682989f269-6a7e8
From: Liu Jing <liujing@cmss.chinamobile.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Liu Jing <liujing@cmss.chinamobile.com>
Subject: [PATCH] netfilter: remove unnecessary assignment in translate_table
Date: Mon,  1 Jul 2024 19:53:02 +0800
Message-Id: <20240701115302.7246-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

in translate_table, the initialized value of 'ret' is unused,
because it will be assigned in the rear. thus remove it.

Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
---
 net/ipv4/netfilter/ip_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fe89a056eb06..c9b34d7d7558 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -664,7 +664,7 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	struct ipt_entry *iter;
 	unsigned int *offsets;
 	unsigned int i;
-	int ret = 0;
+	int ret;
 
 	newinfo->size = repl->size;
 	newinfo->number = repl->num_entries;
-- 
2.33.0



