From: Patrick McHardy <kaber@trash.net>
Subject: Re: Google SoC, Optimized netfilter implementation
Date: Fri, 03 Apr 2009 15:47:40 +0200
Message-ID: <49D6137C.5030205@trash.net>
References: <daf8006b0903311912g2c83d221w68197954d1e08d0d@mail.gmail.com> <878wmikqw8.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Shreyas Bhatewara <shreyas.bhatewara@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48125 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZDCNrq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:47:46 -0400
In-Reply-To: <878wmikqw8.fsf@basil.nowhere.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andi Kleen wrote:
> Shreyas Bhatewara <shreyas.bhatewara@gmail.com> writes:
>> I am composing a proposal for this project to be submitted at Google
>> SoC. Could anyone brief me about what you mean by "dynamic code
>> generation" (https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#Optimized_netfilter_implementation).
> 
> 
> I believe it refers to generate machine code for firewall rules.
> So instead of interpreting a data structure the dynamically generated
> code would just check the rules directly.
> 
> This was done by some kernels before, e.g. OSF/Mach had code to compile
> BPF rules into machine code.
> 
> Doing something like this would be likely interesting, but I expect
> it would be far too much general work for a single SoC. So if you wanted
> to do anything like that you would need to select a very narrow doable
> subset.

Thomas Graf presented something similar for TC at netconf 2005.
But I'm not sure whether it was ever released.

But I'm not so sure about the benefits. Sure, you can generate
optimized code for the simple cases (lets say, TCP port comparison).
But the impact how much you can gain from this is quite limited
I'd expect, for large rulesets algorithmic improvements have a
much larger potential. Something like hipac should not have to
look at the key for each dimension (port number, address etc.)
more than once, so it pretty much doesn't matter how well optimized
that code is.
