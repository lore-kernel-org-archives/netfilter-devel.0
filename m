From: Mistick Levi <gmistick@gmail.com>
Subject: Re: libnetfilter_queue exiting on big tcp sessions
Date: Wed, 3 Nov 2010 07:06:02 +0200
Message-ID: <AANLkTinQ6Q3B7XbdaCRJ9Qr0bTf6VGjLVkjgUtXaSjjk@mail.gmail.com>
References: <AANLkTimmr4MVCOwgxea9KoGB1BjomBchJ7oAgpnt2WyZ@mail.gmail.com>
 <AANLkTin_ZFeXkzJ6zELpX3pP3782YfLjHcPzHrjDt1Ae@mail.gmail.com>
 <AANLkTikV4_MD0JZzbvKhSXjL-abMDY7Af_3FTbbTzP33@mail.gmail.com>
 <AANLkTikRXtjo-0y9aAPmOQ_gAWfTAYM4D-eDfTwah8z6@mail.gmail.com> <AANLkTikxw3dyv6SUVo4O36sHhVM+eZfgb1A5sX-tCM1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Rajkumar S <rajkumars@gmail.com>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41926 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0KCFGY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 01:06:24 -0400
In-Reply-To: <AANLkTikxw3dyv6SUVo4O36sHhVM+eZfgb1A5sX-tCM1b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Justin,

Is you're recv error(-1) print's : bufferspace unavailable?  If so,
the problem is not with the tcp sequence, and the multiple tcp
sessions, it is again with the face that you're process take's alot of
time..
I don't recommend using more threads than you're cpu count, and
ofcourse try using a thread pool..
 (If someone has better knowledge of schedulers in userland, please
input here ).

even if you are dispatching the packet to a different thread to work /
queue .( as in thread pool ), maybe the throughput you are getting is
way over you're processing capability.
(Also, if anyone was successful in doing deep processing on packets
with libnetfilter_queue, and was successful in outstanding big
throughputs, you're input will be appreciated here )

If you want, you can increase the buffer space size, and i said in my
previous mail, but it will not solve the issue, since over time / more
tcp sessions, even that buffer will fill up. Increasing the buffer can
be done via: "nfnl_rcvbufsiz(nfq_nfnlh(my_nfq_handle),
NFQ_NF_BUFSIZE);" ..

NOTE: if you write to hdd while processing, don't / use an advanced
flushing method's in order to avoid writing to disk so much... for
example try using syslog... )

Kind regards
Yechiel Levi.

On Wed, Nov 3, 2010 at 3:53 AM, Justin Yaple <yaplej@gmail.com> wrote:
> Yechiel,
>
> Thank you so much I have been trying to figure this exact issue out
> for the past few day and was getting nowhere. =A0Your suggestion to
> ignore the error and keep going worked fine but not sure if its the
> best solution.
>
> On Tue, Nov 2, 2010 at 10:51 AM, Mistick Levi <gmistick@gmail.com> wr=
ote:
>> Hi,
>>
>> This error is kind of showing up alot in this mailing list.. ( I'd
>> love to hear a response about my =A0thought on how to solve those
>> re-occurring mail's, in the last paragraph ).
>>
>> What's causing this error is that you do not handle packet's fast en=
ough...
>> meaning that you're callback takes time to finish, therefor it delay
>> the recv functions.
>> The bufferspace that is filling up is actually the socket buffer.. t=
he
>> fd you work the recv function on...
>> You can tune the socket buffer size, though it won't help because wi=
th
>> time you're buffer will fill up.
>> and as such you must handle you're packets asap, maybe in a differen=
t
>> thread( if you have multiple cpu's otherwise its kind of a waste).
>
> My application already using multiple threads one to recv() packets
> from the queue and then one or several others to do more advanced
> processing (ie compression/optimizations on TCP segments). =A0When an=
y
> more than 1 TCP session was being processed I would get rv =3D -1.
>
> My project allows packets that don't need advanced processing to
> bypass this in the queue handler function so it can causes packets to
> be returned to the queue out of order when there is more than 1
> session involved. =A0These could be SYN packets for new sessions that
> dont carry any data so bypass the internal processing queues
> altogether.
>
> Is this the problem here that packets being nfq_set_verdict() out of
> queue order causing the rv =3D -1? =A0I am handling packets in a mann=
er
> than ensures that is processes TCP sessions in sequence but not
> necessarily in the order received by the queue.
>
> Perhaps there is a nfq_set_verdict() that would inform the queue that
> the process is holding this packet so go ahead and move on to the nex=
t
> packet in the queue?
>
> Again thanks,
> Justin.
>
>>
>> I hope this mail will be available as an answer to everyone searchin=
g
>> this error on the web.. i know that when i looked for it, i found ve=
ry
>> little information.
>>
>> Maybe this information should be added to the doc's or maybe we coul=
d
>> create a Wiki for netfilter that will help newcomers and solve most =
of
>> those problems before they get to the mailing list, thus leaving the
>> mailing list for new issue's as they arise.
>>
>>
>> Kind Regards
>> Yechiel Levi
>>
>> On Tue, Nov 2, 2010 at 7:30 PM, Rajkumar S <rajkumars@gmail.com> wro=
te:
>>> Hi,
>>>
>>> Thanks for the reply, you were spot on. I removed && rv >=3D 0 and =
now
>>> it's working fine.
>>>
>>> btw, what could have caused buffer space unavailable error?
>>>
>>> Thanks and regards,
>>>
>>> raj
>>>
>>> On Tue, Nov 2, 2010 at 10:30 PM, Mistick Levi <gmistick@gmail.com> =
wrote:
>>>> Hi,
>>>>
>>>> Well, if you didn't change the nfqnl_test program at all, what i t=
hink
>>>> happend is that you got : buffer space unavailable error...
>>>>
>>>> meaning that in you're loop ( " =A0 =A0 =A0 =A0while ((rv =3D recv=
(fd, buf,
>>>> sizeof(buf), 0)) && rv >=3D 0) "
>>>> you get rv < 0, and then you exit properly.
>>>> You could ignore this "recv error" and just continue on packeting.
>>>>
>>>> Try removing the "( && rv >=3D 0 ) =A0,and let us know if it helpe=
d.
>>>>
>>>> Kind Regards,
>>>> Yechiel Levi
>>>>
>>>> On Tue, Nov 2, 2010 at 5:46 PM, Rajkumar S <rajkumars@gmail.com> w=
rote:
>>>>> Hi all,
>>>>>
>>>>> I am using latest git checkout of libnetfilter_queue and libnfnet=
link
>>>>> on debian etch with kernel 2.6.26-2-686. The iptables rules used =
while
>>>>> testing are:
>>>>>
>>>>> -A INPUT -s 192.168.3.22/32 -m state --state NEW,ESTABLISHED -j
>>>>> NFQUEUE --queue-num 0
>>>>> -A OUTPUT -d 192.168.3.22/32 -m state --state NEW,ESTABLISHED -j
>>>>> NFQUEUE --queue-num 0
>>>>>
>>>>> I am using utils/nfqnl_test.c as my test program and using wget t=
o get
>>>>> a file from 192.168.3.22 for testing. The program runs okay when
>>>>> getting smaller files but if number of packets go above say 200
>>>>> nfqnl_test exits with following message:
>>>>>
>>>>> hw_protocol=3D0x0800 hook=3D1 id=3D389 hw_src_addr=3D00:14:2a:c9:=
e1:5d indev=3D2
>>>>> payload_len=3D1500
>>>>> entering callback
>>>>> hw_protocol=3D0x0800 hook=3D1 id=3D390 hw_src_addr=3D00:14:2a:c9:=
e1:5d indev=3D2
>>>>> payload_len=3D1500
>>>>> entering callback
>>>>> closing library handle
>>>>>
>>>>> The number of packets to trigger this condition varies from say 2=
00 to
>>>>> about 1000 and changes with each run.
>>>>>
>>>>> dmesg does not show any error, the last lines of dmesg are:
>>>>> [76465.470246] ip_tables: (C) 2000-2006 Netfilter Core Team
>>>>> [92735.818567] Netfilter messages via NETLINK v0.30.
>>>>> [92793.863824] nf_conntrack version 0.5.0 (6144 buckets, 24576 ma=
x)
>>>>>
>>>>> Before testing with compiled git version I was trying with ubuntu
>>>>> (lucid) and nfqueue-bindings for python and got the same error.
>>>>>
>>>>> I am not sure what goes wrong here, I can help with any debug ste=
ps to
>>>>> find out the exact error if required. Any help to locate and fix =
this
>>>>> issue is much appreciated.
>>>>>
>>>>> with regards,
>>>>>
>>>>> raj
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe netfilt=
er" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>>>>>
>>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
