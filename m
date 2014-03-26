From: Florian Westphal <fw@strlen.de>
Subject: Re: [helper PATCH] Preserve conntrack helper bound through CT rule
Date: Wed, 26 Mar 2014 17:57:47 +0100
Message-ID: <20140326165747.GE21741@breakpoint.cc>
References: <CAF1oqRC4LDjjq2X1EjRSJr0g0oQk45UMZBviLz0mziTwM8WbRQ@mail.gmail.com>
 <20140326130445.GD21741@breakpoint.cc>
 <CAF1oqRAg8Xi+JwL_ErzuwF1TFWHCMcV6pGasUfFQ5_RaDNMBOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Alin =?utf-8?Q?N=C4=83stac?= <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34752 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095AbaCZQ5s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:57:48 -0400
Content-Disposition: inline
In-Reply-To: <CAF1oqRAg8Xi+JwL_ErzuwF1TFWHCMcV6pGasUfFQ5_RaDNMBOQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alin N=C4=83stac <alin.nastac@gmail.com> wrote:
> Hi Florian,
>=20
> Quite the contrary, the new code would be
>     if (ct->master || help)
>         return;
> This will relax the if statement condition, which will decrease the
> __nf_ct_try_assing_helper() call count.

Right.

> Anyway, I use a Broadcom patched 3.4.11, but I checked the origin of
> the call, it does not originate from their patches, in comes from
> nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC) call found in
> masquerade_tg().

I guess this was fixed by
commit 6714cf5465d2803a21c6a46c1ea747795a8889fa
'netfilter: nf_conntrack: fix explicit helper attachment and NAT').
in 3.5 kernel.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
