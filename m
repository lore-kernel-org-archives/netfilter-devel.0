From: =?UTF-8?Q?Tomasz_Chili=C5=84ski?= <tomasz.chilinski@chilan.com>
Subject: Re: new ipset set type - hash:ip,mac
Date: Mon, 25 Apr 2016 16:10:05 +0200
Message-ID: <78dcb7edbf2bf1016069cd5dfe88f862@chilan.com>
References: <8357c05ce35b35c21e8e06dd43f4d5b8@chilan.com>
 <alpine.DEB.2.10.1604251117280.5773@blackhole.kfki.hu>
Reply-To: tomasz.chilinski@chilan.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_bf8ce514491d52695b4c029ad8bbf179"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.chilan.com ([185.127.120.5]:51470 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbcDYOKR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 10:10:17 -0400
Received: from mail.chilan.com (lord.chilan.com [127.0.0.1])
	by mail.chilan.com (Postfix) with ESMTP id AB8807E2AF2
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 16:10:05 +0200 (CEST)
Received: from mail.chilan.com (mail.chilan.com [185.127.120.5])
	by mail.chilan.com (Postfix) with ESMTPA id 9384E7E2AF1
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 16:10:05 +0200 (CEST)
In-Reply-To: <alpine.DEB.2.10.1604251117280.5773@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--=_bf8ce514491d52695b4c029ad8bbf179
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

W dniu 25.04.2016 11:18, Jozsef Kadlecsik napisał(a):
> On Sun, 24 Apr 2016, Tomasz Chiliński wrote:
> 
>> First - thanks a lot for excellent ipset toolkit!
>> Second - Sorry for posting directly to you, but didn't get reply from
>> netfilter-devel
>> mailing list after trying to subscribe there.
>> 
>> I've created lately my own very missed set type hash:ip,mac
>> which stored any ipv4/ipv6 - mac pairs using hashing structures.
>> It allows to create only single set with all addresses and macs
>> used in quite large lans without bothering with separated sets
>> for different ip segments.
>> 
>> I've attached patches for kernel 4.1 and ipset 6.29.
>> I could also prepare for newer kernel versions if one would be
>> interested in it ;-)
>> 
>> Any feedback or small review would be very appreciated!
> 
> Thanks your patch, I'll review and report back.

Missed man entry in attachment.

> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of 
> Sciences
>           H-1525 Budapest 114, POB. 49, Hungary

-- 
Pozdrawiam
Tomasz Chiliński, Chilan

--=_bf8ce514491d52695b4c029ad8bbf179
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=ipset-6.29-hash-ipmac-man.patch
Content-Disposition: attachment;
 filename=ipset-6.29-hash-ipmac-man.patch;
 size=1239

LS0tIGEvc3JjL2lwc2V0LjgJMjAxNi0wMy0xNiAwOTowNzoxOC4wMDAwMDAwMDAgKzAxMDAKKysr
IGIvc3JjL2lwc2V0LjgJMjAxNi0wNC0yNSAxNjowMTo1NS4wOTA5OTQ2MzEgKzAyMDAKQEAgLTU1
MSw2ICs1NTEsMjggQEAKIC5JUAogaXBzZXQgdGVzdCBmb28gMDE6MDI6MDM6MDQ6MDU6MDYKIAor
LlNTIGhhc2g6aXAsbWFjCitUaGUgXGZCaGFzaDppcCxtYWNcZlIgc2V0IHR5cGUgdXNlcyBhIGhh
c2ggdG8gc3RvcmUgSVB2NCBhbmQgYSBNQUMgYWRkcmVzcyBwYWlycy4gWmVybyB2YWx1ZWQgTUFD
IGFkZHJlc3NlcyBjYW5ub3QgYmUgc3RvcmVkIGluIGEgXGZCaGFzaDppcCxtYWNcZlIKK3R5cGUg
b2Ygc2V0LgorLlBQCitcZklDUkVBVEVcLU9QVElPTlNcZlIgOj0gWyBcZkJoYXNoc2l6ZVxmUiBc
Zkl2YWx1ZVxmUiBdIFsgXGZCbWF4ZWxlbVxmUiBcZkl2YWx1ZVxmUiBdIFsgXGZCdGltZW91dFxm
UiBcZkl2YWx1ZVxmUiBdIFsgXGZCY291bnRlcnNcZlAgXSBbIFxmQmNvbW1lbnRcZlAgXSBbIFxm
QnNrYmluZm9cZlAgXQorLlBQCitcZklBRERcLUVOVFJZXGZSIDo9IFxmSWlwXGZSLFxmSW1hY2Fk
ZHJcZlIKKy5QUAorXGZJQUREXC1PUFRJT05TXGZSIDo9IFsgXGZCdGltZW91dFxmUiBcZkl2YWx1
ZVxmUiBdIFsgXGZCcGFja2V0c1xmUiBcZkl2YWx1ZVxmUiBdIFsgXGZCYnl0ZXNcZlIgXGZJdmFs
dWVcZlIgXSBbIFxmQmNvbW1lbnRcZlIgXGZJc3RyaW5nXGZSIF0gWyBcZkJza2JtYXJrXGZSIFxm
SXZhbHVlXGZSIF0gWyBcZkJza2JwcmlvXGZSIFxmSXZhbHVlXGZSIF0gWyBcZkJza2JxdWV1ZVxm
UiBcZkl2YWx1ZVxmUiBdCisuUFAKK1xmSURFTFwtRU5UUllcZlIgOj0gXGZJaXBcZlIsXGZJbWFj
YWRkclxmUgorLlBQCitcZklURVNUXC1FTlRSWVxmUiA6PSBcZklpcFxmUixcZkltYWNhZGRyXGZS
CisuUFAKK0V4YW1wbGVzOgorLklQCitpcHNldCBjcmVhdGUgZm9vIGhhc2g6aXAsbWFjCisuSVAK
K2lwc2V0IGFkZCBmb28gMS4xLjEuMSwwMTowMjowMzowNDowNTowNgorLklQCitpcHNldCB0ZXN0
IGZvbyAxLjEuMS4xLDAxOjAyOjAzOjA0OjA1OjA2CisKIC5TUyBoYXNoOm5ldAogVGhlIFxmQmhh
c2g6bmV0XGZSIHNldCB0eXBlIHVzZXMgYSBoYXNoIHRvIHN0b3JlIGRpZmZlcmVudCBzaXplZCBJ
UCBuZXR3b3JrIGFkZHJlc3Nlcy4KIE5ldHdvcmsgYWRkcmVzcyB3aXRoIHplcm8gcHJlZml4IHNp
emUgY2Fubm90IGJlIHN0b3JlZCBpbiB0aGlzIHR5cGUgb2Ygc2V0cy4K
--=_bf8ce514491d52695b4c029ad8bbf179--

