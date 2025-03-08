Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC5B190470
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473334; cv=none; b=Nd39RYzq4AerZpxxhRtLvueKDyfGskNxG4jdJl/HRZFuRgTXRAQj5yLx0S11VI3FEDImmTv0XFKqYWpI0hJDnbKkkBA2kqy/xQ0tKQ70Trf59rZKcfJB16q2DZSvAZo2mK1ni5tS0Z+/74UW+wqwqsc43tQzHP2aqtRGab/zLqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473334; c=relaxed/simple;
	bh=i2zhu+2s5zXuvsXQ/W0QYb0H0/9cW2TPzn8nXooedVQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=C2p01I2cPb8DDjCIcqQ2kGE4sycAFhK/bnL7132y70ziIqIME49YxwegPApy5bCU60TlisFTB2zP3bWvfh+X0rMS80CvlNXGM+6i0C5vnW098BMzOISwr1zJ9P9y2X41Bcuc9mlXZ65Do678dioilMhwItgaVjMvk/PpikiXbPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=SCi8uv4r; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="SCi8uv4r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473330; x=1742078130; i=corubba@gmx.de;
	bh=xaNkBryFdZf/drGHm/3V39rYs/yhcd3K/QgXfFQ3CQ0=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=SCi8uv4rAelJqZ1+eI/Z8fNMHrFU9RToB/72Uit51T0LP5QFEuV8fz0LfpX0ZGsD
	 s48bJt3XPKTXzWug32sa3R+T/9cziSIiNqaBV/xFmuBXZ0D6FO4s6gvdSTQVQ0vq5
	 R0sNbMeP5uESYcTPRPaDL98RRNoRwgHTqyruNt7GBcg3xtex4XGiiuzRuEYrBSUiB
	 WftJtCieHXj/5PydbKcApv8fJFNAy37zIisxjudrdeqNt3Bj1JUC/B0sIrXAP4rmI
	 aCyOpRtvnTnf0zbPdFscQLyh/LMhA1qMoewGilN/k+6DA9nLYeNq7REbGGGeuNxsm
	 JjsSJLXfPgWKsqVRzQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MryTF-1tU8CV0iCT-00aaTH for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:35:30 +0100
Message-ID: <e8c066d2-0bda-448e-b8ec-452f5c586625@gmx.de>
Date: Sat, 8 Mar 2025 23:35:29 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 4/8] ulogd: raise error on unknown config key
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Language: de-CH
In-Reply-To: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FnFQBG6rPb4vLYqb8d2NGOVLSFx8BLZV2agDWU67fpzhSwfrCMM
 vkBd3ZTOhqOGjz0iJ96lu/HAIdiUgzyDCkG8Gf8P872hugPM7LZkSa6UwboDKMoie07DpMf
 3tGk1x7TcRYlIq5K/8SMkWHb6wFSupGnOTSXDWC1vaDIlflwhme3cWtH7acE/F6gx/4wKc/
 v0+HqhssEEmKeKjXbGTWA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ann/iEeLnlg=;odqVjqVXyEguWXMyU6yQaY0JF+k
 qJhDkzMmMtmRX6Pcj2dB8HHH0893vm+lC2qq+nD/YdFMmB5s5BEObSYKGALHPvG4znJ1vPPAA
 zkYuu38rMwfZ3HUnjPfzL+/ud4yiRUgYBjPPs3HJQnKECJgd3LT0o/B/nVMyIO6/ZXOiDbGCk
 zhGWzcVATwgMleWE7NgAQaqeCAfYiO8W0yeXAFRPrndgPqaodiEtI8usvsqHIsHNAanmTxekm
 IQQO+1cmQVWKn6zAzvUlCu3ashor2Fz8229rVci7xDdxsx5JNEq/6x9xB1if9EVS2iw/Wfg94
 2G67VlDMwOXGyvCF8B2XyV+BFgrF9ofvbU5IqvmIWRZVpzCfDLM9kQjjj7HlPzFHWQF16p2xU
 w2QHoavBskmHLsw8porsnBOwGx8gvIyHE9PWb8OHB/fwLbwqdtWYl9xGeFGz97STH9zccroOM
 vL3pMdqb7RQbebelqLSm4VH3Ibjd2moWoIr2H7bI6kqDkHDde5t+TWjwhlKFEt+FRbW8zva/q
 2b4DHwnQhJmYLzm3e5RYppH5DPa1kfmDJF0Wt2keBXF9k/hLmrfbxlZqNjuehc/+FKWnC7KMk
 fbuAR9oHVuTZVkNzjx8xcCMn5MzcgVoegvNCXkovBXoLQ43MdMIF9ysp+/8UPQoVvoGGFbfUj
 0Chyg4yFT0vWnox5b4E0X04xnZnc7Kg69zLlIO6rIeOeCZm40wAb41maIEB4Oturn2NnpyCKa
 mVbnNHYs5WLLlaKJxbnGgVDbd9OY9VGP3tq3YBoOxg3PkIPvz0VrbDwigM5La58c9Jwnvc3vb
 ac3SlUybScDQVYC4ax/t/AFcegBD9mMU5s+ZJ2Zwcn8UQarvdgo/L1HwWmjW/0EqH6aT9U+m0
 WUeF+c7FDrIdgtIvvUsIyNfbrWOaIF6bD/R9KXeemr9fkMwLayo/qet3rtQUoD9zorQNCtX+l
 kllJnEEfGNf731c0fJ7MCNHmxljsZNlqY+iN2PC9wxPI3SmDV1lHY1WvCq1fDs+UWSv2m33wv
 Id2atA2ACOFHla8IXaxcym34hWA9F2vVwMlA65WMse5iSqjVWMa2VrvNeWgY2rJlhFX37zyxH
 GgZGYX2HWzawnstdpmT8ymAaL+2+uI8jgZcok1mNV/nzBfQbYcfYoOwJzmvaMBgKrns7LOa47
 nfQN84kvTXTc6C7KRLPw5MiCtqWP17z2qJgsmi6c1L7yrZ7MYRm/DfGN/Xw99+WeKEb2d/bIu
 OOUfkiov87mliWg+G84LRc6y/18ZRr1lx0gtougElxr90PP61aSwE7DqJv2K1YwSmcjwDW2Iq
 rkBrw+DtbF/C+dA66fae7z/ltu0feTdz/LtH4AHVGmFUBTtOrpwDydkbQQo1qK86akimIepIg
 wKVzetb79KZmyOWPqfhemtPyFcyQqKOHcBQQnbM0Z1Uawg1TXmMxYEN7Rs

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
 src/conffile.c | 11 +++++++++++
 src/ulogd.c    |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/src/conffile.c b/src/conffile.c
index 5b7f834..96eff69 100644
=2D-- a/src/conffile.c
+++ b/src/conffile.c
@@ -230,6 +230,17 @@ int config_parse_file(const char *section, struct con=
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
index 80e1ac0..96f88db 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -285,6 +285,8 @@ int ulogd_parse_configfile(const char *section, struct=
 config_keyset *ce)
 			ulogd_log(ULOGD_ERROR,
 			          "unknown config key \"%s\"\n",
 			          config_errce->key);
+			free(config_errce);
+			config_errce =3D NULL;
 			break;
 		case -ERRSECTION:
 			ulogd_log(ULOGD_ERROR,
=2D-
2.48.1

