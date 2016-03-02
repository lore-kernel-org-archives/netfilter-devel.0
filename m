From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 16:17:24 +0100
Message-ID: <20160302151724.GB5844@salvia>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr>
 <20160302145016.GF4348@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53674 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbcCBPR3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 10:17:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E3384E6649
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:17:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D014ADA8F9
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:17:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B6BE2DA38C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:17:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302145016.GF4348@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 03:50:16PM +0100, Florian Westphal wrote:
> Jan Engelhardt <jengelh@inai.de> wrote:
> > On Wednesday 2016-03-02 13:10, Florian Westphal wrote:
> > >>         case XT_STATISTIC_MODE_RANDOM:
> > >>                 if ((prandom_u32() & 0x7FFFFFFF) < info->u.rando=
m.probability)
> > >>=20
> > >> --probability seems to check for "less than" the random value.
> > >
> > >Yes. [...]=20
> > >Other suggestions?
> >=20
> > "--probability" is meant to represent saying "with a probability
> > of=A0p=3D10%, ...". This does not mandate any particular operator.
>=20
> Right, that was my reasoning for making meta random 0.1 behave
> like 'match with a probabiliy of 10%'.
>=20
> > Furthermore, it surprises me that iptables even supports
> > !=A0--probability, because you can just express it as 1-p
> > instead.
>=20
> Yes.
>=20
> So my suggestion is this:
>=20
> for nft v2 of meta random support:
>=20
> - keep the 'implicit LE op' behaviour so that
> meta random 0.1 means '10% probability of matching'.
> - change display to hide the LE detail from the user, i.e.
> don't show 'meta random le 0.1' but 'meta random 0.1'.
> [ I agree with Jan, its detail, users can still see this
> with debug output on ].
>=20
> Don't change anything else, i.e.
>=20
> meta random =3D=3D 0.1 will match with a probability of 1 in 0xffffff=
f
> on average.  It does what you asked it to do ;)
>=20
> For the translation patch, if ! is given, translate it to the inverse
> as per Jans instruction, e.g.
>=20
> --probability ! 0.1 is translated to
>=20
> meta random 0.9
>=20
> If there are no further comments, I will send a v2 for nft meta rando=
m
> side soon.

In all this thread you talk all the time on probability semantics,
however the selector name is 'random'.

Why don't you rename this to 'meta probability' instead?

No changes in the semantics then, just use:

        meta probability 0.1

and when expressing the opposite:

        meta probability 0.9
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
