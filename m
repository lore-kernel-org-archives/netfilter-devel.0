Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B51922D4
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Dec 2024 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.58.85.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734197520; cv=none; b=NGFVGqaqc4WVtncYSh3LdpOd41dm+2i/c+HQWksxvU2y2B6H+QL6VLL0HCh6WNxxrlZed0k1g1ZRpGQ0FDt70A8AO3LM96LqVB8IKrAnX6xsPfHERO6q5specgRMrh2YRXYU8/Md9zN02YPx19w3JBbvTNDvfrz3Qn4oVRq0EPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734197520; c=relaxed/simple;
	bh=GdcIoMV9rDgh/h7XI/XexxU3pMPlgPu8UDf7JNbHBG0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Bfv4QHR4b6/sj0mS60OeL+5DMNEqyNDYz/3sZ/9Y83dajDzhbwXk0QntCpm8OFe81YRsUNVc6798MiroPsT44QGWif/ZacDWrdCSgXMRQLuf3XfNMcJ+i1hl7JgD6Wx/8u39nWrOnvv9FkiGdrZuhTbCFReAlFT5L28XmTf/01E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM; spf=pass smtp.mailfrom=aculab.com; arc=none smtp.client-ip=185.58.85.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-312-61ot2vfuOIOCZzeUwr6qww-1; Sat, 14 Dec 2024 17:31:50 +0000
X-MC-Unique: 61ot2vfuOIOCZzeUwr6qww-1
X-Mimecast-MFC-AGG-ID: 61ot2vfuOIOCZzeUwr6qww
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sat, 14 Dec
 2024 17:30:53 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Sat, 14 Dec 2024 17:30:53 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>, 'Naresh Kamboju'
	<naresh.kamboju@linaro.org>, 'Dan Carpenter' <dan.carpenter@linaro.org>,
	'Julian Anastasov' <ja@ssi.bg>, "'pablo@netfilter.org'"
	<pablo@netfilter.org>, Andrew Morton <akpm@linux-foundation.org>
CC: 'open list' <linux-kernel@vger.kernel.org>,
	"'lkft-triage@lists.linaro.org'" <lkft-triage@lists.linaro.org>, "'Linux
 Regressions'" <regressions@lists.linux.dev>, 'Linux ARM'
	<linux-arm-kernel@lists.infradead.org>, "'netfilter-devel@vger.kernel.org'"
	<netfilter-devel@vger.kernel.org>, 'Arnd Bergmann' <arnd@arndb.de>, "'Anders
 Roxell'" <anders.roxell@linaro.org>, 'Johannes Berg'
	<johannes.berg@intel.com>, "'toke@kernel.org'" <toke@kernel.org>, 'Al Viro'
	<viro@zeniv.linux.org.uk>, "'kernel@jfarr.cc'" <kernel@jfarr.cc>,
	"'kees@kernel.org'" <kees@kernel.org>
Subject: [PATCH net-next] Fix clamp() of ip_vs_conn_tab on small memory
 systems.
Thread-Topic: [PATCH net-next] Fix clamp() of ip_vs_conn_tab on small memory
 systems.
Thread-Index: AdtOTfU+VQ/Jz9m3Sa6gMqrna34atA==
Date: Sat, 14 Dec 2024 17:30:53 +0000
Message-ID: <24a6bfd0811b4931b6ef40098b33c9ee@AcuMS.aculab.com>
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
X-Mimecast-MFC-PROC-ID: DNP-rM_87HoLDVcpnfsAzALnB4FwrPhTD6RMAs6eOes_1734197509
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The 'max_avail' value is calculated from the system memory
size using order_base_2().
order_base_2(x) is defined as '(x) ? fn(x) : 0'.
The compiler generates two copies of the code that follows
and then expands clamp(max, min, PAGE_SHIFT - 12) (11 on 32bit).
This triggers a compile-time assert since min is 5.

In reality a system would have to have less than 512MB memory
for the bounds passed to clamp to be reversed.

Swap the order of the arguments to clamp() to avoid the warning.

Replace the clamp_val() on the line below with clamp().
clamp_val() is just 'an accident waiting to happen' and not needed here.

Detected by compile time checks added to clamp(), specifically:
minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MR=
LfAbM3f6ke0g@mail.gmail.com/
Fixes: 4f325e26277b ("ipvs: dynamically limit the connection hash table")
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: David Laight <david.laight@aculab.com>
---

Julian seems to be waiting for a 'v2' from me.
Changed target tree to 'net-next'.
I've re-written the commit message.
Copied Andrew Morton - he might want to take the change through the 'mm' tr=
ee.
Plausibly the 'fixes' tag should refer to the minmax.h change?
This will need back-porting if the minmax set get back-ported.

I'm not sure whether there ought to be an attribution to Dan Carpenter <dan=
.carpenter@linaro.org>

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

