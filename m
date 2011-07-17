From: Ed W <lists@wildgooses.com>
Subject: Re: NAT66 : A first implementation
Date: Sun, 17 Jul 2011 23:23:05 +0100
Message-ID: <4E2360C9.20304@wildgooses.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net> <alpine.LNX.2.01.1107150151390.20658@frira.zrqbmnf.qr> <4E226E7D.6050800@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?S3J6eXN6dG9mIE9sxJlkemtp?= <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:38172 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1GQWaU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2011 18:30:20 -0400
In-Reply-To: <4E226E7D.6050800@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

> How would you imagine managing and maintaining a typical corporate
> network (1K+ devices) of different devices and operating systems -
> workstations (Windows, Mac, Linux), servers (Windows, Linux, BSD)
> routers, switches (radius), firewalls, APs, etc; without static IP
> addresses? Static = not random.

I agree.  Can't see how you would (unless dynamic DNS started to work a
whole lot better than today...)


> Also, how would you imagine readressing such network one day, when you
> decide to change your ISP?

Aha.  This is a statement that you don't believe PI space will become
easier to access when requesting IPV6 space?

There seems to be sufficient space for PI to become the norm to hand
out.  However, the current state of routing appears to struggle with
IPV4 taken to the limit, and so there seems to be understandable
reluctance to actually fix all the issues we have with IPV4 since some
facets of the solution kill current routing hardware..?

Mobile phone numbers are now interchangeable between phone companies in
under 24 hours in the UK.  Lets hope that PI space allocations become
the norm under IPv6..?


> Without NAT (and BTW without working and complete L3 security in
> switches) no one will consider IPv6 seriously nor dare to implement it
> in production. Of course NAT does not provide security but it provides a
> real and useful privacy, opposite to annoying randomness.

It's not clear to me that NAT solves L3 security any better than a
non-nat firewall?  "Security" through NAT is largely through breaking
routing, but a non NAT firewall appears to achieve entirely the same
effect more directly (some would argue much better in fact)


I personally think that IPV6 NAT could be very useful for a number of
niche situations!  Please lets see this get implemented!

On the other hand I hope that widespread adoption doesn't happen...
Instead I hope that PI allocations become straightforward and the norm.
I would also disagree with some of the reasons *why* you want NAT,
although at the limit I would still agree NAT is useful for some
situations (just different situations)

Cheers

Ed W
