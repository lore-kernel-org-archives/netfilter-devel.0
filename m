From: Jeff Haran <jharan@bytemobile.com>
Subject: RE: Netfilter Packet Reinjection
Date: Fri, 23 Mar 2012 22:20:57 +0000
Message-ID: <471DE477E2B1F549A58F3A14A27180BE014CD8@HQ-EX01.bytemobile.com>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
	<471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
 <CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fr3DBr <fr3dbr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:20035 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2CWWVS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:21:18 -0400
In-Reply-To: <CAMpo4z0gLyYa6xnZHYSz8Z4q98aan_uv_z73o4Wwc0UV=5m2Lg@mail.gmail.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> Em 23 de mar=E7o de 2012 19:11, Jeff Haran <jharan@bytemobile.com>
> escreveu:
> >> -----Original Message-----
> >> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-deve=
l-
> >> owner@vger.kernel.org] On Behalf Of Fr3DBr
> >> Sent: Friday, March 23, 2012 2:59 PM
> >> To: netfilter-devel@vger.kernel.org
> >> Subject: Netfilter Packet Reinjection
> >>
> >> Hello,
> >>
> >> I'm writting a module to deal with certain packets, and i wanted t=
o
> >> DROP then initially, store it, and at an later moment, reinject it
> >> before the routing decision.
> >>
> >> What would be the method i could call, to place the packet again i=
n
> >> the stack at this point ?!
> >>
> >> Thanks,
> >>
> >> Fred
> >
> > You probably want to take a look at nf_reinject() in
> net/netfilter/nf_queue.c.
> >
> > Jeff Haran
> From: Fr3DBr [mailto:fr3dbr@gmail.com]
> Sent: Friday, March 23, 2012 3:12 PM
> To: Jeff Haran
> Cc: netfilter-devel@vger.kernel.org
> Subject: Re: Netfilter Packet Reinjection
> I did, but i didn't wanted to implement a queue, but just do what i
> said directly !
>

=46ixing the top post.

I assume by "I didn't wanted to implement a queue", you meant you didn'=
t want to use an NF_QUEUE to put the packets to user space.

=46ine. Nobody said you had to use a user space queue. But if you want =
to hang onto packets for later re-injection, calling nf_reinject() is o=
ne way to do it.




--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
