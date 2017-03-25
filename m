From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf v4 1/1] netfilter: snmp: Fix one possible panic when snmp_trap_helper fail to register
Date: Sat, 25 Mar 2017 18:00:51 +0800
Message-ID: <000301d2a54e$afc437f0$0f4ca7d0$@foxmail.com>
References: <1490408646-26051-1-git-send-email-gfree.wind@foxmail.com> <CAML_gOfz33nvrG0fu1KLeMQbYsVSPP6CdoNLUFUiMh8YG7Hs0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        "'Netfilter Developer Mailing List'"
        <netfilter-devel@vger.kernel.org>
To: "'Liping Zhang'" <zlpnobody@gmail.com>, <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:52240 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdCYKBF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Mar 2017 06:01:05 -0400
In-Reply-To: <CAML_gOfz33nvrG0fu1KLeMQbYsVSPP6CdoNLUFUiMh8YG7Hs0A@mail.gmail.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Liping,

> -----Original Message-----
> From: Liping Zhang [mailto:zlpnobody@gmail.com]
> Sent: Saturday, March 25, 2017 4:17 PM
> To: gfree.wind@foxmail.com
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>; Netfilter Developer =
Mailing List
> <netfilter-devel@vger.kernel.org>; Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf v4 1/1] netfilter: snmp: Fix one possible panic =
when
> snmp_trap_helper fail to register
>=20
> Hi Feng,
>=20
> 2017-03-25 10:24 GMT+08:00  <gfree.wind@foxmail.com>:
> [...]
> > @@ -1293,12 +1283,7 @@ static int __init =
nf_nat_snmp_basic_init(void)
> >         BUG_ON(nf_nat_snmp_hook !=3D NULL);
> >         RCU_INIT_POINTER(nf_nat_snmp_hook, help);
> >
> > -       ret =3D nf_conntrack_helper_register(&snmp_trap_helper);
> > -       if (ret < 0) {
> > -               nf_conntrack_helper_unregister(&snmp_helper);
> > -               return ret;
> > -       }
> > -       return ret;
> > +       return nf_conntrack_helper_register(&snmp_trap_helper);
>=20
> I think you should also remove the "int ret =3D 0;" statement,
>=20
> static int __init nf_nat_snmp_basic_init(void) {
>      int ret =3D 0;  <--- Here
>=20
> Otherwise, GCC will warn "unused variable".

Thanks.
I didn't see the warning during compiling.
I think it should be overlapped because I pull the upstream.
There are other changes.

Next time, I would only touch the changed files and compile.
Thanks again.

Feng





