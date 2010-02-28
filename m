From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: linux-next netfilter: xt_recent: Add an entry reaper
Date: Sun, 28 Feb 2010 21:26:04 +0100
Message-ID: <1267388764.9082.85.camel@edumazet-laptop>
References: <20100228033841.265CFF8BB0@sepang.rtg.net>
	 <1267331677.9082.46.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002281146470.9681@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tim Gardner <timg@tpi.com>, kaber@trash.net,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63557 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031970Ab0B1U0L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:26:11 -0500
In-Reply-To: <alpine.LSU.2.01.1002281146470.9681@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le dimanche 28 f=C3=A9vrier 2010 =C3=A0 11:50 +0100, Jan Engelhardt a =C3=
=A9crit :

> Entries do not expire (except "falling off" the LRU when it's full) -
> there is no counter that tells them when they expired.
> "--seconds" is just a match option, not something that defines
> the LRU's properties. And that's actually good, because that allows
> you to write
>=20
> 	-m recent --name foo --seconds 60 -j do that
>=20
> 	-m recent --name foo --seconds 3600 -j do something else
>=20
> If you purged "expired" entries after 60 secs, there would be nothing
> left for the 3600 one to check for.

Thats right of course, thanks for reminding us how it works !


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
