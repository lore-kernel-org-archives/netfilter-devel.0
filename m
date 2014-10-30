From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nf_log: fix sparse warning in nf_logger_find_get()
Date: Thu, 30 Oct 2014 18:40:02 +0100
Message-ID: <1414690802-26724-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47009 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932947AbaJ3Ri3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:38:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

net/netfilter/nf_log.c:157:16: warning: incorrect type in assignment (different address spaces)
net/netfilter/nf_log.c:157:16:    expected struct nf_logger *logger
net/netfilter/nf_log.c:157:16:    got struct nf_logger [noderef] <asn:4>*<noident>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 9562e39..49a6417 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -154,8 +154,7 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
 	struct nf_logger *logger;
 	int ret = -ENOENT;
 
-	logger = loggers[pf][type];
-	if (logger == NULL)
+	if (rcu_access_pointer(loggers[pf][type]) == NULL)
 		request_module("nf-logger-%u-%u", pf, type);
 
 	rcu_read_lock();
-- 
1.7.10.4

