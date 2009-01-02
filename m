From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 4/5] netfilter: print the list of register loggers.
Date: Fri,  2 Jan 2009 18:07:34 +0100
Message-ID: <1230916055-15448-4-git-send-email-eric@inl.fr>
References: <1230915875.28326.87.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:49075 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756991AbZABRHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:07:45 -0500
In-Reply-To: <1230915875.28326.87.camel@ice-age>
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
 net/netfilter/nf_log.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 5d6748c..ed03c20 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -167,13 +167,26 @@ static int seq_show(struct seq_file *s, void *v)
 {
 	loff_t *pos = v;
 	const struct nf_logger *logger;
+	struct nf_logger *t;
+	char loggers_string[256];
+	int len = 256;
 
 	logger = rcu_dereference(nf_loggers[*pos]);
 
+	memset(loggers_string, 0, len);
+	list_for_each_entry(t, &nf_loggers_l[*pos], list[*pos]) {
+		strncat(loggers_string, t->name, len);
+		strncat(loggers_string, ",", 1);
+		len -= strlen(t->name) + 1;
+	}
+	if (strlen(loggers_string))
+		loggers_string[strlen(loggers_string) -1] = 0;
+
 	if (!logger)
-		return seq_printf(s, "%2lld NONE\n", *pos);
+		return seq_printf(s, "%2lld NONE (%s)\n", *pos, loggers_string);
 
-	return seq_printf(s, "%2lld %s\n", *pos, logger->name);
+	return seq_printf(s, "%2lld %s (%s)\n", *pos, logger->name,
+			  loggers_string);
 }
 
 static const struct seq_operations nflog_seq_ops = {
-- 
1.5.6.3

