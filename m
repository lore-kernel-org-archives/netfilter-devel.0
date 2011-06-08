From: Patrick McHardy <kaber@trash.net>
Subject: Re: Installer, option fixes
Date: Wed, 08 Jun 2011 09:35:15 +0200
Message-ID: <4DEF2633.2070808@trash.net>
References: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38658 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1FHHf1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:35:27 -0400
In-Reply-To: <1307478964-2034-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07.06.2011 22:35, Jan Engelhardt wrote:
> Here are a couple of fixes. I have also taken the liberty to move the
> main code into a directory of its own to unclutter the toplevel direc=
tory.
> This does not impact AFAICS.
>=20
> With this in, it would be prudent to produce a 1.4.12.
> =3D=3D=3D
> The following changes since commit a1cd1f2a4a35427c68cd0d1bd2761d5be4=
2b12b1:
>=20
>   doc: fix trivial typo in libipt_SNAT (2011-06-01 02:35:28 +0200)
>=20
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
>=20
> Jan Engelhardt (4):
>       src: move all libiptc pieces into its directory
>       src: move all iptables pieces into a separate directory
>       tests: add some sample rulesets to test save-restore cycle
>       option: fix ignored negation before implicit extension loading
>=20
> Maciej =C5=BBenczykowski (1):
>       xtables-multi: fix absence of xml translator in IPv6-only build=
s
>=20

Pulled, thanks Jan.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
