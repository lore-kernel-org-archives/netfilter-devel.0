From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2,libnftnl] Free user data in unsetters
Date: Thu, 2 Jun 2016 12:58:40 +0200
Message-ID: <20160602105840.GC3013@salvia>
References: <1464864024-12108-1-git-send-email-carlosfg@riseup.net>
 <20160602105538.GA3013@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59692 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbcFBK6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 06:58:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2ED884B822F
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:58:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E7E641BDA2D
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:58:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 804321B8F27
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:58:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160602105538.GA3013@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 12:55:38PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 02, 2016 at 12:40:23PM +0200, Carlos Falgueras Garc=EDa w=
rote:
> > Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> > ---
> >  src/rule.c     | 2 ++
> >  src/set_elem.c | 2 ++
> >  2 files changed, 4 insertions(+)
> >=20
> > diff --git a/src/rule.c b/src/rule.c
> > index 8ee8648..3576e32 100644
> > --- a/src/rule.c
> > +++ b/src/rule.c
> > @@ -112,6 +112,8 @@ void nftnl_rule_unset(struct nftnl_rule *r, uin=
t16_t attr)
> >  	case NFTNL_RULE_POSITION:
> >  	case NFTNL_RULE_FAMILY:
> >  	case NFTNL_RULE_USERDATA:
> > +		xfree(r->user.data);
> > +		r->user.len =3D 0;
>=20
> I think we don't need to reset user.len, right?

BTW, I'd suggest you call this: "Fix leak in nftnl_rule_unset()"

I would review other any other existing unsetter to see if we're also
leaking there. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
