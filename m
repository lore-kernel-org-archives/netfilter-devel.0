Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3B523F384
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741791359; cv=none; b=NpCtsvDg6SCmy5/g1fBgLvllq7tlwjAAYNWsvurRdVoYDwrlIsDIMVoEy6Yc9GmOshpfrNxnG35rCB2s6gllMyu1dFvAG9XBmC1IwqTrjq4dFE1SBtHTLlKta5Rw5IaOoi+/HrAJTaZOR+oWn3BnW0vpWJrNE9xGeVpzhDXVsyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741791359; c=relaxed/simple;
	bh=f7gXRTwkylOWSEkhVFiazWrtz0PriABBKmJlvrb6RwI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=hQuM5WL/+u4rtIKvo2zc3pik3zZKUNW6Odd/E83w1H3Ym+1EojlEhOqjVdw0rhGHdXFaHEoLE2Zdz3RHm3Rz+Zp4YXr597802me9gT2c4hTm8ad8DSAsbvssq60THa1iQc6ZGLCgI+w9eNhbjnTDyXaSg4ayGpEZOge1EZIaNsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=VUeErVDx; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="VUeErVDx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741791355; x=1742396155; i=corubba@gmx.de;
	bh=whI+ToDGeLrZTUGIQIHFsb1vQBlAUJpqqd32yl1Qa3c=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VUeErVDxldO4AVqc6KCSh4bdocu+nUGgXhVe6NkYTDYdSAlla4gTwxNL16qnNW8p
	 jpzK4nORuSakKyLvn6Y3L5CqvjKrH0g+/DZuDE8ey/GpeuA8/pz2v8HshPs9NQZ+s
	 MGsoRvMbB51Um/gwhTZMHrNEgcOwQmGeqdTVtylvZQnZwtMxxIs6jqVXtKxGSfsrO
	 hKK/RW+cb0T0Jkq5+edraD7JtZeWzmYwnpv7lIJHlWNnYze190MFOSllKZpG0VLxH
	 ENTWDFx0RgpOvEpkHawU4VyLR1ZyFOJzAduCm7oEvB6McsMtljC7ZLlLDZtaNVYs8
	 ocFQf2+r4NZ04nPTqQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MHoNC-1tyPtd3D4Y-007YCf for
 <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 15:55:55 +0100
Message-ID: <622bffdf-faf5-401e-8a5b-6d9c44d2c4a2@gmx.de>
Date: Wed, 12 Mar 2025 15:55:55 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2,v2 5/6] ulogd: provide default configure implementation
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Language: de-CH
In-Reply-To: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Tl0xFMtGtKSy2X5Q9Gvv+Z9thSPmvAQ0hV89lzMiaexDPwcPqXq
 q6jawqQPB0bOvoCHBztbEamU/OODri5BWzT0kWfNdwPPfQ9a8e/GsZA6Ro4XzOLwo8e0nuX
 2QKzY/RoigcPPfgx2vjbchmMRvtg7RH5o7odcjxvurz0jnEUJnTYhTzl4slIyRciOaCI36N
 VR+Y9oYE/k37I+pL6VLKg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dzUos7/SzD4=;Xth9IteIi2jEawSOaj1SpXgd/w3
 Oy0mfWjl0hDklPf8DAvNr3mPGRLdKCD5DPIsRMq0RsQlpduEBK/GV2gridspaMfJkS8k7qaf2
 u+bqysDDPei4iDrQxHHKsFzc9E1u906L+xRxsccGtGECLjCO2mJL2Qq9KMLhZfYIlJbHaBrxX
 pgdlx60n9Az6Urpm4sqzBk1qfMJpyuk0LnnlS4Zi2xKLpl29lMaCdJSF32gb/BTF4ULT8xvZr
 R/GXVNrFPRAMcKuckOZrVkfybExT3REdBH2t8763Rk9qTRJ7OJCkfUsJxVBY7R5J5LjeX8wTp
 gKBkBws22LgWSzSHKfN67ZnWoIdpKkj1SE7EqfTXpis25h3jultXAK0tbcPGgvvyvdPK5qj5Y
 gL0CNbp3fudUIUKBsSAuBBES+8HA4C+A+adFZDbmnTCi/HC5sFZ6GlZR756We7gu3ozR04Lba
 Fxc+PLeOG+dZHuitFcslGmGgaxEd78l4NWNpgJIQys/sa0PLN6pshafusE3Ot6rZZBWxTO1Ii
 n2c5BHC8UTM6JOXdLpUiIX1vXbRaKtZHo0jIz/qDgYE4hXHE4p9e6GWTJ3DZVso9ZlhoOZM8x
 j6oJo/gpXKKwLsGGa6o1iApSHN2ebBSTQ1Mf8p43Tukdv2UUwoasM1BD6jYU+h852DBQ91mHN
 6RJquSp+rIlpUOwFcxvw61HacO8zs6kLL6AH903c1h9qZLqdd3BWcQPB5ud2ufteNthTo3vFB
 WgzEQbNSGcjghj0zC0ig6tN0eZhUYxKjkoUdKHbXjlySpk7jyUX7C4XeElb9I6ayuZkcz760T
 gmaK4z297TTuGs4CUdmbuhHcOq6uWiC6518KnGRt7N9AXFpV56k6iXQ8NNEXTinKnRiBdEmSz
 cGPQCIqr55MqN+LhQvZ5xL4ImPY2NnWGIigSeoaQpYa4DCEp+AL7KY4KlaBsZ0w/rxqFW6fML
 y32MbzGwc/OLyZIinUtqxOZj3b3glwT/Asx18ccc7lI35E5o2sEX8M2kHxMQ57B6vV6Gs8XA1
 1JOhWmfql7wQAXAencC7bDvk8fNzcR+r7Me2ljBnjA8lSeod3gZbfZwun3igOBt8M6jtU6xy4
 yiJWXZdqXFDjWCgCmMD4zQtBlculxWIB3FTfCDS0eas0dtk2jOgoEXTQOXwrsHkBh5PewCF8f
 rK7z8ni+2A2V6nvLd6HqZHl3dq2QoCKsTRKIRJ1NoOBi9PoApddsP8EnViSnxlhFgkpE+r3Bl
 IuIxJdJVT5VYRJmcxd1SKDMLtQFvzjLT3MJF3XExQzwhb9GprFTLhTwruYZQo1PtzeuGt264q
 IlLAt/C/pTnvzmrfZmXJjFIHMyQdJ2jhg19MLwM24LZgiKnh/C+4RNvA1q8HNhbxpQciCWkoR
 OrKLJ4NvEreI44QO7Vkd3frCSSKhijC4FmkwlO6NwIsrYIz4WdfKxkM8WQuKd1ThulmUPY5Lz
 vkgHI5ygGnxx81eY4lUyPDocQvqyhuceIsxcsVw1ycrh58RkB

Provide a default implementation for the configure hook which simply
calls ulogd_parse_configfile(), so simple plugins only need to provide
the config_keyset. This also triggers an "unknown key" error if a
plugin defines no config_keyset (aka it has no options), but the config
file contains directives for it.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - None

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
index cc4f2da..9f562f7 100644
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
