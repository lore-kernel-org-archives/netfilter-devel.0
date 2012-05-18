From: Arif Hossain <aftnix@gmail.com>
Subject: RTP stats explaination
Date: Fri, 18 May 2012 16:21:30 +0600
Message-ID: <CAGuaRCvvUiFeVAR6fCtz28H7h4g+u7HnxGbo-3_eBLYk+CTjOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: wireshark-users@wireshark.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, CentOS mailing list <centos@centos.org>,
	debian-user@lists.debian.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40103 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137Ab2ERKVb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 May 2012 06:21:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,
We are getting very poor quality of voice during testing of a new
filtering application of us.

The application receives packets from kernel using netfilter_queue
library. Then insert the packets into a new user managed queue and
does some transformations on it, like concatenation of udp payload.

The network is healthy. Its inside our lab. And it does not drop
packets or anything .

In our app we do not forward packet immediately. After enough packet
received to increase rtp packetization time (ptime) the we forward the
message over raw socket and set dscp to be 10 so that this time
packets can escape iptable rules.

>From client side the RTP stream analysis shows nearly every stream as
problematic. summery for some streams are given below :

Stream 1:

Max delta = 1758.72 ms at packet no. 40506
Max jitter = 231.07 ms. Mean jitter = 9.27 ms.
Max skew = -2066.18 ms.
Total RTP packets = 468   (expected 468)   Lost RTP packets = 0
(0.00%)   Sequence errors = 0
Duration 23.45 s (-22628 ms clock drift, corresponding to 281 Hz (-96.49%)

Stream 2:

Max delta = 1750.96 ms at packet no. 45453
Max jitter = 230.90 ms. Mean jitter = 7.50 ms.
Max skew = -2076.96 ms.
Total RTP packets = 468   (expected 468)   Lost RTP packets = 0
(0.00%)   Sequence errors = 0
Duration 23.46 s (-22715 ms clock drift, corresponding to 253 Hz (-96.84%)

Stream 3:

Max delta = 71.47 ms at packet no. 25009
Max jitter = 6.05 ms. Mean jitter = 2.33 ms.
Max skew = -29.09 ms.
Total RTP packets = 258   (expected 258)   Lost RTP packets = 0
(0.00%)   Sequence errors = 0
Duration 10.28 s (-10181 ms clock drift, corresponding to 76 Hz (-99.05%)

Any idea where should we look for the problem?


- --
- -aft
-----BEGIN PGP SIGNATURE-----
Version: OpenPGP.js v0.1
Comment: http://openpgpjs.org

wsBcBAEBAgAQBQJPtiJ7CRCJVJ6A/SK8awAAHJgH/jRURuZWygqJTX7zafjK
807MvWxODhtw2p4ZLg+sCNJ0OpZlV5GftPKwH9XB4GfUKhmTPfCZ3n8vF6PU
nWKMdBDM3D/K+DktpiGuAK90A5lwniFptN8DGt/ltqdAaSAlGbz1E6LGGdlw
1w/6lPeO3J9HKpkNQA2nfn3q/s5ZHQiYoGvgFofkm85LBSYgyn4b7YDY7qnp
wtsGkSR1h66+q37Hb+1iZyWrHj26YJ+sNRBe8GzKdEccwrKMX1gJFNl5BBfl
frGsZ3Y02cSYFg5L1vVstl8F/yTz8JXTGk6yKbtA0N+TRhI7gIJ/VItm1SJt
JcF94ylPjIWiw9Iacv8ec88=
=jiIm
-----END PGP SIGNATURE-----
