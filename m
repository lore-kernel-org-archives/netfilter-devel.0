From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 2/8] netfilter: get rid of sparse warning
Date: Thu, 24 Jan 2008 10:15:38 -0800
Message-ID: <20080124181628.087126298@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48243 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbYAXSYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:20 -0500
Content-Disposition: inline; filename=nf-log-sparse.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tell sparse about lock assumption here.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/netfilter/nf_log.c	2008-01-23 10:02:42.000000000 -0800
+++ b/net/netfilter/nf_log.c	2008-01-23 10:03:00.000000000 -0800
@@ -103,6 +103,7 @@ EXPORT_SYMBOL(nf_log_packet);
 
 #ifdef CONFIG_PROC_FS
 static void *seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(RCU)
 {
 	rcu_read_lock();
 
@@ -123,6 +124,7 @@ static void *seq_next(struct seq_file *s
 }
 
 static void seq_stop(struct seq_file *s, void *v)
+	__releases(RCU)
 {
 	rcu_read_unlock();
 }

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>

