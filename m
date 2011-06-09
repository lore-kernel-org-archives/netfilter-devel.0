From: Tihomir Katic <tihomir.katic@gmail.com>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 16:25:53 +0200
Message-ID: <BANLkTimwCf_pp8ejd8Bex93xPTveLPX7ow@mail.gmail.com>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
	<alpine.LNX.2.01.1106091530110.22244@frira.zrqbmnf.qr>
	<BANLkTi=Ggxj5Pv1t8H_S4gqEWGQwP=iWqA@mail.gmail.com>
	<alpine.LNX.2.01.1106091615510.31505@frira.zrqbmnf.qr>
	<BANLkTikkY=Hcksw7Lb8CvgD+fhDN=TtCJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64688 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1FIOZz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:25:55 -0400
Received: by iyb14 with SMTP id 14so1348264iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 07:25:53 -0700 (PDT)
In-Reply-To: <BANLkTikkY=Hcksw7Lb8CvgD+fhDN=TtCJg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> This should be -m multiport --dports 1:5,21:25
Yes, you are right about this, but I didn't know Iptables can work
like this (have range in "array" list), I noticed it recently, so this
in plan to add

http://valeria.zesoi.fer.hr/~tkatic/index.php?appl=3Dfea

Plans for future development:
 -  Allow multiport parameter to contain arrays together with single nu=
mbers


2011/6/9 Tihomir Katic <tihomir.katic@gmail.com>:
>>That is purely noise. You need a lot more rules (10000 and up) to
>>measure an effect.
>
> I've been testing, list with 1000 rules, list with 10000 rules, list
> with 50000 rules.
> Searching for minimum time, in 100 tests, etc.
>
> 1 MIN ( 1000 single): =A00.206000 us
> 1 MIN (1000 array): =A00.264000 us
>
> 1 MIN (10000 single): =A00.081400 us
> 1 MIN (10000 array): =A00.156900 us
>
> I couldn't restore 50000 array command (memory issue) on Iptables 1.4=
=2E4
>
> But it can be restored on 1.2.9 (don't have right now results for tha=
t)
>
> Br
>
>
> 2011/6/9 Jan Engelhardt <jengelh@medozas.de>:
>> On Thursday 2011-06-09 16:07, Tihomir Katic wrote:
>>>
>>>Also, I have been doing some tests, and in config.txt you will see:
>>>## Optimal size of multiport - port array
>>>port_array_size_optimal =3D 10
>>>
>>>It means, it will merge 2 rules for example --dport 1:5 and --dport
>>>21:25 into -m multiport --dports 1,2,3,4,5,21,22,23,24,25
>>
>> This should be -m multiport --dports 1:5,21:25
>>
>>>But, based on my recent tests, it should be
>>>port_array_size_optimal =3D 15
>>
>> Yes, multiport can hold 15 "things".
>>
>>>rule with =A0--dport 1:5 =A0takes e.g. ~0.2 us
>>>and rule with 15 elements in multiport array lasts ~0.4us, so it is
>>>pretty much the same
>>
>> That is purely noise. You need a lot more rules (10000 and up) to
>> measure an effect.
>>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
