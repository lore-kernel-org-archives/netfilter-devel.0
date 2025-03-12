Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF0A24EF69
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741791286; cv=none; b=SrKThPU9QnR71dbcPs4jY9j5JYkeA2I1rkErUiSLhcwb/JKFaxr33JeLEUcN4nfLAMpEOsi7HZ94nDEFN7HS84+cASkfAMUyxVngqbH/79uAbUY6TF6F3H7vjdckapoGbgO0Msd/Ew65f2M0+a/H93oEV05uB8PZjfbhATEvuEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741791286; c=relaxed/simple;
	bh=Z/cUth0l6YIHNHbxYyoY3WSzOkHGLvD79gfxyIRf7O4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=g1OZY1j54OH+5DgIPe041yCxk866cLMKkjMyfYybZM4AOIOGkCB6Ql7eY1hZ96CzLt1shLfqDyKKZE1+ysDjTgB+w3uYgm7xRRtbYI1N9DGD83I1R7vK58nOLzPcIwsgSn1j3Iu2YJ7QWZTFfhvxisB6v92er410AWTsrv5PENY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=ImmOZIXW; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="ImmOZIXW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741791282; x=1742396082; i=corubba@gmx.de;
	bh=44lFVfB42Z6lqlhZsspgrVAL6wSWdr+flVq5SYqsPxw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ImmOZIXWlcJUP4wsdVFGHy6row0NNUzBkTLhVvuDvj23bU2470eVuTRbVrCzc3M/
	 5Kan/tbF0xJYBGLBmNNOmrTeizR1zreplf+VzB0tv9QjOPW8rBMtvaaXsmnDChMn4
	 QoWQp2G4NWuvys/o16fKG70akez0ahMazEOQhWKQbgP/SBJbRlQd/l3PZiwKOYvG7
	 OQbG7PBAPgse121gVODwMAEmD64hhJclcZ1a7fpN6e10RJ/ZJEaiVNP3nekFnxW0G
	 Ooa1cUOp7XLPVVZ5BW1gFFHQvB7oVhfg6Z38le17OOEYYUuFDj+uXzGYNVX/muVIu
	 wTJo6jegJch3pPlK4w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MJE6F-1tdKnq3SSh-00S407 for
 <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 15:54:41 +0100
Message-ID: <e3965ebb-b9f9-46ce-87e5-4960405dbe35@gmx.de>
Date: Wed, 12 Mar 2025 15:54:41 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2,v2 3/6] ulogd: raise error on unknown config key
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Language: de-CH
In-Reply-To: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:T+TPM+hXg6Z6sAx/3j3K4bt3cFlUj2GuCIbsd7qcjLDw1nEEoeP
 pAeUKgVBqxkeO7kGjrFGk1Oir1+nZd+Iqt8SfoOPt7+ZC3km/ELZeX82usxGdX4dUEZhfa4
 y/gT0yPC4o2MwVciMtoDy2SRRwbH9GqUXc9k7be5Qfh0INJiVHgiHNZcD0pfO19nFNkPRQ9
 BsbUi6QcSo5o6ynwsKIRQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:w7dSEJvoEOM=;EZQHPONX+alQgzkxIqyOvY2QPYN
 Td8EJd6iOP/cAmNZJdTZcAccPR5TJnXrC03p0Gj6Q1s582tAAjjIeP+9cdbCqP0fW7+TfIKIg
 NLRgFt4qQszVCcCtnMEcmbkdqeLNMltN7L65IU/c+nfgbUO8Io1GIdO1H2F2qPFFf1MVZQeN0
 ALRdAarzZgRG21MkxchFxKUs3tH0A7z7XUxnZvAhtYlJD1dD+ebRp/+t2auYlSbwc/zL9DPct
 naCldGqO1904ycK6//cn8vUJJU8DewM7RpMw+3mb389pDHVadMUJPsZUpNbH7DJSgAQlrgNLh
 FSEdiLxuGP1OEdAMg+6ww4d0JsgTov2y7gSco9u5Sf2Gu4JeVrMjDquBUIfYou30JRb4NAZsZ
 IwCWUfjqHPTYPGNgJD0PccmrurEI1lHnYIOSjsvUVOd3H2bhBzitXZ8Tv30gvAXQRaBUG2JZ/
 BZcgwhWp9aDDS7BU8pH9SG3q1fitkK/fYTYr5JpN3o6P5E4PUjBWi0W8vFOskNzC+nYHXTkLK
 eMu381BxaMDJMfDXFDX4IyVqVembpOktPTZ2pv6Utnz77/3vc5a6SDT+nxkAtnl7Kr9CJfJ6t
 f6d8yJqB/Ed2FH374uERWS2BJvSFBjnSzNF77Y4Q6AQaTAWkJq6zc4wNeIoI4u5brjG560BCY
 VMURLQAqhnQ04Hn1SMKmh4gaQ7GMWN0bTRzj8e0+yDonvZdzn57NlKK+JWinR4kiruxDmWO76
 aX7mZlnsvhO2QAnNugFdXTvvq5M6JeFQ6AlRKqcn7XTpSUdZiVF1tlHzx1CSV2klI4dr5IwpW
 2y6puIEDbhuytpu49a0bHgQzDbZMbbViIzLZ0Mo3GTQaHY741BlXRqM3D0u8PP0n0CZtS97fQ
 jOYF5ZmVM0Ap0WUfpDB9fNXebr/2tOJncgENS0AQF0CmyQNKViWYmZQDd9eU6mY4WPbSQxIVS
 lZ+RhgxAnxLJg15B6In2UK+gt+urCHlTFQF8FSs3+Ni1GlaaUNDWzQ7ESlosFVAngrxMSYxo6
 0iHRwVxrqqQBRpu0aEDC/brf5HkuswhBlwoeqcVzriY6tYzpmJTB8tGqqGL93+O2Uv3bD3/Pe
 qxbEyPptPahf9uMmS7J6GgljebysTDKDtVOHzQ/jRH7GdGC9DBsnoIfQX64Oqpf5+U/p6hxsM
 F9IkqdCr+mUWG+6Yg8PooekYkcxAJaSjc94b29yI8aL1rxuvGN6qxu6DeJw8YHEi/HNB1Icym
 ap7YSiKS0CF8TkK6bCWerkY9mKGBZlODQECarS5ONYCorFQfCi5AnR3FUr6vWilUl9Q3d0+fs
 HZrXwYK8yjQINImkOZBR3/hvXdwJLaKbQAMD/g3QXUiN/GK57TlKbqtf7i+mhlIRL02noOKuY
 ukk4EfYQ8zmlBfY+wKLCEe3HimUtSLCuKJLzm4PfRL3KOQdHnkuN626/+RVB6Ev51X/khPox+
 qwHV82LIgYQi2XzeiAwvp+8XwJ4k=

Until a6fbeb96e889 ("new configuration file syntax (Magnus Boden)")
this was already caught, and the enum member is still present.

Check if the for loop worked throught the whole array without hitting a
matching config option, and return with the unknown key error code.
Because there is no existing config_entry struct with that unknwon key
to use with the established config_errce pointer, allocate a new struct.
This potentially creates a memory leak if that config_entry is never
freed again, but for me that is acceptable is this rare case.

Since the memory allocation for the struct can fail, also reuse the old
out-of-memory error to indicate that.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - Reduce indentation of case statements (Florian Westphal)

 src/conffile.c | 11 +++++++++++
 src/ulogd.c    |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/src/conffile.c b/src/conffile.c
index cc5552c..7b9fb0f 100644
=2D-- a/src/conffile.c
+++ b/src/conffile.c
@@ -236,6 +236,17 @@ int config_parse_file(const char *section, struct con=
fig_keyset *kset)
 			break;
 		}
 		pr_debug("parse_file: exiting main loop\n");
+
+		if (i =3D=3D kset->num_ces) {
+			config_errce =3D calloc(1, sizeof(struct config_entry));
+			if (config_errce =3D=3D NULL) {
+				err =3D -ERROOM;
+				goto cpf_error;
+			}
+			strncpy(&config_errce->key[0], wordbuf, CONFIG_KEY_LEN - 1);
+			err =3D -ERRUNKN;
+			goto cpf_error;
+		}
 	}


diff --git a/src/ulogd.c b/src/ulogd.c
index 51aa2b9..4c4df66 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -285,6 +285,8 @@ int ulogd_parse_configfile(const char *section, struct=
 config_keyset *ce)
 		ulogd_log(ULOGD_ERROR,
 		          "unknown config key \"%s\"\n",
 		          config_errce->key);
+		free(config_errce);
+		config_errce =3D NULL;
 		break;
 	case -ERRSECTION:
 		ulogd_log(ULOGD_ERROR,
=2D-
2.48.1
