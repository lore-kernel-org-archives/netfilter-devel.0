Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="HjWJ1zRw"
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2A710A
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2023 14:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
	t=1702159411; x=1702764211; i=corubba@gmx.de;
	bh=+j56QjzFiNpjlDRx704g1dJrlKkIKSU6vtzoiqzrBYs=;
	h=X-UI-Sender-Class:Date:To:From:Subject;
	b=HjWJ1zRwNWLjGYvWkvfaSnuI07QEHRX0OZtmkpZ5ha70zcNuKe0RDhTcR6i2/cio
	 +eeLzGtJZNRPPTZpA8z+NE2HKs+8JgltXR/P4RMEtAJb2TeTNT3VSO9y6mvf7oD7H
	 HjpIalKx+j8wKreVbUGdy0ih4GvjNYQniEllJn4w1uDmIWfYXMQXK8SQtuBywMdDE
	 OkESEl/uIqS3kCd558EuUMiEdYgCwkFxW7BEYNGOztUp+Au6bb8+DhXza4L6S4yJP
	 kxOzfvbGy3kFefleJH806lYe3wVacbIwzE0eqMbKjKmVOpFojZ+KBLodfd1aXIkeM
	 nI9K1+Xy5MGZxckV3g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.90.215]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MgvrL-1ri9300Vfp-00hQh6 for
 <netfilter-devel@vger.kernel.org>; Sat, 09 Dec 2023 23:03:31 +0100
Message-ID: <5c64b212-6e43-424a-a6b0-ba79c0596d3e@gmx.de>
Date: Sat, 9 Dec 2023 23:03:01 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: netfilter-devel@vger.kernel.org
Content-Language: de-CH
From: corubba <corubba@gmx.de>
Subject: [PATCH libnftnl] object: getters take const struct
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DPMNgv9xomjnfw5L8bM3rZpimp2CWxMHpBWxWh8OPaXmFrVXRyI
 y4T9jZrVwUSUjQxFDPVzKmMRdKetJoLX8apawz8PZSjc8XjVvxgA7Kr2SNTAlVjyYR6+a8j
 eC4rN6+LElTRn4nA3DOEPHoiOV4yd3KM4IVdXc0jrodjYp+3h0K+L8dfsfZVace/t6Lf4Wa
 fC63DHf8WcsBzCQ+qCbcA==
UI-OutboundReport: notjunk:1;M01:P0:ke9x5Ho9kLw=;RkeJTGFL4rHQ16i2iPV64lHL8bE
 eqGJX6NHYUmHWZ9pl3ibs+ZmEBbGudk8b66w/YTc+bUC3yl1e8to0zr2a/kk6r3Ftn/BOKtNt
 a55kvGAPzg17TvZH1Fy+fUFswBtqrZE7Kc8nDj1OEsV9bLqHin2wyrzO81Eo6uofnzj6Becs2
 W5gBUni6nRiFMIub7P2onuDZx8QP+WFohWh0wcBfUhE3iO3uSsCAbr4hwqQkX6qViTfYobDHK
 NNJRzXRyVqtP1YGkdxDpuUuCIld1tI2VqzIYsnfdykwwoKONh9pd0uULPpqrno7AYU1Hg1h13
 mbyPu5M3THwsIO2Itrgd0lAb0vsWcqpGSzjDPdoINHhxpceMwFGAEwarTCqdXi4lThkPsPpyR
 KqpAjO14s2BBIYng4sKOqF8VubZe/58pF2rITXbsC5PTCYFaetI52MQsJsO4cA0ye9ltgblhW
 eH9uwYtUSEWUgwptIItZ+0FLplm14dmpcfl5L2S8Ibl3zfnEuKwM76l0frTjXurn3m+bscKxg
 fIM09KARSIND/cd2GBrU+3ogwJI6R5hMk4IYUWzl/CizFJZjc/wqmBi1Y/qfmWZrXxWThVM4/
 m4n5EKEaVcIWELOZ9+D3W7m9lCPMM/vmuaQCBwxEx8kGTwP7GwBPiWiq10YoyqzLtY1GC9IEw
 8FhNlD/VmnvXe9rCkBZio6PYDaS+H7no0Ul3C6jW5o10ZcNc4n3yhQnUEyDu9PhPVBFslMFQ9
 dFEi21k6MhVa7KsJ93/aS33MrPtuvzsLfZUt0J3TRgbn7EHjnlHc2Glrln3hb4DbLwDepfHnE
 BmZ5RwwFKsVbZWOm8WciztApUkj+SM87iy/8FR37ThR4cprEXh8Bw5vhn2E5qEnjEU5saQ38C
 6sYJ6hp1Re595H3nzjvz3Qht3r30YgAQ98ikdsbjCt1JVtDAZ+oDNBF/HCsIUXxYwttB9H3gD
 iSy4ZQ==

As with all the other entities (like table or set), the getter functions
for objects now take a `const struct nftnl_obj*` as first parameter.
The getters for all specific object types (like counter or limit), which
are called in the default switch-case, already do.

Signed-off-by: corubba <corubba@gmx.de>
=2D--
 include/libnftnl/object.h | 14 +++++++-------
 src/object.c              | 14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 9bd83a5..4b2d90f 100644
=2D-- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -131,14 +131,14 @@ void nftnl_obj_set_u16(struct nftnl_obj *ne, uint16_=
t attr, uint16_t val);
 void nftnl_obj_set_u32(struct nftnl_obj *ne, uint16_t attr, uint32_t val)=
;
 void nftnl_obj_set_u64(struct nftnl_obj *obj, uint16_t attr, uint64_t val=
);
 void nftnl_obj_set_str(struct nftnl_obj *ne, uint16_t attr, const char *s=
tr);
-const void *nftnl_obj_get_data(struct nftnl_obj *ne, uint16_t attr,
+const void *nftnl_obj_get_data(const struct nftnl_obj *ne, uint16_t attr,
 			       uint32_t *data_len);
-const void *nftnl_obj_get(struct nftnl_obj *ne, uint16_t attr);
-uint8_t nftnl_obj_get_u8(struct nftnl_obj *ne, uint16_t attr);
-uint16_t nftnl_obj_get_u16(struct nftnl_obj *obj, uint16_t attr);
-uint32_t nftnl_obj_get_u32(struct nftnl_obj *ne, uint16_t attr);
-uint64_t nftnl_obj_get_u64(struct nftnl_obj *obj, uint16_t attr);
-const char *nftnl_obj_get_str(struct nftnl_obj *ne, uint16_t attr);
+const void *nftnl_obj_get(const struct nftnl_obj *ne, uint16_t attr);
+uint8_t nftnl_obj_get_u8(const struct nftnl_obj *ne, uint16_t attr);
+uint16_t nftnl_obj_get_u16(const struct nftnl_obj *obj, uint16_t attr);
+uint32_t nftnl_obj_get_u32(const struct nftnl_obj *ne, uint16_t attr);
+uint64_t nftnl_obj_get_u64(const struct nftnl_obj *obj, uint16_t attr);
+const char *nftnl_obj_get_str(const struct nftnl_obj *ne, uint16_t attr);

 void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
 				   const struct nftnl_obj *ne);
diff --git a/src/object.c b/src/object.c
index 232b97a..9e76861 100644
=2D-- a/src/object.c
+++ b/src/object.c
@@ -160,7 +160,7 @@ void nftnl_obj_set_str(struct nftnl_obj *obj, uint16_t=
 attr, const char *str)
 }

 EXPORT_SYMBOL(nftnl_obj_get_data);
-const void *nftnl_obj_get_data(struct nftnl_obj *obj, uint16_t attr,
+const void *nftnl_obj_get_data(const struct nftnl_obj *obj, uint16_t attr=
,
 			       uint32_t *data_len)
 {
 	if (!(obj->flags & (1 << attr)))
@@ -198,42 +198,42 @@ const void *nftnl_obj_get_data(struct nftnl_obj *obj=
, uint16_t attr,
 }

 EXPORT_SYMBOL(nftnl_obj_get);
-const void *nftnl_obj_get(struct nftnl_obj *obj, uint16_t attr)
+const void *nftnl_obj_get(const struct nftnl_obj *obj, uint16_t attr)
 {
 	uint32_t data_len;
 	return nftnl_obj_get_data(obj, attr, &data_len);
 }

 EXPORT_SYMBOL(nftnl_obj_get_u8);
-uint8_t nftnl_obj_get_u8(struct nftnl_obj *obj, uint16_t attr)
+uint8_t nftnl_obj_get_u8(const struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret =3D nftnl_obj_get(obj, attr);
 	return ret =3D=3D NULL ? 0 : *((uint8_t *)ret);
 }

 EXPORT_SYMBOL(nftnl_obj_get_u16);
-uint16_t nftnl_obj_get_u16(struct nftnl_obj *obj, uint16_t attr)
+uint16_t nftnl_obj_get_u16(const struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret =3D nftnl_obj_get(obj, attr);
 	return ret =3D=3D NULL ? 0 : *((uint16_t *)ret);
 }

 EXPORT_SYMBOL(nftnl_obj_get_u32);
-uint32_t nftnl_obj_get_u32(struct nftnl_obj *obj, uint16_t attr)
+uint32_t nftnl_obj_get_u32(const struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret =3D nftnl_obj_get(obj, attr);
 	return ret =3D=3D NULL ? 0 : *((uint32_t *)ret);
 }

 EXPORT_SYMBOL(nftnl_obj_get_u64);
-uint64_t nftnl_obj_get_u64(struct nftnl_obj *obj, uint16_t attr)
+uint64_t nftnl_obj_get_u64(const struct nftnl_obj *obj, uint16_t attr)
 {
 	const void *ret =3D nftnl_obj_get(obj, attr);
 	return ret =3D=3D NULL ? 0 : *((uint64_t *)ret);
 }

 EXPORT_SYMBOL(nftnl_obj_get_str);
-const char *nftnl_obj_get_str(struct nftnl_obj *obj, uint16_t attr)
+const char *nftnl_obj_get_str(const struct nftnl_obj *obj, uint16_t attr)
 {
 	return nftnl_obj_get(obj, attr);
 }
=2D-
2.43.0
