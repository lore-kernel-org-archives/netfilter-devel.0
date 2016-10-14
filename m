From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: routing table lookup
Date: Fri, 14 Oct 2016 18:48:28 +0200
Message-ID: <CAJO99T=NxgSu8_J-nK4FQW6yw2b_+KsSwS04chxv93YoTxkoOw@mail.gmail.com>
References: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
 <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr> <CAJO99Tn0yTE1=dFMO--vj9KpMt2kgRfURu8-GoXy=KZDRymOQw@mail.gmail.com>
 <alpine.LSU.2.20.1610112203020.5047@nerf40.vanv.qr> <CAJO99TnPeGz81C8iP_gg3uD4Y3epDBg5BwWex6RWT0YR93eceg@mail.gmail.com>
 <20161012061930.GA28142@unicorn.suse.cz> <CAJO99TnLzTbtTZP_DKE37eG_+X3T5b1g5rbhVTGz07RDgShDPw@mail.gmail.com>
 <20161014114421.GB10404@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Michal Kubecek <mkubecek@suse.cz>,
        Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34759 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbcJNQs3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 12:48:29 -0400
Received: by mail-yw0-f169.google.com with SMTP id w3so78063208ywg.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 09:48:29 -0700 (PDT)
In-Reply-To: <20161014114421.GB10404@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-10-14 13:44 GMT+02:00 Florian Westphal <fw@strlen.de>:
> Bj=C3=B8rnar Ness <bjornar.ness@gmail.com> wrote:
>>
>> ip saddr rt_table 10 drop
>>
>> comments?
>
> I don't really understand why you would want this.
>
> If you only want to match saddr, why not use ipset (or nftables set) for
> this?

Its hard to populate via routing protocols. RTBH/ Source RTBH is very
convenient, and handles all the details (filtering, timeout etc etc) in rou=
ting
daemon (bird in my case). It is ofcorse possible to make a middleware that
listens for updates on a routing table, and propagates them to a set, but
thats what I would want to and could avoid if I was given access to a
"set type" lookup in a spesific table.

> If you want to use the fib, why not use blackhole routes?

Because there is not possible to do saddr based lookups in prerouting,
the only way this is possible is if one enables rp_filter and packet will
the have traveled far inside the kernel already. Also, it is not possible
to send ICMP unreachable for example using rp_filter method

> I'd like to understand why you need this 'rule skip' thing, seems we
> would have to export some fib internals for this which I'd like to
> avoid.

I hope You can see the use of this. And it also probably has other usecases=
.

Regards,
--
Bj(/)rnar
