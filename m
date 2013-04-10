From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: documentation bug: missing nat targets in man
Date: Wed, 10 Apr 2013 14:53:52 +0200
Message-ID: <516560E0.6000605@chello.at>
References: <5163E3BE.3040609@chello.at> <20130409095448.GD26170@macbook.localnet> <5163FE28.3020604@chello.at> <20130410112623.GB21728@macbook.localnet>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep18.mx.upcmail.net ([62.179.121.38]:62379 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3DJMyl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:54:41 -0400
In-Reply-To: <20130410112623.GB21728@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.04.2013 13:26, Patrick McHardy wrote:
> On Tue, Apr 09, 2013 at 01:40:24PM +0200, Mart Frauenlob wrote:
>> On 09.04.2013 11:54, Patrick McHardy wrote:
>>> On Tue, Apr 09, 2013 at 11:47:42AM +0200, Mart Frauenlob wrote:
>>>> Hello,
>>>>
>>>> I noticed there's quite new DNAT, SNAT, NETMAP support for
>>>> ip6tables, but that information is missing in the man page.
>>>> Anything else needed than just copying the according ipv4 *.man files?
>>>> If so, want me do prepare a patch?
>>>
>>> I guess you can rename the ipv4 specific man files to xt_... and
>>> update them accordingly, the modules should behave similar to their
>>> IPv4 counterparts.
>>>
>>
>> Ok, here it is.
>> I slightly modified the text in regards to sentence structure.
>> Removed the references to older kernels, as this does not apply to
>> the new ipv6 version.
>> Added the list of valid protocols, which again - for me leaves the
>> question about -p icmp open (re other mail).

[...]
>> ---
>>   extensions/libip6t_DNAT.man   |   30 ++++++++++++++++++++++++++++++
>>   extensions/libip6t_NETMAP.man |    9 +++++++++
>>   extensions/libip6t_SNAT.man   |   28 ++++++++++++++++++++++++++++
>>   3 files changed, 67 insertions(+), 0 deletions(-)
>>   create mode 100644 extensions/libip6t_DNAT.man
>>   create mode 100644 extensions/libip6t_NETMAP.man
>>   create mode 100644 extensions/libip6t_SNAT.man
>
> Well, my suggestion was to add one manpage which covers both the IPv4
> and IPv6 targets since they're pretty much identical. I think just
> adding a libxt_DNAT.man etc. should work.

I've not yet tried to figure out where and what code is responsible for 
assembling all the *.man files together, but from what I see as the 
result and from what is there, like the LOG or MASQUERADE target are 
split up that way, actually producing redundant sections. Thats why I 
thought thats the way to go. Will try the libxt_*.man way...


As there's redundant stuff, I can also prepare patches to join that 
together. Wanted?

What about the -p icmp part?

Best regards

Mart

