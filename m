From: =?UTF-8?B?VGVycnkgTW/Dq3M=?= <T.Moes@student.ulg.ac.be>
Subject: Re: NAT66 : A first implementation
Date: Thu, 14 Jul 2011 18:27:46 +0200
Message-ID: <4E1F1902.9020605@student.ulg.ac.be>
References: <4E1F0F88.3090704@student.ulg.ac.be> <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:32810 "EHLO
	serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab1GNQ1s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:27:48 -0400
In-Reply-To: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you are willing to compare this implementation, which just add two=20
targets to Xtables, with mine, which involves the Connection Tracking,=20
and is able to deal with icmp error messages, AND implements stateful,=20
n:1 mapping, yes, ok, I've done nothing.

Have you at least taken a look at this work, before saying I've=20
implemented nothing but something already implemented ?

On 14/07/11 18:22, Jan Engelhardt wrote:
> On Thursday 2011-07-14 17:47, Terry Mo=C3=ABs wrote:
>
>> Hi all !
>>
>> Since the Draft of NPT66 (Stateless Mapping) has gone RFC
>> (http://tools.ietf.org/html/rfc6296), it's the good time for me to p=
ublish my
>> master thesis : an implementation, for Netfilter, of NAT in IPv6, wi=
th both
>> Stateless and Stateful approaches.
>>
>> It's published on Sourceforge : https://sourceforge.net/projects/nfn=
at66/
> Hm, how often has this been (re)implemented now... the last one was
> sf.net/projects/map66

--
Terry Mo=C3=ABs (20061420)
Universit=C3=A9 de Li=C3=A8ge - Facult=C3=A9 des Sciences Appliqu=C3=A9=
es
2=C3=A8me ann=C3=A9e Master Ing=C3=A9nieur Civil en Informatique - D=C3=
=A9l=C3=A9gu=C3=A9
Repr=C3=A9sentant Etudiant - Conseil de Facult=C3=A9
=46FSA Administrateur - http://www.ffsa.be
T.Moes@student.ulg.ac.be

--=20

N-HiTec - Nova High Technology Engineering and Consulting

Responsable des Infrastructures - Vice-Pr=C3=A9sident

Web :   http://www.nhitec.com
T=C3=A9l :   04/366.20.01

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
