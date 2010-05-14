From: krunal patel <krunal.raj@gmail.com>
Subject: ipset socket not closed
Date: Fri, 14 May 2010 21:53:16 +0530
Message-ID: <AANLkTilw1ljLMNAQtEthe7ErEX8R4jkGH1u9_r-fshFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:40372 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0ENQXQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 12:23:16 -0400
Received: by pzk42 with SMTP id 42so1419721pzk.4
        for <netfilter-devel@vger.kernel.org>; Fri, 14 May 2010 09:23:16 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I found a bug in=A0libipt_set.h. When iptables communicate with ipset,
socket is created but not closed. I wanted to apply more then 700
iptables rule in one shot and all are having -m set option. I did
iptables-restore and found error "Can't open socket to ipset."
After closing socket I am able to do iptables-restore.
patch:

--- iptables-1.4.2/extensions/libipt_set.h =A0 =A0 =A02010-05-14
18:32:50.000000000 +0530
+++ iptables-1.4.2/extensions/libipt_set.h =A0 =A0 =A02010-05-14
18:44:49.000000000 +0530
@@ -41,13 +41,14 @@

=A0static int get_set_getsockopt(void *data, socklen_t * size)
=A0{
- =A0 =A0 =A0 int sockfd =3D -1;
+ =A0 =A0 =A0 int sockfd =3D -1, res =3D -1;
=A0=A0 =A0 =A0 =A0sockfd =3D socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
=A0=A0 =A0 =A0 =A0if (sockfd < 0)
=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit_error(OTHER_PROBLEM,
=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Can't open sock=
et to ipset.\n");
=A0=A0 =A0 =A0 =A0/* Send! */
- =A0 =A0 =A0 return getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size);
+ =A0 =A0 =A0 res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size)=
;
+ =A0 =A0 =A0 return res;
=A0}
Regards,
Krunal
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
