From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf] netfilter: ctnetlink: make it safer when updating ct->status
Date: Thu, 13 Apr 2017 11:22:51 +0800
Message-ID: <000201d2b405$3c071920$b4154b60$@foxmail.com>
References: <1492012596-60889-1-git-send-email-zlpnobody@163.com> <000001d2b3ff$9777d110$c6677330$@foxmail.com> <CAML_gOeLBvnCYrYH7JzaJKg+UJ-hm+ctKGvJRnJkfsN8EEswhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "'Liping Zhang'" <zlpnobody@163.com>,
        "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        "'Netfilter Developer Mailing List'"
        <netfilter-devel@vger.kernel.org>, <cernekee@chromium.org>
To: "'Liping Zhang'" <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgsg2.qq.com ([54.254.200.128]:40675 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755528AbdDMDW4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 23:22:56 -0400
In-Reply-To: <CAML_gOeLBvnCYrYH7JzaJKg+UJ-hm+ctKGvJRnJkfsN8EEswhg@mail.gmail.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Liping,

> -----Original Message-----
> From: Liping Zhang [mailto:zlpnobody@gmail.com]
> Sent: Thursday, April 13, 2017 11:15 AM
> To: Gao Feng <gfree.wind@foxmail.com>
> Cc: Liping Zhang <zlpnobody@163.com>; Pablo Neira Ayuso
> <pablo@netfilter.org>; Netfilter Developer Mailing List
> <netfilter-devel@vger.kernel.org>; cernekee@chromium.org
> Subject: Re: [PATCH nf] netfilter: ctnetlink: make it safer when =
updating
> ct->status
>=20
> Hi Feng,
>=20
> 2017-04-13 10:42 GMT+08:00 Gao Feng <gfree.wind@foxmail.com>:
> [...]
> >> +static void
> >> +__ctnetlink_change_status(struct nf_conn *ct, unsigned long on,
> >> +                       unsigned long off) {
> >> +     unsigned long mask;
> >> +     unsigned int bit;
> >> +
> >> +     for (bit =3D 0; bit < __IPS_MAX_BIT; bit++) {
> >> +             mask =3D 1 << bit;
> >> +             /* Ignore these unchangable bits */
> >> +             if (mask & IPS_UNCHANGEABLE_MASK)
> >> +                     continue;
> >
> > How about clear the bits of on and off with IPS_UNCHANGEABLE_MASK
> > before loop.
> > Like "on &=3D ~ IPS_UNCHANGEABLE_MASK";
> > Then the "if (mask & IPS_UNCHANGEABLE_MASK)" could be removed.
>=20
> No, it's better to do this together, there are two invocations, it's =
not good to
> copy these codes twice.

You mean " on &=3D ~ IPS_UNCHANGEABLE_MASK " and " off &=3D ~ =
IPS_UNCHANGEABLE_MASK " seems duplicated?

>=20
> >
> > BTW, when some bits are set both of on and off, the "on" would be
> > effective, but "off" not.
>=20
> This won't happen, see the invocation:
> 1. __ctnetlink_change_status(ct, status, 0); 2. =
__ctnetlink_change_status(ct,
> status, ~status);
>=20
> > So I think we could use BUILD_BUG_ON to avoid it during building.
> > BUILD_BUG_ON(on&mask);
>=20
> Btw, this won't help, BUILD_BUG_ON is only effective on compile time, =
but
> "on" and "off" will be modified at the running time.
You are right.
This new function would be used frequently at running time.

Regards
Feng



