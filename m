From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: Fix printf format warning
Date: Tue, 1 Apr 2014 17:44:52 +0700
Message-ID: <20140401104452.GA2110@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61838 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaDAKo6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:44:58 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so9417692pdj.3
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Apr 2014 03:44:58 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Using PRIx32 macro is portable across multiple architectures and
also fix the printf format warning on any architectures that
"%llx" is not refer to 32 bits size.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 lib/print.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/print.c b/lib/print.c
index f81c074..a7abdcf 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -13,6 +13,7 @@
 #include <arpa/inet.h>				/* inet_ntop */
 #include <net/ethernet.h>			/* ETH_ALEN */
 #include <net/if.h>				/* IFNAMSIZ */
+#include <inttypes.h>				/* PRIx macro */
=20
 #include <libipset/debug.h>			/* D() */
 #include <libipset/data.h>			/* ipset_data_* */
@@ -519,7 +520,7 @@ ipset_print_mark(char *buf, unsigned int len,
 	mark =3D ipset_data_get(data, opt);
 	assert(mark);
=20
-	size =3D snprintf(buf, len, "0x%08llx", *mark);
+	size =3D snprintf(buf, len, "0x%08"PRIx32, *mark);
 	SNPRINTF_FAILURE(size, len, offset);
=20
 	return offset;
--=20
1.9.1


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJTOpikAAoJEJ0EcL2mzcRXw/gP/0bSgJwI0Nchst8V3O8MFgO3
6ILrVycJMMEa4KR8+hrxJqqiZgeKZ02VIZPiIwDHVl/zAHijZ9H7wf/OD5IUA9Rz
Nv0r4qJypnY/uErQpBX/5WrMdfst7TwbqbsUb5jsc3Jab2KHZMq4xTe6y3esiHMZ
dw5fA85ch3iWuJ7l38mwQCxQaeEYahkB+YMVFRwazspLyehSeK6DSt8rlLmk1JvF
N+hLpIs+caAok3ae4DF86dltVGlYLwPHmbd8qSfSBGpu8MmXwH9LYuQ1PRajnbDd
timvzlUcMMEqD2NswBLHWub9d3qmnbB1Ukogjw7vK1RtFtfdMOjvU8c+/nETwM9I
GfzSbXsvfKUeMFh/TU5Mg/QlbV9OEpu22oDdZkqq7MkVLEVjryPCylsL44tEXQeo
uQEYJdf5cmiBuW/BpyaUvzixuqG5kFHRErHRpeaGhOxcch+RauVaL5WtvfdykUHj
F92D1/TRp74dEwKTTElb30XHbfVGVF58rNBhuWSqvZKdSUliuENPbcGw8LOhw4nf
crMG6NR9YGI+BDhB1Q+fheudtYqzI31YlWWqttqDj/FlD2spjQyBxamgKfn/vpXC
c/Pj4kauot/NUGJ8xZEnvrb961Eusd6wuvoVcOygx9Fytc8PgH370rFMJ6DwZxRG
8QD6fs9MgUlG6835s2lz
=YAQn
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
