From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 libnftnl] Fix leak in nftnl_*_unset()
Date: Fri, 10 Jun 2016 12:20:53 +0200
Message-ID: <1465554054-16283-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:39689 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbcFJKVD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 06:21:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/rule.c     | 1 +
 src/set_elem.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 1e1a138..4c22436 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -112,6 +112,7 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_=
t attr)
 	case NFTNL_RULE_POSITION:
 	case NFTNL_RULE_FAMILY:
 	case NFTNL_RULE_USERDATA:
+		xfree(r->user.data);
 		break;
 	}
=20
diff --git a/src/set_elem.c b/src/set_elem.c
index da30b02..e585d84 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -82,6 +82,7 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, u=
int16_t attr)
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
 	case NFTNL_SET_ELEM_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
+		xfree(s->user.data);
 		break;
 	case NFTNL_SET_ELEM_EXPR:
 		if (s->flags & (1 << NFTNL_SET_ELEM_EXPR)) {
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
