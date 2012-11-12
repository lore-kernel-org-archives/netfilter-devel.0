From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 15:27:08 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211121523190.23195@lap-x201>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:59912 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2KLP12 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:27:28 -0500
In-Reply-To: <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:

>>> I do not see any simple solution except to delete any NATed entry
>>> unconditionally when the routing changes. But that can easily be too much
>>> and may kill valid entries.
>>
>> But I'm sorry that you won't consider having a flag that changes
>> MASQUERADE's behaviour to automatically change the source address in the
>> conntrack entry.
>
> I don't think changing the source address were a good solution: if
> MASQUERADE could be changed to handle the cases then the wrong conntrack
> entries should be deleted.
>
> But what would trigger the action? (Routing changed? I do not see such a
> kernel event but I might missed it.) And more importantly, what would
> identify the affected entries?
>
> I do not see any good answer to those questions.

I propose that:

* when the packet matches an existing conntrack rule, and

* is sent out of an interface that does not list the packet's new (SNAT-to) 
source address as one of its IP addresses (i.e. if this were a new 
connection, MASQUERADE would not choose this source address), and

* the --update-source-address flag is set on the MASQUERADE target

then update the source address on the conntrack rule to the new one.

That's the same thing that would happen if we deleted the conntrack entry 
first: MASQUERADE would choose a new source address and save it in the new 
conntrack entry.

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

