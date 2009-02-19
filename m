From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/3] netfilter: print the list of register loggers.
Date: Thu, 19 Feb 2009 22:54:17 +0100
Message-ID: <1235080458-6623-2-git-send-email-eric@inl.fr>
References: <499DD499.50704@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:59826 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757931AbZBSVyX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:54:23 -0500
In-Reply-To: <499DD499.50704@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the proc output to add display of registered
loggers. The content of /proc/net/netfilter/nf_log is modified. Instead
of displaying a protocol per line with format:
	proto:logger
it now displays:
	proto:logger (comma_separated_list_of_loggers)
NONE is used as keyword if no logger is used.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_log.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 96cc2f4..efda4ba 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -154,13 +154,37 @@ static int seq_show(struct seq_file *s, void *v)
 {
 	loff_t *pos = v;
 	const struct nf_logger *logger;
+	struct nf_logger *t;
+	int ret;
 
 	logger = rcu_dereference(nf_loggers[*pos]);
 
 	if (!logger)
-		return seq_printf(s, "%2lld NONE\n", *pos);
+		ret = seq_printf(s, "%2lld NONE (", *pos);
+	else
+		ret = seq_printf(s, "%2lld %s (", *pos, logger->name);
+
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&nf_log_mutex);
+	list_for_each_entry(t, &nf_loggers_l[*pos], list[*pos]) {
+		ret = seq_printf(s, "%s", t->name);
+		if (ret < 0) {
+			mutex_unlock(&nf_log_mutex);
+			return ret;
+		}
+		if (&t->list[*pos] != nf_loggers_l[*pos].prev) {
+			ret = seq_printf(s, ",");
+			if (ret < 0) {
+				mutex_unlock(&nf_log_mutex);
+				return ret;
+			}
+		}
+	}
+	mutex_unlock(&nf_log_mutex);
 
-	return seq_printf(s, "%2lld %s\n", *pos, logger->name);
+	return seq_printf(s, ")\n");
 }
 
 static const struct seq_operations nflog_seq_ops = {
-- 
1.5.6.3

