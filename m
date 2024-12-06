Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5605A1FCCFB
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 10:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733480893; cv=none; b=ocN8r3M4nvLbLBsaIIgZ48WaIZhuYX6OTaFMr/mmrFP5E96nxTcS8okYiLVb3yfOgbZwVFCy803cgLuIog5PqFXv+ASlji65UWp64JfQzxD3x+l7GmdgE0VeqmcvkVUqrnL2Hplk2m9QURN33jDPyF3a9Gxn9Lk6aEmUtZs8QJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733480893; c=relaxed/simple;
	bh=hthJtxRUGovk5V1RqI0hmfgY1tiYoYoWmAR9jCX9OyI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mr6Phq9mSMKKI6lWT2GfwpHGpa/lXEzyOPvc8dTIiycGz6ltr8VQOcJOrNuhROYjNqZt5BLgHsnKPzaxsKCigiUn7bnf8tHPZCB8MdLk2RvKFDf9usmMh9TCOV5NIcMMteEG0EglkgxJELIjfoNHfDd2xf1SOZ17oTAXuE4olr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-126-71H4KnOWMoK8Apry69ITrA-1; Fri, 06 Dec 2024 10:28:08 +0000
X-MC-Unique: 71H4KnOWMoK8Apry69ITrA-1
X-Mimecast-MFC-AGG-ID: 71H4KnOWMoK8Apry69ITrA
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 6 Dec
 2024 10:27:23 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 6 Dec 2024 10:27:23 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 'Naresh Kamboju'
	<naresh.kamboju@linaro.org>, 'Dan Carpenter' <dan.carpenter@linaro.org>,
	Julian Anastasov <ja@ssi.bg>, "'pablo@netfilter.org'" <pablo@netfilter.org>
CC: 'open list' <linux-kernel@vger.kernel.org>,
	"'lkft-triage@lists.linaro.org'" <lkft-triage@lists.linaro.org>, "'Linux
 Regressions'" <regressions@lists.linux.dev>, 'Linux ARM'
	<linux-arm-kernel@lists.infradead.org>, "'netfilter-devel@vger.kernel.org'"
	<netfilter-devel@vger.kernel.org>, 'Arnd Bergmann' <arnd@arndb.de>, "'Anders
 Roxell'" <anders.roxell@linaro.org>, 'Johannes Berg'
	<johannes.berg@intel.com>, "'toke@kernel.org'" <toke@kernel.org>, 'Al Viro'
	<viro@zeniv.linux.org.uk>, "'kernel@jfarr.cc'" <kernel@jfarr.cc>,
	"'kees@kernel.org'" <kees@kernel.org>
Subject: [PATCH net] Fix clamp() of ip_vs_conn_tab on small memory systems.
Thread-Topic: [PATCH net] Fix clamp() of ip_vs_conn_tab on small memory
 systems.
Thread-Index: AdtHyTlbE/fm67s0Ria1gsbgnJ6Kcg==
Date: Fri, 6 Dec 2024 10:27:23 +0000
Message-ID: <33893212b1cc4a418cec09aeeed0a9fc@AcuMS.aculab.com>
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
X-Mimecast-MFC-PROC-ID: 3P-m-zQy8fBPrprgxVFvlMXQ1IXQM7ItLwnFR9UDjco_1733480887
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The intention of the code seems to be that the minimum table
size should be 256 (1 << min).
However the code uses max =3D clamp(20, 5, max_avail) which implies
the author thought max_avail could be less than 5.
But clamp(val, min, max) is only well defined for max >=3D min.
If max < min whether is returns min or max depends on the order of
the comparisons.

Change to clamp(max_avail, 5, 20) which has the expected behaviour.

Replace the clamp_val() on the line below with clamp().
clamp_val() is just 'an accident waiting to happen' and not needed here.

Fixes: 4f325e26277b6
(Although I actually doubt the code is used on small memory systems.)

Detected by compile time checks added to clamp(), specifically:
minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

Signed-off-by: David Laight <david.laight@aculab.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_con=
n.c
index 98d7dbe3d787..c0289f83f96d 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1495,8 +1495,8 @@ int __init ip_vs_conn_init(void)
 =09max_avail -=3D 2;=09=09/* ~4 in hash row */
 =09max_avail -=3D 1;=09=09/* IPVS up to 1/2 of mem */
 =09max_avail -=3D order_base_2(sizeof(struct ip_vs_conn));
-=09max =3D clamp(max, min, max_avail);
-=09ip_vs_conn_tab_bits =3D clamp_val(ip_vs_conn_tab_bits, min, max);
+=09max =3D clamp(max_avail, min, max);
+=09ip_vs_conn_tab_bits =3D clamp(ip_vs_conn_tab_bits, min, max);
 =09ip_vs_conn_tab_size =3D 1 << ip_vs_conn_tab_bits;
 =09ip_vs_conn_tab_mask =3D ip_vs_conn_tab_size - 1;
=20
--=20
2.17.1

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)

