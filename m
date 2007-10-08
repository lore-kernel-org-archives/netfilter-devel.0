From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Mon, 8 Oct 2007 11:32:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710081117270.6987@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net>
 <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu> <47049D5B.8050001@trash.net>
 <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710052151180.11803@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:51789 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbXJHJca (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 05:32:30 -0400
In-Reply-To: <Pine.LNX.4.64.0710052151180.11803@bizon.gios.gov.pl>
Content-ID: <Pine.LNX.4.64.0710081125261.6987@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Krzysztof,

On Fri, 5 Oct 2007, Krzysztof Oledzki wrote:

> --- example #1 begin ---
[...]
> 21:44:59.870913 IP (tos 0x0, ttl 1, id 42334, offset 0, flags [DF], proto TCP
> (6), length 52) 192.168.150.12.38485 > 192.168.50.21.80: F, cksum 0x0d2f
> (correct), 3235585700:3235585700(0) ack 2584050074 win 54 <nop,nop,timestamp
> 1812577946 32205200>
> 21:44:59.870998 IP (tos 0x0, ttl 128, id 13216, offset 0, flags [DF], proto
> TCP (6), length 52) 192.168.50.21.80 > 192.168.150.12.38485: ., cksum 0x10d7
> (correct), ack 3235585701 win 64652 <nop,nop,timestamp 32205201 1812577946>
> 
> 21:45:03.379006 IP (tos 0x0, ttl 1, id 63436, offset 0, flags [DF], proto TCP
> (6), length 60) 192.168.150.12.38485 > 192.168.50.21.80: S, cksum 0x4896
> (correct), 2494249856:2494249856(0) win 5840 <mss 1460,sackOK,timestamp
> 1812581452 0,nop,wscale 7>
> 
> Oct  5 21:45:03 fw1 kernel: nf_ct_tcp: invalid SYNIN= OUT= SRC=192.168.150.12
> DST=192.168.50.21 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=63436 DF PROTO=TCP
> SPT=38485 DPT=80 SEQ=2494249856 ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 OPT
> (020405B40402080A6C09CC4C0000000001030307) UID=451

The last sequence number ACK-ed by the server is 3235585701. The ISN sent 
by the client at reopening is 2494249856, which is not after the largest
sequence number used in the previous session.

> --- example #1 begin ---
[...]
> 21:44:12.943021 IP (tos 0x0, ttl 1, id 34940, offset 0, flags [DF], proto TCP
> (6), length 52) 192.168.150.13.60522 > 192.168.50.61.80: F, cksum 0x5072
> (correct), 3536556182:3536556182(0) ack 2820416277 win 54 <nop,nop,timestamp
> 1812531018 32197611>
> 21:44:12.943142 IP (tos 0x0, ttl 128, id 32770, offset 0, flags [none], proto
> TCP (6), length 52) 192.168.50.61.80 > 192.168.150.13.60522: ., cksum 0x5037
> (correct), ack 3536556183 win 65534 <nop,nop,timestamp 32197725 1812531018>
> 
> 21:44:21.462090 IP (tos 0x0, ttl 1, id 60902, offset 0, flags [DF], proto TCP
> (6), length 60) 192.168.150.13.60522 > 192.168.50.61.80: S, cksum 0xcef7
> (correct), 3521103209:3521103209(0) win 5840 <mss 1460,sackOK,timestamp
> 1812539535 0,nop,wscale 7>

And the same here: largest seq is 3536556183, but the ISN is 3521103209.

It seems to me conntack is just right.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
