From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 10:24:13 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211121019280.23195@lap-x201>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:59216 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2KLLHd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:07:33 -0500
Received: from 82-68-244-70.dsl.in-addr.zen.co.uk ([82.68.244.70] helo=lap-x201.local)
	by one-mail.aptivate.org with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80.1)
	(envelope-from <chris-netfilter-110904@aptivate.org>)
	id 1TXrBe-0005Zx-Jh
	for netfilter-devel@vger.kernel.org; Mon, 12 Nov 2012 10:24:14 +0000
In-Reply-To: <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Joszef,

On Sat, 10 Nov 2012, Jozsef Kadlecsik wrote:

> But the thread is drifted from the original cases:
>
>> This only seems to happen when you're using a UDP device behind a Linux
>> NAT router, and your routing to the destination host changes, because:
>>
>> * You bring up a VPN tunnel and the SIP destination is at the other end
>> of that tunnel; or
>
> This case is not handled by MASQUERADE.
>
>> * Your default route changes because you failover to another provider.
>
> And this case is also not handled if the original default route device is
> still healthy, that is for example when you use some dynamic routing
> protocol which detects failure in the routing path.

Not necessarily dynamic routing. Even using pppd (pppoa/pppoe) for one 
connection and ethernet for the other can cause this problem. Any case 
that changes routing without bringing down the old device can be affected.

I'm glad you agree that these are actual problems or limitations with 
MASQUERADE.

> I do not see any simple solution except to delete any NATed entry
> unconditionally when the routing changes. But that can easily be too much
> and may kill valid entries.

But I'm sorry that you won't consider having a flag that changes 
MASQUERADE's behaviour to automatically change the source address in the 
conntrack entry.

Is that because you think it's impossible or infeasible to get access to 
the right information at the right time? Or some other reason?

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

