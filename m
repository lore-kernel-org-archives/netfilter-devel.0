From: =?UTF-8?Q?Nicolas_Ma=C3=AEtre?= <nimai@skynet.be>
Subject: Re: Using RELATED for a level4 protocol (MPTCP)
Date: Wed, 23 May 2012 10:00:56 +0200
Message-ID: <CACd4Q01oZkW6nj5mdmjDjnB5S8nRu6-c5cKz-BXJJinhiDwC0A@mail.gmail.com>
References: <CACd4Q01Hg2TC=_5Kk+MhZUoP9swUJKGFEvQgSbbtcXi=_4BZTQ@mail.gmail.com>
 <alpine.LNX.2.01.1205222335460.18927@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43397 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2EWIBT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 May 2012 04:01:19 -0400
Received: by wibhj8 with SMTP id hj8so4263456wib.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 May 2012 01:01:17 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1205222335460.18927@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 23, 2012 at 12:18 AM, Jan Engelhardt <jengelh@inai.de> wrot=
e:
> SHIM6 seems to already offer multihoming/loadsharing - and does so at
> the IP level, so I really wonder why one would want to use MPTCP when
> that's one up and seems to limit itself to TCP.
>

I somewhat disagree even if I get your point and if that xkcd looks so =
true.
SHIM6 isnt (and probably won't be) ready to be deployed as it requires
IPv6 and, above all, it has no support for middleboxes traversal.
MPTCP is designed from the start with the backward-compatibility in
mind. As it is a TCP option, it shouldn't be interfered with. In the
opposite case, it has some fallback mechanisms that allows it to be
completely transparent to boxes that don't want to support it.
Also, AFAIK, SHIM6 is only for multihoming/redundancy in case of a
link fail not exactly for loadsharing. MPTCP, on the other side, is
supposed to enhance performances when multiple links are available and
I assume that's why some big companies are interested in it,
especially for datacenters.

Anyway, thank you for your interest.

Unfortunately, that's not the subject.
So, is there anyone who could at least confirm that there is no way to
use the RELATED state bit for my concern?

Thank you.

--=20
Nicolas Ma=C3=AEtre
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
