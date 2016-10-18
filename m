From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [nf-next PATCH] netfilter: update Arturo Borrero Gonzalez email
 address
Date: Tue, 18 Oct 2016 14:02:29 +0200
Message-ID: <147679214958.17523.7992061607718852857.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43468 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753111AbcJRMCd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2016 08:02:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 1131D51F2EA
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 12:02:30 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jlNKplBNbSSE for <netfilter-devel@vger.kernel.org>;
        Tue, 18 Oct 2016 14:02:18 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 339D151F277
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Oct 2016 14:02:17 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The email address has changed, let's update the copyright statements.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 net/ipv4/netfilter/nft_masq_ipv4.c  |    4 ++--
 net/ipv4/netfilter/nft_redir_ipv4.c |    4 ++--
 net/ipv6/netfilter/nft_masq_ipv6.c  |    4 ++--
 net/ipv6/netfilter/nft_redir_ipv6.c |    4 ++--
 net/netfilter/nft_masq.c            |    4 ++--
 net/netfilter/nft_redir.c           |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/nft_masq_ipv4.c b/net/ipv4/netfilter/nft_masq_ipv4.c
index 51ced81..9a1250e8 100644
--- a/net/ipv4/netfilter/nft_masq_ipv4.c
+++ b/net/ipv4/netfilter/nft_masq_ipv4.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -77,5 +77,5 @@ module_init(nft_masq_ipv4_module_init);
 module_exit(nft_masq_ipv4_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "masq");
diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter/nft_redir_ipv4.c
index c09d438..adf709f 100644
--- a/net/ipv4/netfilter/nft_redir_ipv4.c
+++ b/net/ipv4/netfilter/nft_redir_ipv4.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -72,5 +72,5 @@ module_init(nft_redir_ipv4_module_init);
 module_exit(nft_redir_ipv4_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET, "redir");
diff --git a/net/ipv6/netfilter/nft_masq_ipv6.c b/net/ipv6/netfilter/nft_masq_ipv6.c
index 9597ffb..4cf92dd 100644
--- a/net/ipv6/netfilter/nft_masq_ipv6.c
+++ b/net/ipv6/netfilter/nft_masq_ipv6.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -77,5 +77,5 @@ module_init(nft_masq_ipv6_module_init);
 module_exit(nft_masq_ipv6_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "masq");
diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter/nft_redir_ipv6.c
index aca44e8..f80c294 100644
--- a/net/ipv6/netfilter/nft_redir_ipv6.c
+++ b/net/ipv6/netfilter/nft_redir_ipv6.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -71,5 +71,5 @@ module_init(nft_redir_ipv6_module_init);
 module_exit(nft_redir_ipv6_module_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
 MODULE_ALIAS_NFT_AF_EXPR(AF_INET6, "redir");
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 81b5ad6..bf92de0 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -105,4 +105,4 @@ int nft_masq_dump(struct sk_buff *skb, const struct nft_expr *expr)
 EXPORT_SYMBOL_GPL(nft_masq_dump);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index 03f7bf4..967e09b 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * Copyright (c) 2014 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -108,4 +108,4 @@ int nft_redir_dump(struct sk_buff *skb, const struct nft_expr *expr)
 EXPORT_SYMBOL_GPL(nft_redir_dump);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>");
+MODULE_AUTHOR("Arturo Borrero Gonzalez <arturo@debian.org>");

