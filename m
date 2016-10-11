From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: routing table lookup
Date: Tue, 11 Oct 2016 22:18:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1610112203020.5047@nerf40.vanv.qr>
References: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com> <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr> <CAJO99Tn0yTE1=dFMO--vj9KpMt2kgRfURu8-GoXy=KZDRymOQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:35612 "EHLO ares41.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753412AbcJKUTJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 16:19:09 -0400
In-Reply-To: <CAJO99Tn0yTE1=dFMO--vj9KpMt2kgRfURu8-GoXy=KZDRymOQw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2016-10-11 21:10, Bjørnar Ness wrote:
>2016-10-11 20:28 GMT+02:00 Jan Engelhardt <jengelh@inai.de>:
>> Well you can mark routes with realm numbers, and match on that. (In
>> iptables, this was done with -m realm.) At least that is the idea. Not
>> sure if the skb field that holds the information is already
>> filled in before FORWARD (at which point I guess it will contain the
>> dst realm anyway).
>
>I think you misunderstood what I am looking for here, for example:
>prerouting:
>ip saddr route table 10 drop

Assuming you mean "saddr is in {the set of dst addrs in table 10}"
then it's as I said - basically rpfilter with sort of an extra check
for the realm number (which you can make the same as the table number).
