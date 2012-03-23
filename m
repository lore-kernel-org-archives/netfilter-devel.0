From: Jeff Haran <jharan@bytemobile.com>
Subject: RE: Netfilter Packet Reinjection
Date: Fri, 23 Mar 2012 22:11:39 +0000
Message-ID: <471DE477E2B1F549A58F3A14A27180BE014CC0@HQ-EX01.bytemobile.com>
References: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Fr3DBr <fr3dbr@gmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:6314 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2CWWVI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:21:08 -0400
In-Reply-To: <CAMpo4z2HumFBL+xNWPKbJiUancfraKT2_+u=fqkzSOX-74t8jg@mail.gmail.com>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
> owner@vger.kernel.org] On Behalf Of Fr3DBr
> Sent: Friday, March 23, 2012 2:59 PM
> To: netfilter-devel@vger.kernel.org
> Subject: Netfilter Packet Reinjection
> 
> Hello,
> 
> I'm writting a module to deal with certain packets, and i wanted to
> DROP then initially, store it, and at an later moment, reinject it
> before the routing decision.
> 
> What would be the method i could call, to place the packet again in
> the stack at this point ?!
> 
> Thanks,
> 
> Fred

You probably want to take a look at nf_reinject() in net/netfilter/nf_queue.c.

Jeff Haran



