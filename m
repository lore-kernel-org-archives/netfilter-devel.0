From: Jan Engelhardt <jengelh@medozas.de>
Subject: IPTV buffering
Date: Thu, 16 Dec 2010 12:18:43 +0100 (CET)
Message-ID: <20101216111843.88E16F0C32AB5@borg.medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44123 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab0LPLSo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:18:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-12-16 10:57, Jesper Dangaard Brouer wrote:

> [...] NetConf 2010, see:
>
> http://vger.kernel.org/netconf2010.html

I just went over a few slide sets, and noticed Dave's Netfilter summary=
=20
about your IPTV talk, enlisting the point

 * Ethernet switches buffer too small

("too small".. "too few"?) Given the recent uproar about bufferbloat in=
=20
routing devices (see LWN coverage about Getty's articles), wanting=20
larger buffers seems to almost contradict what Getty would like.

Though TV is usually delivered via UDP rather than TCP, some of the=20
protocols may too implement some sort of congestion recognition or=20
even avoidance technique=C2=A0=E2=80=94 IIRC realplayer had something t=
hat=20
adapted video quality based upon transfer rate.

Wanting more buffers vs. wanting less buffering seems to be quite=20
contradictory. Jesper, what is your take on this?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
