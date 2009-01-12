From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] netfilter: desactivate nf_log logger via sysctl.
Date: Mon, 12 Jan 2009 08:14:34 +0100
Message-ID: <1231744474-19993-1-git-send-email-eric@inl.fr>
References: <1231452093.10299.2.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39497 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751471AbZALHOi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:14:38 -0500
In-Reply-To: <1231452093.10299.2.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for unbind of logger via sysctl. By echoing
"NONE" to a /proc/sys/net/netfilter/nf_log/PROTO file, the logger
corresponding to this PROTO is set to NULL.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_log.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index d4b5259..4775700 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -252,6 +252,10 @@ static int nf_log_proc_dostring(ctl_table *table, int write, struct file *filp,
 
 	rcu_read_lock();
 	if (write) {
+		if (!strnicmp(buffer, "NONE", *lenp - 1)) {
+			rcu_read_unlock();
+			return nf_log_unbind_pf(table->ctl_name);
+		}
 		logger = __find_logger_n(table->ctl_name, buffer, *lenp -1);
 		if (logger == NULL) {
 			rcu_read_unlock();
-- 
1.5.6.3

