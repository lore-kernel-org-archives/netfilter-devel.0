From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: static build breakage - 1.4.16.2.
Date: Tue, 9 Oct 2012 02:49:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210090247230.22447@nerf07.vanv.qr>
References: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com> <alpine.LNX.2.01.1210090002380.21001@nerf07.vanv.qr> <CAHo-OoxV9YQfXueHrBt1WJjv7MpsEOfkBdwOeEhcJbvGQ+wv7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:52045 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2JIAt3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:49:29 -0400
In-Reply-To: <CAHo-OoxV9YQfXueHrBt1WJjv7MpsEOfkBdwOeEhcJbvGQ+wv7Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-10-09 02:16, Maciej =C5=BBenczykowski wrote:

>> (N.B. You can have both --enable-static and --enable-shared)
>
>Yeah, but I just want a small binary and don't need shared support
>(indeed it's even undesirable).
>
>> This patch seems to do it for me. Ok for you?
>
>Looks like it.
>Care to push and release as .3?
>
>Although perhaps calling it pfx_aliases or pfx_build_alias would be
>better (there doesn't seem to be any actual symlinks are there?)

You should build with --disable-static sometimes. :)


>This also skips the blacklist_modules logic, which I guess in this
>case doesn't matter.

Indeed not.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
