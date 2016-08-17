From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] ct: add missing slash to connlabel path
Date: Wed, 17 Aug 2016 13:13:02 +0200
Message-ID: <1471432383-4318-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42864 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcHQLNR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 07:13:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5B277E8E84
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 13:13:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4C9F7100A60
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 13:13:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 10D3FAD81
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 13:13:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If I configure nftables via:

	./configure --prefix=/usr

the connlabel path breaks due to missing slash, so append this after
DEFAULT_INCLUDE_PATH.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ct.c b/src/ct.c
index f383f29..f6b1dc1 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -29,7 +29,7 @@
 #include <utils.h>
 #include <statement.h>
 
-#define CONNLABEL_CONF	DEFAULT_INCLUDE_PATH "connlabel.conf"
+#define CONNLABEL_CONF	DEFAULT_INCLUDE_PATH "/connlabel.conf"
 
 static const struct symbol_table ct_state_tbl = {
 	.symbols	= {
-- 
2.1.4

