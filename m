From: =?Big5?Q?=C2=C5=AE=BC=DE=B3?= <lantw44@gmail.com>
Subject: Re: [PATCH 2/3] extra: fix wrong implementation in
 nfq_udp_get_payload
Date: Tue, 01 Jul 2014 01:00:25 +0800
Message-ID: <1404147625.31928.0.camel@wn.lant.com.tw>
References: <1403260021-8732-1-git-send-email-lantw44@gmail.com>
	 <1403260021-8732-2-git-send-email-lantw44@gmail.com>
	 <20140630100229.GB5038@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49398 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaF3RAb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:00:31 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so8923792pab.18
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2014 10:00:30 -0700 (PDT)
In-Reply-To: <20140630100229.GB5038@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E6=96=BC =E4=B8=80=EF=BC=8C2014-06-30 =E6=96=BC 12:02 +0200=EF=BC=8CPa=
blo Neira Ayuso =E6=8F=90=E5=88=B0=EF=BC=9A
> On Fri, Jun 20, 2014 at 06:27:00PM +0800, lantw44@gmail.com wrote:
> > From: Ting-Wei Lan <lantw44@gmail.com>
> >=20
> > ---
> >  src/extra/udp.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/src/extra/udp.c b/src/extra/udp.c
> > index eee732e..2a17a2f 100644
> > --- a/src/extra/udp.c
> > +++ b/src/extra/udp.c
> > @@ -56,13 +56,17 @@ EXPORT_SYMBOL(nfq_udp_get_hdr);
> >   */
> >  void *nfq_udp_get_payload(struct udphdr *udph, struct pkt_buff *pk=
tb)
> >  {
> > -	unsigned int doff =3D udph->len;
> > +	uint16_t len =3D ntohs (udph->len);
>                             ^
>=20
> removed this space.
>=20
> Applied, thanks.

but I cannot find this patch in libnetfilter_queue git log ...


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
