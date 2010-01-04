From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bypass rules using conntrack helpers
Date: Mon, 04 Jan 2010 13:50:08 +0100
Message-ID: <4B41E400.20107@trash.net>
References: <faefb3f10912270011l48b955cejbbafc3f8a6e55c97@mail.gmail.com> <alpine.LSU.2.01.0912271303490.6911@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?0KDQvtC80LDQvSDQptC40YHRi9C6?= <roman@tsisyk.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33342 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0ADMuN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:50:13 -0500
In-Reply-To: <alpine.LSU.2.01.0912271303490.6911@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2009-12-27 09:11, =D0=A0=D0=BE=D0=BC=D0=B0=D0=BD =D0=A6=D0=B8=
=D1=81=D1=8B=D0=BA wrote:
>> =D0=90 questionable point exists in the conntrack expectations desig=
n. What
>> happens if somebody opened fake outgoing connection which would matc=
h
>> conntrack helpers' signatures? Conntrack module will be able to add
>> records in expectation table.
>> Unfortunately, all users from 192.168.0.0/24 will have problems with
>> an active FTP. Users will force administrators to read boring manual=
s
>> as alredy founded and load nf_connrack_ftp + nf_nat_ftp to "overcome=
"
>> the problem.
>> Next, if malicious software would initiate connection as in the
>> previous case, NAT subsystem will forward (y << 8 | z) port to outsi=
de
>> by changing source PORT command and, in fact, forwarding a port
>> inside. So, if we something would open connections to remote 21 port
>> and send our PORT commands, we can transparently open ANY port from
>> INTERNAL server to the public Internet, regardless NAT. Hereinafter,
>> I'll call this "conntrack back-connection issue".
>=20
> That is what helpers are supposed to do. If that poses a security ris=
k,
> to your network, I advise not to use them. In case of FTP that is eas=
ily
> worked around by using passive ftp.

It should also be pointed out that helpers don't allow anything,
the rule accepting RELATED packets does. And it can be preceeded
by filtering rules to restrict what the helper is able to do.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
