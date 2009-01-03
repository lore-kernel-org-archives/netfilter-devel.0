From: Eric Leblond <eleblond@inl.fr>
Subject: Re: Bug in Netfiler_queue when using small packets in 100Mb traffic
Date: Sat, 03 Jan 2009 16:31:47 +0100
Message-ID: <1230996707.28326.100.camel@ice-age>
References: <d579762c0901030638k3ddcac6dy8ee175244eaddbe9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: VPF <videopacketfilter@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:37550 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbZACPbw convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:31:52 -0500
In-Reply-To: <d579762c0901030638k3ddcac6dy8ee175244eaddbe9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Le samedi 03 janvier 2009 =E0 15:38 +0100, VPF a =E9crit :
> Hi, I encountered a problem with the example nfqnl_test.c when I sent
> 100Mb/s of <200ko packets. The program stopped running quickly and
> printed "unbinding from queue 0". It appears that the call recv(fd,
> buf, sizeof(buf), 0) returns an error after a few packets. (errno 105
> : No buffer space available).
>=20
> Do you see any solution to this problem?

This problem is well known. This is linked with the size of the
nfnetlink buffer. The buffer is too small to contains the data when
trafic is high. A typical workaround is to increase this size.=20

It can be done by using the nfnl_rcvbufsiz(). The code should looks
like:
 nfnl_rcvbufsiz(nfq_nfnlh(h), SIZE);

This workaround may not be sufficient and in this case a unbinding,
rebinding of the queue is needed.

BR,
--=20
Eric Leblond <eleblond@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
EdenWall: http://www.edenwall.com/

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
