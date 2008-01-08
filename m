From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [NETFILTER]: Use const in struct xt_match, xt_target, xt_table
Date: Tue, 8 Jan 2008 13:42:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801081325380.3032@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40183 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYAHMmu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 07:42:50 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

origin git://computergmbh.de/linux netfilter
commit 911b3c3680fd17409c64a6589cfcaf18e4fa04ce
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Tue Jan 8 13:25:08 2008 +0100

    [NETFILTER]: Use const in struct xt_match, xt_target, xt_table
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b99ede5..90dc6ea 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -214,7 +214,7 @@ struct xt_match
 	/* Free to use by each match */
 	unsigned long data;
 
-	char *table;
+	const char *table;
 	unsigned int matchsize;
 	unsigned int compatsize;
 	unsigned int hooks;
@@ -261,7 +261,7 @@ struct xt_target
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
-	char *table;
+	const char *table;
 	unsigned int targetsize;
 	unsigned int compatsize;
 	unsigned int hooks;
@@ -277,7 +277,7 @@ struct xt_table
 	struct list_head list;
 
 	/* A unique name... */
-	char name[XT_TABLE_MAXNAMELEN];
+	const char name[XT_TABLE_MAXNAMELEN];
 
 	/* What hooks you will enter on */
 	unsigned int valid_hooks;

