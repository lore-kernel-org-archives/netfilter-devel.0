From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: static build breakage - 1.4.16.2.
Date: Tue, 9 Oct 2012 12:04:57 +0200
Message-ID: <20121009100457.GA20804@1984>
References: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com>
 <alpine.LNX.2.01.1210090002380.21001@nerf07.vanv.qr>
 <CAHo-OoxV9YQfXueHrBt1WJjv7MpsEOfkBdwOeEhcJbvGQ+wv7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59978 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab2JIKFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:05:05 -0400
Content-Disposition: inline
In-Reply-To: <CAHo-OoxV9YQfXueHrBt1WJjv7MpsEOfkBdwOeEhcJbvGQ+wv7Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 08, 2012 at 05:16:14PM -0700, Maciej =C5=BBenczykowski wrot=
e:
> > (N.B. You can have both --enable-static and --enable-shared)
>=20
> Yeah, but I just want a small binary and don't need shared support
> (indeed it's even undesirable).
>=20
> > This patch seems to do it for me. Ok for you?
>=20
> Looks like it.

Applied, thanks a lot.

> Care to push and release as .3?

Will do in a couple of days.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
