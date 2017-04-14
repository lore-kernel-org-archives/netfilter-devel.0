From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf] netfilter: xt_CT: fix cthelper module's refcnt leak
Date: Fri, 14 Apr 2017 08:49:33 +0800
Message-ID: <000101d2b4b8$fc4220a0$f4c661e0$@foxmail.com>
References: <1491622728-55625-1-git-send-email-zlpnobody@163.com> <20170413223056.GA5106@salvia> <CAML_gOe-gAk0fyhRE9e4chqL7=nEOqc5_cWBO0YvqAAKqZXHSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "'Liping Zhang'" <zlpnobody@163.com>,
        "'Netfilter Developer Mailing List'"
        <netfilter-devel@vger.kernel.org>
To: "'Liping Zhang'" <zlpnobody@gmail.com>,
        "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:45502 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753351AbdDNAtj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 20:49:39 -0400
In-Reply-To: <CAML_gOe-gAk0fyhRE9e4chqL7=nEOqc5_cWBO0YvqAAKqZXHSw@mail.gmail.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Liping Zhang [mailto:zlpnobody@gmail.com]
> Hi Pablo,
>=20
> 2017-04-14 6:30 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> >> We should call module_put when the time policy is not found.
> >> Otherwise, the related cthelper module cannot be removed anymore.
> >>
> >> It is easy to reproduce by typing the following command:
> >>   # iptables -t raw -A OUTPUT -p tcp -j CT --helper ftp --timeout =
xxx
> >
> > Can we fix all leaks in the error path in one single patch for =
xt_CT?
>=20
> Right.
>=20
> > Feng sent me a patch to fix another issue there, so if either you or
> > him send me one single patch to fix all xt_CT refcount leaks in one
> > go, I'd appreciate.
>=20
> Feng, since you spotted this issue earlier, can you send a new patch =
to do this?
> With a new patch name: "netfilter: xt_CT: fix refcnt leak on error =
path".

Thanks.

>=20
> Also you can add my:
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>

No problem.

Regards
Feng



