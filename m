From: Patrick Schaaf <bof@bof.de>
Subject: Re: Writing metadata to a packet
Date: Fri, 31 Mar 2017 08:29:12 +0200
Message-ID: <CAJ26g5TYNQ63e_JP8v10u6suU+Gd7RwHYxa8My_NhJrdGPH2Uw@mail.gmail.com>
References: <577C8ADD.60007@oracle.com> <1467793086.1273.12.camel@edumazet-glaptop3.roam.corp.google.com>
 <58DDE622.8070107@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Vikas <vikas.c.kumar@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:54978 "EHLO
        mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932268AbdCaGiv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2017 02:38:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by mars.intermailgate.com (Postfix) with ESMTP id DB87E25E34
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 08:29:15 +0200 (CEST)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com [209.85.214.54])
        by mars.intermailgate.com (Postfix) with ESMTPSA id AAC7B25E23
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2017 08:29:14 +0200 (CEST)
Received: by mail-it0-f54.google.com with SMTP id 190so6979211itm.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2017 23:29:14 -0700 (PDT)
In-Reply-To: <58DDE622.8070107@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Vikas,

in a very controlled environment, loadbalancer to real servers, I'm
doing that using the IP TOS / DSCP header bits - manipulating them
using the TOS target, on the loadbalancer, in mangle/PREROUTING rules,
and matching them using the tos match on the realservers (nat
PREROUTING) to effect REDIRECT to different local ports (various
apache listening ports).

Not for the faint of heart...

There is no nice wide standard "I've got these bits to freely set and
get them to arbitrary destinations" mechanism on the IP or TCP layer.
netfilter can't invent such...

best regards
  Patrick


On Fri, Mar 31, 2017 at 7:16 AM, Vikas <vikas.c.kumar@oracle.com> wrote:
> Hi,
>
> I was wondering if how we can set some user specified values when we punt a
> packet from source to destination in a infrastructure which uses netfilter?
> More precisely at the source side so that when packet reaches destination
> host, it can decode the metadata values.
> Is their a way out? Any pointer/link would be appreciated.
>
> Regards
> Vikas
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
