From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 v2,libnftnl] Fix leak in nftnl_*_unset()
Date: Fri, 10 Jun 2016 14:22:45 +0200
Message-ID: <20160610122246.1621-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:42488 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102AbcFJMWy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 08:22:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/rule.c     | 2 ++
 src/set_elem.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 1e1a138..19e8b95 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -111,7 +111,9 @@ void nftnl_rule_unset(struct nftnl_rule *r, uint16_=
t attr)
 	case NFTNL_RULE_COMPAT_FLAGS:
 	case NFTNL_RULE_POSITION:
 	case NFTNL_RULE_FAMILY:
+		break;
 	case NFTNL_RULE_USERDATA:
+		xfree(r->user.data);
 		break;
 	}
=20
diff --git a/src/set_elem.c b/src/set_elem.c
index da30b02..f40515c 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -81,7 +81,9 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, u=
int16_t attr)
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
+		break;
 	case NFTNL_SET_ELEM_USERDATA:	/* NFTA_SET_ELEM_USERDATA */
+		xfree(s->user.data);
 		break;
 	case NFTNL_SET_ELEM_EXPR:
 		if (s->flags & (1 << NFTNL_SET_ELEM_EXPR)) {
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
