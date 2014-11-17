From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [PATCH RFC 0/1] bridge: fix netfilter/NF_BR_LOCAL_OUT for own,
 locally generated queries
Date: Mon, 17 Nov 2014 12:20:27 +0100
Message-ID: <1416223228-8411-1-git-send-email-linus.luessing@c0d3.blue>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.passe0815.de ([188.40.49.9]:59204 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaKQL3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:29:45 -0500
Received: from mail.passe0815.de (localhost [127.0.0.1])
	by mail.passe0815.de (Postfix) with ESMTP id B953A585FEF
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2014 12:20:41 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi there,

would someone from the netfilter side mind double checking this small
patch?

Cheers, Linus

-> http://patchwork.ozlabs.org/patch/391763/ :


On Mon, Nov 17, 2014 at 01:12:44AM -0500, David Miller wrote:
> From: Linus L=EF=BF=BDssing <linus.luessing@c0d3.blue>
> Date: Mon, 17 Nov 2014 03:08:16 +0100
>=20
> > On Mon, Nov 03, 2014 at 06:01:46AM +0800, Herbert Xu wrote:
> >> On Mon, Sep 22, 2014 at 01:32:44AM +0200, Linus L=EF=BF=BDssing wr=
ote:
> >> > Signed-off-by: Linus L=EF=BF=BDssing <linus.luessing@web.de>
> >>=20
> >> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> >=20
> > Hi David,
> >=20
> > are there any unanswered questions left?
>=20
> I expect to get this from the netfilter folks, since it is a
> netfilter change.  So you should submit it to the netfilter
> maintainers.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
