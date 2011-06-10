From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH] libnfnetlink: BAD_SIZEOF
Date: Fri, 10 Jun 2011 11:11:00 +0200
Message-ID: <1307697060-6572-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab1FJJLU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:11:20 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5A9BKeE026684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 05:11:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

static analysis (analysis based only on compiling of sources, not based on running of binary)
of the code revealed the following problem:

libnfnetlink.c:481: Taking the size of pointer parameter "nlh" is suspicious.
libnfnetlink.c:486: Taking the size of pointer parameter "nlh" is suspicious.
---
 src/libnfnetlink.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index 6e7afc6..2f962fc 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -477,12 +477,12 @@ nfnl_parse_hdr(const struct nfnl_handle *nfnlh,
 
 	if (nlh->nlmsg_len == NLMSG_LENGTH(sizeof(struct nfgenmsg))) {
 		if (genmsg)
-			*genmsg = (void *)nlh + sizeof(nlh);
+			*genmsg = (void *)nlh + sizeof(*nlh);
 		return NULL;
 	}
 
 	if (genmsg)
-		*genmsg = (void *)nlh + sizeof(nlh);
+		*genmsg = (void *)nlh + sizeof(*nlh);
 
 	return (void *)nlh + NLMSG_LENGTH(sizeof(struct nfgenmsg));
 }
-- 
1.7.5.2

