From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Wed, 28 Jan 2004 14:22:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4017B78B.3050201@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Willy Tarreau <willy@w.ods.org>,
 Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040128103000.GP11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Wed, Jan 28, 2004 at 09:49:56AM +0100, Patrick McHardy wrote:
> 
>>I see two problems with this approach. The dummy devices don't have
>>any ip config, so f.e. REDIRECT will fail. 
> 
> 
> Ok, let's ignore that for now.  dunno if the dummydev idea was so good
> at all.

I believe we pass the real device and provide a new match.
The real device might be interesting for filtering, too.
But as you say, let's ignore it for now.


>>The bigger problem is hooking in output routines that return
>>NET_XMIT_BYPASS. dst_output loops until the return code of
>>skb->dst->output != NET_XMIT_BYPASS.  These output routines replace
>>skb->dst when finished by calling dst_pop.
>>
>>If we pass the packet through netfilter in between, the dst_entry
>>might get replaced in ip_route_me_harder or elsewhere and not all
>>transformations will be applied. 
> 
> 
> I see.   So we would have to modify all code that changes skb->dst to
> check if there is a dst stack.  If yes, it would have to iterate over
> all of them and just change the last one.  Shouldn't be too hard to
> intergrate that change.

> However, it is hard to tell what is the correct behaviour in that case.
> 
> In POST_ROUTING of the original, unencapsulated packet, I would say it
> is correct to not apply those transformations, in case rerouting of the
> packet occurs.  If somebody reroutes here, he wants to affect the
> original packet, not the encapsulated one.

Agreed. The problem is outfn is already set to {ah,esp}_output when
POST_ROUTING of the original packet is called, we need to handle this
somehow.

We also should handle the opposite case, after a (normal) packet is
SNATed ip_route_me_harder will replace the dst_entry, the new one might
include ipsec transformations if a policy for the now-different packet
exists, but the packet is always passed to ip_finish_output2. If we
would call dst_output instead strange hook orders can occur:
  PRE_ROUTING FORWARD POST_ROUTING <SNAT, encapsulate>
   POST_ROUTING LOCAL_OUT <SNAT again ;)> ..
I can't imagine a good solution right now.


> However, once we did do the first encapsulation, it doesn't make sense
> to encapsulate further layers until we've reached the real dst.  At this
> point, LOCAL_OUT would be called with the heading-for-the-wire packet
> and rerouting will and should affect the final device.

I'm not sure if you understand you correctly. Do you mean to say that it
doesn't make sense to pass packets to netfilter hooks until all 
transformations have been applied ? If so, I agree, I don't think there
is much use in doing stuff to half-done packets. We can easily detect
the final dst_entry, it should have dst->xfrm = NULL (at least I would
think so). But I don't know how to skip intermediate ones, I guess
they look similar to the first one.

> 
> However, exposing all those intermediate steps to the
> netfilter-hook-attached code is not so bad.  It enables people to do
> whatever they want... they just need to be careful with their rules.
> If there's too much interference with normal OUTPUT/POSTROUTING rules,
> we could still go for new hooks+new chains.

This makes me think I misunderstood your statement above. I recall there
was some confusion between hook functions and hooks before, it seems
I got me, too ;) Do you propose to make these steps visible to iptables
chains or just to the registered hook functions, which would hide them
from the user by immediately returning in the iptables case ?


> 
> 
>>If NAT is used, ip_route_{input,output} might even return a different
>>policy bundle.
> 
> 
> The question is, again: What ist the desired behaviour?  Should the
> policy be determined on the un-NAT'ed packet or on the NAT'ed one?

The NATed one. When the policy says encrypt 10.0.0.1<->10.0.0.2, NAT
should bypass that. IIRC Herbert Xu mentioned some things about when
policy checks need to be done in the "2.6 IPSEC + SNAT" thread. I'm
going to read it again later.


>>Regards,
>>Patrick
> 
> 
