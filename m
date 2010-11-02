From: Mistick Levi <gmistick@gmail.com>
Subject: Re: libnetfilter_queue exiting on big tcp sessions
Date: Tue, 2 Nov 2010 19:51:13 +0200
Message-ID: <AANLkTikRXtjo-0y9aAPmOQ_gAWfTAYM4D-eDfTwah8z6@mail.gmail.com>
References: <AANLkTimmr4MVCOwgxea9KoGB1BjomBchJ7oAgpnt2WyZ@mail.gmail.com>
 <AANLkTin_ZFeXkzJ6zELpX3pP3782YfLjHcPzHrjDt1Ae@mail.gmail.com> <AANLkTikV4_MD0JZzbvKhSXjL-abMDY7Af_3FTbbTzP33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Rajkumar S <rajkumars@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59884 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab0KBRvf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:51:35 -0400
In-Reply-To: <AANLkTikV4_MD0JZzbvKhSXjL-abMDY7Af_3FTbbTzP33@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This error is kind of showing up alot in this mailing list.. ( I'd
love to hear a response about my  thought on how to solve those
re-occurring mail's, in the last paragraph ).

What's causing this error is that you do not handle packet's fast enoug=
h...
meaning that you're callback takes time to finish, therefor it delay
the recv functions.
The bufferspace that is filling up is actually the socket buffer.. the
fd you work the recv function on...
You can tune the socket buffer size, though it won't help because with
time you're buffer will fill up.
and as such you must handle you're packets asap, maybe in a different
thread( if you have multiple cpu's otherwise its kind of a waste).

I hope this mail will be available as an answer to everyone searching
this error on the web.. i know that when i looked for it, i found very
little information.

Maybe this information should be added to the doc's or maybe we could
create a Wiki for netfilter that will help newcomers and solve most of
those problems before they get to the mailing list, thus leaving the
mailing list for new issue's as they arise.


Kind Regards
Yechiel Levi

On Tue, Nov 2, 2010 at 7:30 PM, Rajkumar S <rajkumars@gmail.com> wrote:
> Hi,
>
> Thanks for the reply, you were spot on. I removed && rv >=3D 0 and no=
w
> it's working fine.
>
> btw, what could have caused buffer space unavailable error?
>
> Thanks and regards,
>
> raj
>
> On Tue, Nov 2, 2010 at 10:30 PM, Mistick Levi <gmistick@gmail.com> wr=
ote:
>> Hi,
>>
>> Well, if you didn't change the nfqnl_test program at all, what i thi=
nk
>> happend is that you got : buffer space unavailable error...
>>
>> meaning that in you're loop ( " =A0 =A0 =A0 =A0while ((rv =3D recv(f=
d, buf,
>> sizeof(buf), 0)) && rv >=3D 0) "
>> you get rv < 0, and then you exit properly.
>> You could ignore this "recv error" and just continue on packeting.
>>
>> Try removing the "( && rv >=3D 0 ) =A0,and let us know if it helped.
>>
>> Kind Regards,
>> Yechiel Levi
>>
>> On Tue, Nov 2, 2010 at 5:46 PM, Rajkumar S <rajkumars@gmail.com> wro=
te:
>>> Hi all,
>>>
>>> I am using latest git checkout of libnetfilter_queue and libnfnetli=
nk
>>> on debian etch with kernel 2.6.26-2-686. The iptables rules used wh=
ile
>>> testing are:
>>>
>>> -A INPUT -s 192.168.3.22/32 -m state --state NEW,ESTABLISHED -j
>>> NFQUEUE --queue-num 0
>>> -A OUTPUT -d 192.168.3.22/32 -m state --state NEW,ESTABLISHED -j
>>> NFQUEUE --queue-num 0
>>>
>>> I am using utils/nfqnl_test.c as my test program and using wget to =
get
>>> a file from 192.168.3.22 for testing. The program runs okay when
>>> getting smaller files but if number of packets go above say 200
>>> nfqnl_test exits with following message:
>>>
>>> hw_protocol=3D0x0800 hook=3D1 id=3D389 hw_src_addr=3D00:14:2a:c9:e1=
:5d indev=3D2
>>> payload_len=3D1500
>>> entering callback
>>> hw_protocol=3D0x0800 hook=3D1 id=3D390 hw_src_addr=3D00:14:2a:c9:e1=
:5d indev=3D2
>>> payload_len=3D1500
>>> entering callback
>>> closing library handle
>>>
>>> The number of packets to trigger this condition varies from say 200=
 to
>>> about 1000 and changes with each run.
>>>
>>> dmesg does not show any error, the last lines of dmesg are:
>>> [76465.470246] ip_tables: (C) 2000-2006 Netfilter Core Team
>>> [92735.818567] Netfilter messages via NETLINK v0.30.
>>> [92793.863824] nf_conntrack version 0.5.0 (6144 buckets, 24576 max)
>>>
>>> Before testing with compiled git version I was trying with ubuntu
>>> (lucid) and nfqueue-bindings for python and got the same error.
>>>
>>> I am not sure what goes wrong here, I can help with any debug steps=
 to
>>> find out the exact error if required. Any help to locate and fix th=
is
>>> issue is much appreciated.
>>>
>>> with regards,
>>>
>>> raj
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe netfilter=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
