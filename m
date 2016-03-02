From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 15:59:26 +0100
Message-ID: <20160302145926.GG4348@breakpoint.cc>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr>
 <20160302145016.GF4348@breakpoint.cc>
 <alpine.LSU.2.20.1603021551230.17720@nerf40.vanv.qr>
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
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52426 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085AbcCBO72 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 09:59:28 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1603021551230.17720@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
>=20
> On Wednesday 2016-03-02 15:50, Florian Westphal wrote:
> >>=20
> >> "--probability" is meant to represent saying "with a probability
> >> of=A0p=3D10%, ...". This does not mandate any particular operator.
> >
> >So my suggestion is this:
> >
> >for nft v2 of meta random support:
> >
> >- keep the 'implicit LE op' behaviour so that
> >meta random 0.1 means '10% probability of matching'.
> >- change display to hide the LE detail from the user, i.e.
> >don't show 'meta random le 0.1' but 'meta random 0.1'.
> >[ I agree with Jan, its detail, users can still see this
> >with debug output on ].
>=20
> What I implied is that the operator ought to completely disappear,
> also from the netlink exchange. Let the random module take
> just p at the user-kernel boundary, like xt_statistic.c did.

This is what I want to avoid.

Right now meta random is 6 lines of kernel code;
It just fills a 32bit register with prandom_u32 result.
Everything else can be modeled with the nf_tables engine.

And I think thats the right approach, adding an nft_random
expression seems overkill.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
