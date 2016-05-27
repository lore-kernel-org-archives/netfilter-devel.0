From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2 libnftnl] set_elem: Copy user data memory
Date: Fri, 27 May 2016 16:56:54 +0200
Message-ID: <1464361015-14755-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:53177 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbcE0O5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 May 2016 10:57:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

All attributes are passed by copy, so user data should be copied too.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/set_elem.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index 990be24..b9c7e1e 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -125,8 +125,14 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s, =
uint16_t attr,
 		s->timeout =3D *((uint64_t *)data);
 		break;
 	case NFTNL_SET_ELEM_USERDATA: /* NFTA_SET_ELEM_USERDATA */
-		s->user.data =3D (void *)data;
-		s->user.len  =3D data_len;
+		if (s->user.data !=3D NULL)
+			xfree(s->user.data);
+
+		s->user.data =3D malloc(data_len);
+		if (!s->user.data)
+			return;
+		memcpy(s->user.data, data, data_len);
+		s->user.len =3D data_len;
 		break;
 	default:
 		return;
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
