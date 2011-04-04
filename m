From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 04/17] Delay (statically built) match/target initialization
Date: Mon, 04 Apr 2011 15:32:17 +0200
Message-ID: <4D99C861.1090406@trash.net>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com> <1301632053-3694-4-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52364 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1DDNcY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:32:24 -0400
In-Reply-To: <1301632053-3694-4-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.04.2011 06:27, Maciej =C5=BBenczykowski wrote:
> Matches and targets built into the iptables static binary will always
> be registered as the binary starts up, this may potentially (as a res=
ult
> of kernel version support checking) result in modules being autoloade=
d.
>=20
> This is undesirable (for example it may cause CONNMARK target to load
> and thus cause the kernel to load the conntrack module, which isn't a=
 no-op).
>=20
> Transition to a system where matches and targets are registered into
> a pending list, from whence they get fully registered only when requi=
red.
>=20

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
