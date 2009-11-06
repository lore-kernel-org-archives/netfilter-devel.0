From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfiler: remove the write permission of nf_conntrack/acct
Date: Fri, 06 Nov 2009 17:34:26 +0800
Message-ID: <4AF3EDA2.6060103@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48369 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbZKFJeG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:34:06 -0500
Received: by pwj9 with SMTP id 9so546311pwj.21
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2009 01:34:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 remove write permission of nf_conntrack/acct

This option only works when initialization.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
net/netfilter/nf_conntrack_acct.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_acct.c.orig	2009-11-06 17:27:31.000000000 +0800
+++ b/net/netfilter/nf_conntrack_acct.c	2009-11-06 17:27:47.000000000 +0800
@@ -20,7 +20,7 @@
 
 static int nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
 
-module_param_named(acct, nf_ct_acct, bool, 0644);
+module_param_named(acct, nf_ct_acct, bool, 0444);
 MODULE_PARM_DESC(acct, "Enable connection tracking flow accounting.");
 
 #ifdef CONFIG_SYSCTL


