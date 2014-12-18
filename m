From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 14:14:58 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1412181411130.1745@nerf08.vanv.qr>
References: <alpine.LSU.2.11.1412181353020.1745@nerf08.vanv.qr> <20141218134703.11fc792a@turingmachine> <73fbbc6b959fe59d8cdb140563e15198@mail.higgsboson.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:40685 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaLRNPA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 08:15:00 -0500
In-Reply-To: <73fbbc6b959fe59d8cdb140563e15198@mail.higgsboson.tk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2014-12-18 14:02, J=C3=B6rg Thalheim wrote:
>18. Dezember 2014 13:56 Uhr, "Jan Engelhardt" <jengelh@inai.de> schrie=
b:=20
>> On Thursday 2014-12-18 13:47, J=C3=B6rg Thalheim wrote:
>>> +
>>> +nftables_confdir =3D ${sysconfdir}
>>> +nftables_conf_DATA =3D nftables.conf
>>=20
>> Per systemd and distro directions, upstream-provided files should re=
ally really be located in /usr,
>> not /etc
>> (this location being reserved for machine- and user-specific tweaks)=
=2E
>
>This is what the code does (/usr/lib/systemd/system/nftables.service).=
=20
>In nftables.conf I have added some dummy rules, because the service fi=
le relies on it and=20
>will fails otherwise which is a bad default.

I mean the shipped nftables.conf, it ought to be installed to
/usr(/share/nftables), similar to systemd services.
If and when the user decides to procure his own rules, he will do so vi=
a his
own nftables.conf, then located in /etc and - ideally - overriding the
same-named file in /usr.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
