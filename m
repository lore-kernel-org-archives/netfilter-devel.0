From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 15:50:16 +0100
Message-ID: <20160302145016.GF4348@breakpoint.cc>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52397 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390AbcCBOuU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 09:50:20 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Wednesday 2016-03-02 13:10, Florian Westphal wrote:
> >>         case XT_STATISTIC_MODE_RANDOM:
> >>                 if ((prandom_u32() & 0x7FFFFFFF) < info->u.random.=
probability)
> >>=20
> >> --probability seems to check for "less than" the random value.
> >
> >Yes. [...]=20
> >Other suggestions?
>=20
> "--probability" is meant to represent saying "with a probability
> of=A0p=3D10%, ...". This does not mandate any particular operator.

Right, that was my reasoning for making meta random 0.1 behave
like 'match with a probabiliy of 10%'.

> Furthermore, it surprises me that iptables even supports
> !=A0--probability, because you can just express it as 1-p
> instead.

Yes.

So my suggestion is this:

for nft v2 of meta random support:

- keep the 'implicit LE op' behaviour so that
meta random 0.1 means '10% probability of matching'.
- change display to hide the LE detail from the user, i.e.
don't show 'meta random le 0.1' but 'meta random 0.1'.
[ I agree with Jan, its detail, users can still see this
with debug output on ].

Don't change anything else, i.e.

meta random =3D=3D 0.1 will match with a probability of 1 in 0xfffffff
on average.  It does what you asked it to do ;)

=46or the translation patch, if ! is given, translate it to the inverse
as per Jans instruction, e.g.

--probability ! 0.1 is translated to

meta random 0.9

If there are no further comments, I will send a v2 for nft meta random
side soon.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
