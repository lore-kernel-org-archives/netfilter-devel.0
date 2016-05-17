From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2] nftables: Fix memory leak linearizing user data
Date: Tue, 17 May 2016 18:00:16 +0200
Message-ID: <1463500816-26155-3-git-send-email-carlosfg@riseup.net>
References: <1463500816-26155-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:38875 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbcEQQAq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 12:00:46 -0400
In-Reply-To: <1463500816-26155-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftnl_rule_set_data makes a copy of the user data which receives, it is=
 not
necessary make a copy before call it.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/netlink_linearize.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 62bb25c..98c22d8 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1127,8 +1127,6 @@ void netlink_linearize_rule(struct netlink_ctx *c=
tx, struct nftnl_rule *nlr,
=20
 	if (rule->comment) {
 		struct nftnl_udata_buf *udata;
-		uint32_t udlen;
-		void *ud;
=20
 		udata =3D nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udata)
@@ -1137,12 +1135,9 @@ void netlink_linearize_rule(struct netlink_ctx *=
ctx, struct nftnl_rule *nlr,
 		if (!nftnl_udata_put_strz(udata, UDATA_TYPE_COMMENT,
 					  rule->comment))
 			memory_allocation_error();
-
-		udlen =3D nftnl_udata_buf_len(udata);
-		ud =3D xmalloc(udlen);
-		memcpy(ud, nftnl_udata_buf_data(udata), udlen);
-
-		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA, ud, udlen);
+		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
+				    nftnl_udata_buf_data(udata),
+				    nftnl_udata_buf_len(udata));
=20
 		nftnl_udata_buf_free(udata);
 	}
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
