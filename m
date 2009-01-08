From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 5/6] netfilter: print the list of register loggers.
Date: Thu,  8 Jan 2009 23:03:13 +0100
Message-ID: <1231452194-7800-5-git-send-email-eric@inl.fr>
References: <1231452093.10299.2.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net, jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:37541 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755100AbZAHWDT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:03:19 -0500
In-Reply-To: <1231452093.10299.2.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the proc output to add display of registered
loggers. The content of /proc/net/netfilter/nf_log is modified. Instead
of displaying a protocol per line with format:
	proto:logger
it now displays:
	proto:logger (comma_separated_list_of_loggers)

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_log.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 1655a1f..fc1deca 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -172,13 +172,31 @@ static int seq_show(struct seq_file *s, void *v)
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
+	list_for_each_entry(t, &nf_loggers_l[*pos], list[*pos]) {
+		ret = seq_printf(s, "%s", t->name);
+		if (ret < 0)
+			return ret;
+		if (&t->list[*pos] != nf_loggers_l[*pos].prev) {
+			ret = seq_printf(s, ",");
+			if (ret < 0)
+				return ret;
+		}
+	}
 
-	return seq_printf(s, "%2lld %s\n", *pos, logger->name);
+	return seq_printf(s, ")\n");
 }
 
 static const struct seq_operations nflog_seq_ops = {
-- 
1.5.6.3

