From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: nfulnl_test doesn't work on Ubuntu
Date: Thu, 23 Feb 2012 08:58:18 +0100
Message-ID: <1329983898.15610.11.camel@edumazet-laptop>
References: <CAHS57vUULJmJZuaR3-e2Lzx24Jj-gkg2t5qu_oa9vVdwfjOv-w@mail.gmail.com>
	 <1329981861.15610.10.camel@edumazet-laptop>
	 <CAHS57vVYyO+yES9CSk8Fbmdwc-S8g_p9QCT=kkOK2A-RmwzFJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Ganesh Kumar <gkumarnm@gmail.com>
To: Ganesh Kumar <ganeshkumarnm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39989 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2BWH6Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:58:25 -0500
Received: by werb13 with SMTP id b13so542256wer.19
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2012 23:58:24 -0800 (PST)
In-Reply-To: <CAHS57vVYyO+yES9CSk8Fbmdwc-S8g_p9QCT=kkOK2A-RmwzFJg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 23 f=C3=A9vrier 2012 =C3=A0 13:05 +0530, Ganesh Kumar a =C3=A9=
crit :
> Hi Eric,
>=20
>    Thanks for a fast reply.
> I tried modprobe nfnetlink_log
>=20
> this is what I get in dmesg
>=20
> [2054919.049919] Netfilter messages via NETLINK v0.30.
>=20
> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
> ./nfulnl_test
> binding nfnetlink_log to AF_INET
> error during nflog_bind_pf()
> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
>=20
> These are the contents of
> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
> ls /usr/local/lib/
> libnetfilter_log.a                   libnetfilter_log_libipulog.so.1
>    libnfnetlink.a                       pkgconfig/
> libnetfilter_log.la
> libnetfilter_log_libipulog.so.1.0.0  libnfnetlink.la
>    python2.6/
> libnetfilter_log_libipulog.a         libnetfilter_log.so
>    libnfnetlink.so
> libnetfilter_log_libipulog.la        libnetfilter_log.so.1
>    libnfnetlink.so.0
> libnetfilter_log_libipulog.so        libnetfilter_log.so.1.1.0
>    libnfnetlink.so.0.2.0
> gakumar@krishna-desktop:~/PacketFilter/libnetfilter_log-1.0.0/utils$
>=20
> Hope its installed properly.
> anything else I need to fix/check
>=20

You have to be root=20

sudo ./nfulnl_test



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
