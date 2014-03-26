From: Florian Westphal <fw@strlen.de>
Subject: Re: [helper PATCH] Preserve conntrack helper bound through CT rule
Date: Wed, 26 Mar 2014 14:04:45 +0100
Message-ID: <20140326130445.GD21741@breakpoint.cc>
References: <CAF1oqRC4LDjjq2X1EjRSJr0g0oQk45UMZBviLz0mziTwM8WbRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alin =?utf-8?Q?N=C4=83stac?= <alin.nastac@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33601 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbaCZNEr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:04:47 -0400
Content-Disposition: inline
In-Reply-To: <CAF1oqRC4LDjjq2X1EjRSJr0g0oQk45UMZBviLz0mziTwM8WbRQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alin N=C4=83stac <alin.nastac@gmail.com> wrote:
> Hi,
>=20
> I've discovered that MASQUERADE target overwrites the CT --helper set=
tings.
> The setup I used is the following:
>   iptables -t raw -A PREROUTING -i lan -p tcp --dport 2121 -j CT --he=
lper ftp
>   iptables -t nat -A POSTROUTING -o wan -s 192.168.1.0/24 -j MASQUERA=
DE
>=20
> I found out the problem, the helper set in the conntrack template is
> overwritten by MASQUERADE target.
> This patch fixes the issue:
>=20
> diff --git a/net/netfilter/nf_conntrack_core.c
> b/net/netfilter/nf_conntrack_core.c
> index bba14a7..ab7cd3e 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1445,7 +1445,7 @@ void nf_conntrack_alter_reply(struct nf_conn *c=
t,
>         nf_ct_dump_tuple(newreply);
>=20
>         ct->tuplehash[IP_CT_DIR_REPLY].tuple =3D *newreply;
> -       if (ct->master || (help && !hlist_empty(&help->expectations))=
)
> +       if (ct->master || help)

This is confusing.  This forces re-ookup of helper even if
expectations have been setup (i.e., helper is being used).

IOW, this increases __nf_ct_try_assign_helper() call count...

Would you mind letting us know what kernel version is having problems,
and wheter helper autoassignments are enabled?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
