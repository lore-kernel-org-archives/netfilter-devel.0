From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] include: xtables: Add enum for better nft translation code
Date: Wed, 23 Dec 2015 19:51:33 +0530
Message-ID: <20151223142132.GA15698@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36229 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbLWOVj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 09:21:39 -0500
Received: by mail-pf0-f171.google.com with SMTP id 65so9012329pff.3
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 06:21:39 -0800 (PST)
Received: from gmail.com ([223.176.140.7])
        by smtp.gmail.com with ESMTPSA id 2sm48416383pfl.56.2015.12.23.06.21.37
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 23 Dec 2015 06:21:38 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add enum xt_op for ease to write cleaner and better code for
nft translation.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 include/xtables.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/xtables.h b/include/xtables.h
index 7d97baa..0355057 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -414,6 +414,18 @@ struct xtables_globals
 	int (*compat_rev)(const char *name, uint8_t rev, int opt);
 };
 
+/*
+ * enum op-
+ *
+ * For writing clean nftables translations code
+ */
+
+enum xt_op {
+	XT_OP_EQ,
+	XT_OP_NEQ,
+	XT_OP_MAX,
+};
+
 #define XT_GETOPT_TABLEEND {.name = NULL, .has_arg = false}
 
 #ifdef __cplusplus
-- 
1.9.1

