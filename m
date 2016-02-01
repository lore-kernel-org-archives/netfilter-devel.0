From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH conntrack 1/5] conntrack: support delete by label
Date: Mon, 1 Feb 2016 12:20:47 +0100
Message-ID: <20160201112047.GB540@breakpoint.cc>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
 <20160201110222.GE8095@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-15?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33467 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753583AbcBALUy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 06:20:54 -0500
Content-Disposition: inline
In-Reply-To: <20160201110222.GE8095@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 25, 2016 at 11:15:44AM +0000, Asbj=F8rn Sloth T=F8nnesen =
wrote:
> > This option was already silently allowed by 991fc4ae,
> > but didn't have any effect.
> >=20
> > This patch adds the check and documents it.
>=20
> Applied, thanks.
>=20
> > Cc: Clemence Faure <clemence.faure@sophos.com>
> > Signed-off-by: Asbj=F8rn Sloth T=F8nnesen <ast@fiberby.dk>
> > ---
> >=20
> > Notes:
> >     I tried to create a test case, as well but I didn't
> >     seam to be able to get --label-add to work with
> >     create.

It only works if a -m connlabel rule exists on the system at the moment=
=2E

https://patchwork.ozlabs.org/patch/553363/

extends it to nftables.

> Cc'ing Florian. I think it would be good to have a test for this labe=
l
> support for conntrack.

Right.  We could just add

nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);

When attempting to add a label via ctnetlink and label support
isn't active.

However, unlike the nft/xtables path this would be one-way:

When you have a ruleset that uses -m connlabel, then flush/delete the
ruleset the extension will not be added to new conntracks anymore
since ->destroy() hook invocation will _put the connlabel extension
usage count.

=46or ctnetlink there is no such thing unfortunately (unless we'd add
refcnts to the individual conntracks but thats something I don't want
to do since it seems ridiculously expensive with no real gain).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
