Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35FFC2D0E4
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 12:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC322080A
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 12:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgKSMW4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 07:22:56 -0500
Received: from smtp-out.kfki.hu ([148.6.0.48]:37277 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgKSMWz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 07:22:55 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id B9997CC0112;
        Thu, 19 Nov 2020 13:22:52 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 19 Nov 2020 13:22:50 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id DEDADCC0108;
        Thu, 19 Nov 2020 13:22:46 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D2467340D5C; Thu, 19 Nov 2020 13:22:46 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id CE0A8340D5B;
        Thu, 19 Nov 2020 13:22:46 +0100 (CET)
Date:   Thu, 19 Nov 2020 13:22:46 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Oskar Berggren <oskar.berggren@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: ipset 7.7 modules fail to build on kernel 4.19.152
In-Reply-To: <CAHOuc7P+vHrPofOg9FHAUMhuDu=ewxgBp2h8TxmveNoZEayfkQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.23.453.2011191320240.19567@blackhole.kfki.hu>
References: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com> <alpine.DEB.2.23.453.2011020953550.16514@localhost> <CAHOuc7Ou_=rXSGCweVtN8QhMx8XaA9DPvBZBPHTe2SS05C0GsQ@mail.gmail.com> <alpine.DEB.2.23.453.2011082203260.26301@blackhole.kfki.hu>
 <CAHOuc7P+vHrPofOg9FHAUMhuDu=ewxgBp2h8TxmveNoZEayfkQ@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-403197974-1605788566=:19567"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-403197974-1605788566=:19567
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Oskar,

On Sun, 8 Nov 2020, Oskar Berggren wrote:

> That took care of the problems in ip_set_core.c, now I got problems wit=
h=20
> jhash.h again. Same problem, but different compile unit, and despite=20
> having the additional include that you suggested.
>=20
> WITHOUT including the compat layer the problem occurs here:
>   CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip=
_set_core.o
> In file included from
> /usr/src/linux-headers-4.19.0-12-common/include/net/inet_sock.h:22,
>                  from
> /usr/src/linux-headers-4.19.0-12-common/include/net/inet_connection_soc=
k.h:24,
>                  from
> /usr/src/linux-headers-4.19.0-12-common/include/linux/tcp.h:24,
>                  from
> /usr/src/linux-headers-4.19.0-12-common/include/linux/ipv6.h:87,
>                  from
> /home/oskar/Downloads/ipset-7.7/kernel/include/linux/netfilter/ipset/ip=
_set.h:11,
>                  from
> /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip_set_core.=
c:23:
> /home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h: In
> function =E2=80=98jhash=E2=80=99:
> /home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h:91:32:
> error: =E2=80=98fallthrough=E2=80=99 undeclared (first use in this func=
tion)
>   case 12: c +=3D (u32)k[11]<<24; fallthrough;
> [...same on line 137...]
>=20
>=20
> WITH the compat layer included (and the fix for
> list_for_each_entry_rcu), the same error appears slightly later:
>   CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip=
_set_core.o
>   CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/ip=
_set_getport.o
>   CC [M]  /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/pf=
xlen.o
> In file included from
> /usr/src/linux-headers-4.19.0-12-common/include/net/inet_sock.h:22,
>                  from
> /usr/src/linux-headers-4.19.0-12-common/include/net/inet_connection_soc=
k.h:24,
>                  from
> /usr/src/linux-headers-4.19.0-12-common/include/linux/tcp.h:24,
>                  from
> /usr/src/linux-headers-4.19.0-12-common/include/net/tcp.h:24,
>                  from
> /home/oskar/Downloads/ipset-7.7/kernel/include/linux/netfilter/ipset/pf=
xlen.h:7,
>                  from
> /home/oskar/Downloads/ipset-7.7/kernel/net/netfilter/ipset/pfxlen.c:4:
> /home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h: In
> function =E2=80=98jhash=E2=80=99:
> /home/oskar/Downloads/ipset-7.7/kernel/include/linux/jhash.h:91:32:
> error: =E2=80=98fallthrough=E2=80=99 undeclared (first use in this func=
tion)
>   case 12: c +=3D (u32)k[11]<<24; fallthrough;
> [...same on line 137...]

Could you post your compiler type and version? I cannot reproduce the=20
issue and even don't get how can it happen. The same compatibility layer=20
is/should be available when compiling pfxlen.c as at compiling=20
ipset_core.c.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-403197974-1605788566=:19567--
