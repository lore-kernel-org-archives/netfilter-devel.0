From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH 4/5] ipset: remove extran newline on debug output
Date: Mon, 08 Sep 2014 16:30:48 +0200
Message-ID: <20140908143048.16930.51389.stgit@jonathan.eitzenberger.org>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:65186 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaIHObw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:31:52 -0400
In-Reply-To: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
---
 lib/session.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/session.c b/lib/session.c
index d4fe836..8d79a96 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -804,7 +804,7 @@ list_adt(struct ipset_session *session, struct nlattr *nla[])
 		safe_snprintf(session, "</elem>");
 
 	for (arg = type->args[IPSET_ADD]; arg != NULL && arg->opt; arg++) {
-		D("print arg opt %u %s\n", arg->opt,
+		D("print arg opt %u %s", arg->opt,
 		   ipset_data_test(data, arg->opt) ? "(yes)" : "(missing)");
 		if (!(arg->print && ipset_data_test(data, arg->opt)))
 			continue;

