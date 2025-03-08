Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDD21A5B99
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 21:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741469852; cv=none; b=D7U9e/5L0Kt++/t7KtQMPr3FmLp8Aj3qh/LHJ5hb1BPzdSggHaIfL2ak59LGDThTdD/5fHOsWjDvbQdt8FNI1AswICZ9tXAnmHCoxj1RMrMzbQ8LaDQ+Bld3gnDNgRRpOSfDtJMfqrZeHwcpLYH6/E/sSsPxhDMttvN6EPQhNmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741469852; c=relaxed/simple;
	bh=mlaUFxVYvS/U3YzLo/tSeS1c7FMUlP6L6K2rjxPH+GE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=cZcq5BtYXK3IYWZzRruOvlW0MOhLb/PD/9v0+F2IlgnpNfDE8L49o6fTXBI9tuUPINLogmd8kNUcIV+7wmG3Uo6qbwFIXuq3/8SEAI+OjHsMvTNBuZlKjRn4WpyTo1GCB7OgVu1l/JeJIXxtqrokCe9HAom2PdJAlGs5m/DFdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=lxI2nuOO; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="lxI2nuOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741469848; x=1742074648; i=corubba@gmx.de;
	bh=zGoeafttijh6c0nP0Tt5gJ/sCj9Rx7r82WTyH3j9Ngg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=lxI2nuOOxT4qAN+saf8JoZDvVV6PCbhdhQMuLI3MelceinpsH/1+PrHfcpqPm6zg
	 vcmLdoEMz0AktcqDV1luy4kanhRGuH7xdf4SH1HDEPwHnTFEN0BPdB2QXB4XIdULT
	 v4h8nlG2TqfB4BoQP+WtRxYYYxpHLXJPqRDs9Cp+8C1BSaS3Sl8xwu+PJfNlVL1UX
	 ipQpDB84TSvkqdNxqAikuTHzOKXuMwabsqdoCdk8gCxx4dZSImTD1uGnJPZ7njcrz
	 C997xTwU0PW0Cv5Em3h5dHUBZZ93dzD+sMBzf7coVK0OHq+Hi2SaWGj2vTR6DASZu
	 GLgkKv8JAAhQreRxYA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M5QFB-1tqD2z1UyD-00ElSk for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 22:37:28 +0100
Message-ID: <21e4d476-8ad2-4b28-bb2f-ddb5c5b44ece@gmx.de>
Date: Sat, 8 Mar 2025 22:37:28 +0100
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
Subject: [PATCH ulogd2] ulogd: ignore private data on plugin stop
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PZO8pSXCFBe9q7jE+C+Fdx/eeq461inz6jbandyhn3tMZ5coCLV
 QzJj72U2m+FLtfbjonmAnWpt5nwSjrDPfBbcZunYdRaytD0zNqNATbxtEurs5XC7r1KgFRy
 VbHhWz1hTwfD7Fmt4y8VtRfEHO694uzDPysLtGwkLwLMy9m1f5Ev4ltsUITIR7V9MbIcVDI
 WbSB0HtY2Gfeg5YCsij4w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:oDoluiap3bw=;g4i4iNPYZ0FmvMKMfByJo0AMTSN
 Yui8gsd7ng/xV9mS/Ac3MSc+nEwLGd5ZWrOlt/41c5MpFzJiYmpe0o8geXrjGX8HDJnkBwQPq
 4sJ4P8Ye4qw+lFJ5+arU3/59hEMZAJca8oGc2whIaiRsjaEGxcvsowDkv/KhfNcydMm3dEYdn
 dLPJt+bw5COpMHsWPvVMhVaYLkvbFYVT+4sZgtfrv2p1cYk/g66cj+cn/jx/P4efoJVOtY705
 FKDY6Ck7E7eJ7k0g6PdUpuN5tGCGLjnnBj1K6gp03eaiTXR51l/P4ljfB8ueKaDxgivYuGn4C
 RjSuWQBUVcSTB4aWYcJJYXCWXi8hekOPU0tTZPBdQFdZNm34YvTMf6Ky0L1CwvPT0fe9JPHwm
 LGjCPh3Lpvj1ATm2B09mAuJM7WukEsDUYjFZtpzBHOfVBA8yxry/e3iXuBN1SSsb6iFPmWGjR
 aGciOoTB4re7MnzglpdIYH9kiDI7kPBa4ZIT9BqoI8IqLmpcVtWV8dSfL99peyHZk2o/hgxHc
 IJVs41m1LtDZfuKtf8aDSH2TDkiW6lnxbLi+sMmS93mvvIHJJZUJ3gbYM9WeogKWzPOxUU22f
 rKFA7P7+zpvjOg3vOR9KDTKnbgK1UNa3SM9r98rLOAyCn6F4MnKAwhGQZCALeXEaPJQG3PotF
 I4bBCnz173eo5g9fb5T/c5vz0CagCfexVH1MG8iIp/SatzWHwuE4hrLLOcrqLSzd7ekwJSV1h
 LfSf0JBmMO5SFS5KevgVoUaT9yiz/MoF4i/DADcWUJ4rx1ycBkoR6lTMN9MXKkmEKGeh9iFVN
 3FM5DU9Qjxy28maXOlEICyOWdhVWiWIG2EsOZsP2+EkWSG15J6jfivrCWiYdibAb8nPJJf4Ns
 zWwjI7zIGOYORo9Yz4pE8ftBgY+qytEdCj+nCXUaScPilXqq1/gRDehzImJiwFAFFwugTcX2u
 VjRCadGO5oJ2SDEO+ZwqnWVTb5b8k4uGAPnGtQof6XLFvaKKKKAaaDzImTo/0SsIn7LuPgbMp
 qO3ylCxCXUXhQuBuNb52cE6Z9IqJF+yebii3mthR79Hat8hIM7epfjsrU3POdhcDt8WaEEAxg
 V4vCu1vJpVAhQKQeonWP7g8pPmrBK0bgruW/0HEGprPgi7qctE9RO5XvqHMyO1o5EsJtla8ml
 yjR2rvAZebm+3uXaQnb3dLPWB1HBvn/tOWJrFngeYEg+6o3QT8YUxVcZ42pPvizuzt4Ns60Nk
 gnCtclFw94KwrhugJ6V6r9vJefouqNwfqRInFUvTnMth90B8qQDTKTDuguNdOvLI9Ow3+c++A
 RODnncFlvYcSOvPC/7f8tP9qgfOsTbXRQBnBusgZgRiUsJCuvxV1rhsuPbjePZd1R54ugPhEB
 2ogCLsdKie0GMUO3RsVb9L8Lsp2VJocwYMVUTy4/gRFPhTnTdE5/XnN7Al

When deciding whether to call the stop hook of a plugin instance, only
two things are relevant: If the plugin actually has a stop hook defined,
and if the plugin instance is still used in a different stack. The
private data of a plugin instance is opaque to ulogd, so its size or
content are irrelevant to the stop-hook decision. And in the same vein
should ulogd never write to it.

The one-null-byte write could previously lead to an out-of-bounds write
on plugins with a stop hook and zero-size private data.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 src/ulogd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index 6c5ff9a..9a0060d 100644
=2D-- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1327,12 +1327,10 @@ static void stop_pluginstances()

 	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
 		llist_for_each_entry_safe(pi, npi, &stack->list, list) {
-			if ((pi->plugin->priv_size > 0 || *pi->plugin->stop) &&
-			    pluginstance_stop(pi)) {
+			if (*pi->plugin->stop && pluginstance_stop(pi)) {
 				ulogd_log(ULOGD_DEBUG, "calling stop for %s\n",
 					  pi->plugin->name);
 				(*pi->plugin->stop)(pi);
-				pi->private[0] =3D 0;
 			}

 			/* NB: plugin->stop() might access other plugin instances,
=2D-
2.48.1
