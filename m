From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 18:19:35 +0000 (GMT)
Message-ID: <alpine.DEB.2.02.1211121805330.23195@lap-x201>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201>
 <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:60406 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2KLSTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:19:43 -0500
In-Reply-To: <alpine.DEB.2.00.1211121740100.18435@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, 12 Nov 2012, Jozsef Kadlecsik wrote:

>>>> But I'm sorry that you won't consider having a flag that changes 
>>>> MASQUERADE's behaviour to automatically change the source address in 
>>>> the conntrack entry.
>>>
>>> I don't think changing the source address were a good solution: if 
>>> MASQUERADE could be changed to handle the cases then the wrong 
>>> conntrack entries should be deleted.

I'm not quite sure what you mean here. Are you saying that "invalid 
conntrack entries should be detected and deleted" or "changing MASQUERADE 
is pointless because if it would just delete conntrack entries that should 
not be deleted"?

>>> But what would trigger the action? (Routing changed? I do not see such 
>>> a kernel event but I might missed it.) And more importantly, what 
>>> would identify the affected entries?
[...]
> An in-kernel "route changed" notification were great, because then we 
> could delete all MASQUERAD-ed entries where --update-source-address flag 
> is set.

If we could register to receive routing changed events for SNAT source 
addresses, that would be great (more efficient) but if the mechanism does 
not yet exist, it would be much more difficult to create.

I suppose that if we just deleted them all on any routing change, then 
that would solve the immediate problem for us. It would be ideal if 
incoming packets could still be directed to the correct internal source, 
but dropping them is a smaller problem than continuing to send out invalid 
packets and keeping a broken entry alive forever.

>> I propose that:
>>
>> * when the packet matches an existing conntrack rule, and
>>
>> * is sent out of an interface that does not list the packet's new (SNAT-to)
>> source address as one of its IP addresses (i.e. if this were a new
>> connection, MASQUERADE would not choose this source address), and
>
> First, it'd mean a heavy checking for every matched packet.

Is it really so expensive to get the list of IP addresses for an interface 
and check down the list for presence of a given address? If so, perhaps 
that's a problem elsewhere in the kernel?

> Second, there's no callback, whatsoever in the netfilter conntrack
> framework which could execute this instruction set. And if such an
> internal hook were added, that'd mean an unnecessary "check the hook and
> call if exists" overhead for *every* other case.

Another option is to check, after routing, the source address that 
MASQUERADE would have assigned to the packet. There must be a mechanism 
for that, because we already do it for the first packet in the connection, 
and it surely cannot be expensive. If it's different to the current 
SNAT-to address in the conntrack, and the flag is set on the conntrack, 
then update the conntrack.

>> * the --update-source-address flag is set on the MASQUERADE target
>>
>> then update the source address on the conntrack rule to the new one.
>
> Why do you insist on updating the source address?

In these cases, the original source address is no longer valid. If we 
delete the conntrack, we will just end up creating a new one for the same 
packet. That results in more overhead and higher churn in the conntrack 
table, but admittedly since the source address has changed, we should 
probably treat the conntrack as UNREPLIED anyway, i.e. more like a new 
fresh conntrack.

Perhaps if we were to leave the old conntrack alone and just create a new 
one, then packets arriving from the peer destined to the old source 
address would still end up being forwarded to the local device, which 
could help to keep any existing connections kind-of alive (that might be 
seen as a bad thing as well).

> Should the --update-source-address be limited to UDP only?

I think the problem applies even more to portless protocols such as GRE. 
Devices have no choice to "change the source port" when making a new 
connection. Any packets that they send, will definitely keep a stale entry 
alive.

Thank you for considering and engaging with this proposal :)

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 967 838
Future Business, Cam City FC, Milton Rd, Cambridge, CB4 1UY, UK

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

