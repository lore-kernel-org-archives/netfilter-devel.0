From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/2] libnfntl: Fix segfault due to invalid free of rule user data
Date: Tue, 17 May 2016 18:00:15 +0200
Message-ID: <1463500816-26155-2-git-send-email-carlosfg@riseup.net>
References: <1463500816-26155-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:38858 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbcEQQAn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 12:00:43 -0400
In-Reply-To: <1463500816-26155-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the user allocates a nftnl_udata_buf and then passes the TLV data to
nftnl_rule_set_data, the pointer stored in rule.user.data is not the be=
gining of
the allocated block. In this situation, if it calls to nftnl_rule_free,=
 it tries
to free this pointer and segfault is thrown.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/rule.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index c299548..3f276f8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -167,7 +167,12 @@ void nftnl_rule_set_data(struct nftnl_rule *r, uin=
t16_t attr,
 		if (r->user.data !=3D NULL)
 			xfree(r->user.data);
=20
-		r->user.data =3D (void *)data;
+		r->user.data =3D malloc(data_len);
+		if (!r->user.data) {
+			perror("libnftnl: " __FILE__ ": nftnl_rule_set_data()");
+			return;
+		}
+		memcpy(r->user.data, data, data_len);
 		r->user.len =3D data_len;
 		break;
 	}
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
