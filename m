From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: routing table lookup
Date: Wed, 12 Oct 2016 17:19:20 +0200
Message-ID: <CAJO99TnLzTbtTZP_DKE37eG_+X3T5b1g5rbhVTGz07RDgShDPw@mail.gmail.com>
References: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
 <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr> <CAJO99Tn0yTE1=dFMO--vj9KpMt2kgRfURu8-GoXy=KZDRymOQw@mail.gmail.com>
 <alpine.LSU.2.20.1610112203020.5047@nerf40.vanv.qr> <CAJO99TnPeGz81C8iP_gg3uD4Y3epDBg5BwWex6RWT0YR93eceg@mail.gmail.com>
 <20161012061930.GA28142@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:34331 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754043AbcJLPTV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 11:19:21 -0400
Received: by mail-yw0-f170.google.com with SMTP id w3so34934787ywg.1
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2016 08:19:21 -0700 (PDT)
In-Reply-To: <20161012061930.GA28142@unicorn.suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-10-12 8:19 GMT+02:00 Michal Kubecek <mkubecek@suse.cz>:
> On Wed, Oct 12, 2016 at 12:17:24AM +0200, Bj=C3=B8rnar Ness wrote:
>>
>> Yeah, sortoff. But afaik rpfilter is a iptables module, and not
>> available in nftables yet.
>>
>> Pablo: is the "lookup in routing table from nftables" a total waste of t=
ime?
>
> You may be interested in
>
>   https://www.youtube.com/watch?v=3DwfWMPlZHQBk&t=3D19m40s

Thanks, Michal, this is interesting, but not exactly what I am looking
for. This fib module
would as far as I can tell follow the routing from rules -> table ->
decision, which will need
both a src and dst address. What I want is to skip the rule matching,
and check directly in
a table, that way we only need a single address, and the following
should potentially work
from prerouting:

ip saddr rt_table 10 drop

comments?

--=20
Bj(/)rnar
