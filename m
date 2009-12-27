From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Bypass rules using conntrack helpers
Date: Sun, 27 Dec 2009 13:16:59 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912271303490.6911@obet.zrqbmnf.qr>
References: <faefb3f10912270011l48b955cejbbafc3f8a6e55c97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?0KDQvtC80LDQvSDQptC40YHRi9C6?= <roman@tsisyk.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40430 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbZL0MRE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Dec 2009 07:17:04 -0500
In-Reply-To: <faefb3f10912270011l48b955cejbbafc3f8a6e55c97@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-12-27 09:11, =D0=A0=D0=BE=D0=BC=D0=B0=D0=BD =D0=A6=D0=B8=
=D1=81=D1=8B=D0=BA wrote:
>
>=D0=90 questionable point exists in the conntrack expectations design.=
 What
>happens if somebody opened fake outgoing connection which would match
>conntrack helpers' signatures? Conntrack module will be able to add
>records in expectation table.
>Unfortunately, all users from 192.168.0.0/24 will have problems with
>an active FTP. Users will force administrators to read boring manuals
>as alredy founded and load nf_connrack_ftp + nf_nat_ftp to "overcome"
>the problem.
>Next, if malicious software would initiate connection as in the
>previous case, NAT subsystem will forward (y << 8 | z) port to outside
>by changing source PORT command and, in fact, forwarding a port
>inside. So, if we something would open connections to remote 21 port
>and send our PORT commands, we can transparently open ANY port from
>INTERNAL server to the public Internet, regardless NAT. Hereinafter,
>I'll call this "conntrack back-connection issue".

That is what helpers are supposed to do. If that poses a security risk,
to your network, I advise not to use them. In case of FTP that is easil=
y
worked around by using passive ftp.

=46urthermore, the problems NAT brings with itself (ETE connectivity is
just one) are well-known. Getting your own IPv6 tunnel is a
no-brainer these days.

>Furthermore, various ways to inititate connections from client exists.
>It can be malicious software, that needs only user permisions to open
>connection outgoing connection, or user himself, or ... surprise, just
>a web-browser.

That is why, as far as I gather, security standards advise to use
proxies for the connections from the internal network to the
Internet.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
