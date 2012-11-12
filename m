From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 20:56:39 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.1211122014550.4432@chris-desktop.fen.aptivate.org>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201> <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
 <alpine.DEB.2.02.1211121805330.23195@lap-x201> <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Chris Wilson <chris-netfilter-110904@aptivate.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:60782 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab2KLU5n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:57:43 -0500
In-Reply-To: <alpine.DEB.2.00.1211121940290.18729@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:

>>>> * is sent out of an interface that does not list the packet's new
>>>> (SNAT-to)
>>>> source address as one of its IP addresses (i.e. if this were a new
>>>> connection, MASQUERADE would not choose this source address), and
>>>
>>> First, it'd mean a heavy checking for every matched packet.
>>
>> Is it really so expensive to get the list of IP addresses for an interface
>> and check down the list for presence of a given address?
>
> That'd mean that for *every* packet first the next routing hop should be
> calculated in netfilter too

Why "too"? Doesn't the kernel do that already? Why not use the results of 
the kernel's decision?

> then an IP address of the interface selected and then the old and the 
> calculated addresses compared. For every packet, unconditionally, that's 
> simply too much overhead.

This only needs to be done if the packet hits a conntrack with 
--update-source-address. And looking down the list of IP addresses of the 
interface in that case doesn't seem too bad. But I'm willing to concede on 
it.

>> If so, perhaps that's a problem elsewhere in the kernel?
>
> No, it's netfilter specific.

I mean, it shouldn't be hard (or expensive) to get a list of IP addresses 
for an interface, and it shouldn't be hard to check whether a given IP is 
in that list. If it is, then it seems to me that something must be broken. 
But I don't want to have a fight over it.

>> Another option is to check, after routing, the source address that 
>> MASQUERADE would have assigned to the packet. There must be a mechanism 
>> for that, because we already do it for the first packet in the 
>> connection, and it surely cannot be expensive. If it's different to the 
>> current SNAT-to address in the conntrack, and the flag is set on the 
>> conntrack, then update the conntrack.
>
> The first packets are special: the (NAT) rules are evaluated for the 
> very first packets only. Subsequent ones are looked up in the conntrack 
> table and the nat table is completely skipped. As I wrote, there's no 
> callback/hook by which such a functionality for MASQUERADE could be 
> called.

That doesn't mean that it's expensive, just that we don't do it at the 
moment. And the mangle table is called for every packet, so netfilter 
already does some work for every packet.

> Also, SNAT/MASQUERADE is the very last action in netfilter.

Sorry, but why does that make a difference?

> My concern is that there can for example be conntrack extensions attached
> to the conntrack entry, which may became broken if the IP address was
> simply changed.

Good point, I didn't realise that.

>> I think the problem applies even more to portless protocols such as 
>> GRE. Devices have no choice to "change the source port" when making a 
>> new connection. Any packets that they send, will definitely keep a 
>> stale entry alive.
>>
>> Thank you for considering and engaging with this proposal :)
>
> It's an issue, which should be solved in MASQUERADE itself. The 
> conntrack tool can be used to solve it, in theory. In practice it's not 
> easy at all: a daemon should be run on the machine which catches the 
> routing changes and then calls "conntrack".

Agreed :)

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

