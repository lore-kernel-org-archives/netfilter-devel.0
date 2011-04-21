From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patches: don't call modprobe, ipv4/ipv6 flag support, xtables-multi
 unification.
Date: Thu, 21 Apr 2011 11:16:25 +0200
Message-ID: <4DAFF5E9.7020208@trash.net>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com> <BANLkTimsGzmOnXR1otTvnKBYAS7m=91+uA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42376 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1DUJQb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:16:31 -0400
In-Reply-To: <BANLkTimsGzmOnXR1otTvnKBYAS7m=91+uA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20.04.2011 03:44, Maciej =C5=BBenczykowski wrote:
> Here's version 2.
>=20
> Since the first patch was already applied, and the last isn't wanted,
> we're down to 3 patches.
>=20
> The following changes are available in the git repository at:
>   git://github.com/zenczykowski/iptables.git for-upstream
>=20
> The first patch is standalone, the third builds on the second.
> Only the first patch was changed, and then only by adding
> 'enter,tab,tab,tab,tab' in two spots to fixup formatting.
>=20
> Maciej Zenczykowski (5):
>   Add --ipv4/-4 and --ipv6/-6 support to ip6?tables{,-restore}.
>   Move common parts of libext{4,6}.a into libext.a
>   combine ip6?tables-multi into xtables-multi

Pulled, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
