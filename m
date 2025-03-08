Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317CC19006F
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473433; cv=none; b=TMWbdtrzf/q94bZOqusiSe9WKKLHYfvFnmujQAzXw2xp89Oo7Z8ejm7imjZQRB47Wn1Tpx/+o0HPA/m7uL+YTf4rMrEmvg/xkMJThzHXGhjnQ9ZVo829hPYmeP8rdI7Q3ANf6gqP6EozgLLyb/NCC4NIPHvSqYFA4loh3Zio4IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473433; c=relaxed/simple;
	bh=4QOdNEB/a3O1Eo1K3+F5af7XOEwHw5/aBhSnbvTkIT8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ZJFSpJBi744cDS2sgkyxugjQ5D1gKRAOzJDBm4/LjpsZnwkk33bWCPeekZCfvSJInwu/9qOf1YS+S79/VUe7XLxfVWAZeEmxhWcYnFcx3xop2zV8jKst8cYF1qHoNhNEscbz72UgeY0qskmgJm/w3QEgq2Dl5H2tyhfojYcnJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=QXgMAQNA; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="QXgMAQNA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473429; x=1742078229; i=corubba@gmx.de;
	bh=annnr+hSDcJyND0bOvTio5rwkd1lstVeCkDVPGqT7IU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=QXgMAQNAE2SOBavxqW3KoLc43lNwzUuwdHTZ1vo6JZznrnAFWD+QuDKTx4WP+C1G
	 ROn3/feeNUVOVntMV214Y2qa4NF/aC6Ax/utPFd3QnTMkA5bzz4HDNH/FUsphKINB
	 Cx0MVBQfgyLvyoN+qdDi3p+m6N0HJwUFq3cuqK3CSm8vcR3lZOfrzwmOry4CcBRHh
	 p1SZ7t+r2xluBvu6oh6eI/Cy9MULDEYbBAuEEdsshis8RSaROQ9dPxivAxo4AF3Q4
	 34MqWnlimpBxDclAl8W/nytXrOO6iA+K6vBWYWCMRTnYJR1LJOWDesZwVOfoZ9PZi
	 0bqHPWk4W53iqRSlPw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M26vB-1tp83A1cIT-000qX3 for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:37:09 +0100
Message-ID: <47d10112-1250-4ffd-898a-32e27b91ba94@gmx.de>
Date: Sat, 8 Mar 2025 23:37:09 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 6/8] ulogd: improve integer option parsing
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Language: de-CH
In-Reply-To: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JPCj8oYw7DoZDUDIqb3Lxx2uDS2E38l9qZ5VHwteAaDvHioS2z6
 b3YoW0AzNgTkIJbG8kvcInx1rHdtKZRMmNa/gOmwVxL98U9ebhQ57N9EXzvybrT5ImSfSIy
 +5LkVstnknROJYwHbZ3Zxdv/gDprf5GDpzo6gyWHn4BcHj9X9UNllQlAkmh87knsqglbzpY
 IGISUj5kPHYXN3M2LGkbQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:A7I/EFwPNDY=;NF1RM5V1Gl0DKO7ujHP9khbW+zR
 +lttzh1Frszg4emdY410C/SUB2JffYiOpBt4d5ATBox0ohB6SZRQxJhaR7NBKNR7UwLGtQQ5o
 NpnGJNcbfhWWWjxpdhcgPz+vwz/6MwNeBDDHL093O3VOhW3TtajFbJyip0YC3PaIkXSKvp5AX
 iv22iazqei0ercH+OaA07FHPDpcApMIID3i8RiRqYLltzPxL3myg00PZIL70Ls4owKhplo4z2
 Ar8rEPYQ0lQSYguZFZV19aKj+wP7nMNiUVFW9BpLyPZ4AO8VV0GXHjP5dQ8E5MklDN8he6Iz9
 FXq0DTEoKTXbFx4pbIDihROEMTe9M7hcfrCR0oGINF/Mkl98bGT9oo8pxOwXj5xSA0wrzIhN7
 UYx5F6ipwZ5ZWvK70wrjaBoEkWiZCxfhPKDLL5ZKcyrIyVcEGnK0htn+lOjB0ixL7Sdi8U6i+
 8wf881ad3ji1lbefvwYffa24fpm35vPFLeeZjQ0Uz2vK8gODESo90hMi7RXteZVDRFxZuWm7S
 qb+K7iwZZ4M2IeTBHcAQ8CxccX+oKUcm0+ow7vGjl5sjaZA+aEkDpjm/GjKO3M2toLv3nynWT
 anJQVuOlW3K/ZVIzaSWowuEgye1hy0ToHo+1XmCxPPRYyeojbMSO4liAxOjXYl1wfoe9ydxte
 fjy8yaw9w3JlG+way0ZrRMHbS14O4egRqPQTv9DxzbooXdBxc9NWD9COoMyA90sHLdOR1Cw5d
 tQTZiC/qaIC0O4xVZbnXO5HApk1VMQvtwOKy/9Anig3NhdPwYtM3H5eSlDybeX8pblIYlpiMu
 vUhIhEngLK1JCfrkOEXVwJu3Ga5SoOvIjmHs6R1JDcv0i/QuEGsBUjFBQmtHhxq4kjMhsGKgP
 ySyfjY8FKATKqcARAhAcQm9u1bNkSArhrDhGUFsMubai0vYkuHqO1w3Komxw6RNN0rtGdDNtt
 n0SUbKMmSF67zsO1KTWwtXQ6DEy/omkX6r0Z9MZdEK4Z/vKw7MckLML520Ew/N69v0+DzPeOi
 phBIkCRheuhrCYU/rhMA9WbKbSrnIM5ylt73UnuiivPCQQQzHgJ4S7TvdYrwpsZ4J8eBNt+t6
 ux0WyKwtMBT//IA8iswwpN9ypGyeKsRYxTxFkRkVeagwfKf7SUHQqPnlzhshcls+QEQVEsrdi
 hx4wML40Obx7eRjBQEfo6w+ohZ6MXT93H1uxIaWziwnKuzyQ1Hutw204rsPy/GgawT3SDxMjz
 lb2uaWxT6sARXUsbkHqE56o/BxIwHq/YRTfvyWgItBFT5dBiqnnQcAt8ZMfb7g+op04+O/3Uh
 rTPpWw3cW8EH054qzcy5mbOB2Q8PUQUSCo3JhhLKRT/IrldOxWT/VsPT5ZCsmro1DunrGn9wd
 QjsZsOQpp/mGm00rgGPuRXNPjRN+B3XzKND7bdlcnd1yW7qrMYqKU4iaTjpUiRTxa7y8voDbk
 OPY03Yw==

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
index 96f88db..96cea8a 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -302,6 +302,16 @@ int ulogd_parse_configfile(const char *section, struc=
t config_keyset *ce)
 				ulogd_log(ULOGD_ERROR,
 				          "string value is too long\n");
 			break;
+		case -ERRINTFORMAT:
+			ulogd_log(ULOGD_ERROR,
+			          "integer has invalid format for key \"%s\"\n",
+			          config_errce->key);
+			break;
+		case -ERRINTRANGE:
+			ulogd_log(ULOGD_ERROR,
+			          "integer is out of range for key \"%s\"\n",
+			          config_errce->key);
+			break;
 	}

 	return ULOGD_IRET_ERR;
=2D-
2.48.1

