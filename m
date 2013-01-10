From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: v3.8-rc3: uninitialized warnings in net/netfilter/xt_CT.c
Date: Thu, 10 Jan 2013 13:16:02 +0100
Message-ID: <20130110121602.GA20429@1984>
References: <20130110111821.GA23008@liondog.tnic>
 <20130110114742.GA17883@1984>
 <20130110120121.GD23008@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Borislav Petkov <bp@alien8.de>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	lkml <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab3AJMQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:16:06 -0500
Content-Disposition: inline
In-Reply-To: <20130110120121.GD23008@liondog.tnic>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 01:01:21PM +0100, Borislav Petkov wrote:
> On Thu, Jan 10, 2013 at 12:47:42PM +0100, Pablo Neira Ayuso wrote:
> > Patch attached to address this issue.
>=20
> > From 3ceaa3b1baa660aaeef63b86ea9771dcab6d0acd Mon Sep 17 00:00:00 2=
001
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date: Thu, 10 Jan 2013 12:42:15 +0100
> > Subject: [PATCH] netfilter: xt_CT: fix unset return value if conntr=
ack zone
> >  are disabled
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >=20
> > net/netfilter/xt_CT.c: In function =E2=80=98xt_ct_tg_check_v1=E2=80=
=99:
> > net/netfilter/xt_CT.c:250:6: warning: =E2=80=98ret=E2=80=99 may be =
used uninitialized in this function [-Wmaybe-uninitialized]
> > net/netfilter/xt_CT.c: In function =E2=80=98xt_ct_tg_check_v0=E2=80=
=99:
> > net/netfilter/xt_CT.c:112:6: warning: =E2=80=98ret=E2=80=99 may be =
used uninitialized in this function [-Wmaybe-uninitialized]
> >=20
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> Yep, that's exactly what I meant, thanks Pablo.
>=20
> Acked-by: Borislav Petkov <bp@alien8.de>

Applied, thanks Borislav.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
