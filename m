Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9711A1E5B71
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741806582; cv=none; b=M5ec/9uOym0Py7jmAKS7axxVkphF3mAi6l0wSTRzMA0kXTRxy4pKS8CSduOBrpxJLQXbwMn7zjVbMVLu3H8eYvLNiLCuroJbvWGgUn7d0rHl3wgP0GkzXDx9/JuKt3/3giqKMWupIf3Vz/eSdOiw1uS6w2+3U/171ghadI/AglY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741806582; c=relaxed/simple;
	bh=vQCuQ5v6h99qhak+EIo1KB1O9bDLf8ss6Wi+vERTJak=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=MRDs6GzBtUMMurNzTBX/Fqf5k+oBVdJG5WradpcCnGlLrHTJAvwoEDdW0zr9ts0GGB0E17T8KfZ92hcQFhQAjq0WNjwDA70M2gw954eKZ6P258IVbXuUbdhfss6dZtCQi7bLd4fJme4UGDcbUafalpV7J2g8yNOTWNYicT0BkWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=Nsrh/PLv; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="Nsrh/PLv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741806577; x=1742411377; i=corubba@gmx.de;
	bh=Xfv+BBwe29CfZKO0oB4++Bg5KSYrduHmosdcdCZdzHg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Nsrh/PLvB7bxEdNXxOMKB6gRGlEiXyuArBT41Kd1ISVlemIzRe/AmZ0LYdrQ0RUx
	 QmIMSNUbtRuXajKXQ6BBBphMNCntOhmZZ5GznRtq8bn/zP+ztDRvYvgHb4spEej7P
	 7v0whPxXPcJbglJRD5HMDbQyy3fkyV9cGntINcPU0uz4JnvkXf8IjkWpFWBYABFne
	 Mq1HBavJFJ8mqUHzvnYCqI9x1l0PZ2S4gVCs3e09JufvAKWAd541DjjkfNEaWAGl8
	 5gaNgSTKaZj+toPNXXxyvWCV/pgJXjSmmp/JXT8E0Q7rmpemTaGjnP4kwtOb9t9Od
	 WDAYo0Pj8M00TFzl6w==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MtfJX-1t50P82Pd9-016s4B for
 <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 20:09:37 +0100
Message-ID: <24c4bb1f-35a6-4595-bba6-40eb9f38da37@gmx.de>
Date: Wed, 12 Mar 2025 20:09:36 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-CH
To: netfilter-devel@vger.kernel.org
From: Corubba Smith <corubba@gmx.de>
Subject: [PATCH ulogd2,v3] ulogd: raise error on unknown config key
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pkTCruJotNG26avHRTtgy99Rj+In1i2ST3r2cnptyPsrhBLGU8t
 IZfKWO2O3i+d8Z/leytM5QzgOO1XGUIsdwoseCvw7HGw6vcFXlvJOxvqDhK5Y9s/M6W9mwm
 uP38y9RWNrBuaiFkzonx7nMXMou94EX7b39UbicUoTGt4jZ6AXnllZowzvDVwJFxmvezJDo
 ik7733udxo4WlRCDB13Bg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/o3WpV5iOpA=;7iRYa/GYspetS3SIcBPcLKyMgED
 1yjL3VRkaGFkJ8lfYWxXFgHlvEjg7qLI9Yg2KBFmamFAn8rivqeVC2ozaP3QJBNl4d5EZetJ2
 8YfXSWGZDXfzkGQJhA/MXuARMcTVsNbjk2b9EU4Ksos3GOZzuemqX/c+tw7x4zHio6VCaLAar
 sqDk47wmsOVtg0AaOUhr8IH43+q68R1HWpdz+PW7Ty73Dmn0V/TXokqdVuV4Ulw20HXs5ikQ4
 Fts7HAGvvYcSLJ/WCkqNYLVv8KiJz/mh5paarPQhfMjKoYrxgm1EHob6/xlquqg6be8O1nkkZ
 9s7rf1T7YBVU9MzNGqXXKPaVA6qQUSFJ9+xN9jPNuklwyzGdJe5QX5u95Ep4xWBFgM4W5T1bx
 OvLmXjv3iztvKiyyxJgC/rfXkLupVnoO922Uf4s9q6O8VT+q7RPS8LHdnfvvbeMsTsOyV1FfM
 12IKkDhXCmpsU7Z88mydzxCH/ep654T/95GGP9aq+eHuuwPMyfUdNMjFjRDJxenQ0XkibuwgI
 Ubr4iiRyFfOuzhSfaUbUCIoHcVbvCMi1BuOBOkiJUedfBbgZJOwvqgmgsWBf3UGh4DC2nJGJh
 3N4NuFepNnKzlPLog0LGQte90f7BvDbqoewIEr/FjuxKzz+rgLWYFK8gtdDQ1M5ZDAepKYFyK
 pmQX+l7lDAuM7Fh58roRyUxbL05lLvbeHociSt1auj+sRdAmk/pyX9eqt+2WUqTlTa+/evsC6
 sPcsfHj4CuTIgAK2Vf13KYM+Bs+cM5xj7mp51T0tEkNVqKx3mW/gBgUdz2MfzHvMnSKhF0QIJ
 xEGgo4AFv3Zzwy5vFJhxaT2aPMH7Z+LzF6tUhvz4mZwSs9mqjzjpO3oeFIJ/BF7cePgsPsJ7t
 46i/ut9dgkRqvjKU+p3Y4Es7d9/jkltc7Mecj6D2P5WESzirUWDUhRRTIuhwRa6V4eNr78KEn
 V8lCpNP/M2jg2L8d4FZVV9GHxYZkyBH6ttDjXhtuKZXNCYluFYJrAkLzwvdmQdF2RMuYyPtTz
 fjCvBrVsa+dA0GC5mUU/mEIata9dpzo/g432+XA02R2JJN9vzyqjnPZYzmWxL3VwoeYZL9mxA
 ap+yiQnRPdc1VEk9bUkVvy2+oR9jzliZOzD0pd9awhOzkLCythGN9rmDR+C5mu9F8yc7RbMQE
 r0JtM2B4xU75weiULr2F5Tg0bL4V+6oqv1jb8U4mWy4hweY7gG6mQjbSUP/VpniH6kVySI8bk
 z1zZ8qBCqwmXAKnSmeLhQpkAohvIj1+DhE1SmDbTqOhyduVYD4Cixf8tIzXq4r20Wi+FwxcXv
 MiqeWxwpVfqJ9cHrxIGFjLN25hdrqwvHTwTil3fd0BR8/YeWUpCl1lr6BjJrez6rNZk0JxP+f
 1cwgMcElU6qf7/VHqQN9zYMYYQqimtqgIbicNw/fn+gKq9MB9ZJRuOUXCxrJ3WnhKK0jT5tnu
 TW4s1Pq4HCZRtaXesuM0qocb9Dlo=

Until a6fbeb96e889 ("new configuration file syntax (Magnus Boden)")
this was already caught, and the enum member is still present.

Check if the for loop worked throught the whole array without hitting a
matching config option, and return with the unknown key error code.
Because there is no existing config_entry struct with that unknwon key
to use with the established config_errce pointer, allocate a new struct.
This potentially creates a memory leak if that config_entry is never
freed again, but for me that is acceptable in this rare case.

Since the memory allocation for the struct can fail, also reuse the old
out-of-memory error to indicate that.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v3:
  - Rebase onto master branch (15b89e41a536 ("all: remove trivial configur=
e hooks"))
  - All other patches from v2 are already applied
  - Fix string-truncate compiler warning (Florian Westphal)
  - Link to v2: https://lore.kernel.org/netfilter-devel/1a5fff4d-4cef-48e3=
-a77c-bb4f7098f35b@gmx.de/

Changes in v2:
  - Rebase onto master branch (b9f931e2f30e ("nfct: add icmpv6"))
  - Renumber the patchset since v1 patch #1 and #5 are already applied
  - Reduce indentation of case statements (Florian Westphal)
  - Link to v1: https://lore.kernel.org/netfilter-devel/ca5581f5-5e54-47f5=
-97c8-bcc788c77781@gmx.de/

 src/conffile.c | 12 ++++++++++++
 src/ulogd.c    |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/src/conffile.c b/src/conffile.c
index e55ff30..f84fcf5 100644
=2D-- a/src/conffile.c
+++ b/src/conffile.c
@@ -256,6 +256,18 @@ int config_parse_file(const char *section, struct con=
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
+			memcpy(&config_errce->key[0], wordbuf,
+			       sizeof(config_errce->key) - 1);
+			err =3D -ERRUNKN;
+			goto cpf_error;
+		}
 	}


diff --git a/src/ulogd.c b/src/ulogd.c
index b146f94..917ae3a 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -281,6 +281,8 @@ int ulogd_parse_configfile(const char *section, struct=
 config_keyset *ce)
 	case -ERRUNKN:
 		ulogd_log(ULOGD_ERROR, "unknown config key \"%s\"\n",
 		          config_errce->key);
+		free(config_errce);
+		config_errce =3D NULL;
 		break;
 	case -ERRSECTION:
 		ulogd_log(ULOGD_ERROR, "section \"%s\" not found\n", section);
=2D-
2.48.1
