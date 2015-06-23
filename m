From: Florian Westphal <fw@strlen.de>
Subject: Re: Kernel 4.1.0 broke the TARPIT & DELUGE targets in
 xtables-addons-2.6
Date: Tue, 23 Jun 2015 11:39:47 +0200
Message-ID: <20150623093947.GA2324@breakpoint.cc>
References: <52756b9a-0699-405b-918c-73bcfafe97bb@zeracles.net.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alexander Petrenas <zeracles@zeracles.net.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37060 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932093AbbFWJjt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2015 05:39:49 -0400
Content-Disposition: inline
In-Reply-To: <52756b9a-0699-405b-918c-73bcfafe97bb@zeracles.net.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexander Petrenas <zeracles@zeracles.net.ru> wrote:
> Netfilter changes in the recent 4.1.0 kernel update included removal =
of the BRNF_BRIDGED flag:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D40451fd013878b005ccae767dfebc07dfecf85d9
>=20
> Unfortunately, getting rid of BRNF_BRIDGED flag broke the xtables-add=
ons-2.6 package, which now fails to build TARPIT & DELUGE targets with =
the following errors:
>=20
> xtables-addons-2.6/extensions/xt_TARPIT.c:253:30: error: =E2=80=98BRN=
=46_BRIDGED=E2=80=99 undeclared (first use in this function)
>       nskb->nf_bridge->mask & BRNF_BRIDGED))
>                               ^
>=20
> xtables-addons-2.6/extensions/xt_TARPIT.c:282:2: error: too few argum=
ents to function =E2=80=98NF_HOOK=E2=80=99
>   NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, nskb, NULL,
>   ^

NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, NULL, nskb, NULL,

> xtables-addons-2.6/extensions/xt_TARPIT.c:397:2: error: too few argum=
ents to function =E2=80=98NF_HOOK=E2=80=99
>   NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, nskb, NULL,

same

> My kernel hacking skills are non-existant (as well as my C skills), s=
o I expectedly failed to come up with any patch that would replace BRNF=
_BRIDGED flag with nf_bridge->physoutdev in the following xt_TARPIT.c c=
ode:
>=20
> #ifdef CONFIG_BRIDGE_NETFILTER
> 	if (hook !=3D NF_INET_FORWARD || (nskb->nf_bridge !=3D NULL &&
> 	    nskb->nf_bridge->mask & BRNF_BRIDGED))
> #else

if (hook !=3D NF_INET_FORWARD || (nskb->nf_bridge !=3D NULL &&
    nskb->nf_bridge->physoutdev))
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
