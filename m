Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FADC1AA1F4
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473501; cv=none; b=P8/WC6pO1+eJi5+IQ+SlF49t1JDODcXKgJiejXQ0xCZLLcVChf9nbd7wxx1pmjMq0w0/X3xp1dXh3OjpbWSJUM//u2/+MlDgyotGOSQVUg37qIw2wW1Y3KrycvruAkZV9vnJiQ2zfwhKfRnurPVSMQOpPYZz6phh3BZ1J6MIvRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473501; c=relaxed/simple;
	bh=iV8G5O1vD+HoWu3s7SdR1nzlZvn04FGu++VvPcKeUT0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=bV/5vx3iDkICrOjwtnD5sOuk8gqOsKS0JWwXH9fKjGnqYe1yMGbK5nmiMX1uDz1ajjJ2FIdPy0Uak7NVvo27R+4ApaH5ls0BINEkrfiiHBPax2Yvym9rw/8ul1+DKzEJILLVWvcXyB7XobEwNSga7nLe5vmdXaCiwWTzlRYdY9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=jcI0Eycj; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="jcI0Eycj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473497; x=1742078297; i=corubba@gmx.de;
	bh=4oCayn6ecfMbi4lHSRfiWEXOfgV2SiBxPCKK0ou0MsA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=jcI0EycjkoB9xnBHI10ss4wfImFb3nA3wvuDHOZhjGDs35eyFQFrXFnMq5PTLKQC
	 FxOy9o1t3Nf1QERor5coobUkb6f86+zrrLY4W56C9zOQmW6He/uXRR3uJvXsv5Waz
	 NnLf73ihT8b4k7+OSG7HZh+AeQFOEGzfe54uOoQnOPDkFTny+BylvJcfCrLSusCuO
	 T6uKir5I0u3+nVBMFY3SnUea2NTciaIcsnSP0PpPbcowgvSWviW5RQGTr52NEOFM6
	 xXOEMy52Jo5mKKB7ywlkgUslztbKpfZd595CApV63DO/eF7z5mw2z9W5XjEJvqGqv
	 wU9lkbp+PDPG38sGrg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M7b2T-1tsRRk0i1l-00CYWj for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:38:17 +0100
Message-ID: <33fac502-d6b6-42c7-94e5-a78adc0dc86d@gmx.de>
Date: Sat, 8 Mar 2025 23:38:16 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 7/8] ulogd: default configure implementation
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Language: de-CH
In-Reply-To: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5sYuxhiLf68FVjmW2s7e/6eiE4/NVn8amkCqqZKCr9rjVvGQv03
 ouNnr7o5smaeTTW7+Er+brLxEo/Un7QkZnqWrLmWbWUVxjLgTk0VT2RsBC02giCWDhecV0w
 AqHZuUkLxOlVVcixVvQNx+YZvv3+YndV2OQxVT5yWWvsf4LQ9a0Fg5nSZ7gwzYYktrtji3E
 inDMy4ElmEj0IRNAHc4pw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ONUj1rbzVmI=;LQATtLk4lrTaiKaDC1NzuZT7YWx
 XU0MMwjx8Vn1xuyQkrY5PxbogacziaUxbAHR8xMfoPRKbbKscysgHgJlOxMygtyVLVmo3cz9z
 GjWMraEYLEqJjFVnlFr85oSJUiIDGIyuHGVtozrHp8BQYvwn2R8YpqgrbEcm+ATwbvUJhO9oL
 zx0IBHnXhR4TQnBFytV1U0133ARsPPfCEfCTewDScvpgYPnAw1wig6baHBXsTHANCO1R9c9uE
 ss8Ri8vOCaEMkc5b3XosRl7seZVfkiWBciHhHP2MFfFWe5lu+UZ8r1nQqn+bUz3I/gWtrQN0f
 OX5zxVMP6vxv/aeYfHbxZwge+KOTVL9+FkN5htI+03zMXIPg7PU6TlaJCv2XJTEQK+EHgX/iD
 FNSbQIJnX4etz9T6MotWmB6WDF2haSSBzEe+X2O9x8LygudQ4DDmnSunPPThPDqSddcuWbUqI
 Ko64PkO15ynr3GZfEOC4K+Y48788UeCROFlaQq8LfyTFIC/VKr9ERUjJC+1EvfD1JzcxMLZnq
 knr1fFAtp8tw7sL/6YuWGSMU6viQcoYeTRlj3+bb3XeQkE4rrTmyWCacWjR1jn+7GA0OnHWyH
 eox1JKfg+dcsd8wlxEDG0R44xdubAttUOU/IPETlJfh+yFR/XyYOZBVxMYpeyu6rkEsP9Txfh
 +w387gR1dDTMFSj52ITkMak1SszIFTC51LvytXsGD8XZjV7RLV8ZyiAKCDtBiV+kY/3u5kjP0
 BiHzKUZaYYWuoY7VvkdAHzwpreTB+5pwAuMVPVj3dsmxrO1/NVmNStOypGubgTeaEhqOd91wo
 csq0Q2o9ZaNec6Cgp5Q5oiB3aNY0FzYp8yGulRR7eINyAIwaLU/FoJaerDLAeRTAYrQowBoR+
 dndOuYWwEEENkRhKsypzDzWebQywRYzBIJ+HNFEraWaOuJOLTYXUmeJSuq51lDGfuG5oBU/Fk
 0ju7EUdcx/IpG321DVxYIljgLLRkg8gQsnNA4AbuY6qSY05bs90P6g4v4yStk5nc2ARiEJP2Y
 XBrt+e36h3MHd8566nn1edWK57twT5+w8geu/L0EI6+CG04hoOnV0FNKnzrRLWJBsfjKcK4zG
 8sv1J6r9wgjGy4wv7KtT6Q2fCiqK6wAupk08tx95849Etxe8xkhAnDM1Ed8+TU5+LKSDZoFX3
 RPyl5ICJy3LvF5dpFir5obMKnQHzL4UnoHlPf8ubCXFCX46/CmEzkXYBw7eda0TKiZxLySA5o
 dDVE4hhWp+p98JmAB5ezT2RTimWbQycqtEfFdEEs7Q9cHXAxVcIZHosZIYYDJsKVK+yZFxveQ
 H9PR8WAKKO8R4ygBiSv8zr3cN6Ep5Zl8QoTol8U/g6OJvBdVtIgjQUVKngy4djxte81kGy8ux
 JJ0FEsCh0y6N/mfcLwf5NWq4wsF+i23qfbOY9XG6Lh1yxwQu2xx+PHE03R

Provide a default implementation for the configure hook which simply
calls ulogd_parse_configfile(), so simple plugins only need to provide
the config_keyset. This also triggers an "unknown key" error if a
plugin defines no config_keyset (aka it has no options), but the config
file contains directives for it.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 src/conffile.c |  7 ++++++-
 src/ulogd.c    | 21 ++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/src/conffile.c b/src/conffile.c
index f412804..b9027da 100644
=2D-- a/src/conffile.c
+++ b/src/conffile.c
@@ -158,7 +158,12 @@ int config_parse_file(const char *section, struct con=
fig_keyset *kset)
 	}

 	if (!found) {
-		err =3D -ERRSECTION;
+		if (kset->num_ces =3D=3D 0) {
+			/* If there are no options, then no section isnt an error. */
+			err =3D 0;
+		} else {
+			err =3D -ERRSECTION;
+		}
 		goto cpf_error;
 	}

diff --git a/src/ulogd.c b/src/ulogd.c
index 96cea8a..d72ede5 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -869,15 +869,22 @@ create_stack_resolve_keys(struct ulogd_pluginstance_=
stack *stack)
 			  pi_cur->plugin->name);
 		/* call plugin to tell us which keys it requires in
 		 * given configuration */
+		int ret;
 		if (pi_cur->plugin->configure) {
-			int ret =3D pi_cur->plugin->configure(pi_cur,
-							    stack);
-			if (ret < 0) {
-				ulogd_log(ULOGD_ERROR, "error during "
-					  "configure of plugin %s\n",
-					  pi_cur->plugin->name);
-				return ret;
+			ret =3D pi_cur->plugin->configure(pi_cur, stack);
+		} else {
+			struct config_keyset empty_kset =3D {.num_ces=3D0};
+			struct config_keyset *kset =3D &empty_kset;
+			if (pi_cur->config_kset) {
+				kset =3D pi_cur->config_kset;
 			}
+			ret =3D ulogd_parse_configfile(pi_cur->id, kset);
+		}
+		if (ret < 0) {
+			ulogd_log(ULOGD_ERROR, "error during "
+				  "configure of plugin %s\n",
+				  pi_cur->plugin->name);
+			return ret;
 		}
 	}

=2D-
2.48.1

