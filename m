Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B324F18DB2A
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 14:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739714637; cv=none; b=FcLu2KZ2p4I95RwxS8gY8U5coZ0MbTB8YqRRTRdj4BlrcjVUEObrKN0ZgYQi1IBQIdXHMawOh9UGdKENjuDYTyI6WUMuWNnN4vqahaye1h/rkhDWsmmFVJDv1yGJd6BzeeLGuYNnjaCN0ILEeo0J2j2G6SBjOu5soFnk/S1x0is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739714637; c=relaxed/simple;
	bh=suiZDPybn+fk+nZrEX7tYpg7NOdXlLjoDzcoGAx2mYU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=R7WCtBh/OQWKLBPmOHECp6EP/tI8suUIWAxnKbPRU3lAzWWooPrcVP/LrKSAeP17AU1xLYaMLKKrMXBBFtfog2E01LFHvIxW1yuEhQgozpWCkLbz1Z9duhsLaWedZ9DaabidmNeGMYMIojCIrh3zbdZ9koxpSp0LmTmDXyzDjoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=GFxWRLKh; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="GFxWRLKh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739714631; x=1740319431; i=corubba@gmx.de;
	bh=SJ3Pbs/8fvnTnLRi25fsvsKqsiIGyrxGmxoYrU2JZFk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GFxWRLKhlhhbcnYvEoclHuHFMawbd65X4o1c6zGNNGsMmpYVoruGbO36euOebMl3
	 nb1ZyjpRbqjjQZvB/xsIreiKlUdbPWCf8F07/2ZyBZuL2xqKGMCejBq5KGAqM7xaM
	 mpa4eECCox8oA7t/rc7eLiOuSEKYuLY1fGpN1Z9r64W1XOgaH+IfaoD4LSS/wam9g
	 xxNQ3GwfdK/9nrqcLL1x2hKq+yvm1qM1d6meiOhtO74L//2yb8iG5KTzx0gKVXoOH
	 TKY27NqEyKBCkZsi35QKU9drvjL0aAgEXZEvW1irYcEutWaf9JnfWvVrP9W6/XrgD
	 oDS5s2z7y/PR7A/gTw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.182]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mirng-1t717535VM-00j91N for
 <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 15:03:51 +0100
Message-ID: <99ab0ced-78e9-434a-9807-8f39f9c37ad6@gmx.de>
Date: Sun, 16 Feb 2025 15:03:51 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 v2 2/3] gprint: fix comma after ip addresses
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <6b8f641d-7ed2-4e1a-8ecc-c77488f71f00@gmx.de>
Content-Language: de-CH
In-Reply-To: <6b8f641d-7ed2-4e1a-8ecc-c77488f71f00@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qM81YfOSoPZIclpOUK03YHIzGwhMYeYXpACN3nFIGuAWl8gWWLR
 IzdWwxMI2b9I+1LwwYEbL/oexyZsuXBi56zkwkNaxvA8IsfxxGvDtkxtZkxRgm0x2qLhf1P
 jdg2f0T/wiYpvgw4l7kq50s/REI1Ae9nh2+uNbZ2K6knjOXwk1Qca8tm8mVevitzvFXjh0S
 w7imECUlOLLsS+YWHSeRQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:E//p5rVmpbQ=;dCtM3rSpiygvqZWpAbtawsWjJiZ
 6WTJhq8/ONSi08FFYnP9kE7cwHA2Yn8JmO2WrE9Ke70/MpyOO/UVBMc3PvF8Qw3QcA8yDZy0e
 xS3MvOTsmkrojOIebALEh+aQhji+qCbppGkt5PgJKW1o5YACE2tKaEH0fA4te3xxiILke0vWq
 7yrQ3F8CIlHMe9mfmTwDyX1qXwF/T0rQvcpV81mGnjdAj+sq0MGco8bObE/vCYrXIoQMU4kAs
 Y+dF/ByJ73hl2O/y96V2JRDgHU/To4sxw94TpGX31b7GHhOeZCmfW4tBK48lTyy6FA08d78Lw
 WR/guSA8tVUUUYC8V+IsA2OB8TEffAhAXJssHmWRJGBkMGkZvgbai6S9A1oXXNzBNbsd33IP+
 yaEuntVxuAYArYA8l9xU/QhcDepcXb67rTQVkJmZkgokLOQaN0Sr7BPC/RHpOnd3Ntlc5gzQG
 b7bcPpVYCUPKTG7io46TQBNUCVavmTOSELmme0oi/Ipnh5lQBe3mE3CtEhO7fTPb/MS6k9j4E
 APIzaXGPmlDEqb3bD/k2Wb5StbnBcglbL8oX8fjtWygcQFBXzlw0HssQ2RphcQJnOVQ+0BVzs
 TtFpWzg4SazKzqzE2DterOtZTQmfpGiFYIEZBijjemNySCRqTenOz6KscpdzsHCVJ2Yv9jb9r
 1LX1KLHV6HT929vFvb/CoXGP4vFCA4SyQJPuVciC1jq3Xw9tvMEeOgyAffonxNhRoj6C/wRCO
 yDbFpojbl9tgB9qeN/wUOQxn9zNj34xzHdVVVTt5sjgzX7KG2AVQgLexISfeiVQcPC+tDOh0r
 GUdsNvcWdC3viA2zh8gwLRRd9e1CL8/lrP3DWJVOaopJiow5S5jz4qIvcMY3hjUZct0QR9T6R
 ok0ep0D00n/WCigPUqJFeInYEEAJeHKHIDFG1soz3nxW9LswdGMwe8a2b8D37QSiu/8YVfNAd
 39mF0HEUOIJyJ/R0GdjFD/uvWVxrBG6/WT25BBY0fdizs+ut9QY3ryJ8yhjEiosDQpt3rXKaL
 cDhTI4f9WCotO0zTLclFR20mhYQVr8FdHDiNrJxvZ8s6jxJTZDVbjm/B0UgvewLeLYdT0HmIx
 k+/hiNJOnFoAsKBNk5/G12vJJcX2D5QV++fv1rc5j95/3PxSnf9Zxua9TP/2Pk464FstDdtOy
 Q0G3JMXC8nK2XNxpDzqJcWjSKoYjnN6gXIWym0eWIWbH3YyTNYmu07SF6mc8gmL9/oRIhkGB8
 Xx/WJ27EQofu3oDEq5FcV8SLTxxUegIlZbkhFgbHSZCHQafqL4Mv2aIss2zmKi6wHHb/s0Xy9
 RhZC09/YoEdwUma8Pm4ocMkMn7CqaES3Mckos4JgjkAYoCzoT2AyTi3BumqL6kceJrvdXnIfg
 +RthzG55qhC+ZaOFpCD0Ra1sJQs++BUkZ6fngzkzQXp7m4sTHVc4axIHFeyClOaovz7iO9j7V
 k7ecguA==

Do the same as the oprint plugin: let inet_ntop() write to a temporary
buffer, and then write that buffer content and the trailing comma to the
actual output buffer in one go.

Fixes: f04bf6794d11 ("gprint, oprint: use inet_ntop to format ip addresses=
")
Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 output/ulogd_output_GPRINT.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index 37829fa..20dd308 100644
=2D-- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -155,6 +155,7 @@ static int gprint_interp(struct ulogd_pluginstance *up=
i)
 			size +=3D ret;
 			break;
 		case ULOGD_RET_IPADDR: {
+			char addrbuf[INET6_ADDRSTRLEN + 1] =3D "";
 			struct in6_addr ipv6addr;
 			struct in_addr ipv4addr;
 			int family;
@@ -176,10 +177,12 @@ static int gprint_interp(struct ulogd_pluginstance *=
upi)
 				addr =3D &ipv4addr;
 				family =3D AF_INET;
 			}
-			if (!inet_ntop(family, addr, buf + size, rem))
+			if (!inet_ntop(family, addr, addrbuf, sizeof(addrbuf)))
 				break;
-			ret =3D strlen(buf + size);

+			ret =3D snprintf(buf+size, rem, "%s,", addrbuf);
+			if (ret < 0)
+				break;
 			rem -=3D ret;
 			size +=3D ret;
 			break;
=2D-
2.48.1

