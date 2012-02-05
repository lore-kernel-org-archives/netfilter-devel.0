From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/4] xt_log: Make printk() in sb_close() optional
Date: Sun,  5 Feb 2012 01:14:51 +0100
Message-ID: <1328400892-22409-6-git-send-email-richard@nod.at>
References: <1328400892-22409-1-git-send-email-richard@nod.at>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	eric.dumazet@gmail.com, jengelh@medozas.de, rostedt@goodmis.org,
	Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:47849 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab2BEAPI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:15:08 -0500
In-Reply-To: <1328400892-22409-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make printk() in sb_close() optional such that other modules
can build a log string without printing it using printk().

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/net/netfilter/xt_log.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
index 0dfb34a..767e08d 100644
--- a/include/net/netfilter/xt_log.h
+++ b/include/net/netfilter/xt_log.h
@@ -39,10 +39,12 @@ static struct sbuff *sb_open(void)
 	return m;
 }
 
-static void sb_close(struct sbuff *m)
+static void __sb_close(struct sbuff *m, int print)
 {
-	m->buf[m->count] = 0;
-	printk("%s\n", m->buf);
+	if (print) {
+		m->buf[m->count] = 0;
+		printk("%s\n", m->buf);
+	}
 
 	if (likely(m != &emergency))
 		kfree(m);
@@ -52,3 +54,4 @@ static void sb_close(struct sbuff *m)
 	}
 }
 
+#define sb_close(m)	__sb_close(m, 1)
-- 
1.7.7.3

