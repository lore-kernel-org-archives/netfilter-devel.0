From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Fri, 23 Jul 2004 02:06:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41005697.9060807@trash.net>
References: <Pine.LNX.4.44.0407141656420.17283-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephen Frost <sfrost@snowman.net>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407141656420.17283-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Wed, 14 Jul 2004, Patrick McHardy wrote:
> 
> 
>>It can be done easily, when the packets hit netfilter decapsulation is
>>already done, we just need to add a call to xfrm4_policy_check().
>>The drawback is that policy checks would be performed twice on valid
>>packets.
> 
> 
> Two question here:
> 
> a) Can the raw table be used for enforcing ipsec flow policies without 
> disturbing conntrack, like it can for normal traffic?

You mean by calling xfrm4_policy_check from a new target ? Yes.

> b) If you check policies with xfrm4_policy_check() before conntrack with
> the purpose of avoiding disturbing conntrack you better do so on all
> incoming traffic, not only ipsec decapsulated traffic.. If not you have a 
> noticeable asymmetry in that illegal decapsulated traffic over ipsec is 
> handled correctly but unencrypted packets still crashes conntrack.

Sure, everything needs to be checked.

> Maybe there is room for a skb flag indicating the policy check has already
> been passed? If so it should be possible to switch the ipsec policy check
> to prerouting relatively easily when needed?

We could do that, but all other places are coded to avoid duplicate
policy checks, so I'm unsure if Dave will accept it. But I'm going to
try at least ;)

> But seriously speaking I think conntrack may need to be split in two for
> this to work properly: prerouting to associate packet with connection for
> filtering purposes, postrouting & local_in to update the conntrack state,
> windows etc. Until this is done it is in my opinion just as good to simply
> refer to the raw table for anti-spoof filtering as other solutions will 
> still only be partial and only protect from what is already reasonably 
> well protected.

I've thought about this, but I can't imagine how it would work, you
have to deal with all kinds of races ..

Regards
Patrick

> 
> Regards
> Henrik
> 
