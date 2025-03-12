Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333CA248874
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741791321; cv=none; b=dJ0d9vz0ZF4MhjGKVf3vXWRQLodxnK/idvtwgRKSlXaKP0158TJJEgDHw//65CgOLBGX5rZLoXfv/MxRXykq/Cs+KOIs0nUtlQyoC2rMr8H5RVPREH70urJRjodOvodyL41Ya0XIz6BxgcLpidzy5q9OJhF9mbiM5258bTDG0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741791321; c=relaxed/simple;
	bh=RLXmb67O93k0eyssHQ0xgYE+VrkobD+fZGZWeg9tcKk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=QjCs7WfcX4ufFEvUXBO882cdDb1SydgNh3JM+sD1U+IKtSbOu8lknebgcg6VxE4O8tmS7LVxyv7Z0Zd2o8RbInQ+FDCtDiAFmEtFswH5dg0cASiK1Vn2v6UoBuugY6nGqjVcWtXYlAFYjKMHq+3P0zz5vSir8VaCXi/oj6cH52Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=oNCuMa6X; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="oNCuMa6X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741791317; x=1742396117; i=corubba@gmx.de;
	bh=5aj+tTvJqbWlV8Sn8M7LucAPrXShuApNgYd9iERs2gc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=oNCuMa6X6Qzjbg5V1wYPAoWg7s/uEHRhbG4fcUzZzIeVAnZZPqA18wn13GMxPCrR
	 Dzope4edgm+aKCCJVtgEGE5OP3hya3I7pb5zhtAicTylSNgTEduR3A9OjBbSjtr5p
	 A5+TUT8vaF4mlNRqLmh3hjZSFGz5VFHmfXPOiuA2XvPdG7uyRkEHkTyMb8dcNYqBq
	 z5PIl64uf3hBbWsjoRYlynWfqa25661XwoQc5XLya9ojsSds1niZOM4iZJnCP846p
	 uBfOg5D18HQha8ynWuNW8pqMfKnZr7jl1Vno7IYDqZIPj7ZsbM7Gz1Zjn6g6qKaKm
	 WH4MM4jF2DWJ+mNVfA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N49hB-1tA0JQ0nPF-00wOP6 for
 <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 15:55:17 +0100
Message-ID: <4748a2cc-21b8-453a-ae90-22c6f2becb9c@gmx.de>
Date: Wed, 12 Mar 2025 15:55:16 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2,v2 4/6] ulogd: improve integer option parsing
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Language: de-CH
In-Reply-To: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rrsF2jymNz+ZDr/n6VD64BWEyHm+5AKveE2kj4w0jyzzmcR5eox
 VX+DBs7rVxrL19qTWVX49iDG0Y5Sd0l+ViFaGQLHLJ3wh5vEsMzIovtDmClRha0H1VFEcNG
 AiASlk7VokQI+m9ZoCPk4Y6poI1ZV5sE+fHLyfvShJdHcdDXOA2qqwyYAh77JvP4WrCcSuE
 f1OL2qnXA189TQgAjVt0g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QLPbUCVY79A=;+6s6FpmrunN8xsSAhEpL0+jmvPr
 NFHlrP5BAAZ8UAuHEJG1JivQVx8MSncXm216LhH1fu2gx/e/yIvq+B8NPrEMjKNXvC5nT++dY
 zCpmAyWfIviFGoB9GW5yafYE7rXOO2O9+C6tQ5KJ3VKWLhFjlUbEM5Zp+weYNa40bvWfLp5a6
 o8nDVbgHLPRzAvKOz6HQr3OZ9oiD37UBN3+OFIN4FD6gXxJnzUWU4WKlj0cFmjufxQ5zGtGJE
 3X8WwY9jM1k2Q5srg5Z0ytLdzU5+i8q0z4dr+oX6cdAqBVb+9MqeU1WDtHv3qsPHQH6DeUKbs
 ZhMQJFQ4nZhtnQdkuMUwp8x6f7rI4IbyJuHoZN+Ovzu42B3y3UEJhxnaYv9QsqoIxD18btu4S
 GZWJJpx9dznmo0LVgSYONkWOp+Yx6NHhaqczn2SVUBXhcGgoKAAOoXtgjfsWT6bn+LdDN2Sty
 UXVrbIvcz4Mgk6pvsG8a+CLiRq0baPHo1o+P6MkQLcV/Fu87AH0BoWTRtqhraKvmWp4Cs8MSJ
 9THxRF4pN4tmLO1gJWk6pnLTjxvYzBl6G0FwMOhOl0CDTqmT0KsLaRqdB7d+58C2Pf1ZWIZvG
 ANQdWBwd0xFfpWfnuDPqpJW+a5bOpjkytepkxEs8poulgaBbWL56QnTg4Lb4GEbSxhC1hZtgz
 6fFZiyRuNd6fihBCYRh9lpFZbkYRTfazL7NvdrgUKmFBlfBm74zFUdHr0Xb+Za6Td9AX1q5UM
 a/LO61FpYHeJPGk0ejuilFLGiRPNeqQxObADyq5T7yTUYB4qo+lbG9L9OOCVaLd7AUS/PI4lt
 FV1Zm/R/l+68VdhRwO51P3p5dOypCg2E8A2kuN1Z8qvgxC5alY7yKj8dmTNhBsVBH3YFKZh5/
 MeJwglruX+WnywG9PxtDobP2HzqtsqUrqmx/4PLqZS3yFdPRDFZmJOJb2Cn4Gq3DbKADwGf63
 CH0f7Q4/UWEY1/OeuR7foi5SvUweWPpwklRrnQiiT34puesGxajnGUeuEEZy7LgPD9aayIZfl
 BJ7PIjG8Q9oeYo2iRTPfXjkMMsQyeVZsxCmDtRCkHS3G5b6wQZ/46dyiFUdRxfw3BxwEnpQoK
 vMmh3aP3JPg+F1FYr12AT+pSc0cJv+5x/IXK45fM8lXkMgJj8N45H6PH4cwPPTfKcr+6ZtIP0
 bLcWiPByyT7JKEUi8m/1CrlceGIY0pJjvZmk/lnPycf8TYevYXMyo2laSnEhrr1ZFBxVpXcZS
 W9AieEfqcadREZ0wjchh9sAgG5qjptYxtYPWmmIAilW64TSfMpGrFhWxvVo8/nie3Ojy7Siir
 +9fvroAi0ewbvKuWHeVOSfQ64E1HoTLA7GG5DIBAFtQW1ehw1AzeV647cuiISTXVN9m3li8+z
 lnMr2/70EJx7NRUbSmP4/bjKgcvGS2mGVzCBKzuilyXFR/zSluCJO96v+s8PtXMCsXDVmTxBO
 fh7DMn02VroBiqRSNYILRmJoPfos=

The `value` union member in `struct config_entry` is declared as `int`
since basically the beginning in e07722e46001 ("config stuff added").
The parsing was switched from the original `atoi()` in 015849995f7f
("Fix hexadecimal parsing in config file") to `strtoul()`.

Switch the function for parsing to the signed `strtol()` variant since
the result will be stored in a signed int, and it makes sense to support
negative numbers. Detect when `strtol()` does not properly consume the
whole argument and return a new format error. Also check the numerical
value to make sure the signed int does not overflow, in which case
a new range error is returned.

Unfortunately there is no `strtoi()` which would do the proper range
check itself, so the intermediate `long` and range-check for `int` is
required. I also considered changing the `value` union member from
`int` to `long`, which would make it possible to use the parsed value
as-is. But since this is part of the api towards plugins (including
third party) such a potentially breaking change felt unwarranted. This
also means that still only 16bit integer values are *guaranteed* to
work, although most platforms use bigger widths for int.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - Reduce indentation of case statements (Florian Westphal)

 include/ulogd/conffile.h |  2 ++
 src/conffile.c           | 17 ++++++++++++++++-
 src/ulogd.c              | 10 ++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/ulogd/conffile.h b/include/ulogd/conffile.h
index 1f3d563..fb54dea 100644
=2D-- a/include/ulogd/conffile.h
+++ b/include/ulogd/conffile.h
@@ -19,6 +19,8 @@ enum {
 	ERRUNKN,	/* unknown config key */
 	ERRSECTION,	/* section not found */
 	ERRTOOLONG,	/* string too long */
+	ERRINTFORMAT,	/* integer format is invalid */
+	ERRINTRANGE,	/* integer value is out of range */
 };

 /* maximum line length of config file entries */
diff --git a/src/conffile.c b/src/conffile.c
index 7b9fb0f..f412804 100644
=2D-- a/src/conffile.c
+++ b/src/conffile.c
@@ -17,6 +17,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 =
 USA
  */

+#include <limits.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/common.h>
 #include <ulogd/conffile.h>
@@ -227,7 +228,21 @@ int config_parse_file(const char *section, struct con=
fig_keyset *kset)
 					}
 					break;
 				case CONFIG_TYPE_INT:
-					ce->u.value =3D strtoul(args, NULL, 0);
+					errno =3D 0;
+					char *endptr =3D NULL;
+					long parsed =3D strtol(args, &endptr, 0);
+					if (endptr =3D=3D args || *endptr !=3D '\0') {
+						config_errce =3D ce;
+						err =3D -ERRINTFORMAT;
+						goto cpf_error;
+					}
+					if (errno =3D=3D ERANGE ||
+					    parsed < INT_MIN || parsed > INT_MAX) {
+						config_errce =3D ce;
+						err =3D -ERRINTRANGE;
+						goto cpf_error;
+					}
+					ce->u.value =3D (int)parsed;
 					break;
 				case CONFIG_TYPE_CALLBACK:
 					(ce->u.parser)(args);
diff --git a/src/ulogd.c b/src/ulogd.c
index 4c4df66..cc4f2da 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -302,6 +302,16 @@ int ulogd_parse_configfile(const char *section, struc=
t config_keyset *ce)
 			ulogd_log(ULOGD_ERROR,
 			          "string value is too long\n");
 		break;
+	case -ERRINTFORMAT:
+		ulogd_log(ULOGD_ERROR,
+		          "integer has invalid format for key \"%s\"\n",
+		          config_errce->key);
+		break;
+	case -ERRINTRANGE:
+		ulogd_log(ULOGD_ERROR,
+		          "integer is out of range for key \"%s\"\n",
+		          config_errce->key);
+		break;
 	}

 	return ULOGD_IRET_ERR;
=2D-
2.48.1
