From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset socket not closed
Date: Tue, 18 May 2010 15:18:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1005181511260.10084@blackhole.kfki.hu>
References: <AANLkTilw1ljLMNAQtEthe7ErEX8R4jkGH1u9_r-fshFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1244943010-1274188682=:10084"
Cc: netfilter-devel@vger.kernel.org
To: krunal patel <krunal.raj@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:38787 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab0ERN1h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 May 2010 09:27:37 -0400
In-Reply-To: <AANLkTilw1ljLMNAQtEthe7ErEX8R4jkGH1u9_r-fshFw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1244943010-1274188682=:10084
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Fri, 14 May 2010, krunal patel wrote:

> I found a bug in=A0libipt_set.h. When iptables communicate with ipset,
> socket is created but not closed. I wanted to apply more then 700
> iptables rule in one shot and all are having -m set option. I did
> iptables-restore and found error "Can't open socket to ipset."
> After closing socket I am able to do iptables-restore.
> patch:
>=20
> --- iptables-1.4.2/extensions/libipt_set.h =A0 =A0 =A02010-05-14
> 18:32:50.000000000 +0530
> +++ iptables-1.4.2/extensions/libipt_set.h =A0 =A0 =A02010-05-14
> 18:44:49.000000000 +0530
> @@ -41,13 +41,14 @@
>=20
> =A0static int get_set_getsockopt(void *data, socklen_t * size)
> =A0{
> - =A0 =A0 =A0 int sockfd =3D -1;
> + =A0 =A0 =A0 int sockfd =3D -1, res =3D -1;
> =A0=A0 =A0 =A0 =A0sockfd =3D socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
> =A0=A0 =A0 =A0 =A0if (sockfd < 0)
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit_error(OTHER_PROBLEM,
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Can't open socket=
 to ipset.\n");
> =A0=A0 =A0 =A0 =A0/* Send! */
> - =A0 =A0 =A0 return getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size);
> + =A0 =A0 =A0 res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size);
> + =A0 =A0 =A0 return res;
> =A0}

This is an old iptables version, the bug had been fixed almost a year=20
ago. Please check the recent version when reporting bugs.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1244943010-1274188682=:10084--
