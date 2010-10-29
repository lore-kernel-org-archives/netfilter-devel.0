From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: nf_nat: make find/put static
Date: Fri, 29 Oct 2010 16:30:37 +0200
Message-ID: <4CCADA8D.3030808@trash.net>
References: <201010231923.o9NJN2oc012438@hera.kernel.org> <AANLkTikuvBb79Q-mKK-u3tL=f433Om4T3NqJUynv=8=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40101 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab0J2Oay (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:30:54 -0400
In-Reply-To: <AANLkTikuvBb79Q-mKK-u3tL=f433Om4T3NqJUynv=8=w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 28.10.2010 20:42, schrieb Geert Uytterhoeven:
> On Sat, Oct 23, 2010 at 21:23, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>>    netfilter: nf_nat: make find/put static
>>
>>    ...
>=20
> They should be moved inside the
> "#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MO=
DULE)",
> as I now get:
>=20
> net/ipv4/netfilter/nf_nat_core.c:52: warning: =E2=80=98nf_nat_proto_f=
ind_get=E2=80=99
> defined but not used
> net/ipv4/netfilter/nf_nat_core.c:66: warning: =E2=80=98nf_nat_proto_p=
ut=E2=80=99
> defined but not used

Thanks, I'll fix this up.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
