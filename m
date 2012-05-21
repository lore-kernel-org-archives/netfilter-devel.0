From: "RUOFF, LARS (LARS)" <lars.ruoff-cfy2TCaE7SFv+uJa97DSA9BPR1lH4CV8@public.gmane.org>
Subject: Re: RTP stats explaination
Date: Mon, 21 May 2012 09:43:39 +0200
Message-ID: <23C6087F32FB3A43941E25922F87538E23C077CCA0@FRMRSSXCHMBSA2.dc-m.alcatel-lucent.com>
References: <CAGuaRCvvUiFeVAR6fCtz28H7h4g+u7HnxGbo-3_eBLYk+CTjOA@mail.gmail.com>
Reply-To: Community support list for Wireshark <wireshark-users-IZ8446WsY0/dtAWm4Da02A@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Community support list for Wireshark <wireshark-users-IZ8446WsY0/dtAWm4Da02A@public.gmane.org>,
 "netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "netfilter-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netfilter-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 CentOS mailing list <centos-IFYaIzF+flcdnm+yROfE0A@public.gmane.org>, "debian-user-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org"
 <debian-user-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org>
Return-path: <wireshark-users-bounces-IZ8446WsY0/dtAWm4Da02A@public.gmane.org>
In-Reply-To: <CAGuaRCvvUiFeVAR6fCtz28H7h4g+u7HnxGbo-3_eBLYk+CTjOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://wireshark.org/mailman/options/wireshark-users>,
 <mailto:wireshark-users-request-IZ8446WsY0/dtAWm4Da02A@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.wireshark.org/lists/wireshark-users>
List-Post: <mailto:wireshark-users-IZ8446WsY0/dtAWm4Da02A@public.gmane.org>
List-Help: <mailto:wireshark-users-request-IZ8446WsY0/dtAWm4Da02A@public.gmane.org?subject=help>
List-Subscribe: <https://wireshark.org/mailman/listinfo/wireshark-users>,
 <mailto:wireshark-users-request-IZ8446WsY0/dtAWm4Da02A@public.gmane.org?subject=subscribe>
Errors-To: wireshark-users-bounces-IZ8446WsY0/dtAWm4Da02A@public.gmane.org
Sender: wireshark-users-bounces-IZ8446WsY0/dtAWm4Da02A@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Are you using some sort of silence suppression (or voice activity detection) ?
If not, then the packets of your stream should be evenly spaced over time, i.e. "Max delta" should not be very different from the RTP packetization time. Go to the packets with high "Delta" and verify that you have gaps in your RTP stream. It seems you have some timing issues with your app.

Lars



-----Original Message-----
From: wireshark-users-bounces-IZ8446WsY0/dtAWm4Da02A@public.gmane.org [mailto:wireshark-users-bounces-IZ8446WsY0/dtAWm4Da02A@public.gmane.org] On Behalf Of Arif Hossain
Sent: vendredi 18 mai 2012 12:22
To: wireshark-users-IZ8446WsY0/dtAWm4Da02A@public.gmane.org; netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; netfilter-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; CentOS mailing list; debian-user-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org
Subject: [Wireshark-users] RTP stats explaination

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,
We are getting very poor quality of voice during testing of a new filtering application of us.

The application receives packets from kernel using netfilter_queue library. Then insert the packets into a new user managed queue and does some transformations on it, like concatenation of udp payload.

The network is healthy. Its inside our lab. And it does not drop packets or anything .

In our app we do not forward packet immediately. After enough packet received to increase rtp packetization time (ptime) the we forward the message over raw socket and set dscp to be 10 so that this time packets can escape iptable rules.

>From client side the RTP stream analysis shows nearly every stream as problematic. summery for some streams are given below :

Stream 1:

Max delta = 1758.72 ms at packet no. 40506 Max jitter = 231.07 ms. Mean jitter = 9.27 ms.
Max skew = -2066.18 ms.
Total RTP packets = 468   (expected 468)   Lost RTP packets = 0
(0.00%)   Sequence errors = 0
Duration 23.45 s (-22628 ms clock drift, corresponding to 281 Hz (-96.49%)

Stream 2:

Max delta = 1750.96 ms at packet no. 45453 Max jitter = 230.90 ms. Mean jitter = 7.50 ms.
Max skew = -2076.96 ms.
Total RTP packets = 468   (expected 468)   Lost RTP packets = 0
(0.00%)   Sequence errors = 0
Duration 23.46 s (-22715 ms clock drift, corresponding to 253 Hz (-96.84%)

Stream 3:

Max delta = 71.47 ms at packet no. 25009 Max jitter = 6.05 ms. Mean jitter = 2.33 ms.
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
___________________________________________________________________________
Sent via:    Wireshark-users mailing list <wireshark-users-IZ8446WsY0/dtAWm4Da02A@public.gmane.org>
Archives:    http://www.wireshark.org/lists/wireshark-users
Unsubscribe: https://wireshark.org/mailman/options/wireshark-users
             mailto:wireshark-users-request-IZ8446WsY0/dtAWm4Da02A@public.gmane.org?subject=unsubscribe
___________________________________________________________________________
Sent via:    Wireshark-users mailing list <wireshark-users-IZ8446WsY0/dtAWm4Da02A@public.gmane.org>
Archives:    http://www.wireshark.org/lists/wireshark-users
Unsubscribe: https://wireshark.org/mailman/options/wireshark-users
             mailto:wireshark-users-request-IZ8446WsY0/dtAWm4Da02A@public.gmane.org?subject=unsubscribe
