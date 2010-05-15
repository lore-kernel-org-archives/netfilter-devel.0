From: krunal patel <krunal.raj@gmail.com>
Subject: Re: ipset socket not closed
Date: Sat, 15 May 2010 12:09:36 +0530
Message-ID: <AANLkTiljvCa7GHjBleIfzAB5JyINVg3H1ivWkE5V8r5z@mail.gmail.com>
References: <AANLkTilw1ljLMNAQtEthe7ErEX8R4jkGH1u9_r-fshFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:45918 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0EOGjh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 May 2010 02:39:37 -0400
Received: by pxi5 with SMTP id 5so1724748pxi.19
        for <netfilter-devel@vger.kernel.org>; Fri, 14 May 2010 23:39:36 -0700 (PDT)
In-Reply-To: <AANLkTilw1ljLMNAQtEthe7ErEX8R4jkGH1u9_r-fshFw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

sorry
--- extensions/libipt_set.h     2010-05-15 12:38:08.000000000 +0530
+++ extensions/libipt_set.h     2010-05-15 12:38:53.000000000 +0530
@@ -41,13 +41,15 @@

 static int get_set_getsockopt(void *data, socklen_t * size)
 {
-       int sockfd =3D -1;
+       int sockfd =3D -1, res =3D -1;
        sockfd =3D socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
        if (sockfd < 0)
                exit_error(OTHER_PROBLEM,
                           "Can't open socket to ipset.\n");
        /* Send! */
-       return getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size);
+       res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size);
+       close(sockfd);
+       return res;
 }

On Fri, May 14, 2010 at 9:53 PM, krunal patel <krunal.raj@gmail.com> wr=
ote:
> Hi,
> I found a bug in=A0libipt_set.h. When iptables communicate with ipset=
,
> socket is created but not closed. I wanted to apply more then 700
> iptables rule in one shot and all are having -m set option. I did
> iptables-restore and found error "Can't open socket to ipset."
> After closing socket I am able to do iptables-restore.
> patch:
>
> --- iptables-1.4.2/extensions/libipt_set.h =A0 =A0 =A02010-05-14
> 18:32:50.000000000 +0530
> +++ iptables-1.4.2/extensions/libipt_set.h =A0 =A0 =A02010-05-14
> 18:44:49.000000000 +0530
> @@ -41,13 +41,14 @@
>
> =A0static int get_set_getsockopt(void *data, socklen_t * size)
> =A0{
> - =A0 =A0 =A0 int sockfd =3D -1;
> + =A0 =A0 =A0 int sockfd =3D -1, res =3D -1;
> =A0=A0 =A0 =A0 =A0sockfd =3D socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
> =A0=A0 =A0 =A0 =A0if (sockfd < 0)
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit_error(OTHER_PROBLEM,
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Can't open so=
cket to ipset.\n");
> =A0=A0 =A0 =A0 =A0/* Send! */
> - =A0 =A0 =A0 return getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size=
);
> + =A0 =A0 =A0 res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, data, siz=
e);
> + =A0 =A0 =A0 return res;
> =A0}
> Regards,
> Krunal
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
