Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7C2190470
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473398; cv=none; b=OWKWKAqWzUVBc6BKKe5W5wlKu+k2VPlR9cbhl5aWMfUzjP1+H1jtIYsub1+X4tJfQICih7HRRu5S4s/SLAbjoJRkCnWwjpLJE0MnMWpQ69803/6nW4DLnjPFC3LXJTt5+xzbYwqeI6v/k87OVWFo8efMpSoKPkqNekvhpubshh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473398; c=relaxed/simple;
	bh=Sm4hWO5x3whnKaAdR9QSuNLtIbHxYD05Jblcg0FEMXU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=BPcnk3jHqjiJfvU+icXVjmVwtzau/Osk5++Ku5GwFNHnYnCYJxRg2rAozB6STZUHEQHhauY+9iOaLE2DrgvKmDGo/8VXhbemUSU53D3UnsCDVfkFPIWTcq0o9nKPHqxec6G7FdxwSk9CZC5vtEqD/KHI601TidUCjLIQCXMMt/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=RNSog4mY; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="RNSog4mY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473394; x=1742078194; i=corubba@gmx.de;
	bh=+nCO3fM0s9YO2n7lCmXxKRvh18iL8OFM+BDg+gSMaNw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=RNSog4mYjuInwOYsYxqWnoVgFNRl6E7o6/U427soalBB342Yz+8hDboFIFmRtP/M
	 v63iEkaFtpYl2gIQbo24NUf+q8l+k3ybPioxcEyJQ9OO2mXXYffCOH6f3bZ9Isp+o
	 wdg0EuUEwbZHVzUD1ygg4nZtKnjdjaz2FG2rewhjmT3XSrhxcDFsXg4ldUoP3bdSr
	 KlO9sF8+FxpLBGcKUJNBcs/HSFXyuollEyrZ/MpnPHH59Km4c8aJsi59m5EogvVB0
	 DgQaoZdXoLhgcyJNtqv3Z3GNm2FFFBk2aFT96cEgrmMNnYS/iQ5fvygq+W8NacvOa
	 0Fc4xcCAZgV7hNindA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MAfUe-1txgc603fk-009Ppa for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:36:34 +0100
Message-ID: <2e368f1f-e6bf-4820-8b30-0a4dd3a3deb2@gmx.de>
Date: Sat, 8 Mar 2025 23:36:33 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 5/8] ulogd: ignore malformed config directives
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Language: de-CH
In-Reply-To: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4dXWnlWNvQ66gYCcYQXnH1MyDtVNpQNpB6y3ivNWaTU/zV2DES8
 JVjDf5FcXInTiswSjAfc3ZcbD/pnIiL8SI4XLZeWR14kO+NWrSup7P4ZhT7aVBh01vrTm45
 M495OUAG8pluqUa+6UoO+UM3be7ceq8+srL5Qxh42IyPLFfLT7Yvu/e6OmdSMg324dwFvFX
 W4VlDhO7IuY7WHDCdpHbQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gtxfAOXVMNY=;g1qNuru9Zj3kCs6Sn5RKDsXqRxJ
 UK93PAuNGMvHK5h5z0m5piZzqsierN1of60MDGAp/FVm9mlU4jJyQTQcaZWLNAqtn62t7GvBU
 7guL5mmrfZUGrl7W9H312IrMTBHfxD58N+Dm8fukOfGD6wEt3IvIl5f4//0iOcMK5XcW15i7C
 SYowf8kbGQsZbC7+x65wo1Ams3mL3DiXFegZWmftqwd0yuiLZrhucU6Ys9aVQJtUm1DV1gatf
 RwYbMmJsVH4h2S+6anT2j78mcKagcXIWCycZXTFR+jggH/rZJotJntvvQBiVfp83gtzXuNEjx
 zmy4SWsKxsBRg6W4/d7HIykWvk9dJDXRAJnMoSeAxnI0xDeNUeddLRsADX2uxaVUc80b2j/wI
 QHYV8NxL9NvqS+Vqd046kbOmQu8Om/mfxh7olZVrOsvROC0faxl4QE5L4hIeeTs9/ukpyGBxA
 kxE0whO1xeC7rIu8vMOIbaiQz2y0anUo72zP0r2KyQn+3R3201xBRgDCOLE14naTlw2+VgIFj
 g+80D3duAO+ztC1FxHlhOmgODNZNAPE0F+BduiH7CV5PACXW30fqk/VGSPyX6n+nn3KjKv2Gb
 NS4PekACRaiS+rfctju6xebVxKVZgsl799hKiPu2HOiPIPbSS/bH7zHAWFW43o5zVUDCbcBA6
 j5mrrrHmikLe8UxZzYW+6zl7QfI7IjuVg6i+dBdmvTWIztRtoGvGkpi6Qv/em8oSB4EwH41AF
 YAevgJxBj5AsUCcd244dTzCkvMkrctNh20dqwEpQeAkmDL8CkQJ0rQIjkrQrvx1N1NCxZ096J
 oDziUb9zZPXV1Yk9Llxfm2swuaLGvyVZb/RsBk1TIN9Ph3JkTbXKI26YQkrTnhiyzZbC/V/da
 +0MJJgXZ1r9qJdbGY5TbWBOBFthI6B3ti4neToxX/yixO1J6JDuCrkVOKyU6Zm4kqnATp5V4j
 +s5XneuEaaiowGirD/7D00mSl8gRk4EB0alCLq6+tltV+XUxiEofX8tCmKsh1qsi7Vekp2D+e
 fLXezzdH0J2167MLyh9w5/qi5NF+k3Yhb6WUfEo3le344w7cVGoqQvyoYIYWf52QTr3wjF7PB
 HQCjgjh9dgO1xLwnZ9jqGj8nUhfCiUGWu4ibNpZrgrHSIGxboHwD1FRfBtpn/WCmesD2Q2Fmt
 gjK1cLlUWIyy/adcv/YZup8K6uY+vj2xWw5C8a24NCuPP8Z1n3qR8CdI2cnMPnICTXFJwM5ET
 +nxQtlKTGuy6unGhYauqCS2i5tKxPM6xfnvJiGcARgS30aCkiIir6+UL+oWLjefnqsw/6C/MO
 DF3L25YBu74R5uwh6bUMnTFIsUGG6x2tB8Lkcr76QWDhlMx+yajkcp+3uwadpzzAHfsASuDqO
 AQBnC8DCtsNTduLncJFjikDW6J0EHmWwL9cKvbtfOX02FlRLOU93hvwArs

When a config directive is provided with a malformed argument (e.g.
`loglevel=3D"1`), then the call to get_word() returns NULL and `wordbuf`
is left unchanged aka still contains the directive name. Unlike the
previous calls to get_word(), the return value is not checked here, and
processing continues with `args` pointing to the still unchanged
`wordbuf`. So `loglevel=3D"1` is effectively parsed as
`loglevel=3Dloglevel`.

Instead if no valid argument is found, ignore the directive and log a
warning.

Due to the way get_word() is implemented, this unfortunately will report
an empty argument (e.g. `loglevel=3D`) as malformed as well. Ideally that
should behave the same as `loglevel=3D""`, but I found no nice way to
achieve that. An empty argument is only useful in rare cases, so
treating it as malformed should be fine for now. That's still way better
than the previous broken "name as value" behaviour.

Fixes: e88384d9d5a1 ("added new generic get_word() function to do better p=
arsing")
Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 src/conffile.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/conffile.c b/src/conffile.c
index 96eff69..7b9fb0f 100644
=2D-- a/src/conffile.c
+++ b/src/conffile.c
@@ -198,6 +198,12 @@ int config_parse_file(const char *section, struct con=
fig_keyset *kset)
 			}

 			wordend =3D get_word(wordend, " =3D\t\n\r", (char *) &wordbuf);
+			if (wordend =3D=3D NULL) {
+				ulogd_log(ULOGD_NOTICE,
+					"ignoring malformed config directive \"%s\" on line %d\n",
+					ce->key, linenum);
+				break;
+			}
 			args =3D (char *)&wordbuf;

 			if (ce->hit && !(ce->options & CONFIG_OPT_MULTI))
=2D-
2.48.1

