From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 3/4] netfilter: print the list of register loggers.
Date: Sun, 15 Feb 2009 13:37:16 +0100
Message-ID: <1234701437-2754-3-git-send-email-eric@inl.fr>
References: <49980BA7.2040108@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54386 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752745AbZBOMhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:37:22 -0500
In-Reply-To: <49980BA7.2040108@inl.fr>
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
index 1271b4f..f9e6cad 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -168,13 +168,37 @@ static int seq_show(struct seq_file *s, void *v)
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

