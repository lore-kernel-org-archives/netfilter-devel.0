From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: nfulnl_test doesn't work on Ubuntu
Date: Thu, 23 Feb 2012 08:24:21 +0100
Message-ID: <1329981861.15610.10.camel@edumazet-laptop>
References: <CAHS57vUULJmJZuaR3-e2Lzx24Jj-gkg2t5qu_oa9vVdwfjOv-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Ganesh Kumar <gkumarnm@gmail.com>
To: Ganesh Kumar <ganeshkumarnm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62777 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2BWHY3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:24:29 -0500
Received: by werb13 with SMTP id b13so527694wer.19
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2012 23:24:27 -0800 (PST)
In-Reply-To: <CAHS57vUULJmJZuaR3-e2Lzx24Jj-gkg2t5qu_oa9vVdwfjOv-w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 23 f=C3=A9vrier 2012 =C3=A0 12:00 +0530, Ganesh Kumar a =C3=A9=
crit :
> dear all,
>=20
>  I'm trying my hand on the NFLOG target of iptables, so I setup
> the below ones on my ubuntu machine 10.4  :
>=20
>=20
> libnetfilter_log-1.0.0
> libnfnetlink-dev_1.0.0
>=20
>=20
> $ uname -a
> Linux ubuntu 2.6.32.21 #2 SMP Wed Jul 6 22:03:07 PDT 2011 i686 GNU/Li=
nux
>=20
>=20
> but when I try to build and run the utils nfulnl_test.c this is what
> I'm getting using the below command
> gcc -o nfulnl_test nfulnl_test.c -L /usr/local/lib/ -lnetfilter_log
>=20
> $ ./nfulnl_test
> binding nfnetlink_log to AF_INET
> error during nflog_bind_pf()
>=20
> Am I missing something, any help is appreciated.
>=20
> Many thanks,
> GK

It works well on ubuntu 11.10 & 11.04, not sure for 10.04

Could you check if you can load nfnetlink_log module ?

modprobe nfnetlink_log



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
