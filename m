From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2,libnftnl] Free user data in unsetters
Date: Thu,  2 Jun 2016 12:40:23 +0200
Message-ID: <1464864024-12108-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:58658 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbcFBKkh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 06:40:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/rule.c     | 2 ++
 src/set_elem.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 8ee8648..3576e32 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -112,6 +112,8 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_=
t attr)
 	case NFTNL_RULE_POSITION:
 	case NFTNL_RULE_FAMILY:
 	case NFTNL_RULE_USERDATA:
+		xfree(r->user.data);
+		r->user.len =3D 0;
 		break;
 	}
=20
diff --git a/src/set_elem.c b/src/set_elem.c
index b9c7e1e..47ad6f4 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -82,6 +82,8 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, u=
int16_t attr)
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
 	case NFTNL_SET_ELEM_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
+		xfree(s->user.data);
+		s->user.len =3D 0;
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
