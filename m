From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: inconsistent address treatment.
Date: Sun, 26 Dec 2010 23:16:18 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012262309540.5681@obet.zrqbmnf.qr>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net> <4D1457D5.3040305@plouf.fr.eu.org> <4D14BD05.8020509@earthlink.net> <alpine.LNX.2.01.1012242242440.30415@obet.zrqbmnf.qr> <4D1730B7.3090805@treenet.co.nz>
 <4D17B6FB.5020807@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	Stephen Clark <sclark46@earthlink.net>,
	netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47230 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab0LZWQU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:16:20 -0500
In-Reply-To: <4D17B6FB.5020807@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-12-26 22:43, Pascal Hambourg wrote:

>Amos Jeffries a =C3=A9crit :
>>=20
>> FWIW: we (Squid project) use the syntax "ip[-ip][/mask]".
>
>I'm being curious : what is the meaning of "ip-ip/mask" when both the
>range and mask are present ?

Sounds like

192.168.0.64-192.168.191/255.255.255.253
<=3D>
192.168.0.{64 65 68 69 72 73 76 77 77...}

Well, it's probably of use... to someone.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
