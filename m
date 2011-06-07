From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
Date: Tue, 07 Jun 2011 13:55:00 +0900
Message-ID: <1307422500.6576.57.camel@nexus.oss.ntt.co.jp>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
	 <1307320871-31770-2-git-send-email-pablo@netfilter.org>
	 <BANLkTikAs7fN2JQJTUwQHAYPPGMf8i9uEA@mail.gmail.com>
	 <1307411912.6576.8.camel@nexus.oss.ntt.co.jp>
	 <BANLkTikaTp3NAhy307vkH_pUVSgoFuvgVQ@mail.gmail.com>
	 <1307422292.6576.54.camel@nexus.oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, stable@kernel.org,
	netfilter-devel@vger.kernel.org
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57418 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1FGEzB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 00:55:01 -0400
In-Reply-To: <1307422292.6576.54.camel@nexus.oss.ntt.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2011-06-07 at 13:51 +0900, Fernando Luis V=C3=A1zquez Cao wrote=
:
> On Mon, 2011-06-06 at 21:15 -0700, Maciej =C5=BBenczykowski wrote:
> > I'm still opposed on the grounds that there may be people relying o=
n
> > the current behaviour.
>=20
> That is not my call, but I can tell you that I wrote this patch in
> response to a report from several carriers that were complaining that
> Linux' mangling code was completely broken and unusable.
>=20
> From my experience, we are in a situation where people used to IPv4's
> mangling code are starting to migrate to IPv6 only to find out that s=
ome
> of their iptables rules do not work as expected, the reason (unknown =
to
> them) being that IPv6's DSCP mangling code was not implemented accord=
ing
> to the documentation.
>=20
> I would think that the benefit of fixing this outweighs the risk of
> breaking some systems relying on the current behavior, which is the
> opposite of what the documentation says and what its IPv4 counterpart
> does.

As an aside, we could even add a note to the relevant man page saying
that the IPv6 DSCP mangle code used to be broken but not anymore (it ha=
s
been done before).

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
