From: Tihomir Katic <tihomir.katic@gmail.com>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 17:55:59 +0200
Message-ID: <BANLkTik6n1wj7LgYDHmkR5zzDuGeD_VFGw@mail.gmail.com>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com>
	<alpine.LNX.2.01.1106091530110.22244@frira.zrqbmnf.qr>
	<BANLkTi=Ggxj5Pv1t8H_S4gqEWGQwP=iWqA@mail.gmail.com>
	<alpine.LNX.2.01.1106091615510.31505@frira.zrqbmnf.qr>
	<BANLkTikkY=Hcksw7Lb8CvgD+fhDN=TtCJg@mail.gmail.com>
	<alpine.LNX.2.01.1106091632200.31505@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49720 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1FIP4A convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:56:00 -0400
Received: by iyb14 with SMTP id 14so1420869iyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jun 2011 08:55:59 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1106091632200.31505@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This times are per 1 command.So total time is

 {
1 MIN ( 1000 single):  0.206000 us
1 MIN ( 1000 array):  0.264000 us
1 MIN ( 1000 range):  0.182000 us
} x 1000
=3D
(10000 single):  206 us
(10000 array):  264 us
(10000 range):  182 us

and
{
1 MIN (10000 single):  0.081400 us
1 MIN (10000 array):  0.156900 us
1 MIN (10000 range):  0.081900 us
}  x 10000
=3D
(10000 single):  814 us
(10000 array):  1569 us
(10000 range):  819 us


Of course there is some noise ..., but in general 1 rule with array
list (15 single numbers) is in worst case same as 2 rules (1 single
number).
So with current implementation, 15 single ports can be generated from
2 rules (e.g. --dport 80 and --dport 101:114)

But, I must allow ranges in multiport parameter, and than this
discussion will not be needed.

Br


2011/6/9 Jan Engelhardt <jengelh@medozas.de>:
> On Thursday 2011-06-09 16:23, Tihomir Katic wrote:
>
>>>That is purely noise. You need a lot more rules (10000 and up) to
>>>measure an effect.
>>
>>I've been testing, list with 1000 rules, list with 10000 rules, list
>>with 50000 rules.
>>Searching for minimum time, in 100 tests, etc.
>>
>>1 MIN ( 1000 single): =A00.206000 us
>>1 MIN (1000 array): =A00.264000 us
>>
>>1 MIN (10000 single): =A00.081400 us
>>1 MIN (10000 array): =A00.156900 us
>
> It seems you are not executing all rules. How else could 10k rules be
> faster than 1k? You must not use any -j.
>
> What you need is something like:
>
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> -A INPUT -p tcp -m multiport --dport 1:5,20:25
> COMMIT
> # Completed on Thu Jun =A09 16:33:15 2011
>
> (of course, replicating this to 1000 rules), and then sending yoursel=
f
> some packet and measure the RTT.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
