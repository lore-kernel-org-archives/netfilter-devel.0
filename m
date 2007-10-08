From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Mon, 8 Oct 2007 19:23:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710081917420.30123@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net>
 <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu> <47049D5B.8050001@trash.net>
 <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710052151180.11803@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710081117270.6987@blackhole.kfki.hu> <470A5D2C.1040006@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2063523715-1191864210=:30123"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:51178 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbXJHRXm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:23:42 -0400
In-Reply-To: <470A5D2C.1040006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2063523715-1191864210=:30123
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 8 Oct 2007, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
>> Hi Krzysztof,
>>
>>> --- example #1 begin ---
>>
>> [...]
>>
>> The last sequence number ACK-ed by the server is 3235585701. The ISN sen=
t
>> by the client at reopening is 2494249856, which is not after the largest
>> sequence number used in the previous session.
>>
>>
>>> --- example #1 begin ---
>>
>> [...]
>>
>>
>> And the same here: largest seq is 3536556183, but the ISN is 3521103209.
>>
>> It seems to me conntack is just right.
>
>
> thats true, but I'm wondering, is there any benefit in being
> strict about this? The chances of accidentally reopening an
> old connection are a lot smaller than breaking things as in
> this case. Or maybe we could add PAWS checks, although that
> would increase the conntrack size by another 8 bytes.
>
> Krzysztof, does the problem disappear if you use something
> like 30 s for the TIME_WAIT timeout?

No, as a delay between a new and an old happens to be <30s, for example:

* ~4s:
21:44:59.870913 IP (tos 0x0, ttl 1, id 42334, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.12.38485 > 192.168.50.21.80: F, cksum 0x0d2f=
 (correct), 3235585700:3235585700(0) ack 2584050074 win 54 <nop,nop,timesta=
mp 1812577946 32205200>
21:44:59.870998 IP (tos 0x0, ttl 128, id 13216, offset 0, flags [DF], proto=
 TCP (6), length 52) 192.168.50.21.80 > 192.168.150.12.38485: ., cksum 0x10=
d7 (correct), ack 3235585701 win 64652 <nop,nop,timestamp 32205201 18125779=
46>

21:45:03.379006 IP (tos 0x0, ttl 1, id 63436, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.12.38485 > 192.168.50.21.80: S, cksum 0x4896=
 (correct), 2494249856:2494249856(0) win 5840 <mss 1460,sackOK,timestamp 18=
12581452 0,nop,wscale 7>

* ~28s:

21:39:44.152045 IP (tos 0x0, ttl 1, id 49816, offset 0, flags [DF], proto T=
CP (6), length 52) 192.168.150.13.60522 > 192.168.50.51.80: F, cksum 0xd651=
 (correct), 1066479999:1066479999(0) ack 2447238194 win 46 <nop,nop,timesta=
mp 1812262227 12462265>
21:39:44.152247 IP (tos 0x0, ttl 128, id 29444, offset 0, flags [DF], proto=
 TCP (6), length 52) 192.168.50.51.80 > 192.168.150.13.60522: ., cksum 0xd8=
26 (correct), ack 1066480000 win 65112 <nop,nop,timestamp 12462265 18122622=
27>

21:44:12.884700 IP (tos 0x0, ttl 1, id 34935, offset 0, flags [DF], proto T=
CP (6), length 60) 192.168.150.13.60522 > 192.168.50.61.80: S, cksum 0x258d=
 (correct), 3536555879:3536555879(0) win 5840 <mss 1460,sackOK,timestamp 18=
12530960 0,nop,wscale 7>


Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2063523715-1191864210=:30123--
