From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/4] netfilter: nf_log: handle NFPROTO_INET properly in nf_logger_[find_get|put]
Date: Wed,  8 Jun 2016 20:43:17 +0800
Message-ID: <1465389800-27842-2-git-send-email-zlpnobody@163.com>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:33465 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422765AbcFHMoM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:44:12 -0400
In-Reply-To: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

When we request NFPROTO_INET, it means both NFPROTO_IPV4 and NFPROTO_IPV6.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_log.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index a5d41df..73b845d 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -159,6 +159,20 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
 	struct nf_logger *logger;
 	int ret = -ENOENT;
 
+	if (pf == NFPROTO_INET) {
+		ret = nf_logger_find_get(NFPROTO_IPV4, type);
+		if (ret < 0)
+			return ret;
+
+		ret = nf_logger_find_get(NFPROTO_IPV6, type);
+		if (ret < 0) {
+			nf_logger_put(NFPROTO_IPV4, type);
+			return ret;
+		}
+
+		return 0;
+	}
+
 	if (rcu_access_pointer(loggers[pf][type]) == NULL)
 		request_module("nf-logger-%u-%u", pf, type);
 
@@ -179,6 +193,12 @@ void nf_logger_put(int pf, enum nf_log_type type)
 {
 	struct nf_logger *logger;
 
+	if (pf == NFPROTO_INET) {
+		nf_logger_put(NFPROTO_IPV4, type);
+		nf_logger_put(NFPROTO_IPV6, type);
+		return;
+	}
+
 	BUG_ON(loggers[pf][type] == NULL);
 
 	rcu_read_lock();
-- 
2.5.5


