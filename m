From: Chris Wilson <chris@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Thu, 8 Nov 2012 18:37:24 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1879368401-1352399846=:5637"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:47649 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab2KHSg4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2012 13:36:56 -0500
In-Reply-To: <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1879368401-1352399846=:5637
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Jan,

On Thu, 8 Nov 2012, Jan Engelhardt wrote:
> On Thursday 2012-11-08 17:35, Chris Wilson wrote:
>>
>> Summary: UDP devices (e.g. SIP phones) that don't change their source port,
>> behind NAT, when routing to their destination changes, keep a conntrack entry
>> valid which contains the old (wrong) SNAT-to address
>
> Actually, not {changing the tuple and thus breaking at least
> stream-type connections} could be considered a feature, for example
> when you migrate off a certain address and onto a new one.

OK, I can see that, but in this case it results in pretty broken 
behaviour, which users (other than me) are encountering in practice.

> You can remove "old" NFCT entries by use of conntrack(8) if you the time 
> between preferred_lft and valid_lft running out is too short.

Unfortunately I don't think conntrack works on the CentOS 5 kernel 
(2.6.18). Perhaps it's just too old, but it's widely used, and other 2.6.x 
kernels are widely used on routers too.

I know that fixing/changing this behaviour would also require a kernel 
upgrade, but I'd prefer that at some point as users are upgraded to newer 
kernels, this bug stops affecting them.

I'd also prefer a more automatic solution than manually removing entries 
from the conntrack table.

>> Another option which doesn't violate layering might be to update the 
>> NAT rule when the outgoing address is known (after routing),
>
> That is what MASQUERADE is usually for.

Unfortunately I am using MASQUERADE and this still happens. If it could 
just be fixed in the MASQUERADE target that would be a big win.

>> Another option might be to remember the destination interface as part 
>> of the conntrack entry, and continue to send matching packets out of 
>> that interface even if the routing changes. [...]
>
> Consider this 2×2 event matrix (giving 4 cases a packet can end up
> in):
>
>  route out on {A, B} × use outgoing address {A, B}
>
> It is certainly possible that a customer may be multi-linked (2 or
> more ISPs), and each ISP accepting traffic from/to his multi-home (1
> or more subnets), whilst he is doing round-robin loadbalancing.

It is possible, especially in the round-robin case, but that is probably 
less often used than the simple failover case, because so few ISPs will 
allow you to do this, for spoofing prevention reasons. Also it's not much 
of a failover system if the backup route uses the same ISP as the main 
route.

Considing both cases where users with failover and load balancing, and 
considering whether they use use the same ISP for both connections AND the 
ISP supports spoofing the source address, or not, I'd guess that the first 
case (same ISP and spoofing works) is less likely than the second, but I 
don't have evidence to back it up.

> An operating system can therefore never automatically know whether
> it is ok to continue using certain tuples over a link or not, unless
> the user intervenes in some way.

I think it would rarely be acceptable to send a packet out of the wrong 
interface that doesn't match the source address (AB and BA in your 
matrix). Perhaps in that case we could require an extra flag to 
MASQUERADE?

Even a default-off MASQUERADE flag that says "--update-source-address" 
would give us the option to have this fixed automatically, provided that 
people know about the flag and use it.

The only alternative currently (when the device uses fixed source ports 
and the router doesn't support conntrack(8)) is to poll the device's web 
interface, check whether it's offline, and if so manually tweak its source 
port. That seems more hacky.

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

--8323329-1879368401-1352399846=:5637--
