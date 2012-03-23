From: Fr3DBr <fr3dbr@gmail.com>
Subject: Re: Netfilter Packet Reinjection
Date: Fri, 23 Mar 2012 19:12:27 -0300
Message-ID: <CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jeff Haran <jharan@bytemobile.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35007 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab2CWWM2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:12:28 -0400
Received: by yhmm54 with SMTP id m54so3140629yhm.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Mar 2012 15:12:28 -0700 (PDT)
In-Reply-To: <471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I did, but i didn't wanted to implement a queue, but just do what i
said directly !

Em 23 de mar=E7o de 2012 19:11, Jeff Haran <jharan@bytemobile.com> escr=
eveu:
>> -----Original Message-----
>> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
>> owner@vger.kernel.org] On Behalf Of Fr3DBr
>> Sent: Friday, March 23, 2012 2:59 PM
>> To: netfilter-devel@vger.kernel.org
>> Subject: Netfilter Packet Reinjection
>>
>> Hello,
>>
>> I'm writting a module to deal with certain packets, and i wanted to
>> DROP then initially, store it, and at an later moment, reinject it
>> before the routing decision.
>>
>> What would be the method i could call, to place the packet again in
>> the stack at this point ?!
>>
>> Thanks,
>>
>> Fred
>
> You probably want to take a look at nf_reinject() in net/netfilter/nf=
_queue.c.
>
> Jeff Haran
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
