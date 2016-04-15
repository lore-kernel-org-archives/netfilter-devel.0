From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] rule: fix leaks in NFTNL_RULE_USERDATA
Date: Fri, 15 Apr 2016 12:35:05 +0200
Message-ID: <1460716505-10394-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: carlosfg@riseup.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcDOKfP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 06:35:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2E6EAED061
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:35:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 203559D0FB
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:35:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 063A09D105
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:35:09 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46ix leaks in nftnl_rule_free() and nftnl_rule_set_data().

Reported-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 3a32bf6..9c09127 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -75,6 +75,8 @@ void nftnl_rule_free(struct nftnl_rule *r)
 		xfree(r->table);
 	if (r->chain !=3D NULL)
 		xfree(r->chain);
+	if (r->user.data !=3D NULL)
+		xfree(r->user.data);
=20
 	xfree(r);
 }
@@ -162,6 +164,9 @@ void nftnl_rule_set_data(struct nftnl_rule *r, uint=
16_t attr,
 		r->position =3D *((uint64_t *)data);
 		break;
 	case NFTNL_RULE_USERDATA:
+		if (r->user.data !=3D NULL)
+			xfree(r->user.data);
+
 		r->user.data =3D (void *)data;
 		r->user.len =3D data_len;
 		break;
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
