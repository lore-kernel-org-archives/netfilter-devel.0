From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Wed, 14 Jul 2004 17:05:08 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407141656420.17283-100000@filer.marasystems.com>
References: <40F52655.8040608@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Stephen Frost <sfrost@snowman.net>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40F52655.8040608@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Jul 2004, Patrick McHardy wrote:

> It can be done easily, when the packets hit netfilter decapsulation is
> already done, we just need to add a call to xfrm4_policy_check().
> The drawback is that policy checks would be performed twice on valid
> packets.

Two question here:

a) Can the raw table be used for enforcing ipsec flow policies without 
disturbing conntrack, like it can for normal traffic?

b) If you check policies with xfrm4_policy_check() before conntrack with
the purpose of avoiding disturbing conntrack you better do so on all
incoming traffic, not only ipsec decapsulated traffic.. If not you have a 
noticeable asymmetry in that illegal decapsulated traffic over ipsec is 
handled correctly but unencrypted packets still crashes conntrack.

Maybe there is room for a skb flag indicating the policy check has already
been passed? If so it should be possible to switch the ipsec policy check
to prerouting relatively easily when needed?

But seriously speaking I think conntrack may need to be split in two for
this to work properly: prerouting to associate packet with connection for
filtering purposes, postrouting & local_in to update the conntrack state,
windows etc. Until this is done it is in my opinion just as good to simply
refer to the raw table for anti-spoof filtering as other solutions will 
still only be partial and only protect from what is already reasonably 
well protected.

Regards
Henrik
