From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipset socket not closed
Date: Fri, 14 May 2010 20:34:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005142034290.13800@obet.zrqbmnf.qr>
References: <AANLkTilw1ljLMNAQtEthe7ErEX8R4jkGH1u9_r-fshFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: krunal patel <krunal.raj@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37636 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab0ENSeh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 14:34:37 -0400
In-Reply-To: <AANLkTilw1ljLMNAQtEthe7ErEX8R4jkGH1u9_r-fshFw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-05-14 18:23, krunal patel wrote:

>Hi,
>I found a bug in=C2=A0libipt_set.h. When iptables communicate with ips=
et,
>socket is created but not closed. I wanted to apply more then 700
>iptables rule in one shot and all are having -m set option. I did
>iptables-restore and found error "Can't open socket to ipset."
>After closing socket I am able to do iptables-restore.
>patch:
>
>--- iptables-1.4.2/extensions/libipt_set.h =C2=A0 =C2=A0 =C2=A02010-05=
-14
>18:32:50.000000000 +0530
>+++ iptables-1.4.2/extensions/libipt_set.h =C2=A0 =C2=A0 =C2=A02010-05=
-14
>18:44:49.000000000 +0530
>@@ -41,13 +41,14 @@
>
>=C2=A0static int get_set_getsockopt(void *data, socklen_t * size)
>=C2=A0{
>- =C2=A0 =C2=A0 =C2=A0 int sockfd =3D -1;
>+ =C2=A0 =C2=A0 =C2=A0 int sockfd =3D -1, res =3D -1;
>=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0sockfd =3D socket(AF_INET, SOCK_RAW, =
IPPROTO_RAW);
>=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sockfd < 0)
>=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exit_erro=
r(OTHER_PROBLEM,
>=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 "Can't open socket to ipset.\n");
>=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Send! */
>- =C2=A0 =C2=A0 =C2=A0 return getsockopt(sockfd, SOL_IP, SO_IP_SET, da=
ta, size);
>+ =C2=A0 =C2=A0 =C2=A0 res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, d=
ata, size);
>+ =C2=A0 =C2=A0 =C2=A0 return res;
>=C2=A0}

I don't see a close...
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
