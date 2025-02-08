Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B91F9DA
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739022541; cv=none; b=Eb9FscuDeto70z/4lCAGki87F05QOgVpJCaMZZUCaZDVrcAEYJckZFA2Yty+w+ynB4nqUFmWht0mbliVKIHhoHSBzPEkksUpk7Cx1quBcGpOTnPBE0/RPPMem3TZMuriqdgszdDMVHqoJbag/wz5cTxRSFFbZ5MYU8jMCvWfhiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739022541; c=relaxed/simple;
	bh=X0EyMgSqUCzChH1F7+va9tJWcUywb1K9S+Gkp7C2g8M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=k2h7II5bRcwoHctkd8C55UF0G9PQJ71329vNNnqxP7M3JFDVjis3BR60myVTFiJGFikNDSkVfz54P7hYdn3jWXxphaqNghv/srsSCSgArvcyJphFw6QYWHIlDV28jNTa+SPzSYD7TmbOpNJVskhHYjXUBMmQD2afzivYAGXrvEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=Jll24lGW; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="Jll24lGW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739022537; x=1739627337; i=corubba@gmx.de;
	bh=xk5PgUXKt4yALLAJG4QtS6t7LqIDER652rGlMDTU+zw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Jll24lGWvb4H0T54UVl3GDSXa/VSjubpB7VNvHL1ftWFOc4Pi1SV/urORAuMsc18
	 POmPhOF5CKrhN19VM13umlguPhxE4myXGBalnvVqNkm/KtLj7SHCYuGIz1Joa5Fnu
	 urJ/QkNgqESf+Z9eZuO7k9GXzoOLKlwvYWtzjA/stUM2En+cZzIyvrOxS8150+U3k
	 HCCJq//IaNBZDppihpE2m+PakcW927UahhNV7XD+Tac3cyiZvFsOSd6xu8pomUfCN
	 V1C7LOaejBoL55dGp1FItrGqr57eQihhDcs3Q8bN/4s+8Xz9BEp0sGXeLXAO681w7
	 ST2xD34o8eKMsODwDg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.92]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MqaxU-1t3Hb73Qgq-00fEo5 for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Feb 2025 14:48:57 +0100
Message-ID: <0d239601-00a1-45df-9ebf-1e31c33ff45f@gmx.de>
Date: Sat, 8 Feb 2025 14:48:57 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 1/3] nfct: add newline to reliable log message
From: corubba <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
Content-Language: de-CH
In-Reply-To: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2IqMzFfTo2zAHUxgANKE4dqzZutfzcvHtuQWRfxuJJHEaxSf2Hr
 oFG/ocT15I50UeCFKgWQ1vav99+9j2K8qty5tbut6AKoDgvSSw4DBvaTCErBog4fqOhgVhM
 K2WP5A7bRwcmTI79WGyGvmlqLVyozNxzLO1l5G3SOUqTfkIe25GrzR4Z0q7efve6+eHqOki
 oRDEG2amYNWc2YXxgkNOg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aq/Qd4koAH0=;aFYbQZzfHuM1zFAPd0thiPQaVCJ
 P1EiCUK70l0i5Al0YoYA+bqhsyF2LvVs9YltCbvxoPiAL6k8RYiPd+CsfoOVBIHEIgRv3F0vM
 uIo8EXGD1stXGgA9tHgMSu/oPUaxlTY98E36yEJDH5RukU7Q5tjBYQ0XQqVFctWnFRWR1Oh0G
 r0S0YPzuhQmD7MkohWMHsEa03CKeWemrTx5eY0kM5LiF18knC6m2ksaszGepkTj7IQh13kbSI
 jFOvKdFAhRzig2b+1tsrFETaWDp2lm/5O4Rc09Tj4ZONisIzyiOaGfbCryYZatGTrQCejUX41
 XWBiunWU1rG9VZtJQZF+F/5gfyy4P4DED2UlBTnPp5UyNn9gvHyPrfiSE2BjguGikRu/9Fx2m
 Zaw6pQhCWK4WJngxrSsnZpqpbF8i+lXOBkv9GOOqE4zGacBxgHxNvPlzLVd/yhQd4q4ai16Cv
 NLIqjMCgo11luqv5hWCOAqQBiJsGKD8NuWqCXlyk+chmjPmvxeZffqZSF9DWDpYyGBxSw4G9e
 HPDpC/YRzT1iQfS/Jaj6ZZ52XT8uTme6FVDmnhIrDFD+SGlRzG9l5cEfjeW4ufsuAqYEopXur
 GHlSewOUpdkTu+VXhHDZYh/MzkQdnfWf7+ActIvjoNET7hAK2SUSFFpuPsnqEdEhWqazH3F4q
 Uznry+fpH427flpC2NsH9OEkWiee8h+XgblzIzmKbC9Vp9r1PZ9xDa+T07lzIpch++lqeX7eh
 MFbaaor+CmWcTbU9z2rBP1nLdj839aVs4GJ/a2l91nWNPSa0pnfP/184v1cxWZyAfnYEa67dP
 JwE6Ga40lO4umRqx8vUAJbffBgYRM+KngWm09ytm5EdMirUXF3AGygs2Pb9WeSt5WJptZlHul
 RsS18Vk5ALU2pyiZhKomySUmqy+gw2rPnMFfvrGFExuv8CSSubzCHCG2NdCq/AM2KiDF4DJz3
 AKNQo+x8ZvOH7eyDerOqsK70hH7CzGMdMNnTebQvVlpi9lxuykYxiavyxeSfQ8Wi/y7fLp0hq
 DV88jH5YzDPh2Xki4/fbAexWXHLAM26fRWsBEZF5dL6hDKmNB4aLlNxN6zhbLUrYRDq7dXII+
 5+NSHQM6hODLFPPuoPh76cKeaYDkqBBI4EVYF18m8kq3alO6rPJ+573VJ1iDDkN3xVjhI/s8Z
 SUOcAd57Zv6Kw9uya1IQKumk7egHfNwezec03/275VzRFs3UTM9d13djishKqqvVYa/WZpG5I
 zPM6lqPAiQGrBIkJ9C5naiZcSSy1rVvKylbwymhUecc/5U68tDnvmOEqM/+yFJ2r9SThDnVVV
 hQvgp412x6C/58aHLDMf2o5WSLO/3aRaCRFk/9jKb1/5YYBgBdV5VjuWNPJrNT8X1sbzCW3hY
 ++t3NNepi9GYdYtucxeTYRemroAlBEBQnaGcZVxpCZiHkmn32r4WBHxkddUSuyeKOIb89rX1v
 7VtUpBg==

Missing since 4bc3b22e.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 899b7e3..983c8d6 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -1327,7 +1327,7 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)
 		setsockopt(nfct_fd(cpi->cth), SOL_NETLINK,
 				NETLINK_NO_ENOBUFS, &on, sizeof(int));
 		ulogd_log(ULOGD_NOTICE, "NFCT reliable logging "
-					"has been enabled.");
+					"has been enabled.\n");
 	}
 	cpi->nfct_fd.fd =3D nfct_fd(cpi->cth);
 	cpi->nfct_fd.cb =3D &read_cb_nfct;
=2D-
2.48.1

