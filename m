From: "Jeff Haran" <jharan@bytemobile.com>
Subject: RE: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 15:12:47 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A7028D1CDC@hq-exchange01.bytemobile.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr><4E1F1902.9020605@student.ulg.ac.be><alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net> <6F5DE7538AFCDA45A114F5E7510424A7028D1BBE@hq-exchange01.bytemobile.com> <4E1FA5F9.3040006@nostrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "David Miller" <davem@davemloft.net>, <jengelh@medozas.de>,
	<T.Moes@student.ulg.ac.be>, <netfilter-devel@vger.kernel.org>
To: "Adam Roach" <adam@nostrum.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:12444 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1GOWNI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:13:08 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4E1FA5F9.3040006@nostrum.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Adam Roach [mailto:adam@nostrum.com]
> Sent: Thursday, July 14, 2011 7:29 PM
> To: Jeff Haran
> Cc: David Miller; jengelh@medozas.de; T.Moes@student.ulg.ac.be;
netfilter-
> devel@vger.kernel.org
> Subject: Re: NAT66 : A first implementation
> 
...
> So, really, before we do the whole "NATS BAD!" dogpile again, I'd
> encourage people take an unprejudiced look at the technique described
in
> RFC 6296. There may actually be a place for NPTv6 in netfilter after
all.

I was unaware of the RFC. Thanks for the reference, however I have to
point out the following quote from its introduction:

"For reasons discussed in [RFC2993] and Section 5, the IETF does not
recommend the use of Network Address Translation technology for IPv6."

I'm not saying nobody is going to use IPv6 NAT nor that the Linux world
should somehow make it hard on them to do so. There may be a few cases
where it makes sense.

All I am saying is I think most will come to the conclusion that the
benefits they get from it will not compensate for the hassle of dealing
with it. And lacking popularity, many of the hassles will go
unaddressed, further encouraging users to not use it. With IPv4, NAT
quickly became a necessity because of the lack of address space. If your
application or device broke IPv4 NAT, you had a lot of incentive to
change it so it worked with NAT. I think it is unlikely that the same
incentives will come into play with any form of IPv6 NAT.



