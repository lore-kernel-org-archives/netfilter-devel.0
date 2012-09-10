From: Romain Francoise <romain@orebokech.com>
Subject: [PATCH] netfilter: xt_LOG: avoid using old-style "<.>" printk prefix
Date: Mon, 10 Sep 2012 19:29:06 +0200
Message-ID: <874nn5dbx9.fsf@silenus.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stringer.orebokech.com ([88.190.240.207]:44639 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2IJRg3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:36:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since commit 04d2c8c83d ("printk: convert the format for KERN_<LEVEL> to
a 2 byte pattern"), printk no longer uses a "<.>" string prefix
internally, so the call in xt_LOG ends up emitting the prefix as part of
the log itself (and possibly not at the configured level).

To avoid having to worry about printk's internal formatting, switch to
printk_emit(), specifying the desired level directly.

Signed-off-by: Romain Francoise <romain@orebokech.com>
---
 include/net/netfilter/xt_log.h |    7 +++++--
 net/netfilter/xt_LOG.c         |    6 +++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
index 9d9756c..343f5bb 100644
--- a/include/net/netfilter/xt_log.h
+++ b/include/net/netfilter/xt_log.h
@@ -39,11 +39,14 @@ static struct sbuff *sb_open(void)
 	return m;
 }
 
-static void sb_close(struct sbuff *m)
+static void sb_emit(struct sbuff *m, int level)
 {
 	m->buf[m->count] = 0;
-	printk("%s\n", m->buf);
+	printk_emit(0, level, NULL, 0, "%s\n", m->buf);
+}
 
+static void sb_close(struct sbuff *m)
+{
 	if (likely(m != &emergency))
 		kfree(m);
 	else {
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index ff5f75f..d33ff9f 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -436,7 +436,7 @@ log_packet_common(struct sbuff *m,
 		  const struct nf_loginfo *loginfo,
 		  const char *prefix)
 {
-	sb_add(m, "<%d>%sIN=%s OUT=%s ", loginfo->u.log.level,
+	sb_add(m, "%sIN=%s OUT=%s ",
 	       prefix,
 	       in ? in->name : "",
 	       out ? out->name : "");
@@ -477,6 +477,8 @@ ipt_log_packet(u_int8_t pf,
 
 	dump_ipv4_packet(m, loginfo, skb, 0);
 
+	sb_emit(m, loginfo->u.log.level);
+
 	sb_close(m);
 }
 
@@ -807,6 +809,8 @@ ip6t_log_packet(u_int8_t pf,
 
 	dump_ipv6_packet(m, loginfo, skb, skb_network_offset(skb), 1);
 
+	sb_emit(m, loginfo->u.log.level);
+
 	sb_close(m);
 }
 #endif
-- 
1.7.10.4


