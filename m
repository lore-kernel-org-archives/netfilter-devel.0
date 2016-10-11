From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: routing table lookup
Date: Wed, 12 Oct 2016 00:17:24 +0200
Message-ID: <CAJO99TnPeGz81C8iP_gg3uD4Y3epDBg5BwWex6RWT0YR93eceg@mail.gmail.com>
References: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
 <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr> <CAJO99Tn0yTE1=dFMO--vj9KpMt2kgRfURu8-GoXy=KZDRymOQw@mail.gmail.com>
 <alpine.LSU.2.20.1610112203020.5047@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:35848 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753156AbcJKWR0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 18:17:26 -0400
Received: by mail-yb0-f177.google.com with SMTP id 191so13386029ybv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Oct 2016 15:17:25 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1610112203020.5047@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-10-11 22:18 GMT+02:00 Jan Engelhardt <jengelh@inai.de>:
>
> On Tuesday 2016-10-11 21:10, Bj=C3=B8rnar Ness wrote:
>>2016-10-11 20:28 GMT+02:00 Jan Engelhardt <jengelh@inai.de>:
>>> Well you can mark routes with realm numbers, and match on that. (In
>>> iptables, this was done with -m realm.) At least that is the idea. Not
>>> sure if the skb field that holds the information is already
>>> filled in before FORWARD (at which point I guess it will contain the
>>> dst realm anyway).
>>
>>I think you misunderstood what I am looking for here, for example:
>>prerouting:
>>ip saddr route table 10 drop
>
> Assuming you mean "saddr is in {the set of dst addrs in table 10}"
> then it's as I said - basically rpfilter with sort of an extra check
> for the realm number (which you can make the same as the table number).

Yeah, sortoff. But afaik rpfilter is a iptables module, and not
available in nftables yet.

Pablo: is the "lookup in routing table from nftables" a total waste of time=
?

--=20
Bj(/)rnar
