From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Fwd: Re: TCP connection stalls under 2.6.24.7
Date: Thu, 10 Jul 2008 11:46:25 +0200
Message-ID: <200807101146.26034.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:45360 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbYGJJqd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:46:33 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re01.intra2net.com (Postfix) with ESMTP id 8063A8C09
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jul 2008 11:46:31 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 4E5F32AC4C
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jul 2008 11:46:31 +0200 (CEST)
Received: from storm.m.i2n (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTP id 147F92AC49
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jul 2008 11:46:27 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Repost with the tcpdump attachment as link to "marc.info".

netfilter-devel had a 100K size limit which is now raised to 400K.
Thanks to DaveM for the investigation!

----------  Forwarded Message  ----------

Subject: Re: TCP connection stalls under 2.6.24.7
Date: Monday, 7. July 2008
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: netdev@vger.kernel.org
CC: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, Patrick McHardy <kaber@trash.net>,
       Sven Riedel <sr@securenet.de>, <netfilter-devel@vger.kernel.org>

Hello together,

On Monday, 7. July 2008 11:18:32 you wrote:
> I'll upgrade to 2.6.25.10 and see if it helps,
> there is a TCP connection timeout fix in there:
> http://kerneltrap.org/mailarchive/linux-kernel/2008/6/14/2122714

After upgrading to 2.6.25.10, the TCP connection still stalls.

I temporarily disabled PMTU discovery, TCP window scaling, TCP SACK
and manually forced the MTU to 1400 with no noticable effect.

I also added a "iptables -I INPUT -s IP.OF.MAIL.RELAY -j ACCEPT"
to make sure it's not related to conntrack on the double.

So here are the current results:
- 2.6.23.16: Working
- 2.6.24: Stalling connection
- 2.6.24.7: Stalling connection
- 2.6.25.10: Stalling connection

Attached is a tcpdump of a stalling connection with the
sensitive information replaced by "xxxxx", so please ignore the broken
checkums at the beginning. The dump was created using 2.6.24.7.

Jozsef Kadlecsik suggested this is not related to netfilter,
so I'm now asking for help on netdev.

Here's the text output from tcpdump:
-----------------------------------------------------------
13:40:14.140625 IP linux.53132 > mailserver.smtp: S 943411848:943411848(0) win 5808 <mss 1452,sackOK,timestamp 5386646 0,nop,wscale 2>
13:40:14.206523 IP mailserver.smtp > linux.53132: S 4213328541:4213328541(0) ack 943411849 win 65535 <mss 1400>
13:40:14.206548 IP linux.53132 > mailserver.smtp: . ack 1 win 5808
13:40:14.271316 IP mailserver.smtp > linux.53132: P 1:84(83) ack 1 win 65535
13:40:14.271336 IP linux.53132 > mailserver.smtp: . ack 84 win 5808
13:40:14.271395 IP linux.53132 > mailserver.smtp: P 1:26(25) ack 84 win 5808
13:40:14.341555 IP mailserver.smtp > linux.53132: P 84:257(173) ack 26 win 65535
13:40:14.341737 IP linux.53132 > mailserver.smtp: P 26:38(12) ack 257 win 6432
13:40:14.405342 IP mailserver.smtp > linux.53132: P 257:275(18) ack 38 win 65535
13:40:14.405419 IP linux.53132 > mailserver.smtp: P 38:68(30) ack 275 win 6432
13:40:14.471391 IP mailserver.smtp > linux.53132: P 275:293(18) ack 68 win 65535
13:40:14.471485 IP linux.53132 > mailserver.smtp: P 68:82(14) ack 293 win 6432
13:40:14.535423 IP mailserver.smtp > linux.53132: . ack 82 win 65535
13:40:14.539343 IP mailserver.smtp > linux.53132: P 293:324(31) ack 82 win 65535
13:40:14.539405 IP linux.53132 > mailserver.smtp: P 82:224(142) ack 324 win 6432
13:40:14.619489 IP mailserver.smtp > linux.53132: P 324:553(229) ack 224 win 65535
13:40:14.619633 IP linux.53132 > mailserver.smtp: . 224:1624(1400) ack 553 win 7504
13:40:14.619671 IP linux.53132 > mailserver.smtp: . 1624:3024(1400) ack 553 win 7504
13:40:14.746337 IP mailserver.smtp > linux.53132: . ack 1624 win 65535
13:40:14.746378 IP linux.53132 > mailserver.smtp: . 3024:4424(1400) ack 553 win 7504
13:40:14.746414 IP linux.53132 > mailserver.smtp: . 4424:5824(1400) ack 553 win 7504
13:40:14.863352 IP mailserver.smtp > linux.53132: . ack 4424 win 65535
13:40:14.863381 IP linux.53132 > mailserver.smtp: . 5824:7224(1400) ack 553 win 7504
13:40:14.863412 IP linux.53132 > mailserver.smtp: . 7224:8624(1400) ack 553 win 7504
13:40:14.888119 IP linux.53132 > mailserver.smtp: . 8624:10024(1400) ack 553 win 7504
13:40:14.955509 IP mailserver.smtp > linux.53132: . ack 5824 win 65535
13:40:14.955539 IP linux.53132 > mailserver.smtp: . 10024:11424(1400) ack 553 win 7504
13:40:14.955569 IP linux.53132 > mailserver.smtp: P 11424:12512(1088) ack 553 win 7504
13:40:15.048337 IP mailserver.smtp > linux.53132: . ack 8624 win 65535
13:40:15.048365 IP linux.53132 > mailserver.smtp: . 12512:13912(1400) ack 553 win 7504
13:40:15.048397 IP linux.53132 > mailserver.smtp: . 13912:15312(1400) ack 553 win 7504
13:40:15.073100 IP linux.53132 > mailserver.smtp: . 15312:16712(1400) ack 553 win 7504
13:40:15.165394 IP mailserver.smtp > linux.53132: . ack 10024 win 65535
13:40:15.165422 IP linux.53132 > mailserver.smtp: . 16712:18112(1400) ack 553 win 7504
13:40:15.165452 IP linux.53132 > mailserver.smtp: . 18112:19512(1400) ack 553 win 7504
13:40:15.271312 IP mailserver.smtp > linux.53132: . ack 13912 win 65535
13:40:15.271343 IP linux.53132 > mailserver.smtp: P 19512:20704(1192) ack 553 win 7504
13:40:15.271386 IP linux.53132 > mailserver.smtp: . 20704:22104(1400) ack 553 win 7504
13:40:15.296088 IP linux.53132 > mailserver.smtp: . 22104:23504(1400) ack 553 win 7504
13:40:15.320793 IP linux.53132 > mailserver.smtp: . 23504:24904(1400) ack 553 win 7504
13:40:15.375251 IP mailserver.smtp > linux.53132: . ack 15312 win 65535
13:40:15.375273 IP linux.53132 > mailserver.smtp: . 24904:26304(1400) ack 553 win 7504
13:40:15.375303 IP linux.53132 > mailserver.smtp: . 26304:27704(1400) ack 553 win 7504
13:40:15.447472 IP mailserver.smtp > linux.53132: . ack 18112 win 65535
13:40:15.447524 IP linux.53132 > mailserver.smtp: . 27704:29104(1400) ack 553 win 7504
13:40:15.447559 IP linux.53132 > mailserver.smtp: . 29104:30504(1400) ack 553 win 7504
13:40:15.472265 IP linux.53132 > mailserver.smtp: . 30504:31904(1400) ack 553 win 7504
13:40:15.585446 IP mailserver.smtp > linux.53132: . ack 20704 win 65535
13:40:15.585487 IP linux.53132 > mailserver.smtp: P 31904:32992(1088) ack 553 win 7504
13:40:15.585614 IP linux.53132 > mailserver.smtp: . 32992:34392(1400) ack 553 win 7504
13:40:15.610316 IP linux.53132 > mailserver.smtp: . 34392:35792(1400) ack 553 win 7504
13:40:15.677292 IP mailserver.smtp > linux.53132: . ack 23504 win 65535
13:40:15.677313 IP linux.53132 > mailserver.smtp: . 35792:37192(1400) ack 553 win 7504
13:40:15.677342 IP linux.53132 > mailserver.smtp: . 37192:38592(1400) ack 553 win 7504
13:40:15.702048 IP linux.53132 > mailserver.smtp: . 38592:39992(1400) ack 553 win 7504
13:40:15.796288 IP mailserver.smtp > linux.53132: . ack 24904 win 65535
13:40:15.796314 IP linux.53132 > mailserver.smtp: . 39992:41392(1400) ack 553 win 7504
13:40:15.796350 IP linux.53132 > mailserver.smtp: . 41392:42792(1400) ack 553 win 7504
13:40:15.856442 IP mailserver.smtp > linux.53132: . ack 27704 win 65535
13:40:15.856470 IP linux.53132 > mailserver.smtp: . 42792:44192(1400) ack 553 win 7504
13:40:15.856515 IP linux.53132 > mailserver.smtp: . 44192:45592(1400) ack 553 win 7504
13:40:15.881218 IP linux.53132 > mailserver.smtp: . 45592:46992(1400) ack 553 win 7504
13:40:15.977365 IP mailserver.smtp > linux.53132: . ack 30504 win 65535
13:40:15.977389 IP linux.53132 > mailserver.smtp: . 46992:48392(1400) ack 553 win 7504
13:40:16.001505 IP linux.53132 > mailserver.smtp: . 48392:49792(1400) ack 553 win 7504
13:40:16.001534 IP linux.53132 > mailserver.smtp: . 49792:51192(1400) ack 553 win 7504
13:40:16.141214 IP mailserver.smtp > linux.53132: . ack 34392 win 65535
13:40:16.141249 IP linux.53132 > mailserver.smtp: . 51192:52592(1400) ack 553 win 7504
13:40:16.141280 IP linux.53132 > mailserver.smtp: . 52592:53992(1400) ack 553 win 7504
13:40:16.165987 IP linux.53132 > mailserver.smtp: . 53992:55392(1400) ack 553 win 7504
13:40:16.190691 IP linux.53132 > mailserver.smtp: . 55392:56792(1400) ack 553 win 7504
13:40:16.215342 IP mailserver.smtp > linux.53132: . ack 35792 win 65535
13:40:16.215393 IP linux.53132 > mailserver.smtp: . 56792:58192(1400) ack 553 win 7504
13:40:16.240096 IP linux.53132 > mailserver.smtp: . 58192:59592(1400) ack 553 win 7504
13:40:16.329180 IP mailserver.smtp > linux.53132: . ack 38592 win 65535
13:40:16.329220 IP linux.53132 > mailserver.smtp: . 59592:60992(1400) ack 553 win 7504
13:40:16.329255 IP linux.53132 > mailserver.smtp: P 60992:61664(672) ack 553 win 7504
13:40:16.341471 IP linux.53132 > mailserver.smtp: . 61664:63064(1400) ack 553 win 7504
13:40:16.425284 IP mailserver.smtp > linux.53132: . ack 39992 win 65535
13:40:16.425322 IP linux.53132 > mailserver.smtp: . 63064:64464(1400) ack 553 win 7504
13:40:16.425357 IP linux.53132 > mailserver.smtp: . 64464:65864(1400) ack 553 win 7504
13:40:16.505348 IP mailserver.smtp > linux.53132: . ack 42792 win 65535
13:40:16.505387 IP linux.53132 > mailserver.smtp: . 65864:67264(1400) ack 553 win 7504
13:40:16.505420 IP linux.53132 > mailserver.smtp: . 67264:68664(1400) ack 553 win 7504
13:40:16.530126 IP linux.53132 > mailserver.smtp: . 68664:70064(1400) ack 553 win 7504
13:40:16.622359 IP mailserver.smtp > linux.53132: . ack 45592 win 65535
13:40:16.622387 IP linux.53132 > mailserver.smtp: . 70064:71464(1400) ack 553 win 7504
13:40:16.622417 IP linux.53132 > mailserver.smtp: . 71464:72864(1400) ack 553 win 7504
13:40:16.647124 IP linux.53132 > mailserver.smtp: . 72864:74264(1400) ack 553 win 7504
13:40:16.751201 IP mailserver.smtp > linux.53132: . ack 48392 win 65535
13:40:16.751228 IP linux.53132 > mailserver.smtp: . 74264:75664(1400) ack 553 win 7504
13:40:16.751259 IP linux.53132 > mailserver.smtp: . 75664:77064(1400) ack 553 win 7504
13:40:16.775965 IP linux.53132 > mailserver.smtp: . 77064:78464(1400) ack 553 win 7504
13:40:16.840381 IP mailserver.smtp > linux.53132: . ack 49792 win 65535
13:40:16.840419 IP linux.53132 > mailserver.smtp: . 78464:79864(1400) ack 553 win 7504
13:40:16.840450 IP linux.53132 > mailserver.smtp: . 79864:81264(1400) ack 553 win 7504
13:40:16.927375 IP mailserver.smtp > linux.53132: . ack 52592 win 65535
13:40:16.927401 IP linux.53132 > mailserver.smtp: . 81264:82664(1400) ack 553 win 7504
13:40:16.927433 IP linux.53132 > mailserver.smtp: . 82664:84064(1400) ack 553 win 7504
13:40:16.952139 IP linux.53132 > mailserver.smtp: . 84064:85464(1400) ack 553 win 7504
13:40:17.045338 IP mailserver.smtp > linux.53132: . ack 55392 win 65535
13:40:17.045374 IP linux.53132 > mailserver.smtp: . 85464:86864(1400) ack 553 win 7504
13:40:17.045406 IP linux.53132 > mailserver.smtp: . 86864:88264(1400) ack 553 win 7504
13:40:17.070113 IP linux.53132 > mailserver.smtp: . 88264:89664(1400) ack 553 win 7504
13:40:17.162120 IP mailserver.smtp > linux.53132: . ack 58192 win 65535
13:40:17.162148 IP linux.53132 > mailserver.smtp: . 89664:91064(1400) ack 553 win 7504
13:40:17.162179 IP linux.53132 > mailserver.smtp: . 91064:92464(1400) ack 553 win 7504
13:40:17.186886 IP linux.53132 > mailserver.smtp: . 92464:93864(1400) ack 553 win 7504
13:40:17.255239 IP mailserver.smtp > linux.53132: . ack 59592 win 65535
13:40:17.255268 IP linux.53132 > mailserver.smtp: . 93864:95264(1400) ack 553 win 7504
13:40:17.255298 IP linux.53132 > mailserver.smtp: . 95264:96664(1400) ack 553 win 7504
13:40:17.368334 IP mailserver.smtp > linux.53132: . ack 63064 win 65535
13:40:17.368390 IP linux.53132 > mailserver.smtp: . 96664:98064(1400) ack 553 win 7504
13:40:17.368423 IP linux.53132 > mailserver.smtp: P 98064:98528(464) ack 553 win 7504
13:40:17.377076 IP linux.53132 > mailserver.smtp: . 98528:99928(1400) ack 553 win 7504
13:40:17.401781 IP linux.53132 > mailserver.smtp: . 99928:101328(1400) ack 553 win 7504
13:40:17.465163 IP mailserver.smtp > linux.53132: . ack 64464 win 65535
13:40:17.465230 IP linux.53132 > mailserver.smtp: . 101328:102728(1400) ack 553 win 7504
13:40:17.465265 IP linux.53132 > mailserver.smtp: . 102728:104128(1400) ack 553 win 7504
13:40:17.544242 IP mailserver.smtp > linux.53132: . ack 67264 win 65535
13:40:17.544272 IP linux.53132 > mailserver.smtp: . 104128:105528(1400) ack 553 win 7504
13:40:17.544303 IP linux.53132 > mailserver.smtp: . 105528:106928(1400) ack 553 win 7504
13:40:17.569011 IP linux.53132 > mailserver.smtp: . 106928:108328(1400) ack 553 win 7504
13:40:17.661252 IP mailserver.smtp > linux.53132: . ack 70064 win 65535
13:40:17.661289 IP linux.53132 > mailserver.smtp: . 108328:109728(1400) ack 553 win 7504
13:40:17.661320 IP linux.53132 > mailserver.smtp: . 109728:111128(1400) ack 553 win 7504
13:40:17.686027 IP linux.53132 > mailserver.smtp: . 111128:112528(1400) ack 553 win 7504
13:40:17.792315 IP mailserver.smtp > linux.53132: . ack 72864 win 65535
13:40:17.792346 IP linux.53132 > mailserver.smtp: . 112528:113928(1400) ack 553 win 7504
13:40:17.792377 IP linux.53132 > mailserver.smtp: . 113928:115328(1400) ack 553 win 7504
13:40:17.817082 IP linux.53132 > mailserver.smtp: . 115328:116728(1400) ack 553 win 7504
13:40:17.875197 IP mailserver.smtp > linux.53132: . ack 74264 win 65535
13:40:17.875215 IP linux.53132 > mailserver.smtp: . 116728:118128(1400) ack 553 win 7504
13:40:17.899923 IP linux.53132 > mailserver.smtp: . 118128:119528(1400) ack 553 win 7504
13:40:17.980287 IP mailserver.smtp > linux.53132: . ack 77064 win 65535
13:40:17.980334 IP linux.53132 > mailserver.smtp: . 119528:120928(1400) ack 553 win 7504
13:40:17.980365 IP linux.53132 > mailserver.smtp: . 120928:122328(1400) ack 553 win 7504
13:40:18.005072 IP linux.53132 > mailserver.smtp: . 122328:123728(1400) ack 553 win 7504
13:40:18.085234 IP mailserver.smtp > linux.53132: . ack 78464 win 65535
13:40:18.085265 IP linux.53132 > mailserver.smtp: . 123728:125128(1400) ack 553 win 7504
13:40:18.085295 IP linux.53132 > mailserver.smtp: . 125128:126528(1400) ack 553 win 7504
13:40:18.156177 IP mailserver.smtp > linux.53132: . ack 81264 win 65535
13:40:18.156206 IP linux.53132 > mailserver.smtp: . 126528:127928(1400) ack 553 win 7504
13:40:18.156237 IP linux.53132 > mailserver.smtp: . 127928:129328(1400) ack 553 win 7504
13:40:18.180942 IP linux.53132 > mailserver.smtp: . 129328:130728(1400) ack 553 win 7504
13:40:18.274172 IP mailserver.smtp > linux.53132: . ack 84064 win 65535
13:40:18.274216 IP linux.53132 > mailserver.smtp: . 130728:132128(1400) ack 553 win 7504
13:40:18.274248 IP linux.53132 > mailserver.smtp: . 132128:133528(1400) ack 553 win 7504
13:40:18.298950 IP linux.53132 > mailserver.smtp: . 133528:134928(1400) ack 553 win 7504
13:40:18.390240 IP mailserver.smtp > linux.53132: . ack 86864 win 65535
13:40:18.390279 IP linux.53132 > mailserver.smtp: . 134928:136328(1400) ack 553 win 7504
13:40:18.390310 IP linux.53132 > mailserver.smtp: . 136328:137728(1400) ack 553 win 7504
13:40:18.415017 IP linux.53132 > mailserver.smtp: . 137728:139128(1400) ack 553 win 7504
13:40:18.495173 IP mailserver.smtp > linux.53132: . ack 88264 win 65535
13:40:18.495211 IP linux.53132 > mailserver.smtp: . 139128:140528(1400) ack 553 win 7504
13:40:18.495241 IP linux.53132 > mailserver.smtp: . 140528:141928(1400) ack 553 win 7504
13:40:18.684146 IP mailserver.smtp > linux.53132: . ack 93864 win 65535
13:40:18.684178 IP linux.53132 > mailserver.smtp: . 141928:143328(1400) ack 553 win 7504
13:40:18.684209 IP linux.53132 > mailserver.smtp: . 143328:144728(1400) ack 553 win 7504
13:40:18.708919 IP linux.53132 > mailserver.smtp: . 144728:146128(1400) ack 553 win 7504
13:40:18.733633 IP linux.53132 > mailserver.smtp: . 146128:147528(1400) ack 553 win 7504
13:40:18.758340 IP linux.53132 > mailserver.smtp: . 147528:148928(1400) ack 553 win 7504
13:40:18.801152 IP mailserver.smtp > linux.53132: . ack 96664 win 65535
13:40:18.801206 IP linux.53132 > mailserver.smtp: . 148928:150328(1400) ack 553 win 7504
13:40:18.801236 IP linux.53132 > mailserver.smtp: . 150328:151728(1400) ack 553 win 7504
13:40:18.825942 IP linux.53132 > mailserver.smtp: . 151728:153128(1400) ack 553 win 7504
13:40:18.916231 IP mailserver.smtp > linux.53132: . ack 98528 win 65535
13:40:18.916287 IP linux.53132 > mailserver.smtp: . 153128:154528(1400) ack 553 win 7504
13:40:18.916320 IP linux.53132 > mailserver.smtp: . 154528:155928(1400) ack 553 win 7504
13:40:18.941026 IP linux.53132 > mailserver.smtp: . 155928:157328(1400) ack 553 win 7504
13:40:19.000201 IP mailserver.smtp > linux.53132: . ack 101328 win 65535
13:40:19.000240 IP linux.53132 > mailserver.smtp: . 157328:158728(1400) ack 553 win 7504
13:40:19.000271 IP linux.53132 > mailserver.smtp: . 158728:160128(1400) ack 553 win 7504
13:40:19.024978 IP linux.53132 > mailserver.smtp: . 160128:161528(1400) ack 553 win 7504
13:40:19.118224 IP mailserver.smtp > linux.53132: . ack 104128 win 65535
13:40:19.118256 IP linux.53132 > mailserver.smtp: . 161528:162928(1400) ack 553 win 7504
13:40:19.118286 IP linux.53132 > mailserver.smtp: . 162928:164328(1400) ack 553 win 7504
13:40:19.142994 IP linux.53132 > mailserver.smtp: . 164328:165728(1400) ack 553 win 7504
13:40:19.235024 IP mailserver.smtp > linux.53132: . ack 106928 win 65535
13:40:19.235100 IP linux.53132 > mailserver.smtp: . 165728:167128(1400) ack 553 win 7504
13:40:19.235135 IP linux.53132 > mailserver.smtp: . 167128:168528(1400) ack 553 win 7504
13:40:19.256950 IP linux.53132 > mailserver.smtp: . 168528:169928(1400) ack 553 win 7504
13:40:19.327125 IP mailserver.smtp > linux.53132: . ack 108328 win 65535
13:40:19.327174 IP linux.53132 > mailserver.smtp: . 169928:171328(1400) ack 553 win 7504
13:40:19.327205 IP linux.53132 > mailserver.smtp: . 171328:172728(1400) ack 553 win 7504
13:40:19.411138 IP mailserver.smtp > linux.53132: . ack 111128 win 65535
13:40:19.411173 IP linux.53132 > mailserver.smtp: . 172728:174128(1400) ack 553 win 7504
13:40:19.411205 IP linux.53132 > mailserver.smtp: . 174128:175528(1400) ack 553 win 7504
13:40:19.435913 IP linux.53132 > mailserver.smtp: P 175528:176352(824) ack 553 win 7504
13:40:19.528188 IP mailserver.smtp > linux.53132: . ack 113928 win 65535
13:40:19.528224 IP linux.53132 > mailserver.smtp: . 176352:177752(1400) ack 553 win 7504
13:40:19.528258 IP linux.53132 > mailserver.smtp: . 177752:179152(1400) ack 553 win 7504
13:40:19.646160 IP mailserver.smtp > linux.53132: . ack 116728 win 65535
13:40:19.646199 IP linux.53132 > mailserver.smtp: . 179152:180552(1400) ack 553 win 7504
13:40:19.646233 IP linux.53132 > mailserver.smtp: . 180552:181952(1400) ack 553 win 7504
13:40:19.803080 IP mailserver.smtp > linux.53132: . ack 119528 win 65535
13:40:19.803106 IP linux.53132 > mailserver.smtp: . 181952:183352(1400) ack 553 win 7504
13:40:19.803139 IP linux.53132 > mailserver.smtp: . 183352:184752(1400) ack 553 win 7504
13:40:19.920136 IP mailserver.smtp > linux.53132: . ack 122328 win 65535
13:40:19.920185 IP linux.53132 > mailserver.smtp: . 184752:186152(1400) ack 553 win 7504
13:40:19.920218 IP linux.53132 > mailserver.smtp: . 186152:187552(1400) ack 553 win 7504
13:40:20.037145 IP mailserver.smtp > linux.53132: . ack 125128 win 65535
13:40:20.037176 IP linux.53132 > mailserver.smtp: . 187552:188952(1400) ack 553 win 7504
13:40:20.037209 IP linux.53132 > mailserver.smtp: . 188952:190352(1400) ack 553 win 7504
13:40:20.153935 IP mailserver.smtp > linux.53132: . ack 126528 win 65535
13:40:20.153966 IP linux.53132 > mailserver.smtp: . 190352:191752(1400) ack 553 win 7504
13:40:20.213044 IP mailserver.smtp > linux.53132: . ack 129328 win 65535
13:40:20.213063 IP linux.53132 > mailserver.smtp: . 191752:193152(1400) ack 553 win 7504
13:40:20.213093 IP linux.53132 > mailserver.smtp: . 193152:194552(1400) ack 553 win 7504
13:40:20.331045 IP mailserver.smtp > linux.53132: . ack 132128 win 65535
13:40:20.331106 IP linux.53132 > mailserver.smtp: . 194552:195952(1400) ack 553 win 7504
13:40:20.331141 IP linux.53132 > mailserver.smtp: . 195952:197352(1400) ack 553 win 7504
13:40:20.448086 IP mailserver.smtp > linux.53132: . ack 134928 win 65535
13:40:20.448153 IP linux.53132 > mailserver.smtp: . 197352:198752(1400) ack 553 win 7504
13:40:20.448188 IP linux.53132 > mailserver.smtp: . 198752:200152(1400) ack 553 win 7504
13:40:20.565142 IP mailserver.smtp > linux.53132: . ack 136328 win 65535
13:40:20.565178 IP linux.53132 > mailserver.smtp: . 200152:201552(1400) ack 553 win 7504
13:40:20.627890 IP mailserver.smtp > linux.53132: . ack 139128 win 65535
13:40:20.627916 IP linux.53132 > mailserver.smtp: . 201552:202952(1400) ack 553 win 7504
13:40:20.627949 IP linux.53132 > mailserver.smtp: . 202952:204352(1400) ack 553 win 7504
13:40:23.945532 IP linux.53132 > mailserver.smtp: . 139128:140528(1400) ack 553 win 7504
13:40:24.124744 IP mailserver.smtp > linux.53132: . ack 140528 win 65535
13:40:24.124779 IP linux.53132 > mailserver.smtp: . 204352:205752(1400) ack 553 win 7504
13:40:30.761559 IP linux.53132 > mailserver.smtp: . 140528:141928(1400) ack 553 win 7504
13:40:30.879206 IP mailserver.smtp > linux.53132: . ack 147528 win 65535
13:40:30.879244 IP linux.53132 > mailserver.smtp: . 205752:207152(1400) ack 553 win 7504
13:40:30.879274 IP linux.53132 > mailserver.smtp: . 207152:208552(1400) ack 553 win 7504
13:40:44.157537 IP linux.53132 > mailserver.smtp: . 147528:148928(1400) ack 553 win 7504
13:40:44.277506 IP mailserver.smtp > linux.53132: . ack 150328 win 65535
13:40:44.277546 IP linux.53132 > mailserver.smtp: . 208552:209952(1400) ack 553 win 7504
13:40:44.277579 IP linux.53132 > mailserver.smtp: . 209952:211352(1400) ack 553 win 7504
13:41:10.837536 IP linux.53132 > mailserver.smtp: . 150328:151728(1400) ack 553 win 7504
13:41:10.955575 IP mailserver.smtp > linux.53132: . ack 154528 win 65535
13:41:10.955610 IP linux.53132 > mailserver.smtp: . 211352:212752(1400) ack 553 win 7504
13:41:10.955642 IP linux.53132 > mailserver.smtp: . 212752:214152(1400) ack 553 win 7504
13:42:04.073557 IP linux.53132 > mailserver.smtp: . 154528:155928(1400) ack 553 win 7504
13:42:04.198891 IP mailserver.smtp > linux.53132: . ack 155928 win 65535
13:42:04.198938 IP linux.53132 > mailserver.smtp: . 214152:215552(1400) ack 553 win 7504
13:42:04.198970 IP linux.53132 > mailserver.smtp: . 215552:216952(1400) ack 553 win 7504
13:43:50.437541 IP linux.53132 > mailserver.smtp: . 155928:157328(1400) ack 553 win 7504
13:43:50.696615 IP mailserver.smtp > linux.53132: . ack 157328 win 65535
13:43:50.696641 IP linux.53132 > mailserver.smtp: . 216952:218352(1400) ack 553 win 7504
13:43:50.696671 IP linux.53132 > mailserver.smtp: . 218352:219752(1400) ack 553 win 7504
13:44:51.681540 IP mailserver.smtp > linux.41085: P 3630759848:3630759915(67) ack 1371960018 win 65535
13:44:51.681568 IP linux.41085 > mailserver.smtp: R 1371960018:1371960018(0) win 0
13:44:51.681583 IP mailserver.smtp > linux.41085: F 67:67(0) ack 1 win 65535
13:44:51.681594 IP linux.41085 > mailserver.smtp: R 1371960018:1371960018(0) win 0
-----------------------------------------------------------

It just looks like some ACKs never made it to the linux box.
Any idea how I can further troubleshoot the stalling connection?

The tcpdump can be found here:
http://marc.info/?l=linux-netdev&m=121543716913532&q=p3

Please CC: comments, I'm only on netfilter-devel.

Thanks in advance,
Thomas
