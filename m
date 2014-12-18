From: "=?utf-8?B?SsO2cmcgVGhhbGhlaW0=?=" <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 13:02:27 +0000
Message-ID: <73fbbc6b959fe59d8cdb140563e15198@mail.higgsboson.tk>
References: <alpine.LSU.2.11.1412181353020.1745@nerf08.vanv.qr>
 <20141218134703.11fc792a@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:36473 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaLRNC3 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:02:29 -0500
In-Reply-To: <alpine.LSU.2.11.1412181353020.1745@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

18. Dezember 2014 13:56 Uhr, "Jan Engelhardt" <jengelh@inai.de> schrieb=
:=20
> On Thursday 2014-12-18 13:47, J=C3=B6rg Thalheim wrote:
>=20
>> +
>> +nftables_confdir =3D ${sysconfdir}
>> +nftables_conf_DATA =3D nftables.conf
>=20
> Per systemd and distro directions, upstream-provided files should rea=
lly really be located in /usr,
> not /etc
> (this location being reserved for machine- and user-specific tweaks).
>=20
> That's why something.service is provided in /usr(/lib/systemd/system/=
) rather
> rather than /etc/systemd/system, for example.

This is what the code does (/usr/lib/systemd/system/nftables.service).=20
In nftables.conf I have added some dummy rules, because the service fil=
e relies on it and=20
will fails otherwise which is a bad default.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
