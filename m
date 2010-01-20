From: Mistick Levi <gmistick@gmail.com>
Subject: Re: libnetfilter_queue - remove packet from kernel buffer, and
	reinject later
Date: Wed, 20 Jan 2010 22:13:14 +0200
Message-ID: <6c279bde1001201213h724a22cfvc9c8e51538156ec2@mail.gmail.com>
References: <6c279bde1001191125u28fa13a4i4fd7973cf950cccc@mail.gmail.com>
	 <1263941697.4571.46.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:52094 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0ATUU7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:20:59 -0500
Received: by bwz22 with SMTP id 22so1597322bwz.25
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2010 12:20:58 -0800 (PST)
In-Reply-To: <1263941697.4571.46.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2010/1/20 Eric Leblond <eric@inl.fr>:
> Hello,
>
> Le mardi 19 janvier 2010 =E0 21:25 +0200, Mistick Levi a =E9crit :
>> Hi,
>> I've worked with libipq, and libnetfilter_queue, and i got to a plac=
e
>> where my userspace code can't get anymore packets( with the message:
>> netlink message: no buffer space available ) .
>>
>> Now what i want to do is this:
>> Read a packet from the queue, copy it to my own queue/location in my
>> program, and re injecting the packet later on with my verdict, after=
 i
>> finished.
>
> This is how it works ;)
>
> In fact, the 'no buffer space available' message is due to your progr=
am
> not getting packets as fast as needed: The kernel is sending packet t=
o a
> netlink socket and the internal buffer of the socket gets filled with
> the packets waiting to be read.
>
> What you need to do is:
> =A0 =A0 =A0* read packet as fast as you can (your callback function h=
as to be
> =A0 =A0 =A0 =A0fast)
> =A0 =A0 =A0* do the intensive or delay needing work outside of the ca=
llback
> =A0 =A0 =A0 =A0(via a thread or something)

What do you mean by doing the delay needing work outside of the
callback? in the end of the callback i should give a verdict, no ?

>
> It last option is not possible, you can increase the netlink buffer s=
ize
> via the nfnl_rcvbufsiz function. "Standard" syntax is the following:
> =A0 =A0 =A0 =A0nfnl_rcvbufsiz(nfq_nfnlh(my_nfq_handle), NFQ_NF_BUFSIZ=
E);
>

I will try that. what i have tried so far is increasing the:
wmem_default, wmem_max, rmem_default and rmem_max.
> BR,
>
>>
>> but to my best of my understanding, until i send a verdict the packe=
t
>> still takes place in the queue.
>> and i've read something about using NF_STOLEN and then reinject, but=
 i
>> dont think that NF_STOLEN is a valid verdict.
>>
>> Any ideas on how i can do what it is i wish to do? ( Clear the kerne=
l
>> queue by transferring the packets to my queue ).
>>
>> Kind regards
>> Levi Yechiel
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-=
devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> Eric Leblond <eric@inl.fr>
> INL: http://www.inl.fr/
> NuFW: http://www.nufw.org/
>
Well, I have to do some logic before deciding if the packet ACCEPTED
or DROPPED. and the callback is the one that decide that(send the
verdict),

My original phrasing was bad so :
Question: is it possible to take the packet out from the internal
socket(as with nfq_handle packet or recv() ) and return some verdict
like: "NF_STOLEN" ,then do the delay needing work, and then re inject
the packet to continue its normal traversal.

Thanks in advance,
Levi Yechiel
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
