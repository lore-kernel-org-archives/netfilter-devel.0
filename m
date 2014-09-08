From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH 1/5] Remove a duplicate debug print
Date: Mon, 08 Sep 2014 16:30:33 +0200
Message-ID: <20140908143033.16930.26216.stgit@jonathan.eitzenberger.org>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:52086 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaIHObh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:31:37 -0400
In-Reply-To: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
---
 lib/session.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/session.c b/lib/session.c
index d2957a5..7a719b2 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -1038,8 +1038,7 @@ callback_list(struct ipset_session *session, struct nlattr *nla[],
 		ipset_data_flags_unset(data, IPSET_CREATE_FLAGS);
 		D("nla typename %s",
 		  (char *) mnl_attr_get_payload(nla[IPSET_ATTR_TYPENAME]));
-		D("nla typename %s",
-		  (char *) mnl_attr_get_payload(nla[IPSET_ATTR_TYPENAME]));
+
 		ATTR2DATA(session, nla, IPSET_ATTR_FAMILY, cmd_attrs);
 		ATTR2DATA(session, nla, IPSET_ATTR_TYPENAME, cmd_attrs);
 		ATTR2DATA(session, nla, IPSET_ATTR_REVISION, cmd_attrs);

