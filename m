From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] mxml: test if the root node name is initialized
 before to compare it.
Date: Wed, 4 Mar 2015 20:20:40 +0100
Message-ID: <20150304192040.GA16716@salvia>
References: <1425326318-22936-1-git-send-email-alvaroneay@gmail.com>
 <20150302233504.GA5166@salvia>
 <54F5BAFE.3070000@gmail.com>
 <20150304190318.GA15705@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758455AbbCDTRB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 14:17:01 -0500
Content-Disposition: inline
In-Reply-To: <20150304190318.GA15705@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 04, 2015 at 08:03:18PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Mar 03, 2015 at 02:45:34PM +0100, =C1lvaro Neira Ayuso wrote:
> > El 03/03/15 a las 00:35, Pablo Neira Ayuso escribi=F3:
> > >On Mon, Mar 02, 2015 at 08:58:38PM +0100, Alvaro Neira Ayuso wrote=
:
> > >>If the root node name is not correctly initialized, we have a cra=
sh.
> > >
> > >Under what circunstances may tree->value.opaque be NULL?
> >=20
> > The function mxmlLoadFile doesn't work correctly. With my patch to
> > import ruleset in json and xml. I have seen that if we use a rulese=
t
> > in json and use the command nft import xml.
>=20
> OK, so this bug can be triggered by malformed input.
>=20
> > The function mxmlLoadFile returns a tree without any information
> > inside.  Therefore, when we try to verify that the name of the firs=
t
> > node is the same of the parameter, we have a crash.
> >=20
> > We have two ways to solve it. Test if the node is NULL and:
> >  1- show an error that the node is not found.
> >  2- show an error that the input is not correctly.
> >=20
> > I have thought that the best is the first. But I can change it.
>=20
> I think we have to make robust checks on the input, if what we get is
> not "sane" then it's not worth going further.
>=20
> So I'd suggest you modify this lines a bit below:
>=20
>         if (tree->value.opaque =3D=3D NULL) {
>                 err->error =3D NFT_PARSE_EBADINPUT;
>                 goto err;
>         }
>=20
> to look like:
>=20
>         if (tree =3D=3D NULL || tree->value.opaque =3D=3D NULL) {
>                 err->error =3D NFT_PARSE_EBADINPUT;
>                 goto err;
>         }
>=20
> > >>---
> > >>  src/mxml.c |    3 ++-
> > >>  1 file changed, 2 insertions(+), 1 deletion(-)
> > >>
> > >>diff --git a/src/mxml.c b/src/mxml.c
> > >>index 0001ba0..b68f86f 100644
> > >>--- a/src/mxml.c
> > >>+++ b/src/mxml.c
> > >>@@ -43,7 +43,8 @@ mxml_node_t *nft_mxml_build_tree(const void *da=
ta, const char *treename,
> > >>  		goto err;
> > >>  	}
> > >>
> > >>-	if (strcmp(tree->value.opaque, treename) =3D=3D 0)
> > >>+	if (tree->value.opaque !=3D NULL &&
> > >>+	    strcmp(tree->value.opaque, treename) =3D=3D 0)
> > >>  		return tree;
> > >>
> > >>  	err->error =3D NFT_PARSE_EMISSINGNODE;

Actually your patch looks correct because you're returning "missing
node" which is triggering the crash, right?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
