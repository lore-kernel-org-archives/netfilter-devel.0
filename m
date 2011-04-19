From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] add xtables-multi{32,64} recognition
Date: Tue, 19 Apr 2011 09:32:41 +0200
Message-ID: <4DAD3A99.2010608@trash.net>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>	<1303176233-14063-5-git-send-email-zenczykowski@gmail.com>	<4DAD3749.1000208@trash.net> <BANLkTinbg_38zymRyTvpXZ1zcms76G1L1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33280 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1DSHdD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:33:03 -0400
In-Reply-To: <BANLkTinbg_38zymRyTvpXZ1zcms76G1L1w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.04.2011 09:29, Maciej =C5=BBenczykowski wrote:
>> What is the purpose of this?
>=20
> Unfortunately not every 64-bit kernel version has had fully functiona=
l
> 32 bit backwards compatibility with userspace.  As such, it is
> sometimes necessary to ship a 32-bit userspace iptables for 32-bit
> kernels and a 64-bit binary for 64-bit kernels - sometimes in the sam=
e
> OS image.
>=20
> The way I've done this is ship both binaries, one named *32 and one
> *64 and then have a launcher at * launch the appropriate one for the
> running kernel.
>=20
> To be fair, these kernels are pretty old at this point, OTOH, the
> patch is rather trivial and harmless.

Sure, but if you upgrade iptables on those systems, you can simply
replace the wrapper script. I don't think it makes much sense to
put this into the upstream version to handle compatibility for your
specific case.

The other patches look good to me.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
