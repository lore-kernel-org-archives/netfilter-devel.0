From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Provide family and protocol to make getaddrinfo happy
Date: Wed, 25 May 2011 14:31:05 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105251423280.22697@frira.zrqbmnf.qr>
References: <1306325786-16849-1-git-send-email-ljaenicke@innominate.com> <1306325786-16849-2-git-send-email-ljaenicke@innominate.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55797 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab1EYMbG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 08:31:06 -0400
In-Reply-To: <1306325786-16849-2-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-05-25 14:16, Lutz Jaenicke wrote:

>getaddrinfo() will fail for numeric port numbers if neither
>the socket type (stream/datagram) nor the protocol is
>provided.
>Since matches on ports only make sense if the protocol is known
>we "just" have to derive the protocol number from the information
>already collected.

Not quite; ports are also possible with -m ipvs and -m conntrack, which=
=20
do not require -p tcp/udp.

If someone speicifies a numeric port to getaddrinfo, I just want the=20
thing encoded in struct sockaddr_XX.sXX_port - it does not need to know=
=20
the particular L4 proto, or the service's text-based name to do that -=20
which is most likely why glibc allows it.

I would like to have an opinion on that from =C2=B5clibc preferably..
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
