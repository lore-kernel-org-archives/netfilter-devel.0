From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Wed, 14 Jul 2004 14:25:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40F52655.8040608@trash.net>
References: <Pine.LNX.4.44.0407140528420.12284-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephen Frost <sfrost@snowman.net>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407140528420.12284-100000@filer.marasystems.com>
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
> 
> This general problem of conntrack when applying policies on packets
> flows.. Spoofed packets arriving from an untrusted source will disrupt
> conntrack states unless filtering is applied before conntrack.
> 
> In normal traffic this can be solved by using the raw table to enforce the
> anti-spoof policy by dropping illegal traffic flows before seen by
> conntrack.  I suppose something similar could be done with ipsec traffic?

Yes.

> It would obviously be very nice for conntrack if the ipsec policy checks
> could be applied in prerouting before conntrack, but I am not sure how
> feasible this is.. It is not exacly a natural point for ipsec to apply 
> policy checks in prerouting..

It can be done easily, when the packets hit netfilter decapsulation is
already done, we just need to add a call to xfrm4_policy_check().
The drawback is that policy checks would be performed twice on valid
packets.

Regards
Patrick
