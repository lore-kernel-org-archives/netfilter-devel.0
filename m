Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55D82206B4
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733507655; cv=none; b=P9TL+lfmTYYr87WC4WZ4cojbNjuoN+WqaDIqrQ0oc2w+n4nk9tHt25J8MyWzwBDWgAoo8ySkWaEGMbVd0cDKyVMWrMxWodvxl6aic548oJuzScvX2oQwxy9QLZX5vCEbA3dGgXqNjsiPkV5WYHs7D6cNCga1J9QfIgY5cBItzwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733507655; c=relaxed/simple;
	bh=CAvPxwbRXQNLTTqGkA10Ah9zjMscuWnJ5epuxY56l/w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 MIME-Version:Content-Type; b=UdXFGgWRVyKmybxlXQrVI4c9owYj7X6n66pxGTTXk2F14zsTBQmA4AHcVk5A9D2h10Rbr7AzX3AzAKBT3Y2ltjE7YngWTTVWBaOuA7Jvx/cROqv6rRLoa79fvjg9jw9cBnVRYCkDPlHzMLuv9hOpov4QBrx1HV5Mhlg4N48Gz6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-128-v2x3GVjoN7yhLXzRYoHP7Q-1; Fri, 06 Dec 2024 17:54:11 +0000
X-MC-Unique: v2x3GVjoN7yhLXzRYoHP7Q-1
X-Mimecast-MFC-AGG-ID: v2x3GVjoN7yhLXzRYoHP7Q
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 6 Dec
 2024 17:53:24 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 6 Dec 2024 17:53:24 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Julian Anastasov' <ja@ssi.bg>, 'Andrew Morton'
	<akpm@linux-foundation.org>
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
Thread-Index: AdtHyTlbE/fm67s0Ria1gsbgnJ6KcgAD9raAAACnwVAAB9xJgAACKUOg
Date: Fri, 6 Dec 2024 17:53:24 +0000
Message-ID: <494a4dc2ba2041dfb9f45d86e972b953@AcuMS.aculab.com>
References: <33893212b1cc4a418cec09aeeed0a9fc@AcuMS.aculab.com>
 <5ec10e7c-d050-dab8-1f1b-d0ca2d922eef@ssi.bg>
 <2a91ee407ed64d24b82e5fc665971add@AcuMS.aculab.com>
 <c0a2ee53-f6ff-f4d4-e9ab-6a3bf850bec5@ssi.bg>
In-Reply-To: <c0a2ee53-f6ff-f4d4-e9ab-6a3bf850bec5@ssi.bg>
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
X-Mimecast-MFC-PROC-ID: J0Zhs3Jf9XZGp973r5N1Ee8uRyjYhYOV7VWR1eQ5Bck_1733507650
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Julian Anastasov
> Sent: 06 December 2024 16:23
...
> =09I'm not sure how much memory we can see in small system,
> IMHO, problem should not be possible in practice:
>=20
> - nobody expects 0 from totalram_pages() in the code
>=20
> - order_base_2(sizeof(struct ip_vs_conn)) is probably 8 on 32-bit

It is 0x120 bytes on 64bit, so 8 could well be right.

> - PAGE_SHIFT: 12 (for 4KB) or more?
>=20
> =09So, if totalram_pages() returns below 128 pages (4KB each)
> max_avail will be below 19 (7 + 12), then 19 is reduced with 2 + 1
> and becomes 16, finally with 8 (from the 2nd order_base_2) to reach
> 16-8=3D8. You need a system with less than 512KB (19 bits) to trigger
> problem in clamp() that will lead to max below 8.

Which pretty much won't happen, I think my (dead) sun3 has more than that.

> Further, without
> checks, for ip_vs_conn_tab_bits=3D1 we need totalram_pages() to return 0
> pages.
>=20
> > > > Detected by compile time checks added to clamp(), specifically:
> > > > minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
> > >
> > > =09Existing or new check? Does it happen that max_avail
> > > is a constant, so that a compile check triggers?
> >
> > Is all stems from order_base_2(totalram_pages()).
> > order_base_2(n) is 'n > 1 ? ilog2(n - 1) + 1 : 0'.
> > And the compiler generates two copies of the code that follows
> > for the 'constant zero' and ilog2() values.
> > And the 'zero' case compiles clamp(20, 8, 0) which is errored.
> > Note that it is only executed if totalram_pages() is zero,
> > but it is always compiled 'just in case'.
>=20
> =09I'm confused with these compiler issues,

The compiler is just doing its job.
Consider this expression:
=09(x >=3D 1 ? 2 * x : 1) - 1
It is likely to get converted to:
=09(x >=3D 1 ? 2 * x - 1 : 0)
to avoid the subtract when x < 1.

The same thing is happening here.
order_base_2() has a (condition ? fn() : 0) in it.
All the +/- constants get moved inside, on 64bit that is +12 -2 -1 -9 =3D 0=
.
Then the clamp() with constants gets moved inside:
=09(condition ? clamp(27, 8, fn() + 0) : clamp(27, 8, 0 + 0))
Now, at runtime, we know that 'condition' is true and (fn() >=3D 8)
so the first clamp() is valid and the second one never used.
But this isn't known by the compiler and clamp() detects the invalid
call and generates a warning.

> if you
> think we should go with the patch just decide if it is a
> net or net-next material. Your change is safer for bad
> max_avail values but I don't expect to see problem while
> running without the change, except the building bugs.
>=20
> =09Also, please use nf/nf-next tag to avoid any
> confusion with upstreaming...

I've copied Andrew M - he's taken the minmax.h change into his mm tree.
This is one of the build breakages.

It probably only needs to go into next for now (via some route).
But I can image the minmax.h changes getting backported a bit.

=09David

>=20
> Regards
>=20
> --
> Julian Anastasov <ja@ssi.bg>

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

