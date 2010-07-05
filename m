From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt2 table core
Date: Mon, 5 Jul 2010 11:42:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007051138480.18387@obet.zrqbmnf.qr>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>  <201007020532.12596.simonl@parknet.dk>  <alpine.LSU.2.01.1007041440130.12356@obet.zrqbmnf.qr> <1278322612.2877.21.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="683461209-1344787659-1278322938=:18387"
Cc: Simon Lodal <simonl@parknet.dk>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57930 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab0GEJmV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:42:21 -0400
In-Reply-To: <1278322612.2877.21.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--683461209-1344787659-1278322938=:18387
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Monday 2010-07-05 11:36, Eric Dumazet wrote:
>> The command I used was
>> 
>> 	ping6 localhost -fc 500 -i .001
>> 
>> this sends 500 packets in near-flood fashion (-i0 would lead to
>> packet drops).
>> 
>> Xtables1 blob-style 2.6.31-rc4:
>> 500 packets transmitted, 500 received, 0% packet loss, time 3532ms
>> Xtables1 blob-style 2.6.34:
>> 500 packets transmitted, 500 received, 0% packet loss, time 3405ms
>> Xtables2 (linked lists) 2.6.35-rc1:
>> 500 packets transmitted, 500 received, 0% packet loss, time 14775ms
>> nftables (uses linked lists) 2.6.31-rc4:
>> 500 packets transmitted, 500 received, 0% packet loss, time 16198ms
>> 
>> Do you have any suggestions for improvement though?
>
>I dont understand how it is possible to spend so much time per packet,
>just adding few pointers :)
>Are you sure you dont hit another problem ?

If you see where this went awry, I'd be grateful. (The tests have been 
run on a single CPU.)

>Could you give us the rules you use ?

Attached.
--683461209-1344787659-1278322938=:18387
Content-Type: APPLICATION/octet-stream; name=bigrules2.xz
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LSU.2.01.1007051142170.18387@obet.zrqbmnf.qr>
Content-Description: 
Content-Disposition: attachment; filename=bigrules2.xz

/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM/6GrA+1dABGIBWgZ+FA8sqjgZSfs
Cdt25xLJUj3dsmGVjsm34i8SEbJ5B24ztc2F2dnpKibnWdH4KWb/sCaqPfeg
uKXUMdaIcXB7eSL2xrmJl0JxyGdc2o3PFfEECcilU8ZlTy3DrYA0R6oonBjZ
ezMJy63STlOmBrcP8fXeV8StWC1ez2w0yXekU06fKr8ic64oR0y5Xn8ZQ4D4
xx8Wwmcnnf9T4TW6m0RttAuIPmBkVMS9AMtTdtMImQdneOErdbfZPMz7kFUW
9iP1NS9dV0EQsRDqjIIaQjSKN6leslhrzw7uKwzKfrm4YRQy1r+ChA4k7OxI
fY52QwXupjS+gKp6aFHa4rKP8oFLUmwwr52rkVSnP3CXvaShBUySLdp0j4H4
08ULk8f7Pm+EfDUdRmttWr4j4dRDybj2bb2OBQAvXdE0y+DjBl2Wrkdtz9Dj
RSR48BWrRXQMuAmnd64osZWyHnPqzHqadAsCGYHdusuIu95rpPiAD+lbFETg
ID0hc6l8KRW0ZmMus14ly7ik/pd3VTLS+NrmU/q0FAisfu0t4xqlHnLeaEJ8
iKYmHZbzxulsaexQW0y+j06E4mUL+cFtSX3DITY4fXXPtO2dqcWICybM1OJ4
RjR6WqeN1bckNlRp9wHTf51UoUxX1As389yIL6HPjwnJfaoFCybt6kZQWqlO
Ydwqc2QUEzzxUiS5kgVORVY3eNNDNVd3u55HjBce7fVXG8mYdQN7rHmWzYYO
YZRthgQd+mrOQuAIwuzgt3akNEWbyRpLhNrI2fB1VGaKTG+kJayTGcchp9wC
cy5ts9OhZc7wTYKFYsektA4oF8UfJQbIyUTnIDjIPJV9vUrtR0LtElSCJ9zg
ueARVJ6rUxbx3UStcvrppcbnJyzWaEWY7xF78XD8ItdRY2qjYxcpdsibAhyt
6++KV6cmXS37RvsQfYFskylY0BZdx/k+i/m0Nz15hkT/UA72IfyclMYmyzJc
vDbI73rbUQNoFMchkjc2ssmmq12bAAFI1ddp1tMUvvK+dWBWsf1wyWiPKHmZ
JWjCjCBruDiqaFYSgjCXlR5jOjJO2NPDw8Ndd72TyRnJNV7R4o/+K6ulp3Hc
NdXfStEHPGV/eIjfaD4pFN5SpR94XIX41Nkrj5zY+F8Y2alqI7pDuUcGT0U+
tQDqVHbK40RGbXOE2yuoSkZ98T3tl2YtUKiV1fPRCuoVBnFpl8/jSao8Jb60
3mBr4UcjGwi6ZnYc0XBjHUBOe6XGBtDFbT5Tuu4C9LIiK5M1D+WCEacN7sGO
Z39gFUbklNooGoFKmfxo1VZC4cceth+odfMUJjYa0EwcZtIb2qkgLtG0Q1Vg
AAAAAADsM/v3s1G4bQABiQisw34A0ABy77HEZ/sCAAAAAARZWg==

--683461209-1344787659-1278322938=:18387
Content-Type: APPLICATION/octet-stream; name=bigrules2.nft.xz
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LSU.2.01.1007051142171.18387@obet.zrqbmnf.qr>
Content-Description: 
Content-Disposition: attachment; filename=bigrules2.nft.xz

/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM//+/An5dABGISkbyP2lvDMzsNGYO
EslvuAPrl5raOZMAfUCrYc4npKcqFkUnGZv5PaOOSuq7jVPQ2Ac9ra+yHvjx
Unu2p4nCrT7AftP4pkA8ZXsKVxmtnYLLKQKhN+135fBnrdVG+eXFpzM0kC9h
1HATjuiyH30Mde4ZJQX+S757fTPVrXeB3l7uHj+8T6lBhe/KVeAKCuYQb7Ei
5YoNe/crBfLeGJXPEl3C+NHdMfTl6qs1k+mK3Wfo1JcLAChnLFYo/a40efr0
FfmQjgbpMUN/VlE1WJjgU5DFGQVkE4ynxVaiX6TRwJcWmGAiiusBHUpfiejc
RqW45VaJZLpVcJc+dnZKouuADARYx9D1vnD+1Kht/GTp33fUcUNS2uR3Vpd3
k2NM1WkEyGiP0LKpUhkWWKMD+rY9UlP6ftG2HA3Wreaar/eHV2ifGBWFjOnt
61kd86fjDSAseSSmpFgKv2c2BroDs8FMyM1lkok7HNLiw0HBABkaf4k+XlJz
0aMxdGLbQwTdK3rhYcTuG+HQY6Y4toba2ut7ykM2QCSIc46HKIbStEVboj4h
I+QW9MgRT6EREVbQkKqjG+WYkbS2KEWnykYPi7mWuRpewdypST6LEbcXCUiq
rUbw3zVp2gONfylTQjDE9EItKsIytd+O+83FK0eJSKFIv3g835asYmCQMbMX
yDVFcMmQbTcsIcKutVB0BWxTL5Ti/NjthywnLSqXyLHO4TjBfh5sU9yGOKaC
l4RVO0K1gPQJYD51p88BtchQAlZ7NtRHGBREYXTvtjrsQcl84OXperIEVdoF
ksFEQRGBq5A0XWMiVU+5ZZ56L6XaFu35hxy38jhWOz/tqbycLbrDm5DrAh8A
7HWqSP7cqLJnn/vA8VE55RiZurMkJyQzzpqlBh+zpOcPGkD7ZI08h7DDH5fQ
vFnPAKTlGEOIoEKb28rqNnkOIPeCXYtNeAdta+P4/21wLHCTPQHoMoYQt/V0
v9Ow2exT6C63aviox2+2v+2VQrfCNE2daFpwjHrmxt1FP6wGodHsJ8IcjSWr
2zvY3YeLQYIkopP27gNxYdWff42WkKxwXtPPubyqn45vHnvgkesbO13omUpo
bw1JLqELEh6ILiMPnvO9PYhYPjezg7LmTrMvx1GZltNSL4lYlJMeaiLPuvRg
bFvgW8PzOpqTpNue5fYi8k8qdehtTRgFMgslEGG/nQz260KBBfnKaJyb2FBm
HTWcIDKyMjRaMR5+ENQWfaPTND3RlAVGU05+ObKuI7B+/nVXT3ZsY2HtkUWc
niWDUXkpddW4NBLpAq2BFEJB7ocT+sp4tYu6xm6kPudZmSDTPeFzXwjzxB7S
54Z/RpuqULkaFrRUCe3lGzr1NI9tdz9ms6Tk+ZtdeN5eIsQR8Yg+FpvsbYdJ
x0SF5bNVj36xkW2vP1X9nDbyVUUo3NUQmP/MKgD+Yd7g8vukfdvPNKgXWRvP
yclw+7nXMG3uDsz9kyObs0h3X2206GGzFtR88Io73RdNsccapv2CzGWlrSbA
pk3zeWp11ThVsifvrBOyX/ZVG1JUHONY/G0yp9IWFsqtYKZp9W6RxXlO98ge
5Z3OAABl1KhEDTyRFwABvwmsoe4BEmgkTbHEZ/sCAAAAAARZWg==

--683461209-1344787659-1278322938=:18387--
