From: Yanchuan Nian <ycnian@gmail.com>
Subject: Re: [nft] Byteorder problem still exists in nft
Date: Tue, 2 Sep 2014 14:55:33 +0800
Message-ID: <20140902065533.GA15959@localhost.localdomain>
References: <1409563554-1563-1-git-send-email-ycnian@gmail.com>
 <CADjjUBMbgdmaGGos1JyHiRwqf-PH9sfa2LKwxLfnXz5BPJyV9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61831 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBGws (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:52:48 -0400
Received: by mail-pd0-f179.google.com with SMTP id z10so7844796pdj.10
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Sep 2014 23:52:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CADjjUBMbgdmaGGos1JyHiRwqf-PH9sfa2LKwxLfnXz5BPJyV9Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 01, 2014 at 01:54:38PM +0200, Alvaro Neira Ayuso wrote:
> Hello
>=20
> El 01/09/2014 11:25, "Yanchuan Nian" <ycnian@gmail.com> escribi=F3:
> >
> > Hi,
> > There are still some byteorder prolems in nft.
> >
> > The first one:
> > nft> add rule bridge filter input ip saddr 192.168.1.1 counter
> > nft> list table bridge filter
> > table bridge filter {
> >         chain input {
> >                  type filter hook input priority 0;
> >                  unknown unknown 0xc0a80101 [invalid type] counter
> packets 0 bytes 0
> >         }
> > }
> > nft>
> > I guess this error occurs in payload_gen_dependency() which set the
> byteorder
> > host endian but ether type is big endian.
> >
> > The second one:
> > nft> add rule ip filter input ip length > 10 counter
> > BUG: invalid byte order conversion 0 =3D> 2
> > nft: src/evaluate.c:153: byteorder_conversion_op: Assertion `0' fai=
led.
> > This is because the datatype of ip length is integer_type whose byt=
eorder
> is invalid.
>=20
> I have already reported this bug. I have sent some patches but Patric=
k
> showed me the best way to fix it and I'm working in some patches.
>=20
> Regards
>=20
> Alvaro

Oh, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
