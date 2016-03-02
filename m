From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 15:54:05 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603021551230.17720@nerf40.vanv.qr>
References: <20160301204042.GA15382@sonyv> <20160302114611.GA3008@salvia> <20160302121033.GA4348@breakpoint.cc> <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr> <20160302145016.GF4348@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37966 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbcCBOyM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 09:54:12 -0500
In-Reply-To: <20160302145016.GF4348@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2016-03-02 15:50, Florian Westphal wrote:
>>=20
>> "--probability" is meant to represent saying "with a probability
>> of=C2=A0p=3D10%, ...". This does not mandate any particular operator=
=2E
>
>So my suggestion is this:
>
>for nft v2 of meta random support:
>
>- keep the 'implicit LE op' behaviour so that
>meta random 0.1 means '10% probability of matching'.
>- change display to hide the LE detail from the user, i.e.
>don't show 'meta random le 0.1' but 'meta random 0.1'.
>[ I agree with Jan, its detail, users can still see this
>with debug output on ].

What I implied is that the operator ought to completely disappear,
also from the netlink exchange. Let the random module take
just p at the user-kernel boundary, like xt_statistic.c did.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
