From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl, v2] fix some error checking in parser functions
Date: Wed, 22 Jun 2016 19:30:05 +0200
Message-ID: <20160622173005.GA4634@salvia>
References: <1466418559-4495-1-git-send-email-carlosfg@riseup.net>
 <20160622172434.GA3755@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41525 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbcFVRaK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:30:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9E5A0E8E90
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DF53EBADB
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 84B336447B
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:30:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160622172434.GA3755@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 07:24:34PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 20, 2016 at 12:29:19PM +0200, Carlos Falgueras Garc=EDa w=
rote:
> > Use a variable 'ret' multiple times without treat the error between=
 can
> > overwrite the previous error value, and may execute code which shou=
ld not.
>=20
> Applied, thanks.

I had to apply this chunk on top. Note that these two don't set 'ret'.

diff --git a/src/set_elem.c b/src/set_elem.c
index 94b50f9..00b7327 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -393,8 +393,10 @@ static int nftnl_set_elems_parse2(struct
nftnl_set *s, const struct nlattr *nest
         }
        if (tb[NFTA_SET_ELEM_EXPR]) {
                e->expr =3D nftnl_expr_parse(tb[NFTA_SET_ELEM_EXPR]);
-               if (e->expr =3D=3D NULL)
+               if (e->expr =3D=3D NULL) {
+                       ret =3D -1;
                        goto out_set_elem;
+               }
                e->flags |=3D (1 << NFTNL_SET_ELEM_EXPR);
        }
        if (tb[NFTA_SET_ELEM_USERDATA]) {
@@ -406,8 +408,10 @@ static int nftnl_set_elems_parse2(struct
nftnl_set *s, const struct nlattr *nest
=20
                e->user.len  =3D
mnl_attr_get_payload_len(tb[NFTA_SET_ELEM_USERDATA]);
                e->user.data =3D malloc(e->user.len);
-               if (e->user.data =3D=3D NULL)
+               if (e->user.data =3D=3D NULL) {
+                       ret =3D -1;
                        goto out_expr;
+               }
                memcpy(e->user.data, udata, e->user.len);
         =20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
