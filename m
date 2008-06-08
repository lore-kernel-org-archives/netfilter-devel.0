From: Eric Leblond <eric@inl.fr>
Subject: netfilter: Make nflog quiet when no one listen in userspace.
Date: Sun,  8 Jun 2008 12:05:10 +0200
Message-ID: <1212919510-6499-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:52048 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751091AbYFHKC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jun 2008 06:02:57 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The message "nf_log_packet: can't log since no backend logging module loaded
in! Please either load one, or disable logging explicitly" was displayed for
each logged packet when no userspace application is listening to nflog events.
The message seems to warn for a problem with a kernel module missing but as
said before this is not the case. I thus propose to suppress the message (I
don't see any reason to flood the log because a user application has crashed.)

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_log.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index bc11d70..9fda6ee 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -92,10 +92,6 @@ void nf_log_packet(int pf,
 		vsnprintf(prefix, sizeof(prefix), fmt, args);
 		va_end(args);
 		logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
-	} else if (net_ratelimit()) {
-		printk(KERN_WARNING "nf_log_packet: can\'t log since "
-		       "no backend logging module loaded in! Please either "
-		       "load one, or disable logging explicitly\n");
 	}
 	rcu_read_unlock();
 }
-- 
1.5.4.3

