From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/26] netfilter: nf_log: Remove NULL check
Date: Wed,  6 Jul 2016 16:23:50 +0200
Message-ID: <1467815048-2240-9-git-send-email-pablo@netfilter.org>
References: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1467815048-2240-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Shivani Bhardwaj <shivanib134@gmail.com>

If 'logger' was NULL, there would be a direct jump to the label 'out',
since it has already been checked for NULL, remove this unnecessary
check.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 73b845d..18e325c 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -181,7 +181,7 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
 	if (logger == NULL)
 		goto out;
 
-	if (logger && try_module_get(logger->me))
+	if (try_module_get(logger->me))
 		ret = 0;
 out:
 	rcu_read_unlock();
-- 
2.1.4
