From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH] libnetfilter_conntrack: conntrack/objopt: NO_EFFECT
Date: Fri, 10 Jun 2011 11:12:15 +0200
Message-ID: <1307697135-6693-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1FJJMc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:12:32 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5A9CVWs005799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 05:12:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

static analysis (analysis based only on compiling of sources, not based
on running of binary) of the code revealed the following problem:

conntrack/objopt.c:63: self_assign: Assignment operation
                       "ct->snat.l4max.all = ct->snat.l4max.all"
                       has no effect.
---
 src/conntrack/objopt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/conntrack/objopt.c b/src/conntrack/objopt.c
index 7e6e5e2..6180663 100644
--- a/src/conntrack/objopt.c
+++ b/src/conntrack/objopt.c
@@ -60,7 +60,7 @@ static void setobjopt_undo_dnat(struct nf_conntrack *ct)
 static void setobjopt_undo_spat(struct nf_conntrack *ct)
 {
 	ct->snat.l4min.all = ct->tuple[__DIR_REPL].l4dst.tcp.port;
-	ct->snat.l4max.all = ct->snat.l4max.all;
+	ct->snat.l4max.all = ct->snat.l4min.all;
 	ct->tuple[__DIR_REPL].l4dst.tcp.port =
 			ct->tuple[__DIR_ORIG].l4src.tcp.port;
 	set_bit(ATTR_SNAT_PORT, ct->set);
-- 
1.7.5.2

