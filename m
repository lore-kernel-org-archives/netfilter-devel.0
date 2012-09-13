From: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Subject: AW: ulogd syslogemu output garbage after kernel update (32 to 64bit)
Date: Thu, 13 Sep 2012 09:42:24 +0200
Message-ID: <9F69795E29C890408AC2DAF646C89BB379DA5476A8@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.ait.ac.at ([62.218.164.132]:59701 "EHLO MX2.ait.ac.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2IMHm2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:42:28 -0400
Received: from pps.filterd (MX2 [127.0.0.1])
	by MX2.ait.ac.at (8.14.5/8.14.5) with SMTP id q8D7gQX8023913
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Sep 2012 09:42:26 +0200
Received: from mail.ait.ac.at (mta2.ait.ac.at [62.218.164.112])
	by MX2.ait.ac.at with ESMTP id 179dg00efx-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Sep 2012 09:42:26 +0200
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Urspr=FCngliche Nachricht-----
> Von: Fiedler Roman
> Gesendet: Montag, 10. September 2012 08:37
> An: netfilter-devel@vger.kernel.org
> Betreff: ulogd syslogemu output garbage after kernel update (32 to 64=
bit)
>=20
> Hello list,
>=20
> In short: Could 32-bit ulogd run on 64-bit kernel without failing?

Has any one an educated guess, if that could work? Are netlink data-str=
uctures machine-arch dependent and hence a 32-bit ulogd cannot process =
a 64-bit netlink message?
=20
> Longer story: One of our machines runs on 32bit linux because 32bit c=
ode is
> smaller. Also the kernel was a 32-bit one. Over the time during opera=
tion, the
> larger amount of data processed increased RAM requirements. All proce=
sses
> stay below 4G but the system itself could use more than 4G RAM, which=
 is not
> possible with the 32-bit kernel used. So the kernel was upgraded  to =
64 bit
> (kernel 3.3.2) WITHOUT upgrading the system to 64 bit.
>=20
> Afterwards everything worked fine except that the ulogd (1.24-3ubuntu=
1)
> messages written to syslogemu were complete garbage, e.g.
>=20
> Jan  1 00:00:00 localhost  0 0 20 0 1 < IN=3D [unprintable bytes]
> R OUT=3D [unprintable bytes]
> MAC=3D50:54:2d:49:4e:46:4f:00:00:00:00:00:00:00:00:00:00:00:00:0e:00:=
5
> 0:56:9c:3c:a6:00:50:56:9c:00:a2:08:00:34:35:37:36:36:31:32:20:34:32:3=
8:
> 37:38:35:39:38:34:30:20:34:32:38:37:38:35:38:31:30:34:20:34:31:35:31:=
3
> 2  SRC=3D32.48.32.48 DST=3D32.49.55.32 LEN=3D13112 TOS=3D10 PREC=3D0x=
20 TTL=3D57
> ID=3D12340 MF FRAG:5940 PROTO=3D53
>=20
> All other iptables tools seem to work correctly, e.g. iptables-save s=
hows
> correct interface names, rules and also the ruleset works as expected=
=2E From
> that I would expect, that the error should reside in the netlink hand=
over of
> captured packets to ulogd or the ulogd handling of those messages.
>=20
> Is it possible to run a 32-bit ulogd on 64-bit system or is there som=
e reason,
> this cannot work? If it won't work, it would be nice if ulogd fails t=
o start with
> some understandable error message.
>=20
> Kind Regards,
> Roman

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
