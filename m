From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3 iptables,xlate4] libxtables: fix leak in xt_buf object
Date: Mon,  1 Feb 2016 19:43:34 +0100
Message-ID: <1454352216-18812-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56514 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbcBASnp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 13:43:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8B10461E9E
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C20ADA862
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 61B6DDA808
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:43:39 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Release data area that is allocated by xt_buf_alloc().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 libxtables/xtables.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index fa979f2..21e515d 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2015,6 +2015,7 @@ struct xt_buf *xt_buf_alloc(int size)
 
 void xt_buf_free(struct xt_buf *buf)
 {
+	free(buf->data);
 	free(buf);
 }
 
-- 
2.1.4

