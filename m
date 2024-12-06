Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B748420103B
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 13:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733490530; cv=none; b=m5+f0aSFW5RxxuqrjTqzXygBf8MP8eSqObdOvxN1l0RhRwm32RhO/kVS/fpw6SDqh8x5Pb/EUVq6FqwF/MeRCBKux2COvan1dKAyjkWNDJ0RszFyf5ZXhmeYwc7/fBXuGU3n4xIjvFntn/Pl9na/vhc4v1CH/sMynwgAM1ibIOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733490530; c=relaxed/simple;
	bh=QF8c2MhUemDCUpYqGQBweZ1Ws7IWDc/WAQA2tfJjVVU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=DEnSe9cVif/rYDxU8bxDR4s7Pgq1PPpkjy/mhYlIzkxHZSUh5+3cUAvesvyJk5cuV16jxQgIpLIZ8wf+ftBTZrP5FXWISf/0DxM89uZmb4gHUjxTgk/UGqNBtJhrULvyrM6pK1CyOuwfcrSFGNILHQuR/Ug2YxdoW5nUxHOtNBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-168-rEnKtWNUMFWeQM5TnnsDWQ-1; Fri, 06 Dec 2024 13:08:45 +0000
X-MC-Unique: rEnKtWNUMFWeQM5TnnsDWQ-1
X-Mimecast-MFC-AGG-ID: rEnKtWNUMFWeQM5TnnsDWQ
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 6 Dec
 2024 13:07:59 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 6 Dec 2024 13:07:59 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Julian Anastasov' <ja@ssi.bg>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 'Naresh Kamboju'
	<naresh.kamboju@linaro.org>, 'Dan Carpenter' <dan.carpenter@linaro.org>,
	"'pablo@netfilter.org'" <pablo@netfilter.org>, 'open list'
	<linux-kernel@vger.kernel.org>, "'lkft-triage@lists.linaro.org'"
	<lkft-triage@lists.linaro.org>, 'Linux Regressions'
	<regressions@lists.linux.dev>, 'Linux ARM'
	<linux-arm-kernel@lists.infradead.org>, "'netfilter-devel@vger.kernel.org'"
	<netfilter-devel@vger.kernel.org>, 'Arnd Bergmann' <arnd@arndb.de>, "'Anders
 Roxell'" <anders.roxell@linaro.org>, 'Johannes Berg'
	<johannes.berg@intel.com>, "'toke@kernel.org'" <toke@kernel.org>, 'Al Viro'
	<viro@zeniv.linux.org.uk>, "'kernel@jfarr.cc'" <kernel@jfarr.cc>,
	"'kees@kernel.org'" <kees@kernel.org>
Subject: RE: [PATCH net] Fix clamp() of ip_vs_conn_tab on small memory
 systems.
Thread-Topic: [PATCH net] Fix clamp() of ip_vs_conn_tab on small memory
 systems.
Thread-Index: AdtHyTlbE/fm67s0Ria1gsbgnJ6KcgAD9raAAACnwVA=
Date: Fri, 6 Dec 2024 13:07:59 +0000
Message-ID: <2a91ee407ed64d24b82e5fc665971add@AcuMS.aculab.com>
References: <33893212b1cc4a418cec09aeeed0a9fc@AcuMS.aculab.com>
 <5ec10e7c-d050-dab8-1f1b-d0ca2d922eef@ssi.bg>
In-Reply-To: <5ec10e7c-d050-dab8-1f1b-d0ca2d922eef@ssi.bg>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FaqbtbSl-Ligc2gJMD_NcggagQHF0sDET_iT2wWwa7I_1733490524
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Julian Anastasov
> Sent: 06 December 2024 12:19
>=20
> On Fri, 6 Dec 2024, David Laight wrote:
>=20
> > The intention of the code seems to be that the minimum table
> > size should be 256 (1 << min).
> > However the code uses max =3D clamp(20, 5, max_avail) which implies
>=20
> =09Actually, it tries to reduce max=3D20 (max possible) below
> max_avail: [8 .. max_avail]. Not sure what 5 is here...

Me mistyping values between two windows :-)

Well min(max, max_avail) would be the reduced upper limit.
But you'd still fall foul of the compiler propagating the 'n > 1'
check in order_base_2() further down the function.

> > the author thought max_avail could be less than 5.
> > But clamp(val, min, max) is only well defined for max >=3D min.
> > If max < min whether is returns min or max depends on the order of
> > the comparisons.
>=20
> =09Looks like max_avail goes below 8 ? What value you see
> for such small system?

I'm not, but clearly you thought the value could be small otherwise
the code would only have a 'max' limit.
(Apart from a 'sanity' min of maybe 2 to stop the code breaking.)

>=20
> > Change to clamp(max_avail, 5, 20) which has the expected behaviour.
>=20
> =09It should be clamp(max_avail, 8, 20)
>=20
> >
> > Replace the clamp_val() on the line below with clamp().
> > clamp_val() is just 'an accident waiting to happen' and not needed here=
.
>=20
> =09OK
>=20
> > Fixes: 4f325e26277b6
> > (Although I actually doubt the code is used on small memory systems.)
> >
> > Detected by compile time checks added to clamp(), specifically:
> > minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
>=20
> =09Existing or new check? Does it happen that max_avail
> is a constant, so that a compile check triggers?

Is all stems from order_base_2(totalram_pages()).
order_base_2(n) is 'n > 1 ? ilog2(n - 1) + 1 : 0'.
And the compiler generates two copies of the code that follows
for the 'constant zero' and ilog2() values.
And the 'zero' case compiles clamp(20, 8, 0) which is errored.
Note that it is only executed if totalram_pages() is zero,
but it is always compiled 'just in case'.

>=20
> >
> > Signed-off-by: David Laight <david.laight@aculab.com>
>=20
> =09The code below looks ok to me but can you change the
> comments above to more correctly specify the values and if the
> problem is that max_avail goes below 8 (min).
>=20
> > ---
> >  net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs=
_conn.c
> > index 98d7dbe3d787..c0289f83f96d 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > @@ -1495,8 +1495,8 @@ int __init ip_vs_conn_init(void)
> >  =09max_avail -=3D 2;=09=09/* ~4 in hash row */
> >  =09max_avail -=3D 1;=09=09/* IPVS up to 1/2 of mem */
> >  =09max_avail -=3D order_base_2(sizeof(struct ip_vs_conn));
>=20
> =09More likely we can additionally clamp max_avail here:
>=20
> =09max_avail =3D max(min, max_avail);
>=20
> =09But your solution solves the problem with less lines.

And less code in the path that is actually executed.

=09David

>=20
> > -=09max =3D clamp(max, min, max_avail);
> > -=09ip_vs_conn_tab_bits =3D clamp_val(ip_vs_conn_tab_bits, min, max);
> > +=09max =3D clamp(max_avail, min, max);
> > +=09ip_vs_conn_tab_bits =3D clamp(ip_vs_conn_tab_bits, min, max);
> >  =09ip_vs_conn_tab_size =3D 1 << ip_vs_conn_tab_bits;
> >  =09ip_vs_conn_tab_mask =3D ip_vs_conn_tab_size - 1;
> >
> > --
> > 2.17.1
>=20
> Regards
>=20
> --
> Julian Anastasov <ja@ssi.bg>

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

