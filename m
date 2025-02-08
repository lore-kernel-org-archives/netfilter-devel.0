Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF727F9DA
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739022593; cv=none; b=om2eTQS4K4VKkGvxgKw6hH6I66v0JyXQGNqDzY7TetpvTlkL8u1Khd/G893TwDFdg87t0/38ky1xX0MMe7h+CPTQ2rHeGnPdB0c9BnISRfZLF7e/1vef8Xx+7rV1lTPWpOkquRbpfnQr6k/XuRsi3P5T7kW8D48ysXi7j7SLoWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739022593; c=relaxed/simple;
	bh=+DRWduvKP6b0I875ajpjC8g9Tg98E6HKN9RFilk/qvc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Ajj+kgQHfHg2BPliB2H/MSKxfYo/j4xmNZjUaWRlVt4nTFQ6yiIARC1IeYHJN0qAD1S9/STrM7usNv/2qY4bQWq3xW0l56C1D5rAdsRrAceHSLHB16039swXzkzAP3uCFral8QpV/VNAKYAnduDiFao0ok0koxikT4M/LVGywAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=Llyed3Fp; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="Llyed3Fp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739022589; x=1739627389; i=corubba@gmx.de;
	bh=hjLgHcxLXs4eQXID5xNDlf0QVafsOiyqXfgGRvE1ZFQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Llyed3Fp+HKQWZb0akMj0T9GkcrNmfdmw0DfomCyNX68U5yXMeT4D424m728aYpU
	 6m0Dan9budFGSUccQsPw5PQx+8AHwW+fi1QOgY+AljEfOROzzZbtTn97ff6bMkNUK
	 CgAZSns7BqMdjcrQrBteE2pH1bAvmdtCIq5nkUHAqZ+tAStzFR2eISe/iAjwOefzT
	 ZRp3RGNsvy4Dbf2xrKFP2J4dwSykANWkeZZLz6xjoHVh9lWdM2spa8JeVxzcHXp9I
	 gZW2A+VMkYWoc9dlWAzHH1fOVzJoSsSw+59AArUYqH+sqRudxA9OF1oxU5IzVerHb
	 QdOH91sFLcL7Su1JPw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.92]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MN5if-1twv9c359R-00QPWX for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Feb 2025 14:49:49 +0100
Message-ID: <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de>
Date: Sat, 8 Feb 2025 14:49:49 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 2/3] gprint: fix comma after ip addresses
From: corubba <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
Content-Language: de-CH
In-Reply-To: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nU2Jv3gH7oze5/Yo/gswy2JJb+oFkzy7J3FXXkwlLbakZuZDmcj
 qUosgmGpkWawq+M5h9OjVSvOtNXa8ue4Y8lJT/Pab/FTXXfGpmlw/co3Y1CZTW9YUK11RC+
 SCuDYLBNMXWVDGKJFxdv7evwmeJl0Aj8uLTpONgpehSE9ru4VAPAirL6/1FPItVZpWE/ohm
 NgxxkIMCYzmHbbQ2bJrWg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:p+TbJ3hYczQ=;Dqug3MFpn9TpippyHBJyE5TH97e
 TqImTHocBghDeYdrGbkLU8mdpWLloQsxOQC/ZQjCLCQ5vYw/M2+kQzgoXRGPfPPl62aJ4Imo6
 SK4gihbhozGdx1PctRz+mbU05mQXdn85Q/0uMBskgCi60mS5ClhScqlB+rpYiVocz5KH+dnxi
 bwehWEWEIoLLxZ06eIvNKohyu9zlxrfz3wknlbXIN2Wu0wSYLWK8giCv3ENtZaGRZ6BaVViAP
 qOngAkKxU4dixPcoX3saBtczACLRm9g0R7kvHebeREjba3IRp8FHOdfxMQJtJPcHEttp/5uvA
 RcUxPM+QfOPOSSaC56aTQAsGVMfbZsMMyA5/usObETskekWYNhOfcLFS4rscZcw/YnCYk9Rut
 7Wc8bRgVfY0iUhMBkX3970Ke4OMwMI+7SkwMACHieT5XHgFmTQjpuVuuuXxrmYRjUAOfm2O8E
 paTlkJRqyQ508kQFncNVtAxLJouSIAwfjFsAFppR5NEtc4VRj3Vo5LYeV1WvYTxZFXxYXesuw
 TMhXbMeHjR/wct4EK7GDmuUbKWa7QnJ2qN/zeMJP3j0+mdYePxZyxLsWjP1awS9vKhAMt2NH6
 RoDGCaztLurnq8JDKOOIN/wrp5ZZFgJOTM0BgN22uoLbo2/lMxYHw713dcUExbi9QzvvtK6Fp
 1L96xzfsvyhEqH73lFDzfO5k3nkaHC02Ws6vNfiRACuRm4hJf6aALsdoYNPxvCzEnrRTFcMD6
 /bA7FwXyUQS7iODjEo7fZWYk2Lt2ZAKUb9/yXpZp9fOduV2p+NO14RyTLteT6rKq6xZiQoknh
 M/tfaGMpXRzmAUl9XXVFnHMiFilKOJZ/UuobkRW53WnYKq1L8ZeZha3X+sdPQl4rB4Pawr0PB
 Ld79fcT2w6FeBT2bDANEy5bHMr+R2PUxwILbDkeNEMpoWeQgofYVUDt/5se5VBiyC+KhZtQvs
 JOjniNzl5VXBcY16p5bd12dpsNERitoBfDBYnkfJvhWUssgeq9OQg4jwrnElCz1R5ZDyvghOC
 K08/sWppAjH+qKqYL+wXsn2CqHY2wO4D6buNoz/6VpoQhDqTZFJ/L4TPVkuRBrPNM1k5t8Hea
 ca8/Ok/xKs4AT7aL9KbaMFyNY7tuZkLA/rQz7EN1r0pXW7xIwxq1pMelTtX2QJxSddaMUh3fY
 0Bm2RyCWllbUWbbIngKla3Fbwn79igRxXDYxxmZx7m8Oq932tu6Uxjx0kumXQ30IBf+YflZY+
 Wq2f4tLunh0PHgd9TACpsdBikK2lkxWTd/Z+f3mMZm3tsG5Q3txMvaVkIZ/p3E3IrtCyEv/8c
 Jwc2wGaAptJxY0mHG4zXwFzlrLh5jffPIjppe50WIrUulhXOmsz76Q0+/UPqZ7GtqKbF0eVBI
 uh4Y0a6Oo72R0pn7cKyN4+M/Ddmic3MnDGOIEBpklIflxQnwpN82tk/3/y

Gone missing in f04bf679.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 output/ulogd_output_GPRINT.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index 37829fa..d95ca9d 100644
=2D-- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -179,9 +179,15 @@ static int gprint_interp(struct ulogd_pluginstance *u=
pi)
 			if (!inet_ntop(family, addr, buf + size, rem))
 				break;
 			ret =3D strlen(buf + size);
+			rem -=3D ret;
+			size +=3D ret;

+			ret =3D snprintf(buf+size, rem, ",");
+			if (ret < 0)
+				break;
 			rem -=3D ret;
 			size +=3D ret;
+
 			break;
 		}
 		default:
=2D-
2.48.1

