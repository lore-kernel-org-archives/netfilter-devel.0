From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: routing table lookup
Date: Tue, 11 Oct 2016 21:10:15 +0200
Message-ID: <CAJO99Tn0yTE1=dFMO--vj9KpMt2kgRfURu8-GoXy=KZDRymOQw@mail.gmail.com>
References: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
 <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:36466 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751749AbcJKUNC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Oct 2016 16:13:02 -0400
Received: by mail-yw0-f176.google.com with SMTP id u124so20657929ywg.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Oct 2016 13:13:02 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-10-11 20:28 GMT+02:00 Jan Engelhardt <jengelh@inai.de>:
> Well you can mark routes with realm numbers, and match on that. (In
> iptables, this was done with -m realm.) At least that is the idea. Not
> sure if the skb field that holds the information is already
> filled in before FORWARD (at which point I guess it will contain the
> dst realm anyway).

I think you misunderstood what I am looking for here, for example:

prerouting:

ip saddr route table 10 drop

-- 
Bj(/)rnar
